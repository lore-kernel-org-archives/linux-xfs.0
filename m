Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8D1C4CEC9
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 01:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AFC121927
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568856710;
	bh=YS2D8KhCcn+D9Tai9PAqGE6zTsldXzlFkafNRLuhDFw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lCJ/8FgRlQlYotgUJPaK0p/iNSNfJszuampOwjwLckaRwMfLpw+QfuCls9Bp/VKGt
	 uDPjEzbcnlKcRae3CvNW+OLvGVQ369XCgenc7SN/OPHKCB3X/gjbWaQFu1GE13aSB9
	 jiFTBcHOHVN4G+aHEcRkcsSzR2XdXnCBbo6WwAgM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbfISBbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 21:31:50 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45176 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfISBbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 21:31:49 -0400
Received: by mail-lf1-f66.google.com with SMTP id r134so1030373lff.12
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 18:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJ4ydVPnUk1MpO9iHZC8eadZdfXIfU9vawn2F3Ib1fo=;
        b=A0YUpl9WGKzUNGpQlDZCnUNq6eUYinpLyOjjYEWw9qMpylivgUSR6LUyPDngKcRQfO
         CG9fCIJMna6iMWF1LQ7ztmKybh1kW4q5WyqsVkqC2UC0ZmH4W8gyqqZ+vDToxilfbXhs
         SCFR9Wb1ioaYc1GAqKixI4+MGwt/qdu3yOajg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJ4ydVPnUk1MpO9iHZC8eadZdfXIfU9vawn2F3Ib1fo=;
        b=TdhRwHWr2AY3LxBkWqtPiE7AJ6JjYyuIFUGQRdd4JTSyZoAivA2fUPQR/1nPcyoStS
         8yWZTcby+BHTl0py7dibj1jprHbCcFB4WWc3EYeq92Y0H0YprUKTeEc33CSXbO0QAtSp
         Dhitu4wzJd6Is0mz1Sd093afRf1ww785HTl3h0TW+O8E2waZLP6s/1gkuanOgb83GuF6
         BnNSPuHZrVMvFybgRUW42roiWLLDsfhwJbbRpJM0q3wZ/0daOfcdS44r7Pux9jazNInk
         pX80RNOH/El89BcmZovah/FV0rCHpPd0YZxpsJUdbt2CMLzwwBWQj6+NoODTK8T/iDJQ
         ifAg==
X-Gm-Message-State: APjAAAWTofT+eQzeA/CfDkXa6/VF1LeMZ2nsBp7WEicZ99INr60cTO3g
        8z0npGZjy8qH+l0lGu8X9PB/lbKeB3s=
X-Google-Smtp-Source: APXvYqybi//yG8U4wdJDDJHx4UlDxJ1NHx4z7Yc11YdHO8m1zpcMt+vBxlnkXqNbzJdthM+rMGVJqA==
X-Received: by 2002:ac2:4114:: with SMTP id b20mr3637577lfi.19.1568856707489;
        Wed, 18 Sep 2019 18:31:47 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id a14sm1269552lfg.74.2019.09.18.18.31.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 18:31:46 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id c195so1044435lfg.9
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 18:31:46 -0700 (PDT)
X-Received: by 2002:a19:f204:: with SMTP id q4mr3489622lfh.29.1568856706072;
 Wed, 18 Sep 2019 18:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190917152140.GU2229799@magnolia>
In-Reply-To: <20190917152140.GU2229799@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Sep 2019 18:31:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
Message-ID: <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
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

On Tue, Sep 17, 2019 at 8:21 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please pull this series containing all the new iomap code for 5.4.

So looking at the non-iomap parts of it, I react to the new "list_pop() code.

In particular, this:

        struct list_head *pos = READ_ONCE(list->next);

is crazy to begin with..

It seems to have come from "list_empty()", but the difference is that
it actually makes sense to check for emptiness of a list outside
whatever lock that protects the list. It can be one of those very
useful optimizations where you don't even bother taking the lock if
you can optimistically check that the list is empty.

But the same is _not_ true of an operation like "list_pop()". By
definition, the list you pop something off has to be stable, so the
READ_ONCE() makes no sense here.

Anyway, if that was the only issue, I wouldn't care. But looking
closer, the whole thing is just completely wrong.

All the users seem to do some version of this:

        struct list_head tmp;

        list_replace_init(&ioend->io_list, &tmp);
        iomap_finish_ioend(ioend, error);
        while ((ioend = list_pop_entry(&tmp, struct iomap_ioend, io_list)))
                iomap_finish_ioend(ioend, error);

which is completely wrong and pointless.

Why would anybody use that odd "list_pop()" thing in a loop, when what
it really seems to just want is that bog-standard
"list_for_each_entry_safe()"

        struct list_head tmp;
        struct iomap_ioend *next;

        list_replace_init(&ioend->io_list, &tmp);
        iomap_finish_ioend(ioend, error);
        list_for_each_entry_safe(struct iomap_ioend, next, &tmp, io_list)
                iomap_finish_ioend(ioend, error);

which is not only the common pattern, it's more efficient and doesn't
pointlessly re-write the list for each entry, it just walks it (and
the "_safe()" part is because it looks up the next entry early, so
that the entry that it's walking can be deleted).

So I pulled it. But then after looking at it, I unpulled it again
because I don't want to see this kind of insanity in one of THE MOST
CORE header files we have in the whole kernel.

If xfs and iomap want to think they are "popping" a list, they can do
so. In the privacy of your own home, you can do stupid and pointless
things.

But no, we don't pollute core kernel code with those stupid and
pointless things.

              Linus
