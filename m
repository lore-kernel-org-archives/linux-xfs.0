Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1509C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Feb 2022 21:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245262AbiBKVAD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:00:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbiBKVAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Feb 2022 16:00:02 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3121AA5
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 12:59:57 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A56D114A1B;
        Fri, 11 Feb 2022 14:59:22 -0600 (CST)
Message-ID: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net>
Date:   Fri, 11 Feb 2022 14:59:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        L A Walsh <xfs@tlinx.org>
Subject: [ANNOUNCE] xfsdump 3.1.10 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------cdH00z1oKl7r1telw62jLdrN"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------cdH00z1oKl7r1telw62jLdrN
Content-Type: multipart/mixed; boundary="------------VZuWRv8hQzVMR0hnW0S1d7qZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Anthony Iliopoulos <ailiop@suse.com>,
 Gao Xiang <hsiangkao@linux.alibaba.com>, L A Walsh <xfs@tlinx.org>
Message-ID: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net>
Subject: [ANNOUNCE] xfsdump 3.1.10 released

--------------VZuWRv8hQzVMR0hnW0S1d7qZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

The new head of the master branch is commit:

3607469 (HEAD -> master, tag: v3.1.10, origin/master, origin/HEAD, korg/m=
aster) xfsdump: Release 3.1.10

I've deferred Darrick's patch to remove dmapi interfaces for now,
because I don't want to stall on getting the fix for the root inode
problems out there any longer. It's been ... quite long enough.

Next release we can think about the dmapi junk, and possibly the
workaround for the broken dumps with the root inode problem.

This should at least be generating valid dumps on those filesystems
with "interesting" geometry, again.

New Commits:

Anthony Iliopoulos (2):
      [15689d8] xfsdump: remove obsolete code for handling mountpoint ino=
des
      [f8c9cdc] xfsdump: remove obsolete code for handling xenix named pi=
pes

Eric Sandeen (3):
      [5f9f0ca] xfsdump: rename worker threads
      [25b42fb] xfsdump: don't try to generate .ltdep in inventory/
      [3607469] xfsdump: Release 3.1.10

Gao Xiang (2):
      [3b71c7f] xfsdump: Revert "xfsdump: handle bind mount targets"
      [0717c1c] xfsdump: intercept bind mount targets


Code Diffstat:

 VERSION                 |  2 +-
 common/drive.h          |  2 +-
 common/drive_minrmt.c   | 16 +++++------
 common/drive_scsitape.c | 16 +++++------
 common/main.c           |  8 +++---
 common/ring.c           | 58 ++++++++++++++++++-------------------
 common/ring.h           | 32 ++++++++++-----------
 common/stream.c         |  2 +-
 common/ts_mtio.h        |  2 +-
 configure.ac            |  2 +-
 debian/changelog        |  7 +++++
 doc/CHANGES             |  5 ++++
 doc/files.obj           |  2 +-
 doc/xfsdump.html        |  6 ++--
 dump/content.c          | 89 +++++++++++++++++++++++++++++++++++++++++--=
--------------
 dump/inomap.c           |  3 --
 inventory/Makefile      |  2 --
 restore/content.c       |  8 ------
 18 files changed, 149 insertions(+), 113 deletions(-)

--------------VZuWRv8hQzVMR0hnW0S1d7qZ--

--------------cdH00z1oKl7r1telw62jLdrN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmIGzksFAwAAAAAACgkQIK4WkuE93uDx
2g//ZPW+hsSP4SCqn67bCBrS+i53xEahx3iu5QQNHap5vYg9wer0aHTDhdTBcmWwjdgKUSyNEqme
YfcJ8rvOy1wYLhhwMv/sDc019pc681vUxVgeqnzT70AINALLfFAgOh8h8u9gfTPyN6zUvjOoxD6B
PTcSeJxB2I+oh1HQmc5nLBzvEXXXpfIF42p2teeR+EFDyPepwlqst7gGpo2khPOn5+czm4jvzHkJ
q3lCdJiGmarcM0nfe3M0tQd01WRSTBJwGh58hfAGNDQ/P0uRofl8F+Ty+B7W7geBOiihmg4GmWYB
TjXDTr3vCvtEjbK1puUYt6htgDB+2mdtuc3TZHi4Zlx/8ubRRrSubcTFsq2IP3eIt+lgJS/cgRCG
9pMq8J18DgWV4XJMJ3c5j1zTgqXK9u5qT+XhA1VNqxhTlpXdcBcKyvHhqiWBV67sOl7Rjm846Uwm
eOMhTQPsm5peTzzc0JKTFXSG/YrPVDYjy2KGR5OjIsZeREnHnGrnPzkFFM4zqLeuxfxeDzlRLKmF
SuTbyKY8132kZmQeVpw5NbgPHnVNJPvYqwsH280uNvQSjg0RT0RLrQxMNGWsUQIAUvTBCX/tVA/H
fonCQZ+Vkq0eYYN0RfNTuhkgJ0n3D4q1SQSDLUy+ILmglR9e/cbD6yWomTmKLqi4p6UwvHnBCeQF
epo=
=y/im
-----END PGP SIGNATURE-----

--------------cdH00z1oKl7r1telw62jLdrN--
