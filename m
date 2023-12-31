Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72EBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5miBxkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE803C433C7;
	Sun, 31 Dec 2023 20:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056132;
	bh=Hr+qeTsHrsqVdYcuuf93Dh3Ap0WQdNuMwalY6xZLdZs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T5miBxkN7RTNfLECEqy9blRgWObYmJXHKWbp+NvjW/BfjX/WxyjYMQlBD/yJ7u37l
	 QZ+OBcrmJGKFgWg6iPq9vdu/RyO74o16um9QkvcGL53MESkn/vKk5V7rzKJhyaYnNG
	 t5MZ5u1fqsAbKHvRJED0uFX0pDW5NhySN+3oD6ww78/vyXR65zrGlvg7/sOF/r+BhX
	 1bWnRwNJHAXJIuom3z/+O4nF/6KS1HoeghDGw+i+7N3jmuy7H+VtbXCpHxhGDUIMCi
	 GKEWvGZd3dRuX3s9SRwKNBauU8bb+xRhUd3OfFUFH0dCi1okW62aohIuXCnGmWa6Wj
	 MBDBSqzDxJsCg==
Date: Sun, 31 Dec 2023 12:55:32 -0800
Subject: [PATCH 09/22] xfs: salvage parent pointers when rebuilding xattr
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841892.1757392.12387417515945378983.stgit@frogsfrogsfrogs>
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

When we're salvaging extended attributes, make sure we validate the ones
that claim to be parent pointers before adding them to the salvage pile.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr_repair.c |   41 ++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.h       |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 9a88d46392626..39e64d7559451 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
 #include "xfs_acl.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -124,6 +125,13 @@ xrep_xattr_want_salvage(
 		return false;
 	if (valuelen > XATTR_SIZE_MAX || valuelen < 0)
 		return false;
+	if (attr_flags & XFS_ATTR_PARENT) {
+		if (!xfs_parent_namecheck(rx->sc->mp, name, namelen,
+				attr_flags))
+			return false;
+		if (!xfs_parent_valuecheck(rx->sc->mp, value, valuelen))
+			return false;
+	}
 	return true;
 }
 
@@ -151,14 +159,21 @@ xrep_xattr_salvage_key(
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
@@ -562,6 +577,9 @@ xrep_xattr_insert_rec(
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
 	int				error;
 
+	if (key->flags & XFS_ATTR_PARENT)
+		args.op_flags |= XFS_DA_OP_NVLOOKUP;
+
 	/*
 	 * Grab pointers to the scrub buffer so that we can use them to insert
 	 * attrs into the temp file.
@@ -595,8 +613,13 @@ xrep_xattr_insert_rec(
 
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
index d3a0cefea3684..8fa26a7811118 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2662,6 +2662,46 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
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

