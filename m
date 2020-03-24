Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA77C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 18:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF51C20714
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 18:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgCXS0H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 14:26:07 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:13168 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbgCXS0G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Mar 2020 14:26:06 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 298B95474CE;
        Tue, 24 Mar 2020 14:26:06 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id A987B60AFA3;
        Tue, 24 Mar 2020 14:26:05 -0400 (EDT)
Date:   Tue, 24 Mar 2020 19:26:10 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Pawan Prakash Sharma <pawanprakash101@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs duplicate UUID
Message-ID: <20200324192610.0f19a868@harpe.intellique.com>
In-Reply-To: <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
        <20200324183819.36aa5448@harpe.intellique.com>
        <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/tObYrmr10NaIaJYd1mMz8Uu"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/tObYrmr10NaIaJYd1mMz8Uu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 24 Mar 2020 23:14:03 +0530
Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:

> > Did you try to mount it with the "nouuid" option? =20
>=20
> yes, that is working fine. I am able to mount it. But I am not sure
> the side effect of doing that as there will not be any uuid generated
> and xfsdump/xfsrestore might need that. Correct me if I am wrong.
>=20

Your problem is that the log is dirty. You need to mount it once to
clean up the log, then you'll be able to change the UUID.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/tObYrmr10NaIaJYd1mMz8Uu
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEUEARECAAYFAl56UMMACgkQX3jQXNUicVaDrACdHMrhl+zNBoUk1JCxQuVkaiiH
DOsAmNSB+plhsPMVdEMSDVCDBIKgpRs=
=m+0Y
-----END PGP SIGNATURE-----

--Sig_/tObYrmr10NaIaJYd1mMz8Uu--
