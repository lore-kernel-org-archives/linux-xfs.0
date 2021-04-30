Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7ACC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 19:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5746145B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 19:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhD3TD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 15:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3TD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 15:03:27 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66253C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 12:02:38 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s25so1471694lji.0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 12:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v06I/GWg3EwPlU1YR85dzjFdybBe49tFpVbSc13sT5g=;
        b=Galr3BSlX33rXt2K8EQHGRcZrM5ViYGKWBw38IzYWCRrSddOBancyNAJf2LZtMxP3T
         bF0ymVMvrFneKi7IRMGXFgsKK1yQqrbrajNH0kNjN/vFDn+oQe8qOwe7lgYDibKEbxCT
         BjkEdBDtoriE8DaKOtpJmKPGutBN74277b2es=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v06I/GWg3EwPlU1YR85dzjFdybBe49tFpVbSc13sT5g=;
        b=WpSf6BXkEQtSu29WQM/uAH1zV3cI85iyG/p5UJtI04gdrCE8y+v9G1lfL005CZzXDC
         5r+fTRKk2cTwx1jKizCbWyaIXkSNbBrvy6IvChfzXOui0DwEC0e6Le7fwyDt+zdqwBP1
         mYS6dugCD0ka0gV7ewy70jWgwxARbT90gIuyTgOqYZ4a6+qEIfQHkzEI6mLQffgGJcZr
         jc2Xv16tpC2thHtPECWvzg1iNiFg1crSW85zS8HDQs5AaqA38zNMWSg8owW/cYkWRzPN
         PcMdDZ9teq2dQPk/+EDdzNeVElhxcPsRbyBin9LarxRu+W3QSe+O/TaZDWGVA7+kxjPo
         QSZA==
X-Gm-Message-State: AOAM533o+ScrsrluQ4xJg6lYUPOGD1XJVU5cVnuxnQfhVQTl1Az4OP9W
        3uvGRZc8SnR0nfXvta4rkVuKRBrtH4z4k4aU
X-Google-Smtp-Source: ABdhPJwby0Al7nYRf5q72c9HZT0rL05ByOR3EvbzUTZQmgBFbZnvYRKMCPNUfJw/mDcK/jCGfZO10w==
X-Received: by 2002:a2e:720f:: with SMTP id n15mr4665353ljc.400.1619809356758;
        Fri, 30 Apr 2021 12:02:36 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id m5sm357178lfl.303.2021.04.30.12.02.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 12:02:35 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id p12so5102202ljg.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 12:02:35 -0700 (PDT)
X-Received: by 2002:a2e:989a:: with SMTP id b26mr4719544ljj.465.1619809355301;
 Fri, 30 Apr 2021 12:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de> <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
 <20210428061706.GC5084@lst.de> <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
 <20210428064110.GA5883@lst.de> <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
 <1de23de2-12a9-2b13-3b86-9fe4102fdc0c@rasmusvillemoes.dk> <CAHk-=wimsMqGdzik187YWLb-ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com>
 <26d06c27-4778-bf75-e39a-3b02cd22d0e3@rasmusvillemoes.dk> <CAHk-=whJmDjTLYLeF=Ax31vTOq4PHXKo6JUqm1mQNGZdy-6=3Q@mail.gmail.com>
 <m135v7y5c5.fsf@fess.ebiederm.org>
In-Reply-To: <m135v7y5c5.fsf@fess.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 12:02:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgjTongV9B_2gSaY9xVhw9oK8Bc+uOara-CLuSsk7fBpQ@mail.gmail.com>
Message-ID: <CAHk-=wgjTongV9B_2gSaY9xVhw9oK8Bc+uOara-CLuSsk7fBpQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Hellwig <hch@lst.de>,
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

On Fri, Apr 30, 2021 at 11:50 AM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> A printk specific variant could easily be modified to always restart or
> to simply ignore renames and changes to the mount tree.

Exactly. I think a "ignore renames and mount tree changes" version for
printk would be the right thing.

Yeah, you can in theory get inconsistent results, but everything is
RCU-protected, so you'd get the same kind of "its' kind of valid, but
in race situations you might get a mix of two components" that '%pd'
gives for a dentry case.

That would allow people to use '%pD' and get reasonable results,
without having them actually interact with locks (that may or may not
be held by the thread trying to print debug messages).

           Linus
