Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EDD2417EA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882811; cv=none; b=NK07kggJuAb1pQCdKeRgrEZP6cJo4u82deeoLXeHtOO9z/51O8BkHq2xlQxY1yGGdQ/+iUpXsUY3MejeMELx+5L1x81YNNI5M4FODtno6minZyvcOhzi+xLM+3Y0YcNBX4RCmQvhS75lzdlQwr0JfqobLpdAvyDYb3E0/IX/U8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882811; c=relaxed/simple;
	bh=VpwfUgYL2uM7O5yMtjsc1b+/o7boGpg2n+o0G9AXVpY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHLaFZdrvbqlXNBWhNytJGRXDA60KenXPoXjnGdycZPmiRzb4076hFd5nHkTFF8MA5ob95TnIJXmvV8+uNk1zzjQw1mR79voR9n1GwQbsS4edxyGNZ/2v3pMvWO9FZqBPUwj5eaESVkMPxksoRcTFybeNxjPeCEuJvhjbEHEvC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8D8EaXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8D8EaXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28D9C4CEE0;
	Thu,  6 Feb 2025 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882809;
	bh=VpwfUgYL2uM7O5yMtjsc1b+/o7boGpg2n+o0G9AXVpY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T8D8EaXBIFcPf1hZe00mGBUizydwXZF/g/3zvV6E+xiUYB2yAw1NQRVCXoYqn20uy
	 lEBqgrY+KmfBI/sdWbps8ErWz7SGxIgtdIDZ35azBDH44/MzHZENZ2E+DRdcGzcck7
	 TROFsFnsHzZQVmi1ai+6xPcxnwuXsQh4zvhcfFqJ7br/Daulozhe9lWCjf/hbW39Tf
	 BIkPQmt/9QaLYKxCTZALAvHUlzVtkiZ8MCxM27CbT3R+aBgTV9CElH/vTH8XSCtjZS
	 zBmlUe0aokL3nYRkBIp7OamvxG8CVzHxE2gdpOGC8/wMWCs67bFgkpb2Qd6eI4PfBb
	 yGnjzh7LucyLw==
Date: Thu, 06 Feb 2025 15:00:09 -0800
Subject: [PATCH 13/22] xfs_repair: find and mark the rtrefcountbt inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089131.2741962.15415300047895957138.stgit@frogsfrogsfrogs>
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

