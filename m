Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD161C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 902C3208A9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:47:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qxfbqard"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgEZNrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 09:47:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24670 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbgEZNrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 09:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590500824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cjvnMK0418wEKyzy21neiB1jctudOYI7ItQnlw1+pLg=;
        b=QxfbqardziDuSaOjaWjMTCCLYlU/9JZmq1MfJb4X3Dym64msE89/k/CehhQsP7jVkkTYub
        EA+oAmu/h+wkg50Xazt0Llr3zWvhID59IqnPRgYs9CClBMyrrnNo2YhrGEdEw+pMWhfkFJ
        dpgtLjLf5K9YGuFELxGTRBOSuwAQ2xI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-BSXvXThqMSuFeYy-4KjN5g-1; Tue, 26 May 2020 09:46:56 -0400
X-MC-Unique: BSXvXThqMSuFeYy-4KjN5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0825100CCD3;
        Tue, 26 May 2020 13:46:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CCCC6EDAA;
        Tue, 26 May 2020 13:46:55 +0000 (UTC)
Date:   Tue, 26 May 2020 09:46:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: refactor xfs_iomap_prealloc_size
Message-ID: <20200526134653.GB5462@bfoster>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025259150.493629.14462334296980108072.stgit@magnolia>
 <20200524171709.GI8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524171709.GI8230@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 10:17:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_iomap_prealloc_size to be the function that dynamically
> computes the per-file preallocation size by moving the allocsize= case
> to the caller.  Break up the huge comment preceding the function to
> annotate the relevant parts of the code, and remove the impossible
> check_writeio case.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v2: minor rebase due to changes in previous patch
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c |   83 ++++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e74a8c2c94ce..b9a8c3798e08 100644
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
> + * filesystem is to being full, the smaller the maximum preallocation.
>   */
>  STATIC xfs_fsblock_t
>  xfs_iomap_prealloc_size(
> @@ -389,41 +377,28 @@ xfs_iomap_prealloc_size(
>  	int			shift = 0;
>  	int			qshift = 0;
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
> +	 * Use the minimum preallocation size for small files or if we are
> +	 * writing right after a hole.
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
> -	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> +	if (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
>  	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
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
> -	 * Otherwise we take the size of the preceding data extents as the basis
> -	 * for the preallocation size. Note that we don't care if the previous
> -	 * extents are written or not.
> -	 *
> -	 * If the size of the extents is greater than half the maximum extent
> -	 * length, then use the current offset as the basis. This ensures that
> -	 * for large files the preallocation size always extends to MAXEXTLEN
> -	 * rather than falling short due to things like stripe unit/width
> -	 * alignment of real extents.
> +	 * Take the size of the preceding data extents as the basis for the
> +	 * preallocation size. Note that we don't care if the previous extents
> +	 * are written or not.
>  	 */
>  	plen = prev.br_blockcount;
>  	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> @@ -435,19 +410,25 @@ xfs_iomap_prealloc_size(
>  		plen += got.br_blockcount;
>  		prev = got;
>  	}
> +
> +	/*
> +	 * If the size of the extents is greater than half the maximum extent
> +	 * length, then use the current offset as the basis.  This ensures that
> +	 * for large files the preallocation size always extends to MAXEXTLEN
> +	 * rather than falling short due to things like stripe unit/width
> +	 * alignment of real extents.
> +	 */
>  	alloc_blocks = plen * 2;
>  	if (alloc_blocks > MAXEXTLEN)
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
> -	if (!alloc_blocks)
> -		goto check_writeio;
>  	qblocks = alloc_blocks;
>  
>  	/*
>  	 * MAXEXTLEN is not a power of two value but we round the prealloc down
>  	 * to the nearest power of two value after throttling. To prevent the
> -	 * round down from unconditionally reducing the maximum supported prealloc
> -	 * size, we round up first, apply appropriate throttling, round down and
> -	 * cap the value to MAXEXTLEN.
> +	 * round down from unconditionally reducing the maximum supported
> +	 * prealloc size, we round up first, apply appropriate throttling,
> +	 * round down and cap the value to MAXEXTLEN.
>  	 */
>  	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
>  				       alloc_blocks);
> @@ -508,7 +489,6 @@ xfs_iomap_prealloc_size(
>  	 */
>  	while (alloc_blocks && alloc_blocks >= freesp)
>  		alloc_blocks >>= 4;
> -check_writeio:
>  	if (alloc_blocks < mp->m_allocsize_blocks)
>  		alloc_blocks = mp->m_allocsize_blocks;
>  	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
> @@ -975,9 +955,16 @@ xfs_buffered_write_iomap_begin(
>  	if (error)
>  		goto out_unlock;
>  
> -	if (eof) {
> -		prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork, offset,
> -				count, &icur);
> +	if (eof && offset + count > XFS_ISIZE(ip)) {
> +		/*
> +		 * Determine the initial size of the preallocation.
> +		 * We clean up any extra preallocation when the file is closed.
> +		 */
> +		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
> +			prealloc_blocks = mp->m_allocsize_blocks;
> +		else
> +			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> +						offset, count, &icur);
>  		if (prealloc_blocks) {
>  			xfs_extlen_t	align;
>  			xfs_off_t	end_offset;
> 

