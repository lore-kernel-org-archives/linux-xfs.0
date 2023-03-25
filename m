Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28857C6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 20:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCYUGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCYUGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 16:06:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C29EEF
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:06:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn12so20888681edb.4
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679774765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPB7hzR1KHvTdfIifE2g7FovsTPRz1KIWa91Eo2+Hxw=;
        b=hNMebUU7huTAcRxFGTajfQnywt7MuQ44i0xXCtVO5WQ3B+31dzCRbcfyESb0YSL57e
         7brCdGvBKh9R8JVM/PtB8FYGCQ6VHgyw6nX9ub37wEf6GFA94ph5C3C+EYuKd/Ot7dcP
         Sj2qyD1dFZSMtC+ibINbD7VjNHtd9BNTHASmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679774765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPB7hzR1KHvTdfIifE2g7FovsTPRz1KIWa91Eo2+Hxw=;
        b=kMUspsgYHv9isHQv8LnlSwQDVLCdMlGwrgaOOKsGiKvOhwhwvxqd8yLWLDkBIy71U+
         fvuOqeTUatsBQNaBWcEaxEFilB3KTasmTPsdXvuLrmv2Q+ctKw3WK/Dy+mXg5G2nIGv1
         WVBqL0KPDm4xQxYgCrCJvT+/UtD+ibkFud2eXm8uUclGp6yQAMrf7Xy4jwEh0cvgmRI3
         51nTAmMJY61eVkEYr7akogz1FctZV302KCTDAvvm8oAhHpsgHTsZ2w3EifYcTYa4b5Vu
         2upEB77m0X7Wt6Rtu2K8FSUbPLsuBHFnGK2O+SVrxVHTfeKyh85QuDWQg2/vYzcf6N2f
         wQIA==
X-Gm-Message-State: AAQBX9cvzV1Wbc72xU8DprwxZMkvIfBXm+5MikPILbKlXUlbLqe0vnrE
        n48HB3OcmVA8hPeSVbwbWl0/p7rYgoHi5yyEL6xkA2AA
X-Google-Smtp-Source: AKy350bJpYRo9BVcVlIC+9km2fEpTaGFKCredNAD7BGkrddtPs+RgXfCeMLuM0vL3vcS+G3UeG2IrQ==
X-Received: by 2002:a17:906:ecf4:b0:930:2e1c:97ba with SMTP id qt20-20020a170906ecf400b009302e1c97bamr7442373ejb.5.1679774765062;
        Sat, 25 Mar 2023 13:06:05 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id t9-20020a50c249000000b005021d1ae6adsm3205330edf.28.2023.03.25.13.06.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 13:06:04 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id ew6so20805659edb.7
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:06:04 -0700 (PDT)
X-Received: by 2002:a17:906:7846:b0:933:1967:a984 with SMTP id
 p6-20020a170906784600b009331967a984mr3248641ejm.15.1679774763744; Sat, 25 Mar
 2023 13:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
In-Reply-To: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Mar 2023 13:05:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjqeE9JBh7Jkkjb-QE4oeRhO4Xcf92d0=DDTzVeFp=6rA@mail.gmail.com>
Message-ID: <CAHk-=wjqeE9JBh7Jkkjb-QE4oeRhO4Xcf92d0=DDTzVeFp=6rA@mail.gmail.com>
Subject: Re: [GIT PULL 2/3] xfs: percpu counter bug fixes for 6.3-rc3
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2023 at 11:33=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> I'm hoping this is a fairly painless fix to the problem, since the dying
> cpu mask should generally be empty.  It's been in for-next for a week
> without any complaints from the bots.  However, if this is too much for
> a bug fix, we could defer to 6.4.

I'm not overly happy about the timing of the fix and it would have
been lovely to get this earlier in the release, but it does seem quite
sane and fairly straightforward.

So in it went,

                Linus
