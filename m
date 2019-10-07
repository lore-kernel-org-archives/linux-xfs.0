Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C679AECE58C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 19:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B8322133F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 19:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfJGTQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 15:16:20 -0400
Received: from sandeen.net ([63.231.237.45]:52048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGTQT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 15:16:19 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 095EA78D7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 14:15:53 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 6040b5d5
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <a4d1721d-4f60-1dfb-e09c-b7c42e35baa3@sandeen.net>
Date:   Mon, 7 Oct 2019 14:16:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UBuCIoQ5Ldzue6QXLNE3iaMhGsQMusn4s"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UBuCIoQ5Ldzue6QXLNE3iaMhGsQMusn4s
Content-Type: multipart/mixed; boundary="CA094xVYsrRmUlwhSXlZMizUXQcbGlcCh";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <a4d1721d-4f60-1dfb-e09c-b7c42e35baa3@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 6040b5d5

--CA094xVYsrRmUlwhSXlZMizUXQcbGlcCh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Still working through Darrick's patchbomb.  Other than that:

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

6040b5d5 (HEAD -> for-next, korg/for-next, refs/patches/for-next/xfs_scru=
b__batch_inumbers_calls_during_fscounters_calculation-1.patch) xfs_scrub:=
 batch inumbers calls during fscounters calculation

New Commits:

Darrick J. Wong (4):
      [3c8276c4] xfs_io: add a bulkstat command
      [1ff6be86] xfs_spaceman: remove open-coded per-ag bulkstat
      [23ea9841] xfs_scrub: convert to per-ag inode bulkstat operations
      [6040b5d5] xfs_scrub: batch inumbers calls during fscounters calcul=
ation

Eric Biggers (9):
      [f007179d] xfs_io/encrypt: remove unimplemented encryption modes
      [336e7c19] xfs_io/encrypt: update to UAPI definitions from Linux v5=
=2E4
      [eb6c66e6] xfs_io/encrypt: generate encryption modes for 'help set_=
encpolicy'
      [7cde2c28] xfs_io/encrypt: add new encryption modes
      [c304c84f] xfs_io/encrypt: extend 'get_encpolicy' to support v2 pol=
icies
      [a7a5e44c] xfs_io/encrypt: extend 'set_encpolicy' to support v2 pol=
icies
      [ba71de04] xfs_io/encrypt: add 'add_enckey' command
      [c808a097] xfs_io/encrypt: add 'rm_enckey' command
      [dafb55f9] xfs_io/encrypt: add 'enckey_status' command


Code Diffstat:

 io/Makefile        |   9 +-
 io/bulkstat.c      | 518 ++++++++++++++++++++++++++++++++++
 io/encrypt.c       | 816 ++++++++++++++++++++++++++++++++++++++++++++++-=
------
 io/init.c          |   1 +
 io/io.h            |   1 +
 libfrog/bulkstat.c |  20 ++
 libfrog/bulkstat.h |   3 +
 man/man8/xfs_io.8  | 155 +++++++++-
 scrub/fscounters.c |  26 +-
 scrub/inodes.c     |  20 +-
 spaceman/health.c  |  16 +-
 11 files changed, 1424 insertions(+), 161 deletions(-)
 create mode 100644 io/bulkstat.c


--CA094xVYsrRmUlwhSXlZMizUXQcbGlcCh--

--UBuCIoQ5Ldzue6QXLNE3iaMhGsQMusn4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl2bjwEACgkQIK4WkuE9
3uDBEhAAs907usLge6gIDGadg1K5jAG8hgrGHdKfIZaFNlQTQW53HJacTv/wyYr3
ZKK2o1+vixHVpHkn9X17bCZXWyGKLgS8nKs/zLzyveXMxC4PB1sRAnVF1ghSojNs
iDJMHDLrbAR2piNABnm94B1UoV0Fu1n+t5rCgPydXNnRJiq6TRa9R5qtz305uE8A
Q8rjQc1h7h9N1Wb8rilYoUqGletUERZs2glC1+HOV1PtoAvlwlrt6UZ6zgwn9DvT
nJAm4uBIQx6mD9HmrYoQoTOiJe/k4JT3pkThrbjJ3znvjjVUgHx0vN7xSDN4GESi
+oz5HrSasr7XlLTOG8Qo1TWFmZ3kqfdYRLApgL3mHoK+0WIaq5guuIauzyoGPVgn
CP5eTEPrp7y0s7JkKvknYdTQoqMoR9I89OjAEfz4gU2z9PMlTL2p7bNHArSTX+3t
+Bf+jB63sCacFWuJEoCMBVgpsoPnjaI0ua7a6jfeIwrpKh0lgI2Lv9AhNYoIkMFV
tgT3DGTmzVRGUJgSeeyWx/k2eLOFkrH+T4KtsOjJstcTl+3vMuRs09w0TYcXSzHp
gEBr0GSov6KWgAn2QRe4UinB10SIxjhmPZdODbbQPmsjX+h6vvmD4SsCtjcl3Ib1
WKfloBmaNt5yF4Z8lkc1hZmA+aAPGtgEu5uWKREq7cJG644Sy/0=
=gGRi
-----END PGP SIGNATURE-----

--UBuCIoQ5Ldzue6QXLNE3iaMhGsQMusn4s--
