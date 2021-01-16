Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DED7C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C55207B6
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAPJfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbhAPJf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:35:29 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5BC0613D3
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:34:48 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 6so16756322ejz.5
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=rswQ/ApcgYamb5hFYuyYx2TpIr9U8s8G/z2UBE6wkvw=;
        b=almQ6x167DKMl4kpy8OWJ/ag46yEJ5pLXWvXrVHDisLD83JoYs3KFcefw8pVrdsyCb
         KTPrTp8+rq9gpAlMwGA2UIfulF1S2Jbufz7TV6hTJzBlvlLwCJOM9qGWl3vKqNrdHLx4
         3bNW6ze/n5EE5TpniSQ2F6Na9y8WBo/150m9UMA+hhK0W+fQ02u4wtUPAK0RkN/AokCn
         mygGgbk6MlKGaYcWWZuCtQc1mzwayydPKj/XZaoGFfOgmCslXWi6W5u8tHq53SSet+ZS
         ohaF05ASDCz8j9e+EgOF6MD9BG702VITTj7rPhR2Sc7Jc0LhO4DmOcHoJlu6gn7KXiib
         yZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=rswQ/ApcgYamb5hFYuyYx2TpIr9U8s8G/z2UBE6wkvw=;
        b=FFicDoc5imoGTWh3RqacWM9lLQ4WaCOXjo04ypfWnKeMlMjb7XDGbqIRZDQGiBkMNR
         Yx63a3yuwHYZY0XFAZVBI3BwuiSSOZSx/NKBcUkDyCUqYE0PxVi3NIxaANudzLQoBwZN
         uvg8TymrLB42gdpSurJTmHUaB8rTl8hwriR4OS19ACHQv0A/qX8wjX6jvW8APX1LCgfW
         VINoGOJW9djPuIXNW3U/DjEg7wIPKu7FkoO1TzVwNWQ32gc8EwQ+9BoOOqmmcufgQr2z
         jQAj4cJFuhVk7slrk8LRgtvGtn06m/Hk7JwQA17qZToKWqlMaGo889KPWK9c5/krnttg
         lAYw==
X-Gm-Message-State: AOAM530dtCBN1QIPFJUfhWSs++7jzt4URGP/1GlTCS+i+dM+4MX31BBO
        ECNqyiSrEyNUja/uPzBJmpPHxQuK+vPhD9OO4/c=
X-Google-Smtp-Source: ABdhPJwqR6OoSJnfcwUTEkt//GQU5qzZh5+zE+jRTwS8QfdILqbL+h7WgMWDOI2+gxl2ssN5z6aHrw==
X-Received: by 2002:a17:906:aac1:: with SMTP id kt1mr11113221ejb.329.1610789686958;
        Sat, 16 Jan 2021 01:34:46 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id zn8sm6271596ejb.39.2021.01.16.01.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 01:34:46 -0800 (PST)
To:     nathans@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
From:   Bastian Germann <bastiangermann@fishpost.de>
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
Message-ID: <24a4b41b-4af0-66ad-48c9-64e616c2ce4e@fishpost.de>
Date:   Sat, 16 Jan 2021 10:34:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EkuYxbyHQdPBJuqs9fGfaJ9Q2XdMt6Pk3"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EkuYxbyHQdPBJuqs9fGfaJ9Q2XdMt6Pk3
Content-Type: multipart/mixed; boundary="fUaEjkRMxrWw3mZN0iFLijVCFyPiM9kV3";
 protected-headers="v1"
From: Bastian Germann <bastiangermann@fishpost.de>
To: nathans@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
 Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Message-ID: <24a4b41b-4af0-66ad-48c9-64e616c2ce4e@fishpost.de>
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
In-Reply-To: <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>

--fUaEjkRMxrWw3mZN0iFLijVCFyPiM9kV3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 15.01.21 um 04:40 schrieb Nathan Scott:
> Heya,
>=20
> On Fri, Jan 15, 2021 at 5:39 AM Bastian Germann
> <bastiangermann@fishpost.de> wrote:
>>
>> Apply some minor changes to the xfsprogs debian packages, including
>> missing copyright notices that are required by Debian Policy.
>>
>> Bastian Germann (6):
>>    debian: cryptographically verify upstream tarball
>>    debian: remove dependency on essential util-linux
>>    debian: remove "Priority: extra"
>>    debian: use Package-Type over its predecessor
>>    debian: add missing copyright info
>>    debian: new changelog entry
>=20
> Having reviewed each of these, please add for each:
>=20
> Signed-off-by: Nathan Scott <nathans@debian.org>
>=20
>=20
> Also, please add Bastion to the list of deb uploaders - thanks!

Hi Nathan,

There is no point in adding me unless you allow uploads for my key
2861 2573 17C7 AEE4 F880  497E C386 0AC5 9F57 4E3A via

https://wiki.debian.org/DebianMaintainer#Granting_Permissions

Thanks,
Bastian

>=20
> diff --git a/debian/control b/debian/control
> index 49ffd340..06b92400 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -2,7 +2,7 @@ Source: xfsprogs
>   Section: admin
>   Priority: optional
>   Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
> -Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
> <anibal@debian.org>
> +Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
> <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
>   Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>=3D
> 5), gettext, libtool, libedit-dev, libblkid-dev (>=3D 2.17),
> linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python,
> pkg-config
>   Standards-Version: 4.0.0
>   Homepage: https://xfs.wiki.kernel.org/
>=20


--fUaEjkRMxrWw3mZN0iFLijVCFyPiM9kV3--

--EkuYxbyHQdPBJuqs9fGfaJ9Q2XdMt6Pk3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsD5BAABCAAjFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmACszQFAwAAAAAACgkQH1x6i0VWQxQ3
VQwAtV64yrFESNTX98lwHELNuw2JAvf/qQ+HAY2kYj55HT5kD2IpkmjTrm+Isg3c0AfnhjFJGXKN
iWzeBIvQNB2x0t52XeMVFOSd3VJXxyVQ7xrUHU7TAGU5pp8dFhLJCBxKbIKQ1RSw6MqtgyDzVc8Z
Bu225D8R8t9yod9I/F3Dx0v8zhAg0R1jbsSiwnO16Zs66rDw31j9RH0SPJiNNdqMVkSD3cLupH26
xLYlxmHRA/RPdKSdOFtuMjv3YHbjnbsuAl8ebkOOGou14+tccAzBWQWJ1dHm2Sw+3SH6itpU2olT
+g9EU3XK1DBwM9oB26nPpJ6tl0eVL60OJ3rQI+m7fDuEB+WhxaFBG7+bghFkXLBKlH4i0dHfj/xm
xMKXli7aKoFLIr2j6NtHm8le+ncREKH5WWjKU4wvKWGUWMqSYEWiZC3cV0NiN9JwKxSZ6oVXSNCR
5kJ8PYXjVAzHMYqp/MTtqABfOeSq4YdnWNK9+qGjTVaXv+rDoLJJJJXeU9oR
=+68i
-----END PGP SIGNATURE-----

--EkuYxbyHQdPBJuqs9fGfaJ9Q2XdMt6Pk3--
