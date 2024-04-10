Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC21621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711022; cv=none; b=FSx2CIVN7kV365Ux3lpzY9aUdvHbmvO6tny+66UeCwg50PNY0u/8VTGrKxFLj/3ntsCzZ0OY0ojOKobsGqJ6UNhaNnv57Wjs9+t9M8fUNBwGR2aPZxR6tq/QeOb3/4lGa/QCK92g3CvW9xFT4iPdld0+JUombIPZxdqmWRXiP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711022; c=relaxed/simple;
	bh=9uxYOvA/TDMS6M7Yb+Qzg/SxrYeMPsUXyXDGau5bePE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AophBSV1hM5SbVTQSEEnuduZKGDnDmiKbdwRvXsPrRhc6iF0h7chDOf9anwG6lxmXQTZ7DocpLJT2IsPW4/CfQ1221aILtG4bI5MQliP8x0nOsnggN9DQUZqRb/fg6jC9ohv9kZl4RlnK5AUug/vHD8hoo13CqFTpl4u0+aM7Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB8KFoE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB8KFoE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81662C433C7;
	Wed, 10 Apr 2024 01:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711021;
	bh=9uxYOvA/TDMS6M7Yb+Qzg/SxrYeMPsUXyXDGau5bePE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UB8KFoE5svXQWJlr4Y40o6/zfTOgmIfMON3M59kL/zqtKb1tV3gK4/IPJwhZ2BXiM
	 JEp15cG5mAzhPhttWePivd4Ld/4rCz5zXO3ZTrDJBOJEPYNfrLyKm/u3bCeUTlgzkh
	 Uc48TNRxPtxLzMo7854wkfpQS8Iwas1Aq5IMAfjvi4vNlk/Iie0ZlhR0Hyo6B6sgxr
	 JDCeO8i2sUK2QqqVvg/No8ODOoWyDWjVGgQDa9B0Ntz4ccp5sG6b66f95wp0g0OmnW
	 JlmNorVWBPf95igvyTpro5F9Q14QC4Wjp9srIJJ9bggJFNueql9oXZoCjdwh+W0aZ6
	 S2gr6Z5uT0IZA==
Date: Tue, 09 Apr 2024 18:03:41 -0700
Subject: [PATCH 7/7] xfs: salvage parent pointers when rebuilding xattr
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970583.3632713.16977275276286469285.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr_repair.c |   34 +++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.h       |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 7228758c2da1a..091cef077cdde 100644
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
@@ -127,6 +128,9 @@ xrep_xattr_want_salvage(
 		return false;
 	if (valuelen > XATTR_SIZE_MAX || valuelen < 0)
 		return false;
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_valuecheck(rx->sc->mp, value, valuelen);
+
 	return true;
 }
 
@@ -154,14 +158,21 @@ xrep_xattr_salvage_key(
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
@@ -596,8 +607,13 @@ xrep_xattr_insert_rec(
 
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
index 3e726610b9e32..4b968df3d840c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2540,6 +2540,44 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
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
+		__dynamic_array(char, name, namelen)
+	),
+	TP_fast_assign(
+		const struct xfs_parent_rec	*rec = value;
+
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = be64_to_cpu(rec->p_ino);
+		__entry->parent_gen = be32_to_cpu(rec->p_gen);
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
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

