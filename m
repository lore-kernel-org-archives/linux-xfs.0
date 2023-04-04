Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5F3C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 18:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbjDDSTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbjDDSTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 14:19:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8814E421A
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 11:19:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w9so134246585edc.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680632391; x=1683224391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbrTPfR3qZqGGJQPxQAw32Dz9FCDOSxWxRJMs6hkEEs=;
        b=daQFFW2adhDFVdIaP2jK/9tfRTbPIOJLhrEOZLlw6kXOvaizjZITeC2Mh+GRIwC4rr
         dsmKEEolvNyQR1YEW9DXhuyVD/IQZ39J95o/IDqPvJC36ZYbXsrD8Is+qc6S7t3wFau2
         s717dQCCdWyuszsZSVBvYkqw5N+A3fqWsvacU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632391; x=1683224391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbrTPfR3qZqGGJQPxQAw32Dz9FCDOSxWxRJMs6hkEEs=;
        b=STulqErrdS6gyhqUQaTJyIzvK4MiBWtOrzNaBxo7oDZ8gW/DdXsnF47wJXb38Laaqc
         gEvJfZ8YnyhCy21t7pdyTpbyo7a+l18F3IsGOm34FItGeqCszIToX2EIscYTQBlWRSLk
         lWIq9OYdBb3QHORpXsZ8KuyLS7izKQmRR/Vl64TX+Td/T5O+dkOGZO4Pva+mZdG9oVJb
         DUVQ4LHP0lrbXLINSi93O8rtUilxYYHW9OH/uB5IS3I/p2TtrwTqg0RyISTKsDSWMV6A
         oVV7VBG2oEkVkZcUvp6PBt5scoBY3OiLStxzImMeUgG30CBDgKLTooNJI4KNYcPb/Spm
         7rbA==
X-Gm-Message-State: AAQBX9dtlijUPGzzNeUjuWuxHghwRxAwarf3fmU6ByhSnop/iq48s0JU
        xJvR09jXzo0VoySyReHe3F5bGU4XF8qNUDUWXbl04g==
X-Google-Smtp-Source: AKy350ajosy8RufKoRtvaiGYuhqw7/xnYpTMWYMLCRgUVk4wW/NiXb0cfrxc6FmSizWWSxBXAgcoag==
X-Received: by 2002:a17:906:868c:b0:947:4828:4399 with SMTP id g12-20020a170906868c00b0094748284399mr472565ejx.12.1680632390797;
        Tue, 04 Apr 2023 11:19:50 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id tc27-20020a1709078d1b00b009231714b3d4sm6278448ejc.151.2023.04.04.11.19.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:19:50 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id w9so134246259edc.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 11:19:50 -0700 (PDT)
X-Received: by 2002:a50:9b12:0:b0:502:227a:d0da with SMTP id
 o18-20020a509b12000000b00502227ad0damr226368edi.2.1680632389465; Tue, 04 Apr
 2023 11:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs> <20230404171715.GE109974@frogsfrogsfrogs>
In-Reply-To: <20230404171715.GE109974@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Apr 2023 11:19:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
Message-ID: <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
Subject: Re: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 4, 2023 at 10:17=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> My finger slipped and I accidentally added you to the To: list on this
> new series.  This series needs to go through review on linux-xfs; when
> this is ready to go I (or Dave) will send you a pull request.
>
> Sorry about the noise.

No, it's good. See my rant emails.

Case insensitivity is a subject near and dear to my heart.

And when I say "near and dear to my heart", I obviously mean "I
despise it, and I have spent _decades_ ranting against it and trying
to explain why it's a problem".

I've ranted against it before, but it's been probably a decade since I
needed to. I was hoping this was long behind us.

I'm surprised people still think it's even acceptable.

FAT isn't known for being a great filesystem. HFS+ was garbage, but
even Apple eventually got the message and tried to make APFS better.
I'm not sure Apple succeeded (maybe the case insensitivity is still
the default on OS X, but apparently at least iOS got the message).

Every single case-insensitive filesystem in the world HAS BEEN CRAP.
Please. Learn from literally decades of reality, and stop doing it.

And if you have to do it for some legacy reason, at least understand
the problems with it. Understand that you DO NOT KNOW what the user
space locale is.

Limiting yourself to US-ASCII is at least technically valid. Because
EBCDIC isn't worth worrying about.  But when the high bit is set, you
had better not touch it, or you need to limit it spectacularly.

                   Linus
