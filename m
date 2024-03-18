Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035355E41
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798637; cv=none; b=bTmNsNBBKoaD5ZLrqe/Oz2zWHGXT+qMXFh/mX2jGYmqzdaTggwo5QRV9WfLyuS8laCzsPrnYwf0QMfVEz57RROcQ+jSYNPoyRFNiTs4yhZvf3B8JLllG88EtFAZn9FyUzECCPOk+Y3l+rakVqJhifDRtVtLSysus4MdczLUg3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798637; c=relaxed/simple;
	bh=/9D3d9AmBVKBugsdt/81PpqHWCzhILYySLuUb0LfKgw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hV2++49Xf4lSTd9iFCPav2umwRyE7Ohp7xhPwR9VyE2v251wUhfpQACq+7AGd1QEJMyHx/lO/2/GKTdHHWzZrql7Al5f+ZOssYa2ZHpYDQwf8FNOzGQ/n8dhakqwAaupfhkozRpC513RK7ITc5xyOkdP7dMLSxsB/bywgPln4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IP0bvIiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IP0bvIiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBD3C433C7;
	Mon, 18 Mar 2024 21:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798636;
	bh=/9D3d9AmBVKBugsdt/81PpqHWCzhILYySLuUb0LfKgw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IP0bvIiX2Vv3mr/ehdy8Kcanx3xXAwZ3ww48KxJWSNEvtUJWjv57lhG/OGLqzwQ2O
	 yg0GLVyA6MiQX1fMWNXzzcaYR+bPd1cd8SQdY1l4hasEJTTZy/w6Jk9wV4IrfyCRXC
	 fdtAu2Ye88JUAEWeB3DWQvqX+sN2ghUlCiDeniq4tY3cJYUwBHLtpGYn2hoIKB0lZh
	 /U/X6qChhz4pAHeIs957mo4hCCnvk0HWiQ4n8ok+WvpWzZSFRXpu6q77bJAeV0YJ3O
	 Qc20Go4Qy1Lw64sKA7lS/S3AX3bP8zHMgST8PZ+mQf6c3NI/6lMKViO9cjgtb86qb4
	 dwi9hKzMTarvw==
Date: Mon, 18 Mar 2024 14:50:36 -0700
Subject: [PATCH 10/23] xfs: salvage parent pointers when rebuilding xattr
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802857.3808642.15148327756269402709.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

When we're salvaging extended attributes, make sure we validate the ones
that claim to be parent pointers before adding them to the salvage pile.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr_repair.c |   42 +++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.h       |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index ae595951be71c..2661bc97e9900 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_acl.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -127,6 +128,14 @@ xrep_xattr_want_salvage(
 		return false;
 	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
 		return false;
+	if (attr_flags & XFS_ATTR_PARENT) {
+		if (!xfs_has_parent(rx->sc->mp))
+			return false;
+		if (!xfs_parent_namecheck(rx->sc->mp, name, namelen,
+				attr_flags))
+			return false;
+		return xfs_parent_valuecheck(rx->sc->mp, value, valuelen);
+	}
 	return true;
 }
 
@@ -154,14 +163,21 @@ xrep_xattr_salvage_key(
 	 * Truncate the name to the first character that would trip namecheck.
 	 * If we no longer have a name after that, ignore this attribute.
 	 */
-	while (i < namelen && name[i] != 0)
-		i++;
-	if (i == 0)
-		return 0;
-	key.namelen = i;
+	if (flags & XFS_ATTR_PARENT) {
+		key.namelen = namelen;
 
-	trace_xrep_xattr_salvage_rec(rx->sc->ip, flags, name, key.namelen,
-			valuelen);
+		trace_xrep_xattr_salvage_pptr(rx->sc->ip, flags, name,
+				key.namelen, value, valuelen);
+	} else {
+		while (i < namelen && name[i] != 0)
+			i++;
+		if (i == 0)
+			return 0;
+		key.namelen = i;
+
+		trace_xrep_xattr_salvage_rec(rx->sc->ip, flags, name,
+				key.namelen, valuelen);
+	}
 
 	error = xfblob_store(rx->xattr_blobs, &key.name_cookie, name,
 			key.namelen);
@@ -565,6 +581,9 @@ xrep_xattr_insert_rec(
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
 	int				error;
 
+	if (key->flags & XFS_ATTR_PARENT)
+		args.op_flags |= XFS_DA_OP_NVLOOKUP;
+
 	/*
 	 * Grab pointers to the scrub buffer so that we can use them to insert
 	 * attrs into the temp file.
@@ -598,8 +617,13 @@ xrep_xattr_insert_rec(
 
 	ab->name[key->namelen] = 0;
 
-	trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags, ab->name,
-			key->namelen, key->valuelen);
+	if (key->flags & XFS_ATTR_PARENT)
+		trace_xrep_xattr_insert_pptr(rx->sc->tempip, key->flags,
+				ab->name, key->namelen, ab->value,
+				key->valuelen);
+	else
+		trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags,
+				ab->name, key->namelen, key->valuelen);
 
 	/*
 	 * xfs_attr_set creates and commits its own transaction.  If the attr
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7fb6990010789..46e2ded8b77fb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2533,6 +2533,46 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_salvage_rec);
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_insert_rec);
 
+DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name,
+		 unsigned int namelen, const void *value, unsigned int valuelen),
+	TP_ARGS(ip, flags, name, namelen, value, valuelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, valuelen)
+	),
+	TP_fast_assign(
+		struct xfs_parent_name_irec	pptr;
+
+		xfs_parent_irec_from_disk(&pptr, name, value, valuelen);
+
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = pptr.p_ino;
+		__entry->parent_gen = pptr.p_gen;
+		__entry->namelen = pptr.p_namelen;
+		memcpy(__get_str(name), pptr.p_name, pptr.p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_SALVAGE_EVENT(name) \
+DEFINE_EVENT(xrep_pptr_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name, \
+		 unsigned int namelen, const void *value, unsigned int valuelen), \
+	TP_ARGS(ip, flags, name, namelen, value, valuelen))
+DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_salvage_pptr);
+DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_insert_pptr);
+
 TRACE_EVENT(xrep_xattr_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip),
 	TP_ARGS(ip, arg_ip),

