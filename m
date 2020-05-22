Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E459C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 11:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324CF206F6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 11:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aH0GGoMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgEVL1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 07:27:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728281AbgEVL13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 07:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590146847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XGIhDWQJsHI/nKiAc4WmLzzdpbO8HuOLwxrJcs4x2Ss=;
        b=aH0GGoMFtXv+Jys0TEFHq9AVAJ9g+Dhy9ZPeFufgpf6WRafY5WhaKwasCcgnMWd5P6fiiS
        nMwJJcHrsFbcyNgUzHLTln5qCFoQLsRaPEJmHOvbCeQlOsz/LBtb2FKpV/925WwNzGOZNO
        9Tub/tEGrCELdwv9b/j4YVtNSSxLTzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-Hfu5kwaoNE2AB7o-iaerqQ-1; Fri, 22 May 2020 07:27:26 -0400
X-MC-Unique: Hfu5kwaoNE2AB7o-iaerqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F64E474;
        Fri, 22 May 2020 11:27:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4ED934668;
        Fri, 22 May 2020 11:27:24 +0000 (UTC)
Date:   Fri, 22 May 2020 07:27:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200522112722.GA50656@bfoster>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011598984.76931.15076402801787913960.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011598984.76931.15076402801787913960.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:09PM -0700, Darrick J. Wong wrote:
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
>  fs/xfs/xfs_iomap.c |   37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ac970b13b1f8..6a308af93893 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
>  	loff_t			count,
>  	struct xfs_iext_cursor	*icur)
>  {
> +	struct xfs_iext_cursor	ncur = *icur; /* struct copy */
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
> @@ -413,16 +415,27 @@ xfs_iomap_prealloc_size(
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

If prev is initialized by peeking the previous extent, then it looks
like the first iteration of this loop compares the immediately previous
extent with itself..

> +	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> +		if (plen > MAXEXTLEN / 2 ||
> +		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
> +		    got.br_startblock + got.br_blockcount != prev.br_startblock)

We should probably check for nullstartblock (delalloc) extents
explicitly here rather than rely on the calculation to fail.

> +			break;
> +		plen += got.br_blockcount;



> +		prev = got;
> +	}
> +	alloc_blocks = plen * 2;

Why do we replace the bit shifts with division/multiplication? I'd
prefer to see the former for obvious power of 2 operations, even if this
happens to be 32-bit arithmetic. I don't see any particular reason to
change it in this patch.

Brian

> +	if (alloc_blocks > MAXEXTLEN)
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	if (!alloc_blocks)
>  		goto check_writeio;
> 

