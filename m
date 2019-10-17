Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E930ECE58E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 14:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E663421A4C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 14:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437956AbfJQOko (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 10:40:44 -0400
Received: from sandeen.net ([63.231.237.45]:39320 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437444AbfJQOko (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 10:40:44 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CD4882B37
        for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2019 09:40:03 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to cac2b8b0
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4047ad34-5967-3b1c-8555-29427de3ee58@sandeen.net>
Date:   Thu, 17 Oct 2019 09:40:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oJmSX8l5FaYIPUlb57hzkcpkiu6xdNOdS"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oJmSX8l5FaYIPUlb57hzkcpkiu6xdNOdS
Content-Type: multipart/mixed; boundary="aTXL9PhYaKWv5lqeSu8KOglBaG7vRGzvb"

--aTXL9PhYaKWv5lqeSu8KOglBaG7vRGzvb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

cac2b8b0 (HEAD -> for-next, origin/for-next, korg/for-next) xfs_scrub: si=
mulate errors in the read-verify phase

New Commits:

Darrick J. Wong (24):
      [9d57cbfc] libfrog: fix workqueue error communication problems
      [bfd9b38b] libfrog: fix missing error checking in workqueue code
      [71296cf8] libfrog: split workqueue destroy functions
      [7668d01d] xfs_scrub: redistribute read verify pool flush and destr=
oy responsibilities
      [cb321a39] libfrog: fix per-thread variable error communication pro=
blems
      [336c4824] libfrog: add missing per-thread variable error handling
      [233fabee] libfrog: fix bitmap error communication problems
      [d504cf0b] libfrog: fix missing error checking in bitmap code
      [da3dd6c0] xfs_scrub: fix per-thread counter error communication pr=
oblems
      [0a9ac205] xfs_scrub: report all progressbar creation failures
      [8808a003] xfs_scrub: check progress bar timedwait failures
      [f0bbbd72] xfs_scrub: move all the queue_subdir error reporting to =
callers
      [499c104f] xfs_scrub: fix error handling problems in vfs.c
      [5c657f1e] xfs_scrub: fix handling of read-verify pool runtime erro=
rs
      [4cd869e5] xfs_scrub: abort all read verification work immediately =
on error
      [8cab77d3] xfs_scrub: fix read-verify pool error communication prob=
lems
      [601ebcd8] xfs_scrub: fix queue-and-stash of non-contiguous verify =
requests
      [22d658ec] xfs_scrub: only call read_verify_force_io once per pool
      [15589f0a] xfs_scrub: refactor inode prefix rendering code
      [20e10ad4] xfs_scrub: record disk LBA size
      [29c4f385] xfs_scrub: enforce read verify pool minimum io size
      [323ef14c] xfs_scrub: return bytes verified from a SCSI VERIFY comm=
and
      [27464242] xfs_scrub: fix read verify disk error handling strategy
      [cac2b8b0] xfs_scrub: simulate errors in the read-verify phase


Code Diffstat:

 libfrog/bitmap.c    |  26 ++++--
 libfrog/bitmap.h    |   2 +-
 libfrog/ptvar.c     |  43 +++++++---
 libfrog/ptvar.h     |   8 +-
 libfrog/workqueue.c |  73 ++++++++++++++---
 libfrog/workqueue.h |   2 +
 repair/rmap.c       |   4 +-
 repair/threads.c    |   6 ++
 scrub/common.c      |  35 ++++++++
 scrub/common.h      |   4 +
 scrub/counter.c     |  44 +++++-----
 scrub/counter.h     |   6 +-
 scrub/disk.c        |  78 ++++++++++++++++--
 scrub/disk.h        |   3 +-
 scrub/fscounters.c  |  16 +++-
 scrub/inodes.c      |  14 ++--
 scrub/phase2.c      |  13 +--
 scrub/phase3.c      |  31 ++++---
 scrub/phase4.c      |  12 ++-
 scrub/phase5.c      |   8 +-
 scrub/phase6.c      | 126 ++++++++++++++++++----------
 scrub/phase7.c      |  24 ++++--
 scrub/progress.c    |  20 +++--
 scrub/read_verify.c | 232 +++++++++++++++++++++++++++++++++++++++-------=
------
 scrub/read_verify.h |  17 ++--
 scrub/scrub.c       |  17 ++--
 scrub/spacemap.c    |  16 ++--
 scrub/vfs.c         |  62 +++++++++-----
 scrub/xfs_scrub.c   |   2 +
 29 files changed, 681 insertions(+), 263 deletions(-)


--aTXL9PhYaKWv5lqeSu8KOglBaG7vRGzvb--

--oJmSX8l5FaYIPUlb57hzkcpkiu6xdNOdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl2ofWoACgkQIK4WkuE9
3uAXpRAAvOOjnEUshDw+SPGKpODAuUhG9uexhzmiAkQWuAa3+psMCp4V8Eg+zVLi
857cVn871mKwG0yGtfw2Pj04rObBcoAMTajxPN70WFer+yw7ztJbrCG3eQAGzsst
Trs7+YUGRFwRbgcxSJ7b4vyneNPn/MF+0z1tGmLyBACQhk07nLjVDQqS70RWJvyO
SvQeqq8zkKlC5bD6NmeDBCWlI2tOgEJm1u55RVtnZh5D7NisbW/jJ7AS9BO5WuKP
rPIkXiBFlUHdRrV1HcV0FsUlDziltO4OqfJkA3MieIqp5ZFYlOAoup2VkHZPW8sr
81hVY7SbbF2u4yvRp7yVV8gX1ecLl2bIWNxSA+RzK+MmR8A5TVSR5axlD117lY2P
1QdrXvxbIB6Gfdf82d9qY3FpHKD1wmKKIPOqgCjK+2/zO/Y89wTWKH8ftpW+ybrP
e1/7lyN7TgP1mxnHW8Zblp2TlMNXMuifNRXXHXGY25ew2aJ9kWoNzIiQ9JmsU6dU
4V3p5gjR4JRWkCOIYVVQbJZy1/sDD/pixQHWGeuUVhhYJnI6nAKhooeeGnTORPXe
wL9CoIyhO3D9wgrnMSNDFWUcyHMhm5k0i+JbMHy9yE09DKPDqGLiGjXc3fmMZ+pU
zyg5QDNqeUwPHl+e7d85OprcNv7Fl8KEh6C4S4KO+gtwrGPzokQ=
=fXUE
-----END PGP SIGNATURE-----

--oJmSX8l5FaYIPUlb57hzkcpkiu6xdNOdS--
