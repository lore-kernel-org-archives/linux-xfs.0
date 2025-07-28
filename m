Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B9F283C82
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734712; cv=none; b=HYfTCEIHDybXpoBHpqJeAfLf2I7qE3ZNrVYTpiZhAb5euyLZDzHB2l3Ws+GmR1rXe+sP3wJGeLhFwoCEePCxXll2TH2Q6n0fl67K5PAzUjPemqFQruShYf+LUkLc44USlmv1zcHm8ZocKKSzcgQJWRnmtgOA5+3hOa6QbElTtq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734712; c=relaxed/simple;
	bh=Y5rQ/uxMw3nTbMV8zWBthNRQ4J1L1jCEVXhH/CQJ7Bk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=KkREy5Jbx4w9Y/rvlsWrnCQGVR6S2me8Dukcb+YySDUlENywSbuRAJosknYDXKJw1KyJTscUcP08motN9t+0ptfByUbSRx+HAZ+H5AW+UUgqIMkqjTrfhVWXSljEZMCGp1FMg/FJe6pycbsFnDNJ/WOLCYrrOobfZO+ChaVQWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HGAsCM/Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGAsCM/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3sjYPp7zGBcepDCn4j2vk3k4XzrI0S0AJoJ8Pw84iw=;
	b=HGAsCM/Ya5s/NQ6p9UIqQ2qc9AcdwkOhY44CkiYAyH1G9YxB63kZujA7uNdBqRAsMUzXxf
	RA9pYkvHcrG0kxjHnVDbV+RIgQAQzOutXOBHAg8NOezVX2O9B0qfZBaMwoH5ZrVMpgryqI
	oHpojWgNvFDi+GtMN4ZZjIYrB0Ozk4Y=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-SGrW6vmCPVq4G1CWb1kHgA-1; Mon, 28 Jul 2025 16:31:48 -0400
X-MC-Unique: SGrW6vmCPVq4G1CWb1kHgA-1
X-Mimecast-MFC-AGG-ID: SGrW6vmCPVq4G1CWb1kHgA_1753734707
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae708b158f2so436373766b.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734707; x=1754339507;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3sjYPp7zGBcepDCn4j2vk3k4XzrI0S0AJoJ8Pw84iw=;
        b=hpmB4/HSP3csaPPhvrTfIQUDHACcbLFdckkBEbk7Yfzc/4EQpvgJLzlOu3G8icix+1
         OioU/FEVZg2B/M60CYqZLAf204RE4eotkJMygvpw7tI+E5jDzkDpszpLA/mxeuNgzsXO
         a2KHklELJsfSpKCDDhXNDH6yMmzt9gVWNyCdAy8W0YQ8wfIoxZYzF9Tsgws5pr0xRWCw
         /QYTDazlryLYYCGBvkElBi6VTmK/Q8veADCKBvt50P83jzK9UjzgMqfdwMGQzYkxaKy9
         5Jc+r5v6Y40lS7OBNdV1Mdjg2cMpZ/EnrWyEJU22UpLcawkvUlDA4OAESNZVBJCwKd+v
         xOvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjQEb8nIynXurWc0+6PXF8Ip+tjZPgimaMV9LEkWGxEDiNrGaYIdSE6pusBlL9r0IxCk80i48ZXpE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUNstkOxPdTfGyKwOyygSQpu3bIu14U77Hg0x2DWN2e3Q5vGGJ
	qsh5IZG5zR4Pzw8P62ivevPsqF9lGY0eb1mXrwotzts5+kA4R+5cKdz3LLD44l3SndEBU0Ay2kR
	yw4KzHjma1r5PB/ToHh012f2BFNPozensaW1l27ONPmiImOQV5kWFVsV52nPE
X-Gm-Gg: ASbGncvRMaFHJ4iuVZDeFCdB8WJS04C+OjVK4iLO3TZC7WNbjqx5bx8RXlXtSr2xjvB
	3XatCcqs1WWooKMntai/WKdWDnS9y+DrInFADbZrjKniixrxG3cQMuu9c48XH4i88KpGUVk5fm/
	u6YKQkoQOlgOUKsyMspmYGI+suQeizbrK9wczxpRbu0sfA28vUrHpJkcCddCYM1LJYfgFgtFXh5
	gvFMvyel4Op6IvBPNfsxFaSPVEk6n+6APQ/5G2IUcw+sX1u3WNT3u/MNPjCglWgWAW+xaCc1hW6
	aCOffZoV0FkqNRuJDM/PH/UWW7VmuRoN5f8lzG5HpJPsGg==
