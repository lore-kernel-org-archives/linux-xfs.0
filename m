Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6105DAD25
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOnADMMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE13CC433C7;
	Sun, 31 Dec 2023 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057399;
	bh=/eOJZgW5kCYoIULdBdw7UOfx/TTiccdT7WXC7LMaF9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FOnADMMf3xihcbzOHQ4xvAS1iqtph8WMBqLL5pbmDh58nIp6wuQH/n88aF87ADllm
	 P9/Q6TRkPtZkanFFruiVVBzpjPc+02HuJk0/QPxflqovGyATs/SHIjFbnmh7Fyk1i4
	 0jb36OU2uekzsA5CNct9cchIkzBP2PJMoDZXqK/HP8cgRFeOAaTkoIDwKyhOt0+y3p
	 EqoEOSuQfyfAyr/+phXk/HymHl9lVx9mr3khjAFQR7km8rHVQbCJANv/UudGA03f+Q
	 vEhd81HSeZdR3hRdPmeyoLWUE7EBS1ba0XovVWV92NCE9WiaSgWv8M4nGWAVxxtfGb
	 GEU+F708T0zIQ==
Date: Sun, 31 Dec 2023 13:16:39 -0800
Subject: [PATCH 04/24] xfs: check the realtime superblock at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846306.1763124.5318728014535151147.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Check the realtime superblock at mount time, to ensure that the label
actually matches the primary superblock.  If the rt superblock is good,
attach it to the xfs_mount so that the log can use ordered buffers to
keep this primary in sync with the primary super on the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h   |    1 +
 fs/xfs/xfs_rtalloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    5 +++++
 fs/xfs/xfs_super.c   |   16 ++++++++++++++--
 4 files changed, 70 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 52976a133cec9..7e86aa137d1fa 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -85,6 +85,7 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
+	struct xfs_buf		*m_rtsb_bp;	/* realtime superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ba9116b6e8de7..430d63e5ba751 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1252,6 +1252,56 @@ xfs_rtallocate_extent(
 	return 0;
 }
 
+/* Read the primary realtime group's superblock and attach it to the mount. */
+int
+xfs_rtmount_readsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+	if (mp->m_sb.sb_rblocks == 0)
+		return 0;
+	if (mp->m_rtdev_targp == NULL) {
+		xfs_warn(mp,
+	"Filesystem has a realtime volume, use rtdev=device option");
+		return -ENODEV;
+	}
+
+	/* m_blkbb_log is not set up yet */
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
+			&xfs_rtsb_buf_ops);
+	if (error) {
+		xfs_warn(mp, "rt sb validate failed with error %d.", error);
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
+	}
+
+	mp->m_rtsb_bp = bp;
+	xfs_buf_unlock(bp);
+	return 0;
+}
+
+/* Detach the realtime superblock from the mount and free it. */
+void
+xfs_rtmount_freesb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp = mp->m_rtsb_bp;
+
+	if (!bp)
+		return;
+
+	xfs_buf_lock(bp);
+	mp->m_rtsb_bp = NULL;
+	xfs_buf_relse(bp);
+}
+
 /*
  * Initialize realtime fields in the mount structure.
  */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index f7cb9ffe51ca6..b982b97cf073f 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -33,6 +33,9 @@ xfs_rtallocate_extent(
 	xfs_rtxnum_t		*rtblock); /* out: start rtext allocated */
 
 
+int xfs_rtmount_readsb(struct xfs_mount *mp);
+void xfs_rtmount_freesb(struct xfs_mount *mp);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -79,6 +82,8 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
+# define xfs_rtmount_readsb(mp)				(0)
+# define xfs_rtmount_freesb(mp)				((void)0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c154e2cb7a18e..f3a5e194c535b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext_item.h"
 #include "xfs_parent.h"
+#include "xfs_rtalloc.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -1152,6 +1153,7 @@ xfs_fs_put_super(
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
+	xfs_rtmount_freesb(mp);
 	xfs_freesb(mp);
 	xchk_mount_stats_free(mp);
 	free_percpu(mp->m_stats.xs_stats);
@@ -1671,9 +1673,13 @@ xfs_fs_fill_super(
 		goto out_free_sb;
 	}
 
+	error = xfs_rtmount_readsb(mp);
+	if (error)
+		goto out_free_sb;
+
 	error = xfs_filestream_mount(mp);
 	if (error)
-		goto out_free_sb;
+		goto out_free_rtsb;
 
 	/*
 	 * we must configure the block size in the superblock before we run the
@@ -1717,6 +1723,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 "EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
 
+	if (xfs_has_rtgroups(mp))
+		xfs_warn(mp,
+"EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!");
+
 	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,
@@ -1761,6 +1771,8 @@ xfs_fs_fill_super(
 
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
+ out_free_rtsb:
+	xfs_rtmount_freesb(mp);
  out_free_sb:
 	xfs_freesb(mp);
  out_free_scrub_stats:
@@ -1780,7 +1792,7 @@ xfs_fs_fill_super(
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	goto out_free_sb;
+	goto out_free_rtsb;
 }
 
 static int

