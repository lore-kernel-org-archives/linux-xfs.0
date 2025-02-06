Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBBA2417E3
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882794; cv=none; b=NAUsqOK7wFv68JvR/irmE3a+n3tiamY/qZJSSqBsAmuxx5EldoBlF5Squa0NRPKckUurLF9+JKyDF653jIsTsoqC8u974fIpx0bTVbH8/XW5paOIh6kb/YSWAKrEwCJYT4weDDKiIvwlKqFz24ZCdPFilXAxeTZKm+MrT3vXNig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882794; c=relaxed/simple;
	bh=9H2LtOiRbq/J+02nVXkMD+zoQ+XDkhS3g4kQr4eCT0g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ts02OlkLlV3d6THXEEH0EqZyuv/aZK+Z0U1km47Q7ndMOLEluqeFrTsLu3hJvpZ5QnqQnWrMTHwEgtqtHa2tXeCbpd7ZGIEVJ9i2vnSH/rLzjfm9XVUFo0U80q6FeNx3pMhR1qAAKYQHdSA/k6qe587FkrRXJPBFLOdnUHFEVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BU3gbFiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BU3gbFiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34334C4CEE7;
	Thu,  6 Feb 2025 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882794;
	bh=9H2LtOiRbq/J+02nVXkMD+zoQ+XDkhS3g4kQr4eCT0g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BU3gbFiSKOHN5C2ta0i1nbYsWeN73Jg05xH4RdTL9aX5vA/x4jwy9EwIAd/f34+Ay
	 4X8LTtnzXKjqgDJkSitqXgPUmVVVoHNIRr9jaoA6tr3YyrBBu6Sco9FFA7jKxzyCGC
	 whlf9ay0LZj7uDLouUdghdBuvtVKpXjjNVvfEUGMdv69YvJJ8bmkwipfdSJ1EGKXAr
	 0zPrEcLWb4b+BH03PaJ4IM8ijRb7cfsYPArFf1l+kP72wvvkoOL9r1hSMUhhtsWTzO
	 42rgkbLOKU3o5fKBrgtZJeV8a+aUws92iR7slADg7Ui3qWRKKSXq0aKtYTZ/gNRMj7
	 1LO+BIKRPPg8A==
Date: Thu, 06 Feb 2025 14:59:53 -0800
Subject: [PATCH 12/22] xfs_repair: use realtime refcount btree data to check
 block types
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089116.2741962.13761732561620436172.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the realtime refcount btree to pre-populate the block type information
so that when repair iterates the primary metadata, we can confirm the
block type.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/dinode.c          |  154 +++++++++++++++++++++++
 repair/rt.h              |    4 +
 repair/scan.c            |  314 +++++++++++++++++++++++++++++++++++++++++++++-
 repair/scan.h            |   33 +++++
 5 files changed, 500 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7ce10c408de1a0..0dc6f0350dd0f6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -394,6 +394,7 @@
 #define xfs_verify_fsbext		libxfs_verify_fsbext
 #define xfs_verify_fsbno		libxfs_verify_fsbno
 #define xfs_verify_ino			libxfs_verify_ino
+#define xfs_verify_rgbno		libxfs_verify_rgbno
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 3995584a364771..ac5db8b0ea4392 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -308,6 +308,8 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 			break;
 		case XR_E_INUSE:
 		case XR_E_MULT:
+			if (xfs_has_rtreflink(mp))
+				break;
 			set_rtbmap(ext, XR_E_MULT);
 			break;
 		case XR_E_FREE1:
@@ -382,6 +384,8 @@ _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt
 			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
+			if (xfs_has_rtreflink(mp))
+				break;
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -1083,6 +1087,149 @@ _("bad rtrmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 	return suspect ? 1 : 0;
 }
 
