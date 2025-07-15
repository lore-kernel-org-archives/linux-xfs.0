Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4217260578
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556771; cv=none; b=TBw8+PSRXpfJra73ufmvR+i10hTu3Ehk2oRKqZ7z2RxhlD7lCe3ng0u+E60rqEE4jDRcEec/9u8EPMfLQ/XL6omiIMt7Lc5Fosjr+Db31dYRRSSE4aASA2Crib9ITLcV8KKb+t7t5p2HrZ6WTelN70nnPO+Ie9qCJFqj6uwE/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556771; c=relaxed/simple;
	bh=MrDsslzXa8yZFwIOXw9Gp76mMmClQ+YHYbgSBk4F2g0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDH8eI6bcQl0Ga1UD8giSHHhrF4dptS84lgl8kQVHJJkJBfXJVohDBAwme9J8bshHdWoersIBxvflNlx1R8owW737PToLhXzJtLMEV0CqcRGwzmdcDlj9nkF2k3STCnFXiSoUhs+zd5y4lV/sXrA6U8Sb+nBEWVbIpjMRxV8elY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnxBMBQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnxBMBQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A54C4CEE3;
	Tue, 15 Jul 2025 05:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556770;
	bh=MrDsslzXa8yZFwIOXw9Gp76mMmClQ+YHYbgSBk4F2g0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TnxBMBQR0oyz35eJTTK1dBhpwtdd4OjY6/7ZspW7z+2+1R5+CDxVSRY57vIK3fyuk
	 xiPBOVQxencOuiuWHi3prYij+xyOYFphyt9/xIbRV5vkBi3I+TX3bjb2D2pbxMQqkN
	 /lbjdD4ulZhQSGG0gCB1a484XoV8McqbUiPOzKEvTEGB9bU3Jd7bKR5vzgwDwMhNBu
	 8c4qo0ICBLSnhga0ZnhC/eynsSIMKxJ89kOQvv0HHnHaZERhw3CEh8LtZZQ5ZN4Df4
	 xZM065MZUtC5U68TtoN74XutgnHTHloOLeriH4R/Ofm5EcA1c3G2M2DqBi11/VQdm/
	 ynto0JTymnQsg==
Date: Mon, 14 Jul 2025 22:19:30 -0700
Subject: [PATCH 6/7] mkfs: try to align AG size based on atomic write
 capabilities
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652564.1831001.14293121870201939425.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Try to align the AG size to the maximum hardware atomic write unit so
that we can give users maximum flexibility in choosing an RWF_ATOMIC
write size.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/topology.h |    6 ++++--
 libxfs/topology.c |   36 ++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c   |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 83 insertions(+), 7 deletions(-)


diff --git a/libxfs/topology.h b/libxfs/topology.h
index 207a8a7f150556..f0ca65f3576e92 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -13,8 +13,10 @@
 struct device_topology {
 	int	logical_sector_size;	/* logical sector size */
 	int	physical_sector_size;	/* physical sector size */
-	int	sunit;		/* stripe unit */
-	int	swidth;		/* stripe width  */
+	int	sunit;			/* stripe unit */
+	int	swidth;			/* stripe width  */
+	int	awu_min;		/* min atomic write unit in bbcounts */
+	int	awu_max;		/* max atomic write unit in bbcounts */
 };
 
 struct fs_topology {
diff --git a/libxfs/topology.c b/libxfs/topology.c
index 96ee74b61b30f5..7764687beac000 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -4,11 +4,18 @@
  * All Rights Reserved.
  */
 
+#ifdef OVERRIDE_SYSTEM_STATX
+#define statx sys_statx
+#endif
+#include <fcntl.h>
+#include <sys/stat.h>
+
 #include "libxfs_priv.h"
 #include "libxcmd.h"
 #include <blkid/blkid.h>
 #include "xfs_multidisk.h"
 #include "libfrog/platform.h"
+#include "libfrog/statx.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
@@ -278,6 +285,34 @@ blkid_get_topology(
 		device);
 }
 
