Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D653DEEAA5D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 18:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbjINSVr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjINSVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 14:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A061BE5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694715652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sQctSz3EGzn/CDg6SjblJ9Pt6/T8AuLqGiG3EHLfxQ=;
        b=GT0nLQPn3rxwbsRUIvhwHflXxPHI3Lgn2mnst9VKQLt6hLzsaIDF3+AnJCSrRV2qzs+y7w
        Sq9rDgP4Jv7XHjIzF4MLJDXwZF3TU8k3pp8MdzeLA72WKov+SArNvj6F++Yy31lXc/95MY
        y8BpgoCptMo9KoHQd0jVrM0mlzvYf40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-Ab3Gl2CcMviiaM4SYXiXGw-1; Thu, 14 Sep 2023 14:20:48 -0400
X-MC-Unique: Ab3Gl2CcMviiaM4SYXiXGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A212800D8E;
        Thu, 14 Sep 2023 18:20:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E20A040C2070;
        Thu, 14 Sep 2023 18:20:47 +0000 (UTC)
Date:   Thu, 14 Sep 2023 13:20:46 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <ZQNO/sSzH0GlXztK@redhat.com>
References: <20230914123640.79682-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914123640.79682-1-cem@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 14, 2023 at 02:36:40PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> The current output message prints out a suggestion of an AG size to be
> used in lieu of the user-defined one.
> The problem is this suggestion is printed in filesystem blocks, while
> agsize= option receives a size in bytes (or m, g).
> 
> This patch tries to make user's life easier by outputing the suggesting
> in bytes directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d3a15cf44..827d5b656 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3179,9 +3179,11 @@ _("agsize rounded to %lld, sunit = %d\n"),
>  		if (cli_opt_set(&dopts, D_AGCOUNT) ||
>  		    cli_opt_set(&dopts, D_AGSIZE)) {
>  			printf(_(
> -"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
> -problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
> -an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
> +"Warning: AG size is a multiple of stripe width. This can cause performance\n\
> +problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
> +an AG size that is one stripe unit smaller or larger,\n\
> +for example: agsize=%llu (%llu blks).\n"),
> +				(unsigned long long)((cfg->agsize - dsunit) * cfg->blocksize),
>  				(unsigned long long)cfg->agsize - dsunit);
>  			fflush(stdout);
>  			goto validate;
> -- 
> 2.39.2
> 

