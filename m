Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADF0C43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A93AF20717
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tg0S5RYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfLPQr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:47:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLPQr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 11:47:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBGGdQo0177879;
        Mon, 16 Dec 2019 16:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=C7MdNdQ2sD/OU9Fl1X2sPN0sx586fWF6vltpglQprhA=;
 b=Tg0S5RYzFROCgRt2X3fs+JmecZMkzrxplDqCGkYlMFR6VrpNGuTUQ9C5ccJ3ylZn6irD
 j9OgSyu8+gvWeD0daIhckrthiAMgvG8YRWGhLHcoD2ldndGUcyWQoezSucpkwp7II5nA
 Apezbm8haDouDebYMiRmOhH1qrI20h7cCll/isEpFWKLME5s871N2XAPlIX4PQ6tmmaY
 sSgPCyxH1GH1oW5JOyEr2zLpMULS9u/XLlx8/z+FrfcyMt93g8BcyH4FXfOwPPdwUSMC
 hfNY8ebSm2yvxk3onpHr/VJAInvsb1imrgLNY/ViJBf8xdhDq3rf8kQgickzmforLrVq Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcr0s19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 16:47:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBGGdXoV135700;
        Mon, 16 Dec 2019 16:47:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ww98s4ycb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 16:47:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBGGlkhn030774;
        Mon, 16 Dec 2019 16:47:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 08:47:45 -0800
Date:   Mon, 16 Dec 2019 08:47:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log reservation overflows when allocating large
 rt extents
Message-ID: <20191216164745.GO99875@magnolia>
References: <20191204163809.GP7335@magnolia>
 <20191213121840.GA43376@bfoster>
 <20191213201957.GI99875@magnolia>
 <20191216122332.GA10536@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216122332.GA10536@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912160146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912160146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 07:23:32AM -0500, Brian Foster wrote:
