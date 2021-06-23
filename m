Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BB2C48BC2
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 20:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1475961185
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 20:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFWUDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWUC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jun 2021 16:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624478441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=74G7V0NaDAlSHJmJyNIwWqG5hFIFpXxTprhyHoIX2Ng=;
        b=SfTeUaolwEVfoumlr/aFdS+1tntwlTwBcSVTGZQi/72w7zROfA5NLFMBhp4bU6Nmbfiskh
        1g6m4pQHIR39YA4uFrPd7MPfTvg6GItJtuL6mTX+W42OPc+dt6ln64nC+P6XXQiGkbFly/
        CK5x0GEDHff+cq/+B/N4zF2Hzzqw4CY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-mGomAtyyP4yMDyVUXfn3LA-1; Wed, 23 Jun 2021 16:00:39 -0400
X-MC-Unique: mGomAtyyP4yMDyVUXfn3LA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78562100C661;
        Wed, 23 Jun 2021 20:00:38 +0000 (UTC)
Received: from redhat.com (ovpn-115-10.rdu2.redhat.com [10.10.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2041A19D9F;
        Wed, 23 Jun 2021 20:00:38 +0000 (UTC)
Date:   Wed, 23 Jun 2021 15:00:36 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Initialize error in xfs_attr_remove_iter
Message-ID: <20210623200036.dlhqq4aou4eoeqxa@redhat.com>
References: <20210622210852.9511-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622210852.9511-1-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:08:52PM -0700, Allison Henderson wrote:
> A recent bug report generated a warning that a code path in
> xfs_attr_remove_iter could potentially return error uninitialized in the
> case of XFS_DAS_RM_SHRINK state.  Fix this by initializing error.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 611dc67..d9d7d51 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1375,7 +1375,7 @@ xfs_attr_remove_iter(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = dac->da_state;
> -	int				retval, error;
> +	int				retval, error = 0;
>  	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> -- 
> 2.7.4
> 

