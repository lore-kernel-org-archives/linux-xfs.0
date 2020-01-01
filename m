Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF05C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B623206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DQWhXto+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgAABXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:23:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgAABXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:23:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FLel092752;
        Wed, 1 Jan 2020 01:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4cpnlmIpe1CT5Yevfgonv1nvJf8XTtGinPzq4gj4Rtg=;
 b=DQWhXto+XJkw0SoZUYvA0fFjHKjBX/KymSXTlUevV114suneJAOjBck9FjjLG4SR2NW3
 WfBeRi1+1bK/6p/gpNQfaIiSvx3lyZPZFCVJjMgLOgU4+GusDPkw3ixZexXoimdpEwyT
 1s35C561VnqmTlHj+nnW4uDUzv6/dq9bhNlvSW3ythzpZYmYCjKRcDSHxWdiLEyrCuVz
 9Qw73styxpoWCfdHAFceCpEr+aMWrNAKP2o2GYzP9Qj7rr07ccm9FgXttyjTuPn/JPgW
 7aZ6IEGqYlG73Pvqhc9LfS7AhoM9oLJXvhWVsDtooi05XhOYaKFECS4QfQewFd6RkE5h 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:23:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I7XZ056854;
        Wed, 1 Jan 2020 01:21:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfjew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:21:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011LMfE031247;
        Wed, 1 Jan 2020 01:21:22 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:21:22 -0800
Subject: [PATCH 6/6] xfs_repair: try to correct sb_unit value from
 secondaries
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 31 Dec 2019 17:21:19 -0800
Message-ID: <157784167941.1371066.4768907637646125510.stgit@magnolia>
In-Reply-To: <157784164200.1371066.15490825981810186191.stgit@magnolia>
References: <157784164200.1371066.15490825981810186191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
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
 libxfs/libxfs_api_defs.h |    2 +
 repair/xfs_repair.c      |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b042f0a2..355f99a2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -175,4 +175,6 @@
 #define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 
+#define xfs_sb_read_secondary		libxfs_sb_read_secondary
+
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
 

