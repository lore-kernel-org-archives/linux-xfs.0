Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACDEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 21:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4511222228
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 21:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394773AbhARVhL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:37:11 -0500
Received: from sandeen.net ([63.231.237.45]:59696 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394827AbhARVg0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 16:36:26 -0500
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 334CC4872F3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 15:34:02 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 851038ba
Message-ID: <8704ea2f-84ae-d73f-862e-94d21388c0ef@sandeen.net>
Date:   Mon, 18 Jan 2021 15:35:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BPjrAUEqrYixgCLbliQbCygkHdFs9jqWM"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BPjrAUEqrYixgCLbliQbCygkHdFs9jqWM
Content-Type: multipart/mixed; boundary="J5uKtoKJKEyyNZs4iVIuj7hq5Ag73UTnm";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <8704ea2f-84ae-d73f-862e-94d21388c0ef@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 851038ba

--J5uKtoKJKEyyNZs4iVIuj7hq5Ag73UTnm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the debian/ infrastructure updates.

Thanks,
-Eric

The new head of the for-next branch is commit:

851038ba (HEAD -> for-next, korg/for-next, refs/patches/for-next/fix-cont=
rol) debian: Update Uploaders list

New Commits:

Bastian Germann (6):
      [f808d107] debian: cryptographically verify upstream tarball
      [849e3b65] debian: remove dependency on essential util-linux
      [0a435d0f] debian: remove "Priority: extra"
      [1a86c04a] debian: use Package-Type over its predecessor
      [cac1e96b] debian: add missing copyright info
      [f86541b7] debian: new changelog entry

Nathan Scott (1):
      [851038ba] debian: Update Uploaders list


Code Diffstat:

 debian/changelog                |  11 ++++
 debian/control                  |   7 ++-
 debian/copyright                | 111 ++++++++++++++++++++++++++++++++++=
++-----
 debian/upstream/signing-key.asc |  63 +++++++++++++++++++++++
 debian/watch                    |   2 +-
 5 files changed, 176 insertions(+), 18 deletions(-)
 create mode 100644 debian/upstream/signing-key.asc


--J5uKtoKJKEyyNZs4iVIuj7hq5Ag73UTnm--

--BPjrAUEqrYixgCLbliQbCygkHdFs9jqWM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmAF/zAFAwAAAAAACgkQIK4WkuE93uDn
KRAAqbnXvF24Vv0ewgg9VYfZ/A81nQsnUcW0u573eeBEYVCsbb5CAENx1RaqTVFL3EuoLYd9d63a
QiMrHucw7/nQQZ6seZWljhFdapV7Aynpp6EBkoGATffYlLUgyNMZbjP4/9ejxsuu8MuV3AFN2NaS
PBWG8Tad4wpRyg6G2L3TuSq6frYKYmrBa3WCJFi/jqhZZRNuAfpq/U2k8vE2OF+vLuG1RVCuqoqY
A6rhy1QA8jbBb2NR/r1FfEMQ7YmJjdyQFnN76psAOfWY+5QSf/UQyJgMPGoFAq9KeJaGDU+9VTZQ
EH1tv1zRM+5WrWqGgUSzJDbN75BM60VaNclfJXQlj7/7iukywqEAIwcqMh+GBiyC5JqG7ddfYoyK
wAlg4rQkaOP5D0jSD/UTLys4c3IEOI0v2DNWlp8zspRXWR7lvpcRgnj4S8M73Tc35IvknlYRQ3px
sox+++VHHtev4kjxbFU6wUphTK80bmz7BjcPIAzN9z6b06F8pPxUiPAl47Gw39rghnvJ0/BX/CCT
YwG19t03qQhY3tz4y0JtHmPVyNfuiVQUaxnycF2sWOHyZzZ2bIOujY1Iozw6xrq2dJiM+G7O0VRk
eRV17ettVxUvUrvDN2lPo9XN3YrpnFBparGBMZ6IDVMZT69G/550sYdPvFsnM2GD6ei7AOXgNWUX
Ef8=
=cUfS
-----END PGP SIGNATURE-----

--BPjrAUEqrYixgCLbliQbCygkHdFs9jqWM--
