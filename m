Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BF2C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12092207DD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfLCVbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 16:31:23 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33476 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfLCVbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 16:31:23 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0E28A7EAE8F;
        Wed,  4 Dec 2019 08:31:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1icFlN-0006BI-LU; Wed, 04 Dec 2019 08:31:17 +1100
Date:   Wed, 4 Dec 2019 08:31:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191203213117.GL2695@dread.disaster.area>
References: <20191126202714.GA667580@vader>
 <20191127003426.GP6219@magnolia>
 <20191202215113.GH2695@dread.disaster.area>
 <20191203024526.GF7339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203024526.GF7339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=tV9g-d8QZPGnlahnijgA:9 a=68aO4A7YNkZnsM2P:21
        a=tI9sk9djYAIJeE3u:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 06:45:26PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2019 at 08:51:13AM +1100, Dave Chinner wrote:
> > On Tue, Nov 26, 2019 at 04:34:26PM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> > > > Hello,
> > > > 
> > > > The following reproducer results in a transaction log overrun warning
> > > > for me:
> > > > 
> > > >   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> > > >   mount -o rtdev=/dev/vdc /dev/vdb /mnt
> > > >   fallocate -l 4G /mnt/foo
> > > > 
> > > > I've attached the full dmesg output. My guess at the problem is that the
> > > > tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> > > > bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> > > > this filesystem, which I do see in some of the log items). However, I'm not
> > > > familiar enough with the XFS transaction guts to confidently fix this. Can
> > > > someone please help me out?
> > > 
> > > Hmm...
> > > 
> > > /*
> > >  * In a write transaction we can allocate a maximum of 2
> > >  * extents.  This gives:
> > >  *    the inode getting the new extents: inode size
> > >  *    the inode's bmap btree: max depth * block size
> > >  *    the agfs of the ags from which the extents are allocated: 2 * sector
> > >  *    the superblock free block counter: sector size
> > >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > >  * And the bmap_finish transaction can free bmap blocks in a join:
> > >  *    the agfs of the ags containing the blocks: 2 * sector size
> > >  *    the agfls of the ags containing the blocks: 2 * sector size
> > >  *    the super block free block counter: sector size
> > >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > >  */
> > > STATIC uint
> > > xfs_calc_write_reservation(...);
> > > 
> > > So this means that the rt allocator can burn through at most ...
> > > 1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
> > > ... worth of log reservation as part of setting bits in the rtbitmap and
> > > fiddling with the rtsummary information.
> > > 
> > > Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
> > > is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
> > > reservation.
> > 
> > Ok, if that's the case, we still need to be able to allocate MAXEXTLEN in
> > a single transaction. That's 2^21 filesystem blocks, which at most
> > is 2^21 rtexts.
> > 
> > Hence I think we probably should have a separate rt-write
> > reservation that handles this case, and we use that for allocation
> > on rt devices rather than the bt-based allocation reservation.
> 
> 2^21 rtexts is ... 2^18 bytes worth of rtbitmap block, which implies a
> transaction reservation of around ... ~300K?  I guess I'll have to go
> play with xfs_db to see how small of a datadev you can make before that
> causes us to fail the minimum log size checks.

Keep in mind that rtextsz is often larger than a single filesystem
block, so the bitmap size rapidly reduces as rtextsz goes up.

> As you said on IRC, it probably won't affect /most/ setups... but I
> don't want to run around increasing support calls either.  Even if most
> distributors don't turn on rt support.

Sure, we can limit the size of the allocation based on the
transaction reservation limits, but I suspect this will only affect
filesystems with really, really small data devices that result in a
<10MB default log size. I don't think there is that many of these
around in production....

I'd prefer to fix the transaction size, and then if people start
reporting that the log size is too small, we can then
limit the extent size allocation and transaction reservation based
on the (tiny) log size we read out of the superblock...

Alternatively, we could implement log growing :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
