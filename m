Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38337C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiLaD2o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLaD2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:28:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D9164B7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:28:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B90B81DDB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25301C433D2;
        Sat, 31 Dec 2022 03:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457320;
        bh=ozHaHfsg0uVDShw8f2EIvbyw23/uhyU4YsCYSVdVDEk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eOeeBF3lpXUOPwXvlD8iSCobv8pKWKsh8gX3FSO06xOpch7Zv7XuYPMGHt+FS9U6Y
         MHTbEJaaTtLwCQU9Dn4inenWI3stIFHHSpxmEhjXOO90b38LhcaqeeHPt6WpKsELPA
         4uv4iLPRf/DYzhojQRn6YGLCQE34Do3mTow2dMMfVOfMeI5brAW/EOTA8z/vsBQzPR
         4e2KtfqFc8g7rOmg9Bcjg1nmOD7uWhDT1d37JRhGGtYuyWA8wJ7+7tiD+wZYfb8uem
         PAr6JmFknDy1c2fHBBzX3DIlhsVQj6BBnc+rlE9V6fClESpFNdpOeYs6RvZUJwRPva
         ZfZasR+kea7Tg==
Subject: [PATCH 3/5] xfs_db: get and put blocks on the AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884804.740087.325927225945471829.stgit@magnolia>
In-Reply-To: <167243884763.740087.13414287212519500865.stgit@magnolia>
References: <167243884763.740087.13414287212519500865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new xfs_db command to let people add and remove blocks from an
AGFL.  This isn't really related to rmap btree reconstruction, other
than enabling debugging code to mess around with the AGFL to exercise
various odd scenarios.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/agfl.c                |  297 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    3 
 man/man8/xfs_db.8        |   11 ++
 3 files changed, 307 insertions(+), 4 deletions(-)


diff --git a/db/agfl.c b/db/agfl.c
index f0f3f21a64d..804653e40b5 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -15,13 +15,14 @@
 #include "output.h"
 #include "init.h"
 #include "agfl.h"
+#include "libfrog/bitmap.h"
 
 static int agfl_bno_size(void *obj, int startoff);
 static int agfl_f(int argc, char **argv);
 static void agfl_help(void);
 
 static const cmdinfo_t agfl_cmd =
-	{ "agfl", NULL, agfl_f, 0, 1, 1, N_("[agno]"),
+	{ "agfl", NULL, agfl_f, 0, -1, 1, N_("[agno] [-g nr] [-p nr]"),
 	  N_("set address to agfl block"), agfl_help };
 
 const field_t	agfl_hfld[] = { {
@@ -77,10 +78,280 @@ agfl_help(void)
 " for each allocation group.  This acts as a reserved pool of space\n"
 " separate from the general filesystem freespace (not used for user data).\n"
 "\n"
+" -g quantity\tRemove this many blocks from the AGFL.\n"
+" -p quantity\tAdd this many blocks to the AGFL.\n"
+"\n"
 ));
 
 }
 
