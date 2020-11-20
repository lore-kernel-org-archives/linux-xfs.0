Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7234AC63798
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 15:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291ED223BE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 15:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Za9K5ZBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgKTPB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 10:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgKTPB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 10:01:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0085BC0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 07:01:58 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so10388121wrx.2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 07:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jqz5UUOEhQicM8GI1n91U9BhGV2BVxiLUJ6mo3aw7K4=;
        b=Za9K5ZBRRUOSU+0PZlbgfXPoH9UJHcGZJXwkFjGFMJH1oiLnbIPrrDVhiJxSyC16Ax
         IOXjrzfxBVKv4jkQm7Ufl+ViL6OnMvjv9Clx+XkaaiRWogoWhDQY+pCfWbOerFbIqzUT
         RIt3OBcx+tHFlmzAIMMtC8HZwqxhBlw4cwXnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=jqz5UUOEhQicM8GI1n91U9BhGV2BVxiLUJ6mo3aw7K4=;
        b=OKK5SRhz8sIOnoTo41ob1qfuIzqFM/sburYoVUVekOutyqqlJhk7Z605EbeTx+UebL
         bYZ6J3dFzfRslMr9+wKbIVXmAVrLCZ98DV9MiJTfxWUUQGCAxFdyzIhzSGKdxC4P2Y5t
         RRX2FvRCCygCcHkyZv2aRNR6SaGGfNF6Wi06o144QDwnaibUJkVLeIZndmDqI8Z+CPrZ
         CyqcCSCImikuU1skPW4ZxiZKKZDHGhpGERtND+9eBOp3BtjO65NS52U9ljUrXVBRhXcj
         KE2r6fM4/WlrYMEM6zru+oXhnh71H/G2P8eEiHS40kYZpuI6qR72+HrSG3btdBBuDJFh
         SR4g==
X-Gm-Message-State: AOAM531eyvZplTLCZEWF6ENEoI665LvAz6Q5Wk3cxX8TRXYY43mnwYfB
        qbckewyIxhoBvMQAQaTJFBWKSg==
X-Google-Smtp-Source: ABdhPJwCO3CSQICPk9Pv96NQEDcEp0urkvsbCS2ctV63pmGILJUA9/JLkDue0FlOM93UAlTT4tyiyg==
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr4302070wrx.149.1605884511731;
        Fri, 20 Nov 2020 07:01:51 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id x63sm5104218wmb.48.2020.11.20.07.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:01:50 -0800 (PST)
Date:   Fri, 20 Nov 2020 16:01:48 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
Message-ID: <20201120150148.GJ401619@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Huang Rui <ray.huang@amd.com>
References: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
 <20201120095445.1195585-5-daniel.vetter@ffwll.ch>
 <26a62dfb-02e4-1707-c833-a3c8d5cbe828@amd.com>
 <CAKMK7uHnYGiBsBLeyGA8sZXmAiaHaym9jnLKN_xY4VAtKJjG5A@mail.gmail.com>
 <0b853a0e-b737-e02c-b885-0b0249449cb3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b853a0e-b737-e02c-b885-0b0249449cb3@amd.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 20, 2020 at 11:08:31AM +0100, Christian König wrote:
> Am 20.11.20 um 11:05 schrieb Daniel Vetter:
> > On Fri, Nov 20, 2020 at 11:04 AM Christian König
> > <christian.koenig@amd.com> wrote:
> > > Am 20.11.20 um 10:54 schrieb Daniel Vetter:
> > > > Random observation while trying to review Christian's patch series to
> > > > stop looking at struct page for dma-buf imports.
> > > > 
> > > > This was originally added in
> > > > 
> > > > commit 58aa6622d32af7d2c08d45085f44c54554a16ed7
> > > > Author: Thomas Hellstrom <thellstrom@vmware.com>
> > > > Date:   Fri Jan 3 11:47:23 2014 +0100
> > > > 
> > > >       drm/ttm: Correctly set page mapping and -index members
> > > > 
> > > >       Needed for some vm operations; most notably unmap_mapping_range() with
> > > >       even_cows = 0.
> > > > 
> > > >       Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> > > >       Reviewed-by: Brian Paul <brianp@vmware.com>
> > > > 
> > > > but we do not have a single caller of unmap_mapping_range with
> > > > even_cows == 0. And all the gem drivers don't do this, so another
> > > > small thing we could standardize between drm and ttm drivers.
> > > > 
> > > > Plus I don't really see a need for unamp_mapping_range where we don't
> > > > want to indiscriminately shoot down all ptes.
> > > > 
> > > > Cc: Thomas Hellstrom <thellstrom@vmware.com>
> > > > Cc: Brian Paul <brianp@vmware.com>
> > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > Cc: Christian Koenig <christian.koenig@amd.com>
> > > > Cc: Huang Rui <ray.huang@amd.com>
> > > This is still a NAK as long as we can't come up with a better way to
> > > track TTMs page allocations.
> > > 
> > > Additional to that page_mapping() is used quite extensively in the mm
> > > code and I'm not sure if that isn't needed for other stuff as well.
> > Apologies, I'm honestly not quite sure how this lone patch here ended
> > up in this submission. I didn't want to send it out.
> 
> No problem.
> 
> But looking a bit deeper into the mm code that other drm drivers don't set
> this correctly and still use unmap_mapping_range() sounds like quite a bug
> to me.
> 
> Going to track down what exactly that is used for.

Pagecache shootdown. unmap_mapping_range only shoots down from the virtual
side. Since that's all we care about, we don't need to set up the
address_space in the page.
-Daniel

> 
> Christian.
> 
> > -Daniel
> > 
> > > Regards,
> > > Christian.
> > > 
> > > > ---
> > > >    drivers/gpu/drm/ttm/ttm_tt.c | 12 ------------
> > > >    1 file changed, 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> > > > index da9eeffe0c6d..5b2eb6d58bb7 100644
> > > > --- a/drivers/gpu/drm/ttm/ttm_tt.c
> > > > +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> > > > @@ -284,17 +284,6 @@ int ttm_tt_swapout(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
> > > >        return ret;
> > > >    }
> > > > 
> > > > -static void ttm_tt_add_mapping(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
> > > > -{
> > > > -     pgoff_t i;
> > > > -
> > > > -     if (ttm->page_flags & TTM_PAGE_FLAG_SG)
> > > > -             return;
> > > > -
> > > > -     for (i = 0; i < ttm->num_pages; ++i)
> > > > -             ttm->pages[i]->mapping = bdev->dev_mapping;
> > > > -}
> > > > -
> > > >    int ttm_tt_populate(struct ttm_bo_device *bdev,
> > > >                    struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
> > > >    {
> > > > @@ -313,7 +302,6 @@ int ttm_tt_populate(struct ttm_bo_device *bdev,
> > > >        if (ret)
> > > >                return ret;
> > > > 
> > > > -     ttm_tt_add_mapping(bdev, ttm);
> > > >        ttm->page_flags |= TTM_PAGE_FLAG_PRIV_POPULATED;
> > > >        if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
> > > >                ret = ttm_tt_swapin(ttm);
> > 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
