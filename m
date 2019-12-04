Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189EAC43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2BD8206DB
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AhvG+44r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfLDQdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 11:33:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38196 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfLDQdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 11:33:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GU7Y0172697;
        Wed, 4 Dec 2019 16:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=60Id3c8VbbUI9FKMpHc5MzOQARFYqlPKxApsRweppbI=;
 b=AhvG+44rQ80niLc/MgQqB8bVTuH/eDjBPa03deocNjEBda8SGj9uBRf8JjB/rm7tSVcf
 95Ng5PxEmMjNomsjDmfszSP9MhtScV9v2SCTeuWUANxAiiUY2FFv+XgYXhnlBwI+WnqA
 fJGsddu0esyBbXfmGRE5vYGBvBnUEZEV9w+FpMaBK31tTeEELuzUYJU+aySuZBrQq2iv
 mdo7HzZzvXU7+HnfhQfIUAY0DU190yEzLdlzNjnbzR73TaFwzrHQZRhNCQ17+wOpub66
 3vsW8ULPMmNRGoGZhH7aGlMRHKvUekzqXrlKH4WVnQPihHmfaei51SH9QMwpMKz/hGMT rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcqfgf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 16:33:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GO9w6003497;
        Wed, 4 Dec 2019 16:31:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wp17e8g9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 16:31:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB4GVdf0013761;
        Wed, 4 Dec 2019 16:31:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 08:31:39 -0800
Date:   Wed, 4 Dec 2019 08:31:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191204163136.GO7335@magnolia>
References: <20191126202714.GA667580@vader>
 <20191127003426.GP6219@magnolia>
 <20191202215113.GH2695@dread.disaster.area>
 <20191203024526.GF7339@magnolia>
 <20191203213117.GL2695@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203213117.GL2695@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 08:31:17AM +1100, Dave Chinner wrote:
> On Mon, Dec 02, 2019 at 06:45:26PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 03, 2019 at 08:51:13AM +1100, Dave Chinner wrote:
> > > On Tue, Nov 26, 2019 at 04:34:26PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> > > > > Hello,
> > > > > 
> > > > > The following reproducer results in a transaction log overrun warning
> > > > > for me:
> > > > > 
> > > > >   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> > > > >   mount -o rtdev=/dev/vdc /dev/vdb /mnt
> > > > >   fallocate -l 4G /mnt/foo
> > > > > 
> > > > > I've attached the full dmesg output. My guess at the problem is that the
> > > > > tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> > > > > bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> > > > > this filesystem, which I do see in some of the log items). However, I'm not
> > > > > familiar enough with the XFS transaction guts to confidently fix this. Can
> > > > > someone please help me out?
> > > > 
> > > > Hmm...
> > > > 
> > > > /*
> > > >  * In a write transaction we can allocate a maximum of 2
> > > >  * extents.  This gives:
> > > >  *    the inode getting the new extents: inode size
> > > >  *    the inode's bmap btree: max depth * block size
> > > >  *    the agfs of the ags from which the extents are allocated: 2 * sector
> > > >  *    the superblock free block counter: sector size
> > > >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > > >  * And the bmap_finish transaction can free bmap blocks in a join:
> > > >  *    the agfs of the ags containing the blocks: 2 * sector size
> > > >  *    the agfls of the ags containing the blocks: 2 * sector size
> > > >  *    the super block free block counter: sector size
> > > >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > > >  */
> > > > STATIC uint
> > > > xfs_calc_write_reservation(...);
> > > > 
> > > > So this means that the rt allocator can burn through at most ...
> > > > 1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
> > > > ... worth of log reservation as part of setting bits in the rtbitmap and
> > > > fiddling with the rtsummary information.
> > > > 
> > > > Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
> > > > is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
> > > > reservation.
> > > 
> > > Ok, if that's the case, we still need to be able to allocate MAXEXTLEN in
> > > a single transaction. That's 2^21 filesystem blocks, which at most
> > > is 2^21 rtexts.
> > > 
> > > Hence I think we probably should have a separate rt-write
> > > reservation that handles this case, and we use that for allocation
> > > on rt devices rather than the bt-based allocation reservation.
> > 
> > 2^21 rtexts is ... 2^18 bytes worth of rtbitmap block, which implies a
> > transaction reservation of around ... ~300K?  I guess I'll have to go
> > play with xfs_db to see how small of a datadev you can make before that
> > causes us to fail the minimum log size checks.
> 
> Keep in mind that rtextsz is often larger than a single filesystem
> block, so the bitmap size rapidly reduces as rtextsz goes up.
> 
> > As you said on IRC, it probably won't affect /most/ setups... but I
> > don't want to run around increasing support calls either.  Even if most
> > distributors don't turn on rt support.
> 
> Sure, we can limit the size of the allocation based on the
> transaction reservation limits, but I suspect this will only affect
> filesystems with really, really small data devices that result in a
> <10MB default log size. I don't think there is that many of these
> around in production....
> 
> I'd prefer to fix the transaction size, and then if people start
> reporting that the log size is too small, we can then
> limit the extent size allocation and transaction reservation based
> on the (tiny) log size we read out of the superblock...

Ok, I'll work on that.

> Alternatively, we could implement log growing :)

Heh.  Wandering logs?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
