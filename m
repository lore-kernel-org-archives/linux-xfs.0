Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46A3C74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 13:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCRN7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Mar 2023 09:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCRN7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2023 09:59:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C902ED7E
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 06:59:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id bc12so7436270plb.0
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679147950;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/M+dMSn26B2qEpccb8uAbpa/HFPTTo4JVzYhjAXPk8=;
        b=PCAKqKhET82WN3JId4ejgfBGIVGnVjrO5I0bxl/js6jcTEvpzUrtxGh8oV8f0JBDKL
         yBk1Sw89LaxNjKYcC07PwUHw2h+Ux+y6JommCqmyFzmPb+5ffh7PF8BlE1USMefI6uo0
         24bafU+FJqkQONj7+SxByrZ1RNHG/MqamBFOUghhWkDOuFnk1lT5v4e/0FLHgVrwYCDD
         OdaKq+mRr4Tcjqvb+D0Ud9SIfRoX4WzSTRdkwdck2yH5VNbM3lCBHDN3TyZ3an5Uv3Nl
         jFatfGWQY4rveikQU75F39CTnqTn0tqUKfgH4BbhbOGlWcHCPBrt0HpLhOQN0VKSvkoI
         YnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679147950;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/M+dMSn26B2qEpccb8uAbpa/HFPTTo4JVzYhjAXPk8=;
        b=yhdRQmuGM/T68EtyuyVjC/qvL6j1HrhUkFSDAxQ3jb6lw120i0BpRYjbYvXDL76uPP
         c/O/ONTWDDlUYLLXEL90r3gEIoYbNrDAZ304etSYIE64wcg8K5NJJ33i7a1YUtvman+w
         wvyrtY04/CE7ozuhD1ycWigdgjvkJzaOnEaasHGV6y4PVXiaksQI/r9sKaDxBEYS+LSr
         sv0sPxnlDNzAw3bhHNM6BHQbpbqcwMs3A8PsriX1FrE0wU+N5VLoeMM/2Qbi2X1zmuaU
         6qnEWO1ASTnJDYLZRnWz/xzTq5vqijTSRRqC8DzobAjQSZlmCS44gQvVq+ysrAG5fsM8
         a5mw==
X-Gm-Message-State: AO0yUKXx0fTgZnN/yrdzFPrn3KRsCSNx38TKsj2Be+a+FVxSNGfMgPDs
        epmpsTCK558JQJuNO8iiT0aBdxq9sFo=
X-Google-Smtp-Source: AK7set8EG/auqVIej22Bf/JBtPgeZrqcfCMqr43BLmrsJH1GfB81lqwfpaYsDRDLwvTdX3m+yeM1Rw==
X-Received: by 2002:a17:902:ec8d:b0:1a1:9020:f9c7 with SMTP id x13-20020a170902ec8d00b001a19020f9c7mr11637358plg.44.1679147949881;
        Sat, 18 Mar 2023 06:59:09 -0700 (PDT)
Received: from [192.168.31.119] ([111.0.233.75])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902ee8d00b0019f11a68c42sm3286082pld.297.2023.03.18.06.59.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Mar 2023 06:59:09 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] xfs_db: fix complaints about unsigned char casting
From:   Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20230317202920.GJ11394@frogsfrogsfrogs>
Date:   Sat, 18 Mar 2023 21:59:02 +0800
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9941E0C-756F-45E2-91D7-53CC2A843FCE@gmail.com>
References: <yd5KB_VD7Oe2M-1JTpW8yKsKQ7SaQV9hnFIguCvPI-CuHqrQHOECUVh2Ar9oGpOi5jLK1LKpQ0D_NqN-kz5eyw==@protonmail.internalid>
 <20230315010110.GD11376@frogsfrogsfrogs>
 <20230317102559.agpsaa2fmgd32mc6@andromeda>
 <BCCAE5EE-0A38-42B7-B60E-8C60814FE286@gmail.com>
 <20230317202920.GJ11394@frogsfrogsfrogs>
To:     "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for your detailed explanation!

Thanks,
Alan

> 2023=E5=B9=B43=E6=9C=8818=E6=97=A5 =E4=B8=8A=E5=8D=884:29=EF=BC=8CDarric=
k J. Wong <djwong@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, Mar 17, 2023 at 06:43:40PM +0800, Alan Huang wrote:
>> Is there any reason keep these definition with different types?  =
Question from a newbie...
>=20
> Probably not, but char* handling in C is a mess if you don't specify
> signedness -- on some arches gcc interprets "char" as "signed char", =
and
> on others it uses "unsigned char".  The C library string functions all
> operate on "char *", so if you start changing types you quickly end up
> in compiler warning hell over that.
>=20
> libxfs seems to use "unsigned char*" and "uint8_t *".  I don't know if
> that was just an SGI thing, or merely a quirk of the codebase?  The
> Linux VFS code all take "char *", though as of 6.2 the makefiles force
> those to unsigned everywhere.  As far as directory entry and extended
> attribute names go, all eight bits are allowed.
>=20
> UTF8 encoding uses the upper bit of a char, which means that we really
> want unsigned to avoid problems with sign extension when computing
> hashes and things like that, because emoji and kanji characters are in
> use around the world.
>=20
> IOWS: it's a giant auditing headache to research what parts use the =
type
> declarations they do, figure out what subtleties go with them, and
> decide on appropriate fixes.  And in the end... the system still =
behaves
> the same way it did.
>=20
> --D
>=20
>> Thanks,
>> Alan
>>=20
>>> 2023=E5=B9=B43=E6=9C=8817=E6=97=A5 =E4=B8=8B=E5=8D=886:25=EF=BC=8CCarl=
os Maiolino <cem@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Tue, Mar 14, 2023 at 06:01:10PM -0700, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <djwong@kernel.org>
>>>>=20
>>>> Make the warnings about signed/unsigned char pointer casting go =
away.
>>>> For printing dirent names it doesn't matter at all.
>>>>=20
>>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>>=20
>>> Looks good, will test.
>>>=20
>>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>>>=20
>>>> ---
>>>> db/namei.c |    4 ++--
>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>=20
>>>> diff --git a/db/namei.c b/db/namei.c
>>>> index 00e8c8dc6d5..063721ca98f 100644
>>>> --- a/db/namei.c
>>>> +++ b/db/namei.c
>>>> @@ -98,7 +98,7 @@ path_navigate(
>>>>=20
>>>> 	for (i =3D 0; i < dirpath->depth; i++) {
>>>> 		struct xfs_name	xname =3D {
>>>> -			.name	=3D dirpath->path[i],
>>>> +			.name	=3D (unsigned char *)dirpath->path[i],
>>>> 			.len	=3D strlen(dirpath->path[i]),
>>>> 		};
>>>>=20
>>>> @@ -250,7 +250,7 @@ dir_emit(
>>>> 	uint8_t			dtype)
>>>> {
>>>> 	char			*display_name;
>>>> -	struct xfs_name		xname =3D { .name =3D name };
>>>> +	struct xfs_name		xname =3D { .name =3D (unsigned char =
*)name };
>>>> 	const char		*dstr =3D get_dstr(mp, dtype);
>>>> 	xfs_dahash_t		hash;
>>>> 	bool			good;
>>>=20
>>> --=20
>>> Carlos Maiolino
>>=20

