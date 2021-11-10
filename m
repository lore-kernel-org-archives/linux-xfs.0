Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C1AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 04:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 071D46117A
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 04:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhKJE3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 23:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhKJE3W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Nov 2021 23:29:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23C860E93;
        Wed, 10 Nov 2021 04:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636518395;
        bh=dXmJFaJ13N+L3KjOLIhM0kNM/3tACag6f0joaxD0EPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMlp2Hmfipao+qEz0IJyyIMYG2p9IzL4OP23GffIzCXf+2+Mvp1UM7kuv6AkP5HV8
         a6hfrhXLGwknSza3eL/xHKpCEyJtHoVg/3CesCBLF8/hs4eKFkN87x54X0CCcsoQy/
         Db0S/LfiideN3NmjxJw52WiKOJRHOyIyleKffQHl3RU4VDid45Xfb3wsFmtrL7yzMH
         9BhOlBmmmUUnoabpxPg6JOXc6j3nLrGPdRth59s4sC2HXZsHxSdbciZz8PS/NG346D
         20iZUtaj0mLZBpPYo4WRbe+1e+x121+l8ZpFN160BHAJFnpgQPAmtgnT13OXoL870I
         gTzLOYiP05mhQ==
Date:   Tue, 9 Nov 2021 20:26:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfsprogs: remove kernel stubs from xfs_shared.h
Message-ID: <20211110042635.GA24307@magnolia>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
 <bf4256a4-a4eb-29e7-b974-0a7c01913d9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf4256a4-a4eb-29e7-b974-0a7c01913d9a@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 08:02:14PM -0600, Eric Sandeen wrote:
> The kernel stubs added to xfs_shared.h don't belong there, and
> are mostly unnecessary with the #ifdef __KERNEL__ bits added to
> the xfs_ag.[ch] files. Move the one remaining needed stub in
> libxfs_priv.h.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 15bae1ff..3957a2e0 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -75,6 +75,8 @@ extern kmem_zone_t *xfs_trans_zone;
>  /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
>  struct iomap;
> +#define cancel_delayed_work_sync(work) do { } while(0)
> +
>  #include "xfs_cksum.h"
>  /*
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
