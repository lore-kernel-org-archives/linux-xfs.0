Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919A2C4D2F1
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C453024717
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZ8rTvr0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfLMUUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:20:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbfLMUUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 15:20:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKJT7o063818;
        Fri, 13 Dec 2019 20:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KE+NhCofwQZXQpjAjVyxNZhVSIp0N+YvAPrj7QQQIoA=;
 b=aZ8rTvr0fkuBqBFbIfMHRSq1hEBT8p92vXN9Ken119bbE2Ne/IlPcmqM8uAN3/zkGkVO
 a7/r9FfxWtDRuKmPbyHzOPuWLD/lZYw+sinKfvtdZA/I/aL+qVjZKmN5E07U4yPQ5IGD
 +VrpGvf/vyYAfT+xRKn/DKIt+a8VmIVVsLKaA6pPvC7lbacPf0oc8kLmlM/oX8vqkicZ
 2omgk4voG87wVJWQHoOGbDJi0ib6l7RunPsyHJ8GgyWdYfxW4T2mif15EYNHBr1xKF14
 yi/Qec0e4j4u2cluyqNSKbVRp1M8M01DtBpUbOyCfQVNWqSHj73/0ESF/sVuWLkGpKbJ ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qs339k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:20:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKIVox191452;
        Fri, 13 Dec 2019 20:20:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wvdtvbp9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:20:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBDKJx5X007556;
        Fri, 13 Dec 2019 20:19:59 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 12:19:58 -0800
Date:   Fri, 13 Dec 2019 12:19:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log reservation overflows when allocating large
 rt extents
Message-ID: <20191213201957.GI99875@magnolia>
References: <20191204163809.GP7335@magnolia>
 <20191213121840.GA43376@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213121840.GA43376@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 07:18:40AM -0500, Brian Foster wrote:
