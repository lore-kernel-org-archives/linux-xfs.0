Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7138C56201
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B97520BED
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="K4nmwFze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgKYQ2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731039AbgKYQ2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 11:28:44 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6F1C061A4F
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:28:44 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id c80so3469857oib.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRACjaFJh4AZpkepxixl78ErKCZI3elRJ+hcGP1uvRc=;
        b=K4nmwFzet4CmWQbz4zwRTZ6CI5hxzbxZ25gbBnhWnCJH8Q8rKXsL79Ql5rlCpu29Lr
         bPggFh1VtIOTIpQaTQqFAtXfwAgUPiNMU07nzL7WEAwSqk0xgspIBThT1z03Zvfxcs3b
         aqQEsY9KeNryZDXQ07y5HihJ9KhEL6DoeL6A8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRACjaFJh4AZpkepxixl78ErKCZI3elRJ+hcGP1uvRc=;
        b=B8MPajfU56O5Z3EZ31qTI1/0VwIJJkoO1MYydqT4Y6ABZ7n5YUyEfAYnO/Ivy6aCqg
         gEAgBy2xdq5gj3CtA5jCsNJBa63WcRtiPCCmPhGQlVDr5kN4oyRknPMtlu8vrpdPTD08
         6x//yqkXBaB69gMU6P8aaOWbmYAa0nuaoFyKxBe91byAQwAjURGJAvtL6SACCrZCrOUz
         IatrP3tBpoAOIkbOCH6RsDuXa+vJ6n64deYWRisjVTEF7IXtQ8Yh9DPpOH5ZY7k04awT
         zPZqd86y2HYPwOQdR5QQgktXhqRFed0LArGxjyWfKyMlgqLyJ3GB10JcZqmrweXsnVU9
         c4dQ==
X-Gm-Message-State: AOAM531qY7BAT3k8xj7Qj5AvMteATIpH+c3uqbkTVUq0We0Olu+8zQDL
        Wd7Z8SUNhNlzk0j6FBZtYqOBYshqZpvvhMfUA/e7Vg==
X-Google-Smtp-Source: ABdhPJxFp4HuSi30fm1PHbzKdfrYvQxr8zUWpRKb+OichQq/lnbRaStrtSKPxiYo68cqfG34JDlvPm/6dqfZjcK5iGw=
X-Received: by 2002:aca:7506:: with SMTP id q6mr2814868oic.128.1606321723817;
 Wed, 25 Nov 2020 08:28:43 -0800 (PST)
MIME-Version: 1.0
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch> <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
In-Reply-To: <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 25 Nov 2020 17:28:32 +0100
Message-ID: <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 5:25 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> Random observation while trying to review Christian's patch series to
> stop looking at struct page for dma-buf imports.
>
> This was originally added in
>
> commit 58aa6622d32af7d2c08d45085f44c54554a16ed7
> Author: Thomas Hellstrom <thellstrom@vmware.com>
> Date:   Fri Jan 3 11:47:23 2014 +0100
>
>     drm/ttm: Correctly set page mapping and -index members
>
>     Needed for some vm operations; most notably unmap_mapping_range() with
>     even_cows = 0.
>
>     Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>     Reviewed-by: Brian Paul <brianp@vmware.com>
>
> but we do not have a single caller of unmap_mapping_range with
> even_cows == 0. And all the gem drivers don't do this, so another
> small thing we could standardize between drm and ttm drivers.
>
> Plus I don't really see a need for unamp_mapping_range where we don't
> want to indiscriminately shoot down all ptes.
>
> Cc: Thomas Hellstrom <thellstrom@vmware.com>
> Cc: Brian Paul <brianp@vmware.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>

Apologies again, this shouldn't have been included. But at least I
have an idea now why this patch somehow was included in the git
send-email. Lovely interface :-/
-Daniel

> ---
>  drivers/gpu/drm/ttm/ttm_tt.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> index da9eeffe0c6d..5b2eb6d58bb7 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -284,17 +284,6 @@ int ttm_tt_swapout(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
>         return ret;
>  }
>
> -static void ttm_tt_add_mapping(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
> -{
> -       pgoff_t i;
> -
> -       if (ttm->page_flags & TTM_PAGE_FLAG_SG)
> -               return;
> -
> -       for (i = 0; i < ttm->num_pages; ++i)
> -               ttm->pages[i]->mapping = bdev->dev_mapping;
> -}
> -
>  int ttm_tt_populate(struct ttm_bo_device *bdev,
>                     struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
>  {
> @@ -313,7 +302,6 @@ int ttm_tt_populate(struct ttm_bo_device *bdev,
>         if (ret)
>                 return ret;
>
> -       ttm_tt_add_mapping(bdev, ttm);
>         ttm->page_flags |= TTM_PAGE_FLAG_PRIV_POPULATED;
>         if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
>                 ret = ttm_tt_swapin(ttm);
> --
> 2.29.2
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
