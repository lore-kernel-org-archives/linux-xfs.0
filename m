Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1805B7CAE
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCDB68F8039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QUPTXJ5bvowKeV8Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:51 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 207E885364
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:51 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 4/8] mkfs: change conflicts array into a table capable of
	cross-option addressing
Date: Tue,  2 Aug 2016 17:42:15 +0200
Message-Id: <1470152539-18759-5-git-send-email-jtulak@redhat.com>
In-Reply-To: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
References: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Change subopt_param.conflicts from array of integers into array of structures.
This prepares the ground for more universal conflict detection in future
patches.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 239 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 127 insertions(+), 112 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 14cf7dd..b2fbc58 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -93,8 +93,16 @@ unsigned int		sectorsize;
  *
  *   conflicts MANDATORY
  *     If your subopt is in a conflict with some other option, specify it.
- *     Accepts the .index values of the conflicting subopts and the last
- *     member of this list has to be LAST_CONFLICT.
+ *     Accepts the .index values of the conflicting subopt as .opt (e.g. OPT_D)
+ *     and .subopt (e.g. D_FILE). If .test_values is true, then the conflict
+ *     is raised only when the "remote" suboption .value is equal to
+ *     .invalid_value field and the "current" suboption has .value equal to
+ *     .at_value.
+ *     If .test_values is false, a conflict is raised when the suboption appears
+ *     on the CLI, no matter its value. The field .message contains an optional
+ *     explanatory string for the user. This string can't be translated here,
+ *     so it has to be enveloped with _() when printed.
+ *     The last member of this list has to be {LAST_CONFLICT}.
  *
  *   minval, maxval OPTIONAL
  *     These options are used for automatic range check and they have to be