+static void
+get_hw_atomic_writes_topology(
+	struct libxfs_dev	*dev,
+	struct device_topology	*dt)
+{
+	struct statx		sx;
+	int			fd;
+	int			ret;
+
+	fd = open(dev->name, O_RDONLY);
+	if (fd < 0)
+		return;
+
+	ret = statx(fd, "", AT_EMPTY_PATH, STATX_WRITE_ATOMIC, &sx);
+	if (ret)
+		goto out_close;
+
+	if (!(sx.stx_mask & STATX_WRITE_ATOMIC))
+		goto out_close;
+
+	dt->awu_min = sx.stx_atomic_write_unit_min >> 9;
+	dt->awu_max = max(sx.stx_atomic_write_unit_max_opt,
+			  sx.stx_atomic_write_unit_max) >> 9;
+
+out_close:
+	close(fd);
+}
+
 static void
 get_device_topology(
 	struct libxfs_dev	*dev,
@@ -316,6 +351,7 @@ get_device_topology(
 		}
 	} else {
 		blkid_get_topology(dev->name, dt, force_overwrite);
+		get_hw_atomic_writes_topology(dev, dt);
 	}
 
 	ASSERT(dt->logical_sector_size);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b6de13cebc93ed..d2080804a21470 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3379,6 +3379,32 @@ _("illegal CoW extent size hint %lld, must be less than %u and a multiple of %u.
 	}
 }
 
+static void
+validate_device_awu(
+	struct mkfs_params	*cfg,
+	struct device_topology	*dt)
+{
+	/* Ignore hw atomic write capability if it can't do even 1 fsblock */
+	if (BBTOB(dt->awu_min) > cfg->blocksize ||
+	    BBTOB(dt->awu_max) < cfg->blocksize) {
+		dt->awu_min = 0;
+		dt->awu_max = 0;
+	}
+}
+
+static void
+validate_hw_atomic_writes(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct fs_topology	*ft)
+{
+	validate_device_awu(cfg, &ft->data);
+	if (cli->xi->log.name)
+		validate_device_awu(cfg, &ft->log);
+	if (cli->xi->rt.name)
+		validate_device_awu(cfg, &ft->rt);
+}
+
 /* Complain if this filesystem is not a supported configuration. */
 static void
 validate_supported(
@@ -4052,10 +4078,20 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
  */
 static void
 align_ag_geometry(
-	struct mkfs_params	*cfg)
+	struct mkfs_params	*cfg,
+	struct fs_topology	*ft)
 {
-	uint64_t	tmp_agsize;
-	int		dsunit = cfg->dsunit;
+	uint64_t		tmp_agsize;
+	int			dsunit = cfg->dsunit;
+
+	/*
+	 * We've already validated (or discarded) the hardware atomic write
+	 * geometry.  Try to align the agsize to the maximum atomic write unit
+	 * to give users maximum flexibility in choosing atomic write sizes.
+	 */
+	if (ft->data.awu_max > 0)
+		dsunit = max(DTOBT(ft->data.awu_max, cfg->blocklog),
+				dsunit);
 
 	if (!dsunit)
 		goto validate;
@@ -4111,7 +4147,8 @@ _("agsize rounded to %lld, sunit = %d\n"),
 				(long long)cfg->agsize, dsunit);
 	}
 
-	if ((cfg->agsize % cfg->dswidth) == 0 &&
+	if (cfg->dswidth > 0 &&
+	    (cfg->agsize % cfg->dswidth) == 0 &&
 	    cfg->dswidth != cfg->dsunit &&
 	    cfg->agcount > 1) {
 
@@ -5875,6 +5912,7 @@ main(
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
 	validate_rtextsize(&cfg, &cli, &ft);
+	validate_hw_atomic_writes(&cfg, &cli, &ft);
 
 	/*
 	 * Open and validate the device configurations
@@ -5893,7 +5931,7 @@ main(
 	 * aligns to device geometry correctly.
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
-	align_ag_geometry(&cfg);
+	align_ag_geometry(&cfg, &ft);
 	if (cfg.sb_feat.zoned)
 		calculate_zone_geometry(&cfg, &cli, &xi, &zt);
 	else

