Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBC4C010A2
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 10:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E08206BA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 10:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8XDia1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbfKEKhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 05:37:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388422AbfKEKhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 05:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572950219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ps68cYsPSwTO+hOPUxdMn2CIkrfE91e+yCoEiko15HM=;
        b=X8XDia1NFqGBV0PBfk5cgG7otD5bvLdaAlSadV9BJQS6PIePUDJt3sjYR08gbRsaR8yfAy
        fECTVzSxWRGvn4sHHtmT4LaqGA8SdmUtRXk1Fe6CfqZmRwi1hopU+69ga6iY43R4jSn7q9
        r/8zSkfIbP0L4y5FQCoNoefS5ANp8LA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-2UnXKRhROCS1QX7u5Hdo8g-1; Tue, 05 Nov 2019 05:36:57 -0500
Received: by mail-wr1-f69.google.com with SMTP id y3so5214253wrm.12
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 02:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=yKaFJa8VX8i25Bc9KTbjSlJbZFBNQo306DxMx0MCu18=;
        b=oYRPFnd6pLJfxUuNaEG/SWcJGR69/FajwQ0rjiHk8KyVbkQgJX4T6VSdm4DQCQTDv1
         wN9fH8v3DOFCOdtyFpS516oYK6jVpuRIGyYJis1ohHw4ARwwCAchUDv02Pd9IVo0MP8A
         Z5f6Bomk8/43o0n/mPP0+H7P4vuLUKjbeKVbjqTlqIXhzgaD7kn/IhNkefWPFi/B3Y6e
         YXThAGgIw3ESDbcuY4RX4cdMl/wUJS9nSUKaq9zVOCS1xwcShw3p/vuimmp8aE5j4KO1
         AmHmr1tGwfB8sON1Y3TokxvZKMqLTNHkrCqdeGO94ERPhxka7XD2/4FnTYo8DPFqNFHI
         nfbA==
X-Gm-Message-State: APjAAAVC64VYo+zMdofpEQpV1sIyL7mlHA5bz2NLJlM9j6mZTrnK+Qiz
        GUWaTxr0aS4Qf4XlKG3uDDtoLy4Ee2IIs4kwwJnUj0d6V2CsXs4eMBE40z01NmP4u0G+Ln2k2fC
        u+3pi719LACd6zxJ7b5Ds
X-Received: by 2002:adf:f282:: with SMTP id k2mr428178wro.387.1572950215791;
        Tue, 05 Nov 2019 02:36:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKKTCerV3x5xuYhc7ZXfdKdnG3leqSL0p6cVb7Xtn3mcDDrD/RvybDW00IYvDumhun5F/4vQ==
X-Received: by 2002:adf:f282:: with SMTP id k2mr428162wro.387.1572950215577;
        Tue, 05 Nov 2019 02:36:55 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id v6sm12833885wrt.13.2019.11.05.02.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 02:36:54 -0800 (PST)
Date:   Tue, 5 Nov 2019 11:36:52 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Sitsofe Wheeler <sitsofe@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Tasks blocking forever with XFS stack traces
Message-ID: <20191105103652.n5zwf6ty3wvhti5f@orion>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion>
 <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
X-MC-Unique: 2UnXKRhROCS1QX7u5Hdo8g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi Sitsofe.

...
> <snip>
> > >
> > > Other directories on the same filesystem seem fine as do other XFS
> > > filesystems on the same system.
> >
> > The fact you mention other directories seems to work, and the first sta=
ck trace
> > you posted, it sounds like you've been keeping a singe AG too busy to a=
lmost
> > make it unusable. But, you didn't provide enough information we can rea=
lly make
> > any progress here, and to be honest I'm more inclined to point the fing=
er to
> > your MD device.
>=20
> Let's see if we can pinpoint something :-)
>=20
> > Can you describe your MD device? RAID array? What kind? How many disks?
>=20
> RAID6 8 disks.

>=20
> > What's your filesystem configuration? (xfs_info <mount point>)
>=20
> meta-data=3D/dev/md126             isize=3D512    agcount=3D32, agsize=3D=
43954432 blks
>          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1 spinodes=3D0=
 rmapbt=3D0
>          =3D                       reflink=3D0
> data     =3D                       bsize=3D4096   blocks=3D1406538240, im=
axpct=3D5
>          =3D                       sunit=3D128    swidth=3D768 blks

> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
> log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
>          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-co=
unt=3D1
=09=09=09=09=09=09^^^^^^  This should have been
=09=09=09=09=09=09=09configured to 8 blocks, not 1

> Yes there's more. See a slightly elided dmesg from a longer run on
> https://sucs.org/~sits/test/kern-20191024.log.gz .

At a first quick look, it looks like you are having lots of IO contention i=
n the
log, and this is slowing down the rest of the filesystem. What caught my
attention at first was the wrong configured log striping for the filesystem=
 and
I wonder if this isn't the responsible for the amount of IO contention you =
are
having in the log. This might well be generating lots of RMW cycles while
writing to the log generating the IO contention and slowing down the rest o=
f the
filesystem, I'll try to take a more careful look later on.

I can't say anything if there is any bug related with the issue first becau=
se I
honestly don't remember, second because you are using an old distro kernel =
which
I have no idea to know which bug fixes have been backported or not. Maybe
somebody else can remember of any bug that might be related, but the amount=
 of
threads you have waiting for log IO, and that misconfigured striping for th=
e log
smells smoke to me.

I let you know if I can identify anything else later.

Cheers.

--=20
Carlos

