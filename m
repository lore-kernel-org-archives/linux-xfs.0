Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1EEC433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 14:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A31664E6F
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 14:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBHOqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 09:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhBHOpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Feb 2021 09:45:45 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200AAC061788
        for <linux-xfs@vger.kernel.org>; Mon,  8 Feb 2021 06:45:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l97mh-0005AZ-6r; Mon, 08 Feb 2021 14:45:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#981662: Bug#981864: libinih: Please provide libinih1-udeb
Reply-To: Cyril Brulebois <kibi@debian.org>, 981662@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 981662
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: d-i confirmed
References: <a1fc03a4-7e01-04f4-d7c0-7f0ad8a182f8@fishpost.de> <a1fc03a4-7e01-04f4-d7c0-7f0ad8a182f8@fishpost.de> <a1fc03a4-7e01-04f4-d7c0-7f0ad8a182f8@fishpost.de> <624c9146-2d10-1028-8ee4-d7361ca5a98b@fishpost.de> <161228884604.31814.16098605757501286276.reportbug@tack.local>
X-Debian-PR-Source: xfsprogs
Received: via spool by 981662-submit@bugs.debian.org id=B981662.161279536418163
          (code B ref 981662); Mon, 08 Feb 2021 14:45:02 +0000
Received: (at 981662) by bugs.debian.org; 8 Feb 2021 14:42:44 +0000
Received: from glenfiddich.mraw.org ([62.210.215.98]:50444)
        by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <kibi@debian.org>)
        id 1l97kR-0004iF-BA; Mon, 08 Feb 2021 14:42:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mraw.org;
         s=mail2019; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZlpfBkoYaPkDGqIHfDXbgGdYa6nWP6aNCfcftkWQG4Q=; b=MNwV/Krwc+j0G3EJoDSlczJtl5
        IB9hnieyr+WFtpuqggcwGwsM4ZvMhsxkOXW0rClVGU83ZQohEqh8dUYf0fBxBG4zaaQ5+TNVg7EqE
        PF0hd3qDVeQozOD2ju1zyNtsX47JRJpY06okjkEzwEet4+McYPxbRyP9yCgd719CQ3XrLl6lv1LOy
        8bFoifWPK3tRf5VUZwaxEfL6zIatjfpmsyCZSIvB1uasM9ATUNCxuTZ+leOD4ALy9uVy0tOypuhBp
        8w5ZolBtkpXV7APYTZFRIxT4OM+KXIn/R6SotxGKYrHdIdrtjAqZidfXI7g6ZDfGX7towiPQntqnT
        tKi3XuTQ==;
Received: from localhost ([127.0.0.1] helo=mraw.org)
        by glenfiddich.mraw.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <kibi@debian.org>)
        id 1l97eS-0006pn-EZ; Mon, 08 Feb 2021 15:36:32 +0100
Date:   Mon, 8 Feb 2021 15:36:31 +0100
From:   Cyril Brulebois <kibi@debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>,
        981864@bugs.debian.org
Cc:     981662@bugs.debian.org, debian-boot@lists.debian.org
Message-ID: <20210208143631.vjy5ayzwqo6azqmv@mraw.org>
Organization: Debian
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bvehytbootzobvyj"
Content-Disposition: inline
In-Reply-To: <624c9146-2d10-1028-8ee4-d7361ca5a98b@fishpost.de>
X-Greylist: delayed 368 seconds by postgrey-1.36 at buxtehude; Mon, 08 Feb 2021 14:42:42 UTC
X-CrossAssassin-Score: 2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--bvehytbootzobvyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(With my d-i release manager hat.)

Bastian Germann <bastiangermann@fishpost.de> (2021-02-05):
> Tags: patch
>=20
> On Thu, 4 Feb 2021 18:17:29 +0100 Bastian Germann wrote:
> > xfsprogs recently became a reverse dependency of your package.
> > #981662 documents that for the xfsprogs' udeb variant, a libinih1-udeb
> > to link against is needed. Please provide that package.
>=20
> A patch to introduce that package is enclosed.

Thanks, that looks good to me. I've also checked that rebuilding
xfsprogs against an updated libinih-dev package leads to the expected
dependencies for xfsprogs-udev:

  Depends: libblkid1-udeb (>=3D 2.31), libc6-udeb (>=3D 2.31), libinih1-ude=
b (>=3D 50), libuuid1-udeb (>=3D 2.31)

We would be happy to have this merged soon, since xfs support in the
installer is currently broken:

  https://bugs.debian.org/981662

I'm happy to upload the package and talk to the ftp team (a little
trip to NEW will happen) myself if that helps.


Cheers,
--=20
Cyril Brulebois (kibi@debian.org)            <https://debamax.com/>
D-I release manager -- Release team member -- Freelance Consultant

--bvehytbootzobvyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEtg6/KYRFPHDXTPR4/5FK8MKzVSAFAmAhTGcACgkQ/5FK8MKz
VSDx/A/+LpA0rWpiBM+3rRV+JrnaXAuHi8msGq39NOgiynobiDztewRYPh5EA09+
vI3mJ2P/sCqiSYPUOeoCi5fmnsa472tlILSQibdUVAjS0ceNbFOKGlbuTC/OrDlZ
db+hLEDdgmLfmXaH2jHwlR3bKp8KolYXtf8dvGCeKwlLqa6WLsZmeJESuliKfHDS
/Q+hkObFwEAEByEZa5agVUaocHQ8Bz/tQ1MEe77e13HTZfP3687kM2cT9fxZWkEe
vaKfMx6xtTDejzYcvBga4uZEWDSgBxzbXqIB8KEJ5OUpHRy5JkDHG25qqrEXqNv6
Qy1imzPE1tdo6L3F1qquoayyZbZ2ejuAqgoW0+p1yqeluQ33KeXDa7Lkg9/sDg/H
KA2N56tAxmXkLLSirdSRochQOu2uEl04oTPHW1wJUxfdUVh2znaMzVo7HvW217GN
naqP9K9Mn09fOCObk0McD3ZypgTlrXJkraHSH6d5YLDf8bPStrwDJ8PZPo6fSH5P
7kgx8uv5FnpNgYKT95aRxZLTB+7iFJNL2fSLC/B2j9qorGdM1xHfqgZh0hwEX0LO
qIeQsiOkYlVVoNnvsTsqBZ334hQQQR004ba9kvy9vVNksZ+DsiFHEKKfIobI62WX
TahdF8SSDUPmROeSWyJcTlIXLOPc65KRrDAfbMhA8N4cjQJq8fA=
=31Rt
-----END PGP SIGNATURE-----

--bvehytbootzobvyj--
