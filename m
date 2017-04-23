Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163244AbdDWSzQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:16 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0CEAC059729
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:15 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 07/12] mkfs: save user input values into opts
Date: Sun, 23 Apr 2017 20:54:58 +0200
Message-Id: <20170423185503.31415-8-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Save the parsed values from users into the opts table.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 260 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 165 insertions(+), 95 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4caf93c..362c9b4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1636,16 +1636,19 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case B_LOG:
-					blocklog = getnum(value, &opts[OPT_B],
-								B_LOG);
+					blocklog = parse_conf_val(OPT_B, B_LOG,
+								  value);
 					blocksize = 1 << blocklog;
 					blflag = 1;
+					set_conf_val(OPT_B, B_SIZE, blocksize);
 					break;
 				case B_SIZE:
-					blocksize = getnum(value, &opts[OPT_B],
-							   B_SIZE);
+					blocksize = parse_conf_val(OPT_B,
+								   B_SIZE,
+								   value);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
+					set_conf_val(OPT_B, B_LOG, blocklog);
 					break;
 				default:
 					unknown('b', value);
@@ -1661,76 +1664,92 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case D_AGCOUNT:
-					agcount = getnum(value, &opts[OPT_D],
-							 D_AGCOUNT);
+					agcount = parse_conf_val(OPT_D,
+								 D_AGCOUNT,
+								 value);
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					agsize = getnum(value, &opts[OPT_D],
-								D_AGSIZE);
+					agsize = parse_conf_val(OPT_D,
+								D_AGSIZE,
+								value);
 					dasize = 1;
 					break;
 				case D_FILE:
-					xi.disfile = getnum(value,
-						&opts[OPT_D], D_FILE);
+					xi.disfile = parse_conf_val(OPT_D,
+								    D_FILE,
+								    value);
 					break;
 				case D_NAME:
 					xi.dname = getstr(value, &opts[OPT_D],
 								D_NAME);
+					set_conf_val(OPT_D, D_NAME,  1);
 					break;
 				case D_SIZE:
-					dbytes = getnum(value, &opts[OPT_D],
-								D_SIZE);
+					dbytes = parse_conf_val(OPT_D, D_SIZE,
+								value);
 					break;
 				case D_SUNIT:
-					dsunit = getnum(value, &opts[OPT_D],
-								D_SUNIT);
+					dsunit = parse_conf_val(OPT_D, D_SUNIT,
+								value);
 					break;
 				case D_SWIDTH:
-					dswidth = getnum(value, &opts[OPT_D],
-							 D_SWIDTH);
+					dswidth = parse_conf_val(OPT_D,
+								 D_SWIDTH,
+								 value);
 					break;
 				case D_SU:
-					dsu = getnum(value, &opts[OPT_D],
-								D_SU);
+					dsu = parse_conf_val(OPT_D, D_SU,
+							     value);
 					break;
 				case D_SW:
-					dsw = getnum(value, &opts[OPT_D],
-								D_SW);
+					dsw = parse_conf_val(OPT_D, D_SW,
+							     value);
 					break;
 				case D_NOALIGN:
-					nodsflag = getnum(value, &opts[OPT_D],
-								D_NOALIGN);
+					nodsflag = parse_conf_val(OPT_D,
+								  D_NOALIGN,
+								  value);
 					break;
 				case D_SECTLOG:
-					sectorlog = getnum(value, &opts[OPT_D],
-							   D_SECTLOG);
+					sectorlog = parse_conf_val(OPT_D,
+								   D_SECTLOG,
+								   value);
 					sectorsize = 1 << sectorlog;
 					slflag = 1;
+					set_conf_val(OPT_D, D_SECTSIZE,
+						     sectorsize);
 					break;
 				case D_SECTSIZE:
-					sectorsize = getnum(value,
-						&opts[OPT_D], D_SECTSIZE);
+					sectorsize = parse_conf_val(OPT_D,
+								    D_SECTSIZE,
+								    value);
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
+					set_conf_val(OPT_D, D_SECTLOG,
+						     sectorlog);
 					break;
 				case D_RTINHERIT:
-					c = getnum(value, &opts[OPT_D],
-								D_RTINHERIT);
+					c = parse_conf_val(OPT_D, D_RTINHERIT,
+							   value);
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
 					break;
 				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum(value,
-						&opts[OPT_D], D_PROJINHERIT);
+					fsx.fsx_projid =
+						parse_conf_val(OPT_D,
+							       D_PROJINHERIT,
+							       value);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
 					break;
 				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum(value,
-						&opts[OPT_D], D_EXTSZINHERIT);
+					fsx.fsx_extsize =
+						parse_conf_val(OPT_D,
+							       D_EXTSZINHERIT,
+							       value);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
@@ -1748,45 +1767,53 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case I_ALIGN:
-					sb_feat.inode_align = getnum(value,
-						&opts[OPT_I], I_ALIGN);
+					sb_feat.inode_align =
+						parse_conf_val(OPT_I, I_ALIGN,
+							       value);
 					break;
 				case I_LOG:
