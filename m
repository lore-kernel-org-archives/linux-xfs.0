Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63070C54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 19:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE99205C9
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 19:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588016479;
	bh=PblMWBtQoFDJTZU5sYrsa18EQC2ghwnYCorJeG/zksQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=bTQF6UN0sb+DLkpaNSRrqJNshKjs0HIxrJOtQeZda9sZyZs3lmV0tdZ1835E2GlQg
	 xW7VkU/ajsCK4e7V5QO4kHpZ0bIyjhFO0V5JGVgSbcntFUvtMHZXmb6vFKmsz2I/N4
	 rZioSY6x76EiyQuH+ThS/yz0ikiRUccj3tLchmmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgD0TlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 15:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgD0TlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 15:41:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B68C0610D5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 12:41:18 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j3so18871896ljg.8
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 12:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/diWUIXgSQwef0RKUapiKWcDC4ZexJVcsy5yNjXeH6I=;
        b=W+iws1Uhvb61PrxQjvV/PFk7COkKMfJT3gvdmPLDy0AkzMWVNNtRkNa0mIQQ8RS46h
         wtemENd3mU9RrYEkZPK9CWqOUc2sgBxg2g/Yks8pTCsCdB0FAAwwrV8M7mcKVgAN1jLN
         uWE2KNsGAcoRArxjWyEFkcLzSTLfR54TY0Ay8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/diWUIXgSQwef0RKUapiKWcDC4ZexJVcsy5yNjXeH6I=;
        b=F6Fj4/AMxN8Vv556w6esBnQAkA7fqsUKKhCPVjO/yvnZxGO1LBc60QCZ++L+kCcafW
         4hoQA6D0FDLI+ZwOx6ND7ondbvMyA+u7gUS7lKnAZe14+3pVpu8+H3KubeccsMWJb3Q8
         MswpE7ZmJmN5PgnJd7XWdJ9RLW8ZQ6fv3AEY2gqs8PhDrAMFg21D2Qwvqf6kiomb30tO
         NumNlMb22yhVdC2oQiz5NRJ5+W/qNbByySB5DhnnH2L7OB1TYC83Go2prjm0RL2focaI
         EwcgAPBxmBDmK7gB/ywRO80lG+maVHizK40qoAdcg3iwuhDtBIMSgnuziG6vH/u3Sqz+
         5ftQ==
X-Gm-Message-State: AGi0PuadNFKeaR5d2WLvtKCCTIyxtaEujQkiiMXlqkNptnhuMzkNIS1s
        kNLL1cFQh2rIlK9CdIKVWfRfMyQ/Yss=
X-Google-Smtp-Source: APiQypLb+eJbznIUXz/OKLO9mJkMepXiYsCFY6QrZ+r2fDP1EEXX2S7Ff5y5BzWGAus689gBzXBf4Q==
X-Received: by 2002:a05:651c:402:: with SMTP id 2mr11694177lja.192.1588016476266;
        Mon, 27 Apr 2020 12:41:16 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id l2sm10650357ljg.89.2020.04.27.12.41.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:41:15 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id j14so14883200lfg.9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 12:41:14 -0700 (PDT)
X-Received: by 2002:a05:6512:14a:: with SMTP id m10mr16317524lfo.152.1588016474219;
 Mon, 27 Apr 2020 12:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
 <20200427172959.GB3936841@kroah.com> <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
 <20200427174611.GA4035548@kroah.com> <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
 <20200427183629.GA20158@kroah.com> <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
In-Reply-To: <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 27 Apr 2020 12:40:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
Message-ID: <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 11:59 AM Joe Perches <joe@perches.com> wrote:
>
> There's no real reason not to prefer the latest versions
> over the deprecated ones.

Joe, your pedantic approach is really hard to work with. Please work on it.

The fact is, there *is * a reason to avoid the pedantic "change to new
version" - pointless churn.

We have a lot of the original style spdx markers, because those are
what we started with. And changing them is pointless.

I know you love your scripts to change things around, but to everybody
else it tends to be just extra work and noise.

              Linus
