Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C66C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00799206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUxq9khv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEZNqz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 09:46:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEZNqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 09:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590500813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lj6QWa/ZOMDZy4DUbZL61YrwcgTi7xS7y+DCCEiMmCA=;
        b=WUxq9khvQpJPowTWwhoWuxYU1175JdjELeHHSo52M6b/ChbVnX7kuRyZczNM/JpTo/497b
        JUvMR0SinCOmNmWXaoBRf5NrUR0JO5Rm+mPHdjk1FS5W2WzgyJaLUv/y+2dJtSNNIS8RMa
        8JCru7zqzu4GyAU2+WFtGjtXdeHa5pE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-Fk724XiaN8eSD9iuBhRglA-1; Tue, 26 May 2020 09:46:50 -0400
X-MC-Unique: Fk724XiaN8eSD9iuBhRglA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E2BA108BD0C;
        Tue, 26 May 2020 13:46:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A84760BEC;
        Tue, 26 May 2020 13:46:48 +0000 (UTC)
Date:   Tue, 26 May 2020 09:46:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200526134646.GA5462@bfoster>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025258515.493629.3176219395358340970.stgit@magnolia>
 <20200524171612.GG8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524171612.GG8230@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 10:16:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're estimating a new speculative preallocation length for an
> extending write, we should walk backwards through the extent list to
> determine the number of number of blocks that are physically and
> logically contiguous with the write offset, and use that as an input to
> the preallocation size computation.
> 
> This way, preallocation length is truly measured by the effectiveness of
> the allocator in giving us contiguous allocations without being
> influenced by the state of a given extent.  This fixes both the problem
> where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> the unnecessary shrinkage of preallocation when delalloc extents are
> turned into unwritten extents.
> 
> This was found as a regression in xfs/014 after changing delalloc writes
> to create unwritten extents during writeback.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: multiplication instead of lshift
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c |   40 +++++++++++++++++++++++++++-------------
>  1 file changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7d8966ce630a..e74a8c2c94ce 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
>  	loff_t			count,
>  	struct xfs_iext_cursor	*icur)
>  {
> +	struct xfs_iext_cursor	ncur = *icur;
> +	struct xfs_bmbt_irec	prev, got;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	struct xfs_bmbt_irec	prev;
> -	int			shift = 0;
>  	int64_t			freesp;
>  	xfs_fsblock_t		qblocks;
> -	int			qshift = 0;
>  	xfs_fsblock_t		alloc_blocks = 0;
> +	xfs_extlen_t		plen;
> +	int			shift = 0;
> +	int			qshift = 0;
>  
>  	if (offset + count <= XFS_ISIZE(ip))
>  		return 0;
> @@ -400,7 +402,7 @@ xfs_iomap_prealloc_size(
>  	 */
>  	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
> +	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
>  	    prev.br_startoff + prev.br_blockcount < offset_fsb)
>  		return mp->m_allocsize_blocks;
>  
> @@ -413,16 +415,28 @@ xfs_iomap_prealloc_size(
>  	 * preallocation size.
>  	 *
>  	 * If the extent is a hole, then preallocation is essentially disabled.
> -	 * Otherwise we take the size of the preceding data extent as the basis
> -	 * for the preallocation size. If the size of the extent is greater than
> -	 * half the maximum extent length, then use the current offset as the
> -	 * basis. This ensures that for large files the preallocation size
> -	 * always extends to MAXEXTLEN rather than falling short due to things
> -	 * like stripe unit/width alignment of real extents.
> +	 * Otherwise we take the size of the preceding data extents as the basis
> +	 * for the preallocation size. Note that we don't care if the previous
> +	 * extents are written or not.
> +	 *
> +	 * If the size of the extents is greater than half the maximum extent
> +	 * length, then use the current offset as the basis. This ensures that
> +	 * for large files the preallocation size always extends to MAXEXTLEN
> +	 * rather than falling short due to things like stripe unit/width
> +	 * alignment of real extents.
>  	 */
> -	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> -		alloc_blocks = prev.br_blockcount << 1;
> -	else
> +	plen = prev.br_blockcount;
> +	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> +		if (plen > MAXEXTLEN / 2 ||
> +		    isnullstartblock(got.br_startblock) ||
> +		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
> +		    got.br_startblock + got.br_blockcount != prev.br_startblock)
> +			break;
> +		plen += got.br_blockcount;
> +		prev = got;
> +	}
> +	alloc_blocks = plen * 2;
> +	if (alloc_blocks > MAXEXTLEN)
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	if (!alloc_blocks)
>  		goto check_writeio;
> 

