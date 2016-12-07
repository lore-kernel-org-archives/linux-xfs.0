Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752923AbcLGNfG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:35:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 740457AE9D
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:57 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 16/22] mkfs: Change all value fields in opt structures into unions
Date: Wed,  7 Dec 2016 14:27:23 +0100
Message-Id: <1481117249-21273-17-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Trying to cover all possible values in a single data type is impossible,
so convert the field from long long type to union. This requires
also some small changes in supporting code, otherwise it would not compile.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 812 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 504 insertions(+), 308 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7ffe8ff..afc63d1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -121,6 +121,231 @@ unsigned int		sectorsize;
 #define M_RMAPBT	3
 #define M_REFLINK	4
 
+enum e_type {
+	TYPE_UNDEF,
+	LONGLONG,
+	BOOL,
+	UINT64,
+	INT,
+	UINT,
+	STRING
+};
+union u_value {
+	long long 	ll;
+	bool		b;
+	__uint64_t	uint64;
+	int		i;
+	unsigned int	u;
+	char		*s;
+};
+static bool
+cmp_uvalues_gt(enum e_type a_type, union u_value a, enum e_type b_type, union u_value b) {
+	if (a_type == STRING || b_type == STRING) {
+		if (a_type == b_type)
+			return strcmp(a.s, b.s);
+		return false;
+	}	switch(a_type){
+	case LONGLONG:
+		switch(b_type){
+		case LONGLONG:
+			return a.ll > b.ll;
+		case BOOL:
+			return a.ll > b.b;
+		case UINT64:
+			return a.ll > b.uint64;
+		case INT:
+			return a.ll > b.i;
+		case UINT:
+			return a.ll > b.u;
+		default:
+			return false;
+		};
+		break;
+	case BOOL:
+		switch(b_type){
+		case LONGLONG:
+			return a.b > b.ll;
+		case BOOL:
+			return a.b > b.b;
+		case UINT64:
+			return a.b > b.uint64;
+		case INT:
+			return a.b > b.i;
+		case UINT:
+			return a.b > b.u;
+		default:
+			return false;
+		};
+		break;
+	case UINT64:
+		switch(b_type){
+		case LONGLONG:
+			return a.uint64 > b.ll;
+		case BOOL:
+			return a.uint64 > b.b;
+		case UINT64:
+			return a.uint64 > b.uint64;
+		case INT:
+			return a.uint64 > b.i;
+		case UINT:
+			return a.uint64 > b.u;
+		default:
+			return false;
+		};
+		break;
+	case INT:
+		switch(b_type){
+		case LONGLONG:
+			return a.i > b.ll;
+		case BOOL:
+			return a.i > b.b;
+		case UINT64:
+			return a.i > b.uint64;
+		case INT:
+			return a.i > b.i;
+		case UINT:
+			return a.i > b.u;
+		default:
+			return false;
+		};
+		break;
+	case UINT:
+		switch(b_type){
+		case LONGLONG:
+			return a.u > b.ll;
+		case BOOL:
+			return a.u > b.b;
+		case UINT64:
+			return a.u > b.uint64;
+		case INT:
+			return a.u > b.i;
+		case UINT:
+			return a.u > b.u;
+		default:
+			return false;
+		};
+		break;
+	default:
+		return false;
+	};
+
+	return false;
+}
+static bool
+cmp_uvalue_gt_num(enum e_type a_type, union u_value a, long long b) {
+	union u_value u;
+	u.ll = b;
+	return cmp_uvalues_gt(a_type, a, LONGLONG, u);
+}
+static bool
+cmp_uvalue_lt_num(enum e_type a_type, union u_value a, long long b) {
+	union u_value u;
+	u.ll = b;
+	return cmp_uvalues_gt(LONGLONG, u, a_type, a);
+}
+
+static bool
+test_uvalues(enum e_type a_type, union u_value a, enum e_type b_type, union u_value b) {
+	if (a_type == STRING || b_type == STRING) {
+		if (a_type == b_type)
+			return strcmp(a.s, b.s) == 0;
+		return false;
+	}
+	switch(a_type){
+	case LONGLONG:
+		switch(b_type){
+		case LONGLONG:
+			return a.ll == b.ll;
+		case BOOL:
+			return a.ll == b.b;
+		case UINT64:
+			return a.ll == b.uint64;
+		case INT:
+			return a.ll == b.i;
+		case UINT:
+			return a.ll == b.u;
+		default:
+			return false;
+		};
+		break;
+	case BOOL:
+		switch(b_type){
+		case LONGLONG:
+			return a.b == b.ll;
+		case BOOL:
+			return a.b == b.b;
+		case UINT64:
+			return a.b == b.uint64;
+		case INT:
+			return a.b == b.i;
+		case UINT:
+			return a.b == b.u;
+		default:
+			return false;
+		};
+		break;
+	case UINT64:
+		switch(b_type){
+		case LONGLONG:
+			return a.uint64 == b.ll;
+		case BOOL:
+			return a.uint64 == b.b;
+		case UINT64:
+			return a.uint64 == b.uint64;
+		case INT:
+			return a.uint64 == b.i;
+		case UINT:
+			return a.uint64 == b.u;
+		default:
+			return false;
+		};
+		break;
+	case INT:
+		switch(b_type){
+		case LONGLONG:
+			return a.i == b.ll;
+		case BOOL:
+			return a.i == b.b;
+		case UINT64:
+			return a.i == b.uint64;
+		case INT:
+			return a.i == b.i;
+		case UINT:
+			return a.i == b.u;
+		default:
+			return false;
+		};
+		break;
+	case UINT:
+		switch(b_type){
+		case LONGLONG:
+			return a.u == b.ll;
+		case BOOL:
+			return a.u == b.b;
+		case UINT64:
+			return a.u == b.uint64;
+		case INT:
+			return a.u == b.i;
+		case UINT:
+			return a.u == b.u;
+		default:
+			return false;
+		};
+		break;
+	default:
+		return false;
+	};
+
+	return false;
+}
+
+static bool
+test_uvalue_num(enum e_type a_type, union u_value a, long long b) {
+	union u_value u;
+	u.ll = b;
+	return test_uvalues(a_type, a, LONGLONG, u);
+}
+
 /*
  * Table for parsing mkfs parameters.
  *
@@ -193,11 +418,15 @@ unsigned int		sectorsize;
  *     If the subopt accepts some values (-d file=[1|0]), then this
  *     sets what is used with simple specifying the subopt (-d file).
  *
- *   value INTERNAL
- *     Do not set this on initialization. Use flagval for what you want
- *     to do. This is filled with user input and anything you write here now
- *     is overwritten. (If the user input is a string and not a number, this
- *     value is set to a positive non-zero number.)
+ *   value MANDATORY
+ *     A value that is used for given field as a default if user doesn't specify
+ *     any change. This is filled with user input and anything you write here
+ *     now is overwritten if the user specifies given option.
+ *
+ *   type MANDATORY
+ *     An enum of what type the values are. Affects every u_value field within
+ *     the suboption except conflict's .invalid_value - this one uses the
+ *     "remote" type.
  *
  *   needs_val OPTIONAL
  *     Set to true if, when user specifies the option, she has to specify
@@ -219,14 +448,15 @@ struct opt_params {
 			int		subopt;
 			bool		test_values;
 			bool		test_default_value;
-			long long	invalid_value;
-			long long	at_value;
+			union u_value	invalid_value;
+			union u_value	at_value;
 			const char	*message;
 		}		conflicts [MAX_CONFLICTS];
-		long long	minval;
-		long long	maxval;
-		long long	flagval;
-		long long	value;
+		union u_value	minval;
+		union u_value	maxval;
+		union u_value	flagval;
+		union u_value value;
+		enum e_type 	type;
 		bool		needs_val;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
@@ -244,9 +474,10 @@ struct opt_params {
 					  .subopt = B_SIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_BLOCKSIZE_LOG,
-			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+			  .minval.i = XFS_MIN_BLOCKSIZE_LOG,
+			  .maxval.i = XFS_MAX_BLOCKSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = B_SIZE,
 			  .convert = true,
@@ -255,9 +486,10 @@ struct opt_params {
 					  .subopt = B_LOG,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_BLOCKSIZE,
-			  .maxval = XFS_MAX_BLOCKSIZE,
+			  .minval.u = XFS_MIN_BLOCKSIZE,
+			  .maxval.u = XFS_MAX_BLOCKSIZE,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 		},
 	},
@@ -288,26 +520,30 @@ struct opt_params {
 					  .subopt = D_AGSIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 1,
-			  .maxval = XFS_MAX_AGNUMBER,
+			  .minval.uint64 = 1,
+			  .maxval.uint64 = XFS_MAX_AGNUMBER,
 			  .needs_val = true,
+			  .type = UINT64,
 			},
 			{ .index = D_FILE,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 			{ .index = D_NAME,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = D_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = XFS_AG_MIN_BYTES,
-			  .maxval = LLONG_MAX,
+			  .minval.uint64 = XFS_AG_MIN_BYTES,
+			  .maxval.uint64 = LLONG_MAX,
 			  .needs_val = true,
+			  .type = UINT64,
 			},
 			{ .index = D_SUNIT,
 			  .conflicts = { {.opt = OPT_D,
@@ -320,9 +556,10 @@ struct opt_params {
 					  .subopt = D_SW,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.i = 0,
+			  .maxval.i = UINT_MAX,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = D_SWIDTH,
 			  .conflicts = { {.opt = OPT_D,
@@ -335,9 +572,10 @@ struct opt_params {
 					  .subopt = D_SW,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.i = 0,
+			  .maxval.i = UINT_MAX,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = D_AGSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -345,9 +583,10 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = XFS_AG_MIN_BYTES,
-			  .maxval = XFS_AG_MAX_BYTES,
+			  .minval.uint64 = XFS_AG_MIN_BYTES,
+			  .maxval.uint64 = XFS_AG_MAX_BYTES,
 			  .needs_val = true,
+			  .type = UINT64,
 			},
 			{ .index = D_SU,
 			  .conflicts = { {.opt = OPT_D,
@@ -361,9 +600,10 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.i = 0,
+			  .maxval.i = UINT_MAX,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = D_SW,
 			  .conflicts = { {.opt = OPT_D,
@@ -376,18 +616,20 @@ struct opt_params {
 					  .subopt = D_SWIDTH,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.i = 0,
+			  .maxval.i = UINT_MAX,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = D_SECTLOG,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_SECTSIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_SECTORSIZE_LOG,
-			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .minval.i = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval.i = XFS_MAX_SECTORSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = D_SECTSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -396,9 +638,10 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
-			  .minval = XFS_MIN_SECTORSIZE,
-			  .maxval = XFS_MAX_SECTORSIZE,
+			  .minval.u = XFS_MIN_SECTORSIZE,
+			  .maxval.u = XFS_MAX_SECTORSIZE,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 			{ .index = D_NOALIGN,
 			  .conflicts = { {.opt = OPT_D,
@@ -414,27 +657,31 @@ struct opt_params {
 					  .subopt = D_SWIDTH,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 			{ .index = D_RTINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 1,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.u = 1,
+			  .maxval.u = 1,
+			  .flagval.u = 1,
+			  .type = UINT,
 			},
 			{ .index = D_PROJINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.u = 0,
+			  .maxval.u = UINT_MAX,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 			{ .index = D_EXTSZINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.u = 0,
+			  .maxval.u = UINT_MAX,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 		},
 	},
@@ -458,14 +705,15 @@ struct opt_params {
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = 1,
+					  .at_value.b = 0,
 					  .message = \
 		"Inodes always aligned for CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 			{ .index = I_LOG,
 			  .conflicts = { {.opt = OPT_I,
@@ -475,15 +723,17 @@ struct opt_params {
 					  .subopt = I_SIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_DINODE_MIN_LOG,
-			  .maxval = XFS_DINODE_MAX_LOG,
+			  .minval.i = XFS_DINODE_MIN_LOG,
+			  .maxval.i = XFS_DINODE_MAX_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = I_MAXPCT,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 100,
+			  .minval.i = 0,
+			  .maxval.i = 100,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = I_PERBLOCK,
 			  .conflicts = { {.opt = OPT_I,
@@ -494,9 +744,10 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
-			  .minval = XFS_MIN_INODE_PERBLOCK,
-			  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
+			  .minval.i = XFS_MIN_INODE_PERBLOCK,
+			  .maxval.i = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = I_SIZE,
 			  .conflicts = { {.opt = OPT_I,
@@ -507,52 +758,56 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
-			  .minval = XFS_DINODE_MIN_SIZE,
-			  .maxval = XFS_DINODE_MAX_SIZE,
+			  .minval.i = XFS_DINODE_MIN_SIZE,
+			  .maxval.i = XFS_DINODE_MAX_SIZE,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = I_ATTR,
 			  .conflicts = { {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 1,
+					  .invalid_value.b = true,
+					  .at_value.i = 1,
 					  .message = \
 		"V2 attribute format always enabled on CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 2,
+			  .minval.i = 0,
+			  .maxval.i = 2,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = I_PROJID32BIT,
 			  .conflicts = { {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = true,
+					  .at_value.b = 0,
 					  .message = \
 		"32 bit Project IDs always enabled on CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
 
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 			{ .index = I_SPINODES,
 			  .conflicts = { {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.i = 1,
 					  .message = \
 		"Sparse inodes not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 		},
 	},
@@ -576,13 +831,15 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = L_AGNUM,
+			  /* FIXME custom type xfs_agnumber_t? */
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_DEV,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = UINT_MAX,
+			  .minval.u = 0,
+			  .maxval.u = UINT_MAX,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 			{ .index = L_INTERNAL,
 			  .conflicts = { {.opt = OPT_L,
@@ -592,39 +849,43 @@ struct opt_params {
 					  .subopt = L_DEV,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 			{ .index = L_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
-			  .maxval = XFS_MAX_LOG_BYTES,
+			  .minval.i = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
+			  .maxval.i = XFS_MAX_LOG_BYTES,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_VERSION,
 			  .conflicts = {{.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 1,
+					  .invalid_value.b = true,
+					  .at_value.i = 1,
 					  .message =
 				"V2 logs are required for CRC enabled filesystems."},
 					 {LAST_CONFLICT} },
-			  .minval = 1,
-			  .maxval = 2,
+			  .minval.i = 1,
+			  .maxval.i = 2,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_SUNIT,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SU,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 1,
-			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
+			  .minval.i = 1,
+			  .maxval.i = BTOBB(XLOG_MAX_RECORD_BSIZE),
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_SU,
 			  .conflicts = { {.opt = OPT_L,
@@ -632,9 +893,10 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = BBTOB(1),
-			  .maxval = XLOG_MAX_RECORD_BSIZE,
+			  .minval.i = BBTOB(1),
+			  .maxval.i = XLOG_MAX_RECORD_BSIZE,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_DEV,
 			  .conflicts = { {.opt = OPT_L,
@@ -645,15 +907,17 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = L_SECTLOG,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SECTSIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_SECTORSIZE_LOG,
-			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .minval.i = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval.i = XFS_MAX_SECTORSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_SECTSIZE,
 			  .conflicts = { {.opt = OPT_L,
@@ -662,18 +926,20 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
-			  .minval = XFS_MIN_SECTORSIZE,
-			  .maxval = XFS_MAX_SECTORSIZE,
+			  .minval.i = XFS_MIN_SECTORSIZE,
+			  .maxval.i = XFS_MAX_SECTORSIZE,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = L_FILE,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 			{ .index = L_NAME,
 			  .conflicts = { {.opt = OPT_L,
@@ -684,20 +950,22 @@ struct opt_params {
 					 },
 					 {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = L_LAZYSBCNTR,
 			  .conflicts = { {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = true,
+					  .at_value.b = false,
 					  .message =
 		"Lazy superblock counted always enabled for CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 		},
 	},
@@ -717,9 +985,10 @@ struct opt_params {
 					  .subopt = N_SIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_REC_DIRSIZE,
-			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+			  .minval.i = XFS_MIN_REC_DIRSIZE,
+			  .maxval.i = XFS_MAX_BLOCKSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = N_SIZE,
 			  .conflicts = { {.opt = OPT_N,
@@ -728,29 +997,32 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
-			  .minval = 1 << XFS_MIN_REC_DIRSIZE,
-			  .maxval = XFS_MAX_BLOCKSIZE,
+			  .minval.i = 1 << XFS_MIN_REC_DIRSIZE,
+			  .maxval.i = XFS_MAX_BLOCKSIZE,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = N_VERSION,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval = 2,
-			  .maxval = 2,
+			  .minval.i = 2,
+			  .maxval.i = 2,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = N_FTYPE,
 			  .conflicts = {  {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = true,
+					  .at_value.b = false,
 					  .message =
 		"Cannot disable ftype with crcs enabled."},
 					  {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 		},
 	},
@@ -770,33 +1042,37 @@ struct opt_params {
 			{ .index = R_EXTSIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = XFS_MIN_RTEXTSIZE,
-			  .maxval = XFS_MAX_RTEXTSIZE,
+			  .minval.uint64 = XFS_MIN_RTEXTSIZE,
+			  .maxval.uint64 = XFS_MAX_RTEXTSIZE,
 			  .needs_val = true,
+			  .type = UINT64,
 			},
 			{ .index = R_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
-			  .minval = 0,
-			  .maxval = LLONG_MAX,
+			  .minval.uint64 = 0,
+			  .maxval.uint64 = LLONG_MAX,
 			  .needs_val = true,
+			  .type = UINT64,
 			},
 			{ .index = R_DEV,
 			  .conflicts = { {.opt = OPT_M,
 				  	  .subopt = M_RMAPBT,
 					  .test_values = false,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 0,
+					  .invalid_value.b = 0,
+					  .at_value.b = 0,
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = R_FILE,
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 			{ .index = R_NAME,
@@ -804,17 +1080,19 @@ struct opt_params {
 				  	  .subopt = M_RMAPBT,
 					  .test_values = false,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 0,
+					  .invalid_value.b = 0,
+					  .at_value.b = 0,
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = R_NOALIGN,
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 		},
@@ -838,9 +1116,10 @@ struct opt_params {
 					  .subopt = S_SECTSIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_SECTORSIZE_LOG,
-			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .minval.i = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval.i = XFS_MAX_SECTORSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = S_SECTLOG,
 			  .conflicts = { {.opt = OPT_S,
@@ -850,9 +1129,10 @@ struct opt_params {
 					  .subopt = S_SECTSIZE,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval = XFS_MIN_SECTORSIZE_LOG,
-			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .minval.i = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval.i = XFS_MAX_SECTORSIZE_LOG,
 			  .needs_val = true,
+			  .type = INT,
 			},
 			{ .index = S_SIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -864,9 +1144,10 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
-			  .minval = XFS_MIN_SECTORSIZE,
-			  .maxval = XFS_MAX_SECTORSIZE,
+			  .minval.u = XFS_MIN_SECTORSIZE,
+			  .maxval.u = XFS_MAX_SECTORSIZE,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 			{ .index = S_SECTSIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -878,9 +1159,10 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
-			  .minval = XFS_MIN_SECTORSIZE,
-			  .maxval = XFS_MAX_SECTORSIZE,
+			  .minval.u = XFS_MIN_SECTORSIZE,
+			  .maxval.u = XFS_MAX_SECTORSIZE,
 			  .needs_val = true,
+			  .type = UINT,
 			},
 		},
 	},
@@ -901,148 +1183,153 @@ struct opt_params {
 					  .subopt = L_VERSION,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 1,
+					  .invalid_value.i = 1,
+					  .at_value.b = 1,
 					  .message =
 		"V2 logs are required for CRC enabled filesystems."},
 					 {.opt = OPT_I,
 					  .subopt = I_ALIGN,
 					  .test_values = false,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.b = 1,
 					  .message =
 		"Inodes always aligned for CRC enabled filesytems."},
 					 {.opt = OPT_I,
 					  .subopt = I_PROJID32BIT,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.b = 1,
 					  .message =
 		"32 bit Project IDs always enabled on CRC enabled filesytems."},
 					 {.opt = OPT_I,
 					  .subopt = I_ATTR,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 1,
+					  .invalid_value.i = 1,
+					  .at_value.b = 1,
 					  .message =
 		"V2 attribute format always enabled on CRC enabled filesytems."},
 					 {.opt = OPT_L,
 					  .subopt = L_LAZYSBCNTR,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.b = 1,
 					  .message =
 		"Lazy superblock counted always enabled for CRC enabled filesytems."},
 					 {.opt = OPT_M,
 					  .subopt = M_FINOBT,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.i = 1,
+					  .at_value.b = 0,
 					  .message =
 		"Finobt not supported without CRC support."},
 					 {.opt = OPT_M,
 				  	  .subopt = M_RMAPBT,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = 1,
+					  .at_value.b = 0,
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {.opt = OPT_M,
 				  	  .subopt = M_REFLINK,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.b = 1,
+					  .at_value.b = 0,
 					  .message =
 		"reflink not supported without CRC support."},
 					 {.opt = OPT_I,
 					  .subopt = I_SPINODES,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 1,
-					  .at_value = 0,
+					  .invalid_value.i = 1,
+					  .at_value.b = 0,
 					  .message =
 		"Sparse inodes not supported without CRC support."},
 					 {.opt = OPT_N,
 					  .subopt = N_FTYPE,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.b = 1,
 					  .message =
 		"Cannot disable ftype with crcs enabled."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 			{ .index = M_FINOBT,
 			  .conflicts = { {.opt = OPT_M,
 					  .subopt = M_CRC,
 					  .test_values = true,
 					  .test_default_value = true,
-					  .invalid_value = 0,
-					  .at_value = 1,
+					  .invalid_value.b = 0,
+					  .at_value.i = 1,
 					  .message =
 		"Finobt not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
-			  .flagval = 1,
+			  .minval.i = 0,
+			  .maxval.i = 1,
+			  .flagval.i = 1,
+			  .type = INT,
 			},
 			{ .index = M_UUID,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .needs_val = true,
+			  .type = STRING,
 			},
 			{ .index = M_RMAPBT,
 			.conflicts = { {.opt = OPT_M,
 					.subopt = M_CRC,
 					.test_values = true,
 					.test_default_value = true,
-					.invalid_value = 0,
-					.at_value = 1,
+					.invalid_value.b = 0,
+					.at_value.b = 1,
 					.message =
 		"rmapbt not supported without CRC support."},
 					{.opt = OPT_R,
 					 .subopt = R_NAME,
 					 .test_values = false,
 					 .test_default_value = true,
-					 .invalid_value = 0,
-					 .at_value = 0,
+					 .invalid_value.b = 0,
+					 .at_value.b = 0,
 					 .message =
 		"rmapbt not supported with realtime devices."},
 					{.opt = OPT_R,
 					 .subopt = R_DEV,
 					 .test_values = false,
 					 .test_default_value = true,
-					 .invalid_value = 0,
-					 .at_value = 0,
+					 .invalid_value.b = 0,
+					 .at_value.b = 0,
 					 .message =
 		"rmapbt not supported with realtime devices."},
 				       {LAST_CONFLICT} },
-			.minval = 0,
-			.maxval = 1,
-			.flagval = 0,
+			.minval.b = false,
+			.maxval.b = true,
+			.flagval.b = false,
+			.type = BOOL,
 			},
 			{ .index = M_REFLINK,
 			.conflicts = { {.opt = OPT_M,
 					.subopt = M_CRC,
 					.test_values = true,
 					.test_default_value = true,
-					.invalid_value = 0,
-					.at_value = 1,
+					.invalid_value.b = 0,
+					.at_value.b = 1,
 					.message =
 		"reflink not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .minval = 0,
-			  .maxval = 1,
+			  .minval.b = 0,
+			  .maxval.b = 1,
 			  .needs_val = true,
+			 .type = BOOL,
 			},
 		},
 	},
@@ -1653,8 +1940,7 @@ check_subopt_conflicts(
 static void
 check_subopt_value(
 	struct opt_params	*opt,
-	int			index,
-	long long 		value)
+	int			index)
 {
 	struct subopt_param	*sp = &opt->subopt_params[index];
 	int			i;
@@ -1669,9 +1955,19 @@ check_subopt_value(
 			break;
 		if ( (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
 		      conflict_opt.test_default_value) &&
-		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
-				== conflict_opt.invalid_value &&
-		    value == conflict_opt.at_value) {
+		      test_uvalues(
+			opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].type,
+			opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value,
+			opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].type,
+			conflict_opt.invalid_value
+		      ) &&
+		      test_uvalues(
+			sp->type,
+			sp->value,
+			sp->type,
+			conflict_opt.at_value
+		      )
+		    ) {
 			conflict_struct(opt, sp, &conflict_opt);
 		}
 	}
@@ -1695,7 +1991,7 @@ check_opt(
 		if (!sp->seen)
 			continue;
 		check_subopt_conflicts(opt, index, false);
-		check_subopt_value(opt, index, sp->value);
+		check_subopt_value(opt, index);
 	}
 }
 static void
@@ -1721,18 +2017,42 @@ getnum(
 		if (sp->needs_val)
 			reqval(opts->name, (char **)opts->subopts, index);
 		sp->seen = true;
-		return sp->flagval;
+		switch(sp->type){
+		case LONGLONG:
+			return sp->flagval.ll;
+		case BOOL:
+			return sp->flagval.b;
+		case UINT64:
+			return sp->flagval.uint64;
+		case INT:
+			return sp->flagval.i;
+		case UINT:
+			return sp->flagval.u;
+		default:
+			fprintf(stderr,
+				_("Option -%c %s called getnum, but is not numeric."
+				  " This is a bug.\n"), opts->name, opts->subopts[index]);
+			exit(1);
+		}
 	}
 
 	sp->seen = true;
 
-	if (sp->minval == 0 && sp->maxval == 0) {
+	if (test_uvalue_num(sp->type, sp->minval, 0) &&
+		test_uvalue_num(sp->type, sp->maxval, 0)) {
 		fprintf(stderr,
 			_("Option -%c %s has undefined minval/maxval."
 			  "Can't verify value range. This is a bug.\n"),
 			opts->name, opts->subopts[index]);
 		exit(1);
 	}
+	if (sp->type == TYPE_UNDEF) {
+		fprintf(stderr,
+			_("Option -%c %s is of undefined type."
+			  "Can't parse value. This is a bug.\n"),
+			opts->name, opts->subopts[index]);
+		exit(1);
+	}
 
 	/*
 	 * Some values are pure numbers, others can have suffixes that define
@@ -1753,9 +2073,9 @@ getnum(
 	}
 
 	/* Validity check the result. */
-	if (c < sp->minval)
+	if (cmp_uvalue_gt_num(sp->type, sp->minval, c))
 		illegal_option(str, opts, index, _("value is too small"));
-	else if (c > sp->maxval)
+	else if (cmp_uvalue_lt_num(sp->type, sp->maxval, c))
 		illegal_option(str, opts, index, _("value is too large"));
 	if (sp->is_power_2 && !ispow2(c))
 		illegal_option(str, opts, index, _("value must be a power of 2"));
@@ -1940,20 +2260,12 @@ main(
 								B_LOG);
 					blocksize = 1 << blocklog;
 					blflag = 1;
-					opts[OPT_B].subopt_params[B_LOG].value =
-							blocklog;
-					opts[OPT_B].subopt_params[B_SIZE].value =
-							blocksize;
 					break;
 				case B_SIZE:
 					blocksize = getnum(value, &opts[OPT_B],
 							   B_SIZE);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
-					opts[OPT_B].subopt_params[B_LOG].value =
-							blocklog;
-					opts[OPT_B].subopt_params[B_SIZE].value =
-							blocksize;
 					break;
 				default:
 					unknown('b', value);
@@ -1971,70 +2283,47 @@ main(
 					agcount = getnum(value, &opts[OPT_D],
 							 D_AGCOUNT);
 					daflag = 1;
-					opts[OPT_D].subopt_params[D_AGCOUNT].value =
-							agcount;
 					break;
 				case D_AGSIZE:
 					agsize = getnum(value, &opts[OPT_D],
 								D_AGSIZE);
 					dasize = 1;
-					opts[OPT_D].subopt_params[D_AGSIZE].value =
-							agsize;
 					break;
 				case D_FILE:
 					xi.disfile = getnum(value, &opts[OPT_D],
 							    D_FILE);
-					opts[OPT_D].subopt_params[D_FILE].value =
-							xi.disfile;
 					break;
 				case D_NAME:
 					xi.dname = getstr(value, &opts[OPT_D],
 								D_NAME);
-					opts[OPT_D].subopt_params[D_NAME].value = 1;
 					break;
 				case D_SIZE:
 					dbytes = getnum(value, &opts[OPT_D],
 								D_SIZE);
-					opts[OPT_D].subopt_params[D_SIZE].value =
-							dbytes;
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &opts[OPT_D],
 								D_SUNIT);
-					opts[OPT_D].subopt_params[D_SUNIT].value =
-							dsunit;
 					break;
 				case D_SWIDTH:
 					dswidth = getnum(value, &opts[OPT_D],
 							 D_SWIDTH);
-					opts[OPT_D].subopt_params[D_SWIDTH].value =
-							dswidth;
 					break;
 				case D_SU:
 					dsu = getnum(value, &opts[OPT_D], D_SU);
-					opts[OPT_D].subopt_params[D_SU].value =
-							dsu;
 					break;
 				case D_SW:
 					dsw = getnum(value, &opts[OPT_D], D_SW);
-					opts[OPT_D].subopt_params[D_SW].value =
-							dsw;
 					break;
 				case D_NOALIGN:
 					nodsflag = getnum(value, &opts[OPT_D],
 								D_NOALIGN);
-					opts[OPT_D].subopt_params[D_NOALIGN].value =
-							nodsflag;
 					break;
 				case D_SECTLOG:
 					sectorlog = getnum(value, &opts[OPT_D],
 							   D_SECTLOG);
 					sectorsize = 1 << sectorlog;
 					slflag = 1;
-					opts[OPT_D].subopt_params[D_SECTSIZE].value =
-							sectorsize;
-					opts[OPT_D].subopt_params[D_SECTLOG].value =
-							sectorlog;
 					break;
 				case D_SECTSIZE:
 					sectorsize = getnum(value, &opts[OPT_D],
@@ -2042,10 +2331,6 @@ main(
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
-					opts[OPT_D].subopt_params[D_SECTSIZE].value =
-							sectorsize;
-					opts[OPT_D].subopt_params[D_SECTLOG].value =
-							sectorlog;
 					break;
 				case D_RTINHERIT:
 					c = getnum(value, &opts[OPT_D],
@@ -2053,24 +2338,18 @@ main(
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
-					opts[OPT_D].subopt_params[D_RTINHERIT].value =
-							c;
 					break;
 				case D_PROJINHERIT:
 					fsx.fsx_projid = getnum(value, &opts[OPT_D],
 								D_PROJINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
-					opts[OPT_D].subopt_params[D_PROJINHERIT].value =
-							fsx.fsx_projid;
 					break;
 				case D_EXTSZINHERIT:
 					fsx.fsx_extsize = getnum(value, &opts[OPT_D],
 								 D_EXTSZINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
-					opts[OPT_D].subopt_params[D_EXTSZINHERIT].value =
-							fsx.fsx_extsize;
 					break;
 				default:
 					unknown('d', value);
@@ -2088,64 +2367,44 @@ main(
 					sb_feat.inode_align = getnum(value,
 								&opts[OPT_I],
 								I_ALIGN);
-					opts[OPT_I].subopt_params[I_ALIGN].value =
-							sb_feat.inode_align;
 					break;
 				case I_LOG:
 					inodelog = getnum(value, &opts[OPT_I],
 								I_LOG);
 					isize = 1 << inodelog;
 					ilflag = 1;
-					opts[OPT_I].subopt_params[I_SIZE].value =
-							isize;
-					opts[OPT_I].subopt_params[I_LOG].value =
-							inodelog;
 					break;
 				case I_MAXPCT:
 					imaxpct = getnum(value, &opts[OPT_I],
 							 I_MAXPCT);
 					imflag = 1;
-					opts[OPT_I].subopt_params[I_MAXPCT].value =
-							imaxpct;
 					break;
 				case I_PERBLOCK:
 					inopblock = getnum(value, &opts[OPT_I],
 							   I_PERBLOCK);
 					ipflag = 1;
-					opts[OPT_I].subopt_params[I_PERBLOCK].value =
-							inopblock;
 					break;
 				case I_SIZE:
 					isize = getnum(value, &opts[OPT_I],
 								I_SIZE);
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
-					opts[OPT_I].subopt_params[I_SIZE].value =
-							isize;
-					opts[OPT_I].subopt_params[I_LOG].value =
-							inodelog;
 					break;
 				case I_ATTR:
 					sb_feat.attr_version =
 
 						getnum(value, &opts[OPT_I],
 								I_ATTR);
-					opts[OPT_I].subopt_params[I_ATTR].value =
-							sb_feat.attr_version;
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
 						!getnum(value, &opts[OPT_I],
 							I_PROJID32BIT);
-					opts[OPT_I].subopt_params[I_PROJID32BIT].value =
-							sb_feat.projid16bit;
 					break;
 				case I_SPINODES:
 					sb_feat.spinodes = getnum(value,
 								&opts[OPT_I],
 								I_SPINODES);
-					opts[OPT_I].subopt_params[I_SPINODES].value =
-							sb_feat.spinodes;
 					break;
 				default:
 					unknown('i', value);
@@ -2163,34 +2422,24 @@ main(
 					logagno = getnum(value, &opts[OPT_L],
 								L_AGNUM);
 					laflag = 1;
-					opts[OPT_L].subopt_params[L_AGNUM].value =
-							logagno;
 					break;
 				case L_FILE:
 					xi.lisfile = getnum(value, &opts[OPT_L],
 							    L_FILE);
-					opts[OPT_L].subopt_params[L_FILE].value =
-							xi.lisfile;
 					break;
 				case L_INTERNAL:
 					loginternal = getnum(value, &opts[OPT_L],
 							     L_INTERNAL);
 					liflag = 1;
-					opts[OPT_L].subopt_params[L_INTERNAL].value =
-							loginternal;
 					break;
 				case L_SU:
 					lsu = getnum(value, &opts[OPT_L], L_SU);
 					lsuflag = 1;
-					opts[OPT_L].subopt_params[L_SU].value =
-							lsu;
 					break;
 				case L_SUNIT:
 					lsunit = getnum(value, &opts[OPT_L],
 								L_SUNIT);
 					lsunitflag = 1;
-					opts[OPT_L].subopt_params[L_SUNIT].value =
-							lsunit;
 					break;
 				case L_NAME:
 				case L_DEV:
@@ -2199,32 +2448,22 @@ main(
 					xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
-					opts[OPT_L].subopt_params[L_NAME].value = 1;
-					opts[OPT_L].subopt_params[L_DEV].value = 1;
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
 						getnum(value, &opts[OPT_L],
 								L_VERSION);
 					lvflag = 1;
-					opts[OPT_L].subopt_params[L_VERSION].value =
-							sb_feat.log_version;
 					break;
 				case L_SIZE:
 					logbytes = getnum(value, &opts[OPT_L],
 								L_SIZE);
-					opts[OPT_L].subopt_params[L_SIZE].value =
-							logbytes;
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &opts[OPT_L],
 							    L_SECTLOG);
 					lsectorsize = 1 << lsectorlog;
 					lslflag = 1;
-					opts[OPT_L].subopt_params[L_SECTSIZE].value =
-							lsectorsize;
-					opts[OPT_L].subopt_params[L_SECTLOG].value =
-							lsectorlog;
 					break;
 				case L_SECTSIZE:
 					lsectorsize = getnum(value, &opts[OPT_L],
@@ -2232,17 +2471,11 @@ main(
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
-					opts[OPT_L].subopt_params[L_SECTSIZE].value =
-							lsectorsize;
-					opts[OPT_L].subopt_params[L_SECTLOG].value =
-							lsectorlog;
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
 							getnum(value, &opts[OPT_L],
 							       L_LAZYSBCNTR);
-					opts[OPT_L].subopt_params[L_LAZYSBCNTR].value =
-							sb_feat.lazy_sb_counters;
 					break;
 				default:
 					unknown('l', value);
@@ -2267,27 +2500,20 @@ main(
 								M_CRC);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
-					opts[OPT_M].subopt_params[M_CRC].value =
-							sb_feat.crcs_enabled;
 					break;
 				case M_FINOBT:
 					sb_feat.finobt = getnum(
 						value, &opts[OPT_M], M_FINOBT);
-					opts[OPT_M].subopt_params[M_FINOBT].value =
-							sb_feat.finobt;
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
 						reqval('m', subopts, M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
-					opts[OPT_M].subopt_params[M_UUID].value = 1;
 					break;
 				case M_RMAPBT:
 					sb_feat.rmapbt = getnum(
 						value, &opts[OPT_M], M_RMAPBT);
-					opts[OPT_M].subopt_params[M_RMAPBT].value = 
-						sb_feat.rmapbt;
 					break;
 				case M_REFLINK:
 					sb_feat.reflink = getnum(
@@ -2310,10 +2536,6 @@ main(
 							     N_LOG);
 					dirblocksize = 1 << dirblocklog;
 					nlflag = 1;
-					opts[OPT_N].subopt_params[N_SIZE].value =
-							dirblocksize;
-					opts[OPT_N].subopt_params[N_LOG].value =
-							dirblocklog;
 					break;
 				case N_SIZE:
 					dirblocksize = getnum(value, &opts[OPT_N],
@@ -2321,10 +2543,6 @@ main(
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
-					opts[OPT_N].subopt_params[N_SIZE].value =
-							dirblocksize;
-					opts[OPT_N].subopt_params[N_LOG].value =
-							dirblocklog;
 					break;
 				case N_VERSION:
 					value = getstr(value, &opts[OPT_N],
@@ -2338,14 +2556,10 @@ main(
 							       N_VERSION);
 					}
 					nvflag = 1;
-					opts[OPT_N].subopt_params[N_VERSION].value =
-							sb_feat.dir_version;
 					break;
 				case N_FTYPE:
 					sb_feat.dirftype = getnum(value, &opts[OPT_N],
 								  N_FTYPE);
-					opts[OPT_N].subopt_params[N_FTYPE].value =
-							sb_feat.dirftype;
 					break;
 				default:
 					unknown('n', value);
@@ -2376,33 +2590,23 @@ main(
 				case R_EXTSIZE:
 					rtextbytes = getnum(value, &opts[OPT_R],
 								R_EXTSIZE);
-					opts[OPT_R].subopt_params[R_EXTSIZE].value =
-							rtextbytes;
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &opts[OPT_R],
 							    R_FILE);
-					opts[OPT_R].subopt_params[R_FILE].value =
-							xi.risfile;
 					break;
 				case R_NAME:
 				case R_DEV:
 					xi.rtname = getstr(value, &opts[OPT_R],
 							   R_NAME);
-					opts[OPT_R].subopt_params[R_NAME].value = 1;
-					opts[OPT_R].subopt_params[R_DEV].value = 1;
 					break;
 				case R_SIZE:
 					rtbytes = getnum(value, &opts[OPT_R],
 								R_SIZE);
-					opts[OPT_R].subopt_params[R_SIZE].value =
-							rtbytes;
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &opts[OPT_R],
 								R_NOALIGN);
-					opts[OPT_R].subopt_params[R_NOALIGN].value =
-							norsflag;
 					break;
 				default:
 					unknown('r', value);
@@ -2427,10 +2631,6 @@ main(
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
 					lslflag = slflag = 1;
-					opts[OPT_S].subopt_params[S_LOG].value =
-							sectorsize;
-					opts[OPT_S].subopt_params[S_SECTLOG].value =
-							sectorsize;
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
@@ -2444,10 +2644,6 @@ main(
 						libxfs_highbit32(sectorsize);
 					lsectorlog = sectorlog;
 					lssflag = ssflag = 1;
-					opts[OPT_S].subopt_params[S_SIZE].value =
-							sectorlog;
-					opts[OPT_S].subopt_params[S_SECTSIZE].value =
-							sectorlog;
 					break;
 				default:
 					unknown('s', value);
-- 
2.8.1

