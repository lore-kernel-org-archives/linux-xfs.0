Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F0FC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB12B2071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYD6BkmH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVQJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:09:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27547 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbfKVQJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574438959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jy620vCimj+8qUOQT+zyt69C4IgT/k6hKZHQqbWRbYk=;
        b=cYD6BkmHDmaPsDPtVQr3cW8Nww7HpVQM+VKVG/fL++edtVFIpxmqMCMV/xoBAfU+OC+Lzg
        4cYWf8XrIVbNXqxeUJj4AYYmS1+FmdYHrAdfrH2fZRnMO4Ohhd0ObIfGApX4yqGhtsEc6W
        0WvsvmMKbf/UWtdqLyjt/mKKu8j8gMI=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-qQz3ArojPQaCNLPHXONKzQ-1; Fri, 22 Nov 2019 11:09:15 -0500
Received: by mail-vk1-f198.google.com with SMTP id f73so3086376vka.4
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 08:09:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jy620vCimj+8qUOQT+zyt69C4IgT/k6hKZHQqbWRbYk=;
        b=fN0M2u2IY846+8Cp0faLAj6KTS6HAOspR2iDBZCKgHIVGAzVCxgqW0owh1I6ZL7V2l
         bIjHgpjXEY81VVmqpCjJ6S/w1a9xgxyuzWXVajVprGtKtU7M28soOLZpjgURriHwFvdw
         giydbmqxirDiyGCbZkzb43dvr0/Vai0LPPyEnu/C5r/9RAMrpeA90CJZVZ4QtlPayP8u
         dBvcSdgHs+2evTXSBhIjqInBXxt0lGY/O8rOk081xC9t1SMt8ILsRNYxRiVPYnGf3CCy
         Mt3RB7nXNOddZ6HTITSi2nzZQcBhE2HrjSSOn385tKRmaABoBNdBBf8QV6VXrfDuW6/c
         0l7Q==
X-Gm-Message-State: APjAAAVp7YzaKAV1tbhGEAG9JtfI82VugE8zFEQacOV7hnCuuXWm50IM
        SfP1GYqndU+njo2nuWgn8hqvIaZWmG1ytxV/J5bIC9/aqyXaZ7WPL0Y+XbyU5g15JpaUu1zy2um
        WWXJSGA777sVMIevFzShqilMT9nn2nubLBR7M
X-Received: by 2002:ab0:2ead:: with SMTP id y13mr9886755uay.84.1574438954919;
        Fri, 22 Nov 2019 08:09:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7n2fHeegELZm5I9lrVDOlK/sQ3/zAZM1bvCneWABCrIT5otoBUQeDDHR0CIUBkk45aWy+8AKDsA5X0vVFzZk=
X-Received: by 2002:ab0:2ead:: with SMTP id y13mr9886728uay.84.1574438954534;
 Fri, 22 Nov 2019 08:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20191121214445.282160-1-preichl@redhat.com> <20191121214445.282160-2-preichl@redhat.com>
 <20191121231838.GH4614@dread.disaster.area>
In-Reply-To: <20191121231838.GH4614@dread.disaster.area>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 22 Nov 2019 17:09:03 +0100
Message-ID: <CAJc7PzVR0fjmWRZEazx42UpSDMiPjoSre4S0SLPxJjD3zJ2spQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: qQz3ArojPQaCNLPHXONKzQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 12:18 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
>
> This is mixing an explanation about why the change is being made
> and what was considered when making decisions about the change.

Thanks, I'll try to improve that.
>
> e.g. my first questions on looking at the patch were:
>
>         - why do we need to break up the discards into 2GB chunks?
>         - why 2GB?
>         - why not use libblkid to query the maximum discard size
>           and use that as the step size instead?

This is new for me, please let me learn more about that.


>         - is there any performance impact from breaking up large
>           discards that might be optimised by the kernel into many
>           overlapping async operations into small, synchronous
>           discards?

Honestly, I don't have an answer for that ATM - it's quite possible.
It certainly needs more investigating. On the other hand - current
lack of feedback causes user discomfort. So I'd like to know your
opinion - should the change proposed by this patch be default
behaviour (as it may be more user friendly) and should we add an
option that would 'revert' to current behaviour (that would be for
informed user).

>
> i.e. the reviewer can read what the patch does, but that deosn't
> explain why the patch does this. Hence it's a good idea to explain
> the problem being solved or the feature requirements that have lead
> to the changes in the patch....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

