Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4CFC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0091921907
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568912632;
	bh=MONPxZZQ9H7FCHb02M2zPOYkSXure61GJtN6KikJuV8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=BuUJFb2rVCduj7ODPRVwE4r/R+9soPGUC9XfsjdiTxx72ObQnoP1si1GP4tcJpheR
	 JrwNE1wv5xOLflYpbShzVENXWfyGYrusKzYfNjwfQzj1GY2xn9ftkHBRLoh0ev2Osv
	 J7g2AFHMCrXLwBrtOj9meR7AwTM6+mC2YD6Wz9ps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbfISRDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:03:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39447 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732529AbfISRDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 13:03:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id 72so2915246lfh.6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+Le165FOxvtzRMwfFqjOH0U+XVnKpWjfAd4ukIEWR4=;
        b=FL9rhk1LXaWaOToMWtkofnf+ifZC7L6LjK+IHdHsF/ZjKrMGyWQHvozYfnjOkbc2Aa
         NaQT+Ln1+A5psdVMqEdRU37SGn1dPcL1GnHoARhDT9QcKBubA/swLTsvj8azaK1+sKlm
         HBGHGssbScaIPzuXiY0UhyHgSHDfp0ZEzinrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+Le165FOxvtzRMwfFqjOH0U+XVnKpWjfAd4ukIEWR4=;
        b=QvQ0sTQikILYUMZb34Vfw6c2MrtWe++VnwbSzZP4pa5Yb3Td2EnElMFZYgEMOnKtHJ
         5N7BdQ3fkmIypikNvJuDwOO/fYVZUGr9D6U5hYV4HQLnih7c635mJbdqNFUWotk3DQVL
         cX2DEKL3UHJtnXtgdes4g9witYP+zBm5Bt3LdoVQZewwnz6dGvcYZbSy7nK1qpo1vXfT
         kn2dIjnZAfv9RlJErkhoS92jqwEkOwAjAxB0PKkgdX63Zlhf7kpEofyw38exDMr6K0SC
         3KaFLTlaMj4YAwCtr6UA/u94CjW9CdKnuGPvN6QmEfnHdbKbrgtpBhuTX0UJ+JFFxYDK
         k4ig==
X-Gm-Message-State: APjAAAWl406uToXG++blgaYHs+038zWDOWPEyra/YTbUEKqCvfZw83Tn
        aLPcuOnHNWLb8gVIYBvX79QnFcS6MVU=
X-Google-Smtp-Source: APXvYqwZ422x86ULPPXdG7zQEu151zurQR1xyjfHWS1vopUVrJmasIjzxpD2iC8J/MrKkmuzD6lX4A==
X-Received: by 2002:a05:6512:512:: with SMTP id o18mr5649193lfb.153.1568912628509;
        Thu, 19 Sep 2019 10:03:48 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id x76sm2056292ljb.81.2019.09.19.10.03.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 10:03:47 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id u28so2920192lfc.5
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:03:47 -0700 (PDT)
X-Received: by 2002:ac2:5c11:: with SMTP id r17mr5667771lfp.61.1568912626555;
 Thu, 19 Sep 2019 10:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190917152140.GU2229799@magnolia> <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
 <20190919034502.GJ2229799@magnolia>
In-Reply-To: <20190919034502.GJ2229799@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Sep 2019 10:03:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFRM=z6WS-QLThxL2T1AaoCQeZSoHzj8ak35uSePQVbA@mail.gmail.com>
Message-ID: <CAHk-=wgFRM=z6WS-QLThxL2T1AaoCQeZSoHzj8ak35uSePQVbA@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.4
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
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

On Wed, Sep 18, 2019 at 8:45 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> I propose the following (assuming Linus isn't cranky enough to refuse
> the entire iomap patchpile forever):

Since I don't think the code was _wrong_, it was just that I didn't
want to introduce a new pattern for something we already have, I'd be
ok with just a fix patch on top too.

And if the xfs people really want to use the "pop" model, that's fine
too - just make it specific to just the iomap_ioend type, which is all
you seem to really want to pop, and make the typing (and naming) be
about that particular thing.

As mentioned, I don't think that whole "while (pop)" model is _wrong_
per se.  But I also don't like proliferating new random list users in
general, just because some subsystem has some internal preference.
See?

And I notice that one of the users actually does keep the list around
and modifies it, ie this one:

        while ((ioend = list_pop_entry(&tmp, struct xfs_ioend, io_list))) {
                xfs_ioend_try_merge(ioend, &tmp);
                xfs_end_ioend(ioend);
        }

actually seems to _work_ on the remaining part of the list in that
xfs_ioend_try_merge() function.

So inside of xfs, that "pop ioend from the list" model really may make
perfect sense, and you could just do

    static inline struct xfs_ioend *xfs_pop_ioend(struct list_head *head)
    {
        struct xfs_ioend *ioend = list_first_entry_or_null(head,
struct xfs_ioend *, io_list);
        if (ioend)
                list_del(&ioend->io_list);
        return ioend;
    }

and I don't think it's wrong.

It's just that we've survived three decades without that list_pop(),
and I don't want to make our header files even bigger and more complex
unless we actually have multiple real users.

             Linus
