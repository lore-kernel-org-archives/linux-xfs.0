Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752819AbcLGNdn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:33:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5F2F624C4
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:43 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/22] mkfs: extend opt_params with a value field
Date: Wed,  7 Dec 2016 14:27:10 +0100
Message-Id: <1481117249-21273-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a new field int opt_params - value, which is filled with user input.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 372c620..edcfdc0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -115,6 +115,12 @@ unsigned int		sectorsize;
  *     sets what is used with simple specifying the subopt (-d file).
  *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
  *     value in any case.
+ *
+ *   value INTERNAL
+ *     Do not set this on initialization. Use defaultval for what you want
+ *     to do. This is filled with user input and anything you write here now
+ *     is overwritten. (If the user input is a string and not a number, this
+ *     value is set to a positive non-zero number.)
  */
 struct opt_params {
 	int		index;
@@ -131,6 +137,7 @@ struct opt_params {
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
+		long long	value;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
 #define OPT_B	0
@@ -1566,12 +1573,20 @@ main(
 								B_LOG);
 					blocksize = 1 << blocklog;
 					blflag = 1;
+					opts[OPT_B].subopt_params[B_LOG].value =
+							blocklog;
+					opts[OPT_B].subopt_params[B_SIZE].value =
+							blocksize;
 					break;
 				case B_SIZE:
 					blocksize = getnum(value, &opts[OPT_B],
 							   B_SIZE);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
+					opts[OPT_B].subopt_params[B_LOG].value =
+							blocklog;
+					opts[OPT_B].subopt_params[B_SIZE].value =
+							blocksize;
 					break;
 				default:
 					unknown('b', value);
@@ -1589,47 +1604,70 @@ main(
 					agcount = getnum(value, &opts[OPT_D],
 							 D_AGCOUNT);
 					daflag = 1;
+					opts[OPT_D].subopt_params[D_AGCOUNT].value =
+							agcount;
 					break;
 				case D_AGSIZE:
 					agsize = getnum(value, &opts[OPT_D],
 								D_AGSIZE);
 					dasize = 1;
+					opts[OPT_D].subopt_params[D_AGSIZE].value =
+							agsize;
 					break;
 				case D_FILE:
 					xi.disfile = getnum(value, &opts[OPT_D],
 							    D_FILE);
+					opts[OPT_D].subopt_params[D_FILE].value =
+							xi.disfile;
 					break;
 				case D_NAME:
 					xi.dname = getstr(value, &opts[OPT_D],
 								D_NAME);
+					opts[OPT_D].subopt_params[D_NAME].value = 1;
 					break;
 				case D_SIZE:
 					dbytes = getnum(value, &opts[OPT_D],
 								D_SIZE);
+					opts[OPT_D].subopt_params[D_SIZE].value =
+							dbytes;
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &opts[OPT_D],
 								D_SUNIT);
+					opts[OPT_D].subopt_params[D_SUNIT].value =
+							dsunit;
 					break;
 				case D_SWIDTH:
 					dswidth = getnum(value, &opts[OPT_D],
 							 D_SWIDTH);
+					opts[OPT_D].subopt_params[D_SWIDTH].value =
+							dswidth;
 					break;
 				case D_SU:
 					dsu = getnum(value, &opts[OPT_D], D_SU);
+					opts[OPT_D].subopt_params[D_SU].value =
+							dsu;
 					break;
 				case D_SW:
 					dsw = getnum(value, &opts[OPT_D], D_SW);
+					opts[OPT_D].subopt_params[D_SW].value =
+							dsw;
 					break;
 				case D_NOALIGN:
 					nodsflag = getnum(value, &opts[OPT_D],
 								D_NOALIGN);
+					opts[OPT_D].subopt_params[D_NOALIGN].value =
+							nodsflag;
 					break;
 				case D_SECTLOG:
 					sectorlog = getnum(value, &opts[OPT_D],
 							   D_SECTLOG);
 					sectorsize = 1 << sectorlog;
 					slflag = 1;
+					opts[OPT_D].subopt_params[D_SECTSIZE].value =
+							sectorsize;
+					opts[OPT_D].subopt_params[D_SECTLOG].value =
+							sectorlog;
 					break;
 				case D_SECTSIZE:
 					sectorsize = getnum(value, &opts[OPT_D],
@@ -1637,6 +1675,10 @@ main(
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
+					opts[OPT_D].subopt_params[D_SECTSIZE].value =
+							sectorsize;
+					opts[OPT_D].subopt_params[D_SECTLOG].value =
+							sectorlog;
 					break;
 				case D_RTINHERIT:
 					c = getnum(value, &opts[OPT_D],
@@ -1644,18 +1686,24 @@ main(
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
+					opts[OPT_D].subopt_params[D_RTINHERIT].value =
+							c;
 					break;
 				case D_PROJINHERIT:
 					fsx.fsx_projid = getnum(value, &opts[OPT_D],
 								D_PROJINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
+					opts[OPT_D].subopt_params[D_PROJINHERIT].value =
+							fsx.fsx_projid;
 					break;
 				case D_EXTSZINHERIT:
 					fsx.fsx_extsize = getnum(value, &opts[OPT_D],
 								 D_EXTSZINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
+					opts[OPT_D].subopt_params[D_EXTSZINHERIT].value =
+							fsx.fsx_extsize;
 					break;
 				default:
 					unknown('d', value);
@@ -1673,43 +1721,64 @@ main(
 					sb_feat.inode_align = getnum(value,
 								&opts[OPT_I],
 								I_ALIGN);
+					opts[OPT_I].subopt_params[I_ALIGN].value =
+							sb_feat.inode_align;
 					break;
 				case I_LOG:
 					inodelog = getnum(value, &opts[OPT_I],
 								I_LOG);
 					isize = 1 << inodelog;
 					ilflag = 1;
+					opts[OPT_I].subopt_params[I_SIZE].value =
+							isize;
+					opts[OPT_I].subopt_params[I_LOG].value =
+							inodelog;
 					break;
 				case I_MAXPCT:
 					imaxpct = getnum(value, &opts[OPT_I],
 							 I_MAXPCT);
 					imflag = 1;
+					opts[OPT_I].subopt_params[I_MAXPCT].value =
+							imaxpct;
 					break;
 				case I_PERBLOCK:
 					inopblock = getnum(value, &opts[OPT_I],
 							   I_PERBLOCK);
 					ipflag = 1;
+					opts[OPT_I].subopt_params[I_PERBLOCK].value =
+							inopblock;
 					break;
 				case I_SIZE:
 					isize = getnum(value, &opts[OPT_I],
 								I_SIZE);
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
+					opts[OPT_I].subopt_params[I_SIZE].value =
+							isize;
+					opts[OPT_I].subopt_params[I_LOG].value =
+							inodelog;
 					break;
 				case I_ATTR:
 					sb_feat.attr_version =
+
 						getnum(value, &opts[OPT_I],
 								I_ATTR);
+					opts[OPT_I].subopt_params[I_ATTR].value =
+							sb_feat.attr_version;
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
 						!getnum(value, &opts[OPT_I],
 							I_PROJID32BIT);
+					opts[OPT_I].subopt_params[I_PROJID32BIT].value =
+							sb_feat.projid16bit;
 					break;
 				case I_SPINODES:
 					sb_feat.spinodes = getnum(value,
 								&opts[OPT_I],
 								I_SPINODES);
+					opts[OPT_I].subopt_params[I_SPINODES].value =
+							sb_feat.spinodes;
 					break;
 				default:
 					unknown('i', value);
@@ -1727,24 +1796,34 @@ main(
 					logagno = getnum(value, &opts[OPT_L],
 								L_AGNUM);
 					laflag = 1;
+					opts[OPT_L].subopt_params[L_AGNUM].value =
+							logagno;
 					break;
 				case L_FILE:
 					xi.lisfile = getnum(value, &opts[OPT_L],
 							    L_FILE);
+					opts[OPT_L].subopt_params[L_FILE].value =
+							xi.lisfile;
 					break;
 				case L_INTERNAL:
 					loginternal = getnum(value, &opts[OPT_L],
 							     L_INTERNAL);
 					liflag = 1;
+					opts[OPT_L].subopt_params[L_INTERNAL].value =
+							loginternal;
 					break;
 				case L_SU:
 					lsu = getnum(value, &opts[OPT_L], L_SU);
 					lsuflag = 1;
+					opts[OPT_L].subopt_params[L_SU].value =
+							lsu;
 					break;
 				case L_SUNIT:
 					lsunit = getnum(value, &opts[OPT_L],
 								L_SUNIT);
 					lsunitflag = 1;
+					opts[OPT_L].subopt_params[L_SUNIT].value =
+							lsunit;
 					break;
 				case L_NAME:
 				case L_DEV:
@@ -1753,22 +1832,32 @@ main(
 					xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
+					opts[OPT_L].subopt_params[L_NAME].value = 1;
+					opts[OPT_L].subopt_params[L_DEV].value = 1;
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
 						getnum(value, &opts[OPT_L],
 								L_VERSION);
 					lvflag = 1;
+					opts[OPT_L].subopt_params[L_VERSION].value =
+							sb_feat.log_version;
 					break;
 				case L_SIZE:
 					logbytes = getnum(value, &opts[OPT_L],
 								L_SIZE);
+					opts[OPT_L].subopt_params[L_SIZE].value =
+							logbytes;
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &opts[OPT_L],
 							    L_SECTLOG);
 					lsectorsize = 1 << lsectorlog;
 					lslflag = 1;
+					opts[OPT_L].subopt_params[L_SECTSIZE].value =
+							lsectorsize;
+					opts[OPT_L].subopt_params[L_SECTLOG].value =
+							lsectorlog;
 					break;
 				case L_SECTSIZE:
 					lsectorsize = getnum(value, &opts[OPT_L],
@@ -1776,11 +1865,17 @@ main(
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
+					opts[OPT_L].subopt_params[L_SECTSIZE].value =
+							lsectorsize;
+					opts[OPT_L].subopt_params[L_SECTLOG].value =
+							lsectorlog;
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
 							getnum(value, &opts[OPT_L],
 							       L_LAZYSBCNTR);
+					opts[OPT_L].subopt_params[L_LAZYSBCNTR].value =
+							sb_feat.lazy_sb_counters;
 					break;
 				default:
 					unknown('l', value);
@@ -1805,20 +1900,27 @@ main(
 								M_CRC);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
+					opts[OPT_M].subopt_params[M_CRC].value =
+							sb_feat.crcs_enabled;
 					break;
 				case M_FINOBT:
 					sb_feat.finobt = getnum(
 						value, &opts[OPT_M], M_FINOBT);
+					opts[OPT_M].subopt_params[M_FINOBT].value =
+							sb_feat.finobt;
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
 						reqval('m', subopts, M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
+					opts[OPT_M].subopt_params[M_UUID].value = 1;
 					break;
 				case M_RMAPBT:
 					sb_feat.rmapbt = getnum(
 						value, &opts[OPT_M], M_RMAPBT);
+					opts[OPT_M].subopt_params[M_RMAPBT].value = 
+						sb_feat.rmapbt;
 					break;
 				case M_REFLINK:
 					sb_feat.reflink = getnum(
@@ -1841,6 +1943,10 @@ main(
 							     N_LOG);
 					dirblocksize = 1 << dirblocklog;
 					nlflag = 1;
+					opts[OPT_N].subopt_params[N_SIZE].value =
+							dirblocksize;
+					opts[OPT_N].subopt_params[N_LOG].value =
+							dirblocklog;
 					break;
 				case N_SIZE:
 					dirblocksize = getnum(value, &opts[OPT_N],
@@ -1848,6 +1954,10 @@ main(
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
+					opts[OPT_N].subopt_params[N_SIZE].value =
+							dirblocksize;
+					opts[OPT_N].subopt_params[N_LOG].value =
+							dirblocklog;
 					break;
 				case N_VERSION:
 					value = getstr(value, &opts[OPT_N],
@@ -1861,10 +1971,14 @@ main(
 							       N_VERSION);
 					}
 					nvflag = 1;
+					opts[OPT_N].subopt_params[N_VERSION].value =
+							sb_feat.dir_version;
 					break;
 				case N_FTYPE:
 					sb_feat.dirftype = getnum(value, &opts[OPT_N],
 								  N_FTYPE);
+					opts[OPT_N].subopt_params[N_FTYPE].value =
+							sb_feat.dirftype;
 					break;
 				default:
 					unknown('n', value);
@@ -1895,23 +2009,33 @@ main(
 				case R_EXTSIZE:
 					rtextbytes = getnum(value, &opts[OPT_R],
 								R_EXTSIZE);
+					opts[OPT_R].subopt_params[R_EXTSIZE].value =
+							rtextbytes;
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &opts[OPT_R],
 							    R_FILE);
+					opts[OPT_R].subopt_params[R_FILE].value =
+							xi.risfile;
 					break;
 				case R_NAME:
 				case R_DEV:
 					xi.rtname = getstr(value, &opts[OPT_R],
 							   R_NAME);
+					opts[OPT_R].subopt_params[R_NAME].value = 1;
+					opts[OPT_R].subopt_params[R_DEV].value = 1;
 					break;
 				case R_SIZE:
 					rtbytes = getnum(value, &opts[OPT_R],
 								R_SIZE);
+					opts[OPT_R].subopt_params[R_SIZE].value =
+							rtbytes;
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &opts[OPT_R],
 								R_NOALIGN);
+					opts[OPT_R].subopt_params[R_NOALIGN].value =
+							norsflag;
 					break;
 				default:
 					unknown('r', value);
@@ -1936,6 +2060,10 @@ main(
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
 					lslflag = slflag = 1;
+					opts[OPT_S].subopt_params[S_LOG].value =
+							sectorsize;
+					opts[OPT_S].subopt_params[S_SECTLOG].value =
+							sectorsize;
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
@@ -1949,6 +2077,10 @@ main(
 						libxfs_highbit32(sectorsize);
 					lsectorlog = sectorlog;
 					lssflag = ssflag = 1;
+					opts[OPT_S].subopt_params[S_SIZE].value =
+							sectorlog;
+					opts[OPT_S].subopt_params[S_SECTSIZE].value =
+							sectorlog;
 					break;
 				default:
 					unknown('s', value);
-- 
2.8.1

