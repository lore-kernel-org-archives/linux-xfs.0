Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA57C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23BA32071F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLBVvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:51:19 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55381 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfLBVvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 16:51:19 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 45E7E7EB461;
        Tue,  3 Dec 2019 08:51:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ibtb7-0006FA-DY; Tue, 03 Dec 2019 08:51:13 +1100
Date:   Tue, 3 Dec 2019 08:51:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191202215113.GH2695@dread.disaster.area>
References: <20191126202714.GA667580@vader>
 <20191127003426.GP6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127003426.GP6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=yPCof4ZbAAAA:8 a=-uoBkjAQAAAA:8 a=7-415B0cAAAA:8 a=vsmucVbB2X2MFuJy6fQA:9
        a=hq3SDExIU25eL7r0:21 a=PcRFrYjCTpupJN_V:21 a=CjuIK1q_8ugA:10
        a=y0wLjPFBLyexm0soFTcm:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 04:34:26PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> > Hello,
> > 
> > The following reproducer results in a transaction log overrun warning
> > for me:
> > 
> >   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> >   mount -o rtdev=/dev/vdc /dev/vdb /mnt
> >   fallocate -l 4G /mnt/foo
> > 
> > I've attached the full dmesg output. My guess at the problem is that the
> > tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> > bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> > this filesystem, which I do see in some of the log items). However, I'm not
> > familiar enough with the XFS transaction guts to confidently fix this. Can
> > someone please help me out?
> 
> Hmm...
> 
> /*
>  * In a write transaction we can allocate a maximum of 2
>  * extents.  This gives:
>  *    the inode getting the new extents: inode size
>  *    the inode's bmap btree: max depth * block size
>  *    the agfs of the ags from which the extents are allocated: 2 * sector
>  *    the superblock free block counter: sector size
>  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
>  * And the bmap_finish transaction can free bmap blocks in a join:
>  *    the agfs of the ags containing the blocks: 2 * sector size
>  *    the agfls of the ags containing the blocks: 2 * sector size
>  *    the super block free block counter: sector size
>  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
>  */
> STATIC uint
> xfs_calc_write_reservation(...);
> 
> So this means that the rt allocator can burn through at most ...
> 1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
> ... worth of log reservation as part of setting bits in the rtbitmap and
> fiddling with the rtsummary information.
> 
> Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
> is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
> reservation.

Ok, if that's the case, we still need to be able to allocate MAXEXTLEN in
a single transaction. That's 2^21 filesystem blocks, which at most
is 2^21 rtexts.

Hence I think we probably should have a separate rt-write
reservation that handles this case, and we use that for allocation
on rt devices rather than the bt-based allocation reservation.


> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs: cap realtime allocation length to something we can log
> 
> Omar Sandoval reported that a 4G fallocate on the realtime device causes
> filesystem shutdowns due to a log reservation overflow that happens when
> we log the rtbitmap updates.
> 
> The tr_write transaction reserves enough log reservation to handle a
> full splits of both free space btrees, so cap the rt allocation at that
> number of bits.
> 
> "The following reproducer results in a transaction log overrun warning
> for me:
> 
>     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
>     mount -o rtdev=/dev/vdc /dev/vdb /mnt
>     fallocate -l 4G /mnt/foo
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 49d7b530c8f7..15c4e2790de3 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -69,6 +69,26 @@ xfs_zero_extent(
>  }
>  
>  #ifdef CONFIG_XFS_RT
> +/*
> + * tr_write allows for one full split in the bnobt and cntbt to record the
> + * allocation, and that's how many bits of rtbitmap we can log to the
> + * transaction.  We leave one full block's worth of log space to handle the
> + * rtsummary update, though that's probably overkill.
> + */
> +static inline uint64_t
> +xfs_bmap_rtalloc_max(
> +	struct xfs_mount	*mp)
> +{
> +	uint64_t		max_rtbitmap;
> +
> +	max_rtbitmap = xfs_allocfree_log_count(mp, 1) - 1;
> +	max_rtbitmap *= XFS_FSB_TO_B(mp, 1);
> +	max_rtbitmap *= NBBY;
> +	max_rtbitmap *= mp->m_sb.sb_rextsize;

I can see how this works, but it strikes me as a bit of a hack. We
calculate the worst case reservations up front to avoid having to
play games like this in the code. Hence I think the correct thing to
do is fix the reservation to ensure we can do MAXEXTLEN allocations
without overruns...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