@@ -133,7 +141,14 @@ struct opt_params {
 		bool		str_seen;
 		bool		convert;
 		bool		is_power_2;
-		int		conflicts[MAX_CONFLICTS];
+		struct subopt_conflict {
+			int		opt;
+			int		subopt;
+			bool		test_values;
+			long long	invalid_value;
+			long long	at_value;
+			const char	*message;
+		} 		conflicts [MAX_CONFLICTS];
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
@@ -153,8 +168,8 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = B_LOG,
-			  .conflicts = { B_SIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_B, B_SIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE_LOG,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -162,8 +177,8 @@ struct opt_params {
 			{ .index = B_SIZE,
 			  .convert = true,
 			  .is_power_2 = true,
-			  .conflicts = { B_LOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_B, B_LOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -209,84 +224,84 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = D_AGCOUNT,
-			  .conflicts = { D_AGSIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_AGSIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = XFS_MAX_AGNUMBER,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_FILE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = D_NAME,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SIZE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = LLONG_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SUNIT,
-			  .conflicts = { D_NOALIGN,
-					 D_SU,
-					 D_SW,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
+					 {OPT_D, D_SU, false, 0, 0},
+					 {OPT_D, D_SW, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SWIDTH,
-			  .conflicts = { D_NOALIGN,
-					 D_SU,
-					 D_SW,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
+					 {OPT_D, D_SU, false, 0, 0},
+					 {OPT_D, D_SW, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_AGSIZE,
-			  .conflicts = { D_AGCOUNT,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_AGCOUNT, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = XFS_AG_MAX_BYTES,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SU,
-			  .conflicts = { D_NOALIGN,
-					 D_SUNIT,
-					 D_SWIDTH,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SW,
-			  .conflicts = { D_NOALIGN,
-					 D_SUNIT,
-					 D_SWIDTH,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTLOG,
-			  .conflicts = { D_SECTSIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_SECTSIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTSIZE,
-			  .conflicts = { D_SECTLOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_SECTLOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
@@ -294,29 +309,29 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_NOALIGN,
-			  .conflicts = { D_SU,
-					 D_SW,
-					 D_SUNIT,
-					 D_SWIDTH,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_D, D_SU, false, 0, 0},
+					 {OPT_D, D_SW, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = D_RTINHERIT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = D_PROJINHERIT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_EXTSZINHERIT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -348,57 +363,57 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = I_ALIGN,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = I_LOG,
-			  .conflicts = { I_PERBLOCK,
-					 I_SIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_I, I_PERBLOCK, false, 0, 0},
+					 {OPT_I, I_SIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_DINODE_MIN_LOG,
 			  .maxval = XFS_DINODE_MAX_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_MAXPCT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 100,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PERBLOCK,
-			  .conflicts = { I_LOG,
-					 I_SIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_I, I_LOG, false, 0, 0},
+					 {OPT_I, I_SIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_INODE_PERBLOCK,
 			  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_SIZE,
-			  .conflicts = { I_PERBLOCK,
-					 I_LOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_I, I_PERBLOCK, false, 0, 0},
+					 {OPT_I, I_LOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
 			  .minval = XFS_DINODE_MIN_SIZE,
 			  .maxval = XFS_DINODE_MAX_SIZE,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_ATTR,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 2,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PROJID32BIT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = I_SPINODES,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -438,64 +453,64 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = L_AGNUM,
-			  .conflicts = { L_DEV,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_DEV, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_INTERNAL,
-			  .conflicts = { L_FILE,
-					 L_DEV,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_FILE, false, 0, 0},
+					 {OPT_L, L_DEV, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = L_SIZE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
 			  .maxval = XFS_MAX_LOG_BYTES,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_VERSION,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 2,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SUNIT,
-			  .conflicts = { L_SU,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_SU, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SU,
-			  .conflicts = { L_SUNIT,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_SUNIT, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = BBTOB(1),
 			  .maxval = XLOG_MAX_RECORD_BSIZE,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_DEV,
-			  .conflicts = { L_AGNUM,
-					 L_INTERNAL,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_AGNUM, false, 0, 0},
+					 {OPT_L, L_INTERNAL, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTLOG,
-			  .conflicts = { L_SECTSIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_SECTSIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTSIZE,
-			  .conflicts = { L_SECTLOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_SECTLOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
@@ -503,20 +518,20 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_FILE,
-			  .conflicts = { L_INTERNAL,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_INTERNAL, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = L_NAME,
-			  .conflicts = { L_AGNUM,
-					 L_INTERNAL,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_L, L_AGNUM, false, 0, 0},
+					 {OPT_L, L_INTERNAL, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_LAZYSBCNTR,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -540,15 +555,15 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = N_LOG,
-			  .conflicts = { N_SIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_N, N_SIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_SIZE,
-			  .conflicts = { N_LOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_N, N_LOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
 			  .minval = 1 << XFS_MIN_REC_DIRSIZE,
@@ -556,13 +571,13 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_VERSION,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 2,
 			  .maxval = 2,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_FTYPE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -590,38 +605,38 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = R_EXTSIZE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_MIN_RTEXTSIZE,
 			  .maxval = XFS_MAX_RTEXTSIZE,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_SIZE,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = LLONG_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_DEV,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_FILE,
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			},
 			{ .index = R_NAME,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_NOALIGN,
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			},
 		},
 	},
@@ -642,25 +657,25 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = S_LOG,
-			  .conflicts = { S_SIZE,
-					 S_SECTSIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_S, S_SIZE, false, 0, 0},
+					 {OPT_S, S_SECTSIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTLOG,
-			  .conflicts = { S_SIZE,
-					 S_SECTSIZE,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_S, S_SIZE, false, 0, 0},
+					 {OPT_S, S_SECTSIZE, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SIZE,
-			  .conflicts = { S_LOG,
-					 S_SECTLOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_S, S_LOG, false, 0, 0},
+					 {OPT_S, S_SECTLOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
@@ -668,9 +683,9 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTSIZE,
-			  .conflicts = { S_LOG,
-					 S_SECTLOG,
-					 LAST_CONFLICT },
+			  .conflicts = { {OPT_S, S_LOG, false, 0, 0},
+					 {OPT_S, S_SECTLOG, false, 0, 0},
+					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
@@ -694,19 +709,19 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = M_CRC,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = M_FINOBT,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = M_UUID,
-			  .conflicts = { LAST_CONFLICT },
+			  .conflicts = { {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 		},
@@ -1308,14 +1323,14 @@ check_opt(
 
 	/* check for conflicts with the option */
 	for (i = 0; i < MAX_CONFLICTS; i++) {
-		int conflict_opt = sp->conflicts[i];
+		struct subopt_conflict conflict_opt = sp->conflicts[i];
 
-		if (conflict_opt == LAST_CONFLICT)
+		if (conflict_opt.opt == LAST_CONFLICT)
 			break;
-		if (opts->subopt_params[conflict_opt].seen ||
-		    opts->subopt_params[conflict_opt].str_seen)
+		if (opts->subopt_params[conflict_opt.subopt].seen ||
+		    opts->subopt_params[conflict_opt.subopt].str_seen)
 			conflict(opts->name, (char **)opts->subopts,
-				 conflict_opt, index);
+				 conflict_opt.subopt, index);
 	}
 }
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