-					inodelog = getnum(value, &opts[OPT_I],
-								I_LOG);
+					inodelog = parse_conf_val(OPT_I, I_LOG,
+								  value);
 					isize = 1 << inodelog;
 					ilflag = 1;
+					set_conf_val(OPT_I, I_SIZE, isize);
 					break;
 				case I_MAXPCT:
-					imaxpct = getnum(value, &opts[OPT_I],
-							 I_MAXPCT);
+					imaxpct = parse_conf_val(OPT_I,
+								 I_MAXPCT,
+								 value);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
-					inopblock = getnum(value, &opts[OPT_I],
-							   I_PERBLOCK);
+					inopblock = parse_conf_val(OPT_I,
+								   I_PERBLOCK,
+								   value);
 					ipflag = 1;
 					break;
 				case I_SIZE:
-					isize = getnum(value, &opts[OPT_I],
-								I_SIZE);
+					isize = parse_conf_val(OPT_I, I_SIZE,
+							       value);
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
+					set_conf_val(OPT_I, I_LOG, inodelog);
 					break;
 				case I_ATTR:
 					sb_feat.attr_version =
-						getnum(value, &opts[OPT_I],
-								I_ATTR);
+						parse_conf_val(OPT_I, I_ATTR,
+							       value);
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
 						!getnum(value, &opts[OPT_I],
 							I_PROJID32BIT);
+					set_conf_val(OPT_I, I_PROJID32BIT,
+						     sb_feat.projid16bit);
 					break;
 				case I_SPINODES:
-					sb_feat.spinodes = getnum(value,
-								&opts[OPT_I],
-								I_SPINODES);
+					sb_feat.spinodes =
+						parse_conf_val(OPT_I,
+							       I_SPINODES,
+							       value);
 					break;
 				default:
 					unknown('i', value);
@@ -1802,27 +1829,31 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case L_AGNUM:
-					logagno = getnum(value, &opts[OPT_L],
-								L_AGNUM);
+					logagno = parse_conf_val(OPT_L,
+								 L_AGNUM,
+								 value);
 					laflag = 1;
 					break;
 				case L_FILE:
-					xi.lisfile = getnum(value,
-						&opts[OPT_L], L_FILE);
+					xi.lisfile = parse_conf_val(OPT_L,
+								    L_FILE,
+								    value);
 					break;
 				case L_INTERNAL:
-					loginternal = getnum(value,
-						&opts[OPT_L], L_INTERNAL);
+					loginternal =
+						parse_conf_val(OPT_L,
+							       L_INTERNAL,
+							       value);
 					liflag = 1;
 					break;
 				case L_SU:
-					lsu = getnum(value, &opts[OPT_L],
-								L_SU);
+					lsu = parse_conf_val(OPT_L, L_SU,
+							     value);
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					lsunit = getnum(value, &opts[OPT_L],
-								L_SUNIT);
+					lsunit = parse_conf_val(OPT_L, L_SUNIT,
+								value);
 					lsunitflag = 1;
 					break;
 				case L_NAME:
