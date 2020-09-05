Return-Path: <SRS0=nhRG=CO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0559DC43461
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 16:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3912086A
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599324895;
	bh=KCVpQIkRfqk75kLPHTuJDni6NSqWOhUvpOq5UmDg0jY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zBFSlfjOrGs8855yvb6Splm3v2nW2bYKSQm/H5bp9i/LW6UdvpsfnymxGH9HIfFrf
	 TDhe/g82zFN/KpVUJGcTvvCT2UdqRXxSeIHTORVFSkL3dS6c29W77YDb1Zb9A4Ew6I
	 3ZElBk9I6l5Gfs6Q2y3VM6CG1bUYtdOa7Y7MJgY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIEQyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Sep 2020 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIEQyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Sep 2020 12:54:54 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D2C061244
        for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2020 09:54:53 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id nw23so12555410ejb.4
        for <linux-xfs@vger.kernel.org>; Sat, 05 Sep 2020 09:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WiPzQYToprkedvPvy23+d8Sogck/PPDXaDM0aINUTxs=;
        b=IbD/06LcWNINiD1qQx76yuC4NnGDIsm3+GWIOtgRCjshaVtDI/A02DI5qKetncQ5Eq
         ETJ/AP0MURo4tMxU2BWA9ZqY9wz8byBe5Nb/ZFb/npAfuJhH/nO2eJvqX1EnmPNcLt9a
         /DIWjA8HitbuHHT5Zgo8zabEuZouEGY3xlN9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WiPzQYToprkedvPvy23+d8Sogck/PPDXaDM0aINUTxs=;
        b=J9jPcT3vugYfonKfq0KLmBLyVWFKICvRY/iy7y7gP5Rd4z242u+EUzS7GKrDX1GTLT
         7g5Gy8bbL36izRcbbX9Q1PrGZ0vCDOGrzYbl8gNB4c0ojujVkvKG8nXfxDTO8QXQN4t0
         dvAc9KHnbWzFq6c8VopwxK9ErGRoavvp3FFACOUZu5WchXa3HjUUZ143K/Son1GPTeln
         MB1wkn3HF2i53Nc8658AdqTFCeHM6+RSOrgkKdUO28S+xzyDW7cWMi0cWanGTkGdqIZV
         24Rv7ALRB6lx3cORhZ6H1z7H6CxWSEcPBuOZr3dCbIV1GuTz8XLuBmbLSLanwwBWV1Zl
         MG/Q==
X-Gm-Message-State: AOAM532ji+vhotrubASBGi3pOxdYFzZCSccrk4cktAdRD8Y15zpIKbIj
        QVfKmGVur0PIrYiN4+uBd7rimrxrArPJ3g==
X-Google-Smtp-Source: ABdhPJzX2vjuZjzBji9U5vT9AKC2qF5Qpz94hMZ+UrsS0R4zm47oukMzpMMqIrXsXAUve4PuueR27A==
X-Received: by 2002:a17:906:2d42:: with SMTP id e2mr12926625eji.10.1599324890893;
        Sat, 05 Sep 2020 09:54:50 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id r16sm768475edc.57.2020.09.05.09.54.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 09:54:50 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id z22so12534753ejl.7
        for <linux-xfs@vger.kernel.org>; Sat, 05 Sep 2020 09:54:50 -0700 (PDT)
X-Received: by 2002:a19:c8c6:: with SMTP id y189mr6480035lff.125.1599324489251;
 Sat, 05 Sep 2020 09:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009041200570.27312@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050805250.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050812060.12419@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009050812060.12419@file01.intranet.prod.int.rdu2.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Sep 2020 09:47:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
Message-ID: <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: don't update mtime on COW faults
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 5, 2020 at 5:13 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> When running in a dax mode, if the user maps a page with MAP_PRIVATE and
> PROT_WRITE, the xfs filesystem would incorrectly update ctime and mtime
> when the user hits a COW fault.

So your patch is obviously correct,  but at the same time I look at
the (buggy) ext2/xfs code you fixed, and I go "well, that was a really
natural mistake to make".

So I get the feeling that "yes, this was an ext2 and xfs bug, but we
kind of set those filesystems up to fail".

Could this possibly have been avoided by having nicer interfaces?

Grepping around, and doing a bit of "git blame", I note that ext4 used
to have this exact same bug too, but it was fixed three years ago in
commit fd96b8da68d3 ("ext4: fix fault handling when mounted with -o
dax,ro") and nobody at the time clearly realized it might be a
pattern.

And honestly, it's possible that the pattern came from cut-and-paste
errors, but it's equally likely that the pattern was there simply
because it was such a natural pattern and such an easy and natural
mistake to make.

Maybe it's inevitable. Some people do want (and need) the information
whether it was a write just because they care about the page table
issues (ie marking the pte dirty etc). To that kind of situation,
whether it's shared or not might not matter all that much. But to a
filesystem, a private write vs a shared write are quite different
things.

So I don't really have any suggestions, and maybe it's just what it
is, but maybe somebody has an idea for how to make it slightly less
natural to make this mistake..

But maybe just a test-case is all it takes, like Darrick suggests.

                  Linus
