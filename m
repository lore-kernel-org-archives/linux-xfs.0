Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DA3C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 12:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28EE61627
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 12:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFYMIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 08:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhFYMIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jun 2021 08:08:12 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE3C061574
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jun 2021 05:05:50 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id y25so662489vsj.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jun 2021 05:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3VNM19g7DeF74s6+NRcpPPqeUINbF+IsXDYiknaGyVQ=;
        b=YmiAGasm3tULHnIJqW2Jh09Qo+EbfV1Me7y0WbwAXXDrpY7FGg38JJ2VIegtJQ+GbT
         3phIC5PQysufLirUU3s/HxedTOj+1AgRfvcsoyvzP7r2ZRWe67FSGVZHEw7N0pjWnoHV
         Tt07mQn8DgV/pE5l5lUhVoYKm875I32n1l5/M+PM9n74mrLExQ3GTPmAuM0ESAVAIELg
         k2zGqQSqM3+2DlHwVMU8f89XGRnOW0Q+8u1JzTjkLeos3sI3Az7JATH5Pzy9F+b2XoiS
         P2c2WbJ9WtoSqW3rCE0OwogmxDcJyrg17gPleg9sqilWeebwCFZq/D2TbvipBdhbFg8y
         y02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=3VNM19g7DeF74s6+NRcpPPqeUINbF+IsXDYiknaGyVQ=;
        b=OD3pgCdgCpy83zHPHst78deWvkDXmZtbB6HktY9v/ELW0bMasGpwifFqteyGdts+qH
         zG4/LcEFn0lef+yD3pXdDHqZqVOCuSnAoY33Rd6QKR57bPtD2lkVQo8hAEhHHwsgHpBm
         /rVJFP18Yc9Z330A+gAsgwLtXMEbMgUnoetY0rqM/EZyqgYxWByihziqZxAtDelFHEOz
         ou3cTIgdIVvY1oPrPkreCT9cdN+I26WvsVe37YfmzX2vILMUCewDeENY5NiI6nDp1Ang
         y61JStgxfFQt6WmWRyuqNeSbbbAnipto+IgwLFZg0/1L6BoJNllnte30g0BoGidRlNaY
         MEcw==
X-Gm-Message-State: AOAM5321EEnTzvpvkxBP33okLTUea3GGr/L3rvQop/5witX+Udf4t600
        wuHvhs7vS7Jo7Pij4rHZusph88y8+WeA1zc/y1Wi4j9ZIwWCpw==
X-Google-Smtp-Source: ABdhPJyHJ0KMcNLjsrs7XrdHaq0ZTryY1hpYrQGOKebzC7oAcmxH41jFaYq8f9cwEl4q4gOtCxiHSAFiNMlY9MxmoVk=
X-Received: by 2002:a67:79d1:: with SMTP id u200mr8025479vsc.19.1624622741313;
 Fri, 25 Jun 2021 05:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANFxOjCAYYs7ck0wrnM1AD0pBKE74=4PcDj_k+gHGjDmmvZBzg@mail.gmail.com>
In-Reply-To: <CANFxOjCAYYs7ck0wrnM1AD0pBKE74=4PcDj_k+gHGjDmmvZBzg@mail.gmail.com>
From:   Ml Ml <mliebherr99@googlemail.com>
Date:   Fri, 25 Jun 2021 14:05:29 +0200
Message-ID: <CANFxOjATBAnEJ=pZEjsdsbaY=ziGOo8b3fXL_otYRmDPQOi=_w@mail.gmail.com>
Subject: Re: XFS Mount need ages
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After a loong time it mounted now. Here is some more info:

xfs_info /mnt/backup-cluster5
meta-data=3D/dev/rbd6              isize=3D512    agcount=3D65536, agsize=
=3D32768 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D0
data     =3D                       bsize=3D4096   blocks=3D2147483648, imax=
pct=3D25
         =3D                       sunit=3D16     swidth=3D16 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D=
2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

On Fri, Jun 25, 2021 at 12:49 PM Ml Ml <mliebherr99@googlemail.com> wrote:
>
> Hello List,
>
> i have a rbd block device with xfs on it. After resizing it (from 6TB
> to 8TB i think) the mount need hours to complete:
>
> I started the mount 15mins ago.:
>   mount -nv /dev/rbd6 /mnt/backup-cluster5
>
> ps:
> root      1143  0.2  0.0   8904  3088 pts/0    D+   12:17   0:03  |
>    \_ mount -nv /dev/rbd6 /mnt/backup-cluster5
>
>
> There is no timeout or ANY msg in dmesg until now.
>
> strace -p 1143  :  seems to do nothing.
> iotop --pid=3D1143: uses about 50KB/sec
>
> dd bs=3D1M count=3D2048 if=3D/dev/rbd6 of=3D/dev/null =3D> gives me 50MB/=
sec
>
>
> Any idea what=C2=B4s the problem here?
>
> Cheers,
> Michael
