Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88C9BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwwBTEtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F38C433C7;
	Sun, 31 Dec 2023 21:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057634;
	bh=5//ySmczwmtz2XgpwFe4TCs4eQeGTlsg3pu8hJVY7xs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WwwBTEtGvSWMkUwpTNQJ/qngOo0QhCg3blNXYobjLTAJB1RiCmnXZmrINfkQFYyGg
	 fnEm/uHwU+UbRjAOSth/H9MArkWF8oM8EK/1oJHe/0RaEqMdKh4GdNjBAcj+AEP002
	 DS/LtpAYggY0nx/JZEpRYy8WBvM07zfn6wI0s+MAu3ZNkkC7vMQJfKF4M5OBj28xfL
	 4ttY2EOxNzehKhALNm5ezxCWuVstjc4yf9d1Zl5GkteIPxxj83EbaTD4mGl3PWed6L
	 x4GTbvlW3POx/PeGIdYTFpZQHl3LTAgACCAMZly+W5vS9NT33gPsvbvi35sIiMdeoQ
	 RAd8mVJ4T5XAA==
Date: Sun, 31 Dec 2023 13:20:34 -0800
Subject: [PATCH 19/24] xfs: store rtgroup information with a bmap intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846544.1763124.14189276181526727693.stgit@frogsfrogsfrogs>
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

Make the bmap intent items take an active reference to the rtgroup
containing the space that is being mapped or unmapped.  We will need
this functionality once we start enabling rmap and reflink on the rt
volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.h |    5 ++++-
 fs/xfs/xfs_bmap_item.c   |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index bd7f936262cc6..61c195198db43 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -246,7 +246,10 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
-	struct xfs_perag			*bi_pag;
+	union {
+		struct xfs_perag		*bi_pag;
+		struct xfs_rtgroup		*bi_rtg;
+	};
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 02b872a133104..234296a37b269 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -26,6 +26,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -326,8 +327,18 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(mp)) {
+			xfs_rgnumber_t	rgno;
+
+			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
+			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+		} else {
+			bi->bi_rtg = NULL;
+		}
+
 		return;
+	}
 
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
@@ -358,8 +369,11 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
+			xfs_rtgroup_put(bi->bi_rtg);
 		return;
+	}
 
 	xfs_perag_intent_put(bi->bi_pag);
 }

