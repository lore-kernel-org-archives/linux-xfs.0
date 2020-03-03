Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C9AC3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 01:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A5C121D56
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 01:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCCBoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 20:44:18 -0500
Received: from sandeen.net ([63.231.237.45]:59262 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCCBoR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Mar 2020 20:44:17 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D1D232A77
        for <linux-xfs@vger.kernel.org>; Mon,  2 Mar 2020 19:43:43 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to fbbb184b / v5.5.0-rc1
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <0c5fba67-f406-5265-50b2-ed2eaf7597fb@sandeen.net>
Date:   Mon, 2 Mar 2020 19:44:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="exuKnOUP7ybmhwjpiXv3vkgA5jDMZngPy"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--exuKnOUP7ybmhwjpiXv3vkgA5jDMZngPy
Content-Type: multipart/mixed; boundary="nrkMne7RDsijwbzQotRILJ7fsmkgVuLic"

--nrkMne7RDsijwbzQotRILJ7fsmkgVuLic
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as v5.5.0-rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

caf45d56 (HEAD -> guilt/for-next, tag: v5.5.0-rc1, korg/for-next, refs/pa=
tches/for-next/xfsprogs__release_v5.5.0-rc1.patch) xfsprogs: Release v5.5=
=2E0-rc1

New Commits:

Darrick J. Wong (33):
      [d73b61f9] libxfs: libxfs_buf_delwri_submit should write buffers im=
mediately
      [9a54569a] libxfs: complain when write IOs fail
      [a688242b] libxfs: return flush failures
      [c335b673] libxfs: flush all dirty buffers and report errors when u=
nmounting filesystem
      [10fc0759] mkfs: check that metadata updates have been committed
      [14fb3613] xfs_repair: check that metadata updates have been commit=
ted
      [7c8e6ac7] libfrog: always fsync when flushing a device
      [d855bce8] libxfs: open-code "exit on buffer read failure" in upper=
 level callers
      [ac7ad9aa] libxfs: remove LIBXFS_EXIT_ON_FAILURE
      [b98336dd] libxfs: remove LIBXFS_B_EXIT
      [e02ba985] libxfs: replace libxfs_putbuf with libxfs_buf_relse
      [8b4de37c] libxfs: replace libxfs_getbuf with libxfs_buf_get
      [361379e0] libxfs: replace libxfs_readbuf with libxfs_buf_read
      [331d5956] libxfs: rename libxfs_writebufr to libxfs_bwrite
      [456371d8] libxfs: make libxfs_readbuf_verify return an error code
      [e214b18a] libxfs: make libxfs_readbufr stash the error value in b_=
error
      [3f8a028e] libxfs: introduce libxfs_buf_read_uncached
      [a0846242] xfs_db: use uncached buffer reads to get the superblock
      [745b7e18] xfs_copy: use uncached buffer reads to get the superbloc=
k
      [c92c796e] libxfs: move log functions for convenience
      [de319479] libxfs: convert libxfs_log_clear to use uncached buffers=

      [66ab87d3] libxlog: use uncached buffers instead of open-coding the=
m
      [09468119] libxfs: use uncached buffers for initial mkfs writes
      [18b4f688] libxfs: straighten out libxfs_writebuf naming confusion
      [f524ae04] libxfs: remove unused flags parameter to libxfs_buf_mark=
_dirty
      [e8bef598] libxfs: remove libxfs_writebuf_int
      [e7e49100] libxfs: remove dangerous casting between xfs_buf and cac=
he_node
      [063516bb] libxfs: remove dangerous casting between cache_node and =
xfs_buf
      [1a12e432] libxfs: remove the libxfs_{get,put}bufr APIs
      [b45650ab] libxfs: hide libxfs_getbuf_flags
      [8288ea3d] libxfs: rename libxfs_readbuf_map to libxfs_buf_read_map=

      [f315ae4f] libxfs: rename libxfs_getbuf_map to libxfs_buf_get_map
      [af60a998] libxfs: convert buffer priority get/set macros to functi=
ons

Eric Biggers (1):
      [dfe209d8] xfs_io/encrypt: support passing a keyring key to add_enc=
key

Eric Sandeen (2):
      [5896e59e] xfs_admin: revert online label setting ability
      [caf45d56] xfsprogs: Release v5.5.0-rc1


Code Diffstat:

 VERSION                   |   2 +-
 configure.ac              |   3 +-
 copy/xfs_copy.c           |  19 +-
 db/fsmap.c                |   6 +-
 db/info.c                 |   2 +-
 db/init.c                 |  11 +-
 db/io.c                   |  10 +-
 db/xfs_admin.sh           |  42 +--
 debian/changelog          |   6 +
 doc/CHANGES               |  20 ++
 include/builddefs.in      |   4 +
 include/cache.h           |   2 +-
 include/libxfs.h          |   1 -
 include/libxlog.h         |   1 -
 include/xfs_mount.h       |   2 +-
 io/encrypt.c              |  90 +++--
 libfrog/linux.c           |  31 +-
 libfrog/platform.h        |   2 +-
 libxfs/init.c             | 150 ++++++--
 libxfs/libxfs_api_defs.h  |   6 +
 libxfs/libxfs_io.h        | 131 +++----
 libxfs/libxfs_priv.h      |   3 -
 libxfs/rdwr.c             | 888 +++++++++++++++++++++++++---------------=
------
 libxfs/trans.c            |  23 +-
 libxlog/xfs_log_recover.c |  35 +-
 logprint/log_print_all.c  |   2 +-
 m4/package_libcdev.m4     |  21 ++
 man/man8/xfs_admin.8      |   4 +-
 man/man8/xfs_io.8         |  10 +-
 mkfs/proto.c              |   6 +-
 mkfs/xfs_mkfs.c           |  98 +++--
 repair/attr_repair.c      |  43 +--
 repair/da_util.c          |  36 +-
 repair/dino_chunks.c      |  18 +-
 repair/dinode.c           |  26 +-
 repair/dir2.c             |  23 +-
 repair/phase3.c           |  10 +-
 repair/phase5.c           |  72 ++--
 repair/phase6.c           |  36 +-
 repair/prefetch.c         |  42 +--
 repair/rmap.c             |  11 +-
 repair/rt.c               |   8 +-
 repair/scan.c             |  51 +--
 repair/xfs_repair.c       |  14 +-
 44 files changed, 1176 insertions(+), 845 deletions(-)


--nrkMne7RDsijwbzQotRILJ7fsmkgVuLic--

--exuKnOUP7ybmhwjpiXv3vkgA5jDMZngPy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl5dtm8ACgkQIK4WkuE9
3uDhnA//XU6DRG+p8zbTyJfJK8T2qdfLjIID4x0XAw37Ap5ElbqZH1UOAbm1GLmL
rXFK5lkllipTQnFQwq1qrvYOWQhmFAYVJZ22AWir5wx/TEu+YxSNDLq0d10MN5GX
Qa2i0BWdu8OT8OW/ZrTgGS1WLfeuyXMot5sTR0gdGYWCucdU0mNE+THWy3kKJO7W
BDIyca9FvziofsYRnozHQ4WsQrfOwnkx59mMu1n8sVO2NHgxqBUKdlWtEhs4rYfj
35oJG6njpMkmcUHt21d+F/Yt6jT82Z+0HNXMvzraZO8QnG/+Up5GSpFKlHP34BIR
1dSHFQ54I8cPP4QgAm20iSYNdYke7i9pQRtAMjIFEPMU46WcwavVOUhX3GbPQ8XI
a7OcIPBu9gYBxtAMN8hp8wsV/lRZZKDvt23GGePdNxGnn+oRnVDPeJuTn3lG8Pos
AeEwmj7PdR5pvnBBYVK6f0cZQArbK7vBSoiGFWNJdSE9mlAEVi71tOh60yk8MGNZ
i57B1mY7FpvTfcV4yqeAqA0slO/qrR+5t2ZEAzLN7gJgRkRTM0MCLx1uhSUtQmXE
47eYNYOvJdVoWzKi0im+3cu1cuO+ViVMwZTIkaxJsyS8rCKQi66GxLFHvNh1WWKl
A9+sXV3Jbw71VpfH/JjDd3MdTDw/WGpddjf9jB6e4/rsg3hcQvE=
=C0Ix
-----END PGP SIGNATURE-----

--exuKnOUP7ybmhwjpiXv3vkgA5jDMZngPy--
