Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F62DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 20:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiEFUeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236122AbiEFUen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 16:34:43 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07D1D4CD56
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 13:30:54 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 537D27939;
        Fri,  6 May 2022 15:30:17 -0500 (CDT)
Message-ID: <995036a8-0624-3012-e97b-aeae2d7cc671@sandeen.net>
Date:   Fri, 6 May 2022 15:30:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.18.0-rc0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------MIvd0VaWM68gUi3pOs0mj0z4"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------MIvd0VaWM68gUi3pOs0mj0z4
Content-Type: multipart/mixed; boundary="------------tL5n8V0FWy7CK0iasIVAi2JD";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <995036a8-0624-3012-e97b-aeae2d7cc671@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.18.0-rc0 released

--------------tL5n8V0FWy7CK0iasIVAi2JD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.18.0-rc0

libxfs/ is now up to date with v5.18 kernelspace and I'll start merging
the functional changes, cleanups, and fixes that are on the list.

Thanks,
-Eric

The new head of the for-next branch is commit:

24025262 xfsprogs: Release v5.18.0-rc0

New Commits:

Christoph Hellwig (1):
      [8b4c5cd1] xfs: pass the mapping flags to xfs_bmbt_to_iomap

Darrick J. Wong (5):
      [e501cb44] xfs: remove the XFS_IOC_FSSETDM definitions
      [7126f90b] xfs: remove the XFS_IOC_{ALLOC,FREE}SP* definitions
      [c331b654] xfs: constify the name argument to various directory fun=
ctions
      [f040050e] xfs: constify xfs_name_dotdot
      [bc4d60eb] xfs: document the XFS_ALLOC_AGFL_RESERVE constant

Eric Sandeen (1):
      [24025262] xfsprogs: Release v5.18.0-rc0

Hugh Dickins (1):
      [dabdb383] mm/fs: delete PF_SWAPWRITE


Code Diffstat:

 VERSION                |  4 ++--
 configure.ac           |  2 +-
 doc/CHANGES            |  3 +++
 io/prealloc.c          | 11 +++++++++++
 libhandle/handle.c     | 21 +++------------------
 libxfs/libxfs_priv.h   |  4 ++--
 libxfs/xfs_alloc.c     | 28 +++++++++++++++++++++++-----
 libxfs/xfs_alloc.h     |  1 -
 libxfs/xfs_bmap.c      |  4 ++--
 libxfs/xfs_btree.c     |  2 +-
 libxfs/xfs_dir2.c      | 36 ++++++++++++++++++++----------------
 libxfs/xfs_dir2.h      |  8 ++++----
 libxfs/xfs_dir2_priv.h |  5 +++--
 libxfs/xfs_fs.h        | 37 ++++++++-----------------------------
 man/man3/xfsctl.3      |  2 ++
 man/man8/xfs_io.8      |  2 ++
 16 files changed, 87 insertions(+), 83 deletions(-)

--------------tL5n8V0FWy7CK0iasIVAi2JD--

--------------MIvd0VaWM68gUi3pOs0mj0z4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmJ1hXsFAwAAAAAACgkQIK4WkuE93uC0
Yg//SMFoCoGDZIxRwNnxKOiA7Kg2kn+hqk8y/R2A8g4hxcRhjpCyxKj0N9NHjyejDeSdlmqY+euH
w+bGwB8+oaXyv1pH95MLCt7LAQjTD0cR1/+7+5M6+xYD15/Vu69+tb4v1184GaEbvuO6iaMiW/rp
ojUqMxildiUij0yFASTk0vp+R6vL8+COgA6YZ4pcKBJdRUJAd87SDQCAZHnCUDqsQ/X7SaFPQhWE
qgDcuzGwnP9ciMpzVGS3BmLdqCuHGt6ZCFn1SHl22EPJsnvFh/8WPdXVkwBhdIyWk63dfcBe9RVj
QAD8T0MT2iDRQzPrlnTRWsbxjO5b3LjQn0vgKThTteLGuoGwlWHtQW9OpXtkQxVlgx3brZTDN3aD
Wpfua1qx5LGvzuvh4//gk5006G9F9qc30pMph/UU694us6JY5PgxvSVONcHJKB+n80GZpAcG2zwG
SU2GdVgs9LW9xUPBEVBeD/RLNAB//bdIitaJcVkt/ey4kk1vXe8H3o/yOt1mlAX9EgLQlctdYRup
BCvuo0iUbpYIsi1FLZpaWyzHl31yqgLEIDWH5/SeMOk4X+l8hh4miyw258JirN9TU8GUeZ2EL9w1
8RFSsvZW5LNn7y4W70hNJByfJ9bn/4DvA/N/U8Qas9AdUQ3Vc4eSD6C1Vujw/07agKUFlB6LkJ74
NYc=
=9ujt
-----END PGP SIGNATURE-----

--------------MIvd0VaWM68gUi3pOs0mj0z4--
