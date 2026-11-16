Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871043;
	b=z4jLxJ9n7tQ/J7GiZNmON5OfGfdYxyzp9iwCBm0xlYDJQ8uDlfGAt+ql6xEy4TqXnVem
	 C8BE+K+le5Ghlp4YKeAo3FugPY3iA+5Clpi7MW7Jmb9v7z47nX4wBjvyGgTss85tOVnMT
	 k4ug6/du2eU4FKFS6Pb/5dsI2JEV5Uq75V5XaLIkvuRfZfh0iNAhKarIdTSya/qO6/IUP
	 0PjQ+OCPmmXrHTJHcD65Ix9n7Llc25OLirjwuJsTT7JXHoYVC7jV4xSMLrzuQ0xJwDqPc
	 H+E+Wh+y2453MYLzL3+KgbkvFOPNlQdAHddSIHmwIZi/BoUMUOI9WZvINT1jGZBrndA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=StBFd7xgMqPw50oo+Tb+99A/1sYiMsyPd1KHluajBTM=;
	b=Cdvu4FC0rd17m/TfuCh54UP1CyA7WcpJNg36JP/TF8IOZDDOp+daWY7zELFy3Mp1C43U
	 fdcPs9uPv/bOP4Mxonfndn9G0sEG4mdDv/rK4YxExi9jgvP48bRtsyLl+lCuT/LThuKoG
	 EFbR6k8TQsNhT+F4NIkV8W5MKMu4SKO/VAA+gPeagbi0tXwe+hp/aBdO9tm1wfpy1oP/d
	 aXtmOZF/4jk9j/MfA3yMfiXrSLqMxwQ/+lmKa4xyQsq3+qjJpRcLfJ4cEQruhr5MxrAwB
	 1Vl3JiOFAl2G+9rz8/ySDAUdCkNgujxJYSWHQ71bJY3YQMggGUvtFgsxVuGq4g4lI9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TiXD3DKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63133606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TiXD3DKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A7D1F000C4;
	Mon, 16 Nov 2026 23:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871043;
	bh=StBFd7xgMqPw50oo+Tb+99A/1sYiMsyPd1KHluajBTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiXD3DKFLzYBhsAO1FZvyEA6G+8X2/glgaGYLrBdC9KUAAFMTjtiW/H1G7hYNsl9X
	 pf6wnBtUT0vRLZOo0rtYfx2VlHjSXz5zVNZJGDQW2YST5QWPuoToV9L3MDsT4Cw/Jh
	 QjDIILEAFDybt13UcbHM5FQKc4J9Hdzq9ubeof/nk6rjsnsYWwRpK5VAgdkEheK77e
	 9NG9y+cQ3xrl5OtArgLVqEy2eVR8I2oglnQ95DgZ67vaCeEwExA/YMdNtFcfERWVzl
	 +eOw+OwlYxH0xI4/Dff4phy3WbycOoRvcfaoYVTm4a2R/QQQyq9a7gGUHYFfTon1Q0
	 4Rmot6z8LiTHA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 07/59] xfs: update the rt geometry when recovering a superblock change
Date: Tue, 17 Nov 2026 10:14:24 +1100
Message-ID: <20261116231707.3625263-8-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recovering a growfs can change the realtime geometry. Adding the first
realtime volume can change the realtime extent size. It also brings the rt
rmap and rt refcount btrees into use. Changing the data device size changes
the height those btrees can reach. Superblock recovery does not update the
realtime geometry, the mount features or the realtime btree maximum heights.

The rest of recovery then runs with the old geometry. New rtgroups are set up
with the wrong layout. Valid realtime btree blocks can fail verification and
abort recovery. A realtime device needs to be defined to recover realtime
metadata. Abort superblock recovery if it adds a realtime volume but no device
exists.

Update the realtime geometry, the mount features and the realtime btree
maximum heights when the primary superblock is recovered. Growfs does the same
at runtime.

Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 57929f115055..383d0e87ef6a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -27,6 +27,8 @@
 #include "xfs_sb.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -741,6 +743,7 @@ xlog_recover_do_primary_sb_buffer(
 	struct xfs_dsb			*dsb = bp->b_addr;
 	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
 	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
+	xfs_rfsblock_t			orig_rblocks = mp->m_sb.sb_rblocks;
 	int				error;
 
 	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
@@ -752,11 +755,36 @@ xlog_recover_do_primary_sb_buffer(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Growfs can add the first realtime volume to a filesystem that was
+	 * mounted with a realtime device but had no realtime section. Without
+	 * a realtime device the new realtime volume cannot be recovered.
+	 *
+	 * Check this before the in-core superblock is updated. A failed mount
+	 * frees the rtgroups counted by the in-core superblock, and the new
+	 * rtgroups have not been created yet.
+	 */
+	if (orig_rblocks == 0 && be64_to_cpu(dsb->sb_rblocks) > 0 &&
+	    !XFS_IS_REALTIME_MOUNT(mp)) {
+		xfs_warn(mp,
+	"Recovered a realtime volume, use rtdev=device option");
+		return -ENODEV;
+	}
+
 	/*
 	 * Update the in-core super block from the freshly recovered on-disk one.
 	 */
 	xfs_sb_from_disk(&mp->m_sb, dsb);
 
+	/*
+	 * Growfs can change the realtime extent size when it adds the first
+	 * realtime volume, and adding it sets the realtime feature. Update the
+	 * realtime geometry and the mount features before the rtgroups are
+	 * set up, as both are used to calculate the rtgroup geometry.
+	 */
+	xfs_sb_mount_rextsize(mp, &mp->m_sb);
+	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);
+
 	/*
 	 * Grow can change the device size.  Mirror that into the buftarg.
 	 */
@@ -816,6 +844,16 @@ xlog_recover_do_primary_sb_buffer(
 		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
 		return error;
 	}
+
+	/*
+	 * The realtime btree geometry depends on the realtime volume and the
+	 * data device size, both of which growfs can change. Later recovery
+	 * verifies realtime btree blocks against that geometry, so recompute
+	 * the realtime btree maximum heights now.
+	 */
+	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
 	return 0;
 }
 
-- 
2.55.0

