Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E5CC4361B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65EF23A79
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgLHQre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:47:34 -0500
Received: from sandeen.net ([63.231.237.45]:42442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgLHQre (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Dec 2020 11:47:34 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 17B9EEDD
        for <linux-xfs@vger.kernel.org>; Tue,  8 Dec 2020 10:46:13 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.10.0-rc1 released
Message-ID: <c704c832-d0aa-660c-26b0-5e894a92848c@sandeen.net>
Date:   Tue, 8 Dec 2020 10:46:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T2vKjf9uZYxxRGGEkMdsbpsqKjBJaCZGK"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T2vKjf9uZYxxRGGEkMdsbpsqKjBJaCZGK
Content-Type: multipart/mixed; boundary="sIeIPS3aXR5wroAkuut7uYuDw94EHEo4U";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <c704c832-d0aa-660c-26b0-5e894a92848c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.10.0-rc1 released

--sIeIPS3aXR5wroAkuut7uYuDw94EHEo4U
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.10.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

317ed78d (HEAD -> for-next, tag: v5.10.0-rc1, korg/for-next, refs/patches=
/for-next/5.10.0-rc1) xfsprogs: Release v5.10.0-rc1

New Commits:

Darrick J. Wong (5):
      [07ed2de8] libxfs-apply: don't add duplicate headers
      [05c716fb] libxfs: fix weird comment
      [8fa72fed] libxfs: add realtime extent reservation and usage tracki=
ng to transactions
      [55c5b4a7] debian: fix version in changelog
      [fe4a31ea] debian: add build dependency on libinih-dev

Eric Sandeen (4):
      [0d7b09ac] xfs_quota: document how the default quota is stored
      [3a6ded04] xfs_quota: Remove delalloc caveat from man page
      [15ce5839] xfsprogs: make things non-gender-specific
      [317ed78d] xfsprogs: Release v5.10.0-rc1


Code Diffstat:

 VERSION                    |  2 +-
 configure.ac               |  4 ++--
 debian/changelog           |  8 +++++++-
 debian/control             |  2 +-
 doc/CHANGES                | 13 ++++++++++++-
 include/platform_defs.h.in |  6 +++---
 libxfs/trans.c             | 14 ++++++++++++++
 man/man8/xfs_quota.8       | 23 ++++++++++-------------
 tools/libxfs-apply         | 14 +++++++++++---
 9 files changed, 61 insertions(+), 25 deletions(-)


--sIeIPS3aXR5wroAkuut7uYuDw94EHEo4U--

--T2vKjf9uZYxxRGGEkMdsbpsqKjBJaCZGK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl/PrfwFAwAAAAAACgkQIK4WkuE93uCY
+w/9GrRAgRbtyKrsHgL7NIROJtneLpc4Bp3Ka8j18KgsbMrxXFHF5nwtWFpvZRJAfGNtkWMgS5SB
J5sp+QWYkIlCYf5Hfzo3iCj0FSRWqX/nmR1lbx8XaWf+SQ15e1vLddwtaxsICSBmDsSpz8RGDzyI
5Y6UrwajM0OjtvUnQEdk7aSGix4DQNZRYuZyAHxfZCVKMO6evDJB45QhKZBkBngAbHJFGgZA26oj
P/Ip9DJB9OT0gczbk9kSyAxYdaPo+sG5TSpt8Ok4I4gAMtovVkvn+Vvmk8g+SrRU+wZxMfddNBdE
TdffuH6Po4YoT//mkDi+mERwSsUoM0EPP7hZrLfyr44/YFHRzHV7numgnCt1SVx37c6LVBkzdZ81
t6150t+n6NTXXO1v57UODolMMaJu/htonNzbUjZB/NWIZcFFXNdto/IQM5TuauVWQJbpdmA9Ouvh
/ewpvEqcXL30uUjuvH8Zg4cW43MtJkyJtlYx3HeTiB35aaOzOrkITkQaflZcXyWTuHLsyC8pJgmP
lbV6ISkyqo7/jDVoTdJ2hFUVB8hYF/Fy/z4g274p5wlLDSEPMNujwq0b25ZvydlFkh9+0j1ZQwgX
Dxb6AbP1oDtoz2jCSz6Yt0B7xy1mymE5evO0YWBykbqrG1lDyvA2hWLE28vvSJ4pBj1fY9J6dZnc
VG8=
=M6QN
-----END PGP SIGNATURE-----

--T2vKjf9uZYxxRGGEkMdsbpsqKjBJaCZGK--
