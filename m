Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68727C388F9
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4BD223FB
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507851AbgJVFPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:15:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59137 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444251AbgJVFPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:15:43 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 98DB43ABF4C
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 16:15:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-0034Kv-TU
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-009aoR-Li
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] repair: don't duplicate names in phase 6
Date:   Thu, 22 Oct 2020 16:15:35 +1100
Message-Id: <20201022051537.2286402-6-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022051537.2286402-1-david@fromorbit.com>
References: <20201022051537.2286402-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=ktqsFqGhlViaf363e9wA:9
        a=v6a9nb2BsVOmaqJX:21 a=Oikw1yXlmi1R5_1x:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The name hash in phase 6 is constructed by using names that point
directly into the directory buffers. Hence before the buffers can be
released, the constructed name hash has to duplicate all those names
into meory it owns via dir_hash_dup_names().

Given that the structure that holds the name is dynamically
allocated, it makes no sense to store a pointer to the name
dir_hash_add() and then later have dynamically allocate the name.

Extend the name hash allocation to contain space for the name
itself, and copy the name into the name hash structure in
dir_hash_add(). This allows us to get rid of dir_hash_dup_names(),
and the directory checking code no longer needs to hold all the
directory buffers in memory until the entire directory walk is
complete and the names duplicated.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 101 ++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 72 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index bf0719c186fb..79c87495656f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -72,7 +72,7 @@ typedef struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
 	uint32_t		address;	/* offset of data entry */
-	xfs_ino_t 		inum;		/* inode num of entry */
+	xfs_ino_t		inum;		/* inode num of entry */
 	short			junkit;		/* name starts with / */
 	short			seen;		/* have seen leaf entry */
 	struct xfs_name		name;
