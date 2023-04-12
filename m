Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DA0C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 14:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjDLOMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 10:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjDLOMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 10:12:40 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E058B2D55
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 07:12:29 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id f32so8130592uad.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 07:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681308749; x=1683900749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxC75IJvDByIiSYoRQDajyLoY8YwRlEmsiMAsFI4Oig=;
        b=f8p9BQOsZK0/iXvodz1ButjN5L7q9w1cVMETOJjqE5wjB1YGjut/cuEYwtoLAxcMbq
         eAdXtKDHrrTmqQeyf9Ye1YtvP+MiDftxGMxwH6aSu0uZG/JDR4gHZlH6Evv81LKv/So1
         1eEBVoth6A4qDzWM8a+P9DpY5T7jS29EQfWfz0QVFmMFUWFYahl1cPEk1nuXaKyrZ8RN
         PvZ58EH1Akc9jsbzLL5atAPJUHHw/wO4xzI59/puG0KMbV3+CCBi1vzQXywF0MNYZBNl
         Tn4Btyr1H1Or75pLDAsnfriNQ1zOANFpjqefOXGF3KFTN+w2c+TVsxWq8uV2y9WF5/r2
         blBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681308749; x=1683900749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SxC75IJvDByIiSYoRQDajyLoY8YwRlEmsiMAsFI4Oig=;
        b=ZTVoVjeLKDQ3EIt8PbpCy5jxZ28/X8h9LIz4iCj1g6nAuRnnwqIq3Vp63EOxuAIUXA
         GkbkKY9hFuy6jwE4FQRahZM8cFyVe+24EHipXSniSkizMY+UhLHq4r3LmY1Of8u92PVW
         RbDOX+h6CxPrjB1itNSI3xN3EnOjTBTx31IdktxA2JIdXNRAgnMZrKsbhwwzNOa+aL/c
         tFcmYysiAZnxuQpKQPVtwLxdQhZjA4WCTXU2kkW9aEXRVIiD7cBjE/W6Q0tdUxBugPcQ
         5GPAl22cRYRdbSh8uijJIvNM1f9vtyaXQ5LyG8S3XLJ78rIGSmqzwGlEHLoCWnrQqNfh
         HjOg==
X-Gm-Message-State: AAQBX9e1vln1pU50E71GbajC/JQxGf1yRxzwlj2e1k5O99R82ThOqgg5
        YEnNEGzBtblYOsEsq9WELMy4n0tdQg9szUTImig=
X-Google-Smtp-Source: AKy350YRW1IfGssEdXvT36Je9KphLceH0K1aDy/7r4peLOospqQJQxCHNnC6kbaq1iPZIyjHvFTsTXoP1ULBo6pbKjM=
X-Received: by 2002:ab0:7de:0:b0:771:f5ee:f4e with SMTP id d30-20020ab007de000000b00771f5ee0f4emr872216uaf.1.1681308747905;
 Wed, 12 Apr 2023 07:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
In-Reply-To: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Apr 2023 17:12:17 +0300
Message-ID: <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com>
Subject: Re: Backport of "xfs: open code ioend needs workqueue helper" to 5.10?
To:     Christian Theune <ct@flyingcircus.io>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 5:06=E2=80=AFPM Christian Theune <ct@flyingcircus.i=
o> wrote:
>
> Hi,
>
> afaict this was fixed in 5.13 but hasn=E2=80=99t been backported. I=E2=80=
=99ve seen one of our VMs running 5.10.169 crash with this.
>
> Anybody willing to backport this? It=E2=80=99s only triggered a single ti=
me so far and we are rolling out 5.15 anyways, but maybe this was an oversi=
ght =E2=80=A6 ?

What do you mean by "crash with this"?

There is no logic change in the commit mentioned below.

Thanks,
Amir.

>
> commit 7adb8f14e134d5f885d47c4ccd620836235f0b7f
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Fri Apr 9 10:27:55 2021 -0700
>
>     xfs: open code ioend needs workqueue helper
>
>     Open code xfs_ioend_needs_workqueue() into the only remaining
>     caller.
>
>     Signed-off-by: Brian Foster <bfoster@redhat.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>     Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>
>
> Kind regards,
> Christian
>
> --
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick
>
