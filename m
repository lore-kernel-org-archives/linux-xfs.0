Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125E0EEAA61
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 18:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbjINSZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239368AbjINSZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 14:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0445E1FD5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 11:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694715852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1erUW4zAj89mdsDDpYgBzktoY0KyeY0PG+gq8JUQLmY=;
        b=Ro+Nea42SQkj0J8Yz+lFibjdO350w1Tp3HyNwrqTeFghC8pMQLLdEnEDnxDUgh6ZzygFNI
        x86kkpLuF5SyKUGoOA8kSM283ODgl9pDuY1EDrJ6MXfj5iiVhQJ7k3lsHlQjDELOY3ruAJ
        fo2DO89mVnCRCevmaVRkPLxMegwW9CY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-VYH-MSeJOZyFMHsE5ibLMA-1; Thu, 14 Sep 2023 14:24:10 -0400
X-MC-Unique: VYH-MSeJOZyFMHsE5ibLMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09086800B23;
        Thu, 14 Sep 2023 18:24:10 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C79399A;
        Thu, 14 Sep 2023 18:24:09 +0000 (UTC)
Date:   Thu, 14 Sep 2023 13:24:08 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] libxfs: use XFS_IGET_CREATE when creating new files
Message-ID: <ZQNPyMJFdU6oFUYG@redhat.com>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <169454759296.3539425.5228393276062246709.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454759296.3539425.5228393276062246709.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use this flag to check that newly allocated inodes are, in fact,
> unallocated.  This matches the kernel, and prevents userspace programs
> from making latent corruptions worse by unintentionally crosslinking
> files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  libxfs/util.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index e7d3497ec96..8f79b0cd17b 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -260,7 +260,7 @@ libxfs_init_new_inode(
>  	unsigned int		flags;
>  	int			error;
>  
> -	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
> +	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
>  	if (error != 0)
>  		return error;
>  	ASSERT(ip != NULL);
> 

