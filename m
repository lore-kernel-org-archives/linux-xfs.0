Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F626C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 10:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCQKpn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 06:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCQKpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 06:45:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74C3B4F65
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 03:44:51 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c4so2852216pfl.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 03:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679049890;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGgnJdg3OKjKp1bnwinkU8ShFmQF0AwnG/aVSpL27p0=;
        b=QZ2YaqHTtDnytTDQHDbQctpHRSngs8CBJD//s8Aovg2YdOm/397/KKktBFZTHrK/3I
         umzQGj6ilNJaqg8igKNKTTpyWVx0sn12R0VzkX0LAnaG4xSJp1KG/MauUazcplpTTvHZ
         L8IC08NfR15+8FLD7YpRH4whwrBDDkjSJ0SBMGJmn/6PiPmHcqVdunjpViP0uJy1hfMw
         JWBi4l0+jQbEPsP583ywIIUDJojCOCkAq1L4K+kwOUOEWzhGY+YpluqfCU3qTkStSF6S
         bytGrb2vY9JvFnf30t12GwS28Nt1AYinN6bdnuhzmemKKrFPwum/ESNM/Hf3+/OOqQKC
         vazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679049890;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGgnJdg3OKjKp1bnwinkU8ShFmQF0AwnG/aVSpL27p0=;
        b=V/+bELXHdjkdOkYSnHad1WVyO/mM5Y1qX6JpHez6OoVc1d8/P5LUMS4b99JqHTNfYr
         FgnZ9lWDiME8Qlg2VNje4OrMgSG5wM5EE2xTLiHpPFZC+OVbZR+qNVdGy5XN1YlOre3A
         6qESbfOHXOdQMclmRJ6fP3gAteppa1POrA3PFIpqqmENnU+x97igGP2YTqclaUi120qG
         lK9UHieFDHChv4pAXkY2+jQkivdfuUeIpU2rMolVVHjK8EaUgAEnu+sKlf6EiUH99zZD
         eocXxXkN0aQRTFDX+wLXEnC3M3VsebPmpNnTqibd2BNEbmIlQDMMObhSfGHmSv0XERW/
         uQCA==
X-Gm-Message-State: AO0yUKUNpOglL0iixmsA32/ifpc+wJ42bp9T2k6ej9dkVn5rvUPpxNQa
        8UDhlCCQE2Ogx+ELQCnoJ9tRW5f2jP8GzEk5qpU=
X-Google-Smtp-Source: AK7set+ePFhcMWhEs51xg/oytruSZ3aWyLM8cVFbeWMiUItWEj28S004iS7kIzM2OtPZxguQAou3jg==
X-Received: by 2002:a62:7bc7:0:b0:5ce:ef1b:a86 with SMTP id w190-20020a627bc7000000b005ceef1b0a86mr6098418pfc.2.1679049889673;
        Fri, 17 Mar 2023 03:44:49 -0700 (PDT)
Received: from [127.0.0.1] ([2402:d0c0:2:a2a::1])
        by smtp.gmail.com with ESMTPSA id 2-20020aa79102000000b00593e5a45ce7sm1295486pfh.173.2023.03.17.03.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Mar 2023 03:44:49 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] xfs_db: fix complaints about unsigned char casting
From:   Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20230317102559.agpsaa2fmgd32mc6@andromeda>
Date:   Fri, 17 Mar 2023 18:43:40 +0800
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCCAE5EE-0A38-42B7-B60E-8C60814FE286@gmail.com>
References: <yd5KB_VD7Oe2M-1JTpW8yKsKQ7SaQV9hnFIguCvPI-CuHqrQHOECUVh2Ar9oGpOi5jLK1LKpQ0D_NqN-kz5eyw==@protonmail.internalid>
 <20230315010110.GD11376@frogsfrogsfrogs>
 <20230317102559.agpsaa2fmgd32mc6@andromeda>
To:     "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Is there any reason keep these definition with different types?  =
Question from a newbie...

Thanks,
Alan

> 2023=E5=B9=B43=E6=9C=8817=E6=97=A5 =E4=B8=8B=E5=8D=886:25=EF=BC=8CCarlos=
 Maiolino <cem@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Mar 14, 2023 at 06:01:10PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>=20
>> Make the warnings about signed/unsigned char pointer casting go away.
>> For printing dirent names it doesn't matter at all.
>>=20
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>=20
> Looks good, will test.
>=20
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>=20
>> ---
>> db/namei.c |    4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/db/namei.c b/db/namei.c
>> index 00e8c8dc6d5..063721ca98f 100644
>> --- a/db/namei.c
>> +++ b/db/namei.c
>> @@ -98,7 +98,7 @@ path_navigate(
>>=20
>> 	for (i =3D 0; i < dirpath->depth; i++) {
>> 		struct xfs_name	xname =3D {
>> -			.name	=3D dirpath->path[i],
>> +			.name	=3D (unsigned char *)dirpath->path[i],
>> 			.len	=3D strlen(dirpath->path[i]),
>> 		};
>>=20
>> @@ -250,7 +250,7 @@ dir_emit(
>> 	uint8_t			dtype)
>> {
>> 	char			*display_name;
>> -	struct xfs_name		xname =3D { .name =3D name };
>> +	struct xfs_name		xname =3D { .name =3D (unsigned char =
*)name };
>> 	const char		*dstr =3D get_dstr(mp, dtype);
>> 	xfs_dahash_t		hash;
>> 	bool			good;
>=20
> --=20
> Carlos Maiolino

