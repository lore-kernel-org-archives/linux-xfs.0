Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24976C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 13:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 057332074B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 13:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Tj45p5a0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgG3NRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 09:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgG3NR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 09:17:27 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917FAC0619D2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2020 06:17:26 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id t7so6217279otp.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2020 06:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l6NNuTlAlb+T71eovQReK+men4boXEXZJmc745e1mek=;
        b=Tj45p5a06zkqFl6bUdtEmCxMS67sh1pLfLaP0MJK1JKsob6GFGtCQSeLESCL2s30Bo
         ou0Hr4WM+OKrYig/4okfOklio8NyYxv+hqW65aWlMC+/KH2ReSdB2qWfNUvAmIpCL5GB
         NCD+kQkkx7Q/TROpmA3URVMeplfnD5XbvU6DY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l6NNuTlAlb+T71eovQReK+men4boXEXZJmc745e1mek=;
        b=Kdkh94Y6XgXrNa3aHTDAOqjgK8dRYjDpsbSn2iULRiyKCWDwbyx1D15i3eXutZwsez
         kA98fi44HTgNCvWurhPrl7BGK1H/cOphaMTXnwhMoUb6pNcAutUuJdX3U/EU33qipAF7
         Anc+6fnq1mhMx62s4A8g1Vbpj+QDHCYnxkictlB7s/PJGl5DjPTm5SO4ulWe9m31vfDY
         tD8yrnh54ZdTAPbVDKpLj6PnuPweweAy1xvuGsN7VsIVom4nvHPz0FsI6o9/k/ccM6Hd
         ZJI9oX+2CeQtIglFk/U+RwRBDw4kR/1DrfQOx8ImOB1xI7mcOs73w+GOULkuh6Hc6AUX
         LEPw==
X-Gm-Message-State: AOAM533QeuyAsiPaHqVxvejPb2huS2D6cbkWbIfL8oYAWae0d4AACx5U
        0wPGUxF2V58hZaIQo3bAxqFwi1cEO+N+ErxGhY9K0Q==
X-Google-Smtp-Source: ABdhPJyT+P5EKFUT/rekKMDvcsT0JZ6B1aXbsvpwMmAI2gySdtJl4PHRq6e+n9dVUTuKG5DRk4IoPKAkcy7FpSExRU8=
X-Received: by 2002:a9d:6052:: with SMTP id v18mr2134622otj.303.1596115045756;
 Thu, 30 Jul 2020 06:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200728135839.1035515-1-daniel.vetter@ffwll.ch> <38cbc4fb-3a88-47c4-2d6c-4d90f9be42e7@shipmail.org>
In-Reply-To: <38cbc4fb-3a88-47c4-2d6c-4d90f9be42e7@shipmail.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 30 Jul 2020 15:17:14 +0200
Message-ID: <CAKMK7uFe-70DE5qOBJ6FwD8d_A0yZt+h5bCqA=e9QtYE1qwASQ@mail.gmail.com>
Subject: Re: [PATCH] dma-resv: lockdep-prime address_space->i_mmap_rwsem for dma-resv
To:     =?UTF-8?Q?Thomas_Hellstr=C3=B6m_=28Intel=29?= 
        <thomas_os@shipmail.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Linux MM <linux-mm@kvack.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 30, 2020 at 2:17 PM Thomas Hellstr=C3=B6m (Intel)
<thomas_os@shipmail.org> wrote:
>
>
> On 7/28/20 3:58 PM, Daniel Vetter wrote:
> > GPU drivers need this in their shrinkers, to be able to throw out
> > mmap'ed buffers. Note that we also need dma_resv_lock in shrinkers,
> > but that loop is resolved by trylocking in shrinkers.
> >
> > So full hierarchy is now (ignore some of the other branches we already
> > have primed):
> >
> > mmap_read_lock -> dma_resv -> shrinkers -> i_mmap_lock_write
> >
> > I hope that's not inconsistent with anything mm or fs does, adding
> > relevant people.
> >
> Looks OK to me. The mapping_dirty_helpers run under the i_mmap_lock, but
> don't allocate any memory AFAICT.
>
> Since huge page-table-entry splitting may happen under the i_mmap_lock
> from unmap_mapping_range() it might be worth figuring out how new page
> directory pages are allocated, though.

ofc I'm not an mm expert at all, but I did try to scroll through all
i_mmap_lock_write/read callers. Found the following:

- kernel/events/uprobes.c in build_map_info:

            /*
             * Needs GFP_NOWAIT to avoid i_mmap_rwsem recursion through
             * reclaim. This is optimistic, no harm done if it fails.
             */

- I got lost in the hugetlb.c code and couldn't convince myself it's
not allocating page directories at various levels with something else
than GFP_KERNEL.

So looks like the recursion is clearly there and known, but the
hugepage code is too complex and flying over my head.
-Daniel

>
> /Thomas
>
>
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
