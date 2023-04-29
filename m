Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3E9C77B60
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Apr 2023 17:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjD2Rvw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Apr 2023 13:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjD2Rvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Apr 2023 13:51:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611A0183
        for <linux-xfs@vger.kernel.org>; Sat, 29 Apr 2023 10:51:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f109b1808so203583366b.1
        for <linux-xfs@vger.kernel.org>; Sat, 29 Apr 2023 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682790708; x=1685382708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REehFERuIVF/Wkn2IkWHsEhjZNuUytmkUX0wyPW0A9c=;
        b=TS1xiOXU3ldUAnbFb7xfBPbb+oAJoqC4xXYXnNQLASFej9NyXymEoS4CKJVCIWA3il
         RDjB6/yY4KAJxs6wW6zV+UVTpTyhV+UodxHxcECcNFoumMuw1xQADfjvXA5xgJ+1+uVZ
         FQPyrzfu7VjXn95sF7qNL//YSdVTjSMSvXeyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682790708; x=1685382708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REehFERuIVF/Wkn2IkWHsEhjZNuUytmkUX0wyPW0A9c=;
        b=gMjLzQQ/KhfREBE+8bU2sDdVm1xfExFFER/uWwoWm7tXeLQ7kdn7lnrpApS8KCiwI+
         38YCkbBRyPBvPcodbho2vIULFr3/EI3EXH6t3Ef4hF1RytT1QYQ7Y0kxpvHtICnKHr9V
         bpeFsqORxlCOj/0/8BgYI1QlIZvnAvL35VsklLG4xnQQJgGRvFF/m6Fi5jbsmq+ND6uV
         NzzBhy6ElJZw9btF+0UVx6qKCOGpsH6nKFp5RQYjgMdCff/EC4C2mP5IqT/7dwmWO86p
         hqIGRg6QHYDT/QzyJMPzo/jV0wJ6DPLJFneF9mDgarobplxIAXKJfgUPiOK5mAP/hzLR
         8UoA==
X-Gm-Message-State: AC+VfDybx/8UylrbtHbH6KfTzLEKrQrSz8LYrEuTV0X0hl5IKQ8qG/I7
        PCLjo6F8w0yjs8phOpggKkue5Vmoxu0h+uUqp8RUkqHF
X-Google-Smtp-Source: ACHHUZ4BMEUMe/bv+Q8adwqTHsrk1ejCZ+aTo4DnEzz7ud1tBH4msIPK8K7o+9j9zg3CyqgLMCQiqg==
X-Received: by 2002:a17:907:1c9f:b0:92b:f118:ef32 with SMTP id nb31-20020a1709071c9f00b0092bf118ef32mr9658348ejc.48.1682790708652;
        Sat, 29 Apr 2023 10:51:48 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id o15-20020aa7c7cf000000b005021d210899sm10268518eds.23.2023.04.29.10.51.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 10:51:47 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-50bc075d6b2so276081a12.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Apr 2023 10:51:47 -0700 (PDT)
X-Received: by 2002:a05:6402:1345:b0:506:7f78:c4cc with SMTP id
 y5-20020a056402134500b005067f78c4ccmr2212641edw.27.1682790707444; Sat, 29 Apr
 2023 10:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230428231655.GW3223426@dread.disaster.area>
In-Reply-To: <20230428231655.GW3223426@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 29 Apr 2023 10:51:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgsD_8xT4v+HJkSxTLCkb7Nv1dHCGfSyNLzFaj18SJvGA@mail.gmail.com>
Message-ID: <CAHk-=wgsD_8xT4v+HJkSxTLCkb7Nv1dHCGfSyNLzFaj18SJvGA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 6.4
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2023 at 4:17=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
>   [ ... ] I explicitly choose to use fine
> grained merges for that series to retain all the context/cover
> letter information for each part of the series that Darrick had
> included in the tags for his pull requests. While it means there are
> lots of merge commits, it also means the context and some of the
> reasoning behind the series of changes is kept in the git tree with
> the rest of the code history.

Oh, absolutely no complaints about *these* kinds of merges.

These are lovely, and clarify history rather than obfuscate it. And
the merge messages are extensive and explanatory too.

So yes, I often complain about pull requests that have merges in them,
but that's because of sloppy merges that make no sense and only make
things harder to follow and understand.

Merges per se are not bad, and these all act as nice "punctuation" for
the development. It's the ones with no explanation and no logic to
them that I so detest and try to actively discourage.

              Linus
