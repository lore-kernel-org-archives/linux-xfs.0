Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF2C391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711209; cv=none; b=Yo0PybjUJEMmd93zq1BFbxt/oiYnb6MT3wLdMYOJDQTJA80SfuUHWarPD0vaiCGMIX1JsrzS0wfErp8L7fhSS0s9bSu0GMbh+pv0NT4nD195LaTHlSbTlBY2SEkeJMZl9guOGsHmjOTKeXaEsocZEI1FA0FS5aIbnVy3RLXbij0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711209; c=relaxed/simple;
	bh=r6lX3IqHuo/fUrQBmbGGO/V8/cM2bvve8KQQRMX/pBU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjU0MwTCgP5NzFx64hC3ayfKbLyMjug0+QQRANi+bIrvfhc+gm0/KU8sDKK00vs3m8AiJJxDjamcycIBRsTsrQOyHffbRASOYq3iNZ5Whfy2p6BRX0Xp1mjF2vPyqJGCRUzULrB+Ds7JAU4T4VpoIpUNTaglr5eD3vFWn3VILwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esDmZh1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esDmZh1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBA5C433F1;
	Wed, 10 Apr 2024 01:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711209;
	bh=r6lX3IqHuo/fUrQBmbGGO/V8/cM2bvve8KQQRMX/pBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=esDmZh1jMB4KXVDjjB8DnKMFfjN1TxXa6lBs0HltDGs3gGmt2NSG9Ra6tdkmcwwCH
	 REuXexOafrU+2ZCDllG7LPKo6PW9XpkaHaOJh3z/7LWDKAddLtP0IErHplyXy+z4hb
	 yiT6xTP4fNjV4h129fZqdlVKGCM5sRwrc/aebgE3bWUmICY37TOffQscGglRyoPAey
	 OQHah2FG4ejJHs6QaqWoBT/vt4mnXjiYbRr76h58+bTvFR6CeT6wH3uP5/2yS6S3Rj
	 FfIXxwSCWFE+uXy+cVPD19s35Al7zCX97ycQLmCQjKjESblp8JaOn9Jhv9V0L73XJy
	 F4/Ici5/lx5Dw==
Date: Tue, 09 Apr 2024 18:06:49 -0700
Subject: [PATCH 12/14] xfs: adapt the orphanage code to handle parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971187.3632937.7590627404157821233.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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

Adapt the orphanage's adoption code to update the child file's parent
pointers as part of the reparenting process.  Also ensure that the child
has an attr fork to receive the parent pointer update, since the runtime
code assumes one exists.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |   38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h |    3 +++
 fs/xfs/scrub/scrub.c     |    2 ++
 3 files changed, 43 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 94bcc2799188f..b2f905924d0d8 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -19,6 +19,8 @@
 #include "xfs_icache.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_parent.h"
+#include "xfs_attr_sf.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -330,6 +332,8 @@ xrep_adoption_trans_alloc(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		child_blkres = xfs_rename_space_res(mp, 0, false,
 						    xfs_name_dotdot.len, false);
+	if (xfs_has_parent(mp))
+		child_blkres += XFS_ADDAFORK_SPACE_RES(mp);
 	adopt->child_blkres = child_blkres;
 
 	/*
@@ -503,6 +507,19 @@ xrep_adoption_zap_dcache(
 	dput(d_orphanage);
 }
 
+/*
+ * If we have to add an attr fork ahead of a parent pointer update, how much
+ * space should we ask for?
+ */
+static inline int
+xrep_adoption_attr_sizeof(
+	const struct xrep_adoption	*adopt)
+{
+	return sizeof(struct xfs_attr_sf_hdr) +
+		xfs_attr_sf_entsize_byname(sizeof(struct xfs_parent_rec),
+					   adopt->xname->len);
+}
+
 /*
  * Move the current file to the orphanage under the computed name.
  *
@@ -524,6 +541,19 @@ xrep_adoption_move(
 	if (error)
 		return error;
 
+	/*
+	 * If this filesystem has parent pointers, ensure that the file being
+	 * moved to the orphanage has an attribute fork.  This is required
+	 * because the parent pointer code does not itself add attr forks.
+	 */
+	if (!xfs_inode_has_attr_fork(sc->ip) && xfs_has_parent(sc->mp)) {
+		int sf_size = xrep_adoption_attr_sizeof(adopt);
+
+		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size, true);
+		if (error)
+			return error;
+	}
+
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, adopt->xname,
 			sc->ip->i_ino, adopt->orphanage_blkres);
@@ -548,6 +578,14 @@ xrep_adoption_move(
 			return error;
 	}
 
+	/* Add a parent pointer from the file back to the lost+found. */
+	if (xfs_has_parent(sc->mp)) {
+		error = xfs_parent_addname(sc->tp, &adopt->ppargs,
+				sc->orphanage, adopt->xname, sc->ip);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Notify dirent hooks that we moved the file to /lost+found, and
 	 * finish all the deferred work so that we know the adoption is fully
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
index 319179ab788d3..beb6b686784e6 100644
--- a/fs/xfs/scrub/orphanage.h
+++ b/fs/xfs/scrub/orphanage.h
@@ -54,6 +54,9 @@ struct xrep_adoption {
 	/* Name used for the adoption. */
 	struct xfs_name		*xname;
 
+	/* Parent pointer context tracking */
+	struct xfs_parent_args	ppargs;
+
 	/* Block reservations for orphanage and child (if directory). */
 	unsigned int		orphanage_blkres;
 	unsigned int		child_blkres;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ebb06838c31be..7b1f1abdc7a98 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -19,6 +19,8 @@
 #include "xfs_rmap.h"
 #include "xfs_exchrange.h"
 #include "xfs_exchmaps.h"
+#include "xfs_dir2.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"

