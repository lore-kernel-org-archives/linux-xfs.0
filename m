Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B147ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETjxV5wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D429C433C8;
	Mon,  1 Jan 2024 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068519;
	bh=aEoYIRyIy5kN1J+XfkFP7gvMIPr5+aLcYQX7cj9kBFo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ETjxV5wldepX+FvyACiBNCfey1X5fl9j/G4gXoRev7IeZcfPpcp6IsbWumEn2tkcX
	 /7noO5ZdU/hf6sLhXek29legqLfvvD3f8y93w2Bw9QaXaed3mo86+nxMBKSzDH6i7f
	 MEahM3Ho52m33aTLxNU+cuoZd0H4geoc6JOgAMnezEd7eo8lR5lqYxbgPRID7Npkub
	 9S4tQb/HcTOksRuUVdP4ezpnF7l/upGzeboPWtfu25KFS0nqot6PD/e/gVnpiKkiFq
	 sRbHL27OdN/CPE4iIikZDavoZ+KvxzJIa9kPiOIQjktya8Fnfg+rK+ppS+lLgGC4RZ
	 nicJ5YlM+FTzw==
Date: Sun, 31 Dec 2023 16:21:58 +9900
Subject: [PATCH 44/47] xfs_repair: reserve per-AG space while rebuilding rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015899.1815505.4353601872526248570.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Realtime metadata btrees can consume quite a bit of space on a full
filesystem.  Since the metadata are just regular files, we need to
make the per-AG reservations to avoid overfilling any of the AGs while
rebuilding metadata.  This avoids the situation where a filesystem comes
straight from repair and immediately trips over not having enough space
in an AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    1 +
 repair/phase6.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index 3ab93158cf7..72f38938f69 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -94,6 +94,7 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase6.c b/repair/phase6.c
index ab5c22ffbb0..fd862362f1d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3997,10 +3997,43 @@ reset_rt_metadata_inodes(
 	}
 }
 
+static int
+reserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	int			err2;
+
+	mp->m_finobt_nores = false;
+
+	for_each_perag(mp, agno, pag) {
+		err2 = -libxfs_ag_resv_init(pag, NULL);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
+}
+
+static void
+unreserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag(mp, agno, pag)
+		libxfs_ag_resv_free(pag);
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
+	bool			reserve_perag;
+	int			error;
 	int			i;
 
 	parent_ptr_init(mp);
@@ -4040,6 +4073,17 @@ phase6(xfs_mount_t *mp)
 		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
+	reserve_perag = xfs_has_realtime(mp) && !no_modify;
+	if (reserve_perag) {
+		error = reserve_ag_blocks(mp);
+		if (error) {
+			if (error != ENOSPC)
+				do_warn(
+	_("could not reserve per-AG space to rebuild realtime metadata"));
+			reserve_perag = false;
+		}
+	}
+
 	if (need_rbmino)  {
 		if (!no_modify)  {
 			if (need_rbmino > 0)
@@ -4078,6 +4122,9 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	if (reserve_perag)
+		unreserve_ag_blocks(mp);
+
 	reattach_metadir_quota_inodes(mp);
 
 	mark_standalone_inodes(mp);

