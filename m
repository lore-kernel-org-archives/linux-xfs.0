Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75887C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 00:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiFBA2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 20:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiFBA2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 20:28:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E02194DC
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 17:28:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w27so4266227edl.7
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jun 2022 17:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=McFyTOgd+XHEmlkAqfwIX5SEOFFO1RwY03NA0CSFDzw=;
        b=HKw6+eSMIDccKUrsJReWXBKrh8bC35YUs4ZEaguSquzXiGljGkmcQ6prQaUt7L8r3Z
         JdWdxvUMKB/ZligyUGaIIRb5X2iVF7dHQYxrjUyAIuZJw0Rf+Bfo/QrCGZZjWh/lkDq4
         M94ohT8t9S3lWWtwPGtw3g7ACsCvYY0J+n9L0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=McFyTOgd+XHEmlkAqfwIX5SEOFFO1RwY03NA0CSFDzw=;
        b=ZN4IEFqTm4VCakpFAn1R7tbT/32sPd+9bGEVs6Z96xo3ewwtrWwX6f32Hv6wfAAtoN
         KbaLBEG6+b1Za6T/p6X8adX4kGkXrKLMd+AK51CvDwAzjrZ4qFUm3ehIS9U1VFK77/Eh
         ZBzWfTVK+9+KFtkf5EDBYZFxORJ6AzOdrZC173ZmAtPSTqmIunrT0H2EtgcZy5gxUZ6O
         vOenJIh+u0K862i+xUVVlclyzL4hSvl8V4Enm2oSHToT5mpUqReA8yc3VSGsmDv9BPy7
         PsAWM+ah31T7fHIZqPH4qgtK3REbvL6LDjd4KlS0d42v3IiIk4Cmy91SQn6N5B4UUiDZ
         EmuA==
X-Gm-Message-State: AOAM532r3SVf+HnkAwSAm9FTlI6uWHEdmobcOsQVVn74lO365pzZQgSD
        wj5IcWchOdUcI00/QV8ccxLefIIdrMwmza3v
X-Google-Smtp-Source: ABdhPJwOaUvOX8j2E8u97vAJNXBOSD+zzI6NOFxDMzfo8ERh1xkgzcI30hvNGzM3tqTN/gvpHaGMPw==
X-Received: by 2002:a05:6402:d0a:b0:425:d455:452 with SMTP id eb10-20020a0564020d0a00b00425d4550452mr2551663edb.259.1654129696031;
        Wed, 01 Jun 2022 17:28:16 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id my16-20020a1709065a5000b006fecf74395bsm1204043ejc.8.2022.06.01.17.28.15
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 17:28:15 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id o29-20020a05600c511d00b00397697f172dso3126356wms.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jun 2022 17:28:15 -0700 (PDT)
X-Received: by 2002:a7b:c4ca:0:b0:397:3bac:9b2a with SMTP id
 g10-20020a7bc4ca000000b003973bac9b2amr30505369wmk.154.1654129695207; Wed, 01
 Jun 2022 17:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220601221431.GG227878@dread.disaster.area>
In-Reply-To: <20220601221431.GG227878@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 17:27:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgoUOpeZwTrVzgtKBjR4SLA-rqV4_KDAHEdQ_4JhEQtYw@mail.gmail.com>
Message-ID: <CAHk-=wgoUOpeZwTrVzgtKBjR4SLA-rqV4_KDAHEdQ_4JhEQtYw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: changes for 5.19-rc1 [2nd set]
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 1, 2022 at 3:14 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Some of the code in the tree predates that pull request, so there is
> still a couple of empty merge commit messages.

Thanks, this all looks good.

Even the last time I brought up the commit messages for merges your
tree was by no means the worst offender when it comes to merge
messages, and it was more of a nudge to perhaps improve things.

But I appreciate the further improvement.

              Linus
