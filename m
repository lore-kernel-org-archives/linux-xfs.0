Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0C3C54EEB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2116B2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588020406;
	bh=S0JGqMXyfhwp4pwnB+rzqtWpJTu9aRY8xFng4Qs4J64=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=eIlQU/ELERI2H0TGxx8ZMyQCJZ4BCOc+79yUvjRAFpXRfisZnzTho0ZH5/nTLSMNO
	 qIkBZFSBczu/caSH0vJngS+WJasLgCvrecqB/JyExC1IfHy4hNZ8/Br8x2aCTTQ/1D
	 tbVphYbSoh1Zwo9PiKAPnm0+SK43+r10CyD3oTnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgD0Uqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0Uqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 16:46:45 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292A7C03C1A7
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 13:46:45 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j14so15034110lfg.9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 13:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWR2+QPOvDM4Hcpn5wbulNRTutKr2RiZhAYOOOoHLGE=;
        b=XXUouBL3HsVdD5w4SVkh5b5D8g9+OFHyEx+DyQoaqHU6zlLiC7Dv4gWIn8To8ExMgw
         NntG+tgahRdl4PgQkAptOglp72S4qq9gaTpBKYXOGyoVBKVhhZlHK+aoAtOs0FgfdNnG
         Q4eXzMDYFO1E9IXcsn+dcaRD4uEyvCywvcRfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWR2+QPOvDM4Hcpn5wbulNRTutKr2RiZhAYOOOoHLGE=;
        b=PFxoJrME3eIdlWBe7uYAWrMqZ/PMLJV8SNWywBzBSqPvcstdnwwyTn+FvCA8PjQorr
         aO6s4WyrWO7gVr//ZC3P226mLWjClw77s9fTUQB+cF+SAynsnzppHN/IrcDxTyK3hF6o
         AHKJ+WSCPjAoxc/p8S1VC6+YReTCQiQian9QfCtF6wQqZINUTGf7XDhXZGLSx4uIVAHn
         znj+rvvFKBDO1kjHJGLFiw9an2nYGHDGeL+FbJ75yIFCaFbCSljQm9up9diOCRZgBGm5
         x+p/H/s45ZMO2TcTELX4khEZomhu1m2hXHSUVpIJknhrb/wViLR2RBJdNfNJR/mE1oSy
         utjQ==
X-Gm-Message-State: AGi0PubQHegx38e1TFm1wdpXsmBrfiC6z7nStbNIhkBTQN0M5rjiMGkW
        CQbY4V+WQ3aE67f2JDB19FIi+66wMjg=
X-Google-Smtp-Source: APiQypJtMu/7PH/QY6r03F7QWfQct0FQFvKDs8aRTFUsaSd/E8pYhTYmZRkr6UjySVxrGEwkgm95jQ==
X-Received: by 2002:a19:e041:: with SMTP id g1mr16404730lfj.70.1588020402701;
        Mon, 27 Apr 2020 13:46:42 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id i18sm12162143lfo.57.2020.04.27.13.46.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:46:41 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id h6so15083387lfc.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 13:46:41 -0700 (PDT)
X-Received: by 2002:a19:240a:: with SMTP id k10mr16839809lfk.30.1588020401250;
 Mon, 27 Apr 2020 13:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
 <20200427172959.GB3936841@kroah.com> <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
 <20200427174611.GA4035548@kroah.com> <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
 <20200427183629.GA20158@kroah.com> <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
 <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com> <fdcc8aa5a506ba9c6a3e6e68a7147161424985bf.camel@perches.com>
In-Reply-To: <fdcc8aa5a506ba9c6a3e6e68a7147161424985bf.camel@perches.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 27 Apr 2020 13:46:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
Message-ID: <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
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

On Mon, Apr 27, 2020 at 1:39 PM Joe Perches <joe@perches.com> wrote:
>
> > The fact is, there *is * a reason to avoid the pedantic "change to new
> > version" - pointless churn.
>
> Have you *looked* at this proposed change?
>
> It just changes // SPDX comments to /* */ in .h files.

That's not what I was reacting to - it was you arguing with Greg about
how we use the legacy format.

I really don't care at all about the comment character choices
(either), but wanted to point out that as far as the kernel is
concerned, the "deprecated" spdx keys simply arent' deprecated, they
are just as valid.

> Piecemeal changes aren't great.

Piecemeal changes are fine, when the change doesn't have to be done AT ALL.

There is simply no point in EVER changing "GPL-2.0" into
"GPL-2.0-only" etc, unless the thing is then touched for some other
reason (which it may never be).

Scripted changes are not as useful as you think. They often cause
unnecessary noise in other respects.

I'm constantly seeing stupid pointless work due to irrelevant patches
that then show up in "get_maintainer" output because they show up as
changes to drivbers that nobody cares about.

Or "git blame -C" things that I have to ignore and go past that
history because the scripted change showed an (uninteresting) change.

The fact is, pointless churn is BAD. It's a real expense. The whole
"get it over with once" argument is simply completely wrong.

There are real advantages to "don't touch stuff that doesn't actively
need touching".

              Linus
