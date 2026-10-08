Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DB438333A;
	Thu,  8 Oct 2026 05:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438954; cv=none; b=I64FBUAwXX82OlT7mhT11YGAO2u7gt+PgBwbwsstaIlET42CfTGD5WSM2eOXSwsmfbhLJDO9nTtPWqZ0gODxe5Nv/TwBCmS6ldCkTsk2cL2/qrbAaMYvBXa8u2A0KniWxCFzRxyLb+6CP3CrGw81Jp8zT2I8xALgXIL/OKwANgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438954; c=relaxed/simple;
	bh=2573JlehZmCVFt841k+rjnJJ4MfX7l/xZu+FOHCq5DI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMavY3aI6+HO1OGr91s3L6xQsDJFKbGJsjZuTuDsyXFob5XnIrF9dt47Rg84is89859HRx/mejqXjhMsNyaqcmEKs+hQYgUcp/Adb5ypLaR3DqmlWk1EHcooSICZ+let/HyGFm9qzNTPrNje+KWUYuKd4HEWVALzqpvSmVms8/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIXffG9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIXffG9y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 36D3A1F000FF;
	Thu,  8 Oct 2026 05:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438953;
	bh=FRR7a90arcoyL5gnAsZKMKaR+gdywlhvjOrHR85ilnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=QIXffG9yRI3xUpbk42DSCTaKA+UT8uqCGbgBfu37SJOGzHWr2hxk1dRAUxz3PVMos
	 B5kmwoEGUShbmJV7yF6Yqa0Wv3OdKxxvL51QUB7EBFdj5V/xOy8E/VKBQgXgi0YjYK
	 Yg4boQxsEsbd5CTiaFnVZwwvZengpSUYKeZmy3P4VZIawHPcvAAH4/puZjLHnsbF7Q
	 6dW3NDIwq9Z08NiNd3ggoqSsoeP6YrzyLk7C9ejlIoBHSesKJz/0Gv0WEb+2oc32pK
	 33pGnJ/0MooqZyil0o2+pWmYnMSJXijYo6uLn6/fi3Pbty0II5N0nNUt0NWCD+1jr/
	 4/P7hVTDcjuyA==
Date: Wed, 07 Oct 2026 22:55:52 -0700
Subject: [PATCH 04/12] xfs: reattach dquots after changing inode ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521342.2728617.2833089550706486434.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_inode_ids can change the user, group, or project
id of any given file.  When this happens, we need to detach any existing
incore dquot and attach the correct ones.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5ecccc75af2500..f8a7dd03f867cf 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -41,6 +41,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1748,6 +1750,31 @@ xrep_inode_blockcounts(
 	return 0;
 }
 
+static void
+xrep_inode_switch_dquot(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type,
+	struct xfs_dquot	**dqp)
+{
+#ifdef CONFIG_XFS_QUOTA
+	/*
+	 * We changed one of the file IDs, so we must detach the dquots to
+	 * prevent further changes from being accounted to them, and try to
+	 * attach the dquot for the new id to absorb any other block usage
+	 * changes.  Schedule a quotacheck so the accounting discrepancies will
+	 * get fixed eventually.
+	 */
+	xrep_force_quotacheck(sc, type);
+
+	if (*dqp != NULL) {
+		xfs_qm_dqrele(*dqp);
+		*dqp = NULL;
+	}
+
+	xfs_qm_dqget_inode(sc->ip, type, false, dqp);
+#endif
+}
+
 /* Check for invalid uid/gid/prid. */
 STATIC void
 xrep_inode_ids(
@@ -1761,21 +1788,24 @@ xrep_inode_ids(
 		i_uid_write(VFS_I(sc->ip), 0);
 		dirty = true;
 		if (XFS_IS_UQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+			xrep_inode_switch_dquot(sc, XFS_DQTYPE_USER,
+					&sc->ip->i_udquot);
 	}
 
 	if (!gid_valid(VFS_I(sc->ip)->i_gid)) {
 		i_gid_write(VFS_I(sc->ip), 0);
 		dirty = true;
 		if (XFS_IS_GQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+			xrep_inode_switch_dquot(sc, XFS_DQTYPE_GROUP,
+					&sc->ip->i_gdquot);
 	}
 
 	if (sc->ip->i_projid == -1U) {
 		sc->ip->i_projid = 0;
 		dirty = true;
 		if (XFS_IS_PQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+			xrep_inode_switch_dquot(sc, XFS_DQTYPE_PROJ,
+					&sc->ip->i_pdquot);
 	}
 
 	/* strip setuid/setgid if we touched any of the ids */

