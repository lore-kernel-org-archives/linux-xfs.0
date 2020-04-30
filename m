Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FE2C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A00207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bw5PlsOM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD3LDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:03:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbgD3LDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FGL/egImqa9ZoWOT7/86tuz4OCTjGEzRI1882RTiAg4=;
        b=bw5PlsOMtstK2CNPFhdogqHatWLa55eW/KiKVaIEdjopZJS3UJtJaF1YiSxGYXSbupusWk
        UVKAw0ZnQ4S4Qru51RyNr/XClTIvnQMBnzN8VCdvpuLidKiW9dZye3U1VIzwNBu2QbD/aI
        39+dSqJe7G+KCQ8WAfUBPwhGMjW4d78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-rd-DkTGiOmeqoW_9RhK-EQ-1; Thu, 30 Apr 2020 07:02:57 -0400
X-MC-Unique: rd-DkTGiOmeqoW_9RhK-EQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F33B107ACCD;
        Thu, 30 Apr 2020 11:02:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D0E196AE;
        Thu, 30 Apr 2020 11:02:55 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:02:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: remove the xfs_efi_log_item_t typedef
Message-ID: <20200430110253.GA5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:01PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.c |  2 +-
>  fs/xfs/xfs_extfree_item.h | 10 +++++-----
>  fs/xfs/xfs_log_recover.c  |  4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e2980..00309b81607cd 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -161,7 +161,7 @@ xfs_efi_init(
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(xfs_efi_log_item_t) +
> +		size = (uint)(sizeof(struct xfs_efi_log_item) +
>  			((nextents - 1) * sizeof(xfs_extent_t)));
>  		efip = kmem_zalloc(size, 0);
>  	} else {
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 16aaab06d4ecc..b9b567f355756 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -50,13 +50,13 @@ struct kmem_zone;
>   * of commit failure or log I/O errors. Note that the EFD is not inserted in the
>   * AIL, so at this point both the EFI and EFD are freed.
>   */
> -typedef struct xfs_efi_log_item {
> +struct xfs_efi_log_item {
>  	struct xfs_log_item	efi_item;
>  	atomic_t		efi_refcount;
>  	atomic_t		efi_next_extent;
>  	unsigned long		efi_flags;	/* misc flags */
>  	xfs_efi_log_format_t	efi_format;
> -} xfs_efi_log_item_t;
> +};
>  
>  /*
>   * This is the "extent free done" log item.  It is used to log
> @@ -65,7 +65,7 @@ typedef struct xfs_efi_log_item {
>   */
>  typedef struct xfs_efd_log_item {
>  	struct xfs_log_item	efd_item;
> -	xfs_efi_log_item_t	*efd_efip;
> +	struct xfs_efi_log_item *efd_efip;
>  	uint			efd_next_extent;
>  	xfs_efd_log_format_t	efd_format;
>  } xfs_efd_log_item_t;
> @@ -78,10 +78,10 @@ typedef struct xfs_efd_log_item {
>  extern struct kmem_zone	*xfs_efi_zone;
>  extern struct kmem_zone	*xfs_efd_zone;
>  
> -xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
> +struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
>  int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
>  					    xfs_efi_log_format_t *dst_efi_fmt);
> -void			xfs_efi_item_free(xfs_efi_log_item_t *);
> +void			xfs_efi_item_free(struct xfs_efi_log_item *);
>  void			xfs_efi_release(struct xfs_efi_log_item *);
>  
>  int			xfs_efi_recover(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b13..c81f71e2888cf 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3365,7 +3365,7 @@ xlog_recover_efd_pass2(
>  	struct xlog_recover_item	*item)
>  {
>  	xfs_efd_log_format_t	*efd_formatp;
> -	xfs_efi_log_item_t	*efip = NULL;
> +	struct xfs_efi_log_item	*efip = NULL;
>  	struct xfs_log_item	*lip;
>  	uint64_t		efi_id;
>  	struct xfs_ail_cursor	cur;
> @@ -3386,7 +3386,7 @@ xlog_recover_efd_pass2(
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	while (lip != NULL) {
>  		if (lip->li_type == XFS_LI_EFI) {
> -			efip = (xfs_efi_log_item_t *)lip;
> +			efip = (struct xfs_efi_log_item *)lip;
>  			if (efip->efi_format.efi_id == efi_id) {
>  				/*
>  				 * Drop the EFD reference to the EFI. This
> -- 
> 2.26.2
> 

