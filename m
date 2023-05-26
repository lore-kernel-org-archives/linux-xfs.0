Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9873AC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjEZCQb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjEZCQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2718F13D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B87EC60DCE
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C61C433D2;
        Fri, 26 May 2023 02:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067384;
        bh=aQM0ydoJSP1MBH02CwqhzzRiYaHIwtF6egC6KDcEWL8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JX0D6J3BiPGQn+J7V8wMNBfIHp+XKM7P+stJn1sJRg3Ab3QBbleRGqlzvNJw321Fi
         BAaRFFxmy0fIIKwDCR/17qLRybn561Sg1GH8SytW/cj/llpVjO+6vfUlu+HdvBR/OQ
         PEebom+RNRCZFXaIpHsRpVVW9My8zj3FJguyN6uNpeOq1SyliOQMsF+yNdGm9s+qOl
         FExz7lM/tE25O9Qd5tpCnU55hOawcCT7HDQvP92NFBORJKbVxvPvRvM0FWL0IyLpLz
         Wi/+ih5mm+vvjL32fIrFGzhCrzRDsBn1yLyNLJ7Hl7W2nOjnqoXElQqqCevjSStBVv
         cqbsz+QJJ1mZw==
Date:   Thu, 25 May 2023 19:16:23 -0700
Subject: [PATCH 07/17] xfs: salvage parent pointers when rebuilding xattr
 structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073396.3745075.1972680528979448636.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're salvaging extended attributes, make sure we validate the ones
that claim to be parent pointers before adding them to the salvage pile.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr_repair.c |   41 ++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.c       |    1 +
 fs/xfs/scrub/trace.h       |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 1d5bacbe1b81..489abe1f028a 100644
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
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 18a1a3d1cbef..913f886380c0 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -18,6 +18,7 @@
 #include "xfs_dir2.h"
 #include "xfs_da_format.h"
 #include "xfs_rmap.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 28232e4611d7..c64594f20f73 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2481,6 +2481,46 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
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
+#define DEFINE_XREP_PPTR_SALVAGE_CLASS(name) \
+DEFINE_EVENT(xrep_pptr_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name, \
+		 unsigned int namelen, const void *value, unsigned int valuelen), \
+	TP_ARGS(ip, flags, name, namelen, value, valuelen))
+DEFINE_XREP_PPTR_SALVAGE_CLASS(xrep_xattr_salvage_pptr);
+DEFINE_XREP_PPTR_SALVAGE_CLASS(xrep_xattr_insert_pptr);
+
 TRACE_EVENT(xrep_xattr_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip),
 	TP_ARGS(ip, arg_ip),

