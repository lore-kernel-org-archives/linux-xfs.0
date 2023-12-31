Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD616C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="squIOSMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61549C433C7;
	Sun, 31 Dec 2023 23:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066595;
	bh=/zCyE/mwxu1Yb3/Z896xD+iJ4COl1NUXZRBzDuMST8M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=squIOSMA0/YrlhumlDMjxnHIQLCs9cGO0kUO7IbIoEsDd9typWc9ZwvwWUrZmdZj5
	 WQ1U0W2tuW9mmR3i0NHsUkmW4WuLtoRLOxhAGVMH0z2dhEjvGIuVPdA1QpjIPvvSuW
	 pSxVjJhbnzoyoAVbvhWAaAkRL9PAnBfSFIFE3LAA2r9NifJ3REesNA02K0paRKI6a6
	 faEWg21HscQul2MJ7v2WioDK7Vwu8sCvcWW/OIEZ8qaRXnsIRAb3ItegCZhquCZer2
	 K77/5dA12O6GHW0C28ZYcO0LjLKwPWSkVr0HBakOt5nib8rpIh/3yts+ZaPglWUJqR
	 NDflnis8BlkuA==
Date: Sun, 31 Dec 2023 15:49:54 -0800
Subject: [PATCH 09/52] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012289.1811243.15016247613899430387.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    1 +
 libxfs/xfs_sb.c     |    5 +++++
 2 files changed, 6 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ec0956c539f..184e7a38fb3 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -39,6 +39,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+#define m_frextents	m_sb.sb_frextents
 	spinlock_t		m_sb_lock;
 
 	/*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 3bd56edab87..0ded5220161 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1148,6 +1148,9 @@ xfs_log_sb(
 	 * sb counters, despite having a percpu counter. It is always kept
 	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
 	 * and hence we don't need have to update it here.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
@@ -1156,6 +1159,8 @@ xfs_log_sb(
 				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents = percpu_counter_sum(&mp->m_frextents);
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);

