Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3ECC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58DBF60EBC
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhHBWKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:10:02 -0400
Received: from sandeen.net ([63.231.237.45]:57726 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhHBWJ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:09:58 -0400
Received: from [192.168.1.28] (unknown [137.118.193.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C53454433
        for <linux-xfs@vger.kernel.org>; Mon,  2 Aug 2021 17:08:14 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.13.0-rc1 released
To:     xfs <linux-xfs@vger.kernel.org>
Message-ID: <751421e5-705b-311a-dfa6-e0be700f49d4@sandeen.net>
Date:   Mon, 2 Aug 2021 15:09:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sYFQarhRGNU2UfuA4eQNQgKyeNrSLtPyG"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sYFQarhRGNU2UfuA4eQNQgKyeNrSLtPyG
Content-Type: multipart/mixed; boundary="btpSuAurKupvRG8ITclVv563HBr56ADWE";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <751421e5-705b-311a-dfa6-e0be700f49d4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.13.0-rc1 released

--btpSuAurKupvRG8ITclVv563HBr56ADWE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.13.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

102c0a9f xfsprogs: Release v5.13.0-rc1

New Commits:

Darrick J. Wong (9):
      [ce61e74a] xfs_io: fix broken funshare_cmd usage
      [d87ec7f2] xfs_io: clean up the funshare command a bit
      [e264ca71] xfs_io: only print the header once when dumping fsmap in=
 csv format
      [5c0da2c0] xfs_io: don't count fsmaps before querying fsmaps
      [5f062427] xfs_repair: validate alignment of inherited rt extent hi=
nts
      [1e8afffb] mkfs: validate rt extent size hint when rtinherit is set=

      [4130bb62] xfs_io: allow callers to dump fs stats individually
      [f1ea06d0] xfs_repair: invalidate dirhash entry when junking dirent=

      [610ec295] xfs_quota: allow users to truncate group and project quo=
ta files

Eric Sandeen (1):
      [102c0a9f] xfsprogs: Release v5.13.0-rc1


Code Diffstat:

 VERSION           |   2 +-
 configure.ac      |   2 +-
 doc/CHANGES       |  13 ++++-
 io/fsmap.c        |  33 +------------
 io/prealloc.c     |  33 ++++++++-----
 io/stat.c         | 140 +++++++++++++++++++++++++++++++++++++++---------=
------
 man/man8/xfs_io.8 |  26 ++++++++--
 mkfs/xfs_mkfs.c   |   7 +--
 quota/state.c     |   3 +-
 repair/dinode.c   |  71 +++++++++++++++++++--------
 repair/phase6.c   |  18 +++++++
 11 files changed, 235 insertions(+), 113 deletions(-)


--btpSuAurKupvRG8ITclVv563HBr56ADWE--

--sYFQarhRGNU2UfuA4eQNQgKyeNrSLtPyG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmEIbSkFAwAAAAAACgkQIK4WkuE93uBS
dBAAn/PmEjvwPYyHyQXJmygP00Nl/X/yRFaJGJK42myhvDVMfa6qLfAbl2JEM84BnkzU7m6sXwDn
2yq8oFpBUCp64JJSf7/c3PYbjSrqyNI/Qqtk7osWdhZ+hk1E4Eiil3skYhLrk5u3f9PXuObgp7DN
C06PD9cHm+iVWz2ZKxMewTAiMWG2kSzeBi4Fn30weZUapUUlEEBOH+f2ltHR9Hp1buFWHP9BOfaP
AIzvQjwIVyvY4W7dhZrJH4FRs7r5nzi7NnX8/fZPWu98KXTWnLZCGRzg4pITus7WZMkVYvQpOQ6f
x0+/2u3DFB/051AC1psb03xSpqyHFfoNHAHtOXqEHnXIFbsfw/A3mI/aXNCliU5fk8EbSQPFn5Rt
Jkss5UC2Jph0egYDH0J3wabVBG/Ch23b2b3J2AsnTv1VPqSKgQaosJ3FWB7uUXOitr+gbT4hOp7/
iEcz8O1j3kLKKLxHxC6u/hFPIrArhwjWOWD4TSUJRJ7jDddaGmcb5UcSbtpKesF5cUpyWN6BMV71
huGHzyXLE+bzigwoxNfEikpeXnejqCTfomdlAIHgkrqvwD8rByYNR37Dd29YD29PK7v60q7Xm1nR
OAxvbq2Jy1g8E1++LW+dWPp/7ApqX0WT51WGljfAZ7PO4DXATdyUJz0CXVIzpYsJj+pA5I/w2Vx0
Jrk=
=VtTw
-----END PGP SIGNATURE-----

--sYFQarhRGNU2UfuA4eQNQgKyeNrSLtPyG--
