Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13A5C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 14:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A670208CA
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 14:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCYOYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:24:42 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:30632 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727538AbgCYOYl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Mar 2020 10:24:41 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 007565474A3;
        Wed, 25 Mar 2020 10:24:40 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 6D28960AE3C;
        Wed, 25 Mar 2020 10:24:40 -0400 (EDT)
Date:   Wed, 25 Mar 2020 15:24:36 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Pawan Prakash Sharma <pawanprakash101@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs duplicate UUID
Message-ID: <20200325152418.04340a72@harpe.intellique.com>
In-Reply-To: <CABS7VHDt=v1SmSggnn8288uE5Cs27RqXpPsbiGk9=wyJ-pz1pQ@mail.gmail.com>
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
        <20200324183819.36aa5448@harpe.intellique.com>
        <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
        <20200324192610.0f19a868@harpe.intellique.com>
        <CABS7VHDt=v1SmSggnn8288uE5Cs27RqXpPsbiGk9=wyJ-pz1pQ@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GQ6kx1M7J/UE8MrzolOlWIy"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/GQ6kx1M7J/UE8MrzolOlWIy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 24 Mar 2020 23:58:24 +0530
Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:

> >Your problem is that the log is dirty. You need to mount it once to =20
> clean up the log, then you'll be able to change the UUID.
>=20
> But why xfs_freeze is not clearing that as man page says that it does
> that?

Please reply to the list so that anyone interested can learn about it.=20

This is mentioned in the man page at the next line:

 Note that even after freezing, the on-disk filesystem can contain
 information on files that are still in  the process of unlinking.
 These files will not be unlinked until the filesystem is unfrozen or a
 clean mount of the snapshot is complete.

You probably have open unlinked files (such as temporary files). It's
very common.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/GQ6kx1M7J/UE8MrzolOlWIy
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl57aawACgkQX3jQXNUicVa9SgCg643RJxYqxDtgA3InXCWfqSmC
KZcAoJR6KFaPHlxv6jPamqmM7qAsBeqr
=ixBs
-----END PGP SIGNATURE-----

--Sig_/GQ6kx1M7J/UE8MrzolOlWIy--