> On Fri, Dec 13, 2019 at 12:19:57PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 13, 2019 at 07:18:40AM -0500, Brian Foster wrote:
> > > On Wed, Dec 04, 2019 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Omar Sandoval reported that a 4G fallocate on the realtime device causes
> > > > filesystem shutdowns due to a log reservation overflow that happens when
> > > > we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
> > > > the tr_write and tr_itruncate log reservation calculation.
> > > > 
> > > > "The following reproducer results in a transaction log overrun warning
> > > > for me:
> > > > 
> > > >     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
> > > >     mount -o rtdev=/dev/vdc /dev/vdb /mnt
> > > >     fallocate -l 4G /mnt/foo
> > > > 
> > > > Reported-by: Omar Sandoval <osandov@osandov.com>
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Looks reasonable enough given my limited knowledge on the rt bits. One
> > > question..
> > > 
> > > >  fs/xfs/libxfs/xfs_trans_resv.c |   96 ++++++++++++++++++++++++++++++++--------
> > > >  1 file changed, 77 insertions(+), 19 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > > > index c55cd9a3dec9..824073a839ac 100644
> > > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > > @@ -196,6 +196,24 @@ xfs_calc_inode_chunk_res(
> > > >  	return res;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Per-extent log reservation for the btree changes involved in freeing or
> > > > + * allocating a realtime extent.  We have to be able to log as many rtbitmap
> > > > + * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
> > > > + * as well as the realtime summary block.
> > > > + */
> > > > +unsigned int
> > > > +xfs_rtalloc_log_count(
> > > > +	struct xfs_mount	*mp,
> > > > +	unsigned int		num_ops)
> > > > +{
> > > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > > +	unsigned int		rtbmp_bytes;
> > > > +
> > > > +	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
> > > > +	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Various log reservation values.
> > > >   *
> > > > @@ -218,13 +236,21 @@ xfs_calc_inode_chunk_res(
> > > >  
> > > >  /*
> > > >   * In a write transaction we can allocate a maximum of 2
> > > > - * extents.  This gives:
> > > > + * extents.  This gives (t1):
> > > >   *    the inode getting the new extents: inode size
> > > >   *    the inode's bmap btree: max depth * block size
> > > >   *    the agfs of the ags from which the extents are allocated: 2 * sector
> > > >   *    the superblock free block counter: sector size
> > > >   *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> > > > - * And the bmap_finish transaction can free bmap blocks in a join:
> > > > + * Or, if we're writing to a realtime file (t2):
> > > > + *    the inode getting the new extents: inode size
> > > > + *    the inode's bmap btree: max depth * block size
> > > > + *    the agfs of the ags from which the extents are allocated: 2 * sector
> > > > + *    the superblock free block counter: sector size
> > > > + *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > > > + *    the realtime summary: 1 block
> > > > + *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
> > > 
> > > Why do we include the allocation btrees in the rt reservations? I
> > > thought that we'd either allocate (or free) out of one pool or the
> > > other. Do we operate on both sets of structures in the same transaction?
> > 
> > I read "allocation btrees: 2 exts * 2 trees..." for t1 to mean that we
> > need to be able to allocate one datadev extent (which could cause a full
> > bnobt/cntbt split) for the actual file data, and then the second extent is
> > to handle allocating a new bmbt block to the bmap btree.
> > 
> 
> Ah, metadata out of the traditional trees.. that makes sense. My general
> understanding is that we have two sets of free space and thus two
> associated free space tracking structures: the traditional perag btrees
> for the local device and some bitmap indexing scheme for the external
> realtime device. Based on that, it looks like a file data allocation
> falls down into xfs_bmap_rtalloc() to allocate data blocks via the RT
> subsystem and the subsequent bmap update falls into the bmapbt code that
> uses xfs_alloc_vextent() directly to allocate blocks for the bmbt.
> 
> With regard to the 2 extents, the first sentence in the comment above
> suggests to me that the two extents is a per-transaction operational
> limit. IOW, a write transaction supports two xfs_bmapi_write() calls,
> for example, as opposed to referring to the two lower level allocations
> outlined above. That seems consistent with the "2 * sector" AGF portion
> of the reservation as well, but I could easily be wrong about that.
> 
> BTW I'm not following what you mean by a datadev extent causing a
> bnobt/cntbt split. Doesn't the data extent come from the RT free space,
> or are you just indirectly referring to the supporting bmbt block
> allocation causing a split..?

"t1" is reflects writes to regular files on the datadev device, so
"allocate one datadev extent (which could cause a full bnobt/cntbt
split) for actual file data" applies to that case, not t2.

"t2" is for writes to realtime files on the rt device.

> > Based on that, I concluded that we still need to reserve space for that
> > "second" extent to handle allocating a new bmbt block (on the datadev).

Perhaps my reply could have been clearer had I said:

"Based on that, I concluded for the realtime case (t2) that we still..."

> > While pondering that, I wondered if even that's really true because what
> > happens if you suffer a full bmbt split, the free space is so fragmented
> > that each level of the bmbt split ends up allocating a new block from a
> > different part of the free space btrees and that in turn causes splits
> > in the free space btrees?
> > 
> > I think the answer is "no we're fine" because even if each new bmbt
> > block comes from a different bnobt record, a full bmbt split will never
> > hollow out more than half of one bnobt block's worth of free space
> > records.
> > 
> 
> Yeah. I couldn't say for sure, but this strikes me as something we'd see
> reports of if it were possible/likely to occur in practice, particularly
> since this is the basis of how the allocation transaction reservations
> are calculated in general (not just for RT).

<nod>

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > + * And the bmap_finish transaction can free bmap blocks in a join (t3):
> > > >   *    the agfs of the ags containing the blocks: 2 * sector size
> > > >   *    the agfls of the ags containing the blocks: 2 * sector size
> > > >   *    the super block free block counter: sector size
> > > > @@ -234,40 +260,72 @@ STATIC uint
> > > >  xfs_calc_write_reservation(
> > > >  	struct xfs_mount	*mp)
> > > >  {
> > > > -	return XFS_DQUOT_LOGRES(mp) +
> > > > -		max((xfs_calc_inode_res(mp, 1) +
> > > > +	unsigned int		t1, t2, t3;
> > > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > > +
> > > > +	t1 = xfs_calc_inode_res(mp, 1) +
> > > > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> > > > +	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > > +
> > > > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > > > +		t2 = xfs_calc_inode_res(mp, 1) +
> > > >  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> > > > -				      XFS_FSB_TO_B(mp, 1)) +
> > > > +				      blksz) +
> > > >  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> > > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > > > -				      XFS_FSB_TO_B(mp, 1))),
> > > > -		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> > > > -				      XFS_FSB_TO_B(mp, 1))));
> > > > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
> > > > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> > > > +	} else {
> > > > +		t2 = 0;
> > > > +	}
> > > > +
> > > > +	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > > +
> > > > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> > > >  }
> > > >  
> > > >  /*
> > > > - * In truncating a file we free up to two extents at once.  We can modify:
> > > > + * In truncating a file we free up to two extents at once.  We can modify (t1):
> > > >   *    the inode being truncated: inode size
> > > >   *    the inode's bmap btree: (max depth + 1) * block size
> > > > - * And the bmap_finish transaction can free the blocks and bmap blocks:
> > > > + * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
> > > >   *    the agf for each of the ags: 4 * sector size
> > > >   *    the agfl for each of the ags: 4 * sector size
> > > >   *    the super block to reflect the freed blocks: sector size
> > > >   *    worst case split in allocation btrees per extent assuming 4 extents:
> > > >   *		4 exts * 2 trees * (2 * max depth - 1) * block size
> > > > + * Or, if it's a realtime file (t3):
> > > > + *    the agf for each of the ags: 2 * sector size
> > > > + *    the agfl for each of the ags: 2 * sector size
> > > > + *    the super block to reflect the freed blocks: sector size
> > > > + *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> > > > + *    the realtime summary: 2 exts * 1 block
> > > > + *    worst case split in allocation btrees per extent assuming 2 extents:
> > > > + *		2 exts * 2 trees * (2 * max depth - 1) * block size
> > > >   */
> > > >  STATIC uint
> > > >  xfs_calc_itruncate_reservation(
> > > >  	struct xfs_mount	*mp)
> > > >  {
> > > > -	return XFS_DQUOT_LOGRES(mp) +
> > > > -		max((xfs_calc_inode_res(mp, 1) +
> > > > -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
> > > > -				      XFS_FSB_TO_B(mp, 1))),
> > > > -		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > > > -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> > > > -				      XFS_FSB_TO_B(mp, 1))));
> > > > +	unsigned int		t1, t2, t3;
> > > > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > > > +
> > > > +	t1 = xfs_calc_inode_res(mp, 1) +
> > > > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> > > > +
> > > > +	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > > > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> > > > +
> > > > +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> > > > +		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > > > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> > > > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > > > +	} else {
> > > > +		t3 = 0;
> > > > +	}
> > > > +
> > > > +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> > > >  }
> > > >  
> > > >  /*
> > > > 
> > > 
> > 
> 