+/*
+ * return 1 if inode should be cleared, 0 otherwise
+ */
+static int
+process_rtrefc(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agino_t			ino,
+	struct xfs_dinode		*dip,
+	int				type,
+	int				*dirty,
+	xfs_rfsblock_t			*tot,
+	uint64_t			*nex,
+	blkmap_t			**blkmapp,
+	int				check_dups)
+{
+	struct refc_priv		priv = { .nr_blocks = 0 };
+	struct xfs_rtrefcount_root	*dib;
+	xfs_rtrefcount_ptr_t		*pp;
+	struct xfs_refcount_key		*kp;
+	struct xfs_refcount_rec		*rp;
+	char				*forkname = get_forkname(XFS_DATA_FORK);
+	xfs_rgblock_t			oldkey, key;
+	xfs_ino_t			lino;
+	xfs_fsblock_t			bno;
+	size_t				droot_sz;
+	int				i;
+	int				level;
+	int				numrecs;
+	int				dmxr;
+	int				suspect = 0;
+	int				error;
+
+	/* We rebuild the rtrefcountbt, so no need to process blocks again. */
+	if (check_dups) {
+		*tot = be64_to_cpu(dip->di_nblocks);
+		return 0;
+	}
+
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+
+	/*
+	 * This refcount btree inode must be a metadata inode reachable via
+	 * /rtgroups/$rgno.refcount in the metadata directory tree.
+	 */
+	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA))) {
+		do_warn(
+_("rtrefcount inode %" PRIu64 " not flagged as metadata\n"),
+			lino);
+		return 1;
+	}
+
+	if (!is_rtrefcount_inode(lino)) {
+		do_warn(
+_("could not associate refcount inode %" PRIu64 " with any rtgroup\n"),
+			lino);
+		return 1;
+	}
+
+	priv.rgno = metafile_rgnumber(dip);
+
+	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*tot = 0;
+	*nex = 0;
+
+	level = be16_to_cpu(dib->bb_level);
+	numrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrefc_maxlevels) {
+		do_warn(
+_("bad level %d in inode %" PRIu64 " rtrefcount btree root block\n"),
+			level, lino);
+		return 1;
+	}
+
+	/*
+	 * use rtroot/dfork_dsize since the root block is in the data fork
+	 */
+	droot_sz = xfs_rtrefcount_droot_space_calc(level, numrecs);
+	if (droot_sz > XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK)) {
+		do_warn(
+_("computed size of rtrefcountbt root (%zu bytes) is greater than space in "
+	  "inode %" PRIu64 " %s fork\n"),
+				droot_sz, lino, forkname);
+		return 1;
+	}
+
+	if (level == 0) {
+		rp = xfs_rtrefcount_droot_rec_addr(dib, 1);
+		error = process_rtrefc_reclist(mp, rp, numrecs,
+				&priv, "rtrefcountbt root");
+		if (error) {
+			refcount_avoid_check();
+			return 1;
+		}
+		return 0;
+	}
+
+	dmxr = libxfs_rtrefcountbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK), false);
+	pp = xfs_rtrefcount_droot_ptr_addr(dib, 1, dmxr);
+
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = xfs_rtrefcount_droot_key_addr(dib, i + 1);
+
+		key = be32_to_cpu(kp->rc_startblock);
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (key < oldkey) {
+			do_warn(
+_("out of order key %u in rtrefcount root ino %" PRIu64 "\n"),
+				i, lino);
+			suspect++;
+			continue;
+		}
+		oldkey = key;
+	}
+
+	/* probe keys */
+	for (i = 0; i < numrecs; i++)  {
+		bno = get_unaligned_be64(&pp[i]);
+
+		if (!libxfs_verify_fsbno(mp, bno))  {
+			do_warn(
+_("bad rtrefcount btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
+				bno, lino);
+			return 1;
+		}
+
+		if (scan_lbtree(bno, level, scan_rtrefcbt,
+				type, XFS_DATA_FORK, lino, tot, nex, blkmapp,
+				NULL, 0, 1, check_dups, XFS_RTREFC_CRC_MAGIC,
+				&priv, &xfs_rtrefcountbt_buf_ops))
+			return 1;
+	}
+
+	*tot = priv.nr_blocks;
+	return suspect ? 1 : 0;
+}
+
 /*
  * return 1 if inode should be cleared, 0 otherwise
  */
