Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0ED2C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E65613DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhD1HPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhD1HPr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 03:15:47 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16413C061574
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 00:15:02 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u25so32765517ljg.7
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 00:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2trmDmrES1vVQ7MkvzuigMktNd+5Uu8WJZCEuhx2j9k=;
        b=bnZgnhtwJyLjtTy5vmaj8YAjBKDEQY5lmjCgKYGh8YGFiCZZzopCvoZbZ7YoiiTDT1
         4+D/Kkm5FMJkOo6ybFblObnEkJxbH+08OQLqfQ1Adrp6f6VVhrKh0lVGGvGz2TSEFDfv
         JLosd0pI6c15WAyKEgMeO/Ocn3lty7Zhcie8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2trmDmrES1vVQ7MkvzuigMktNd+5Uu8WJZCEuhx2j9k=;
        b=By0BdAgwJMJ0rraiANUm93szFJeTKmhD0UsvqY45/q3JsaSYHUCC6iHeGPxt8nHzsq
         /35sfJvGFe4pyYuPaR7b5dGc8433GQeivWYrZZTeBVMXS5fyEh7zErTn+nkWb5wQaV4s
         xgWEMTvaXC+l5m8j/vCAnGYSGYGioXScU5WVYAYWHrxZiNYinJfeRynikNmN0rXOKGtF
         kFgEvMr9vVxZg2+/FgyxwxbcwMu0LeEZ1l8F+eD8Gp0kZZEUhDxpegqcRQt2Thv+UyrR
         v78VsMBiW6nZi8AQQEpLkGc8GVq1bcf561i2Ps6wNhmEwDdQvdZfJuTZHmBDXxZqkSbG
         YIrQ==
X-Gm-Message-State: AOAM531M0ZvRNa4MUJxUOm0vncYKtYSItUPodz55NKgDbJKuDCl0IDIt
        Axe7xOaulue4M4q/adMY5C5GSwVb+MhwsToh
X-Google-Smtp-Source: ABdhPJwPS1w7Fn7G4FXXEH7oXaLwPB38HnhPZ+B1PcOC4RVpUM1BcaQZ/4emE5cWE6kgU2hFtJ08UQ==
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr19529956ljp.227.1619594099983;
        Wed, 28 Apr 2021 00:14:59 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id d20sm512225lfn.41.2021.04.28.00.14.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 00:14:58 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id o5so38012143ljc.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 00:14:58 -0700 (PDT)
X-Received: by 2002:a05:651c:1117:: with SMTP id d23mr20222349ljo.220.1619594098444;
 Wed, 28 Apr 2021 00:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de> <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
 <20210428061706.GC5084@lst.de> <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
 <20210428064110.GA5883@lst.de>
In-Reply-To: <20210428064110.GA5883@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Apr 2021 00:14:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
Message-ID: <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: multipart/mixed; boundary="000000000000eb859705c10322ab"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--000000000000eb859705c10322ab
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 27, 2021 at 11:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> "you guys" here is purely me, so I take the blame.  And no, I actually
> did have a first version usind %pD, tested it and looked at the output
> and saw how it stripped the actual useful part of the path, that is the
> first components.

So that's why I cc'd Al and Jia.

You may not have realized that the default for %pD is to show only one
component, and if you want to see more, you need to use something like
%pD4.

Which should be _plenty_.

But it's also something where I think that default (ie "no number")
behavior may be a bit surprising, and perhaps not the greatest
interface.

So let me just quote that first reply of mine, because you seem to not
have seen it:

> We have '%pD' for printing a filename. It may not be perfect (by
> default it only prints one component, you can do "%pD4" to show up to
> four components), but it should "JustWork(tm)".
>
> And if it doesn't, we should fix it.

I really think %pD4 should be more than good enough. And I think maybe
we should make plain "%pD" mean "as much of the path that is
reasonable" rather than "as few components as possible" (ie 1).

So I don't think "%pD" (or "%pD4") is necessarily perfect, but I think
it's even worse when people then go and do odd ad-hoc things because
of some inconvenience in our %pD implementation.

For example, changing the default to be "show more by default" should
be as simple as something like the attached.  I do think that would be
the more natural behavior for %pD - don't limit it unnecessarily by
default, but for somebody who literally just wants to see a maximum of
2 components, using '%pD2' makes sense.

(Similarly, changing the limit of 4  components to something slightly
bigger would be trivial)

Hmm?

Grepping for existing users with

    git grep '%pD[^1-4]'

most of them would probably like a full pathname, and the odd s390
hmcdrv_dev.c use should just be fixed (it has a hardcoded "/dev/%pD",
which seems very wrong).

Of course, %pD has some other limitations too. It doesn't follow
mount-points up. It's kind of intentionally a "for simple
informational uses only", but good enough in practice exactly for
things like debug printouts.

             Linus

--000000000000eb859705c10322ab
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_ko143u320>
X-Attachment-Id: f_ko143u320

IGxpYi92c3ByaW50Zi5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYi92c3ByaW50Zi5jIGIvbGliL3ZzcHJp
bnRmLmMKaW5kZXggNmM1NmM2MmZkOWE1Li41YjU2Mzk1M2Y5NzAgMTAwNjQ0Ci0tLSBhL2xpYi92
c3ByaW50Zi5jCisrKyBiL2xpYi92c3ByaW50Zi5jCkBAIC04ODAsMTEgKzg4MCwxMSBAQCBjaGFy
ICpkZW50cnlfbmFtZShjaGFyICpidWYsIGNoYXIgKmVuZCwgY29uc3Qgc3RydWN0IGRlbnRyeSAq
ZCwgc3RydWN0IHByaW50Zl9zcAogCWludCBpLCBuOwogCiAJc3dpdGNoIChmbXRbMV0pIHsKLQkJ
Y2FzZSAnMic6IGNhc2UgJzMnOiBjYXNlICc0JzoKKwkJY2FzZSAnMSc6IGNhc2UgJzInOiBjYXNl
ICczJzogY2FzZSAnNCc6CiAJCQlkZXB0aCA9IGZtdFsxXSAtICcwJzsKIAkJCWJyZWFrOwogCQlk
ZWZhdWx0OgotCQkJZGVwdGggPSAxOworCQkJZGVwdGggPSA0OwogCX0KIAogCXJjdV9yZWFkX2xv
Y2soKTsK
--000000000000eb859705c10322ab--
