Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F18C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 098B82078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jB5eODrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbgD3LDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:03:11 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28521 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbgD3LDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Qdr4C72zhkDpXntEDWAKWc57IZY3ko42Fwal1x0+DI=;
        b=jB5eODrlZqp4AByAPxcJGq5NrTy0q/2XqlWOO7CDCzW9LPvwxYft4uYTPLEF227p4s9pz+
        7AEVOsEpY1z5NSQ5K40hkegxyIe+C7YKpzJuydDdKtegDx5FREa4zqpkAfJdA679/zThln
        L52Zr1XVEk8tToKOKaC+uwHYpXokOOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-66fwTF2vOD68o3bghzgheA-1; Thu, 30 Apr 2020 07:03:04 -0400
X-MC-Unique: 66fwTF2vOD68o3bghzgheA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94A2C107ACF2;
        Thu, 30 Apr 2020 11:03:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3727B60C18;
        Thu, 30 Apr 2020 11:03:02 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:03:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: remove the xfs_efd_log_item_t typedef
Message-ID: <20200430110301.GB5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:02PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index b9b567f355756..a2a736a77fa94 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -63,12 +63,12 @@ struct xfs_efi_log_item {
>   * the fact that some extents earlier mentioned in an efi item
>   * have been freed.
>   */
> -typedef struct xfs_efd_log_item {
> +struct xfs_efd_log_item {
>  	struct xfs_log_item	efd_item;
>  	struct xfs_efi_log_item *efd_efip;
>  	uint			efd_next_extent;
>  	xfs_efd_log_format_t	efd_format;
> -} xfs_efd_log_item_t;
> +};
>  
>  /*
>   * Max number of extents in fast allocation path.
> -- 
> 2.26.2
> 

