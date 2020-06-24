Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADC3C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7757E2076E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnENXcIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404190AbgFXPLe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:11:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404135AbgFXPLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 11:11:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05OEw8Ou100218;
        Wed, 24 Jun 2020 15:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kh7FY1fMyu9Epiw8oqHQ6Z2b04zIoJQyku5gGm816hA=;
 b=pnENXcIyol2YBCP8/BiTkKHQjq1gs9ix3XyERkecZPnbXR+kUEELRPvR+dHDAaTbvU9q
 BXTaWqV/HmqzQkKSOBcisErz/hBSrLz7A8ugmyK6oTPGAl7wuQmp6TgMzpbhkvCiPK4p
 6JBizIcl8szmS/gEU7c4YwSMJA3Ekg2NJlrgeLp0XvgI0mKb1k1cCfHbN5KEy6mV+jUk
 j9d6ssTgjCSm37fVsiIrlqIgElFNplcynJqks3lvk3cA247epy/ezKuYNzi4ZZUqZnoP
 QIHpXPA4cVvs4O9ZaGyIGS0Uv2DpTXRpTda64+SnsAMsjgLfjnu9V5K9AJT8ZQaO9JQv Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31uustuep1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 15:11:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05OExXdM114768;
        Wed, 24 Jun 2020 15:09:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31uurqyau0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 15:09:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05OF9JLT025364;
        Wed, 24 Jun 2020 15:09:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 15:09:19 +0000
Date:   Wed, 24 Jun 2020 08:09:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 1/3] xfs: redesign the reflink remap loop to fix blkres
 depletion crash
Message-ID: <20200624150915.GJ7606@magnolia>
References: <159288488965.150128.10967331397379450406.stgit@magnolia>
 <159288489583.150128.6342414891989207881.stgit@magnolia>
 <20200624123841.GA9914@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123841.GA9914@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=5 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 08:38:41AM -0400, Brian Foster wrote:
> On Mon, Jun 22, 2020 at 09:01:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The existing reflink remapping loop has some structural problems that
> > need addressing:
> > 
> > The biggest problem is that we create one transaction for each extent in
> > the source file without accounting for the number of mappings there are
> > for the same range in the destination file.  In other words, we don't
> > know the number of remap operations that will be necessary and we
> > therefore cannot guess the block reservation required.  On highly
> > fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
> > run out of block reservation, and fail.
> > 
> > The second problem is that we don't actually use the bmap intents to
> > their full potential -- instead of calling bunmapi directly and having
> > to deal with its backwards operation, we could call the deferred ops
> > xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
> > makes the frontend loop much simpler.
> > 
> > A third (and more minor) problem is that we aren't even clever enough to
> > skip the whole remapping thing if the source and destination ranges
> > point to the same physical extents.
> > 
> 
> I'm wondering if this all really has to be done in one patch. The last
> bit at least sounds like an optimization from the description.

<nod> I can split out that and the quota reservation fixes.

> > Solve all of these problems by refactoring the remapping loops so that
> > we only perform one remapping operation per transaction, and each
> > operation only tries to remap a single extent from source to dest.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.h |   13 ++-
> >  fs/xfs/xfs_reflink.c     |  234 ++++++++++++++++++++++++++--------------------
> >  fs/xfs/xfs_trace.h       |   52 +---------
> >  fs/xfs/xfs_trans_dquot.c |   13 +--
> >  4 files changed, 149 insertions(+), 163 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index 6028a3c825ba..3498b4f75f71 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
> >  	{ BMAP_ATTRFORK,	"ATTR" }, \
> >  	{ BMAP_COWFORK,		"COW" }
> >  
> > +/* Return true if the extent is an allocated extent, written or not. */
> > +static inline bool xfs_bmap_is_mapped_extent(struct xfs_bmbt_irec *irec)
> > +{
> > +	return irec->br_startblock != HOLESTARTBLOCK &&
> > +		irec->br_startblock != DELAYSTARTBLOCK &&
> > +		!isnullstartblock(irec->br_startblock);
> > +}
> 
> Heh, I was going to suggest to call this _is_real_extent(), but I see
> the helper below already uses that name. I do think the name correlates
> better with this helper and perhaps the one below should be called
> something like xfs_bmap_is_written_extent(). Hm? Either way, the
> "mapped" name is kind of vague and brings back memories of buffer heads.

<nod> I originally wasn't going to change the name on the second helper,
but as there are only three callers currently it's probably easier to do
that now.

