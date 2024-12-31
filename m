Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1972C29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688754; cv=none; b=Pj1JxvaPojElbrWUooEkSoAoWJ5mtsgtYVg3ZOZPgtJJAfvku4gcJYg6ElMluHBdzd9Y72z5ZNNY6mUxWhIL/2oKm7UmcIdmo3r7Eky5s1XZdoeHVAk5BXx7DjRXZYF3v0kTS0R8g9fmVcYgFZ3wtvJsIC0emJkdpYEs8GBuu/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688754; c=relaxed/simple;
	bh=vOvBSt6CEDdc7vD9vhQlu0A0DHO4gYI/wqqWBlY5kl8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJdeaX4/n2R64Gc25FCKneG8I4lJnuGeIBni8HtZQ/WtTtL8qCNa7tAfr+BZTlNYpVF/YJU1sxe0JjqhPP+dkBAyx2I4NzjHcBFBtK1gmVaIio/kS1S5zJ3XWKe1LaYLnmbsZzUQEkArSYc8fElpiRXh1R05/TWw6D/NCh8r3/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9RABNsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9RABNsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCF7C4CED2;
	Tue, 31 Dec 2024 23:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688753;
	bh=vOvBSt6CEDdc7vD9vhQlu0A0DHO4gYI/wqqWBlY5kl8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X9RABNsSmfahNP6afRiw8Ym4CBbUeOc++DP/GGcNtzkBlEOF/Eqohx+j7o7AAbrHS
	 4dBjLEvrUbNpUD4uTjeNlb3U3A78QCjpX2IzEmLqUQfg71kYZVKIjGwFNNoMCnlliu
	 zxcHJudUCdaX26pkfjnUBTUMp3ZjM79tfow00V/Qwocm0tyu/Q4d4wp2bsFsLRBdKD
	 Blro3s08zJiQK2UVSKEXSIXxpQNe9EHptiDOaGWaecBlG8KfarKapIfk/3FAaZozMU
	 AIGwpWjJRz796BI/72eUAZdZpiE0JYxlkLgWwvg/Oeah0fX7WNshbpcFLfjN/k5uzH
	 Ye3G+6H4E45Xg==
Date: Tue, 31 Dec 2024 15:45:53 -0800
Subject: [PATCH 04/11] xfs_db: get and put blocks on the AGFL
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777931.2709794.2210883689118756992.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new xfs_db command to let people add and remove blocks from an
AGFL.  This isn't really related to rmap btree reconstruction, other
than enabling debugging code to mess around with the AGFL to exercise
various odd scenarios.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/agfl.c                |  297 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    4 +
 man/man8/xfs_db.8        |   11 ++
 3 files changed, 308 insertions(+), 4 deletions(-)


diff --git a/db/agfl.c b/db/agfl.c
index f0f3f21a64d12c..cf5a2407f6b6d8 100644
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
+	struct xfs_mount	*mp = pag_mount(pag);
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
+	printf(fmt, pag_agno(di->pag), (unsigned int)start,
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
+	const unsigned int	agfl_size = libxfs_agfl_size(pag_mount(pag));
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
+		printf(_("agfl %u: %s\n"), pag_agno(pag), strerror(error));
+	return error;
+}
+
+/* Add blocks to the AGFL. */
+static int
+agfl_put(
+	struct xfs_perag	*pag,
+	int			quantity)
+{
+	struct xfs_alloc_arg	args = {
+		.mp		= pag_mount(pag),
+		.alignment	= 1,
+		.minlen		= 1,
+		.prod		= 1,
+		.resv		= XFS_AG_RESV_AGFL,
+		.oinfo		= XFS_RMAP_OINFO_AG,
+	};
+	struct xfs_buf		*agfl_bp;
+	struct xfs_agf		*agf;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		target;
+	const unsigned int	agfl_size = libxfs_agfl_size(pag_mount(pag));
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
+	args.tp = tp;
+
+	error = -libxfs_alloc_read_agf(pag, tp, 0, &args.agbp);
+	if (error)
+		goto out_cancel;
+
+	agf = args.agbp->b_addr;
+	args.maxlen = min(quantity, agfl_size - be32_to_cpu(agf->agf_flcount));
+
+	if (eoag)
+		target = xfs_agbno_to_fsb(pag,
+				be32_to_cpu(agf->agf_length) - 1);
+	else
+		target = xfs_agbno_to_fsb(pag, 0);
+
+	error = -libxfs_alloc_read_agfl(pag, tp, &agfl_bp);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_alloc_vextent_near_bno(&args, target);
+	if (error)
+		goto out_cancel;
+
+	if (args.agbno == NULLAGBLOCK) {
+		error = ENOSPC;
+		goto out_cancel;
+	}
+
+	for (i = 0; i < args.len; i++) {
+		error = -libxfs_alloc_put_freelist(pag, tp, args.agbp,
+				agfl_bp, args.agbno + i, 0);
+		if (error)
+			goto out_cancel;
+	}
+
+	if (i == 1)
+		printf(_("agfl %u: added agbno %u\n"), pag_agno(pag),
+				args.agbno);
+	else if (i > 1)
+		printf(_("agfl %u: added agbno %u-%u\n"), pag_agno(pag),
+				args.agbno, args.agbno + i - 1);
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
+		printf(_("agfl %u: %s\n"), pag_agno(pag), strerror(error));
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
index 530feef2a47db8..76f55515bb41f7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -31,8 +31,12 @@
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
+#define xfs_alloc_get_freelist		libxfs_alloc_get_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
+#define xfs_alloc_put_freelist		libxfs_alloc_put_freelist
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
+#define xfs_alloc_read_agfl		libxfs_alloc_read_agfl
+#define xfs_alloc_vextent_near_bno	libxfs_alloc_vextent_near_bno
 #define xfs_alloc_vextent_start_ag	libxfs_alloc_vextent_start_ag
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 553adff758bc02..4217e9932dd775 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -182,10 +182,19 @@ .SH COMMANDS
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