Make sure that we find the realtime refcountbt inode and mark it
appropriately, just in case we find a rogue inode claiming to
be an rtrefcount, or just plain garbage in the superblock field.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dino_chunks.c |   11 +++++++++++
 repair/dinode.c      |   49 +++++++++++++++++++++++++++++++++++++++++--------
 repair/dir2.c        |    5 +++++
 repair/incore.h      |    1 +
 repair/rmap.c        |    5 ++++-
 repair/rmap.h        |    2 +-
 repair/scan.c        |    8 ++++----
 7 files changed, 67 insertions(+), 14 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 8c5387cdf4ea52..250985ec264ead 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1036,6 +1036,17 @@ process_inode_chunk(
 	_("would clear rtgroup rmap inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (is_rtrefcount_inode(ino)) {
+				refcount_avoid_check(mp);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared rtgroup refcount inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear rtgroup refcount inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index ac5db8b0ea4392..3260df94511ed2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -181,6 +181,9 @@ clear_dinode(
 
 	if (is_rtrmap_inode(ino_num))
 		rmap_avoid_check(mp);
+
+	if (is_rtrefcount_inode(ino_num))
+		refcount_avoid_check(mp);
 }
 
 /*
@@ -1139,14 +1142,27 @@ _("rtrefcount inode %" PRIu64 " not flagged as metadata\n"),
 		return 1;
 	}
 
-	if (!is_rtrefcount_inode(lino)) {
-		do_warn(
-_("could not associate refcount inode %" PRIu64 " with any rtgroup\n"),
-			lino);
-		return 1;
-	}
-
+	/*
+	 * If this rtrefcount file claims to be from an rtgroup that actually
+	 * exists, check that inode discovery actually found it.  Note that
+	 * we can have stray rtrefcount files from failed growfsrt operations.
+	 */
 	priv.rgno = metafile_rgnumber(dip);
+	if (priv.rgno < mp->m_sb.sb_rgcount) {
+		if (type != XR_INO_RTREFC) {
+			do_warn(
+_("rtrefcount inode %" PRIu64 " was not found in the metadata directory tree\n"),
+				lino);
+			return 1;
+		}
+
+		if (!is_rtrefcount_inode(lino)) {
+			do_warn(
+_("could not associate refcount inode %" PRIu64 " with any rtgroup\n"),
+				lino);
+			return 1;
+		}
+	}
 
 	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 	*tot = 0;
@@ -1179,7 +1195,7 @@ _("computed size of rtrefcountbt root (%zu bytes) is greater than space in "
 		error = process_rtrefc_reclist(mp, rp, numrecs,
 				&priv, "rtrefcountbt root");
 		if (error) {
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 			return 1;
 		}
 		return 0;
@@ -2143,6 +2159,9 @@ process_check_metadata_inodes(
 	if (is_rtrmap_inode(lino))
 		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
 				XR_INO_RTRMAP, _("realtime rmap btree"));
+	if (is_rtrefcount_inode(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTREFC, _("realtime refcount btree"));
 	return 0;
 }
 
@@ -2253,6 +2272,18 @@ _("found inode %" PRIu64 " claiming to be a rtrmapbt file, but rmapbt is disable
 		}
 		break;
 
+	case XR_INO_RTREFC:
+		/*
+		 * if we have no refcountbt, any inode claiming
+		 * to be a real-time file is bogus
+		 */
+		if (!xfs_has_reflink(mp)) {
+			do_warn(
+_("found inode %" PRIu64 " claiming to be a rtrefcountbt file, but reflink is disabled\n"), lino);
+			return 1;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -3453,6 +3484,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_PQUOTA;
 		else if (is_rtrmap_inode(lino))
 			type = XR_INO_RTRMAP;
+		else if (is_rtrefcount_inode(lino))
+			type = XR_INO_RTREFC;
 		else
 			type = XR_INO_DATA;
 		break;
diff --git a/repair/dir2.c b/repair/dir2.c
index af00b2d8d6c852..a80160afaea5cf 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -282,6 +282,9 @@ process_sf_dir2(
 		} else if (is_rtrmap_inode(lino)) {
 			junkit = 1;
 			junkreason = _("realtime rmap");
+		} else if (is_rtrefcount_inode(lino)) {
+			junkit = 1;
+			junkreason = _("realtime refcount");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -761,6 +764,8 @@ process_dir2_data(
 			clearreason = _("metadata directory root");
 		} else if (is_rtrmap_inode(ent_ino)) {
 			clearreason = _("realtime rmap");
+		} else if (is_rtrefcount_inode(ent_ino)) {
+			clearreason = _("realtime refcount");
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),
diff --git a/repair/incore.h b/repair/incore.h
index 4add12615e0a04..57019148f588c3 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -242,6 +242,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
 #define XR_INO_RTRMAP	15		/* realtime rmap */
+#define XR_INO_RTREFC	16		/* realtime refcount */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 85a65048db9afc..e39c74cc7b44f7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1699,8 +1699,11 @@ init_refcount_cursor(
  * Disable the refcount btree check.
  */
 void
-refcount_avoid_check(void)
+refcount_avoid_check(
+	struct xfs_mount	*mp)
 {
+	if (xfs_has_rtgroups(mp))
+		mark_rtgroup_inodes_bad(mp, XFS_RTGI_REFCOUNT);
 	refcbt_suspect = true;
 }
 
diff --git a/repair/rmap.h b/repair/rmap.h
index 23859bf6c2ad42..c0984d97322861 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -41,7 +41,7 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
 uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
-extern void refcount_avoid_check(void);
+extern void refcount_avoid_check(struct xfs_mount *mp);
 void check_refcounts(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
diff --git a/repair/scan.c b/repair/scan.c
index 21fa9018800c77..86565ebb9f2faf 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1980,7 +1980,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	libxfs_perag_put(pag);
 out:
 	if (suspect)
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 	return;
 }
 
@@ -2285,7 +2285,7 @@ _("%s btree block claimed (state %d), agno %d, agbno %d, suspect %d\n"),
 	}
 out:
 	if (suspect) {
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 		return 1;
 	}
 
@@ -3148,7 +3148,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_refc_maxlevels) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
 				levels, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_refcount_root);
@@ -3166,7 +3166,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 	}
 