+struct dump_info {
+	struct xfs_perag	*pag;
+	bool			leak;
+};
+
+/* Return blocks freed from the AGFL to the free space btrees. */
+static int
+free_grabbed(
+	uint64_t		start,
+	uint64_t		length,
+	void			*data)
+{
+	struct dump_info	*di = data;
+	struct xfs_perag	*pag = di->pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_trans	*tp;
+	struct xfs_buf		*agf_bp;
+	int			error;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
+			&tp);
+	if (error)
+		return error;
+
+	error = -libxfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_free_extent(tp, pag, start, length, &XFS_RMAP_OINFO_AG,
+			XFS_AG_RESV_AGFL);
+	if (error)
+		goto out_cancel;
+
+	return -libxfs_trans_commit(tp);
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+	return error;
+}
+
+/* Report blocks freed from the AGFL. */
+static int
+dump_grabbed(
+	uint64_t		start,
+	uint64_t		length,
+	void			*data)
+{
+	struct dump_info	*di = data;
+	const char		*fmt;
+
+	if (length == 1)
+		fmt = di->leak ? _("agfl %u: leaked agbno %u\n") :
+				 _("agfl %u: removed agbno %u\n");
+	else
+		fmt = di->leak ? _("agfl %u: leaked agbno %u-%u\n") :
+				 _("agfl %u: removed agbno %u-%u\n");
+
+	printf(fmt, di->pag->pag_agno, (unsigned int)start,
+			(unsigned int)(start + length - 1));
+	return 0;
+}
+
+/* Remove blocks from the AGFL. */
+static int
+agfl_get(
+	struct xfs_perag	*pag,
+	int			quantity)
+{
+	struct dump_info	di = {
+		.pag		= pag,
+		.leak		= quantity < 0,
+	};
+	struct xfs_agf		*agf;
+	struct xfs_buf		*agf_bp;
+	struct xfs_trans	*tp;
+	struct bitmap		*grabbed;
+	const unsigned int	agfl_size = libxfs_agfl_size(pag->pag_mount);
+	unsigned int		i;
+	int			error;
+
+	if (!quantity)
+		return 0;
+
+	if (di.leak)
+		quantity = -quantity;
+	quantity = min(quantity, agfl_size);
+
+	error = bitmap_alloc(&grabbed);
+	if (error)
+		goto out;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, quantity, 0,
+			0, &tp);
+	if (error)
+		goto out_bitmap;
+
+	error = -libxfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		goto out_cancel;
+
+	agf = agf_bp->b_addr;
+	quantity = min(quantity, be32_to_cpu(agf->agf_flcount));
+
+	for (i = 0; i < quantity; i++) {
+		xfs_agblock_t	agbno;
+
+		error = -libxfs_alloc_get_freelist(pag, tp, agf_bp, &agbno, 0);
+		if (error)
+			goto out_cancel;
+
+		if (agbno == NULLAGBLOCK) {
+			error = ENOSPC;
+			goto out_cancel;
+		}
+
+		error = bitmap_set(grabbed, agbno, 1);
+		if (error)
+			goto out_cancel;
+	}
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		goto out_bitmap;
+
+	error = bitmap_iterate(grabbed, dump_grabbed, &di);
+	if (error)
+		goto out_bitmap;
+
+	if (!di.leak) {
+		error = bitmap_iterate(grabbed, free_grabbed, &di);
+		if (error)
+			goto out_bitmap;
+	}
+
+	bitmap_free(&grabbed);
+	return 0;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_bitmap:
+	bitmap_free(&grabbed);
+out:
+	if (error)
+		printf(_("agfl %u: %s\n"), pag->pag_agno, strerror(error));
+	return error;
+}
+
+/* Add blocks to the AGFL. */
+static int
+agfl_put(
+	struct xfs_perag	*pag,
+	int			quantity)
+{
+	struct xfs_alloc_arg	targs = {
+		.mp		= pag->pag_mount,
+		.alignment	= 1,
+		.minlen		= 1,
+		.prod		= 1,
+		.type		= XFS_ALLOCTYPE_NEAR_BNO,
+		.resv		= XFS_AG_RESV_AGFL,
+		.oinfo		= XFS_RMAP_OINFO_AG,
+	};
+	struct xfs_buf		*agfl_bp;
+	struct xfs_agf		*agf;
+	struct xfs_trans	*tp;
+	const unsigned int	agfl_size = libxfs_agfl_size(pag->pag_mount);
+	unsigned int		i;
+	bool			eoag = quantity < 0;
+	int			error;
+
+	if (!quantity)
+		return 0;
+
+	if (eoag)
+		quantity = -quantity;
+	quantity = min(quantity, agfl_size);
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, quantity, 0,
+			0, &tp);
+	if (error)
+		return error;
+	targs.tp = tp;
+
+	error = -libxfs_alloc_read_agf(pag, tp, 0, &targs.agbp);
+	if (error)
+		goto out_cancel;
+
+	agf = targs.agbp->b_addr;
+	targs.maxlen = min(quantity, agfl_size - be32_to_cpu(agf->agf_flcount));
+
+	if (eoag)
+		targs.fsbno = XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
+				be32_to_cpu(agf->agf_length) - 1);
+	else
+		targs.fsbno = XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno, 0);
+
+	error = -libxfs_alloc_read_agfl(pag, tp, &agfl_bp);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_alloc_vextent(&targs);
+	if (error)
+		goto out_cancel;
+
+	if (targs.agbno == NULLAGBLOCK) {
+		error = ENOSPC;
+		goto out_cancel;
+	}
+
+	for (i = 0; i < targs.len; i++) {
+		error = -libxfs_alloc_put_freelist(pag, tp, targs.agbp,
+				agfl_bp, targs.agbno + i, 0);
+		if (error)
+			goto out_cancel;
+	}
+
+	if (i == 1)
+		printf(_("agfl %u: added agbno %u\n"), pag->pag_agno,
+				targs.agbno);
+	else if (i > 1)
+		printf(_("agfl %u: added agbno %u-%u\n"), pag->pag_agno,
+				targs.agbno, targs.agbno + i - 1);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	return 0;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out:
+	if (error)
+		printf(_("agfl %u: %s\n"), pag->pag_agno, strerror(error));
+	return error;
+}
+
+static void
+agfl_adjust(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			gblocks,
+	int			pblocks)
+{
+	struct xfs_perag	*pag;
+	int			error;
+
+	if (!expert_mode) {
+		printf(_("AGFL get/put only supported in expert mode.\n"));
+		exitcode = 1;
+		return;
+	}
+
+	pag = libxfs_perag_get(mp, agno);
+
+	error = agfl_get(pag, gblocks);
+	if (error)
+		goto out_pag;
+
+	error = agfl_put(pag, pblocks);
+
+out_pag:
+	libxfs_perag_put(pag);
+	if (error)
+		exitcode = 1;
+}
+
 static int
 agfl_f(
 	int		argc,
@@ -88,9 +359,25 @@ agfl_f(
 {
 	xfs_agnumber_t	agno;
 	char		*p;
+	int		c;
+	int		gblocks = 0, pblocks = 0;
 
-	if (argc > 1) {
-		agno = (xfs_agnumber_t)strtoul(argv[1], &p, 0);
+	while ((c = getopt(argc, argv, "g:p:")) != -1) {
+		switch (c) {
+		case 'g':
+			gblocks = atoi(optarg);
+			break;
+		case 'p':
+			pblocks = atoi(optarg);
+			break;
+		default:
+			agfl_help();
+			return 1;
+		}
+	}
+
+	if (argc > optind) {
+		agno = (xfs_agnumber_t)strtoul(argv[optind], &p, 0);
 		if (*p != '\0' || agno >= mp->m_sb.sb_agcount) {
 			dbprintf(_("bad allocation group number %s\n"), argv[1]);
 			return 0;
@@ -98,6 +385,10 @@ agfl_f(
 		cur_agno = agno;
 	} else if (cur_agno == NULLAGNUMBER)
 		cur_agno = 0;
+
+	if (gblocks || pblocks)
+		agfl_adjust(mp, cur_agno, gblocks, pblocks);
+
 	ASSERT(typtab[TYP_AGFL].typnm == TYP_AGFL);
 	set_cur(&typtab[TYP_AGFL],
 		XFS_AG_DADDR(mp, cur_agno, XFS_AGFL_DADDR(mp)),
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 63607cf2b94..d4bc59f3bd1 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -29,8 +29,11 @@
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
+#define xfs_alloc_get_freelist		libxfs_alloc_get_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
+#define xfs_alloc_put_freelist		libxfs_alloc_put_freelist
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
+#define xfs_alloc_read_agfl		libxfs_alloc_read_agfl
 #define xfs_alloc_vextent		libxfs_alloc_vextent
 
 #define xfs_attr_get			libxfs_attr_get
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a694c8ed916..b0ae2abea57 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -182,10 +182,19 @@ Set current address to the AGF block for allocation group
 .IR agno .
 If no argument is given, use the current allocation group.
 .TP
-.BI "agfl [" agno ]
+.BI "agfl [" agno "] [\-g " " quantity" "] [\-p " quantity ]
 Set current address to the AGFL block for allocation group
 .IR agno .
 If no argument is given, use the current allocation group.
+If the
+.B -g
+option is specified with a positive quantity, remove that many blocks from the
+AGFL and put them in the free space btrees.
+If the quantity is negative, remove the blocks and leak them.
+If the
+.B -p
+option is specified, add that many blocks to the AGFL.
+If the quantity is negative, the blocks are selected from the end of the AG.
 .TP
 .BI "agi [" agno ]
 Set current address to the AGI block for allocation group

