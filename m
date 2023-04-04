Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6B5C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 21:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbjDDVvM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbjDDVvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 17:51:11 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91F22710
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 14:51:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ek18so136326191edb.6
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 14:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680645068; x=1683237068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1Roy25wyNzUISjnKolbnuOe6hrcOm5IomviUJwyCH4=;
        b=AHnvNONwk8IY6GJCtkgr65Y2zZioH0pHfaHVdQvzOvCtIkUideK8MxjSb7Zcp9IIJP
         L5wlX9531+ZfVKY47H92ZVL5tLW224lZpXhnTdZuAt6oNsYrbNm20ml1kNvjsx4ie0A0
         HlyExRhSCR+VIJtyopfF8HIA9SbIQRgMqc5WE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680645068; x=1683237068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1Roy25wyNzUISjnKolbnuOe6hrcOm5IomviUJwyCH4=;
        b=mzPRhfhL4tNr1b6Mgks9kBD1e+7OyNCZN1CGAjYr+ea7SbsPPR7LE3rxBM0MNsB+zv
         iZDGWrhlq2kiCuLFqTvWvvNPpHvRDus/tIdRN13CzzOuYgA0+XMAiQ5iyvrKiJTBuFbh
         Me2Zc31p0icM07ksbXw8Rkktd9JSHZZvmStTc4gKJz6J3UVgppHxPNMsOkWCEDbegnWH
         LZdRwEEM3UjRFmrmVYZ8BpeCh0PwwND/lzXbXCSsgwba8Ppv/PdWuf4a9K7O7OaP/Ru0
         8BrXVmcWqvLoaAfV0KwvITBLIOzoss/BDgH5RsFL7jY6oxbvKzinT4uS7HUJH8vkCln/
         oEsg==
X-Gm-Message-State: AAQBX9cBhroHfdQwS0lqj+fVgfTyFvmFdnUn/ukmOQofWPSWt7UgJ7HL
        8SJHZEBe5mccyw9X5BnSs5VcZHug9jdIu16Clkf2wg==
X-Google-Smtp-Source: AKy350aS9ZJTfiEAKOMP/rTZ9kINz5ZWQsx3dNyn6IKwz51VBecueS+b51pWr/AFEryRItUezLZZSg==
X-Received: by 2002:a17:906:95c1:b0:8f6:dc49:337f with SMTP id n1-20020a17090695c100b008f6dc49337fmr814669ejy.43.1680645067870;
        Tue, 04 Apr 2023 14:51:07 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id lx4-20020a170906af0400b009327f9a397csm6563711ejb.145.2023.04.04.14.51.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 14:51:07 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id fi11so12783486edb.10
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 14:51:07 -0700 (PDT)
X-Received: by 2002:a17:906:3b07:b0:935:3085:303b with SMTP id
 g7-20020a1709063b0700b009353085303bmr503340ejf.15.1680645066955; Tue, 04 Apr
 2023 14:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <20230404171715.GE109974@frogsfrogsfrogs> <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
 <CAHk-=wiBm6VNykd5qH9y_SmL+Z8BJDXNwiny8Z0Yss86Wb6STw@mail.gmail.com> <20230404210009.GA303486@frogsfrogsfrogs>
In-Reply-To: <20230404210009.GA303486@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 14:50:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whTNuRyow=fBvCAP5LVGfhYJWNB1fZvQrjWge9eVXpQaQ@mail.gmail.com>
Message-ID: <CAHk-=whTNuRyow=fBvCAP5LVGfhYJWNB1fZvQrjWge9eVXpQaQ@mail.gmail.com>
Subject: Re: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 2:00=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> If it were up to me I'd invent a userspace shim fs that would perform
> whatever normalizations are desired, and pass that (and ideally a lookup
> hash) to the underlying kernel/fs.

No, really.

It's been done.

It sucks.

Guess what Windows has been doing for *decades* because of their
ass-backwards idiotic filesystem interfaces? Pretty much exactly that.

They had this disgusting wide-char thing for the native filename
interface, historically using something like UCS-2LE (sometimes called
UTF-16), and then people convert that back and forth in random ways.
Mostly in libraries so that it's mostly invisible to you, but

Almost exactly like that "If it were up to you".

It's BS. It's incredibly bad. It's taken them decades to get away from
that mistake (I _think_ the UCS-2 interfaces are all considered
legacy)

What Windows used to do (again: I _think_ they've gotten over it), was
to have those special native wchat_t interfaces like _wfopen(), and
then when you do a regular "fopen()" call it converts the "normal"
strings to the whcar_t interface for the actual system call. IOW,
doing exactly that "shim fs" thing wrt filenames.

Sprinkle special byte-order markers in there for completeness (because
UCS-2 was a mindblowingly bad idea along with UCS-4), and add ways to
pick locale on a per-call basis, and you have *really* completed the
unholy mess.

No. Don't do there.

There is absolutely *one* right way, and one right way only: bytes are
bytes. No locale crap, and no case insensitivity.

It avoids *all* the problems, doesn't need any silly conversions, and
just *works*.

Absolutely nobody sane actually wants case insensitivity. A byte is a
byte is a byte, and your pathname is a pure byte stream.

Did people learn *nothing* from that fundamental Unix lesson?  We had
all kinds of crap filesystems before unix, with 8.3 filenames, or
record-based file contents, or all kinds of stupid ideas.

Do you want your file contents to have a "this is Japanese" marker and
special encoding? No? Then why would you want your pathnames to do
that?

Just making it a byte stream avoids all of that.

Yes, we have special characters (notably NUL and '/'), and we have a
couple of special byte stream entries ("." and ".."), but those are
all solidly unambiguous. We can take US-ASCII as a given.

And once it's a byte stream, you can use it any way you want.

Now, the *sane* way is to then use UTF-8 on top of that byte stream,
and avoid all locale issues, but *if* some user space wants to treat
those bytes as Latin1 or as Shift-JS, it still "works" for them.

This is also the reason why a filesystem *MUST NOT* think the byte
stream is UTF-8, and do some kind of unicode normalization, and reject
- or replace - byte sequences that aren't valid UTF-8.

Thinking names should have some record-based structure is as wrong as
thinking that file contents should be record-based.

And *no*, you should not have some kind of "standardized translation
layer" in user space - that's just completely unnecessary overhead for
any actual sane user. It's exactly the wrong thing to do.

Others have been there, done that. Learn from their mistakes.

           Linus
