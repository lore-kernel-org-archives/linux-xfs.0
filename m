Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0AAC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 02:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA751206DC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 02:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GoyHYSR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLCCpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 21:45:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLCCpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 21:45:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32iKGT080027;
        Tue, 3 Dec 2019 02:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sv5YfH98Izsf7QIsGZ/Q1dGEfGKCL3Z30OcJH0+B9SQ=;
 b=GoyHYSR6XdizeXLNnx+ROGHk9+5oFC0Je0U56zGiJRLUtHPw0OT2q9djw52EB5ALr4VC
 q+W7oEF2/MCdIpNWQ3qZTRAjnfDGMRBHwBmn1Wq7zWDM4GoiJTojs2HOc7i9xOfesFgp
 Y18XwQmbeLiApBd7FH2N04KJaMoFcG7TK1mnAQAKkUUpX8GYwAA8IZpikw3WQpuTOqdX
 b7KZVPuBN1spOqbaGhkDZguNnp0FnJS0Z1ZkQsKXV8NI7LKGti0f6CrVJe27x2u9DRvn
 hEQDMPBfe+Vsv0mswFrWjIcsKkMRKs8dfW5L0pSXO1HISTDdCl2tVhshFfMSdx4mq/4Q 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2r45fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:45:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32i3p6101229;
        Tue, 3 Dec 2019 02:45:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wn4qntuhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:45:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB32jRrD024255;
        Tue, 3 Dec 2019 02:45:28 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 18:45:27 -0800
Date:   Mon, 2 Dec 2019 18:45:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org
Subject: Re: Transaction log reservation overrun when fallocating realtime
 file
Message-ID: <20191203024526.GF7339@magnolia>
References: <20191126202714.GA667580@vader>
 <20191127003426.GP6219@magnolia>
 <20191202215113.GH2695@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202215113.GH2695@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 08:51:13AM +1100, Dave Chinner wrote:
> On Tue, Nov 26, 2019 at 04:34:26PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 26, 2019 at 12:27:14PM -0800, Omar Sandoval wrote:
> > > Hello,
> > > 
> > > The following reproducer results in a transaction log overrun warning
> > > for me:
> > > 
> > >   mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> > >   mount -o rtdev=/dev/vdc /dev/vdb /mnt
> > >   fallocate -l 4G /mnt/foo
> > > 
> > > I've attached the full dmesg output. My guess at the problem is that the
> > > tr_write reservation used by xfs_alloc_file_space is not taking the realtime
> > > bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
> > > this filesystem, which I do see in some of the log items). However, I'm not
> > > familiar enough with the XFS transaction guts to confidently fix this. Can
> > > someone please help me out?
> > 
> > Hmm...
> > 
> > /*
> >  * In a write transaction we can allocate a maximum of 2
> >  * extents.  This gives:
> >  *    the inode getting the new extents: inode size
> >  *    the inode's bmap btree: max depth * block size
> >  *    the agfs of the ags from which the extents are allocated: 2 * sector
> >  *    the superblock free block counter: sector size
> >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> >  * And the bmap_finish transaction can free bmap blocks in a join:
> >  *    the agfs of the ags containing the blocks: 2 * sector size
> >  *    the agfls of the ags containing the blocks: 2 * sector size
> >  *    the super block free block counter: sector size
> >  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> >  */
> > STATIC uint
> > xfs_calc_write_reservation(...);
> > 
> > So this means that the rt allocator can burn through at most ...
> > 1 ext * 2 trees * (2 * maxdepth - 1) * blocksize
> > ... worth of log reservation as part of setting bits in the rtbitmap and
> > fiddling with the rtsummary information.
> > 
> > Instead, 4GB of 4k rt extents == 1 million rtexts to mark in use, which
> > is 131072 bytes of rtbitmap to log, and *kaboom* there goes the 109K log
> > reservation.
> 
> Ok, if that's the case, we still need to be able to allocate MAXEXTLEN in
> a single transaction. That's 2^21 filesystem blocks, which at most
> is 2^21 rtexts.
> 
> Hence I think we probably should have a separate rt-write
> reservation that handles this case, and we use that for allocation
> on rt devices rather than the bt-based allocation reservation.

2^21 rtexts is ... 2^18 bytes worth of rtbitmap block, which implies a
transaction reservation of around ... ~300K?  I guess I'll have to go
play with xfs_db to see how small of a datadev you can make before that
causes us to fail the minimum log size checks.

As you said on IRC, it probably won't affect /most/ setups... but I
don't want to run around increasing support calls either.  Even if most
distributors don't turn on rt support.

> 
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs: cap realtime allocation length to something we can log
> > 
> > Omar Sandoval reported that a 4G fallocate on the realtime device causes
> > filesystem shutdowns due to a log reservation overflow that happens when
> > we log the rtbitmap updates.
> > 
> > The tr_write transaction reserves enough log reservation to handle a
> > full splits of both free space btrees, so cap the rt allocation at that
> > number of bits.
> > 
> > "The following reproducer results in a transaction log overrun warning
> > for me:
> > 
> >     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> >     mount -o rtdev=/dev/vdc /dev/vdb /mnt
> >     fallocate -l 4G /mnt/foo
> > 
> > Reported-by: Omar Sandoval <osandov@osandov.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |   23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 49d7b530c8f7..15c4e2790de3 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -69,6 +69,26 @@ xfs_zero_extent(
> >  }
> >  
> >  #ifdef CONFIG_XFS_RT
> > +/*
> > + * tr_write allows for one full split in the bnobt and cntbt to record the
> > + * allocation, and that's how many bits of rtbitmap we can log to the
> > + * transaction.  We leave one full block's worth of log space to handle the
> > + * rtsummary update, though that's probably overkill.
> > + */
> > +static inline uint64_t
> > +xfs_bmap_rtalloc_max(
> > +	struct xfs_mount	*mp)
> > +{
> > +	uint64_t		max_rtbitmap;
> > +
> > +	max_rtbitmap = xfs_allocfree_log_count(mp, 1) - 1;
> > +	max_rtbitmap *= XFS_FSB_TO_B(mp, 1);
> > +	max_rtbitmap *= NBBY;
> > +	max_rtbitmap *= mp->m_sb.sb_rextsize;
> 
> I can see how this works, but it strikes me as a bit of a hack. We
> calculate the worst case reservations up front to avoid having to
> play games like this in the code. Hence I think the correct thing to
> do is fix the reservation to ensure we can do MAXEXTLEN allocations
> without overruns...

Yeah...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
