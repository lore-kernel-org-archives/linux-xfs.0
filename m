Return-Path: <SRS0=3Xx9=C6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D15C43466
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 16:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ABAF222BB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600705251;
	bh=2TtBwT3+WapcL4JKJP0d9ngWbiy5IfwFBY1QgktTBX4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WD2Sn18v/EHrf4IoSP8JPxO77uEhOf8ZGhnkkjyG22FFgJjGqRwO8zrRwY3W+Xc89
	 RAKiWTdrGKjfJEou4od84WyCopiAjrsYoLDHm2k3YP4Jx/4c6TlymNiPg0e1aYJiRu
	 g4xoquNTYUZyaQfHPx8wfUWXrT0hUznsB8xUnj8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgIUQUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgIUQUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 12:20:50 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1564C061755
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2020 09:20:49 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d15so14673387lfq.11
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2020 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8LK5dloOXhiAuv1jzPTpg6aj5g8mwVrNmUPAV9ogWY=;
        b=RFMB/gNwPwfIqudW3R4jXCFsXqrNlGTxVuJ7YvVxCKzq5Y/YUC/Ma6uY7s95wRftZ1
         7s8sQIj4iiCqfqYdGopoS/gZplkdWgCmkY2aCa/c5cevLuamU4HpSU0quOZvV2Xv5EaL
         vunDI/0xHWZgKhUbEF4U4wC7LUJxngCiHSvxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8LK5dloOXhiAuv1jzPTpg6aj5g8mwVrNmUPAV9ogWY=;
        b=uU8v8RQ8jgRgvNcXkpAsJ1zk9WM+UAGpy5dZbQ5KO1/klAdzgUQgGJTkSOLT5oSfIK
         /1oBsbTVzk5fszR7fRc+0pdIQchhKEVHwMAh/Xo0smNi39bNNtF+Bqmt3if1loQw/c/n
         7f+LXhGhukhnrRdhyjxCFwX1Hqt3m5p/fmpESG03C5DPTluJcEM7QUSKUxA5bErXj2Vb
         OHFABsSVK343zYe9y4WILGjpTEpgKXqmq+I8Cy0R2XeASAQzu3xAi/ZNhAggbg5drKKC
         G04JQ8olJ8KZoQokgj78cOWwPM3OVIZpqQINSQ0UCmSisCIsqY3xFjqMp85OwkMnRi/H
         8Plg==
X-Gm-Message-State: AOAM532/lJyaoRSLbBaNM34USbD/LXWgka3oUFJ/CkqjIpIaX8GU2j2R
        kPwC3zuFeRz+/AIOgNdgrX0Ox0c8ET/hTQ==
X-Google-Smtp-Source: ABdhPJw4SNwKZhwv1oKqIOt+3yH2At3shb04d+bcLmAGYTmy6isg+xnLMCXkg7QqpuV/S8xi5W2asg==
X-Received: by 2002:a19:8242:: with SMTP id e63mr216044lfd.226.1600705247753;
        Mon, 21 Sep 2020 09:20:47 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id l129sm2658614lfd.279.2020.09.21.09.20.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 09:20:42 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id v23so11639074ljd.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2020 09:20:42 -0700 (PDT)
X-Received: by 2002:a2e:84d6:: with SMTP id q22mr149175ljh.70.1600705241845;
 Mon, 21 Sep 2020 09:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200623052059.1893966-1-david@fromorbit.com> <CAOQ4uxh0dnVXJ9g+5jb3q72RQYYqTLPW_uBqHPKn6AJZ2DNPOQ@mail.gmail.com>
 <20200916155851.GA1572@quack2.suse.cz> <20200917014454.GZ12131@dread.disaster.area>
 <alpine.LSU.2.11.2009161853220.2087@eggly.anvils> <20200917064532.GI12131@dread.disaster.area>
 <alpine.LSU.2.11.2009170017590.8077@eggly.anvils> <20200921082600.GO12131@dread.disaster.area>
 <20200921091143.GB5862@quack2.suse.cz>
In-Reply-To: <20200921091143.GB5862@quack2.suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Sep 2020 09:20:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wir89LPH6A4H2hkxVXT20+dpcw2qQq0GtQJvy87ARga-g@mail.gmail.com>
Message-ID: <CAHk-=wir89LPH6A4H2hkxVXT20+dpcw2qQq0GtQJvy87ARga-g@mail.gmail.com>
Subject: Re: More filesystem need this fix (xfs: use MMAPLOCK around filemap_map_pages())
To:     Jan Kara <jack@suse.cz>
Cc:     Dave Chinner <david@fromorbit.com>,
        Hugh Dickins <hughd@google.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Martin Brandenburg <martin@omnibond.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Qiuyang Sun <sunqiuyang@huawei.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, nborisov@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 21, 2020 at 2:11 AM Jan Kara <jack@suse.cz> wrote:
>
> Except that on truncate, we have to unmap these
> anonymous pages in private file mappings as well...

I'm actually not 100% sure we strictly would need to care.

Once we've faulted in a private file mapping page, that page is
"ours". That's kind of what MAP_PRIVATE means.

If we haven't written to it, we do keep things coherent with the file,
but that's actually not required by POSIX afaik - it's a QoI issue,
and a lot of (bad) Unixes didn't do it at all.

So as long as truncate _clears_ the pages it truncates, I think we'd
actually be ok.

The SIGBUS is supposed to happen, but that's really only relevant for
the _first_ access. Once we've accessed the page, and have it mapped,
the private part really means that there are no guarantees it stays
coherent.

In particular, obviously if we've written to a page, we've lost the
association with the original file entirely. And I'm pretty sure that
a private mapping is allowed to act as if it was a private copy
without that association in the first place.

That said, this _is_ a QoI thing, and in Linux we've generally tried
quite hard to stay as coherent as possible even with private mappings.

In fact, before we had real shared file mappings (in a distant past,
long long ago), we allowed read-only shared mappings because we
internally turned them into read-only private mappings and our private
mappings were coherent.

And those "fake" read-only shared mappings actually were much better
than some other platforms "real" shared mappings (*cough*hpux*cough*)
and actually worked with things that mixed "write()" and "mmap()" and
expected coherency.

Admittedly the only case I'm aware of that did that was nntpd or
something like that. Exactly because a lot of Unixes were *not*
coherent (either because they had actual hardware cache coherency
issues, or because their VM was not set up for it).

                 Linus