@@ -80,7 +80,6 @@ typedef struct dir_hash_ent {
 
 typedef struct dir_hash_tab {
 	int			size;		/* size of hash tables */
-	int			names_duped;	/* 1 = ent names malloced */
 	dir_hash_ent_t		*first;		/* ptr to first added entry */
 	dir_hash_ent_t		*last;		/* ptr to last added entry */
 	dir_hash_ent_t		**byhash;	/* ptr to name hash buckets */
@@ -171,8 +170,6 @@ dir_hash_add(
 	short			junk;
 	struct xfs_name		xname;
 
-	ASSERT(!hashtab->names_duped);
-
 	xname.name = name;
 	xname.len = namelen;
 	xname.type = ftype;
@@ -199,7 +196,12 @@ dir_hash_add(
 		}
 	}
 
-	if ((p = malloc(sizeof(*p))) == NULL)
+	/*
+	 * Allocate enough space for the hash entry and the name in a single
+	 * allocation so we can store our own copy of the name for later use.
+	 */
+	p = calloc(1, sizeof(*p) + namelen + 1);
+	if (!p)
 		do_error(_("malloc failed in dir_hash_add (%zu bytes)\n"),
 			sizeof(*p));
 
@@ -220,7 +222,12 @@ dir_hash_add(
 	p->address = addr;
 	p->inum = inum;
 	p->seen = 0;
-	p->name = xname;
+
+	/* Set up the name in the region trailing the hash entry. */
+	memcpy(p + 1, name, namelen);
+	p->name.name = (const unsigned char *)(p + 1);
+	p->name.len = namelen;
+	p->name.type = ftype;
 
 	return !dup;
 }
@@ -287,8 +294,6 @@ dir_hash_done(
 	for (i = 0; i < hashtab->size; i++) {
 		for (p = hashtab->byaddr[i]; p; p = n) {
 			n = p->nextbyaddr;
-			if (hashtab->names_duped)
-				free((void *)p->name.name);
 			free(p);
 		}
 	}
@@ -385,27 +390,6 @@ dir_hash_see_all(
 	return j == stale ? DIR_HASH_CK_OK : DIR_HASH_CK_BADSTALE;
 }
 
-/*
- * Convert name pointers into locally allocated memory.
- * This must only be done after all the entries have been added.
- */
-static void
-dir_hash_dup_names(dir_hash_tab_t *hashtab)
-{
-	unsigned char		*name;
-	dir_hash_ent_t		*p;
-
-	if (hashtab->names_duped)
-		return;
-
-	for (p = hashtab->first; p; p = p->nextbyorder) {
-		name = malloc(p->name.len);
-		memcpy(name, p->name.name, p->name.len);
-		p->name.name = name;
-	}
-	hashtab->names_duped = 1;
-}
-
 /*
  * Given a block number in a fork, return the next valid block number
  * (not a hole).
@@ -1387,6 +1371,7 @@ dir2_kill_block(
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
+	libxfs_trans_bhold(tp, bp);
 	memset(&args, 0, sizeof(args));
 	args.dp = ip;
 	args.trans = tp;
@@ -1418,7 +1403,7 @@ longform_dir2_entry_check_data(
 	int			*need_dot,
 	ino_tree_node_t		*current_irec,
 	int			current_ino_offset,
-	struct xfs_buf		**bpp,
+	struct xfs_buf		*bp,
 	dir_hash_tab_t		*hashtab,
 	freetab_t		**freetabp,
 	xfs_dablk_t		da_bno,
@@ -1426,7 +1411,6 @@ longform_dir2_entry_check_data(
 {
 	xfs_dir2_dataptr_t	addr;
 	xfs_dir2_leaf_entry_t	*blp;
-	struct xfs_buf		*bp;
 	xfs_dir2_block_tail_t	*btp;
 	struct xfs_dir2_data_hdr *d;
 	xfs_dir2_db_t		db;
@@ -1457,7 +1441,6 @@ longform_dir2_entry_check_data(
 	};
 
 
-	bp = *bpp;
 	d = bp->b_addr;
 	ptr = (char *)d + mp->m_dir_geo->data_entry_offset;
 	nbad = 0;
@@ -1558,10 +1541,8 @@ longform_dir2_entry_check_data(
 			dir2_kill_block(mp, ip, da_bno, bp);
 		} else {
 			do_warn(_("would junk block\n"));
-			libxfs_buf_relse(bp);
 		}
 		freetab->ents[db].v = NULLDATAOFF;
-		*bpp = NULL;
 		return;
 	}
 
@@ -2219,17 +2200,15 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			int		ino_offset,
 			dir_hash_tab_t	*hashtab)
 {
-	struct xfs_buf		**bplist;
+	struct xfs_buf		*bp;
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
-	int			num_bps;
 	int			i;
 	int			isblock;
 	int			isleaf;
 	xfs_fileoff_t		next_da_bno;
 	int			seeval;
 	int			fixit = 0;
-	xfs_dir2_db_t		db;
 	struct xfs_da_args	args;
 
 	*need_dot = 1;
@@ -2246,11 +2225,6 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		freetab->ents[i].v = NULLDATAOFF;
 		freetab->ents[i].s = 0;
 	}
-	num_bps = freetab->naents;
-	bplist = calloc(num_bps, sizeof(struct xfs_buf*));
-	if (!bplist)
-		do_error(_("calloc failed in %s (%zu bytes)\n"),
-			__func__, num_bps * sizeof(struct xfs_buf*));
 
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
@@ -2279,28 +2253,12 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			break;
 		}
 
-		db = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
-		if (db >= num_bps) {
-			int last_size = num_bps;
-
-			/* more data blocks than expected */
-			num_bps = db + 1;
-			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
-			if (!bplist)
-				do_error(_("realloc failed in %s (%zu bytes)\n"),
-					__func__,
-					num_bps * sizeof(struct xfs_buf*));
-			/* Initialize the new elements */
-			for (i = last_size; i < num_bps; i++)
-				bplist[i] = NULL;
-		}
-
 		if (isblock)
 			ops = &xfs_dir3_block_buf_ops;
 		else
 			ops = &xfs_dir3_data_buf_ops;
 
-		error = dir_read_buf(ip, da_bno, &bplist[db], ops, &fixit);
+		error = dir_read_buf(ip, da_bno, &bp, ops, &fixit);
 		if (error) {
 			do_warn(
 	_("can't read data block %u for directory inode %" PRIu64 " error %d\n"),
@@ -2320,21 +2278,25 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		}
 
 		/* check v5 metadata */
-		d = bplist[db]->b_addr;
+		d = bp->b_addr;
 		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
 		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
-			struct xfs_buf		 *bp = bplist[db];
-
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
+				if (isblock)
+					goto out_fix;
 				continue;
 			}
 		}
 
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-				irec, ino_offset, &bplist[db], hashtab,
+				irec, ino_offset, bp, hashtab,
 				&freetab, da_bno, isblock);
+		if (isblock)
+			break;
+
+		libxfs_buf_relse(bp);
 	}
 	fixit |= (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
 
@@ -2345,7 +2307,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			xfs_dir2_block_tail_t	*btp;
 			xfs_dir2_leaf_entry_t	*blp;
 
-			block = bplist[0]->b_addr;
+			block = bp->b_addr;
 			btp = xfs_dir2_block_tail_p(mp->m_dir_geo, block);
 			blp = xfs_dir2_block_leaf_p(btp);
 			seeval = dir_hash_see_all(hashtab, blp,
@@ -2362,11 +2324,10 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		}
 	}
 out_fix:
+	if (isblock && bp)
+		libxfs_buf_relse(bp);
+
 	if (!no_modify && (fixit || dotdot_update)) {
-		dir_hash_dup_names(hashtab);
-		for (i = 0; i < num_bps; i++)
-			if (bplist[i])
-				libxfs_buf_relse(bplist[i]);
 		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
 		*num_illegal = 0;
 		*need_dot = 0;
@@ -2374,12 +2335,8 @@ out_fix:
 		if (fixit || dotdot_update)
 			do_warn(
 	_("would rebuild directory inode %" PRIu64 "\n"), ino);
-		for (i = 0; i < num_bps; i++)
-			if (bplist[i])
-				libxfs_buf_relse(bplist[i]);
 	}
 
-	free(bplist);
 	free(freetab);
 }
 
-- 
2.28.0

