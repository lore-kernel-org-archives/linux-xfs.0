Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E833DEF7;
	Wed,  2 Sep 2026 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327801; cv=none; b=lJyKdBuY/nWuOLcVJhQGQ7xqkv2Ml4FSgJNWwljQB3YPVuK3gdUkD/zUqvOz84VP1KJRo4rVwnl9CQiLWMTt9pAjysT7DBeUf1rXi2L+FvZBJsMcOc3YUa09T08w6tPGIqwpesf/l8bTn1gFL7i34uMngYSo/eB/swctj1Nw7k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327801; c=relaxed/simple;
	bh=3L0WX9L6x7MXkDF2p+oDZdS9N97n3qPDnBvu29EoUHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jt/srjGtSpdRWT1hPvdWNxRzcLvkVQXjT32Ec43q+EsQwZ05UsMj9hktoFR96BNJNyOAza/bSe5r8ZYuHRI/+vzbc2DsWpMieYx/EqRHuShWdMIIbjzJcnZxm5e+lZUcz6QBAbDpttPNEtyAYEXh29DYQC/vba0ZbrAI8yjw2so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M369OT1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M369OT1u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B28381F000E9;
	Wed,  2 Sep 2026 05:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327799;
	bh=gKoCzEzuwkGKbZKxyow7sOImZGlX57VG2EYovony4dA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=M369OT1uxr5on8Qhtn4j8hL2o4u80qFFFnP2HAgic+cuKXhUZ+lQ1IDN4ZTa6Wy+b
	 zqsWsbtRcQmGyEsB1GFdTA34Mg+L4hVZ9dzjIaCS5gJY0HRhiDtnAtKXMuTzOTO/5X
	 u0cUaTubSRgqSqy6BauXOZqDzbhnOVDPn4Tr5GuhbL7Xrra2iSswJyTGvmrHTRjeP9
	 LbpW99UzeDi8Iei3pXyy61i0oe89B8aIKf4F6O2wmdL5wig/Lwl/VDNHkezznzgNZd
	 cQ8cwqD0ZYB9agRHfi6P4zvcmBE4SNYWDw4mN22CypZjG2GNDx+wfKiuBzJbBZEmnz
	 xiC3X8SS83Qjw==
Date: Tue, 01 Sep 2026 22:43:18 -0700
Subject: [PATCH 6/6] xfs: fix media verification ioctl for internal rt volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749137.3506928.1814273527743295978.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A media scan of a filesystem containing an internal rt volume produced
an error in xfs_scrub phase 6 complaining about a truncated realtime
device.  The rt device wasn't truncated, but the media scan code thought
we were trying to start a scan past the end of m_rtdev_targp.  That in
turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
nr_sectors to the size of the data section.  We don't account for an
internal realtime section, so the kernel doesn't scan any part of it.
Oops.

Reproducer:

 # mkfs.xfs -f /dev/sda -r zoned=1 -d rtinherit=1
 # mount /dev/sda /mnt
 # dd if=/dev/zero of=/mnt/a bs=1024k count=100
 # sync
 # xfs_info /mnt
 meta-data=/dev/sda               isize=512    agcount=4, agsize=32768 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
          =                       exchange=1   metadir=1
 data     =                       bsize=4096   blocks=131072, imaxpct=25
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
 log      =internal log           bsize=4096   blocks=16384, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
 realtime =internal               extsz=4096   blocks=1114112, rtextents=1114112
          =                       rgcount=17   rgsize=65536 extents
          =                       zoned=1      start=131072 reserved=53248

IOWS: 512M data volume, 3.1G internal rt section.  Now let's try some
media verification:

 # xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt
 verified 536870912/536870912 bytes at offset 0
 512 MiB, 1 ops; 0.0496 sec (10.067 GiB/sec and 20.1345 ops/sec)
 verified 536870912/536870912 bytes at offset 0
 512 MiB, 1 ops; 0.0409 sec (12.222 GiB/sec and 24.4439 ops/sec)

Notice how xfs_io says we only verified 512M of the rt volume?  If you
run btrace in the background you'll see that we read the first 512M of
the volume (aka the data section) twice and never read anything from the
rt section.

An earlier fix tried messing with the buftarg geometry, but I've decided
on a more targetted fix for the media verification code.  All we have to
do is calculate the starting and ending daddr for the device that we're
verifying, and clamp the user's input values to that range.  This leads
to some bogosity in the output reporting:

 # xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt/t
 verified 536870912/536870912 bytes at offset 0
 512 MiB, 1 ops; 0.0606 sec (8.248 GiB/sec and 16.4968 ops/sec)
 verified 5100273664/5100273664 bytes at offset 0
 4.750 GiB, 1 ops; 0.3329 sec (14.267 GiB/sec and 3.0035 ops/sec)

Because we don't have a way to report that we didn't really do anything
at all for that first 512M of address space of the rt "device".  But at
least we're no longer ignoring real media.

(Note that the fsmap/bmap/fiemap calls all report physical addresses for
the internal rt volume as offsets from the start of the data device, and
the media verifier call consumes the same.  We baked that into the
user-visible behavior in 6.15, so we're stuck with that sparse hole at
the beginning.)

Cc: <stable@vger.kernel.org> # v6.15
Fixes: bdc03eb5f98f6f ("xfs: allow internal RT devices for zoned mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_verify_media.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 5ead3976d51151..b75c81f8fcc037 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -268,6 +268,8 @@ xfs_verify_media(
 	struct xfs_buftarg	*btp = NULL;
 	struct bio		*bio;
 	struct folio		*folio;
+	xfs_daddr_t		dev_start = 0;
+	xfs_daddr_t		dev_end = 0;
 	xfs_daddr_t		daddr;
 	uint64_t		bbcount;
 	int			error = 0;
@@ -277,24 +279,33 @@ xfs_verify_media(
 	switch (me->me_dev) {
 	case XFS_DEV_DATA:
 		btp = mp->m_ddev_targp;
+		dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 		break;
 	case XFS_DEV_LOG:
-		if (mp->m_logdev_targp != mp->m_ddev_targp)
+		if (mp->m_logdev_targp != mp->m_ddev_targp) {
 			btp = mp->m_logdev_targp;
+			dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+		}
 		break;
 	case XFS_DEV_RT:
 		btp = mp->m_rtdev_targp;
+		dev_start = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
+		dev_end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart +
+					    mp->m_sb.sb_rblocks);
 		break;
 	}
 	if (!btp)
 		return -ENODEV;
 
 	/*
-	 * If the caller told us to verify beyond the end of the disk, tell the
-	 * user exactly where that was.
+	 * If the caller told us to verify before the start or beyond the end
+	 * of the disk volume, tell the user exactly where the volume starts
+	 * and ends.
 	 */
-	if (me->me_end_daddr > btp->bt_nr_sectors)
-		me->me_end_daddr = btp->bt_nr_sectors;
+	if (me->me_end_daddr > dev_end)
+		me->me_end_daddr = dev_end;
+	if (me->me_start_daddr < dev_start)
+		me->me_start_daddr = dev_start;
 
 	/* start and end have to be aligned to the lba size */
 	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
@@ -323,8 +334,7 @@ xfs_verify_media(
 	 *    verifying.
 	 */
 	daddr = me->me_start_daddr;
-	bbcount = min_t(sector_t, me->me_end_daddr, btp->bt_nr_sectors) -
-			  me->me_start_daddr;
+	bbcount = me->me_end_daddr - me->me_start_daddr;
 
 	folio = xfs_verify_alloc_folio(xfs_verify_iosize(me, btp, bbcount));
 	if (!folio)

