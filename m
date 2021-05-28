Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CE7C4708D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 16:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C192B611CA
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 16:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhE1Qvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 May 2021 12:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbhE1Qum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 May 2021 12:50:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B1CC061761
        for <linux-xfs@vger.kernel.org>; Fri, 28 May 2021 09:48:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t21so1909896plo.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 May 2021 09:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fk4P26xr686tF+xIyGU/aKm4+K/mCK1doFPb6J9/qRU=;
        b=DmDHuAu+RWumXnkd9P+goeN9Ajbi8qMiZnNjPNWHRguReyu5RFohhzxijmyhw5nO1H
         SpA8SlWJAjzKi4wLm1yZSXFhGn8q3DEwX7Ri9KmFiAB4R1bE71qQdyMk+yw8JBaBjBXi
         K2dRiR6TgDrE9E2Vn6wG5mfANKklClZmc2QAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fk4P26xr686tF+xIyGU/aKm4+K/mCK1doFPb6J9/qRU=;
        b=MxtmtAuBz1efN1Mx+JUUShp5Hb5oqkn4LSAtNIlIQ7RVkMvliusLTctfKaQNu9uCF1
         6qBHErktka61nccoutTwqf5DvWZRhxVZmF/wVBxYD/45NxcPqgNg3/re5CBku/PWrfhp
         XM6BvHIcNq+4lI5Up+6A2sOUXIzeAa6JGIZr/FbhYUXhG8bdYUZ9T1+QjPDeFQTgUuKL
         1gRCwos8d3LYSdsFoGofE8tF2KeFExBifwL2EiFhqTth2VX5qLkWxRK2VzyE+tQJ/Uis
         0w4ICcZ/6NAfSIN4mnbTjuV/d/T/GWSxZZuOjMqa/5+McockzZj6tPAn2yHZSQmtF4Ue
         3sxQ==
X-Gm-Message-State: AOAM532M5SMVl96vF/zJxiCt6yk8ekmi9Htw84q2mwF9FDdcUEkPYJ/o
        hhO6FcyBom+3yvk4v9KVgVjeUw==
X-Google-Smtp-Source: ABdhPJz4tN3fsTmPtH+o2ZGij1qrcH42kyM2eEUecEgZ96t09kDhE2CHnwD+wXVGAK4Bq4zsbMvCiA==
X-Received: by 2002:a17:90a:74f:: with SMTP id s15mr5411481pje.90.1622220521634;
        Fri, 28 May 2021 09:48:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d66sm985280pfa.32.2021.05.28.09.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 09:48:40 -0700 (PDT)
Date:   Fri, 28 May 2021 09:48:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
Message-ID: <202105280915.9117D7C@keescook>
References: <20210420230652.GA70650@embeddedor>
 <20210420233850.GQ3122264@magnolia>
 <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
 <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
 <20210526211624.GB202121@locust>
 <202105271358.22E0E2BFD@keescook>
 <20210528003454.GN2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528003454.GN2402049@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 05:34:54PM -0700, Darrick J. Wong wrote:
> The choices are bad, so **turn it off** in fs/xfs/Makefile and don't go
> making us clutter up shared library code that will then have to be
> ported to userspace.

Ah! So the concern you have is with portable code shared outside of
the kernel? This came up also with the ACPICA code (which is regularly
imported into the kernel tree), and they just included their own macro
directly[1].

Would you prefer something like that, which would be XFS-specific? I'm
just trying to find a way to avoid losing fall-through coverage
in XFS. (Especially since distros are slowly moving toward enabling
-Wimplicit-fallthrough by default since it's a long-standing weakness
in the C language, and has been hiding real bugs for years.)

It seems like the options here could be:
1) Use an XFS-specific macro like ACPICA does, so that the out-of-tree
   userspace code can share it (more typing, keep coverage).
2) Add -Wno-implicit-fallthrough to fs/xfs/Makefile (easy, lose coverage).

For 1), which portions are shared between xfsprogs and the kernel? Only
libxfs/ and scrub/? How does the below patch look? I could prepare similar
for all of xfsprogs, or do this only for xfsprogs and leave the stuff
outside of libxfs/ and scrube/ using the kernel's "fallthrough" macro?

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 782fdd08f759..ade529ddb60b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -184,4 +184,14 @@ struct xfs_ino_geometry {
 
 };
 
+/* Programmatically mark implicit fallthroughs for GCC and Clang. */
+#ifndef __has_attribute
+#define __has_attribute(x) 0
+#endif
+#if __has_attribute(__fallthrough__)
+#define XFS_FALLTHROUGH __attribute__((__fallthrough__))
+#else
+#define XFS_FALLTHROUGH do { } while (0)
+#endif
+
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e32a1833d523..2cf035ce6a3e 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -354,7 +354,7 @@ xfs_ag_resv_alloc_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case XFS_AG_RESV_NONE:
 		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
 				       XFS_TRANS_SB_FDBLOCKS;
@@ -396,7 +396,7 @@ xfs_ag_resv_free_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
 		return;
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 82b7cbb1f24f..5694e5ac925c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3174,7 +3174,7 @@ xfs_alloc_vextent(
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		/* FALLTHROUGH */
+		XFS_FALLTHROUGH;
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 83ac9771bfb5..20a518757b75 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -282,7 +282,7 @@ xfs_da3_node_read_verify(
 						__this_address);
 				break;
 			}
