Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FEFC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 16:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51316140C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 16:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhD2Qqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240891AbhD2Qqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 12:46:46 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FF4C06138B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 09:45:59 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o16so77219578ljp.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fv1o4ACMgluHoz1tubBqI30O1OAulg9d7QxnCnSiG9c=;
        b=KDkNvN4NBhwsvv2Vt/X74vt7KVgzUpJkoRwK5HYd1W+ax7k1/dGgufUKiRP3X8w5Ql
         H5lHQo0imA8GXWxUOZUx++5LlJIaiJwjb17/VyeO+Shqq/nhIWw9KJuVJxGvXm/uTM1x
         86MzDL52wXvA28OjsoGhD6CKmP2Q62dV3Gr70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fv1o4ACMgluHoz1tubBqI30O1OAulg9d7QxnCnSiG9c=;
        b=Ag20AB6TeWKT4FVYqMBScSXeOKRO1Ucq5UNgQ++lf4YgoaFZCGR7Qx+ygegW2CAuwU
         czI+Y36bauQjKSvMQLVhLHjgyBCH7Fz0ks+jhrflmy8RYBHvj1tbrrWPIfho16I5qsfF
         FDdtM8h1YtAx/YKA+QyWAO6vH4J4TBHhK0wu9vUe/F+ni/2xe6c0PZ2rMn8GD7Oi5LED
         i3DEE9ST9TTGCNBr47Qx938gwP13/bumQECMRmE2Rn7DLHuG3fZsfYYlr/tNO8fvsYVr
         HQd/+22BKdelkrFK7uS9+ScdP/Qn1Upm5K+nqlQKeQ8+hnCM0d+8CXblbotmLuycwUZB
         Xbuw==
X-Gm-Message-State: AOAM530pyV2Zk6BGh2OGU6UMyM3HI7GjlwJ3uMHEZkccespT7E8YETNU
        OWUyAAMRcx96cBgakPVfB6nHhmZofgkczThO
X-Google-Smtp-Source: ABdhPJyCinhG2OhV83/O41+hU844Ke8hHlgzwTXVo+0wYFRp+DbDVC2NF86gHpl9WehFPifkx/gPkg==
X-Received: by 2002:a05:651c:2de:: with SMTP id f30mr439222ljo.66.1619714757870;
        Thu, 29 Apr 2021 09:45:57 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id a20sm557093ljd.105.2021.04.29.09.45.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 09:45:55 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id n138so105997482lfa.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 09:45:55 -0700 (PDT)
X-Received: by 2002:a05:6512:a90:: with SMTP id m16mr284849lfu.201.1619714755208;
 Thu, 29 Apr 2021 09:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de> <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
 <20210428061706.GC5084@lst.de> <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
 <20210428064110.GA5883@lst.de> <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
 <1de23de2-12a9-2b13-3b86-9fe4102fdc0c@rasmusvillemoes.dk> <CAHk-=wimsMqGdzik187YWLb-ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com>
 <26d06c27-4778-bf75-e39a-3b02cd22d0e3@rasmusvillemoes.dk>
In-Reply-To: <26d06c27-4778-bf75-e39a-3b02cd22d0e3@rasmusvillemoes.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Apr 2021 09:45:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=whJmDjTLYLeF=Ax31vTOq4PHXKo6JUqm1mQNGZdy-6=3Q@mail.gmail.com>
Message-ID: <CAHk-=whJmDjTLYLeF=Ax31vTOq4PHXKo6JUqm1mQNGZdy-6=3Q@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 11:40 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> > That also does explain the arguably odd %pD defaults: %pd came first,
> > and then %pD came afterwards.
>
> Eh? 4b6ccca701ef5977d0ffbc2c932430dea88b38b6 added them both at the same
> time.

Ahh, I looked at "git blame", and saw that file_dentry_name() was
added later. But that turns out to have been an additional fix on top,
not actually "later support".

Looking more at that code, I am starting to think that
"file_dentry_name()" simply shouldn't use "dentry_name()" at all.
Despite that shared code origin, and despite that similar letter
choice (lower-vs-upper case), a dentry and a file really are very very
different from a name standpoint.

And it's not the "a filename is the whale pathname, and a dentry has
its own private dentry name" issue. It's really that the 'struct file'
contains a _path_ - which is not just the dentry pointer, but the
'struct vfsmount' pointer too.

So '%pD' really *could* get the real path right (because it has all
the required information) in ways that '%pd' fundamentally cannot.

At the same time, I really don't like printk specifiers to take any
real locks (ie mount_lock or rename_lock), so I wouldn't want them to
use the full  d_path() logic.

                Linus
