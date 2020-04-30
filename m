Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2789C8300B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9571C20757
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZImkden"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgD3LEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726636AbgD3LEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZziUmVvDT3VSZ6foLoomoes9DBVOR0IMkjV49I0TSs0=;
        b=DZImkden7mVBPMRAHLb6BNMJJLVfBvQa0OOqlhGdfpzaKPFPR2813MFc+NojQmgIzzoEv5
        3A23zn5vDldPEb+FvD00oLPZhL6WfbuF7tDR/4x0S2vHI+hSrnJwrviKTlQLYRBvMMYxWi
        FvnvpRwuVZa+p69fzdWTwBFe8hxKDvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-d6ohCMt6OC2UEcFJxPqhWQ-1; Thu, 30 Apr 2020 07:04:51 -0400
X-MC-Unique: d6ohCMt6OC2UEcFJxPqhWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63D581005510;
        Thu, 30 Apr 2020 11:04:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA76F5C1B0;
        Thu, 30 Apr 2020 11:04:49 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: spell out the parameter name for ->cancel_item
Message-ID: <20200430110447.GK5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-12-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:11PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index f2b65981bace4..3bf7c2c4d8514 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -53,7 +53,7 @@ struct xfs_defer_op_type {
>  			struct list_head *item, struct xfs_btree_cur **state);
>  	void (*finish_cleanup)(struct xfs_trans *tp,
>  			struct xfs_btree_cur *state, int error);
> -	void (*cancel_item)(struct list_head *);
> +	void (*cancel_item)(struct list_head *item);
>  	unsigned int		max_items;
>  };
>  
> -- 
> 2.26.2
> 

