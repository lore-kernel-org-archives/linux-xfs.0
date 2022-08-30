Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB4CECAAD4
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 11:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiH3Lw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiH3Lw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 07:52:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562D98D39
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 04:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6AC9B81625
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 11:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44C8C433D7
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 11:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661860344;
        bh=rribF6Ysj+pymXte2qowh5/bhshC9mA8eBJwlAM0r1A=;
        h=Date:From:To:Subject:From;
        b=js5iK3FEhcnPHTpeDkKKU87rercGq2VWMbIualKE9Pq0qEUg4qpK7ryVv2eRIK+KH
         TnHJ7ume2+eh/VXuoUE1PTb1UCJeH2U+2M+4JEWMZ8fy4d0psc1YecpJ2c6xBjufih
         /jVAOjkpWf9uM+PgyoK4k/IfZuPBAuT3XFDTrdRIZe37f8U6zcJTgJqLFRIA0JX28r
         U/ECgZLRWaMiuC7w8ra/nZtoU9hJvQ8pLshXZyM59w9fuBXk8EhVocZIodU4hrynjd
         4d0uc0ckgn2ml//2/67hyKL16q8wntAHo1haBcmf8wZGPVnCx4wKdco0y2TrSkRwqj
         BqCIUNfJxaB4Q==
Date:   Tue, 30 Aug 2022 13:52:20 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <20220830115220.5s2nlztp56fbf4xa@andromeda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iayq7gzlfnfd2cvn"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--iayq7gzlfnfd2cvn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This update contains the initial libxfs sync to Linux 6.0 and should be tur=
ned
into -rc0 once it (hopefully) gets some testing (and no complains) for more=
 people.

Please, if any questions, let me know.


The new head of the for-next branch is commit:

d3e53ab7c xfs: fix inode reservation space for removing transaction


New Commits:

Andrey Strachuk (1):
      [798d43495] xfs: removed useless condition in function xfs_attr_node_=
get

Dan Carpenter (1):
      [17df7eb7e] xfs: delete unnecessary NULL checks

Darrick J. Wong (6):
      [722e81c12] xfs: convert XFS_IFORK_PTR to a static inline helper
      [7ff5f1edf] xfs: make inode attribute forks a permanent part of struc=
t xfs_inode
      [d4292c669] xfs: use XFS_IFORK_Q to determine the presence of an xatt=
r fork
      [4f8415858] xfs: replace XFS_IFORK_Q with a proper predicate function
      [eae3e30d4] xfs: replace inode fork size macros with functions
      [e373f06a3] xfs: don't leak memory when attr fork loading fails

Dave Chinner (17):
      [ef78f876e] xfs: make last AG grow/shrink perag centric
      [37dc5890e] xfs: kill xfs_ialloc_pagi_init()
      [4330a9e00] xfs: pass perag to xfs_ialloc_read_agi()
      [87db57baf] xfs: kill xfs_alloc_pagf_init()
      [f9084bd95] xfs: pass perag to xfs_alloc_read_agf()
      [bc87af992] xfs: pass perag to xfs_read_agi
      [c1030eda4] xfs: pass perag to xfs_read_agf
      [1d202c10b] xfs: pass perag to xfs_alloc_get_freelist
      [9a73333d9] xfs: pass perag to xfs_alloc_put_freelist
      [75c01cccf] xfs: pass perag to xfs_alloc_read_agfl
      [83af0d13a] xfs: Pre-calculate per-AG agbno geometry
      [8aa34dc9b] xfs: Pre-calculate per-AG agino geometry
      [cee2d89ae] xfs: replace xfs_ag_block_count() with perag accesses
      [54f6b9e5e] xfs: make is_log_ag() a first class helper
      [0b2f4162b] xfs: rework xfs_buf_incore() API
      [69535dadf] xfs: track the iunlink list pointer in the xfs_inode
      [b9846dc9e] xfs: double link the unlinked inode list

Slark Xiao (1):
      [e4a32219d] xfs: Fix typo 'the the' in comment

Xiaole He (1):
      [ec36ecd2d] xfs: fix comment for start time value of inode with bigti=
me enabled

hexiaole (1):
      [d3e53ab7c] xfs: fix inode reservation space for removing transaction

--=20
Carlos Maiolino

--iayq7gzlfnfd2cvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT6QG4gav94c4l8aGS0VhjDaiT9IwUCYw358wAKCRC0VhjDaiT9
I86BAP9duIY+FQVZG7gH4nS1pDHkDBGSd0ucEe+K4n9FXM8sPQD/RbznO/1XDxn6
VUya0XGw0QO/gK9jv1Sn2cM03UnHygQ=
=IrPk
-----END PGP SIGNATURE-----

--iayq7gzlfnfd2cvn--
