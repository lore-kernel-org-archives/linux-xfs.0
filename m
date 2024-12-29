Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A81802DD
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479618; cv=none; b=BOoFn15ZIn4Tm6caPRUJVKyJQ6UCcEYd8PWpHObpxfl8Aja0qbz/EnIWGSPGVXu7setyARkrLSGbwJzKs3zdfp9dcoTt9WOgoe4HmX5drlG/bnSLOFGBAZfloPjijvU7+bMhUk09IWLCHwLVyQPPa95FVeUlkWZSLIgT7GOTpSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479618; c=relaxed/simple;
	bh=pXNy5mdyaApodqdBWAxuwdlRdTctnri2FNMPiVW5+Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCy0a88vwdlSEZP827FD8RWf+anWAtXFpEn3u8136kVmPnN8vXfuCijUwveCVnrkJto0RnecD3yIjx6PLG9epdviCs4TnHlnsjZSXP27lZk88d8/eNQz0ds+YBeqdaESpKM/Kbcsf1/xFKTjkII2+KWOHOpmQVwvt7OfZONs9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DS/pitRR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DS/pitRR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4ozYW84s47q9Bj0WEH/x+ltj2loii9ZQPIFFtrz2aQ=;
	b=DS/pitRRW7l6GqKQbpTytXDPNXWd25HvWI1B+bmYkV2tg3ZEfluPyLL6aQ5MYKWQCbFKXv
	KnoqSXoQtEsNH69iw8/rgZnzdWmXyzxTaO9LF7qEXUOrmulokIesB+ieWKMPq5qjs547LI
	J18EZB1aT7QgH+UaSg1zEt8NhjcPD/U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-aeHfekJQMZujc5nkL9ZM7g-1; Sun, 29 Dec 2024 08:40:14 -0500
X-MC-Unique: aeHfekJQMZujc5nkL9ZM7g-1
X-Mimecast-MFC-AGG-ID: aeHfekJQMZujc5nkL9ZM7g
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa6869e15ebso131645266b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479613; x=1736084413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4ozYW84s47q9Bj0WEH/x+ltj2loii9ZQPIFFtrz2aQ=;
        b=YS6ABBTwGJL6omvPheZQ3z6G5gIVLays+LrymlhipNly6oOCjRZJj6iuuwSmmqPIbd
         R6wz8KsvQFbD1FedPLWvddsWAV2h2n8yyUBO4Ih+0iOd0oxk3BlTw+yrGvLaN1fWJJGb
         PRVIS8AnNz7GL5OFbcR9bCrCiOfCSgtQEF6S9KWDhmpL5/SG6a5qUJ3ayqi+xbgf06ou
         1/wvhqGJmlzq1DhFFcslOV1ncsfYuM8+Xk/OoCX1u2R6hyJLtm5f6uDejjzIddIzogX5
         XWcv67NMxR5YWyQiK2/cPc+LdPQx57UfVu7lm9+cRXmN7XXs1V8nrM6AKfdT9tTOn3zz
         8RkQ==
X-Gm-Message-State: AOJu0Yzw0o9cNTwwm01co4THqOnqPhEVXaHjPztyt8pJJxRzBp6wg/NE
	niTeEqPq1Aa9MLg33TBbDw3v0qk9ldrWuyJZXFvq9Re5oY9CsHnpy/R7Wo3EMSoVRRlY6ij+FtZ
	dqdxu1uJvqDUQUZXwTJfGS/P3zusQymkw+mMHvymmc3KuehOL+Gu+K4uc+67nTlltiS7Sum2GjW
	vXLpbOKkOydWYrEoCxqarAy0ke+PUitGN4bvzh/AqZ
X-Gm-Gg: ASbGncsi086gOm7Eon5ePFnoWjtCT8QmlClNQ5G/fnGvbyE7b9wgYBg+VHhHK4hOKKU
	RL6VgZGn8TmHFloRWhod4A14mQZL0hnUw5PnjIhQAtxuHq0u6uW56j85x2z0ihJuOcUPtzAocng
	OChjuV+hR43rt0ISRHtKr1piQfA4MC2eT+WCurBFj9guXOOXDPw5RHzrAWmTq2CqtlD3oKbVzbC
	BVNrIBohdZJKY5ue7grDgpU+hJNlaLnx2W84w15b1nFavkhONsBpoMcWpkMaTINBjF4fYwWR9NE
	ApekVX+gFZ9slec=
X-Received: by 2002:a17:906:6a21:b0:aab:edc2:ccef with SMTP id a640c23a62f3a-aac080fe36dmr2989878266b.2.1735479612694;
        Sun, 29 Dec 2024 05:40:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEFQUufCVpwF3syzzXZMa8hzVoTT64kYSgDe6VzFFzdGdn2uNmACQH5XYeOEZTXVJjgJcWHg==
X-Received: by 2002:a17:906:6a21:b0:aab:edc2:ccef with SMTP id a640c23a62f3a-aac080fe36dmr2989875366b.2.1735479612162;
        Sun, 29 Dec 2024 05:40:12 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:11 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 22/24] xfs: check and repair the verity inode flag state