@@ -1883,6 +2030,7 @@ check_dinode_mode_format(
 		case XFS_DINODE_FMT_META_BTREE:
 			switch (be16_to_cpu(dinoc->di_metatype)) {
 			case XFS_METAFILE_RTRMAP:
+			case XFS_METAFILE_RTREFCOUNT:
 				return 0;
 			default:
 				return -1;
@@ -2333,6 +2481,11 @@ process_inode_data_fork(
 					totblocks, nextents, dblkmap,
 					check_dups);
 			break;
+		case XFS_METAFILE_RTREFCOUNT:
+			err = process_rtrefc(mp, agno, ino, dino, type, dirty,
+					totblocks, nextents, dblkmap,
+					check_dups);
+			break;
 		default:
 			do_error(
  _("unknown meta btree type %d, ino %" PRIu64 " (mode = %d)\n"),
@@ -2406,6 +2559,7 @@ _("would have tried to rebuild inode %"PRIu64" data fork\n"),
 		case XFS_DINODE_FMT_META_BTREE:
 			switch (be16_to_cpu(dino->di_metatype)) {
 			case XFS_METAFILE_RTRMAP:
+			case XFS_METAFILE_RTREFCOUNT:
 				err = 0;
 				break;
 			default:
diff --git a/repair/rt.h b/repair/rt.h
index 13558706e4ec15..e4f3d5d9af3188 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -33,6 +33,10 @@ static inline bool is_rtrmap_inode(xfs_ino_t ino)
 {
 	return is_rtgroup_inode(ino, XFS_RTGI_RMAP);
 }
+static inline bool is_rtrefcount_inode(xfs_ino_t ino)
+{
+	return is_rtgroup_inode(ino, XFS_RTGI_REFCOUNT);
+}
 
 void mark_rtgroup_inodes_bad(struct xfs_mount *mp, enum xfs_rtg_inodes type);
 bool rtgroup_inodes_were_bad(enum xfs_rtg_inodes type);
diff --git a/repair/scan.c b/repair/scan.c
index 7980795e3a6f9f..21fa9018800c77 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1745,12 +1745,6 @@ _("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
 	return 0;
 }
 
-struct refc_priv {
-	struct xfs_refcount_irec	last_rec;
-	xfs_agblock_t			nr_blocks;
-};
-
-
 static void
 scan_refcbt(
 	struct xfs_btree_block	*block,
@@ -1990,6 +1984,314 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	return;
 }
 
+
+int
+process_rtrefc_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_refcount_rec	*rp,
+	int			numrecs,
+	struct refc_priv	*refc_priv,
+	const char		*name)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno = refc_priv->rgno;
+	xfs_rtblock_t		lastblock = 0;
+	int			state;
+	int			suspect = 0;
+	int			i;
+
+	rtg = libxfs_rtgroup_get(mp, rgno);
+	if (!rtg) {
+		if (numrecs) {
+			do_warn(
+_("no rt group 0x%x but %d rtrefcount records\n"),
+					rgno, numrecs);
+			suspect++;
+		}
+
+		return suspect;
+	}
+
+	for (i = 0; i < numrecs; i++) {
+		enum xfs_refc_domain	domain;
+		xfs_rgblock_t		b, rgbno, end;
+		xfs_extlen_t		len;
+		xfs_nlink_t		nr;
+
+		b = rgbno = be32_to_cpu(rp[i].rc_startblock);
+		len = be32_to_cpu(rp[i].rc_blockcount);
+		nr = be32_to_cpu(rp[i].rc_refcount);
+
+		if (b & XFS_REFC_COWFLAG) {
+			domain = XFS_REFC_DOMAIN_COW;
+			rgbno &= ~XFS_REFC_COWFLAG;
+		} else {
+			domain = XFS_REFC_DOMAIN_SHARED;
+		}
+
+		if (domain == XFS_REFC_DOMAIN_COW && nr != 1) {
+			do_warn(
+_("leftover rt CoW extent has incorrect refcount in record %u of %s\n"),
+					i, name);
+			suspect++;
+		}
+		if (nr == 1) {
+			if (domain != XFS_REFC_DOMAIN_COW) {
+				do_warn(
+_("leftover rt CoW extent has invalid startblock in record %u of %s\n"),
+					i, name);
+				suspect++;
+			}
+		}
+		end = rgbno + len;
+
+		if (!libxfs_verify_rgbno(rtg, rgbno)) {
+			do_warn(
+_("invalid start block %llu in record %u of %s\n"),
+					(unsigned long long)b, i, name);
+			suspect++;
+			continue;
+		}
+
+		if (len == 0 || end <= rgbno ||
+		    !libxfs_verify_rgbno(rtg, end - 1)) {
+			do_warn(
+_("invalid length %llu in record %u of %s\n"),
+					(unsigned long long)len, i, name);
+			suspect++;
+			continue;
+		}
+
+		if (nr < 2 || nr > XFS_REFC_REFCOUNT_MAX) {
+			do_warn(
+_("invalid rt reference count %u in record %u of %s\n"),
+					nr, i, name);
+			suspect++;
+			continue;
+		}
+
+		if (nr == 1) {
+			xfs_rgblock_t		b;
+			xfs_extlen_t		blen;
+
+			for (b = rgbno; b < end; b += len) {
+				state = get_bmap_ext(rgno, b, end, &blen, true);
+				blen = min(blen, len);
+
+				switch (state) {
+				case XR_E_UNKNOWN:
+				case XR_E_COW:
+					do_warn(
+_("leftover CoW rtextent (%llu)\n"),
+						(unsigned long long)rgbno);
+					set_bmap_ext(rgno, b, len, XR_E_FREE,
+							true);
+					break;
+				default:
+					do_warn(
+_("rtextent (%llu) claimed, state is %d\n"),
+						(unsigned long long)rgbno, state);
+					break;
+				}
+				suspect++;
+			}
+		}
+
+		if (b && b <= lastblock) {
+			do_warn(_(
+"out-of-order %s btree record %d (%llu %llu) in %s\n"),
+					name, i, (unsigned long long)b,
+					(unsigned long long)len, name);
+			suspect++;
+		} else {
+			lastblock = end - 1;
+		}
+
+		/* Is this record mergeable with the last one? */
+		if (refc_priv->last_rec.rc_domain == domain &&
+		    refc_priv->last_rec.rc_startblock +
+		    refc_priv->last_rec.rc_blockcount == rgbno &&
+		    refc_priv->last_rec.rc_refcount == nr) {
+			do_warn(
+_("record %d of %s tree should be merged with previous record\n"),
+					i, name);
+			suspect++;
+			refc_priv->last_rec.rc_blockcount += len;
+		} else {
+			refc_priv->last_rec.rc_domain = domain;
+			refc_priv->last_rec.rc_startblock = rgbno;
+			refc_priv->last_rec.rc_blockcount = len;
+			refc_priv->last_rec.rc_refcount = nr;
+		}
+
+		/* XXX: probably want to mark the reflinked areas? */
+	}
+
+	libxfs_rtgroup_put(rtg);
+	return suspect;
+}
+
+int
+scan_rtrefcbt(
+	struct xfs_btree_block		*block,
+	int				level,
+	int				type,
+	int				whichfork,
+	xfs_fsblock_t			fsbno,
+	xfs_ino_t			ino,
+	xfs_rfsblock_t			*tot,
+	uint64_t			*nex,
+	struct blkmap			**blkmapp,
+	bmap_cursor_t			*bm_cursor,
+	int				suspect,
+	int				isroot,
+	int				check_dups,
+	int				*dirty,
+	uint64_t			magic,
+	void				*priv)
+{
+	const char			*name = "rtrefcount";
+	char				rootname[256];
+	int				i;
+	xfs_rtrefcount_ptr_t		*pp;
+	struct xfs_refcount_rec	*rp;
+	struct refc_priv		*refc_priv = priv;
+	int				hdr_errors = 0;
+	int				numrecs;
+	int				state;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	int				error;
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	if (magic != XFS_RTREFC_CRC_MAGIC) {
+		name = "(unknown)";
+		hdr_errors++;
+		suspect++;
+		goto out;
+	}
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in %s btree block %d/%d\n"),
+				be32_to_cpu(block->bb_magic), name, agno,
+				agbno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(_("expected level %d got %d in %s btree block %d/%d\n"),
+				level, be16_to_cpu(block->bb_level), name,
+				agno, agbno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	refc_priv->nr_blocks++;
+
+	/*
+	 * Check for btree blocks multiply claimed.  We're going to regenerate
+	 * the btree anyway, so mark the blocks as metadata so they get freed.
+	 */
+	state = get_bmap(agno, agbno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_INUSE1))  {
+		do_warn(
+_("%s btree block claimed (state %d), agno %d, agbno %d, suspect %d\n"),
+				name, state, agno, agbno, suspect);
+		goto out;
+	}
+	set_bmap(agno, agbno, XR_E_METADATA);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level == 0) {
+		if (numrecs > mp->m_rtrefc_mxr[0])  {
+			numrecs = mp->m_rtrefc_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_rtrefc_mnr[0])  {
+			numrecs = mp->m_rtrefc_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+					be16_to_cpu(block->bb_numrecs),
+					mp->m_rtrefc_mnr[0],
+					mp->m_rtrefc_mxr[0], name, agno, agbno);
+			suspect++;
+		}
+
+		rp = xfs_rtrefcount_rec_addr(block, 1);
+		snprintf(rootname, 256, "%s btree block %u/%u", name, agno,
+				agbno);
+		error = process_rtrefc_reclist(mp, rp, numrecs, refc_priv,
+				rootname);
+		if (error)
+			suspect++;
+		goto out;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = xfs_rtrefcount_ptr_addr(block, 1, mp->m_rtrefc_mxr[1]);
+
+	if (numrecs > mp->m_rtrefc_mxr[1])  {
+		numrecs = mp->m_rtrefc_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_rtrefc_mnr[1])  {
+		numrecs = mp->m_rtrefc_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_rtrefc_mnr[1], mp->m_rtrefc_mxr[1], name,
+				agno, agbno);
+		if (suspect)
+			goto out;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_fsblock_t		pbno = be64_to_cpu(pp[i]);
+
+		if (!libxfs_verify_fsbno(mp, pbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+					agbno, name, agno, agbno);
+			suspect++;
+			return 0;
+		}
+
+		scan_lbtree(pbno, level, scan_rtrefcbt, type, whichfork, ino,
+				tot, nex, blkmapp, bm_cursor, suspect, 0,
+				check_dups, magic, refc_priv,
+				&xfs_rtrefcountbt_buf_ops);
+	}
+out:
+	if (suspect) {
+		refcount_avoid_check();
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * The following helpers are to help process and validate individual on-disk
  * inode btree records. We have two possible inode btrees with slightly
diff --git a/repair/scan.h b/repair/scan.h
index a624c882734c77..1643a2397aeaf5 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -100,4 +100,37 @@ int scan_rtrmapbt(
 	uint64_t		magic,
 	void			*priv);
 
+struct refc_priv {
+	struct xfs_refcount_irec	last_rec;
+	xfs_agblock_t			nr_blocks;
+	xfs_rgnumber_t			rgno;
+};
+
+int
+process_rtrefc_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_refcount_rec	*rp,
+	int			numrecs,
+	struct refc_priv	*refc_priv,
+	const char		*name);
+
+int
+scan_rtrefcbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	int			type,
+	int			whichfork,
+	xfs_fsblock_t		bno,
+	xfs_ino_t		ino,
+	xfs_rfsblock_t		*tot,
+	uint64_t		*nex,
+	struct blkmap		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			suspect,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	uint64_t		magic,
+	void			*priv);
+
 #endif /* _XR_SCAN_H */

