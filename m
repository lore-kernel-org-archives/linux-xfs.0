Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53694C56201
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED0E206F9
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="oZokE3b9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgKYSGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbgKYSGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 13:06:09 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03665C061A4F
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 10:06:08 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id l2so2246537qtq.4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 10:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BcVhHVVGnf3WvgX+ezgVKIjE/rfcsmBp0NN8oWI8KeQ=;
        b=oZokE3b9qW4wR31ltC6sLQ8tlsVQNdzsn6eGih9BX9owbzd4vdqHIicN+yS6UhLmWp
         3ItMtJDGOFCY1EYvQ97JYoz+bllXwb5hSufqcrUhqWQMB1IbJJWX0CT7Dwn8uE0Nh6z5
         dw+tG9V44ScSRsHrV7/VT1/OdTnZ/CQ5A6gTusM4CjwRb4DmoUyVsFAnVBK9xVV0b5VH
         3Mzp15tBB2D/v7WXW1Tzd8cStJSr2M7OHyaJH0C3r+eimOrdeDIRnOZqng+EBsuckQn/
         IgupkbnQ8lg3DQoP5zkAZWk208dxV0Dzx5MvaGoorv9NAiTZR3LBKtotzc+NJe+1xtrq
         mPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BcVhHVVGnf3WvgX+ezgVKIjE/rfcsmBp0NN8oWI8KeQ=;
        b=DE3zahwOiVToO2ohRxLhOvo4jtx4Wdt8qD9NKC2FFbrZDMlfgbs7U2M3pdYj1NPFzQ
         /Z4hCc19BDhxWbCfjFpWWuhNhVwbB+TP/tNnUUcJvEqXg/mwEpVdSy9pWfcIrV5FRYtH
         YkU2S5fbfMQOkhsbZ8/J1uyPoloQWlcchIJpFK1GI4nAw2JzlRTsTlQrE+sBzH5p3NlL
         Nb68UIm3+ZU6W5fOU5/a/G3DSyBEkSo43LQ6bGNqF2YTKeoine32ENcJaQA9aFRbLUjV
         3ubloChCo2wQALDppm/zPBUq7eWW2kcH73LEd9x3fVJATkASspdUYLuBRLaPs6OayXit
         IPlA==
X-Gm-Message-State: AOAM531J6uMaqXRAPFUYdK89t2Ea5gjlWfoqffOp3w//0MmSnZrdPaMq
        Bb2AtW9Xpzm5vPPU/xriDFBcDg==
X-Google-Smtp-Source: ABdhPJyTT0zfGule3EMk3EVFgg0sW/Gc+MYUEwA7cD2UFS4TswJqWZPz+DEHts834E3EnWVts2w0Nw==
X-Received: by 2002:ac8:7a7b:: with SMTP id w27mr29725qtt.381.1606327568092;
        Wed, 25 Nov 2020 10:06:08 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id h4sm32176qkh.93.2020.11.25.10.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:06:07 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1khzB8-001Lnb-ES; Wed, 25 Nov 2020 14:06:06 -0400
Date:   Wed, 25 Nov 2020 14:06:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
Message-ID: <20201125180606.GQ5487@ziepe.ca>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
 <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
 <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 05:28:32PM +0100, Daniel Vetter wrote:
> On Wed, Nov 25, 2020 at 5:25 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >
> > Random observation while trying to review Christian's patch series to
> > stop looking at struct page for dma-buf imports.
> >
> > This was originally added in
> >
> > commit 58aa6622d32af7d2c08d45085f44c54554a16ed7
> > Author: Thomas Hellstrom <thellstrom@vmware.com>
> > Date:   Fri Jan 3 11:47:23 2014 +0100
> >
> >     drm/ttm: Correctly set page mapping and -index members
> >
> >     Needed for some vm operations; most notably unmap_mapping_range() with
> >     even_cows = 0.
> >
> >     Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> >     Reviewed-by: Brian Paul <brianp@vmware.com>
> >
> > but we do not have a single caller of unmap_mapping_range with
> > even_cows == 0. And all the gem drivers don't do this, so another
> > small thing we could standardize between drm and ttm drivers.
> >
> > Plus I don't really see a need for unamp_mapping_range where we don't
> > want to indiscriminately shoot down all ptes.
> >
> > Cc: Thomas Hellstrom <thellstrom@vmware.com>
> > Cc: Brian Paul <brianp@vmware.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Christian Koenig <christian.koenig@amd.com>
> > Cc: Huang Rui <ray.huang@amd.com>
> 
> Apologies again, this shouldn't have been included. But at least I
> have an idea now why this patch somehow was included in the git
> send-email. Lovely interface :-/

I wrote a bit of a script around this because git send-email just too
hard to use

The key workflow change I made was to have it prepare all the emails
to send and open them in an editor for review - exactly as they would
be sent to the lists.

It uses a empty 'cover-letter' commit and automatically transforms it
into exactly the right stuff. Keeps track of everything you send in
git, and there is a little tool to auto-run git range-diff to help
build change logs..

https://github.com/jgunthorpe/Kernel-Maintainer-Tools/blob/master/gj_tools/cmd_send_patches.py

I've been occasionaly wondering if I should suggest Konstantin add a
sending side to b4, maybe using some of those ideas..

(careful if you run it, it does autosend without prompting)

Jason
