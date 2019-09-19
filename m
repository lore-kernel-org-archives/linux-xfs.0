Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCA6C4CEC9
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 02:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1E4214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 02:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568858900;
	bh=ijQObP1ViXv2IiyhYIO3hOgjDjMCT66WfvFvJLjFVWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OSVqg4BRWlhNY+/VXDbsa6SCUD8J6yL9uOpl+Ut4oERyNnNC0pF0ijXPDh2e5oC4X
	 G2LrUtuCDhNaujGnRgPpuCpLGGHWRYqDMlaCBtZkm91BoyM57HEe21pbbX6xpV1tx6
	 +54XNR+VGpfceZDANw4NochmgFRKZ7n+N6tLoKIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfISCIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 22:08:19 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33820 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387771AbfISCIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 22:08:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id j19so407717lja.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 19:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Xuld3BlUHhLVm41JSQ0g37C/9G156A47j1pRWimdvw=;
        b=K4bnmhnBOLjP8CCgm9SQOLs8Azqf3H69cXUe+ZDqGsJNsVyqgu4XmqoP9IeTJLNk2l
         //0jhii85ZMd5vOF7E688yX86AzktkkMYhlQ07aMMj+h5+afd2UQCp7atEt6iXXdF2LU
         RRh/vpBYAp69fsqpH8cadS17r2gGFQbSW0FSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Xuld3BlUHhLVm41JSQ0g37C/9G156A47j1pRWimdvw=;
        b=Gb0wJbstzRTYMeaoakwZh7JYY7NDXWdfL+0paFrLUsUOx9EoePHmmDsEKTZwMLiPbu
         9mWmOeE0D4xYjyHpA5CJQAYkEVKHs6xvoMKUewJsNzcpYXvNhBn7tM60R6ZJR4qUoxBN
         esxQlI/9jl39qh1DBe6+nq1j4WYAqP/kftSSYhvxYCnaIB0xPhp5qbxXdeBVd/jK1/88
         PsHvdyf9n1UcVbJJ9zAYpe2K+j+zA1Hb5SSJHmWHk6ljQYNrWBz5r2tPTZG54YjDTfdU
         Dp5d0PHYwAc1SG7VfqU5puyIxazbo/9I1I5V29tXe+HEtwLaTN5bJvTd7JWqzThBtwnD
         jtOg==
X-Gm-Message-State: APjAAAV09GXt1oOtwx4UMwZ+R42H6blrArT+FfeJKlylpxEdqrBfz61a
        lSdBqn2GcUztxv2CUDc/qzV5cfa1W84=
X-Google-Smtp-Source: APXvYqySblWB6JdngFq/+D8YP2SbHkope9yhhWxTiaTlb5YlzwLHnkKc+tvhkZMXLTLhN7uvAUl+AA==
X-Received: by 2002:a2e:3e09:: with SMTP id l9mr3912643lja.215.1568858895482;
        Wed, 18 Sep 2019 19:08:15 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id f5sm1276904lfh.52.2019.09.18.19.08.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 19:08:13 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id r2so1098523lfn.8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 19:08:13 -0700 (PDT)
X-Received: by 2002:ac2:5a4c:: with SMTP id r12mr3524864lfn.52.1568858892842;
 Wed, 18 Sep 2019 19:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190917152140.GU2229799@magnolia> <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
In-Reply-To: <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Sep 2019 19:07:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgXBV57mz46ZB5XivjiSBGkM0cjuvnU2OWyfRF=+41NPQ@mail.gmail.com>
Message-ID: <CAHk-=wgXBV57mz46ZB5XivjiSBGkM0cjuvnU2OWyfRF=+41NPQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.4
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 6:31 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Why would anybody use that odd "list_pop()" thing in a loop, when what
> it really seems to just want is that bog-standard
> "list_for_each_entry_safe()"

Side note: I do agree that the list_for_each_entry_safe() thing isn't
exactly beautiful, particularly since you need that extra variable for
the temporary "next" pointer.

It's one of the C++ features I'd really like to use in the kernel -
the whole "declare new variable in a for (;;) statement" thing.

In fact, it made it into C - it's there in C99 -  but we still use
"-std=gnu89" because of other problems with the c99 updates.

Anyway, I *would* be interested in cleaning up
list_for_each_entry_safe() if somebody has the energy and figures out
what we could do to get the c99 behavior without the breakage from
other sources.

For some background: the reason we use "gnu89" is because we use the
GNU extension with type cast initializers quite a bit, ie things like

    #define __RAW_SPIN_LOCK_UNLOCKED(lockname)      \
        (raw_spinlock_t) __RAW_SPIN_LOCK_INITIALIZER(lockname)

and that broke in c99 and gnu99, which considers those compound
literals and you can no longer use them as initializers.

See

    https://lore.kernel.org/lkml/20141019231031.GB9319@node.dhcp.inet.fi/

for some of the historical discussion about this. It really _is_ sad,
because variable declarations inside for-loops are very useful, and
would have the potential to make some of our "for_each_xyz()" macros a
lot prettier (and easier to use too).

So our list_for_each_entry_safe() thing isn't perfect, but that's no
reason to try to then make up completely new things.

             Linus
