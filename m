Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C342BE058
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229532; cv=none; b=feUs0kzpq/sV1gMa1ax00/FJEEWpPttZDR6eQrfpk68jvVTSgX5UhU/IGJ6w9jLeKuxVi+Q7R1HZaD2xWAdvmS5nN09kg9tvYTPqdVyGdhTUqTgoh4kkCbaQJBA+THYPox4zTuIoAC1Z97KlQ3PAC57QmGQTvA55ZKJdM/pyQNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229532; c=relaxed/simple;
	bh=C/MDGxOkNIvgHTaqTYSxlFYphLb/jo2tJvmNmF9aQAw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aq12JURwtjt9tHHlVeMZD3XPXfg/14qZUZoL8Qc+FtRt+jrHPPLu51EU5m1VfMBLs4lrWOjeUK4peoo+fvwbXPs4DutIfhMZl5MPRYy2wsKQwCDdWaW2/CG3CFmH3Vxolu8M7AI4JjSHzBtyaXpdyVT1tN/IpkL1aS2FKLKt1v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ldm9jta4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdOigMSq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ldm9jta4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdOigMSq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i3zHW5WG2189QuRGw972bnhsFeepbkuRDbwilr8y5Bg=;
	b=Ldm9jta4kYhcU+jyTZApH/c1AMj25JGodYdxgStz9QNvX4P2KhCawco1Fij2Bck6w4RB3B
	uE1K0it0Y1WHgc9YQ1PnUwlLBSc25+vx9thjNQ6C/aHquPugJv00ERGwA9b80wPHiTvJJ5
	1WYYPpCNMqYAuMZxHtMlZJhqqeR26kM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-9D6U23rvO7WpyCjbAM1zUQ-1; Mon, 12 Jan 2026 09:52:09 -0500
X-MC-Unique: 9D6U23rvO7WpyCjbAM1zUQ-1
X-Mimecast-MFC-AGG-ID: 9D6U23rvO7WpyCjbAM1zUQ_1768229528
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-64d29b6e198so6795741a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229528; x=1768834328; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i3zHW5WG2189QuRGw972bnhsFeepbkuRDbwilr8y5Bg=;
        b=QdOigMSq4u7c0OKwET8MczVo7K7sH95ZPRb4ZNJCPyBMX8GLcnuWksLHdt4NkajdzY
         mL+Ft28+Wm5w393Lytn8dDevJHpyUVI3pFtteSJeOLGNImGok1G3RaSACcuA4saf2dwH
         QwlV5MgDTiGL4ClwMXjtY3B0XCe2uRjosiGJ8zvP9fHOQmDyztp9Lj6eLZw5tW6EbZKu
         T/3JsbyWbI0wvAnhj/fZ7yJZqhM1bB6Sf8kbQfKrsn9nbR8p2goStFZOQmSwVMNGiUUx
         Yaf5c5Q/QvKVGhf0+pJ/Dh111okgiWEZpu89v4HKIoUvVKbiwE9qzEMVkn1FexCEYnAQ
         0W2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229528; x=1768834328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3zHW5WG2189QuRGw972bnhsFeepbkuRDbwilr8y5Bg=;
        b=A53YRoN08P05R8RyrXlGJM5kxt/dFQB57I9tQ6bSCXBUez+z2NNj2cq5nvIrNiVL7Q
         Od2z8E/jNrRxE3FBDDUEiL/XUFyVobwR2LVi/ia/QGHmd4VJRR9E2tQJBj6bSPHgrxeT
         e4wQyqQayI+hDRZNkB70cM49NqIc4sxl1tcQ/XiM+vjcVwFVYgUgtLRuXnU0qPvCwCT5
         X3929VnrYMzglAU07xHizilCojgDd8kIJZqY+S+sTJqddIWf7fd1UtxPQCqyzZq+zHzC
         kiaRQWgEa+CRo1av5AJtam9Yjucys/UQcGgacIfquNv0gLeUavBr2yHesrdVuZw3JpJY
         uvyA==
X-Forwarded-Encrypted: i=1; AJvYcCUKqCNpyLe2e6Kt5fCOAz125HPnc/WwBAo7dNiB3Zm/FSYK/LNuUQxAemjMZSjRhxp5UekP2X2zFiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVciQ6kKMjh02hZOFko0FEw/L0XSQa9HB/dGLwOOGfn8/Qvwc0
	3c5CuI070AjWKp4DIigQI7kFM2mAHdPT+212rYxe4aUFCANMXiQ3B6aTXOoFc/ZD7xyQOS8iMIW
	2mG8N2up41MLQlgLrdO/8GhjHR2Omz8fYtkSgnctP8OwPbRlCqP2QR2oDXvmR
