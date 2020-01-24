Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA773C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B763E21569
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IMZw5GRe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgAXASK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:18:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAXASK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:18:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08mQ8002813;
        Fri, 24 Jan 2020 00:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tfb+mOaTHUDN4882XgkvjbPShz2zxmMV461ap3Y6Qos=;
 b=IMZw5GRe/HDSyIt38FTENP0zJZkuYfd4KXvLl2ArnVNsOGq8XcpSalDQYdqif2ZDhO9s
 JWocCGobD297P/J05TqRFJxmimbA6lDUVdhSmCR4q7b99TYiTS5a7yfrx+O24uPnCBBc
 0zPyjtKwHzrtc3oKAbQS2FXvCgvkN+6y+bLqsoMuSPgidJ0re0Wl4VQsYQcFh54ECnk5
 DU8gf0igK4OGlcvk3WJX9RhWVXXBbCAT1HOwNC7ooHaQrRHu2Q9EJdarEdTSZNRIV+LU
 mFcBa16qm1KJJ/FZWGUnDfElrcP8KLdacIVX34TEdWZgqIl1bsLyWYa4cXqooR8NKRfY bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnrnn4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:18:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0Eb2N145960;
        Fri, 24 Jan 2020 00:18:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xqmudkvrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:18:07 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0I6D2031252;
        Fri, 24 Jan 2020 00:18:06 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:18:05 -0800
Subject: [PATCH 6/6] xfs_repair: try to correct sb_unit value from
 secondaries
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Thu, 23 Jan 2020 16:18:03 -0800
Message-ID: <157982508365.2765631.12815545024134566792.stgit@magnolia>
In-Reply-To: <157982504556.2765631.630298760136626647.stgit@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the primary superblock's sb_unit leads to a rootino calculation that
doesn't match sb_rootino /but/ we can find a secondary superblock whose
sb_unit does match, fix the primary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/xfs_repair.c      |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9ede0125..d9f497e0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -178,5 +178,6 @@
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_read_agf			libxfs_read_agf
+#define xfs_sb_read_secondary		libxfs_sb_read_secondary
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 372616c4..66e2c335 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -457,6 +457,84 @@ has_plausible_rootdir(
 	return ret;
 }
 
+/*
+ * If any of the secondary SBs contain a *correct* value for sunit, write that
+ * back to the primary superblock.
+ */
+static void
+guess_correct_sunit(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		sb;
+	struct xfs_buf		*bp;
+	xfs_ino_t		calc_rootino = NULLFSINO;
+	xfs_agnumber_t		agno;
+	unsigned int		new_sunit;
+	unsigned int		sunit_guess;
+	int			error;
+
+	/* Try reading secondary supers to see if we find a good sb_unit. */
+	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
+		error = -libxfs_sb_read_secondary(mp, NULL, agno, &bp);
+		if (error)
+			continue;
+		libxfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+		libxfs_putbuf(bp);
+
+		calc_rootino = libxfs_ialloc_calc_rootino(mp, sb.sb_unit);
+		if (calc_rootino == mp->m_sb.sb_rootino)
+			break;
+	}
+
+	/* If we found a reasonable value, log where we found it. */
+	if (calc_rootino == mp->m_sb.sb_rootino) {
+		do_warn(_("AG %u superblock contains plausible sb_unit value\n"),
+				agno);
+		new_sunit = sb.sb_unit;
+		goto fix;
+	}
+
+	/* Try successive powers of two. */
+	for (sunit_guess = 1;
+	     sunit_guess <= XFS_AG_MAX_BLOCKS(mp->m_sb.sb_blocklog);
+	     sunit_guess *= 2) {
+		calc_rootino = libxfs_ialloc_calc_rootino(mp, sunit_guess);
+		if (calc_rootino == mp->m_sb.sb_rootino)
+			break;
+	}
+
+	/* If we found a reasonable value, log where we found it. */
+	if (calc_rootino == mp->m_sb.sb_rootino) {
+		do_warn(_("Found an sb_unit value that looks plausible\n"));
+		new_sunit = sunit_guess;
+		goto fix;
+	}
+
+	do_warn(_("Could not estimate a plausible sb_unit value\n"));
+	return;
+
+fix:
+	if (!no_modify)
+		do_warn(_("Resetting sb_unit to %u\n"), new_sunit);
+	else
+		do_warn(_("Would reset sb_unit to %u\n"), new_sunit);
+
+	/*
+	 * Just set the value -- safe since the superblock doesn't get flushed
+	 * out if no_modify is set.
+	 */
+	mp->m_sb.sb_unit = new_sunit;
+
+	/* Make sure that swidth is still a multiple of sunit. */
+	if (mp->m_sb.sb_width % mp->m_sb.sb_unit == 0)
+		return;
+
+	if (!no_modify)
+		do_warn(_("Resetting sb_width to %u\n"), new_sunit);
+	else
+		do_warn(_("Would reset sb_width to %u\n"), new_sunit);
+}
+
 /*
  * Make sure that the first 3 inodes in the filesystem are the root directory,
  * the realtime bitmap, and the realtime summary, in that order.
@@ -480,6 +558,7 @@ calc_mkfs(
 		do_warn(
 _("sb root inode value %" PRIu64 " inconsistent with alignment (expected %"PRIu64")\n"),
 			mp->m_sb.sb_rootino, rootino);
+		guess_correct_sunit(mp);
 		rootino = mp->m_sb.sb_rootino;
 	}
 

