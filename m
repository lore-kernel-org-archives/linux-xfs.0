Return-Path: <SRS0=nhRG=CO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6586C43461
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 17:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B7B220760
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599325423;
	bh=bYePyoygb5sypUBeDHzAvhU73UeSVNStq9eAPSiouAY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GQzwkxCy8KA4BOjPdUbswRiYSaKwxJVRoJQQ6on/PQw2678ixcLlo3f3zv5NQ2+8P
	 div9C1Yz7H1vGgWjsqGqXwIq/AVFgXnz1hcTXYT1eAjXhGR9DFiA7YAg6UWALEp7UI
	 XHamQG5966dBf865DOk8S92NMed6HK0SM1P7lzdw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgIERDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Sep 2020 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIERDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Sep 2020 13:03:40 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395ADC061244
        for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2020 10:03:39 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r13so11511003ljm.0
        for <linux-xfs@vger.kernel.org>; Sat, 05 Sep 2020 10:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yq3SfrK7yZAtmYRnvDmja3vYq8mdQSVjPiEi6mwaMYI=;
        b=b0r56yrMlN887hWaFszKtt3otNFfkTZGY9PBeAnyiPugAfYpUMCfOTBWDohK5Luc/G
         +LqYWBwLdx1jUaxLPC79yX0fHBJTRyN1py7Wq/ZzjBRr+LK88BEB8cL1Zhj8z/OzGL05
         1K+nOaaiL2yDxhltK+DQ4feWYgd8jEHvr7JnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yq3SfrK7yZAtmYRnvDmja3vYq8mdQSVjPiEi6mwaMYI=;
        b=HJRtaCDOnUbOnprDCU8IqL7wfCoD3UpmLZTnQNbEOyTCv7dkgVgSECkkWjwam7evIT
         M0bJXgFbz1OL5CVVyVvX27S0HeveHjWjako6RevVDmV47RyTfzOx7ckBNZeqdmm4r2Js
         9Cc6lvkGerCO9dbZ+p5mlD0KXvjyuWdrVGvYhdPk35DuF6sBN1pxdbMLRs9QkxfDB1TJ
         lDJcfuNbQNFlqOjh6MvYClvH01YFDsU21YSSolfUpwIMhX2VX7RkKHVhwS6qv+pwv5dd
         ItJt6/9ReeeJ0YsdXgXK0fnzcBHnNmdMF3fSqnHJPtuuoD9+VHq41wzFD5X5b77cfLBE
         mQJQ==
X-Gm-Message-State: AOAM531tL4w3USiDHOSOsDSBGonkKHIkDeYLoF+HDuErHG3oR24wTg8q
        PA6XXKJCCyZAkBpeNRtbpkOJco0aApb8Dg==
X-Google-Smtp-Source: ABdhPJzuxfvFNcI5qcXljjaNGqR5k8GPOWcrBaUodKP0uTqLPogRh3YDbm5aIo5z/7DtZmfJb24waA==
X-Received: by 2002:a2e:8114:: with SMTP id d20mr6066916ljg.409.1599325417737;
        Sat, 05 Sep 2020 10:03:37 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id y4sm2383147ljk.61.2020.09.05.10.03.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:03:37 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id u27so5433943lfm.13
        for <linux-xfs@vger.kernel.org>; Sat, 05 Sep 2020 10:03:37 -0700 (PDT)
X-Received: by 2002:a05:6512:403:: with SMTP id u3mr6534077lfk.10.1599325416665;
 Sat, 05 Sep 2020 10:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009041200570.27312@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050805250.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050812060.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
In-Reply-To: <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Sep 2020 10:03:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
Message-ID: <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
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

On Sat, Sep 5, 2020 at 9:47 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So your patch is obviously correct, [..]

Oh, and I had a xfs pull request in my inbox already, so rather than
expect Darrick to do another one just for this and have Jan do one for
ext2, I just applied these two directly as "ObviouslyCorrect(tm)".

I added the "inline" as suggested by Darrick, and I also added
parenthesis around the bit tests.

Yes, I know the C precedence rules, but I just personally find the
code easier to read if I don't even have to think about it and the
different subexpressions of a logical operation are just visually very
clear. And as I was editing the patch anyway...

So that xfs helper function now looks like this

+static inline bool
+xfs_is_write_fault(
+       struct vm_fault         *vmf)
+{
+       return (vmf->flags & FAULT_FLAG_WRITE) &&
+              (vmf->vma->vm_flags & VM_SHARED);
+}

instead.

            Linus