> >  
> >  /*
> >   * Return true if the extent is a real, allocated extent, or false if it is  a
> > @@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
> >   */
> >  static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> >  {
> > -	return irec->br_state != XFS_EXT_UNWRITTEN &&
> > -		irec->br_startblock != HOLESTARTBLOCK &&
> > -		irec->br_startblock != DELAYSTARTBLOCK &&
> > -		!isnullstartblock(irec->br_startblock);
> > +	return xfs_bmap_is_mapped_extent(irec) &&
> > +	       irec->br_state != XFS_EXT_UNWRITTEN;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 107bf2a2f344..f50a8c2f21a5 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -984,40 +984,27 @@ xfs_reflink_ag_has_free_space(
> >  }
> >  
> >  /*
> > - * Unmap a range of blocks from a file, then map other blocks into the hole.
> > - * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
> > - * The extent irec is mapped into dest at irec->br_startoff.
> > + * Remap the given extent into the file at the given offset.  The imap
> > + * blockcount will be set to the number of blocks that were actually remapped.
> >   */
> >  STATIC int
> >  xfs_reflink_remap_extent(
> >  	struct xfs_inode	*ip,
> > -	struct xfs_bmbt_irec	*irec,
> > -	xfs_fileoff_t		destoff,
> > +	struct xfs_bmbt_irec	*imap,
> >  	xfs_off_t		new_isize)
> >  {
> > +	struct xfs_bmbt_irec	imap2;
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	bool			real_extent = xfs_bmap_is_real_extent(irec);
> >  	struct xfs_trans	*tp;
> > -	unsigned int		resblks;
> > -	struct xfs_bmbt_irec	uirec;
> > -	xfs_filblks_t		rlen;
> > -	xfs_filblks_t		unmap_len;
> >  	xfs_off_t		newlen;
> > +	int64_t			ip_delta = 0;
> > +	unsigned int		resblks;
> > +	bool			real_extent = xfs_bmap_is_real_extent(imap);
> > +	int			nimaps;
> >  	int			error;
> >  
> > -	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
> > -	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
> > -
> > -	/* No reflinking if we're low on space */
> > -	if (real_extent) {
> > -		error = xfs_reflink_ag_has_free_space(mp,
> > -				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
> > -		if (error)
> > -			goto out;
> > -	}
> > -
> >  	/* Start a rolling transaction to switch the mappings */
> > -	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> > +	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> >  	if (error)
> >  		goto out;
> > @@ -1025,87 +1012,118 @@ xfs_reflink_remap_extent(
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > -	/* If we're not just clearing space, then do we have enough quota? */
> > +	/* Read extent from the second file */
> > +	nimaps = 1;
> > +	error = xfs_bmapi_read(ip, imap->br_startoff, imap->br_blockcount,
> > +			&imap2, &nimaps, 0);
> > +	if (error)
> > +		goto out_cancel;
> > +#ifdef DEBUG
> > +	if (nimaps != 1 ||
> > +	    imap2.br_startoff != imap->br_startoff) {
> > +		/*
> > +		 * We should never get no mapping or something that doesn't
> > +		 * match what we asked for.
> > +		 */
> > +		ASSERT(0);
> > +		error = -EINVAL;
> > +		goto out_cancel;
> > +	}
> > +#endif
> 
> Why the DEBUG?

Christoph wondered (on the atomic extent swap series) when
xfs_bmapi_read would ever return nimaps==0 or an extent that doesn't
match at least the first block that we asked for.

I'm /pretty/ sure that will never happen since the full bmapi read
function will hand us back a "HOLE" mapping if it doesn't find anything,
so I left those parts in as debugging checks.

> > +
> > +	/*
> > +	 * We can only remap as many blocks as the smaller of the two extent
> > +	 * maps, because we can only remap one extent at a time.
> > +	 */
> > +	imap->br_blockcount = min(imap->br_blockcount, imap2.br_blockcount);
> > +
> > +	trace_xfs_reflink_remap_extent2(ip, &imap2);
> > +
> > +	/*
> > +	 * Two extents mapped to the same physical block must not have
> > +	 * different states; that's filesystem corruption.  Move on to the next
> > +	 * extent if they're both holes or both the same physical extent.
> > +	 */
> > +	if (imap->br_startblock == imap2.br_startblock) {
> > +		if (imap->br_state != imap2.br_state)
> > +			error = -EFSCORRUPTED;
> 
> Can we assert the length of each extent match here as well?

We can, but we asked the second bmapi_read to give us a mapping that
isn't any longer than imap->br_blockcount, and now we've just shortened
imap->br_blockcount to be no longer than what that second bmapi_read
returned.

I guess I don't mind adding a debugging assert just to make sure I
didn't screw up the math, though it seems excessive... :)

> > +		goto out_cancel;
> > +	}
> > +
> >  	if (real_extent) {
> > +		/* No reflinking if we're low on space */
> > +		error = xfs_reflink_ag_has_free_space(mp,
> > +				XFS_FSB_TO_AGNO(mp, imap->br_startblock));
> > +		if (error)
> > +			goto out_cancel;
> > +
> > +
> > +		/* Do we have enough quota? */
> >  		error = xfs_trans_reserve_quota_nblks(tp, ip,
> > -				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> > +				imap->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> 
> Any reason this doesn't accommodate removal of real blocks?

The old code didn't. :)

Come to think of it, this under-reserves quota accounting, since we need
to reserve bmbt blocks too.

Urk, I guess that needs fixing too.

> 
> >  		if (error)
> >  			goto out_cancel;
> >  	}
> >  
> > -	trace_xfs_reflink_remap(ip, irec->br_startoff,
> > -				irec->br_blockcount, irec->br_startblock);
> > -
> > -	/* Unmap the old blocks in the data fork. */
> > -	rlen = unmap_len;
> > -	while (rlen) {
> > -		ASSERT(tp->t_firstblock == NULLFSBLOCK);
> > -		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
> > -		if (error)
> > -			goto out_cancel;
> > -
> > +	if (xfs_bmap_is_mapped_extent(&imap2)) {
> >  		/*
> > -		 * Trim the extent to whatever got unmapped.
> > -		 * Remember, bunmapi works backwards.
> > +		 * If the extent we're unmapping is backed by storage (written
> > +		 * or not), unmap the extent and drop its refcount.
> >  		 */
> > -		uirec.br_startblock = irec->br_startblock + rlen;
> > -		uirec.br_startoff = irec->br_startoff + rlen;
> > -		uirec.br_blockcount = unmap_len - rlen;
> > -		uirec.br_state = irec->br_state;
> > -		unmap_len = rlen;
> > +		xfs_bmap_unmap_extent(tp, ip, &imap2);
> > +		xfs_refcount_decrease_extent(tp, &imap2);
> > +		ip_delta -= imap2.br_blockcount;
> > +	} else if (imap2.br_startblock == DELAYSTARTBLOCK) {
> > +		xfs_filblks_t	len = imap2.br_blockcount;
> >  
> > -		/* If this isn't a real mapping, we're done. */
> > -		if (!real_extent || uirec.br_blockcount == 0)
> > -			goto next_extent;
> > -
> > -		trace_xfs_reflink_remap(ip, uirec.br_startoff,
> > -				uirec.br_blockcount, uirec.br_startblock);
> > -
> > -		/* Update the refcount tree */
> > -		xfs_refcount_increase_extent(tp, &uirec);
> > -
> > -		/* Map the new blocks into the data fork. */
> > -		xfs_bmap_map_extent(tp, ip, &uirec);
> > +		/*
> > +		 * If the extent we're unmapping is a delalloc reservation,
> > +		 * we can use the regular bunmapi function to release the
> > +		 * incore state.  Dropping the delalloc reservation takes care
> > +		 * of the quota reservation for us.
> > +		 */
> > +		error = __xfs_bunmapi(NULL, ip, imap2.br_startoff, &len, 0, 1);
> > +		if (error)
> > +			goto out_cancel;
> > +		ASSERT(len == 0);
> > +	}
> >  
> > -		/* Update quota accounting. */
> > -		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> > -				uirec.br_blockcount);
> > +	/*
> > +	 * If the extent we're sharing is backed by written storage, increase
> > +	 * its refcount and map it into the file.
> > +	 */
> > +	if (real_extent) {
> > +		xfs_refcount_increase_extent(tp, imap);
> > +		xfs_bmap_map_extent(tp, ip, imap);
> > +		ip_delta += imap->br_blockcount;
> > +	}
> >  
> > -		/* Update dest isize if needed. */
> > -		newlen = XFS_FSB_TO_B(mp,
> > -				uirec.br_startoff + uirec.br_blockcount);
> > -		newlen = min_t(xfs_off_t, newlen, new_isize);
> > -		if (newlen > i_size_read(VFS_I(ip))) {
> > -			trace_xfs_reflink_update_inode_size(ip, newlen);
> > -			i_size_write(VFS_I(ip), newlen);
> > -			ip->i_d.di_size = newlen;
> > -			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > -		}
> > +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, ip_delta);
> >  
> > -next_extent:
> > -		/* Process all the deferred stuff. */
> > -		error = xfs_defer_finish(&tp);
> > -		if (error)
> > -			goto out_cancel;
> > +	/* Update dest isize if needed. */
> > +	newlen = XFS_FSB_TO_B(mp, imap2.br_startoff + imap2.br_blockcount);
> > +	newlen = min_t(xfs_off_t, newlen, new_isize);
> > +	if (newlen > i_size_read(VFS_I(ip))) {
> > +		trace_xfs_reflink_update_inode_size(ip, newlen);
> > +		i_size_write(VFS_I(ip), newlen);
> > +		ip->i_d.di_size = newlen;
> > +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >  	}
> >  
> > +	/* Commit everything and unlock. */
> >  	error = xfs_trans_commit(tp);
> > -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -	if (error)
> > -		goto out;
> > -	return 0;
> > +	goto out_unlock;
> 
> We probably shouldn't fire the _error() tracepoint in the successful
> exit case.

Oops, good catch. :)

> >  
> >  out_cancel:
> >  	xfs_trans_cancel(tp);
> > +out_unlock:
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  out:
> >  	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
> >  	return error;
> >  }
> >  
> > -/*
> > - * Iteratively remap one file's extents (and holes) to another's.
> > - */
> > +/* Remap a range of one file to the other. */
> >  int
> >  xfs_reflink_remap_blocks(
> >  	struct xfs_inode	*src,
> > @@ -1116,25 +1134,22 @@ xfs_reflink_remap_blocks(
> >  	loff_t			*remapped)
> >  {
> >  	struct xfs_bmbt_irec	imap;
> > -	xfs_fileoff_t		srcoff;
> > -	xfs_fileoff_t		destoff;
> > +	struct xfs_mount	*mp = src->i_mount;
> > +	xfs_fileoff_t		srcoff = XFS_B_TO_FSBT(mp, pos_in);
> > +	xfs_fileoff_t		destoff = XFS_B_TO_FSBT(mp, pos_out);
> >  	xfs_filblks_t		len;
> > -	xfs_filblks_t		range_len;
> >  	xfs_filblks_t		remapped_len = 0;
> >  	xfs_off_t		new_isize = pos_out + remap_len;
> >  	int			nimaps;
> >  	int			error = 0;
> >  
> > -	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
> > -	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
> > -	len = XFS_B_TO_FSB(src->i_mount, remap_len);
> > +	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
> > +			XFS_MAX_FILEOFF);
> >  
> > -	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
> > -	while (len) {
> > -		uint		lock_mode;
> > +	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
> >  
> > -		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
> > -				dest, destoff);
> > +	while (len > 0) {
> > +		unsigned int	lock_mode;
> >  
> >  		/* Read extent from the source file */
> >  		nimaps = 1;
> > @@ -1143,18 +1158,29 @@ xfs_reflink_remap_blocks(
> >  		xfs_iunlock(src, lock_mode);
> >  		if (error)
> >  			break;
> > -		ASSERT(nimaps == 1);
> > +#ifdef DEBUG
> > +		if (nimaps != 1 ||
> > +		    imap.br_startblock == DELAYSTARTBLOCK ||
> > +		    imap.br_startoff != srcoff) {
> > +			/*
> > +			 * We should never get no mapping or a delalloc extent
> > +			 * or something that doesn't match what we asked for,
> > +			 * since the caller flushed the source file data and
> > +			 * we hold the source file io/mmap locks.
> > +			 */
> > +			ASSERT(nimaps == 0);
> > +			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> > +			ASSERT(imap.br_startoff == srcoff);
> > +			error = -EINVAL;
> > +			break;
> > +		}
> > +#endif
> 
> Same thing with the DEBUG check? It seems like at least some of these
> checks should be unconditional in the event the file is corrupted or
> something.

Doh... yeah, I guess the delalloc check really needs to be in there, in
case a previous write+fsync failed and left us some remnants.

> >  
> > -		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
> > -				&imap);
> > +		trace_xfs_reflink_remap_extent1(src, &imap);
> 
> How about trace_xfs_reflink_remap_extent_[src|dest]() so trace data is a
> bit more readable?

<nod> I like the suggestion!

> >  
> > -		/* Translate imap into the destination file. */
> > -		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
> > -		imap.br_startoff += destoff - srcoff;
> > -
> > -		/* Clear dest from destoff to the end of imap and map it in. */
> > -		error = xfs_reflink_remap_extent(dest, &imap, destoff,
> > -				new_isize);
> > +		/* Remap into the destination file at the given offset. */
> > +		imap.br_startoff = destoff;
> > +		error = xfs_reflink_remap_extent(dest, &imap, new_isize);
> >  		if (error)
> >  			break;
> >  
> > @@ -1164,10 +1190,10 @@ xfs_reflink_remap_blocks(
> >  		}
> >  
> >  		/* Advance drange/srange */
> > -		srcoff += range_len;
> > -		destoff += range_len;
> > -		len -= range_len;
> > -		remapped_len += range_len;
> > +		srcoff += imap.br_blockcount;
> > +		destoff += imap.br_blockcount;
> > +		len -= imap.br_blockcount;
> > +		remapped_len += imap.br_blockcount;
> 
> Much nicer iteration, indeed. ;)

Thanks! :)

--D

> Brian
> 
> >  	}
> >  
> >  	if (error)
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 460136628a79..f205602c8ba9 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3052,8 +3052,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
> >  DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
> >  DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
> >  DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
> > -DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
> > -TRACE_EVENT(xfs_reflink_remap_blocks_loop,
> > +TRACE_EVENT(xfs_reflink_remap_blocks,
> >  	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
> >  		 xfs_filblks_t len, struct xfs_inode *dest,
> >  		 xfs_fileoff_t doffset),
> > @@ -3084,59 +3083,14 @@ TRACE_EVENT(xfs_reflink_remap_blocks_loop,
> >  		  __entry->dest_ino,
> >  		  __entry->dest_lblk)
> >  );
> > -TRACE_EVENT(xfs_reflink_punch_range,
> > -	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
> > -		 xfs_extlen_t len),
> > -	TP_ARGS(ip, lblk, len),
> > -	TP_STRUCT__entry(
> > -		__field(dev_t, dev)
> > -		__field(xfs_ino_t, ino)
> > -		__field(xfs_fileoff_t, lblk)
> > -		__field(xfs_extlen_t, len)
> > -	),
> > -	TP_fast_assign(
> > -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> > -		__entry->ino = ip->i_ino;
> > -		__entry->lblk = lblk;
> > -		__entry->len = len;
> > -	),
> > -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
> > -		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  __entry->ino,
> > -		  __entry->lblk,
> > -		  __entry->len)
> > -);
> > -TRACE_EVENT(xfs_reflink_remap,
> > -	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
> > -		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
> > -	TP_ARGS(ip, lblk, len, new_pblk),
> > -	TP_STRUCT__entry(
> > -		__field(dev_t, dev)
> > -		__field(xfs_ino_t, ino)
> > -		__field(xfs_fileoff_t, lblk)
> > -		__field(xfs_extlen_t, len)
> > -		__field(xfs_fsblock_t, new_pblk)
> > -	),
> > -	TP_fast_assign(
> > -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> > -		__entry->ino = ip->i_ino;
> > -		__entry->lblk = lblk;
> > -		__entry->len = len;
> > -		__entry->new_pblk = new_pblk;
> > -	),
> > -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
> > -		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  __entry->ino,
> > -		  __entry->lblk,
> > -		  __entry->len,
> > -		  __entry->new_pblk)
> > -);
> >  DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
> >  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
> >  DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
> >  DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
> >  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
> >  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
> > +DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent1);
> > +DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent2);
> >  
> >  /* dedupe tracepoints */
> >  DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index c0f73b82c055..99511ff6222f 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -124,16 +124,17 @@ xfs_trans_dup_dqinfo(
> >   */
> >  void
> >  xfs_trans_mod_dquot_byino(
> > -	xfs_trans_t	*tp,
> > -	xfs_inode_t	*ip,
> > -	uint		field,
> > -	int64_t		delta)
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	uint			field,
> > +	int64_t			delta)
> >  {
> > -	xfs_mount_t	*mp = tp->t_mountp;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> >  
> >  	if (!XFS_IS_QUOTA_RUNNING(mp) ||
> >  	    !XFS_IS_QUOTA_ON(mp) ||
> > -	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> > +	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino) ||
> > +	    delta == 0)
> >  		return;
> >  
> >  	if (tp->t_dqinfo == NULL)
> > 
> 
