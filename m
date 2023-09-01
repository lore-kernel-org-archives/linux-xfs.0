Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5ABCA0FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 15:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbjIAPOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbjIAPOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 11:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00ED94
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 08:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693581238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=84CoR05ft3YU6ZjrZFAy3aDhwrFjQ3Cd0TcRqUBl1rI=;
        b=TlPw4GLfBBizRlVfPbyMm9A17VcNJWOd7RnRjAwXzbf4vpgzTur5dKlAGluBT8FYeTu0j5
        i/5BdnXmRkS++U/7IJgOAoaMHbXf+zD0qbw5Z1X92V89nw5ysG5iYxp8J0RGOjeg4GeeC+
        VNrfc4zX9b8cGbLSMORINfhAJX9FjaU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-gVaCR3qNP2eWEHREYjpv-Q-1; Fri, 01 Sep 2023 11:13:55 -0400
X-MC-Unique: gVaCR3qNP2eWEHREYjpv-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 577281C18C70;
        Fri,  1 Sep 2023 15:13:55 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23B3AD47819;
        Fri,  1 Sep 2023 15:13:55 +0000 (UTC)
Date:   Fri, 1 Sep 2023 10:13:53 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: require a relatively recent V5 filesystem for LARP
 mode
Message-ID: <ZPH/sV8y77RJ6iqn@redhat.com>
References: <20230901050739.GO28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901050739.GO28186@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 31, 2023 at 10:07:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the FIEXCHANGE code in XFS, I realized that the function
> that enables logged xattrs doesn't actually check that the superblock
> has a LOG_INCOMPAT feature bit field.  Add a check to refuse the
> operation if we don't have a V5 filesystem...
> 
> ...but on second though, let's require either reflink or rmap so that we
> only have to deal with LARP mode on relatively /modern/ kernel.  4.14 is
> about as far back as I feel like going.
> 
> Seeing as LARP is a debugging-only option anyway, this isn't likely to
> affect any real users.
> 
> Fixes: d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c")
> Really-Fixes: f3f36c893f26 ("xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  fs/xfs/xfs_xattr.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 43e5c219aaed..a3975f325f4e 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -46,6 +46,17 @@ xfs_attr_grab_log_assist(
>  	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
>  		return 0;
>  
> +	/*
> +	 * Check if the filesystem featureset is new enough to set this log
> +	 * incompat feature bit.  Strictly speaking, the minimum requirement is
> +	 * a V5 filesystem for the superblock field, but we'll require rmap
> +	 * or reflink to avoid having to deal with really old kernels.
> +	 */
> +	if (!xfs_has_reflink(mp) && !xfs_has_rmapbt(mp)) {
> +		error = -EOPNOTSUPP;
> +		goto drop_incompat;
> +	}
> +
>  	/* Enable log-assisted xattrs. */
>  	error = xfs_add_incompat_log_feature(mp,
>  			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> 

