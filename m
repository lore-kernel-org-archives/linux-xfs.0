Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55468 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbdLGD1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 22:27:40 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8482674884D
        for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2017 21:27:39 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 30a757b
Message-ID: <3b472354-4a3b-c3e6-4b9b-d31b248b0f6c@sandeen.net>
Date: Wed, 6 Dec 2017 21:27:37 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nGQUsnOhpxajrsPpPIqQrWt3EhTDkfh78"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nGQUsnOhpxajrsPpPIqQrWt3EhTDkfh78
Content-Type: multipart/mixed; boundary="E3dC53laqU8TE527nP1PCNRRQG51dJhfc";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <3b472354-4a3b-c3e6-4b9b-d31b248b0f6c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 30a757b

--E3dC53laqU8TE527nP1PCNRRQG51dJhfc
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

30a757b libxfs: libxfs_nproc should never return negative numbers

New Commits:

Darrick J. Wong (1):
      [30a757b] libxfs: libxfs_nproc should never return negative numbers=


Dave Chinner (42):
      [594932f] mkfs: disallow specifying the sector size of internal log=

      [05abf43] mkfs: make subopt table const
      [cf627f3] mkfs: introduce a structure to hold CLI options
      [a350bbc] mkfs: add generic subopt parsing table
      [85d6f03] mkfs: factor block subopts parser
      [a1273b7] mkfs: factor data subopts parser
      [a3ac5af] mkfs: factor inode subopts parser
      [f3bc91a] mkfs: factor log subopts parser
      [997136c] mkfs: factor meta subopts parser
      [98d4092] mkfs: factor naming subopts parser
      [d145f69] mkfs: factor rt subopts parser
      [f948f00] mkfs: factor sector subopts parser
      [4ab08e3] mkfs: Introduce mkfs configuration structure
      [d113804] mkfs: factor printing of mkfs config
      [afda75a] mkfs: factor in memory superblock setup
      [e99bf83] mkfs: factor out device preparation
      [0ff1b0e] mkfs: factor writing AG headers
      [e2847e5] mkfs: factor secondary superblock updates
      [68344ba] mkfs: introduce default configuration structure
      [ebed4ac] mkfs: rename top level CLI parameters
      [585f41b] mkfs: factor sectorsize validation
      [b1b8e54] mkfs: factor blocksize validation
      [22319b5] mkfs: factor log sector size validation
      [a43e656] mkfs: factor superblock feature validation
      [fdea8fb] mkfs: factor directory blocksize validation
      [8fe2902] mkfs: factor inode size validation
      [e24dfa2] mkfs: factor out device size calculations
      [7175103] mkfs: fix hidden parameter in DTOBT()
      [80b154f] mkfs: factor rtdev extent size validation
      [2f44b1b] mkfs: rework stripe calculations
      [379f01d] mkfs: factor device opening
      [dd5ac31] mkfs: factor data device validation
      [90b7e13] mkfs: factor log device validation
      [7a9af89] mkfs: factor rt device validation
      [1de0144] mkfs: factor AG geometry calculations
      [051b4e3] mkfs: factor AG alignment
      [d7240c9] mkfs: rework imaxpct calculation
      [befcd76] mkfs: factor initial mount setup
      [e3bc839] mkfs: factor log size calculations
      [b449c79] mkfs: cleanup redundant temporary code
      [dafb318] mkfs: move error functions
      [4eee66c] mkfs: tidy up definitions


Code Diffstat:

 include/libxfs.h |    2 +-
 libxfs/init.c    |    7 +-
 mkfs/xfs_mkfs.c  | 4640 ++++++++++++++++++++++++++++++------------------=
------
 3 files changed, 2607 insertions(+), 2042 deletions(-)


--E3dC53laqU8TE527nP1PCNRRQG51dJhfc--

--nGQUsnOhpxajrsPpPIqQrWt3EhTDkfh78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlootSkACgkQIK4WkuE9
3uDjlQ//V5sbpGQ2ahSo7BaTp1K9qwtwsL8Be9DqCk/hE9XMURXye2OxwIZ9QnNK
AkCIcskfsnhV3IXsJ9/mz/p41LX2UGR83qw1I0stOGQwgcdq/KocpqkGnZecnJA7
bf+h6TslOe4S1Z7tg6YgzAkZX9SfZx+TgRkrU72BjmkgYowdHS5lYp2zDNFFO0fH
sMWGPpBb5wYRph3zW1K09oenL1jU1w2gbVPlA0r4cknBVLxfUd5QMXzhRJ1z/ytJ
1vzCckXHDchrjwwJ/N5F4g9AMLujKJow91VNiboIhYLJqjTiQtcFKut4o3a0jfvn
I31i1PdSjR/nLc7LAEnvkaV4tWJ8QV64n6xUjkJRTBLizYSLcNd+8WuIEq4xkWN8
mdnZXW91Wnjgo+XeJXVyRMEhkXPnprvsMS+uuO9EbCxy18NBNgt4Tp/ijCjfWnFJ
1pFbLJXVnkbtLD1uW8gb9f5gpymLy2hMidEE9tPfbGJ7jk5vAXFnjEwrlgRHbAsb
WcrOKuYA5nLpcpxodDSvT2I0trtV/fU+D1OSxyL+sBaCsArzwYF/nyQNIKCjmK6Q
4droScFxt0ScKnd55VUFiEP7AQ3GAh4+I88t5ch4u/6FSKblbZWLcJZtH4YIlqtq
sgbe9Yl3rqO2Z9smpTl6MYhn1E8jAkfCz+CUTrwCHPeZjQaCrdo=
=Qpqg
-----END PGP SIGNATURE-----

--nGQUsnOhpxajrsPpPIqQrWt3EhTDkfh78--