> On Wed, Dec 04, 2019 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Omar Sandoval reported that a 4G fallocate on the realtime device causes
> > filesystem shutdowns due to a log reservation overflow that happens when
> > we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
> > the tr_write and tr_itruncate log reservation calculation.
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
> 
> Looks reasonable enough given my limited knowledge on the rt bits. One
> question..
> 
> >  fs/xfs/libxfs/xfs_trans_resv.c |   96 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 77 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index c55cd9a3dec9..824073a839ac 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -196,6 +196,24 @@ xfs_calc_inode_chunk_res(
> >  	return res;
> >  }
> >  
> > +/*
> > + * Per-extent log reservation for the btree changes involved in freeing or
> > + * allocating a realtime extent.  We have to be able to log as many rtbitmap
> > + * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
> > + * as well as the realtime summary block.
> > + */
> > +unsigned int
> > +xfs_rtalloc_log_count(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		num_ops)
> > +{
> > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > +	unsigned int		rtbmp_bytes;
> > +
> > +	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
> > +	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
> > +}
> > +
> >  /*
> >   * Various log reservation values.
> >   *
> > @@ -218,13 +236,21 @@ xfs_calc_inode_chunk_res(
> >  
> >  /*
> >   * In a write transaction we can allocate a maximum of 2
> > - * extents.  This gives:
> > + * extents.  This gives (t1):
> >   *    the inode getting the new extents: inode size
> >   *    the inode's bmap btree: max depth * block size
> >   *    the agfs of the ags from which the extents are allocated: 2 * sector
> >   *    the superblock free block counter: sector size
> >   *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > - * And the bmap_finish transaction can free bmap blocks in a join:
> > + * Or, if we're writing to a realtime file (t2):
> > + *    the inode getting the new extents: inode size
> > + *    the inode's bmap btree: max depth * block size
> > + *    the agfs of the ags from which the extents are allocated: 2 * sector
> > + *    the superblock free block counter: sector size
> > + *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > + *    the realtime summary: 1 block
> > + *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
> 
> Why do we include the allocation btrees in the rt reservations? I
> thought that we'd either allocate (or free) out of one pool or the
> other. Do we operate on both sets of structures in the same transaction?

I read "allocation btrees: 2 exts * 2 trees..." for t1 to mean that we
need to be able to allocate one datadev extent (which could cause a full
bnobt/cntbt split) for the actual file data, and then the second extent is
to handle allocating a new bmbt block to the bmap btree.

Based on that, I concluded that we still need to reserve space for that
"second" extent to handle allocating a new bmbt block (on the datadev).

While pondering that, I wondered if even that's really true because what
happens if you suffer a full bmbt split, the free space is so fragmented
that each level of the bmbt split ends up allocating a new block from a
different part of the free space btrees and that in turn causes splits
in the free space btrees?

I think the answer is "no we're fine" because even if each new bmbt
block comes from a different bnobt record, a full bmbt split will never
hollow out more than half of one bnobt block's worth of free space
records.

--D

> Brian
> 
> > + * And the bmap_finish transaction can free bmap blocks in a join (t3):
> >   *    the agfs of the ags containing the blocks: 2 * sector size
> >   *    the agfls of the ags containing the blocks: 2 * sector size
> >   *    the super block free block counter: sector size
> > @@ -234,40 +260,72 @@ STATIC uint
> >  xfs_calc_write_reservation(
> >  	struct xfs_mount	*mp)
> >  {
> > -	return XFS_DQUOT_LOGRES(mp) +
> > -		max((xfs_calc_inode_res(mp, 1) +
> > +	unsigned int		t1, t2, t3;
> > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > +
> > +	t1 = xfs_calc_inode_res(mp, 1) +
> > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> > +	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > +
> > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > +		t2 = xfs_calc_inode_res(mp, 1) +
> >  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> > -				      XFS_FSB_TO_B(mp, 1)) +
> > +				      blksz) +
> >  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > -				      XFS_FSB_TO_B(mp, 1))),
> > -		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > -				      XFS_FSB_TO_B(mp, 1))));
> > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
> > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> > +	} else {
> > +		t2 = 0;
> > +	}
> > +
> > +	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > +
> > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> >  }
> >  
> >  /*
> > - * In truncating a file we free up to two extents at once.  We can modify:
> > + * In truncating a file we free up to two extents at once.  We can modify (t1):
> >   *    the inode being truncated: inode size
> >   *    the inode's bmap btree: (max depth + 1) * block size
> > - * And the bmap_finish transaction can free the blocks and bmap blocks:
> > + * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
> >   *    the agf for each of the ags: 4 * sector size
> >   *    the agfl for each of the ags: 4 * sector size
> >   *    the super block to reflect the freed blocks: sector size
> >   *    worst case split in allocation btrees per extent assuming 4 extents:
> >   *		4 exts * 2 trees * (2 * max depth - 1) * block size
> > + * Or, if it's a realtime file (t3):
> > + *    the agf for each of the ags: 2 * sector size
> > + *    the agfl for each of the ags: 2 * sector size
> > + *    the super block to reflect the freed blocks: sector size
> > + *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > + *    the realtime summary: 2 exts * 1 block
> > + *    worst case split in allocation btrees per extent assuming 2 extents:
> > + *		2 exts * 2 trees * (2 * max depth - 1) * block size
> >   */
> >  STATIC uint
> >  xfs_calc_itruncate_reservation(
> >  	struct xfs_mount	*mp)
> >  {
> > -	return XFS_DQUOT_LOGRES(mp) +
> > -		max((xfs_calc_inode_res(mp, 1) +
> > -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
> > -				      XFS_FSB_TO_B(mp, 1))),
> > -		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> > -				      XFS_FSB_TO_B(mp, 1))));
> > +	unsigned int		t1, t2, t3;
> > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > +
> > +	t1 = xfs_calc_inode_res(mp, 1) +
> > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> > +
> > +	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> > +
> > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > +		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > +	} else {
> > +		t3 = 0;
> > +	}
> > +
> > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> >  }
> >  
> >  /*
> > 
> 
