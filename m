Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CBEC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 04:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AF623158
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 04:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbhATEcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 23:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbhATEcK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 23:32:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F35E23131;
        Wed, 20 Jan 2021 04:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611117089;
        bh=UcoRoEAM79Bu5oHbRl7mqn1+lj6gJVA9KjRoo45v39o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8bMfrqwC5xXZ7BsRHkE81iD25khASufkxkE/HAWgt4NvG+o6kZDOdWK09pQsP5fd
         I3APT5d4MZGc22RD6k/qsccJGpmb9c8HDyI9lQD3LIS55fJNLNJw6FZLcIQEUPri0r
         l/YKj03XId8ykOoIpGEWAlRqed8uCHC+ECVlMwj6rmrIKMXIBwW45lbtyrAiIR4hAQ
         pF0pCilDQ+zcAF7DZIVkpLFIsDU5u36/Af3YqmU+pdUdG+j/KeaFOXZ+9Zvr4ZRVf2
         o2X/8oe541cKXaAJ1FnaJ0ejNcKAdJ/R+7/O9nDHNb7jsbqr+h6QCW1TRzGDaw0IAx
         eeSF03DWLBZjg==
Date:   Tue, 19 Jan 2021 20:31:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2.1 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210120043128.GX3134581@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161076029319.3386490.2011901341184065451.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2.1: only remove needsrepair at the end of the xfs_repair run
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |    2 +-
 repair/agheader.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/agheader.h   |    2 ++
 repair/xfs_repair.c |    4 +++-
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 36594643..75230ca5 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -181,6 +181,7 @@ xfs_perag_resv(
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 				dev_t, dev_t, dev_t, int);
+int libxfs_flush_mount(struct xfs_mount *mp);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 9fe13b8d..083060bf 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -870,7 +870,7 @@ _("%s: Flushing the %s failed, err=%d!\n"),
  * Flush all dirty buffers to stable storage and report on writes that didn't
  * make it to stable storage.
  */
-static int
+int
 libxfs_flush_mount(
 	struct xfs_mount	*mp)
 {
diff --git a/repair/agheader.c b/repair/agheader.c
index 8bb99489..56a7f45c 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -220,6 +220,40 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
 	return(XR_OK);
 }
 
+/* Clear needsrepair after a successful repair run. */
+int
+clear_needsrepair(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_sb_version_needsrepair(&mp->m_sb) || no_modify)
+		return 0;
+
+	/* We must succeed at flushing all dirty buffers to disk. */
+	error = -libxfs_flush_mount(mp);
+	if (error)
+		return error;
+
+	/* Clear needsrepair from the superblock. */
+	bp = libxfs_getsb(mp);
+	if (!bp)
+		return ENOMEM;
+	if (bp->b_error) {
+		error = bp->b_error;
+		libxfs_buf_relse(bp);
+		return -error;
+	}
+
+	mp->m_sb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
+	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+	libxfs_buf_mark_dirty(bp);
+	libxfs_buf_relse(bp);
+	return 0;
+}
+
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -452,6 +486,27 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!no_modify)
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		if (i == 0) {
+			if (!no_modify)
+				do_warn(
+	_("clearing needsrepair flag and regenerating metadata\n"));
+			else
+				do_warn(
+	_("would clear needsrepair flag and regenerate metadata\n"));
+		} else {
+			/*
+			 * Quietly clear needsrepair on the secondary supers as
+			 * part of ensuring them.  If needsrepair is set on the
+			 * primary, it will be done at the very end of repair.
+			 */
+			rval |= XR_AG_SB_SEC;
+		}
+	}
+
 	return(rval);
 }
 
diff --git a/repair/agheader.h b/repair/agheader.h
index a63827c8..552c1f70 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -82,3 +82,5 @@ typedef struct fs_geo_list  {
 #define XR_AG_AGF	0x2
 #define XR_AG_AGI	0x4
 #define XR_AG_SB_SEC	0x8
+
+int clear_needsrepair(struct xfs_mount *mp);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9409f0d8..d36c5a21 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1133,7 +1133,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	format_log_max_lsn(mp);
 
 	/* Report failure if anything failed to get written to our fs. */
-	error = -libxfs_umount(mp);
+	error = clear_needsrepair(mp);
+	if (!error)
+		error = -libxfs_umount(mp);
 	if (error)
 		do_error(
 	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
