Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6EDC43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DDBE205ED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rDHj47BU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfLDRFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:05:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfLDRFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:05:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4H4Znu007262;
        Wed, 4 Dec 2019 17:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aYaM/Yd+darJmqIqx8PvV/MtsZnfou2C6GCujmLmYpA=;
 b=rDHj47BU7J0NRgOG3RD79nVAQey8N0q40nJeRnWe0V8Z8NFGgrzsbs1+N8mBE7/0xKY0
 KTHIN2drUxjhjlgKnjpRXZBRuu2c/jj211j1cxFwxukU9YZYzaUfMWFY7WfAAEuLlr2j
 hM1RjOkFc5MAoNpU5jsA7XhOmfr3mi8qIIDnV5rYBSEa3wkpva9W9/z8tl7+lexbVbnQ
 aoQ519QQdn4GadqFnOIO3BTNi+RFl2CK4jq/NrDOiqz8DFZrn7TSDuSMyCuVFXI1d34k
 VWHZm4Xs0l0M3N5THk85YWwcH/6wrBvTJ6wa3hyLbm1FZROEQNnb3NXKdQEqmmhA3RWP kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcqfq1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:05:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GwtR6119806;
        Wed, 4 Dec 2019 17:05:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wp17ec571-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:05:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB4H545d013858;
        Wed, 4 Dec 2019 17:05:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:05:03 -0800
Subject: [PATCH 6/6] xfs_repair: check plausibility of root dir pointer
 before trashing it
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Wed, 04 Dec 2019 09:05:02 -0800
Message-ID: <157547910268.974712.78208912903649937.stgit@magnolia>
In-Reply-To: <157547906289.974712.8933333382010386076.stgit@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If sb_rootino doesn't point to where we think mkfs should have allocated
the root directory, check to see if the alleged root directory actually
looks like a root directory.  If so, we'll let it live because someone
could have changed sunit since formatting time, and that changes the
root directory inode estimate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index abd568c9..b0407f4b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -426,6 +426,37 @@ _("would reset superblock %s inode pointer to %"PRIu64"\n"),
 	*ino = expected_ino;
 }
 
+/* Does the root directory inode look like a plausible root directory? */
+static bool
+has_plausible_rootdir(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	int			error;
+	bool			ret = false;
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
+			&xfs_default_ifork_ops);
+	if (error)
+		goto out;
+	if (!S_ISDIR(VFS_I(ip)->i_mode))
+		goto out_rele;
+
+	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
+	if (error)
+		goto out_rele;
+
+	/* The root directory '..' entry points to the directory. */
+	if (ino == mp->m_sb.sb_rootino)
+		ret = true;
+
+out_rele:
+	libxfs_irele(ip);
+out:
+	return ret;
+}
+
 /*
  * Make sure that the first 3 inodes in the filesystem are the root directory,
  * the realtime bitmap, and the realtime summary, in that order.
@@ -436,6 +467,20 @@ calc_mkfs(
 {
 	xfs_ino_t		rootino = libxfs_ialloc_calc_rootino(mp, -1);
 
+	/*
+	 * If the root inode isn't where we think it is, check its plausibility
+	 * as a root directory.  It's possible that somebody changed sunit
+	 * since the filesystem was created, which can change the value of the
+	 * above computation.  Don't blow up the root directory if this is the
+	 * case.
+	 */
+	if (mp->m_sb.sb_rootino != rootino && has_plausible_rootdir(mp)) {
+		do_warn(
+_("sb root inode value %" PRIu64 " inconsistent with alignment (expected %"PRIu64")\n"),
+			mp->m_sb.sb_rootino, rootino);
+		rootino = mp->m_sb.sb_rootino;
+	}
+
 	ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
 	ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,

