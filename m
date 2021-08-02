Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1840C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F32360EE6
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhHBWeM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhHBWeL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A05260F11;
        Mon,  2 Aug 2021 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627943638;
        bh=ZE6y4dJUttCnx7pvuCDWCtKFmUvDxzHWm3/eZp7ZQdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAxFutn1FnzopFv+Gw8BSh2JQ8B/bnrZkc22T9XG1D37vnbikLYpD6m8hPDrniymQ
         BULlrJM58wz1bXH+Gp2j9aLmggn4rvUHzZ1zVDIyi3hDpbgP5YbllKm2XNMcm/JMpb
         g3cuH182jv4XMmEH5NkwAgPknSYJI6Feu4qJE+4AweIiKaLvjvWmx+vSECMQ+VNtyH
         BcekWKC+BB8RV2/wu1XyoqU/rASY1t/633I2KueDhHv1L9kPgBqDfqEz3oeLPQOClI
         2iWQsV6jvpVLWSDRF3PChMVciGoPqqDI1+gwVKlRiZt7+79h5rNUmrtr81QHxhlN81
         aRkkIsTKx/3hg==
Date:   Mon, 2 Aug 2021 15:33:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfsprogs: Rename platform.h -> common.h
Message-ID: <20210802223358.GK3601466@magnolia>
References: <20210802215024.949616-1-preichl@redhat.com>
 <20210802215024.949616-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802215024.949616-3-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 02, 2021 at 11:50:18PM +0200, Pavel Reichl wrote:
> No other platform then linux is supported so rename to something more
> common.
> ---
>  copy/xfs_copy.c                  | 2 +-
>  libfrog/{platform.h => common.h} | 0

This is confusing, we already have a scrub/common.h.  Renaming files
breaks git blame; why change them?

--D

>  libfrog/topology.c               | 2 +-
>  libxfs/init.c                    | 2 +-
>  libxfs/rdwr.c                    | 2 +-
>  repair/xfs_repair.c              | 2 +-
>  6 files changed, 5 insertions(+), 5 deletions(-)
>  rename libfrog/{platform.h => common.h} (100%)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index fc7d225f..c80b42d1 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -12,7 +12,7 @@
>  #include <stdarg.h>
>  #include "xfs_copy.h"
>  #include "libxlog.h"
> -#include "libfrog/platform.h"
> +#include "libfrog/common.h"
>  
>  #define	rounddown(x, y)	(((x)/(y))*(y))
>  #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
> diff --git a/libfrog/platform.h b/libfrog/common.h
> similarity index 100%
> rename from libfrog/platform.h
> rename to libfrog/common.h
> diff --git a/libfrog/topology.c b/libfrog/topology.c
> index b1b470c9..b059829e 100644
> --- a/libfrog/topology.c
> +++ b/libfrog/topology.c
> @@ -11,7 +11,7 @@
>  #endif /* ENABLE_BLKID */
>  #include "xfs_multidisk.h"
>  #include "topology.h"
> -#include "platform.h"
> +#include "common.h"
>  
>  #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
>  #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 1ec83791..d1e87002 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -21,7 +21,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
> -#include "libfrog/platform.h"
> +#include "libfrog/common.h"
>  
>  #include "libxfs.h"		/* for now */
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index fd456d6b..f8e4cf0a 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -17,7 +17,7 @@
>  #include "xfs_inode_fork.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "libfrog/platform.h"
> +#include "libfrog/common.h"
>  
>  #include "libxfs.h"
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 38406eea..af24b356 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -23,7 +23,7 @@
>  #include "slab.h"
>  #include "rmap.h"
>  #include "libfrog/fsgeom.h"
> -#include "libfrog/platform.h"
> +#include "libfrog/common.h"
>  #include "bulkload.h"
>  #include "quotacheck.h"
>  
> -- 
> 2.31.1
> 
