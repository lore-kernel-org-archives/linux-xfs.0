Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E37DBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qeugsk3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEE7C433C7;
	Sun, 31 Dec 2023 20:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056148;
	bh=gdkb+v7R1wApk5ryGYe7Bg3XezkfrVlA+1qZIKhaDoU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qeugsk3uERrvinH8fuKow+9CFDYcQNK3HRLu0fVCEcsj0+HYyxOqDimk8fX+ztiN9
	 3QEFLO4hd2iIAfTPqkd6DdOSyiJtzOHFTVZFypwlbZj0UJA6rMRtkU1fjVybC/pi+O
	 PLPumUvqz8XxnLNKOMSDJ+D600IRS19bbbmsFzkZzlxDAthqAWKC6jg9zO0/UgtKmg
	 JULnetEWx8blv6IPhvVBjP1KKF5UjpHbDWSnjb7kKZx4SWeK6QwabfpvkwLgfQ6wP/
	 3FrURmeBg8zw56jIXYSNKSnaMlCkUC6N3W9cfrPKs5CezWYe8l+qqhbN30nHgIuTEA
	 70sflTPddW4ow==
Date: Sun, 31 Dec 2023 12:55:48 -0800
Subject: [PATCH 10/22] xfs: replace namebuf with parent pointer in directory
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841908.1757392.15682934584944618427.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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

Replace the dirent name buffer at the end of struct xrep_dir with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index e74f456c7b444..13a1a3ef5e714 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
 #include "xfs_ag.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -131,8 +132,14 @@ struct xrep_dir {
 	/* Should we move this directory to the orphanage? */
 	bool			needs_adoption;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for reading parent pointers from child files.  The
+	 * p_name field is used to flush stashed dirents into the temporary
+	 * directory in between parent pointers.  At the very end of the
+	 * repair, it can also be used to compute the lost+found filename
+	 * if we need to reparent the directory.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -696,7 +703,7 @@ xrep_dir_replay_update(
 	struct xfs_name			name = {
 		.len			= dirent->namelen,
 		.type			= dirent->ftype,
-		.name			= rd->namebuf,
+		.name			= rd->pptr.p_name,
 	};
 	struct xfs_mount		*mp = rd->sc->mp;
 #ifdef DEBUG
@@ -773,10 +780,10 @@ xrep_dir_replay_updates(
 
 		/* The dirent name is stored in the in-core buffer. */
 		error = xfblob_load(rd->dir_names, dirent.name_cookie,
-				rd->namebuf, dirent.namelen);
+				rd->pptr.p_name, dirent.namelen);
 		if (error)
 			return error;
-		rd->namebuf[MAXNAMELEN - 1] = 0;
+		rd->pptr.p_name[MAXNAMELEN - 1] = 0;
 
 		error = xrep_dir_replay_update(rd, &dirent);
 		if (error)
@@ -1416,7 +1423,7 @@ xrep_dir_move_to_orphanage(
 	if (error)
 		return error;
 
-	error = xrep_adoption_compute_name(&rd->adoption, rd->namebuf);
+	error = xrep_adoption_compute_name(&rd->adoption, rd->pptr.p_name);
 	if (error)
 		return error;
 

