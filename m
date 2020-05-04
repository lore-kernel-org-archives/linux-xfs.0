Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87E9C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E8B2073E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iwGfpn40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgEDN1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 09:27:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgEDN1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 09:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588598858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5zZ5GsQDacPxevlvMah/s1gaQYsV9KMZLsiSWVUeVE=;
        b=iwGfpn40dRVejACgjBv0pKD9dW9p3boJspbnlYntF+bjtgq21htN3oNhVmyX6VmANMDop1
        GXoIzASMuvH9GDs6aJv50Txl5TOFNNqTc01PQuWE6Z1mMBgbmSe2Z0n/AKRf8gusS/iAYf
        H3hB/SuDk9Tvm/VsYoIYhkVIJaOlUrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-prIwAAIPPnuOF6GXhhA9oA-1; Mon, 04 May 2020 09:27:33 -0400
X-MC-Unique: prIwAAIPPnuOF6GXhhA9oA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D422107ACF3;
        Mon,  4 May 2020 13:27:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01C3C385;
        Mon,  4 May 2020 13:27:31 +0000 (UTC)
Date:   Mon, 4 May 2020 09:27:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 11/24] xfs: Pull up xfs_attr_rmtval_invalidate
Message-ID: <20200504132730.GB54625@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-12-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:03PM -0700, Allison Collins wrote:
> This patch pulls xfs_attr_rmtval_invalidate out of
> xfs_attr_rmtval_remove and into the calling functions.  Eventually
> __xfs_attr_rmtval_remove will replace xfs_attr_rmtval_remove when we
> introduce delayed attributes.  These functions are exepcted to return
> -EAGAIN when they need a new transaction.  Because the invalidate does
> not need a new transaction, we need to separate it from the rest of the
> function that does.  This will enable __xfs_attr_rmtval_remove to
> smoothly replace xfs_attr_rmtval_remove later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c        | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.c |  3 ---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0fc6436..4fdfab9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -669,6 +669,10 @@ xfs_attr_leaf_addname(
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				return error;
> +
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
>  				return error;
> @@ -1027,6 +1031,10 @@ xfs_attr_node_addname(
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				return error;
> +
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
>  				return error;
> @@ -1152,6 +1160,10 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 02d1a44..f770159 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -685,9 +685,6 @@ xfs_attr_rmtval_remove(
>  
>  	trace_xfs_attr_rmtval_remove(args);
>  
> -	error = xfs_attr_rmtval_invalidate(args);
> -	if (error)
> -		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
> -- 
> 2.7.4
> 

