Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1437C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 16:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9930121D7B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 16:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfKGQyE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 11:54:04 -0500
Received: from sandeen.net ([63.231.237.45]:52632 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbfKGQyD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 11:54:03 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 50F881911C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 10:52:53 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to baed134d
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <203f0936-eeda-7a5e-936f-9e8f006677e1@sandeen.net>
Date:   Thu, 7 Nov 2019 10:54:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="E2sNoCGfip7cdm0G1ak1DbFvevxgwNbFV"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E2sNoCGfip7cdm0G1ak1DbFvevxgwNbFV
Content-Type: multipart/mixed; boundary="VgeV0x3nYYQXO9qYljFiGmktYtZf5ezDk"

--VgeV0x3nYYQXO9qYljFiGmktYtZf5ezDk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

I expect to tag this as -rc2 soon and finally release 5.3.0 shortly
after.

If you're missing anything that you want in 5.3.0, please get my
attention in the next day or two.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

baed134d (HEAD -> for-next, origin/for-next, korg/for-next) libfrog: conv=
ert workqueue.c functions to negative error codes

New Commits:

Amir Goldstein (1):
      [89f0bc44] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag

Darrick J. Wong (29):
      [51c94053] xfs_scrub: bump work_threads to include the controller t=
hread
      [b3f76f94] xfs_scrub: implement deferred description string renderi=
ng
      [a3158a75] xfs_scrub: adapt phase5 to deferred descriptions
      [16dbab1a] xfs_scrub: implement background mode for phase 6
      [73ce9669] xfs_scrub: remove moveon from filemap iteration
      [934d8d3a] xfs_scrub: remove moveon from the fscounters functions
      [59f79e0a] xfs_scrub: remove moveon from inode iteration
      [f544ec31] xfs_scrub: remove moveon from vfs directory tree iterati=
on
      [7a2eef2b] xfs_scrub: remove moveon from spacemap
      [ac1c1f8e] xfs_scrub: remove moveon from unicode name collision hel=
pers
      [d86e83b8] xfs_scrub: remove moveon from progress report helpers
      [d22f2471] xfs_scrub: remove moveon from scrub ioctl wrappers
      [83d2c80b] xfs_scrub: remove moveon from repair action list helpers=

      [0d96df9d] xfs_scrub: remove moveon from phase 7 functions
      [af9eb208] xfs_scrub: remove moveon from phase 6 functions
      [8142c597] xfs_scrub: remove moveon from phase 5 functions
      [596a30ba] xfs_scrub: remove moveon from phase 4 functions
      [df024103] xfs_scrub: remove moveon from phase 3 functions
      [f29dc2f5] xfs_scrub: remove moveon from phase 2 functions
      [35b65bcf] xfs_scrub: remove moveon from phase 1 functions
      [b8e62724] xfs_scrub: remove XFS_ITERATE_INODES_ABORT from inode it=
erator
      [64dabc9f] xfs_scrub: remove moveon from main program
      [9fc3ef62] libfrog: print library errors
      [93d69bc7] libfrog: convert bitmap.c to negative error codes
      [03d96c64] libfrog: convert fsgeom.c functions to negative error co=
des
      [e6542132] libfrog: convert bulkstat.c functions to negative error =
codes
      [2f4422f4] libfrog: convert ptvar.c functions to negative error cod=
es
      [de5d20ec] libfrog: convert scrub.c functions to negative error cod=
es
      [baed134d] libfrog: convert workqueue.c functions to negative error=
 codes


Code Diffstat:

 fsr/xfs_fsr.c       |  22 +--
 growfs/xfs_growfs.c |   4 +-
 io/attr.c           |   4 +-
 io/bmap.c           |   2 +-
 io/bulkstat.c       |  43 +++---
 io/fsmap.c          |   4 +-
 io/imap.c           |  12 +-
 io/open.c           |  36 +++--
 io/stat.c           |   6 +-
 io/swapext.c        |  11 +-
 libfrog/Makefile    |   2 +
 libfrog/bitmap.c    |  27 ++--
 libfrog/bulkstat.c  |  80 +++++------
 libfrog/bulkstat.h  |   8 +-
 libfrog/fsgeom.c    |  18 +--
 libfrog/logging.c   |  18 +++
 libfrog/logging.h   |  11 ++
 libfrog/ptvar.c     |   8 +-
 libfrog/scrub.c     |   9 +-
 libfrog/workqueue.c |  25 ++--
 quota/free.c        |   6 +-
 quota/quot.c        |  20 ++-
 repair/rmap.c       |   4 +-
 repair/threads.c    |   6 +-
 repair/xfs_repair.c |   2 +-
 rtcp/xfs_rtcp.c     |   2 +-
 scrub/Makefile      |   2 +
 scrub/counter.c     |   6 +-
 scrub/descr.c       | 106 +++++++++++++++
 scrub/descr.h       |  29 ++++
 scrub/filemap.c     |  73 ++++------
 scrub/filemap.h     |  16 +--
 scrub/fscounters.c  | 135 ++++++++-----------
 scrub/fscounters.h  |   4 +-
 scrub/inodes.c      | 146 +++++++++-----------
 scrub/inodes.h      |  11 +-
 scrub/phase1.c      |  55 ++++----
 scrub/phase2.c      | 119 +++++++++--------
 scrub/phase3.c      | 119 +++++++++--------
 scrub/phase4.c      |  99 +++++++-------
 scrub/phase5.c      | 251 ++++++++++++++++++++++-------------
 scrub/phase6.c      | 274 +++++++++++++++++++-------------------
 scrub/phase7.c      |  75 ++++++-----
 scrub/progress.c    |  13 +-
 scrub/progress.h    |   2 +-
 scrub/read_verify.c |  35 +++--
 scrub/repair.c      |  85 ++++++------
 scrub/repair.h      |  32 +++--
 scrub/scrub.c       | 375 +++++++++++++++++++++++++++-------------------=
------
 scrub/scrub.h       |  49 ++++---
 scrub/spacemap.c    | 149 +++++++++++----------
 scrub/spacemap.h    |  12 +-
 scrub/unicrash.c    |  95 +++++++------
 scrub/unicrash.h    |  24 ++--
 scrub/vfs.c         |  58 ++++----
 scrub/vfs.h         |  14 +-
 scrub/xfs_scrub.c   | 108 ++++++++-------
 scrub/xfs_scrub.h   |  39 +++---
 spaceman/file.c     |   9 +-
 spaceman/health.c   |  25 ++--
 60 files changed, 1638 insertions(+), 1396 deletions(-)
 create mode 100644 libfrog/logging.c
 create mode 100644 libfrog/logging.h
 create mode 100644 scrub/descr.c
 create mode 100644 scrub/descr.h


--VgeV0x3nYYQXO9qYljFiGmktYtZf5ezDk--

--E2sNoCGfip7cdm0G1ak1DbFvevxgwNbFV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl3ETCkACgkQIK4WkuE9
3uCcZxAAjM1Spstb9Fq92ypsZ2GiKLEe4cNd7cnI7CiFJf70X6drdtrZItAn8tA+
R/hMN0FysAIp/gcwOaP9FTm7ASFq70w7m6z5xaq1+kF50/cJAMJXsJG5XAl5RnPz
mcugoephl+ZZmdBfvuyOSUcBoYY74T7gYrtJUVzAwrIVNQ8yPs8t2tUt5UebV8OX
PWP1TBWQ6NtAl1C5pJGw0NxCZFKgGgY+NXGrD6JBmemIijd7nVWk7PPw7tKTZAcv
v/G0Izh2m0jJDCQQ/kSy1j0QRAHrclyEmKWIMwdsRb7IGRtQQU4wakKijNyRK3XF
Md+8OHkdhfAvwXZBFrf1q+7BWmnvtOovVhvOn6JM22b3TQIrWFnZ64FR4Am1b2iT
bBM6jQiYXkLVm9901y55lXDHbx5nj2VD3tXhXo1HiZFaEiT60S/DzXCo/KGIhtqE
oM4UMlWPNpY1i6TcDiamaSXxOFaNVJkFUEtCF/I2ohnrIeVlHCGUgfSigxxU5Wp8
w4E+Zw231lu+0B/3K3c4O6ir4MyKKeGi//8isQZMJoX+/UwmANw0NMfoRcqy01A/
Cid8B928ji1GnB5xWXtyvUNdcSC6oicWhWdaWxT7XHRPAzluHg+pqW31MNFRJJv5
ryKIoRRATsunpG4C6VUvnuBCTxBSgjzZTzQUEch2CFr7Nnt1qy4=
=iQXC
-----END PGP SIGNATURE-----

--E2sNoCGfip7cdm0G1ak1DbFvevxgwNbFV--
