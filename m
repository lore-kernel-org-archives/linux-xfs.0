Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFC0C001DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 09:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjHBJl4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 05:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjHBJlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 05:41:52 -0400
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5372D6D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 02:41:40 -0700 (PDT)
Date:   Wed, 02 Aug 2023 09:41:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
        s=protonmail3; t=1690969298; x=1691228498;
        bh=QKRmuTT6LkzLHDSX6WfE4lU6d+8z1JHgigKOgB15Tlw=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=rhqRFNEqy+oPU1mFvs45eCqCcObT2JVxy7mNHSWMfEkrtdj6DxG/XnhCDyH+wKvIw
         6lVoKN7mM+L9MmU4csQ4IqLYHqQ5FbpDOJ6l0MfF2LVnlXZn1d6dzKnVRzhyKT38pM
         OKrXKYaszbaMbKokIFY0eVrf0zfcSNG463wX/lFm62oy6InovMkWg4wg6goj4MeCqB
         Ko3SCrHM/67FQGznVpJqjrX7wHz6TbqsKb2QmJw41zwuNTSqq+fHdmTgcLRu1ZdJir
         gXgfx8ATLby5NbnAx6KfN6fCJ3IyQySU7Do+EPw6cfi/UnfdB9tS5Jv3alImYMtKnn
         mVd/s5TNWzbeA==
To:     linux-xfs@vger.kernel.org
From:   Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to a86308c98
Message-ID: <20230802094128.ptcuzaycy3vzzovk@andromeda>
Feedback-ID: 28765827:user:proton
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------65b20972c93fb43f69e661b21a3d51cca7570a9e34a213b8fefa9cf4523f1f6d"; charset=utf-8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------65b20972c93fb43f69e661b21a3d51cca7570a9e34a213b8fefa9cf4523f1f6d
Content-Type: text/plain; charset=UTF-8
Date: Wed, 2 Aug 2023 11:41:28 +0200
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to a86308c98
Message-ID: <20230802094128.ptcuzaycy3vzzovk@andromeda>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

a86308c98d33e921eb133f47faedf1d9e62f2e77

2 new commits:

Bill O'Donnell (1):
      [780e93c51] mkfs.xfs.8: correction on mkfs.xfs manpage since reflink and dax are compatible

Wu Guanghao (1):
      [a86308c98] xfs_repair: fix the problem of repair failure caused by dirty flag being abnormally set on buffer

Code Diffstat:

 man/man8/mkfs.xfs.8.in | 7 -------
 repair/scan.c          | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--------65b20972c93fb43f69e661b21a3d51cca7570a9e34a213b8fefa9cf4523f1f6d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmTKJMoJkOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAHsVAQDLjAE4kHhB0TmFR/JF25GYhhFWid2GGZLDXT9+IRxKgAEApHtL
5Vco0dsXWV2HL3cr3yaKSWCunAcBQyd3R/hCugU=
=ziR3
-----END PGP SIGNATURE-----


--------65b20972c93fb43f69e661b21a3d51cca7570a9e34a213b8fefa9cf4523f1f6d--

