Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8C3CA9ECB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 14:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38D3B2086D
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 14:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfJaOqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:46:32 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:45537 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbfJaOqc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Oct 2019 10:46:32 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 10:46:31 EDT
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id CA814547477
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2019 10:40:46 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 71E1160B076
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2019 10:40:46 -0400 (EDT)
Date:   Thu, 31 Oct 2019 15:40:49 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     linux-xfs@vger.kernel.org
Subject: xfs_repair keeps reporting errors
Message-ID: <20191031154049.166549a3@harpe.intellique.com>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nLeV2NsHLFnPtWVsVmy6H1H"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/nLeV2NsHLFnPtWVsVmy6H1H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I just had a problem with a RAID array, now that the rebuild process
is complete, as I run xfs_repair (v 5.0) again and again it keeps
reporting problems (here running xfs_repair for the 3rd time in a row):


bad CRC for inode 861144976062
bad magic number 0x0 on inode 861144976062
bad magic number 0x0 on inode 217316006460
bad version number 0x0 on inode 217316006460
inode identifier 0 mismatch on inode 217316006460
bad version number 0x0 on inode 861144976062
bad CRC for inode 217316006461
bad magic number 0x0 on inode 217316006461
inode identifier 0 mismatch on inode 861144976062
bad version number 0x0 on inode 217316006461
inode identifier 0 mismatch on inode 217316006461
bad CRC for inode 217316006462
bad magic number 0x0 on inode 217316006462
bad CRC for inode 861144976063
bad magic number 0x0 on inode 861144976063
bad version number 0x0 on inode 861144976063
bad version number 0x0 on inode 217316006462
inode identifier 0 mismatch on inode 217316006462
bad CRC for inode 217316006463
bad magic number 0x0 on inode 217316006463
inode identifier 0 mismatch on inode 861144976063
bad version number 0x0 on inode 217316006463
inode identifier 0 mismatch on inode 217316006463

Is there anything else to do?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/nLeV2NsHLFnPtWVsVmy6H1H
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl268nIACgkQX3jQXNUicVaqpQCcDnoL5BL2W06QRt9bOqqSAxqF
6tAAoIl+yE9E6mux59pqh54CFurEj0Cr
=8nHG
-----END PGP SIGNATURE-----

--Sig_/nLeV2NsHLFnPtWVsVmy6H1H--