X-Received: by 2002:a17:907:7295:b0:ae3:502f:cdea with SMTP id a640c23a62f3a-af619c0ca43mr1116577866b.60.1753734707198;
        Mon, 28 Jul 2025 13:31:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHu5PQdC6f+qKZkGwqn0CAIZGHLd30eOzDyno2NqYdNQcNDREYynXXb1tKKbC+cBG3JjwEnLw==
X-Received: by 2002:a17:907:7295:b0:ae3:502f:cdea with SMTP id a640c23a62f3a-af619c0ca43mr1116574166b.60.1753734706359;
        Mon, 28 Jul 2025 13:31:46 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:45 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:29 +0200
Subject: [PATCH RFC 25/29] xfs: check and repair the verity inode flag
 state
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-25-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6831; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=XdTVDqZuJU1JOSoziNbUXLExJ1Kh7yXvR7qsSHvaQ/4=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSby/JZdr8id910TZvfdDSnoUDt6rTywquqH77
 4vqT0aOYx4dpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJiK3lpHhKfPblqsaNttk
 hURaxS7/eP9aLO5W+fVHyxiqi3c6CtQ0M/wVWVdlpN6opnk2/E6joP3OjTMfpvQfTFn89OAJI4V
 5G4N5AdyhSQA=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag.  The usage model
for fsverity requires that any program that cares about verity state is
required to call statx/getflags to check that the flag is set after
opening the file, so clearing the flag will not compromise that model.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c         |  7 +++++
 fs/xfs/scrub/common.c       | 74 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |  3 ++
 fs/xfs/scrub/inode.c        |  7 +++++
 fs/xfs/scrub/inode_repair.c | 36 ++++++++++++++++++++++
 5 files changed, 127 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd..b1448832ae6b 100644
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
index 28ad341df8ee..df031f831bba 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -45,6 +45,8 @@
 #include "scrub/health.h"
 #include "scrub/tempfile.h"
 
+#include <linux/fsverity.h>
+
 /* Common code for the metadata scrubbers. */
 
 /*
@@ -1735,3 +1737,75 @@ xchk_inode_count_blocks(
 	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
 			count);
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
+	u8			*log_blocksize,
+	unsigned int		*blocksize,
+	u64			*treesize)
+{
+	u8			lbs;
+	unsigned int		bs;
+	u64			ts;
+	int			error;
+
+	if (!IS_VERITY(VFS_I(sc->ip)))
+		return 0;
+
+	error = fsverity_merkle_tree_geometry(VFS_I(sc->ip), &lbs, &bs, &ts);
+	switch (error) {
+	case 0:
+		/* fsverity is active; return tree geometry. */
+		if (log_blocksize)
+			*log_blocksize = lbs;
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
+		if (log_blocksize)
+			*log_blocksize = 0;
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
index 19877d99f255..c6ec7b0cc68a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -289,6 +289,9 @@ int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
 int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t *nextents, xfs_filblks_t *count);
+int xchk_inode_setup_verity(struct xfs_scrub *sc, u8 *log_blocksize,
+		unsigned int *blocksize, u64 *treesize);
+bool xchk_inode_verity_broken(struct xfs_inode *ip);
 
 bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
 bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index bb3f475b6353..f173d1fea6bd 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -36,6 +36,10 @@ xchk_prepare_iscrub(
 
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
+	error = xchk_inode_setup_verity(sc, NULL, NULL, NULL);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -833,6 +837,9 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
+
 	xchk_inode_check_unlinked(sc);
 
 	xchk_inode_xref(sc, sc->ip->i_ino, &di);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a90a011c7e5f..e5dd39759f7a 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -573,6 +573,8 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+	if (!xfs_has_verity(mp) || !S_ISREG(mode))
+		flags2 &= ~XFS_DIFLAG2_VERITY;
 
 	if (flags2 & XFS_DIFLAG2_METADATA) {
 		xfs_failaddr_t	fa;
@@ -1613,6 +1615,10 @@ xrep_dinode_core(
 	if (iget_error)
 		return iget_error;
 
+	error = xchk_inode_setup_verity(sc, NULL, NULL, NULL);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -2032,6 +2038,27 @@ xrep_inode_unlinked(
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
@@ -2081,6 +2108,15 @@ xrep_inode(
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
2.50.0

