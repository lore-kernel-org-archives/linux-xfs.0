Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F491C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4476061106
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 03:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhKDDQt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 23:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhKDDQt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 23:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F265460EDF;
        Thu,  4 Nov 2021 03:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635995652;
        bh=eso8ac1L7/RXTUEsVzcedJdK9dqpZbzf9/GHunOQV88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jLenE8fr7lhc7RiwwrnVNWsVOnMKb9j0y0Jv56zOaZuMUxRu6P5b9c8vHrAjYHqpK
         RXPQ9hJ/0OLKdeyZ7jc7E7pMqP//NM1CK2IHjLR7R/jgjccNYiYebRXA1RSGSple3D
         4lW6I+77+u5H+Z6+G/yuMwzgvCVfzn0h5j1SCCnSQ4Tl8xKSdavY/u9KHIQ31wSGWb
         Drc7Zf+FbXaULUds9rp68Ok843qx49KLB785SIuhPYszzy9LUaPB3qvDz30J+01C2p
         Zm7r/ufGxMgO6gJKB2TGS1yOJJl7y7hoDgHHBMXzMYZiigU5bN3VoVbYyYHTc9SUee
         l4Fqm0EH7dOLQ==
Date:   Wed, 3 Nov 2021 20:14:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
Message-ID: <20211104031411.GS24307@magnolia>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <7fe17d89-749d-7114-1f4f-294aba1e3f1d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe17d89-749d-7114-1f4f-294aba1e3f1d@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 03, 2021 at 09:59:57PM -0500, Eric Sandeen wrote:
> Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
> libxfs code and should not have userspace shims in it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: fix spdx and copyright
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 24424d0e..64b44af8 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -11,6 +11,7 @@
>  #include "platform_defs.h"
>  #include "xfs.h"
> +#include "stubs.h"
>  #include "list.h"
>  #include "hlist.h"
>  #include "cache.h"
> diff --git a/include/stubs.h b/include/stubs.h
> new file mode 100644
> index 00000000..d80e8de0
> --- /dev/null
> +++ b/include/stubs.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef STUBS_H
> +#define STUBS_H
> +
> +/* Stub out unimplemented and unneeded kernel functions */
> +struct rb_root {
> +};
> +
> +#define RB_ROOT 		(struct rb_root) { }

Please to remove  ^ this unnecessary space.

> +
> +typedef struct wait_queue_head {
> +} wait_queue_head_t;
> +
> +#define init_waitqueue_head(wqh)	do { } while(0)
> +
> +struct rhashtable {
> +};
> +
> +struct delayed_work {
> +};
> +
> +#define INIT_DELAYED_WORK(work, func)	do { } while(0)
> +#define cancel_delayed_work_sync(work)	do { } while(0)
> +
> +#endif

This probably ought to be '#endif /* STUBS_H */' just to keep it clear
which #ifdef it goes with.

With those two things fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 15bae1ff..32271c66 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -41,6 +41,7 @@
>  #include "platform_defs.h"
>  #include "xfs.h"
> +#include "stubs.h"
>  #include "list.h"
>  #include "hlist.h"
>  #include "cache.h"
> diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
> index bafee48c..25c4cab5 100644
> --- a/libxfs/xfs_shared.h
> +++ b/libxfs/xfs_shared.h
> @@ -180,24 +180,4 @@ struct xfs_ino_geometry {
>  };
> -/* Faked up kernel bits */
> -struct rb_root {
> -};
> -
> -#define RB_ROOT 		(struct rb_root) { }
> -
> -typedef struct wait_queue_head {
> -} wait_queue_head_t;
> -
> -#define init_waitqueue_head(wqh)	do { } while(0)
> -
> -struct rhashtable {
> -};
> -
> -struct delayed_work {
> -};
> -
> -#define INIT_DELAYED_WORK(work, func)	do { } while(0)
> -#define cancel_delayed_work_sync(work)	do { } while(0)
> -
>  #endif /* __XFS_SHARED_H__ */
> 
