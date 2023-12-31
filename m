Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED30BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPWYHkKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9988CC433C7;
	Sun, 31 Dec 2023 20:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054442;
	bh=zrCFPOjwwBdpfPm/rx5ArsghHYYnoctbjkiTGgcPG4s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YPWYHkKx3gls9F4YV+cpa+3106epiHdmmul/BMQjleOZh8MoHaKfa79vzLiGWXkcX
	 JC/VQNiHnVLhTivCTNgoh6DwIaYKcF6ZWFvdFIZHi7ZjVhN5Y0I/VWrxkv+aPu3ZFc
	 Ok9gSu0Ek06QROHgtQA19+IIcOsM3wn79phyOOY3B7O0/RlPtTgzbFgXXJM68nGamf
	 +zfQnB/GW9/bIaPinAMrhkNnLzXiTV/0AA9ARM2xs/SS5bcSOA5Y7RjfgcI3spNY8K
	 vacXAC+Eqj7njTLdVijuUOqMNseqmCI4lAXEjc17y4bI/6kZ0m40wDVoots4BBoQPV
	 xJ8MlN+0XnOHQ==
Date: Sun, 31 Dec 2023 12:27:22 -0800
Subject: [PATCH 12/25] xfs: enable xlog users to toggle atomic extent swapping
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833333.1750288.6295086198444137726.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Plumb the necessary bits into the xlog code so that higher level callers
can enable the atomic extent swapping feature and have it clear
automatically when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      |   13 +++++++++++++
 fs/xfs/xfs_log.h      |    1 +
 fs/xfs/xfs_log_priv.h |    1 +
 3 files changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f62a6e233689c..8874360e596c5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1467,11 +1467,17 @@ xlog_clear_incompat(
 	if (down_write_trylock(&log->l_incompat_xattrs))
 		incompat_mask |= XFS_SB_FEAT_INCOMPAT_LOG_XATTRS;
 
+	if (down_write_trylock(&log->l_incompat_swapext))
+		incompat_mask |= XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT;
+
 	if (!incompat_mask)
 		return;
 
 	xfs_clear_incompat_log_features(mp, incompat_mask);
 
+	if (incompat_mask & XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT)
+		up_write(&log->l_incompat_swapext);
+
 	if (incompat_mask & XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 		up_write(&log->l_incompat_xattrs);
 }
@@ -1592,6 +1598,7 @@ xlog_alloc_log(
 	log->l_sectBBsize = 1 << log2_size;
 
 	init_rwsem(&log->l_incompat_xattrs);
+	init_rwsem(&log->l_incompat_swapext);
 
 	xlog_get_iclog_buffer_size(mp, log);
 
@@ -3890,6 +3897,9 @@ xlog_use_incompat_feat(
 	case XLOG_INCOMPAT_FEAT_XATTRS:
 		down_read(&log->l_incompat_xattrs);
 		break;
+	case XLOG_INCOMPAT_FEAT_SWAPEXT:
+		down_read(&log->l_incompat_swapext);
+		break;
 	}
 }
 
@@ -3903,5 +3913,8 @@ xlog_drop_incompat_feat(
 	case XLOG_INCOMPAT_FEAT_XATTRS:
 		up_read(&log->l_incompat_xattrs);
 		break;
+	case XLOG_INCOMPAT_FEAT_SWAPEXT:
+		up_read(&log->l_incompat_swapext);
+		break;
 	}
 }
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index d187f64459093..30bdbf8ee25c3 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -161,6 +161,7 @@ bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
 enum xlog_incompat_feat {
 	XLOG_INCOMPAT_FEAT_XATTRS = XFS_SB_FEAT_INCOMPAT_LOG_XATTRS,
+	XLOG_INCOMPAT_FEAT_SWAPEXT = XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT
 };
 
 void xlog_use_incompat_feat(struct xlog *log, enum xlog_incompat_feat what);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 304aed840f962..32acdecdc1fa3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -453,6 +453,7 @@ struct xlog {
 
 	/* Users of log incompat features should take a read lock. */
 	struct rw_semaphore	l_incompat_xattrs;
+	struct rw_semaphore	l_incompat_swapext;
 };
 
 /*

