Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BB0B654
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294611; cv=none; b=Z9ertimcjq1gXcBterth0rkWwi18B+Bq47Z3J/XptMSSVIc0SlYc71/GijZkDcFlZ6UCGUF+dnkiKsTeHeIrjf+xsXM6sv75+80stGy9mAS4xVmxlEgz9tTgy5Zrii2sluIwyGWXLQYRSsOQ3boVdnHr7mlEAi7i6s9IUgQiqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294611; c=relaxed/simple;
	bh=dGn93APs1f7laCPa2cHcgnj/5Ugs3Z0Onla3Ut2Taaw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CoaYwM5v+oF9VtiOhJLO9r61Vb0qyejWYy8X5bAVfQMPYpOTwr6R3fekzVsAPFkh5qx8xr3Ts8EVIuN2JWh3xS9p6S6Ym2xODlNJzts2EGVYw6l58CcqhoNiXBw/51fPibfOSiZGjPaxsKhg1/sf+wpzdStjgFPCGF7Q5aUKo30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y78yKI6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y78yKI6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60957C433C7;
	Wed, 13 Mar 2024 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294611;
	bh=dGn93APs1f7laCPa2cHcgnj/5Ugs3Z0Onla3Ut2Taaw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y78yKI6HCIYgP/M+jtSVAFUgR5TqRi4+7cxyqoCVPFZMAGy1tqcBWx3tj4WNO+EBF
	 K1cwWRPRR61A1ypkUw8ItMT2Q4mjWKQmDfVkp7t5fctlYXbVemqVykSpP2P7tih9mX
	 eV+C11+kCyu04ENTf+qQg0UEX5iYbGUoN+f2cj0JXtpvbXeAx8s3pFAYeDJOSyfmuU
	 LAy/D6Arf5RnPSDRiB6xSJEvogK9mBaVOPxVsMZjwxUHh1hzj5oIKCCaWDXJPurcGl
	 6UmrSWSRq5l7sv8LTjvBEY0FNcDbUC2eEe5RK85Zon6beALkwaf3k/BCZ+Up2KqoZH
	 OTgIBIHZBHytg==
Date: Tue, 12 Mar 2024 18:50:10 -0700
Subject: [PATCH 02/13] mkfs: fix log sunit rounding when external logs are in
 use
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430586.2061422.6975814186247298641.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Due to my heinous nature, I set up an external log device with 4k LBAs
using this command:

# losetup -b 4096 -o 4096 --sizelimit $(( (128 * 1048576) - 4096 )) -f /dev/sdb
# blockdev --getsize64 /dev/loop0
134213632

This creates a log device that is slightly smaller than 128MB in size.
Next I ran generic/054, which sets the log sunit to 256k and fails:

# mkfs.xfs -f /dev/sda -l logdev=/dev/loop0,su=256k,version=2 -s size=4096
meta-data=/dev/sda               isize=512    agcount=4, agsize=72448 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       metadir=0
data     =                       bsize=4096   blocks=289792, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =/dev/loop0             bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 blks
Discarding blocks...Done.
Discarding blocks...Done.
mkfs.xfs: libxfs_device_zero write failed: No space left on device

Notice that mkfs thinks it should format a 32768-fsblock external log,
but the log device itself is 32767 fsblocks.  Hence the write goes off
the end of the device and we get ENOSPC.

I tracked this behavior down to align_log_size in mkfs, which first
tries to round the log size up to a stripe boundary, then tries to round
it down.  Unfortunately, in the case of an external log we call the
function with XFS_MAX_LOG_BLOCKS without accounting for the possibility
that the log device might be smaller.

Correct the callsite and clean up the open-coded rounding.

Fixes: 8d1bff2be336 ("mkfs: reduce internal log size when log stripe units are in play")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fcbf5413269a..b8e2c0da60c4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3338,13 +3338,13 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
 		usage();
 	}
 
-	tmp_logblocks = ((cfg->logblocks + (sunit - 1)) / sunit) * sunit;
+	tmp_logblocks = roundup_64(cfg->logblocks, sunit);
 
 	/* If the log is too large, round down instead of round up */
 	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
 	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) ||
 	    tmp_logblocks > max_logblocks) {
-		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
+		tmp_logblocks = rounddown_64(cfg->logblocks, sunit);
 	}
 	cfg->logblocks = tmp_logblocks;
 }
@@ -3465,6 +3465,7 @@ static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
+	struct libxfs_init	*xi,
 	struct xfs_mount	*mp)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
@@ -3503,8 +3504,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		}
 		cfg->logstart = 0;
 		cfg->logagno = 0;
-		if (cfg->lsunit)
-			align_log_size(cfg, cfg->lsunit, XFS_MAX_LOG_BLOCKS);
+		if (cfg->lsunit) {
+			uint64_t	max_logblocks;
+
+			max_logblocks = min(DTOBT(xi->log.size, cfg->blocklog),
+					    XFS_MAX_LOG_BLOCKS);
+			align_log_size(cfg, cfg->lsunit, max_logblocks);
+		}
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
 		return;
@@ -4257,7 +4263,7 @@ main(
 	 * With the mount set up, we can finally calculate the log size
 	 * constraints and do default size calculations and final validation
 	 */
-	calculate_log_size(&cfg, &cli, mp);
+	calculate_log_size(&cfg, &cli, &xi, mp);
 
 	finish_superblock_setup(&cfg, mp, sbp);
 

