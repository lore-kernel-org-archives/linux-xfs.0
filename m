Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADAE2D374A
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556708; cv=none; b=CfyFqfBBRKMCFQD+MILxF9TeImzPlKSfsixhywMxlw33vn+t0wSXFYx4/UkVOSZeA0xw7eArDfGNDTErpQnN0UWMMSyD/gmvwgeTUVFiBt05E2ySSmWq0jHwNe/6IDofi02biUDWA6L85u/k48X47cP9NKkSy++Rn+Sxe6FGyf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556708; c=relaxed/simple;
	bh=srchjsrcBupRpZ00Ns/PXoGqXA5UAPFUPOpswOeg9Dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3dTQQHpCdQ+W7Zd9qCdSQ8UDXwpTBTvQsOEQzb6Y2DbYJOwpwCYd85oyjza+ygN7z0YF8hDJzaypqgnhYUh3bK8nA9SYb+h4b6jndiBPNqQn8NfC34fY2miLZCWPPDkSMfkfUfIJo4aJo3AZfuA2vNEaabwdxqdm+y7C0OAHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SE8Nd9ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SE8Nd9ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD10C4CEE3;
	Tue, 15 Jul 2025 05:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556707;
	bh=srchjsrcBupRpZ00Ns/PXoGqXA5UAPFUPOpswOeg9Dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SE8Nd9owzy2WmZDJsSi46EuyrFdggh6yjEoa8MllTOix0tWK8qOD63PQ0M4GqGrl5
	 puDF18ER/BJiy6SRbuKGRGqN3oyEjRKLYuUux0c6Ad2gYdl1AxxRE1vZG5vPB8QT3l
	 oMzAfWwknke9N7tZvBYS1gm/34d0CoBNbkKSWd/ghKBazF9ZrnL6FwM+KbUeWm7oIU
	 TmANRz5HBcLvPjNeXSie9XwR9mvCE4k5YDo2B8fP0zseP8ivQNUmZTXr4rWjmY+tsK
	 YaA1+itNoMLLRXstMiZd6lkF0zW3rVgGJxlR6P9zRhqG2hu59reYArQ8aA0G3AtLwx
	 aHZOfVDSWRKuw==
Date: Mon, 14 Jul 2025 22:18:27 -0700
Subject: [PATCH 2/7] xfs_db: create an untorn_max subcommand
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652491.1831001.5231020590099120986.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a debugger command to compute the either the logres needed to
perform an untorn cow write completion for a given number of blocks; or
the number of blocks that can be completed given a log reservation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    4 +
 db/logformat.c           |  129 ++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8        |   10 ++++
 4 files changed, 144 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index b968a2b88da372..1e0d1a48fbb698 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -102,6 +102,7 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_ag_resv.h"
+#include "defer_item.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c5fcb5e3229ae4..4bd02c57b496e6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -108,6 +108,10 @@
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_calc_finish_bui_reservation	libxfs_calc_finish_bui_reservation
+#define xfs_calc_finish_cui_reservation	libxfs_calc_finish_cui_reservation
+#define xfs_calc_finish_efi_reservation	libxfs_calc_finish_efi_reservation
+#define xfs_calc_finish_rui_reservation	libxfs_calc_finish_rui_reservation
 #define xfs_cntbt_init_cursor		libxfs_cntbt_init_cursor
 #define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_compute_rgblklog		libxfs_compute_rgblklog
diff --git a/db/logformat.c b/db/logformat.c
index 5edaa5494637c8..aba5b0b1b05061 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -192,8 +192,137 @@ static const struct cmdinfo logres_cmd = {
 	.help =		logres_help,
 };
 
