Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F666C77B7F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 18:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbjEKSGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbjEKSE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 14:04:58 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B33A25D
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 11:04:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bc040c7b8so13633874a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 11:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683828261; x=1686420261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tq0wkRXsDijvxAg3WZO7PtPNDzCMR+Rqhu2o3ecf71A=;
        b=Z2VZPieHre8OnI+bvP8PRkME++R8T+xigqYBLWeVdRJzuheGvtb5pEAYuW+fcZwyhV
         ty8iPh6F2cptqx9QkNQkUaEuE5y0cIsSVWFvv/Lg7w8n9UY6bSySXhllhQO0If9dEwzE
         FwZ2JZADUDZfKES7Fxuw9ERU1UTg74N831rXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683828261; x=1686420261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tq0wkRXsDijvxAg3WZO7PtPNDzCMR+Rqhu2o3ecf71A=;
        b=DOUMYR3/3tRphTFVP8K0d6UwvzYPo9MQ48ybFtm1/iLgr88wbzaCv6CLSy9MYg+PqB
         zZUC/vvXjppfI5VcIvickK+b3mqj/wqeKrr8VbFmXSzXWF69bSPlT1OW2zAAq/RqI8VI
         w9dwUkbZfujfbYq6OJHkn7Ymj6kcdYF1t5vdQqmxFJG0ncgKse2whUiqDIzsxpziY1xL
         MamFCKQ1fuhpNSeh/Fd3yQO3WSxWavbewPL2md1VBzPNtlt4fZGCmiy1bizFNrLmrEkK
         G4AG13WA5FNWQzULrJHVJRt9sGgiVz2svih+/XGm9S1C/H2sejPKsyLugg3U0syNTYyh
         T8sg==
X-Gm-Message-State: AC+VfDyRug0kZS7JfKr+KU9zt9rZ8ICa9MtDqnZe48DMR2uyh8SkXVWe
        CLa++G2Wjs3A6UhVhIuHMPq+ZHRSMxhq4TpK+4S06LSY
X-Google-Smtp-Source: ACHHUZ4U7zx+iRQdogDSt+A61OoADSNnbySM0N1wspSThQgH0J6kUFsOt4Od4MBqXOAsHYaepg5lIQ==
X-Received: by 2002:a17:907:da5:b0:94a:67a9:6052 with SMTP id go37-20020a1709070da500b0094a67a96052mr22651539ejc.67.1683828260960;
        Thu, 11 May 2023 11:04:20 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id l17-20020a170907915100b0095004c87676sm4311775ejs.199.2023.05.11.11.04.20
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 11:04:20 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-9659443fb56so1400563666b.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 11:04:20 -0700 (PDT)
X-Received: by 2002:a17:907:5c6:b0:939:e870:2b37 with SMTP id
 wg6-20020a17090705c600b00939e8702b37mr19641025ejb.70.1683828260174; Thu, 11
 May 2023 11:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230511015846.GH2651828@dread.disaster.area> <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
 <20230511165029.GE858799@frogsfrogsfrogs> <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
In-Reply-To: <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 May 2023 13:04:02 -0500
X-Gmail-Original-Message-ID: <CAHk-=whFBmrdnqOqDDsF42Cf6M60kOethMWkMr1FYXSRXJDSkA@mail.gmail.com>
Message-ID: <CAHk-=whFBmrdnqOqDDsF42Cf6M60kOethMWkMr1FYXSRXJDSkA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 11, 2023 at 12:47=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So if you can confirm that it was just that one smatch warning line
> and nothing else, then I'll happily do that pull.

Oh, and in case you wonder what the warning actually is about -
because some smatch warnings *are* worth looking at - that "ignoring
unreachable code" is generally things like case statements that have
all cases handled and no "break;" in any of the cases, and then
there's a "return" afterwards anyway.

It can be a sign of some logic error, though, so building smatch and
looking at what it reports could certainly be worthwhile. But no, a
smatch failure is very much not a fatal issue.

                  Linus
