Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF8CC7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 01:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjFHB7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFHB7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 21:59:06 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926CD26AB;
        Wed,  7 Jun 2023 18:59:05 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-43dc0aa328dso113471137.1;
        Wed, 07 Jun 2023 18:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686189544; x=1688781544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLD/AoRxIRH6DflQuY1pQRUk5GfyHQapQE2eJSJgDwc=;
        b=RLpOkZZB5Z2i5e/q/2M58hjF8/6cOeJ4Z+1leqfeXaWr8ZOBNF2fvCxb4M/xgxbbmK
         BgONIu66JErya1JDcuy4nGgRP3iN1zdYJQtFEcANuXDVQlNsuStDFGJucViQRYxJWupv
         GIEvpEiBgICCMOOzvxaT8zW9Hu3naVM1gULoC1Pvfc7pcP5lKnRCXcekoHcvzhkkhedz
         EH4PboHRJTIAwrwYQc7ZQqRDnYxnUzM2W7Q5Pq6UUQIE1qtcEOxI84Zhjsack65l5iMB
         eVKWJLy2EVmMGSyd8k5QMagCt3JsZTw0Raaw5FrT+CdtJB3wx+MPPnmSbva/psQA426H
         XPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686189544; x=1688781544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLD/AoRxIRH6DflQuY1pQRUk5GfyHQapQE2eJSJgDwc=;
        b=D1PVxjhwWGEH8wuROSF7S8cKwXYijFGKoiFh0AV264k3HVy7fdBA9QUUgix/a+Brh7
         t9NHbYBZ/TvwCcwPsFPD2JzML73p2mVKoxZqCz0A9OvCR098+TdRa6gW1IDUBeSQxmTx
         eEWwQcMeBhZO4p3Mgc7RXB4gopNC434y5OGWyGuzFcPBNhKqSQFuOni8rfKCWMZ2QAOr
         2bzNDJu1p3PM5DWaApWmw1+A5Q6KKFkF33avVI+OxgtTzgZPpjdaC71YqSNS6L1mzRUd
         E98MQj1NAUorqzKKdJ9IzvFXqE9z8aVMQLVXvGIiTe55NiNMLHSpSqdoCMQ4KbQcnoA9
         zZeQ==
X-Gm-Message-State: AC+VfDyQZ2jpDgQX2NlDgVWsnkOPXYfkJjY4VhVeakA/rFwuanisUEEh
        HT7MNDyTzUVZthdNDHIxg4VWDtl9iWFkm6oy7WSON9iu
X-Google-Smtp-Source: ACHHUZ6IysarFoLEMkoINq2FS2nreTCCGW2A/LlTZrix6kwXfjtEemgVvYXIrTyB44lYFPt/Yw2mvpvDcWSYwPSBL1k=
X-Received: by 2002:a05:6102:c04:b0:43b:4f2e:359 with SMTP id
 x4-20020a0561020c0400b0043b4f2e0359mr260503vss.3.1686189544692; Wed, 07 Jun
 2023 18:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230605075258.308475-1-amir73il@gmail.com> <2023060730-ultimate-triceps-7bea@gregkh>
 <2023060708-paver-foe-ed80@gregkh>
In-Reply-To: <2023060708-paver-foe-ed80@gregkh>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 8 Jun 2023 04:58:53 +0300
Message-ID: <CAOQ4uxg0h1t_xBrLNhPT-2tpxauAgUxe4L-3Oh5MLDXBLkUMEg@mail.gmail.com>
Subject: Re: [PATCH 6.1] xfs: verify buffer contents when we skip log replay
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Danila Chernetsov <listdansp@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 7, 2023 at 9:34=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 07, 2023 at 07:53:54PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 05, 2023 at 10:52:58AM +0300, Amir Goldstein wrote:
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > >
> > > commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.
> >
> > What about 6.3.y?  I can't take a patch for 6.1.y only without it being
> > in a newer kernel at the same time, right?
>
> Ah, it's simple enough, I added it to 6.3.y for now as well, thanks.
>

It's ok, I forgot to say that this one is good for 6.3 as well.

Thanks,
Amir.
