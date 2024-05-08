Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4D371753
	for <linux-xfs@vger.kernel.org>; Wed,  8 May 2024 09:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715160583; cv=none; b=tvxiGb2UmoK0uyv/JF0q9M453IP5HdPBIvsRE0c5yUIUI5c2P8xYDRRr7WIR7xjZ1/IqUy079K7+Do/NagnUnFToYPCs50KV27P7628OUAwEycQ+khPGsMEULt8cpB1EP7ffpSt1GrrhiBnpP5UOLtQVrg9dVjybpdqUhbDj04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715160583; c=relaxed/simple;
	bh=IuOti/7FmMOJOFVe94VcG21BqvUHpmUZFYDAMuu2xow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sj+PQi2g9KXTWbQS8FQO5HDsBHRAAMEZOLHBPfKUdQjQNZJ18DGVfzl97tzRHohZlOOP7mMpc0JW+ZfrwRjGiqRaS6Hs8iaqkRInyOeXDLUeMeR+CUk61lJ0BAewfoTkKeNtLS002DRZWsxHmurt3wR0K8IAOW2ottKmQnr0SRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQzSwZSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQzSwZSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B299FC113CC;
	Wed,  8 May 2024 09:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715160581;
	bh=IuOti/7FmMOJOFVe94VcG21BqvUHpmUZFYDAMuu2xow=;
	h=From:To:Cc:Subject:Date:From;
	b=XQzSwZSm6oyYvM6nuSWPBSFU/SogxUizB8/Fh7VLCwmT1Kzc28OI3Y+VEfKPa/KBZ
	 VCyevtuGFw9MPDULdLlkb4+dTHfmAY/pLmBJen5HHW3n5rNs9Ks78WFGUbcQUpIof0
	 UdEEwT5CKS3+bu2VFKb7lcCbJW99AfSwKLRuMx2kEnJatcZn3qO39GtlyXqr/jC5WP
	 ++IDxMfJAR22QjeFGmwlAasbRBk9hfswsp2zrhQ/+fxHLfsd51wcqp8WKNmi4QD886
	 KMvkruJKjfFOmcY1S093GQj00eGp5OgNi5F3Atz3i05SOUgLSBfkRivBqAb+A2pSNI
	 MSjIQ4u+U1/yw==
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: yi.zhang@huawei.com
Cc: brauner@kernel.org, Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: [BUG REPORT] generic/561 fails when testing xfs on next-20240506
 kernel
Date: Wed, 08 May 2024 14:31:02 +0530
Message-ID: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

generic/561 fails when testing XFS on a next-20240506 kernel as shown below,

# ./check generic/561
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xfs-crc-rtdev-extsize-28k 6.9.0-rc7-next-2024=
0506+ #1 SMP PREEMPT_DYNAMIC Mon May  6 07:53:46 GMT 2024
MKFS_OPTIONS  -- -f -rrtdev=3D/dev/loop14 -f -m reflink=3D0,rmapbt=3D0, -d =
rtinherit=3D1 -r extsize=3D28k /dev/loop5
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 -ortdev=3D/dev/lo=
op14 /dev/loop5 /media/scratch

generic/561       - output mismatch (see /var/lib/xfstests/results/xfs-crc-=
rtdev-extsize-28k/6.9.0-rc7-next-20240506+/xfs_crc_rtdev_extsize_28k/generi=
c/561.out.bad)
    --- tests/generic/561.out   2024-05-06 08:18:09.681430366 +0000
    +++ /var/lib/xfstests/results/xfs-crc-rtdev-extsize-28k/6.9.0-rc7-next-=
20240506+/xfs_crc_rtdev_extsize_28k/generic/561.out.bad        2024-05-08 0=
9:14:24.908010133 +0000
    @@ -1,2 +1,5 @@
     QA output created by 561
    +/media/scratch/dir/p0/d0XXXXXXXXXXXXXXXXXXXXXXX/d486/d4bXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXX/d5bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d212XXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXX/d11XXXXXXXXX/d54/de4/d158/d27f/d895/d1307XXX/d=
8a4/d832XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/r112fXXXXXXXX=
XXX: FAILED
    +/media/scratch/dir/p0/d0XXXXXXXXXXXXXXXXXXXXXXX/d486/d4bXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXX/d5bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d212XXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXX/d11XXXXXXXXX/d54/de4/d158/d27f/d13a3XXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d13c=
0XXXXXXXX/d2301X/d222bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d1240XXXXXXXXXXXX=
XXXXXXXXXXXX/d722XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d1380XXXXXXXXXXXXXXXX/dc62XXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/r10d5: FAILED
    +md5sum: WARNING: 2 computed checksums did NOT match
     Silence is golden
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/561.out /var/lib/xfstests=
/results/xfs-crc-rtdev-extsize-28k/6.9.0-rc7-next-20240506+/xfs_crc_rtdev_e=
xtsize_28k/generic/561.out.bad'  to see the entire diff)
Ran: generic/561
Failures: generic/561
Failed 1 of 1 tests

The following was the fstest configuration used for the test run,

  FSTYP=3Dxfs
  TEST_DIR=3D/media/test
  SCRATCH_MNT=3D/media/scratch
  TEST_DEV=3D/dev/loop16
  TEST_LOGDEV=3D/dev/loop13
  SCRATCH_DEV_POOL=3D"/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop=
9 /dev/loop10 /dev/loop11 /dev/loop12"
  MKFS_OPTIONS=3D'-f -m crc=3D1,reflink=3D0,rmapbt=3D0, -i sparse=3D0 -lsiz=
e=3D1g'
  TEST_FS_MOUNT_OPTS=3D"-o logdev=3D/dev/loop13"
  MOUNT_OPTIONS=3D'-o usrquota,grpquota,prjquota'
  TEST_FS_MOUNT_OPTS=3D"$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
  SCRATCH_LOGDEV=3D/dev/loop15
  USE_EXTERNAL=3Dyes
  LOGWRITES_DEV=3D/dev/loop15

Git bisect produced the following as the first bad commit,

commit 943bc0882cebf482422640924062a7daac5a27ba
Author: Zhang Yi <yi.zhang@huawei.com>
Date:   Wed Mar 20 19:05:45 2024 +0800

    iomap: don't increase i_size if it's not a write operation

    Increase i_size in iomap_zero_range() and iomap_unshare_iter() is not
    needed, the caller should handle it. Especially, when truncate partial
    block, we should not increase i_size beyond the new EOF here. It doesn't
    affect xfs and gfs2 now because they set the new file size after zero
    out, it doesn't matter that a transient increase in i_size, but it will
    affect ext4 because it set file size before truncate. So move the i_size
    updating logic to iomap_write_iter().

    Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
    Link: https://lore.kernel.org/r/20240320110548.2200662-7-yi.zhang@huawe=
icloud.com
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Christian Brauner <brauner@kernel.org>

 fs/iomap/buffered-io.c | 50 +++++++++++++++++++++++++---------------------=
----
 1 file changed, 25 insertions(+), 25 deletions(-)
=20
--=20
Chandan