+STATIC void
+untorn_cow_limits(
+	struct xfs_mount	*mp,
+	unsigned int		logres,
+	unsigned int		desired_max)
+{
+	const unsigned int	efi = xfs_efi_log_space(1);
+	const unsigned int	efd = xfs_efd_log_space(1);
+	const unsigned int	rui = xfs_rui_log_space(1);
+	const unsigned int	rud = xfs_rud_log_space();
+	const unsigned int	cui = xfs_cui_log_space(1);
+	const unsigned int	cud = xfs_cud_log_space();
+	const unsigned int	bui = xfs_bui_log_space(1);
+	const unsigned int	bud = xfs_bud_log_space();
+
+	/*
+	 * Maximum overhead to complete an untorn write ioend in software:
+	 * remove data fork extent + remove cow fork extent + map extent into
+	 * data fork.
+	 *
+	 * tx0: Creates a BUI and a CUI and that's all it needs.
+	 *
+	 * tx1: Roll to finish the BUI.  Need space for the BUD, an RUI, and
+	 * enough space to relog the CUI (== CUI + CUD).
+	 *
+	 * tx2: Roll again to finish the RUI.  Need space for the RUD and space
+	 * to relog the CUI.
+	 *
+	 * tx3: Roll again, need space for the CUD and possibly a new EFI.
+	 *
+	 * tx4: Roll again, need space for an EFD.
+	 *
+	 * If the extent referenced by the pair of BUI/CUI items is not the one
+	 * being currently processed, then we need to reserve space to relog
+	 * both items.
+	 */
+	const unsigned int	tx0 = bui + cui;
+	const unsigned int	tx1 = bud + rui + cui + cud;
+	const unsigned int	tx2 = rud + cui + cud;
+	const unsigned int	tx3 = cud + efi;
+	const unsigned int	tx4 = efd;
+	const unsigned int	relog = bui + bud + cui + cud;
+
+	const unsigned int	per_intent = max(max3(tx0, tx1, tx2),
+						 max3(tx3, tx4, relog));
+
+	/* Overhead to finish one step of each intent item type */
+	const unsigned int	f1 = libxfs_calc_finish_efi_reservation(mp, 1);
+	const unsigned int	f2 = libxfs_calc_finish_rui_reservation(mp, 1);
+	const unsigned int	f3 = libxfs_calc_finish_cui_reservation(mp, 1);
+	const unsigned int	f4 = libxfs_calc_finish_bui_reservation(mp, 1);
+
+	/* We only finish one item per transaction in a chain */
+	const unsigned int	step_size = max(f4, max3(f1, f2, f3));
+
+	if (desired_max) {
+		dbprintf(
+ "desired_max: %u\nstep_size: %u\nper_intent: %u\nlogres: %u\n",
+				desired_max, step_size, per_intent,
+				(desired_max * per_intent) + step_size);
+	} else if (logres) {
+		dbprintf(
+ "logres: %u\nstep_size: %u\nper_intent: %u\nmax_awu: %u\n",
+				logres, step_size, per_intent,
+				logres >= step_size ? (logres - step_size) / per_intent : 0);
+	}
+}
+
+static void
+untorn_write_max_help(void)
+{
+	dbprintf(_(
+"\n"
+" The 'untorn_write_max' command computes either the log reservation needed to\n"
+" complete an untorn write of a given block count; or the maximum number of\n"
+" blocks that can be completed given a specific log reservation.\n"
+"\n"
+	));
+}
+
+static int
+untorn_write_max_f(
+	int		argc,
+	char		**argv)
+{
+	unsigned int	logres = 0;
+	unsigned int	desired_max = 0;
+	int		c;
+
+	while ((c = getopt(argc, argv, "l:b:")) != EOF) {
+		switch (c) {
+		case 'l':
+			logres = atoi(optarg);
+			break;
+		case 'b':
+			desired_max = atoi(optarg);
+			break;
+		default:
+			untorn_write_max_help();
+			return 0;
+		}
+	}
+
+	if (!logres && !desired_max) {
+		dbprintf("untorn_write_max needs -l or -b option\n");
+		return 0;
+	}
+
+	if (xfs_has_reflink(mp))
+		untorn_cow_limits(mp, logres, desired_max);
+	else
+		dbprintf("untorn write emulation not supported\n");
+
+	return 0;
+}
+
+static const struct cmdinfo untorn_write_max_cmd = {
+	.name =		"untorn_write_max",
+	.altname =	NULL,
+	.cfunc =	untorn_write_max_f,
+	.argmin =	0,
+	.argmax =	-1,
+	.canpush =	0,
+	.args =		NULL,
+	.oneline =	N_("compute untorn write max"),
+	.help =		logres_help,
+};
+
 void
 logres_init(void)
 {
 	add_command(&logres_cmd);
+	add_command(&untorn_write_max_cmd);
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 2a9322560584b0..1e85aebbb5b27c 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1366,6 +1366,16 @@ .SH COMMANDS
 .IR name .
 The file being targetted will not be put on the iunlink list.
 .TP
+.BI "untorn_write_max [\-b " blockcount "|\-l " logres "]"
+If
+.B -l
+is specified, compute the maximum (in fsblocks) untorn write that we can
+emulate with copy on write given a log reservation size (in bytes).
+If
+.B -b
+is specified, compute the log reservation size that would be needed to
+emulate an untorn write of the given number of fsblocks.
+.TP
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
 Set the filesystem universally unique identifier (UUID).
 The filesystem UUID can be used by

