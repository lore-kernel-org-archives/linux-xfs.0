Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A5FC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 08:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiGZIl5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 04:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiGZIl4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 04:41:56 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA72267A;
        Tue, 26 Jul 2022 01:41:55 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id b81so6224101vkf.1;
        Tue, 26 Jul 2022 01:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ITZc11EOVLcJSMe4ACoe3DUPT7DoR6woGcldYGG269Y=;
        b=AN4oDDJPhiYfo3AWV+jPosEMdgYcdOXb6NFxQoAYvrRaq41VLyTbX5orDQwOH8mwwA
         eMyY46+tWC/XJp1BzVftuMzbqWo99oWnwgKBkxXhePcETzt59H3bY85pR/i7FZWln/+S
         vJOx0UbJNJG+w9iVe5skkKr6V43pPdVj8tXSpHUHDhpE1dzG4TWNl1cXlMQPBvkXt7aA
         LJjH/iCBGbuSw18LBYJoNX4kR0lycGtSzKLLRq8r8tzev7i2cqADejlPohkV/+wJgaSg
         XF8PGiPXREusOIwod8IyNA9Yr/sgVGXtTKFwZjomMs3cmWjFfQeDDHaG4aaMAshhwbbP
         69Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ITZc11EOVLcJSMe4ACoe3DUPT7DoR6woGcldYGG269Y=;
        b=4OS6pPkMFUkyugSd6TNeL/VuKis7/KQxZQ2ItKwBJ/CL6+pVgmbwqFcqzWo4TaDb9K
         ZDLeufum4ih2HEnCC1i1Gi5VnxK4gi9SMey68+ieiVTU+qvCAJlz4ndNjiedV1LsfxMf
         Q4XaW34HcJ55GQ7Od6/kjIjXVBzkHhZAxAKIiMLZrmUstMRJo/TLk9d7LsPTPAk+m/ux
         9mNiKoWNB3nkMyD2MmlPifY2tvJIF977EjP1y8hVC6anS5ollVbmu5xCGWuCXHjYWFcM
         s3oBSqXXQOJNplukBJzmF1+oqRQHeG0mZiavjaQIeW2U/QRu0+aNethHykHjKVz9Mezz
         e03Q==
X-Gm-Message-State: AJIora8ikGCQuHXPM2d7aNyA7AE+j5GDtYYfKE5oi5KU++HpV74uLJIZ
        mhDAfhQD8FBBdjoBcd+b82OYEXT5idBhvu+sMQ0=
X-Google-Smtp-Source: AGRyM1tFniDrdK+W6bTIni2b7xIldY7A3nLkYPyr65G0ifzaZtH67VnnGRc3Aghr11SUs/DTleNo6xqruKjNyE+HgpU=
X-Received: by 2002:a1f:19cf:0:b0:375:6144:dc41 with SMTP id
 198-20020a1f19cf000000b003756144dc41mr4563414vkz.3.1658824914360; Tue, 26 Jul
 2022 01:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <YrOpmMzn9ArsR9Dy@magnolia>
 <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com>
 <YrSPNFZ+Hium1rhE@magnolia> <CAOQ4uxj2vk4ZPXu20PM0hHCawTVdaY+z5=0WuN__UxwNRDK5+g@mail.gmail.com>
 <Yt9NAQrBxlVUIKou@magnolia>
In-Reply-To: <Yt9NAQrBxlVUIKou@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 Jul 2022 10:41:42 +0200
Message-ID: <CAOQ4uxh+kHfH-x0M+LrVGNHfxW5OtaTbnPsuhmihv7_6jX8YSw@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 00/11] xfs stable candidate patches for
 5.10.y (v5.15+)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > Hi Darrick,
> >
> > FYI, I started testing the log fixes backports from v5.14 along with
> > the deferred
> > patches 6-8 [1] with extra focus on recoveryloop tests.
> >
> > I know that Leah is also testing another batch of 5.15-only patches, so she
> > may yet post another 5.15-only series before my 5.10-only series.
> >
> > In the meanwhile, if you have some spare time due to rc8, please try to
> > look at the already posted patches 6-8 [2] that were deferred from the original
> > stable submission per your request.
>
> This is pretty difficult request -- while I /think/ the LSN->CSN
> conversion for the upper layers in patch 7 is correct, I'm not as
> familiar with where 5.10 is right now as I was when that series was
> being proposed for upstream.
>
> It /looks/ ok, but were I maintaining the 5.10 tree I'd be a lot more
> comfortable if I had in hand all the results from running the long-soak
> log recovery tests for a week.

Sure, I can do that.

>
> (Which itself might be fairly difficult for 5.10...)

That depends on the exact definition of running the long-soak
and log recovery tests for a week.

I did run the 'recoveryloop' group 100 times on baseline vs. backports
and saw no regressions observed.
Also ran 'auto' 10 times and 'soak' 10 times (and counting) with no
regressions so far.

However, some recoveryloop tests are failing in baseline, so running them
"for a week" is meaningless for those tests:

generic/019, generic/475, generic/648: failing often in all config
generic/388: failing often with reflink_1024
generic/388: failing at ~1/50 rate for any config
generic/482: failing often on V4 configs
generic/482: failing at ~1/100 rate for V5 configs
xfs/057: failing at ~1/200 rate for any config

Note that some of those recoverloop tests may be failing due to older
xfs_repair [*].

The following recoveryloop/soak tests have NOT failed so far:
generic,455, generic/457, generic/646
generic/521, generic/522, generic/642

Should I just keep running those for a week?

Another option is to declare those fixes too risky for LTS 5.10.
That is always an option we need to consider.

Anyway, I will post the full v5.14 series for review and continue
running the long soak tests and the passing tests.

Thanks,
Amir.

[*] I should note that the 5.10.y tests are run with xfsprogs 5.10
When I started testing 5.10.y, I used debian/testing with newer xfsprogs
but that led to many issues compared to debain/bullseye with xfsprogs 5.10.
I figured that it is not very likely for a distro to use kernel 5.10
and much newer
xfsprogs (?) so I preferred to test more aligned versions for kernel/xfsprogs
to match the real life use cases.