Date: Sun, 29 Dec 2024 14:39:25 +0100
Message-ID: <20241229133927.1194609-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag.  The usage model
for fsverity requires that any program that cares about verity state is
required to call statx/getflags to check that the flag is set after
opening the file, so clearing the flag will not compromise that model.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c         |  7 ++++
 fs/xfs/scrub/common.c       | 68 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |  3 ++
 fs/xfs/scrub/inode.c        |  7 ++++
 fs/xfs/scrub/inode_repair.c | 36 ++++++++++++++++++++
 5 files changed, 121 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d911cf9cad20..1f840d79cc9d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -646,6 +646,13 @@ xchk_xattr(
 	if (!xfs_inode_hasattr(sc->ip))
 		return -ENOENT;
 
+	/*
+	 * If this is a verity file that won't activate, we cannot check the
+	 * merkle tree geometry.
+	 */
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_set_incomplete(sc);
+
 	/* Allocate memory for xattr checking. */
 	error = xchk_setup_xattr_buf(sc, 0);
 	if (error == -ENOMEM)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5cbd94b56582..00c07335725d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -42,6 +42,8 @@
 #include "scrub/health.h"
 #include "scrub/tempfile.h"
 
+#include <linux/fsverity.h>
+
 /* Common code for the metadata scrubbers. */
 
 /*
@@ -1573,3 +1575,69 @@ xchk_inode_rootdir_inum(const struct xfs_inode *ip)
 		return mp->m_metadirip->i_ino;
 	return mp->m_rootip->i_ino;
 }
+
+/*
+ * If this inode has S_VERITY set on it, read the merkle tree geometry, which
+ * will activate the incore fsverity context for this file.  If the activation
+ * fails with anything other than ENOMEM, the file is corrupt, which we can
+ * detect later with fsverity_active.
+ *
+ * Callers must hold the IOLOCK and must not hold the ILOCK of sc->ip because
+ * activation reads xattrs.  @blocksize and @treesize will be filled out with
+ * merkle tree geometry if they are not NULL pointers.
+ */
+int
+xchk_inode_setup_verity(
+	struct xfs_scrub	*sc,
+	unsigned int		*blocksize,
+	u64			*treesize)
+{
+	unsigned int		bs;
+	u64			ts;
+	int			error;
+
+	if (!IS_VERITY(VFS_I(sc->ip)))
+		return 0;
+
+	error = fsverity_merkle_tree_geometry(VFS_I(sc->ip), NULL, &bs, &ts);
+	switch (error) {
+	case 0:
+		/* fsverity is active; return tree geometry. */
+		if (blocksize)
+			*blocksize = bs;
+		if (treesize)
+			*treesize = ts;
+		break;
+	case -ENODATA:
+	case -EMSGSIZE:
+	case -EINVAL:
+	case -EFSCORRUPTED:
+	case -EFBIG:
+		/*
+		 * The nonzero errno codes above are the error codes that can
+		 * be returned from fsverity on metadata validation errors.
+		 * Set the geometry to zero.
+		 */
+		if (blocksize)
+			*blocksize = 0;
+		if (treesize)
+			*treesize = 0;
+		return 0;
+	default:
+		/* runtime errors */
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Is this a verity file that failed to activate?  Callers must have tried to
+ * activate fsverity via xchk_inode_setup_verity.
+ */
+bool
+xchk_inode_verity_broken(
+	struct xfs_inode	*ip)
+{
+	return IS_VERITY(VFS_I(ip)) && !fsverity_active(VFS_I(ip));
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9ff3cafd8679..f3631c603dd4 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -274,6 +274,9 @@ void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
 int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
+int xchk_inode_setup_verity(struct xfs_scrub *sc, unsigned int *blocksize,
+		u64 *treesize);
+bool xchk_inode_verity_broken(struct xfs_inode *ip);
 
 bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
 bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 25ee66e7649d..661b548460e4 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -36,6 +36,10 @@ xchk_prepare_iscrub(
 
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
+	error = xchk_inode_setup_verity(sc, NULL, NULL);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -815,6 +819,9 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
+
 	xchk_inode_check_unlinked(sc);
 
 	xchk_inode_xref(sc, sc->ip->i_ino, &di);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5a58ddd27bd2..72b97b625517 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -572,6 +572,8 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+	if (!xfs_has_verity(mp) || !S_ISREG(mode))
+		flags2 &= ~XFS_DIFLAG2_VERITY;
 
 	if (flags2 & XFS_DIFLAG2_METADATA) {
 		xfs_failaddr_t	fa;
@@ -1443,6 +1445,10 @@ xrep_dinode_core(
 	if (iget_error)
 		return iget_error;
 
+	error = xchk_inode_setup_verity(sc, NULL, NULL);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -1852,6 +1858,27 @@ xrep_inode_unlinked(
 	return 0;
 }
 
+/*
+ * If this file is a fsverity file, xchk_prepare_iscrub or xrep_dinode_core
+ * should have activated it.  If it's still not active, then there's something
+ * wrong with the verity descriptor and we should turn it off.
+ */
+STATIC int
+xrep_inode_verity(
+	struct xfs_scrub	*sc)
+{
+	struct inode		*inode = VFS_I(sc->ip);
+
+	if (xchk_inode_verity_broken(sc->ip)) {
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
+		inode->i_flags &= ~S_VERITY;
+
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	}
+
+	return 0;
+}
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -1901,6 +1928,15 @@ xrep_inode(
 			return error;
 	}
 
+	/*
+	 * Disable fsverity if it cannot be activated.  Activation failure
+	 * prohibits the file from being opened, so there cannot be another
+	 * program with an open fd to what it thinks is a verity file.
+	 */
+	error = xrep_inode_verity(sc);
+	if (error)
+		return error;
+
 	/* Reconnect incore unlinked list */
 	error = xrep_inode_unlinked(sc);
 	if (error)
-- 
2.47.0

