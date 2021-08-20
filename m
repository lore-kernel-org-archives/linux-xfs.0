Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B8EC4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC10610CC
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 16:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhHTQy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 12:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhHTQyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 12:54:55 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028BAC061756
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 09:54:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so9760080pga.13
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/jv/65/o/pr3Arrh3DCsUW+kuq3VQXikqXf2iTWhR0=;
        b=wmKOKlHKACOKqcXgGfzOyuS+T8nTPa0UTHRKzXqyEB7n1oMhL9ybIy4re4kL145HF1
         bMtrau52pfw/I1Kc5cdxzuDtd0Et/jJkS5US+hv/mTQyQM7TcCklar0bSyyEBZaFQivs
         wSYZ7huQEIGoNty7O9v1HlhEnIt+psE5sGUDc9it5+LPZ7q/ulbelZHxwf3w1Cir636k
         IGP2ByU9d0ypCXvfCnbVJxTWgVNrKwxvWAw8s1imwihI5Uzzw1LN35likbg8w9wlGZNJ
         vEpJZYYjxE1je5/O/8C/dWmlALP8frPW0a+yHWctwSdYLH99P7ISs6wJ2ZSV9hwtj/V7
         R6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/jv/65/o/pr3Arrh3DCsUW+kuq3VQXikqXf2iTWhR0=;
        b=OGyNrjSX2O4E87tyWhBWnLHnkEahL9n5Bs85y0kA1VrFZhaXfUN88Fd5tfNUM7SjwZ
         5bsZxeZke63723rDH0dYSHdFA/lVHPud88myEXUUziRCUPP1rS5y73JttXiOVvW+rgBc
         +jUM4h+yRTgLVSlJzCCEhYQWgx9FllK+2QFdSVrBcqO2AaZTWOC60z0RWACOhGCw0kfc
         pcbMo5odkpoN4aUfF1wh8JfbW2Km4QQZqbq5M9aAg4QpWscTz7De5IxCYOnR17xwh4hg
         +PxTqjEVL6lH0wijaDKbruqU7lfFjEc5ZCOXhcGGOgmJj3dR07rMY8a77Xx04XAhre9J
         uAtQ==
X-Gm-Message-State: AOAM532kb4OWpd9eCfVWPNMfG0/7FS2M6ab5ZmjygVb5ECVpJjiTHe+Y
        /aRp//iX73i9nAxmJdZC1shG3ifrTN6PO/i1aM99Mw==
X-Google-Smtp-Source: ABdhPJxOaSnUuSDnQi5DeVTlIJ2tZRX4+NfWecFNtpOa2DU5Lh7Ot8DcjqxkMAwkp+e/mA/IvF4DoFjucZJd3KA/Wvo=
X-Received: by 2002:a65:6642:: with SMTP id z2mr7510515pgv.240.1629478457626;
 Fri, 20 Aug 2021 09:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
 <20210730100158.3117319-4-ruansy.fnst@fujitsu.com> <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
In-Reply-To: <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 20 Aug 2021 09:54:06 -0700
Message-ID: <CAPcyv4hQvR+KND8F1zGoX=jBJQ6bXhLtmEAPVb=O7rDwzHniiQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 3/9] mm: factor helpers for memory_failure_dev_pagemap
To:     Jane Chu <jane.chu@oracle.com>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 5, 2021 at 6:01 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > -     /*
> > -      * Prevent the inode from being freed while we are interrogating
> > -      * the address_space, typically this would be handled by
> > -      * lock_page(), but dax pages do not use the page lock. This
> > -      * also prevents changes to the mapping of this pfn until
> > -      * poison signaling is complete.
> > -      */
> > -     cookie = dax_lock_page(page);
> > -     if (!cookie)
> > -             goto out;
> > -
> >       if (hwpoison_filter(page)) {
> >               rc = 0;
> > -             goto unlock;
> > +             goto out;
> >       }
>
> why isn't dax_lock_page() needed for hwpoison_filter() check?

Good catch. hwpoison_filter() is indeed consulting page->mapping->host
which needs to be synchronized against inode lifetime.