-			/* fall through */
+			XFS_FALLTHROUGH;
 		case XFS_DA_NODE_MAGIC:
 			fa = xfs_da3_node_verify(bp);
 			if (fa)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b5ebf1d1b4db..17964bc0c04d 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -271,7 +271,7 @@ xchk_bmap_iextent_xref(
 	case XFS_DATA_FORK:
 		if (xfs_is_reflink_inode(info->sc->ip))
 			break;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case XFS_ATTR_FORK:
 		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index a94bd8122c60..051b79442c68 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -44,7 +44,7 @@ __xchk_btree_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index aa874607618a..30ec2ac1228d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -81,7 +81,7 @@ __xchk_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error,
 				ret_ip);
@@ -134,7 +134,7 @@ __xchk_fblock_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	default:
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
@@ -694,7 +694,7 @@ xchk_get_inode(
 		if (error)
 			return -ENOENT;
 		error = -EFSCORRUPTED;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	default:
 		trace_xchk_op_error(sc,
 				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 653f3280e1c1..afbfe731e160 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -47,7 +47,7 @@ xchk_da_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		*error = 0;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	default:
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2857d854c83..68b0f2248b8d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -947,7 +947,7 @@ xrep_ino_dqattach(
 			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
 		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
 			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case -ESRCH:
 		error = 0;
 		break;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a5e9d7d34023..3e467aa11ee5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -242,7 +242,7 @@ xfs_bmap_count_blocks(
 		 */
 		*count += btblocks - 1;
 
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case XFS_DINODE_FMT_EXTENTS:
 		*nextents = xfs_bmap_count_leaves(ifp, count);
 		break;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 465fd9e048d4..dcf92f90be05 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -84,7 +84,7 @@ xfs_fs_encode_fh(
 	case FILEID_INO32_GEN_PARENT:
 		fid->i32.parent_ino = XFS_I(parent)->i_ino;
 		fid->i32.parent_gen = parent->i_generation;
-		/*FALLTHRU*/
+		XFS_FALLTHROUGH;
 	case FILEID_INO32_GEN:
 		fid->i32.ino = XFS_I(inode)->i_ino;
 		fid->i32.gen = inode->i_generation;
@@ -92,7 +92,7 @@ xfs_fs_encode_fh(
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		fid64->parent_ino = XFS_I(parent)->i_ino;
 		fid64->parent_gen = parent->i_generation;
-		/*FALLTHRU*/
+		XFS_FALLTHROUGH;
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
 		fid64->ino = XFS_I(inode)->i_ino;
 		fid64->gen = inode->i_generation;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396ef36dcd0a..f4f58e5e8d3b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -863,7 +863,7 @@ xfs_break_layouts(
 			error = xfs_break_dax_layouts(inode, &retry);
 			if (error || retry)
 				break;
-			/* fall through */
+			XFS_FALLTHROUGH;
 		case BREAK_WRITE:
 			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			break;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 34f2b971ce43..d6cdd87eb2cf 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -100,7 +100,6 @@ xfs_fsmap_owner_to_rmap(
 		dest->rm_owner = XFS_RMAP_OWN_COW;
 		break;
 	case XFS_FMR_OWN_DEFECTIVE:	/* not implemented */
-		/* fall through */
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0369eb22c1bb..cb9ae2cb209a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -848,7 +848,7 @@ xfs_init_new_inode(
 			xfs_inode_inherit_flags(ip, pip);
 		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
 			xfs_inode_inherit_flags2(ip, pip);
-		/* FALLTHROUGH */
+		XFS_FALLTHROUGH;
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_bytes = 0;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3925bfcb2365..ae4bffc3a979 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -558,7 +558,7 @@ xfs_ioc_attrmulti_one(
 	case ATTR_OP_REMOVE:
 		value = NULL;
 		*len = 0;
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case ATTR_OP_SET:
 		error = mnt_want_write_file(parfilp);
 		if (error)
@@ -1544,7 +1544,7 @@ xfs_ioc_getbmap(
 	switch (cmd) {
 	case XFS_IOC_GETBMAPA:
 		bmx.bmv_iflags = BMV_IF_ATTRFORK;
-		/*FALLTHRU*/
+		XFS_FALLTHROUGH;
 	case XFS_IOC_GETBMAP:
 		/* struct getbmap is a strict subset of struct getbmapx. */
 		recsize = sizeof(struct getbmap);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d154f42e2dc6..8fc7afb9b070 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1036,7 +1036,7 @@ xfs_buffered_write_iomap_begin(
 			prealloc_blocks = 0;
 			goto retry;
 		}
-		/*FALLTHRU*/
+		XFS_FALLTHROUGH;
 	default:
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 9aced0a00003..dc5d8b8d32e3 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -294,7 +294,7 @@ xfs_trans_read_buf_map(
 	default:
 		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		/* fall through */
+		XFS_FALLTHROUGH;
 	case -ENOMEM:
 	case -EAGAIN:
 		return error;



-Kees

[1] https://github.com/acpica/acpica/commit/4b9135f5774caa796ddf826448811e8e7f08ef2f

-- 
Kees Cook