@@ -1832,34 +1863,48 @@ main(
 					xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
+					set_conf_val(OPT_L, L_NAME, 1);
+					set_conf_val(OPT_L, L_DEV, 1);
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
-						getnum(value, &opts[OPT_L],
-								L_VERSION);
+						parse_conf_val(OPT_L,
+							       L_VERSION,
+							       value);
 					lvflag = 1;
+					set_conf_val(OPT_L, L_VERSION,
+						     sb_feat.log_version);
 					break;
 				case L_SIZE:
-					logbytes = getnum(value,
-						&opts[OPT_L], L_SIZE);
+					logbytes = parse_conf_val(OPT_L,
+								  L_SIZE,
+								  value);
 					break;
 				case L_SECTLOG:
-					lsectorlog = getnum(value,
-						&opts[OPT_L], L_SECTLOG);
+					lsectorlog = parse_conf_val(OPT_L,
+								    L_SECTLOG,
+								    value);
 					lsectorsize = 1 << lsectorlog;
 					lslflag = 1;
+					set_conf_val(OPT_L, L_SECTSIZE,
+						     lsectorsize);
 					break;
 				case L_SECTSIZE:
-					lsectorsize = getnum(value,
-						&opts[OPT_L], L_SECTSIZE);
+					lsectorsize =
+						parse_conf_val(OPT_L,
+							       L_SECTSIZE,
+							       value);
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
+					set_conf_val(OPT_L, L_SECTLOG,
+						     lsectorlog);
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
-						getnum(value, &opts[OPT_L],
-							L_LAZYSBCNTR);
+						parse_conf_val(OPT_L,
+							       L_LAZYSBCNTR,
+							       value);
 					break;
 				default:
 					unknown('l', value);
@@ -1881,29 +1926,35 @@ main(
 				switch (getsubopt(&p, subopts, &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
-						getnum(value, &opts[OPT_M],
-								M_CRC);
+						parse_conf_val(OPT_M, M_CRC,
+							       value);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
-					sb_feat.finobt = getnum(
-						value, &opts[OPT_M], M_FINOBT);
+					sb_feat.finobt =
+						parse_conf_val(OPT_M, M_FINOBT,
+							       value);
+					set_conf_val(OPT_M, M_FINOBT,
+						     sb_feat.finobt);
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
 						reqval('m', subopts, M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
+					set_conf_val(OPT_M, M_UUID, 1);
 					break;
 				case M_RMAPBT:
-					sb_feat.rmapbt = getnum(
-						value, &opts[OPT_M], M_RMAPBT);
+					sb_feat.rmapbt =
+						parse_conf_val(OPT_M, M_RMAPBT,
+							       value);
 					break;
 				case M_REFLINK:
 					sb_feat.reflink =
-						getnum(value, &opts[OPT_M],
-							M_REFLINK);
+						parse_conf_val(OPT_M,
+							       M_REFLINK,
+							       value);
 					break;
 				default:
 					unknown('m', value);
@@ -1919,17 +1970,23 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case N_LOG:
-					dirblocklog = getnum(value,
-						&opts[OPT_N], N_LOG);
+					dirblocklog = parse_conf_val(OPT_N,
+								     N_LOG,
+								     value);
 					dirblocksize = 1 << dirblocklog;
 					nlflag = 1;
+					set_conf_val(OPT_N, N_SIZE,
+						     dirblocksize);
 					break;
 				case N_SIZE:
-					dirblocksize = getnum(value,
-						&opts[OPT_N], N_SIZE);
+					dirblocksize = parse_conf_val(OPT_N,
+								      N_SIZE,
+								      value);
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
+					set_conf_val(OPT_N, N_LOG,
+						     dirblocklog);
 					break;
 				case N_VERSION:
 					value = getstr(value, &opts[OPT_N],
@@ -1940,14 +1997,17 @@ main(
 					} else {
 						sb_feat.dir_version =
 							getnum(value,
-							       &opts[OPT_N],
-							       N_VERSION);
+								&opts[OPT_N],
+								N_VERSION);
 					}
 					nvflag = 1;
+					set_conf_val(OPT_N, N_VERSION,
+						     sb_feat.dir_version);
 					break;
 				case N_FTYPE:
-					sb_feat.dirftype = getnum(value,
-						&opts[OPT_N], N_FTYPE);
+					sb_feat.dirftype =
+						parse_conf_val(OPT_N, N_FTYPE,
+							       value);
 					break;
 				default:
 					unknown('n', value);
@@ -1977,25 +2037,30 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextbytes = getnum(value,
-						&opts[OPT_R], R_EXTSIZE);
+					rtextbytes = parse_conf_val(OPT_R,
+								    R_EXTSIZE,
+								    value);
 					break;
 				case R_FILE:
-					xi.risfile = getnum(value,
-						&opts[OPT_R], R_FILE);
+					xi.risfile = parse_conf_val(OPT_R,
+								    R_FILE,
+								    value);
 					break;
 				case R_NAME:
 				case R_DEV:
 					xi.rtname = getstr(value, &opts[OPT_R],
 							   R_NAME);
+					set_conf_val(OPT_R, R_NAME, 1);
+					set_conf_val(OPT_R, R_DEV, 1);
 					break;
 				case R_SIZE:
-					rtbytes = getnum(value, &opts[OPT_R],
-								R_SIZE);
+					rtbytes = parse_conf_val(OPT_R, R_SIZE,
+								 value);
 					break;
 				case R_NOALIGN:
-					norsflag = getnum(value, &opts[OPT_R],
-								R_NOALIGN);
+					norsflag = parse_conf_val(OPT_R,
+								  R_NOALIGN,
+								  value);
 					break;
 				default:
 					unknown('r', value);
@@ -2016,12 +2081,14 @@ main(
 						conflict('s', subopts,
 							 S_SECTSIZE,
 							 S_SECTLOG);
-					sectorlog = getnum(value, &opts[OPT_S],
-							   S_SECTLOG);
+					sectorlog = parse_conf_val(OPT_S,
+								   S_SECTLOG,
+								   value);
 					lsectorlog = sectorlog;
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
 					lslflag = slflag = 1;
+					set_conf_val(OPT_S, S_LOG, sectorsize);
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
@@ -2029,13 +2096,16 @@ main(
 						conflict('s', subopts,
 							 S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = getnum(value,
-						&opts[OPT_S], S_SECTSIZE);
+					sectorsize = parse_conf_val(OPT_S,
+								    S_SECTSIZE,
+								    value);
 					lsectorsize = sectorsize;
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					lsectorlog = sectorlog;
 					lssflag = ssflag = 1;
+					set_conf_val(OPT_S,
+						     S_SIZE, sectorlog);
 					break;
 				default:
 					unknown('s', value);
-- 
2.1.4

