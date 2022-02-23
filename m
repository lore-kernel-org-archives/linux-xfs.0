Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C03C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 15:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiBWPmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Feb 2022 10:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiBWPmC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Feb 2022 10:42:02 -0500
X-Greylist: delayed 381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Feb 2022 07:41:34 PST
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9244F9FE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 07:41:34 -0800 (PST)
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id CDD4A5474D1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 10:35:12 -0500 (EST)
Received: from harpe.intellique.com (unknown [195.135.69.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 6A12560AE6E
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 10:35:12 -0500 (EST)
Date:   Wed, 23 Feb 2022 16:35:13 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     linux-xfs@vger.kernel.org
Subject: experience with very large filesystems
Message-ID: <20220223163513.43f1f054@harpe.intellique.com>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2hVicA4Yt0GeveTwtiNaIMn"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/2hVicA4Yt0GeveTwtiNaIMn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I have a large filesystem (1.2 PiB) that's been working flawlessly for
4 years (an LV aggregating 4 300~ish TB RAID-6 arrays). However it's
getting really full (more than 1.1 PiB full right now), and I'm
considering expanding it to 1.8 PiB or more.

Any thoughts, caveats or else?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/2hVicA4Yt0GeveTwtiNaIMn
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAmIWVDIACgkQX3jQXNUicVZXHgCeI+rO36HC8XNyXKJH9VW5lUPZ
GjUAmwTw1Fv1EaqFYEEeHikC5rNE8Xjr
=eVDv
-----END PGP SIGNATURE-----

--Sig_/2hVicA4Yt0GeveTwtiNaIMn--
