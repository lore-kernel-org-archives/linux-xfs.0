Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF378F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608533; cv=none; b=kd3sDtcDc/7U2KwnlX2RoUQweafTwp2CR2M5y22wS5YUR93A8OZpfUijv+DqFPZSh4/vGFxI+Av4yhWg6hUs8MxV6WUJr7OFCzGRUTsUZ7LlFN99r2BO1wK1Qi0k6Z6JEedVrNYPW5W4mzhUnFTFOjw6krqulaE38I1TeLO2j58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608533; c=relaxed/simple;
	bh=urcu5MbnlIx+UKaVW3RzWwo1B9B2x0pIjSdcP2ivbbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LAQgcAJXrMZFPfZrUwrO+UeiNkQ9ptFv/cH0ZGex+89dlgePbBe4YW40MZdnR+bj7j2V/4f8wbbXgqHdmPCU/5NOJvqUj6wG7CBGuapS5KHlLmcl7BYP6bhQMHeOCHKUaHSdNl/DTyfo+YkYPD9NFcDRSjjj2Fv1nwIM9YgWtTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfnindcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfnindcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182CEC4CEC5;
	Fri, 11 Oct 2024 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608533;
	bh=urcu5MbnlIx+UKaVW3RzWwo1B9B2x0pIjSdcP2ivbbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WfnindcFaKWwBVv6nYE5pn+oYOPz75bg9e6wggRYybdeyR5+GNEWWfH5J/HNpbXgV
	 hSyjCWkccNm1QvfvPNCXTt42V2V2htJti7EIbTBUpSh9xwmvu054WfFNsBbp3ZZP9y
	 2+IRH6ba1fSb8c+9f0xqauS/sOFBTl9xJArx41IjET85fbWiLn7wcd6p/QKzwwvUBE
	 Kt3nIvr9AhUHc1Q70FcEu50h9cNayJZPV77KWLseZRBO4PcqTvJcyQT+/M/5Jw3gJc
	 +kRKPEWpe9XgNv9Y97KvywtcxW5x57LOqw4QPnGDBwAAp+q2fmEFcDZwOLNsPqQsyi
	 IG24enDlh5ZRA==
Date: Thu, 10 Oct 2024 18:02:12 -0700
Subject: [PATCH 02/36] xfs: check the realtime superblock at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644273.4178701.7807667633966664905.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
and uuids actually match the primary superblock on the data device.  If
the rt superblock is good, attach it to the xfs_mount so that the log
can use ordered buffers to keep this primary in sync with the primary
super on the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h   |    1 +
 fs/xfs/xfs_rtalloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    6 ++++++
 fs/xfs/xfs_super.c   |   12 ++++++++++--
 4 files changed, 67 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d477d2f60d7a33..f43d5655022263 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -89,6 +89,7 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
+	struct xfs_buf		*m_rtsb_bp;	/* realtime superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 866274a66d4d28..27186fcfdcde73 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1152,6 +1152,56 @@ xfs_growfs_rt(
 	return error;
 }
 
+/* Read the realtime superblock and attach it to the mount. */
+int
+xfs_rtmount_readsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_has_rtsb(mp))
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
index a6836da9bebef5..8e2a07b8174b74 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -12,6 +12,10 @@ struct xfs_mount;
 struct xfs_trans;
 
 #ifdef CONFIG_XFS_RT
+/* rtgroup superblock initialization */
+int xfs_rtmount_readsb(struct xfs_mount *mp);
+void xfs_rtmount_freesb(struct xfs_mount *mp);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -42,6 +46,8 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
+# define xfs_rtmount_readsb(mp)				(0)
+# define xfs_rtmount_freesb(mp)				((void)0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6d6eb41c042e4c..503db1308515dd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_exchmaps_item.h"
 #include "xfs_parent.h"
+#include "xfs_rtalloc.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -1145,6 +1146,7 @@ xfs_fs_put_super(
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
+	xfs_rtmount_freesb(mp);
 	xfs_freesb(mp);
 	xchk_mount_stats_free(mp);
 	free_percpu(mp->m_stats.xs_stats);
@@ -1692,9 +1694,13 @@ xfs_fs_fill_super(
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
@@ -1786,6 +1792,8 @@ xfs_fs_fill_super(
 
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
+ out_free_rtsb:
+	xfs_rtmount_freesb(mp);
  out_free_sb:
 	xfs_freesb(mp);
  out_free_scrub_stats:
@@ -1805,7 +1813,7 @@ xfs_fs_fill_super(
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	goto out_free_sb;
+	goto out_free_rtsb;
 }
 
 static int

