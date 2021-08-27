Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504FEC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 05:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EFF60F14
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 05:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhH0FBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 01:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhH0FBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 01:01:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657D5C061757
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 22:00:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x4so5045541pgh.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 22:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5od/kUgahC3y4f1RegWK6+73V4iglz5jm4qob9t0vVA=;
        b=BSu7p4nmJtMlK80d5oAhh7aFXPoGGP+gl+hWZhWWIym1U6RhBLlAe/5bDvao/kKQAb
         F39MWe9mIjaOnTpfH0sgCcSh4cuXrGB6gDl0qrmlTddQzhzT8/Y7tfrP9EJm+wgSKeyR
         YI9BJmpRsJNULOYGZDCFXG3Z52Al39rgl3cMQTZmGMp3uZyNRxFbN0typYd/gfbgCyan
         LNge0leybWB0kT3kk7W1+86pqLCXA7QIHKUc7zyBr5jt3Z5THZ430BUoxy/REUuce2/G
         Fv36xRBwtc6uC6mupKmmmNaDkbND8kdsV+OgqlhOEw0jJEjDLFYZJIJerQd+Kcj1mqEm
         8U9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5od/kUgahC3y4f1RegWK6+73V4iglz5jm4qob9t0vVA=;
        b=UL0n1nWJlW95gLPv/edRqAqa4S0vIo39Gu49m3sgDpX6cOAJqxa02NX0Tt56kWh9fa
         DPxyrDJVAtQXHFEcIC78HLVfjdV2z4AYWVd6XjlacgRxpvu6adbaJcVFsCGSyd9BRSEa
         WRQrVmZ4PWz0wsL8Ym8tAGmMULC/m7d4rHabpSDQmm98D6FMbnNtOL2Hj5SONuIiwFom
         h5kdSZ7inUN1uCOR7wEWX9XbT4hTuI5QokHJ//bJotwp9oGOiQpeGLEL1nnw+kwjRxTY
         8jPeRMk7W7RfVkEjZS1mNwz59b3pM4jnMI+5oq1UJ2kBz5K18bgOWmMqvHtTsoS7HR8J
         fpaw==
X-Gm-Message-State: AOAM531tQUEejfH+uTeidlqrY5XIMBKxrS9+2k7YJmQTTKvAkUJ6Jrwz
        GKc9llY0Iwm07PMhplsA9541cKop56P1TVUAPTh8MQ==
X-Google-Smtp-Source: ABdhPJyVQVbVkfVdq/1PF6yl6SVsfHp0Hfz/wCeBu9gUupv+ehQ3Plpx7tr9qo13kJxyJjLGTC4u6L4dvPb+Co2Q9YQ=
X-Received: by 2002:aa7:818c:0:b0:3f1:e024:dcbc with SMTP id
 g12-20020aa7818c000000b003f1e024dcbcmr7357771pfi.31.1630040433928; Thu, 26
 Aug 2021 22:00:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-4-ruansy.fnst@fujitsu.com> <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
 <20210823125715.GA15536@lst.de> <d4f07aef-ad9f-7de9-c112-a40e2022b399@fujitsu.com>
In-Reply-To: <d4f07aef-ad9f-7de9-c112-a40e2022b399@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 26 Aug 2021 22:00:23 -0700
Message-ID: <CAPcyv4j832cg0_=h31nTdjFoqgvWsCWqqcY_K_fMRg93JsWU-Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] fsdax: Replace mmap entry in case of CoW
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        david <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 8:22 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
>
>
> On 2021/8/23 20:57, Christoph Hellwig wrote:
> > On Thu, Aug 19, 2021 at 03:54:01PM -0700, Dan Williams wrote:
> >>
> >> static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
> >>                                const struct iomap_iter *iter, void
> >> *entry, pfn_t pfn,
> >>                                unsigned long flags)
> >>
> >>
> >>>   {
> >>> +       struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> >>>          void *new_entry = dax_make_entry(pfn, flags);
> >>> +       bool dirty = insert_flags & DAX_IF_DIRTY;
> >>> +       bool cow = insert_flags & DAX_IF_COW;
> >>
> >> ...and then calculate these flags from the source data. I'm just
> >> reacting to "yet more flags".
> >
> > Except for the overly long line above that seems like a good idea.
> > The iomap_iter didn't exist for most of the time this patch has been
> > around.
> >
>
> So should I reuse the iter->flags to pass the insert_flags? (left shift
> it to higher bits)

No, the advice is to just pass the @iter to dax_insert_entry directly
and calculate @dirty and @cow internally.
