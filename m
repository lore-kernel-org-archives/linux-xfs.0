Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DE3C010A2
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 11:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB34A217F4
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 11:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIy0hwtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfKEL7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:59:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730886AbfKEL7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 06:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572955144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sL0EEP6zndFleaAgcDlToetdj74SGlXaGytgC7nFRE8=;
        b=dIy0hwtMIF/ddEzz6zbYdz83uaWcq8eGgxy9GOpfpNe2A+WNUfz127dEUjYCB5pHHdUh8N
        CsLECPrLN9rrAruQYstDUmJIeMPdMmapfsY2fvQi9TegKYnncsOZH+te8ZxMqyTOGfaye6
        dbeZBQXnW430D0iPbSEq6LcpgM16mQM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-Eiop_Ah4NAuA17QCkyB9Xg-1; Tue, 05 Nov 2019 06:59:02 -0500
Received: by mail-wr1-f69.google.com with SMTP id e3so9747158wrs.17
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 03:59:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=1oQURsesYZMemoPz9mlqvqCXYV+AtXZZDuw375Hicjo=;
        b=CrQAOmUT/Q9dCb0YCmPvNOvOihXTGP6dn/4EbOeqyLpLFvMnRMX8mpIVRPXeBtdPp8
         zpgeoNATV15f8sa1xug7dr4kTaGL18vupb5jvUfK+WHXhlXxomDluAB+MkGiEV48WB1T
         D2YV6U7GWnZvF/VvpygsgZZHMsLU2WbdkAuCQNvYRVTeRVVDafAM+P42NwmW9nJGS7X/
         Nk0ApoeXeHmgnSbXBD/4HR7MZjAMZ159fH3zjd0m9jQWboQ6/bT+G/e1ieQW5ICdmZwI
         Y1k3Ucwf2G2T1jb1bHjBM0y8F+Mhv/GLIg8PiPcON/KLXKiB0eG6JmG0dc176wVNUOvu
         ocqw==
X-Gm-Message-State: APjAAAX63Xk/lP4XHjWZDDsjr7/s6U/1ve3L+FfS0YFXCrdNP7aKM6Mz
        ndHNIwfxjGE1IKIc5SDZ8gJqFiiavb6vNRzdMFfSnXTJP6/2ff25qDt5KZOmeHZ0zouEE2cMGvZ
        pkwEoaIa4bECg4OU1Pi+u
X-Received: by 2002:adf:fc86:: with SMTP id g6mr24359319wrr.74.1572955140914;
        Tue, 05 Nov 2019 03:59:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqwbsXWLypx+PGp4M3Mg/h9whTxcnfvYIA7FL5DfWE0LMpRVF98otKObN/PsigMWmaMIDnEKHg==
X-Received: by 2002:adf:fc86:: with SMTP id g6mr24359309wrr.74.1572955140764;
        Tue, 05 Nov 2019 03:59:00 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id s13sm19193840wmc.28.2019.11.05.03.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 03:58:59 -0800 (PST)
Date:   Tue, 5 Nov 2019 12:58:57 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Sitsofe Wheeler <sitsofe@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Tasks blocking forever with XFS stack traces
Message-ID: <20191105115857.5acumcghqzanwh2i@orion>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion>
 <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion>
MIME-Version: 1.0
In-Reply-To: <20191105103652.n5zwf6ty3wvhti5f@orion>
X-MC-Unique: Eiop_Ah4NAuA17QCkyB9Xg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just to make clear my previous point:


> > > What's your filesystem configuration? (xfs_info <mount point>)
> >=20
> > meta-data=3D/dev/md126             isize=3D512    agcount=3D32, agsize=
=3D43954432 blks
> >          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
> >          =3D                       crc=3D1        finobt=3D1 spinodes=
=3D0 rmapbt=3D0
> >          =3D                       reflink=3D0
> > data     =3D                       bsize=3D4096   blocks=3D1406538240, =
imaxpct=3D5
> >          =3D                       sunit=3D128    swidth=3D768 blks
>=20
> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D=
1
> > log      =3Dinternal               bsize=3D4096   blocks=3D521728, vers=
ion=3D2
> >          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-=
count=3D1
> =09=09=09=09=09=09^^^^^^  This should have been
> =09=09=09=09=09=09=09configured to 8 blocks, not 1
>=20

8 blocks here considering you've used default configuration, i.e. XFS defau=
lts
log stripe unit to 32KiB when the device strip is larger than 256KiB.

--=20
Carlos

