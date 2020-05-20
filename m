Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99E8C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B685620748
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 21:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mO6KtVwj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgETVR3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 17:17:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgETVR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 17:17:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KLHHaP073047;
        Wed, 20 May 2020 21:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0p8lpaEAs9W3ExIUBg1EsBp/pSYCCMbjDnXK30y2BxA=;
 b=mO6KtVwjWUNAK2Zajt0WQYMpkn6bgNcrnJX7Aq28c+zVwj2w6oxXdpTp6M3kB0DGDUhb
 l59UAQ6ha2TOW1HWoOX1e94l4VC6GXzjbKS2xvzYdIE2OQD0hFkutCAw/ljiW1z7V3FH
 trFsVXrUshSthCT5jJKa1leBmgM2gDh1XP5Ere/57ay6HXjyy2OVDOBJNUd9iNoUL8X6
 w1Xll4tNepU3UceYBolxg4guFWjB9IrweIW0iY68oeSYNe6qQSLAi+yyOuryDaafcBVU
 MyJi3ui2IBQvlZdfu64pzni48xfM9+UCjeaj2WQpgkYLvjZPzOihPi+q4CXSWqmsaDzL Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krdg4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 21:17:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKxA8Z184207;
        Wed, 20 May 2020 21:17:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t38um42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 21:17:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KLHIBW010533;
        Wed, 20 May 2020 21:17:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 14:17:17 -0700
Date:   Wed, 20 May 2020 14:17:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200520211716.GH17627@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
 <20200519125437.GA15081@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519125437.GA15081@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 05:54:37AM -0700, Christoph Hellwig wrote:
> The actual logic looks good, but I think the new helper and another
> third set of comment explaining what is going on makes this area even
> more confusing.  What about something like this instead?

This seems reasonable, but the callsite cleanups ought to be a separate
patch from the behavior change.

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bb590a267a7f9..26f9874361cd3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -352,22 +352,10 @@ xfs_quota_calc_throttle(
>  }
>  
>  /*
> - * If we are doing a write at the end of the file and there are no allocations
> - * past this one, then extend the allocation out to the file system's write
> - * iosize.
> - *
>   * If we don't have a user specified preallocation size, dynamically increase
>   * the preallocation size as the size of the file grows.  Cap the maximum size
>   * at a single extent or less if the filesystem is near full. The closer the
> - * filesystem is to full, the smaller the maximum prealocation.
> - *
> - * As an exception we don't do any preallocation at all if the file is smaller
> - * than the minimum preallocation and we are using the default dynamic
> - * preallocation scheme, as it is likely this is the only write to the file that
> - * is going to be done.
> - *
> - * We clean up any extra space left over when the file is closed in
> - * xfs_inactive().
> + * filesystem is to full, the smaller the maximum preallocation.
>   */
>  STATIC xfs_fsblock_t
>  xfs_iomap_prealloc_size(
> @@ -380,52 +368,58 @@ xfs_iomap_prealloc_size(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	struct xfs_bmbt_irec	prev;
> +	struct xfs_iext_cursor	ncur = *icur;
> +	struct xfs_bmbt_irec	prev, got;
>  	int			shift = 0;
>  	int64_t			freesp;
>  	xfs_fsblock_t		qblocks;
>  	int			qshift = 0;
> -	xfs_fsblock_t		alloc_blocks = 0;
> +	xfs_fsblock_t		alloc_blocks;
> +	xfs_extlen_t		plen;
>  
> -	if (offset + count <= XFS_ISIZE(ip))
> -		return 0;
> -
> -	if (!(mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
> -	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
> +	/*
> +	 * As an exception we don't do any preallocation at all if the file is
> +	 * smaller than the minimum preallocation and we are using the default
> +	 * dynamic preallocation scheme, as it is likely this is the only write
> +	 * to the file that is going to be done.
> +	 */
> +	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks))
>  		return 0;
>  
>  	/*
> -	 * If an explicit allocsize is set, the file is small, or we
> -	 * are writing behind a hole, then use the minimum prealloc:
> +	 * Otherwise use the minimum prealloca size for small files, or if we

"preallocation"?

> +	 * are writing right after a hole.
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
> -	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
> +	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> +	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
>  	    prev.br_startoff + prev.br_blockcount < offset_fsb)
>  		return mp->m_allocsize_blocks;
>  
>  	/*
> -	 * Determine the initial size of the preallocation. We are beyond the
> -	 * current EOF here, but we need to take into account whether this is
> -	 * a sparse write or an extending write when determining the
> -	 * preallocation size.  Hence we need to look up the extent that ends
> -	 * at the current write offset and use the result to determine the
> -	 * preallocation size.
> -	 *
> -	 * If the extent is a hole, then preallocation is essentially disabled.
> -	 * Otherwise we take the size of the preceding data extent as the basis
> -	 * for the preallocation size. If the size of the extent is greater than
> -	 * half the maximum extent length, then use the current offset as the
> -	 * basis. This ensures that for large files the preallocation size
> -	 * always extends to MAXEXTLEN rather than falling short due to things
> -	 * like stripe unit/width alignment of real extents.
> +	 * Take the size of the contiguous preceding data extents as the basis
> +	 * for the preallocation size.  Note that we don't care if the previous
> +	 * extents are written or not.
>  	 */
> -	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> -		alloc_blocks = prev.br_blockcount << 1;
> -	else
> +	plen = prev.br_blockcount;
> +	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> +		if (plen > MAXEXTLEN / 2 ||
> +		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
> +		    got.br_startblock + got.br_blockcount != prev.br_startblock)
> +			break;
> +		plen += got.br_blockcount;
> +		prev = got;
> +	}
> +
> +	/*
> +	 * If the size of the extents is greater than half the maximum extent
> +	 * length, then use the current offset as the basis.  This ensures that
> +	 * for large files the preallocation size always extends to MAXEXTLEN
> +	 * rather than falling short due to things like stripe unit/width
> +	 * alignment of real extents.
> +	 */
> +	alloc_blocks = plen * 2;
> +	if (alloc_blocks > MAXEXTLEN)
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
> -	if (!alloc_blocks)
> -		goto check_writeio;
>  	qblocks = alloc_blocks;
>  
>  	/*
> @@ -494,7 +488,6 @@ xfs_iomap_prealloc_size(
>  	 */
>  	while (alloc_blocks && alloc_blocks >= freesp)
>  		alloc_blocks >>= 4;
> -check_writeio:
>  	if (alloc_blocks < mp->m_allocsize_blocks)
>  		alloc_blocks = mp->m_allocsize_blocks;
>  	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
> @@ -961,9 +954,16 @@ xfs_buffered_write_iomap_begin(
>  	if (error)
>  		goto out_unlock;
>  
> -	if (eof) {
> -		prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork, offset,
> -				count, &icur);
> +	if (eof && offset + count > XFS_ISIZE(ip)) {
> +		/*
> +		 * Determine the initial size of the preallocation.
> + 		 * We clean up any extra preallocation when the file is closed.
> +		 */
> +		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
> +			prealloc_blocks = mp->m_allocsize_blocks;
> +		else
> +			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> +						offset, count, &icur);

I'm not sure how much we're really gaining from moving the
MOUNT_ALLOCSIZE check out to the caller, but I don't feel all that
passionate about this.

--D

>  		if (prealloc_blocks) {
>  			xfs_extlen_t	align;
>  			xfs_off_t	end_offset;
