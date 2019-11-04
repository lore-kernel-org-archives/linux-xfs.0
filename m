Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1518CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 13:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C660520B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 13:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfKDNbM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 08:31:12 -0500
Received: from mail1.g1.pair.com ([66.39.3.162]:37028 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbfKDNbM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 08:31:12 -0500
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 3F59F547456;
        Mon,  4 Nov 2019 08:31:11 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id BFA7F60AE84;
        Mon,  4 Nov 2019 08:31:10 -0500 (EST)
Date:   Mon, 4 Nov 2019 14:31:13 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_repair keeps reporting errors
Message-ID: <20191104143113.682d1e9d@harpe.intellique.com>
In-Reply-To: <20191101104551.GB59146@bfoster>
References: <20191031154049.166549a3@harpe.intellique.com>
        <20191101104551.GB59146@bfoster>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/c5VU_JgeIJk3H52Nz0WV/hO"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/c5VU_JgeIJk3H52Nz0WV/hO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 1 Nov 2019 06:45:51 -0400
Brian Foster <bfoster@redhat.com> =C3=A9crivait:

> I think it's hard to say what might be going on here without some view
> into the state of the fs. Perhaps some large chunk of the fs has been
> zeroed given all of the zeroed out on-disk inode fields? We'd probably
> want to see a metadump of the fs to get a closer look.
>=20

Alas, the metadump is 28 GB... (this is a 500 TB filesystem). So far it
seems to behave better with no background RAID controller operation.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/c5VU_JgeIJk3H52Nz0WV/hO
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl3AKCIACgkQX3jQXNUicVbdCQCeKa04XIaTdHPClKaT471H8UMo
c6YAoJUHiF0Zwcx/zVpVfZ1uh76YTYUI
=JXZW
-----END PGP SIGNATURE-----

--Sig_/c5VU_JgeIJk3H52Nz0WV/hO--
