Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CFCC6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 20:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbjDDUVq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDDUVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 16:21:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65A30DC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 13:21:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so135552937edd.5
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 13:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680639703; x=1683231703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6J99aw6LCJ91W2mHXS3DcrfO2N0pMBoRdpys2Z4/niM=;
        b=T/HOvBwdCkvpQjm+mNTLj7Wel17j0wMIuuSQxfEJRTbwO4tWD11FuQ3EkRYda0K1xE
         Dl24YkRM2EaKSHHWTt3D7YDPHK1+h2a9vBtfRPoLc0qSaLdnIkLNaTuPkM837yAs75Nm
         HpgfshHbzNsxE85j7gKa7ZAJ82koak+ROv71g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680639703; x=1683231703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6J99aw6LCJ91W2mHXS3DcrfO2N0pMBoRdpys2Z4/niM=;
        b=49NBtA2Lcs0JZANzF0gdZEdMJEgqpvT0Y4xLg+7pDmhRtX/13oRd7qs5lXdQ8J3y4J
         gJAAftVLvD7RdWN3A9cleZ+Cv7XkvH9gmlcz3cVN+T+RW8QcXTnMZGRbXwFOaZiHlM24
         GnlcotiIyM8WLazm66KajK207hwHE1IQzWRxCKE26Avyadmvbbtp3r8gXSfBLf1/cUeh
         SjOdY51zkAQ1dP8EIIXJIi8LFhL5fjB9AFb4Ny85DlggxIj2W/u/YelSqVAH2WIXaHlo
         bnAx+UtteGfpJO7Z/Kdxo1FV5upZNQ6iizUIG31rlLHIJpRh7s7K1mjOUn16bvaYDtku
         L3lw==
X-Gm-Message-State: AAQBX9eeFak5RRkl84vxOam4IXhYl0VKTPT3/nf6KWDY5VjjqoS+7nBs
        IQJjpid1w3knDYqYGx/d9rBbl+s9dUw3kUIxophH7A==
X-Google-Smtp-Source: AKy350Z+IeidUgNu4c+lJeovY/5wNu37Ebs9dBHfF5L6D6nOmLXLu7YcQUdzUW5xbb0AGsg8rIhnBQ==
X-Received: by 2002:a17:906:d79b:b0:93f:9b68:a0f4 with SMTP id pj27-20020a170906d79b00b0093f9b68a0f4mr305966ejb.26.1680639702966;
        Tue, 04 Apr 2023 13:21:42 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id gw22-20020a170906f15600b0093debb9990esm6369646ejb.212.2023.04.04.13.21.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 13:21:42 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id t10so135367170edd.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 13:21:42 -0700 (PDT)
X-Received: by 2002:a50:a6d1:0:b0:502:7551:86c7 with SMTP id
 f17-20020a50a6d1000000b00502755186c7mr296720edc.4.1680639701885; Tue, 04 Apr
 2023 13:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <20230404171715.GE109974@frogsfrogsfrogs> <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
In-Reply-To: <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 13:21:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiBm6VNykd5qH9y_SmL+Z8BJDXNwiny8Z0Yss86Wb6STw@mail.gmail.com>
Message-ID: <CAHk-=wiBm6VNykd5qH9y_SmL+Z8BJDXNwiny8Z0Yss86Wb6STw@mail.gmail.com>
Subject: Re: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 11:19=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Limiting yourself to US-ASCII is at least technically valid. Because
> EBCDIC isn't worth worrying about.  But when the high bit is set, you
> had better not touch it, or you need to limit it spectacularly.

Side note: if limiting it to US-ASCII is fine (and it had better be,
because as mentioned, anything else will result in unresolvable
problems), you might look at using this as the pre-hash function:

    unsigned char prehash(unsigned char c)
    {
        unsigned char mask =3D (~(c >> 1) & c & 64) >> 1;
        return c & ~mask;
    }

which does modify a few other characters too, but nothing that matters
for hashing.

The advantage of the above is that you can trivially vectorize it. You
can do it with just regular integer math (64 bits =3D 8 bytes in
parallel), no need to use *actual* vector hardware.

The actual comparison needs to do the careful thing (because '~' and
'^' may hash to the same value, but obviously aren't the same), but
even there you can do a cheap "are these 8 characters _possibly_ the
same) with a very simple single 64-bit comparison, and only go to the
careful path if things match, ie

    /* Cannot possibly be equal even case-insentivitely? */
    if ((word1 ^ word2) & ~0x2020202020202020ul)
        continue;
    /* Ok, same in all but the 5th bits, go be careful */
    ....

and the reason I mention this is because I have been idly thinking
about supporting case-insensitivity at the VFS layer for multiple
decades, but have always decided that it's *so* nasty that I really
was hoping it just is never an issue in practice.

Particularly since the low-level filesystems then inevitably decide
that they need to do things wrong and need a locale, and at that point
all hope is lost.

I was hoping xfs would be one of the sane filesystems.

               Linus