X-Gm-Gg: AY/fxX4a3+K3blhfN0P5E35aLqbQOdShzWQKTM341dC1B90uklfYjCU3RJvm7tTh0kV
	2o/r9zHcv89fxgkuicnMZO0fXVNLgFN0G7jzPfBd4swEh+H5N9HXrJ/nHPlyax8ZQONTGnehQd8
	8ykC/iKCHqERpAqxLkXONY+YehuzL647NXdPHEEaJsnG49Z/b0Etz/XKZ4TG/f+VFPcxlYHXYmA
	JjYjyqYnjBFgU0lK/SpgXD2TO7DzCTe7YuiXnmA/c5If+R7enaz0akxFVbSCBkiCCeHKizy4DE2
	a/rmVhTs5zK9T3zI0ZD8UK6kAZXTVvYdp11l3QP1q2xJpUiKEiIMocwNJpn8kPyvp0d/J8sZ
X-Received: by 2002:a17:907:c03:b0:b87:2f29:2054 with SMTP id a640c23a62f3a-b872f29385amr133945466b.8.1768229527781;
        Mon, 12 Jan 2026 06:52:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGB1AHBE/+Mhlwy/JWYn8W4wq+O4YUYCcO2vyBAd8+kNj160C4mXDrZOC7LbzVnSCFekrxpzA==
X-Received: by 2002:a17:907:c03:b0:b87:2f29:2054 with SMTP id a640c23a62f3a-b872f29385amr133942266b.8.1768229527346;
        Mon, 12 Jan 2026 06:52:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86f88f90a4sm670365066b.37.2026.01.12.06.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:52:06 -0800 (PST)
From: "Darrick J. Wong" <aalbersh@redhat.com>
X-Google-Original-From: "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 12 Jan 2026 15:52:06 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 19/22] xfs: check and repair the verity inode flag state
Message-ID: <wtj4hy43eq3dzl4txfnt5ury5eygcaocafmp632jpvmytrk7sn@xcumewz64tkd>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag.  The usage model
for fsverity requires that any program that cares about verity state is
required to call statx/getflags to check that the flag is set after
opening the file, so clearing the flag will not compromise that model.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/scrub/attr.c         |  7 ++++++
 fs/xfs/scrub/common.c       | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |  2 +
 fs/xfs/scrub/inode.c        |  7 ++++++
 fs/xfs/scrub/inode_repair.c | 36 +++++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2..b1448832ae 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -646,6 +646,13 @@
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
index 7bfa37c994..41bbf4648f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -45,6 +45,8 @@
 #include "scrub/health.h"
 #include "scrub/tempfile.h"
 
+#include <linux/fsverity.h>
+
 /* Common code for the metadata scrubbers. */
 
 /*
@@ -1736,3 +1738,54 @@
 	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
 			count);
 }
+
+/*
+ * If this inode has S_VERITY set on it, read the verity info. If the reading
+ * fails with anything other than ENOMEM, the file is corrupt, which we can
+ * detect later with fsverity_active.
+ *
+ * Callers must hold the IOLOCK and must not hold the ILOCK of sc->ip because
+ * activation reads inode data.
+ */
+int
+xchk_inode_setup_verity(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!IS_VERITY(VFS_I(sc->ip)))
+		return 0;
+
+	error = fsverity_ensure_verity_info(VFS_I(sc->ip));
+	switch (error) {
+	case 0:
+		/* fsverity is active */
+		break;
+	case -ENODATA:
+	case -EMSGSIZE:
+	case -EINVAL:
+	case -EFSCORRUPTED:
+	case -EFBIG:
+		/*
+		 * The nonzero errno codes above are the error codes that can
+		 * be returned from fsverity on metadata validation errors.
+		 */
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
index ddbc065c79..36d6a33337 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -289,6 +289,8 @@
 		bool *inuse);
 int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t *nextents, xfs_filblks_t *count);
+int xchk_inode_setup_verity(struct xfs_scrub *sc);
+bool xchk_inode_verity_broken(struct xfs_inode *ip);
 
 bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
 bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index bb3f475b63..1e7cfef00a 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -36,6 +36,10 @@
 
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
+	error = xchk_inode_setup_verity(sc);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -833,6 +837,9 @@
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
+
 	xchk_inode_check_unlinked(sc);
 
 	xchk_inode_xref(sc, sc->ip->i_ino, &di);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4f7040c9dd..846a47286e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -573,6 +573,8 @@
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+	if (!xfs_has_verity(mp) || !S_ISREG(mode))
+		flags2 &= ~XFS_DIFLAG2_VERITY;
 
 	if (flags2 & XFS_DIFLAG2_METADATA) {
 		xfs_failaddr_t	fa;
@@ -1613,6 +1615,10 @@
 	if (iget_error)
 		return iget_error;
 
+	error = xchk_inode_setup_verity(sc);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -2032,6 +2038,27 @@
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
@@ -2081,6 +2108,15 @@
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
- Andrey

