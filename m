Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA0BC77B60
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 17:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjDDRyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 13:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbjDDRys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 13:54:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156191985
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 10:54:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn12so133969788edb.4
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 10:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680630885; x=1683222885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIyxAIGPNJ6SbPtpNjOu1Qfkl2Hkkt9S/yAzUM2lzjA=;
        b=BjZ6g30k3tXTaR1ElHCovjsyMj800Sze1s9Tcw9Ev95pHFqoS5rnzNDrvDsvN1ZgiE
         euIsSij/nTurebPJBIbuKAAHcsZjuqUhM83a+gWenoxNLMjLzXjxi/EYOJWyACsM2zsG
         FbTHBhaXYE5dC6nXu1pg3zDYK80M+wng698hU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680630885; x=1683222885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIyxAIGPNJ6SbPtpNjOu1Qfkl2Hkkt9S/yAzUM2lzjA=;
        b=PPEYOHqmRj8Aj6RpV/0eEvYV6v14WdKyBiJFNczbd2/khB9j7RUbgfpo7bX6QAa4df
         BeMOLFYb9ioVKz5fLU3OH0ACTjGX4htomMt+3bFhlCHH6Om3ku6hXGHa9Yitr6xazQM+
         4lKw/nuTvt60/OSEARKhtYs7jfR2Av27kJcA75GcVEnUjQkb4CwJuFMzITH5U9SDUYFk
         19NeET9BkpKxlRtxxluqHJFilwXr+rHMMkNeG7myFBuigjkJIqmNVFJtyHFlV59m9XQB
         nXWn9js27wBmSNwiMHq2RQVHRA63ycGJoAMRaXaGvQyLbpBgV6gyy8l6hqtPqg4+R9TY
         VvSw==
X-Gm-Message-State: AAQBX9fVJAQcuY2WvNcFHJSyOYSp9ZweCuXRDah3ieooQLl248sy6Sc9
        slGgj/ELuabVPNzs5odxbOrI1vxoSQuW/UUwNPTWaw==
X-Google-Smtp-Source: AKy350ZPeRDfxpz7bXaBflQKTuV+NH7RDmJxwYFbDsZ3TRbUD566ndeIoiPaR/LtAyudlJmqwshpWQ==
X-Received: by 2002:a17:906:3b4e:b0:932:fc34:88f with SMTP id h14-20020a1709063b4e00b00932fc34088fmr430999ejf.11.1680630885128;
        Tue, 04 Apr 2023 10:54:45 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 19-20020a170906025300b00925ce7c7705sm6237050ejl.162.2023.04.04.10.54.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 10:54:44 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id fi11so10445484edb.10
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 10:54:44 -0700 (PDT)
X-Received: by 2002:a17:906:3393:b0:933:7658:8b44 with SMTP id
 v19-20020a170906339300b0093376588b44mr166820eja.15.1680630883841; Tue, 04 Apr
 2023 10:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs> <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
In-Reply-To: <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 10:54:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
Message-ID: <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for ascii-ci
 dir hash computation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 10:07=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> +       if (c >=3D 0xc0 && c <=3D 0xd6)     /* latin A-O with accents */
> +               return true;
> +       if (c >=3D 0xd8 && c <=3D 0xde)     /* latin O-Y with accents */
> +               return true;

Please don't do this.

We're not in the dark ages any more. We don't do crazy locale-specific
crud. There is no such thing as "latin1" any more in any valid model.

For example, it is true that 0xC4 is '=C3=84' in Latin1, and that the
lower-case version is '=C3=A4', and you can do the lower-casing exactly the
same way as you do for US-ASCII: you just set bit 5 (or "add 32" or
"subtract 0xE0" - the latter is what you seem to do, crazy as it is).

So the above was fine back in the 80s, and questionably correct in the
90s, but it is COMPLETE GARBAGE to do this in the year 2023.

Because '=C3=84' today is *not* 0xC4. It is "0xC3 0x84" (in the sanest
simplest form), and your crazy "tolower" will turn that into "0xE3
0x84", and that not only is no longer '=C3=A4', it's not even valid UTF-8
any  more.

I realize that filesystem people really don't get this, but
case-insensitivity is pure and utter CRAP. Really. You *cannot* do
case sensitivity well. It's impossible. It's either locale-dependent,
or you have to have translation models for Unicode characters that are
horrifically slow and even then you *will* get it wrong, because you
will start asking questions about normalization forms, and the end
result is an UNMITIGATED DISASTER.

I wish filesystem people just finally understood this.  FAT was not a
good filesystem.  HFS+ is garbage. And any network filesystem that
does this needs to pass locale information around and do it per-mount,
not on disk.

Because you *will* get it wrong. It's that simple. The only sane model
these days is Unicode, and the only sane encoding for Unicode is
UTF-8, but even given those objectively true facts, you have

 (a) people who are going to use some internal locale, because THEY
HAVE TO. Maybe they have various legacy things, and they use Shift-JIS
or Latin1, and they really treat filenames that way.

 (b) you will have people who disagree about normal forms. NFC is the
only sane case, but you *will* have people who use other forms. OS X
got this completely wrong, and it causes real issues.

 (c) you'll find that "lower-case" isn't even well-defined for various
characters (the typical example is German '=C3=9F', but there are lots of
them)

 (d) and then you'll hit the truly crazy cases with "what about
compatibility equivalence". You'll find that even in English with NBSP
vs regular SPACE, but it gets crazy.

End result: the only well-defined area is US-ASCII. Nothing else is
even *remotely* clear. Don't touch it. You *will* screw up.

Now, if you *only* use this for hashing, maybe you will feel like "you
will screw up" is not such a big deal.

But people will wonder why the file 'Bj=C3=B6rn' does not compare equal to
the file 'BJ=C3=96RN' when in a sane locale, but then *does* compare equal
if they happen to use a legacy Latin1 one.

So no. Latin1 isn't that special, and if you special-case them, you
*will* screw up other locales.

The *only* situation where 'tolower()' and 'toupper()' are valid is
for US-ASCII.

And when you compare to glibc, you only compare to "some random locale
that happens to be active rigth n ow". Something that the kernel
itself cannot and MUST NOT do.

                Linus
