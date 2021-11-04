Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3635C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0088610FC
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhKDCbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhKDCbD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 22:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685F361073;
        Thu,  4 Nov 2021 02:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635992906;
        bh=bJsaWChbSErt27Vdf6GTN4+QCCS2x4ET0sKVwZHMiYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ttNcbFaVUa7S/1I5kj4UrUgZ4boHRneCFbhO+W2lpgEBufTCwOgkdRgGraiGsCWB7
         eu1IANBrOO9qozej9QWK4Hapt6m7lmn7FzFgj/nQimCLeJIp18RRZvZlUzei93bWfc
         xRAxT3xpv3Gm78dz4K6AI43YIQheu73Jcv+hOiUhUkBrPXY0KJsQ5KHHkaLvCFlxwI
         xLlCd5PQ/RazpiVKKIsnEXOwWT9a+mvGCmWiRWCVfY9UMwYbip6l3AlFEXXbYo/K4H
         jcS9hnGB2IaAFIHjKEtsLiNQpcr9n/J68qsmO9TtJD9aR4nO62HHBJ7o7aqs+2olGe
         7G1ewEZSnBa9Q==
Date:   Wed, 3 Nov 2021 19:28:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: move stubbed-out kernel functions out of
 xfs_shared.h
Message-ID: <20211104022826.GR24307@magnolia>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 03, 2021 at 09:21:35PM -0500, Eric Sandeen wrote:
> Move kernel stubs out of libxfs/xfs_shared.h, which is kernel
> libxfs code and should not have userspace shims in it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
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
> index 00000000..41eaa0c4
> --- /dev/null
> +++ b/include/stubs.h
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0

This needs a C-style (not C++-style) comment for SPDX compliance.

(I still don't get why the committee who came up with SPDX required C++
style comments for C code...)

> +

Needs a copyright statement too.

> +/*
> + * Stub out unimplemented and unneeded kernel structures etc
> + */
> +#ifndef STUBS_H
> +#define STUBS_H
> +
> +struct rb_root {
> +};
> +
> +#define RB_ROOT 		(struct rb_root) { }

Space after 'T' and before '('.

--D

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
