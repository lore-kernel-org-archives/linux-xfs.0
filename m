Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C7EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC2120720
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uej2L97k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404545AbgFYM0u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:26:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404343AbgFYM0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMZdlTy7bSBVP+qOhCwUf0mO2Kz6DrjJ8SssTqMmMI8=;
        b=Uej2L97kAcOvrAWQ/ZvON6Qopo7O11d/KofymtdbUB3MMP/8Mp17pjPIU+lhdE3CQK70Bc
        BZGI0lVJmDkyUJcfXp5Y9aZegZY/WDAnzkBRtsJ7U7psKLzhrKAjupwnSXGjCdPrKbKUSG
        KxZoojepBQ5C4KnMZcOiZEfFrW7hCdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-roKuxMeGOi-A5U8hTh9PXA-1; Thu, 25 Jun 2020 08:26:46 -0400
X-MC-Unique: roKuxMeGOi-A5U8hTh9PXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7D1FEC1BC;
        Thu, 25 Jun 2020 12:26:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40819101E69A;
        Thu, 25 Jun 2020 12:26:45 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:26:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 2/9] xfs: rename xfs_bmap_is_real_extent to
 is_written_extent
Message-ID: <20200625122643.GD2863@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304787204.874036.10765296473918147829.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304787204.874036.10765296473918147829.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:17:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The name of this predicate is a little misleading -- it decides if the
> extent mapping is allocated and written.  Change the name to be more
> direct, as we're going to add a new predicate in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.h     |    2 +-
>  fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
>  fs/xfs/xfs_reflink.c         |    6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6028a3c825ba..2b18338d0643 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>   * Return true if the extent is a real, allocated extent, or false if it is  a
>   * delayed allocation, and unwritten extent or a hole.
>   */
> -static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> +static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
>  {
>  	return irec->br_state != XFS_EXT_UNWRITTEN &&
>  		irec->br_startblock != HOLESTARTBLOCK &&
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 9498ced947be..1d9fa8a300f1 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -70,7 +70,7 @@ xfs_rtbuf_get(
>  	if (error)
>  		return error;
>  
> -	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map)))
> +	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
>  		return -EFSCORRUPTED;
>  
>  	ASSERT(map.br_startblock != NULLFSBLOCK);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d89201d40891..22fdea6d69d3 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -179,7 +179,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
> +	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> @@ -655,7 +655,7 @@ xfs_reflink_end_cow_extent(
>  	 * preallocations can leak into the range we are called upon, and we
>  	 * need to skip them.
>  	 */
> -	if (!xfs_bmap_is_real_extent(&got)) {
> +	if (!xfs_bmap_is_written_extent(&got)) {
>  		*end_fsb = del.br_startoff;
>  		goto out_cancel;
>  	}
> @@ -996,7 +996,7 @@ xfs_reflink_remap_extent(
>  	xfs_off_t		new_isize)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	bool			real_extent = xfs_bmap_is_real_extent(irec);
> +	bool			real_extent = xfs_bmap_is_written_extent(irec);
>  	struct xfs_trans	*tp;
>  	unsigned int		resblks;
>  	struct xfs_bmbt_irec	uirec;
> 

