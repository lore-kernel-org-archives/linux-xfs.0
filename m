Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5855C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B12D20714
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCXRfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:35:04 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:59122 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgCXRfE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Mar 2020 13:35:04 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 3874F5474B0;
        Tue, 24 Mar 2020 13:35:03 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 9B5AA60AE37;
        Tue, 24 Mar 2020 13:35:02 -0400 (EDT)
Date:   Tue, 24 Mar 2020 18:28:37 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pawan Prakash Sharma <pawanprakash101@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: xfs duplicate UUID
Message-ID: <20200324182837.57f71c65@harpe.intellique.com>
In-Reply-To: <20200324161655.GA10586@infradead.org>
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
        <20200324161655.GA10586@infradead.org>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9HmW8/V8WPqyMS9AucycBAv"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/9HmW8/V8WPqyMS9AucycBAv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 24 Mar 2020 09:16:55 -0700
Christoph Hellwig <hch@infradead.org> =C3=A9crivait:

> On Tue, Mar 24, 2020 at 09:43:25PM +0530, Pawan Prakash Sharma wrote:
> > Hi,
> >=20
> > I am using ZFS filesystem and created a block device(ZVOL) and
> > mounted and formatted that as xfs filesystem. I have one
> > application running which is using this xfs file system.
> >=20
> > Now, when I am creating a ZFS snapshot and ZFS clone and trying to
> > mount the clone filesystem, I am getting duplicate UUID error and I
> > am not able to moiunt it. =20
>=20
> Don't ask for our help if you are intentionally violating our
> copyrights.

Come on, do you think he's an Oracle peon? :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/9HmW8/V8WPqyMS9AucycBAv
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl56RMoACgkQX3jQXNUicVbYmQCg2bP61PDOKYyY1LF0mw6DWLQ5
4/sAoLqDBQrbmBpJiw6lh3xkrbTeyC1m
=u2we
-----END PGP SIGNATURE-----

--Sig_/9HmW8/V8WPqyMS9AucycBAv--
