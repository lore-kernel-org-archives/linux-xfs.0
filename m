Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D0EEED600
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 15:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbjIOPE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbjIOPEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 11:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9A62111
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 08:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694790192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lTZfA5rPlEfiTz4c92kcEKYabBvdtJsj3rwpq0qrzBM=;
        b=HgUW12ZI8rt0KwOCZpQ/BYLuAsOUw02ROx/PQB1lOWyvLV9TVbLDMIIDZIJsOHoe560rfB
        Y7i03RQ6T1JYdcFvuw4hIllDM0dZWC2NGMRvEP0mesWL52lm02yuKceiQ+5d9bilgW9ltF
        uA7yfqmkrGngPW/zJ/9bpI+jcg3GvwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-687-_ANoj1VnN2WU3lpoECSwCg-1; Fri, 15 Sep 2023 11:03:10 -0400
X-MC-Unique: _ANoj1VnN2WU3lpoECSwCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDE1F185A73B;
        Fri, 15 Sep 2023 15:03:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A18012156A27;
        Fri, 15 Sep 2023 15:03:09 +0000 (UTC)
Date:   Fri, 15 Sep 2023 10:03:08 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <ZQRyLLnvkEKbs5Wn@redhat.com>
References: <20230915102246.108709-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915102246.108709-1-cem@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 12:22:46PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> The current output message prints out a suggestion of an AG size to be
> used in lieu of the user-defined one.
> The problem is this suggestion is printed in filesystem blocks, without
> specifying the suffix to be used.
> 
> This patch tries to make user's life easier by outputing the option as
> it should be used by the mkfs, so users can just copy/paste it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
> 
> V2:
> 	- Keep printing it in FSBs, just add the agsize= and the 'b' suffix at
> 	  the end
> 
>  mkfs/xfs_mkfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d3a15cf44..b61934e57 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3179,9 +3179,9 @@ _("agsize rounded to %lld, sunit = %d\n"),
>  		if (cli_opt_set(&dopts, D_AGCOUNT) ||
>  		    cli_opt_set(&dopts, D_AGSIZE)) {
>  			printf(_(
> -"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
> -problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
> -an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
> +"Warning: AG size is a multiple of stripe width. This can cause performance\n\
> +problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
> +an AG size that is one stripe unit smaller or larger, for example: agsize=%llub\n"),
>  				(unsigned long long)cfg->agsize - dsunit);
>  			fflush(stdout);
>  			goto validate;
> -- 
> 2.39.2
> 

