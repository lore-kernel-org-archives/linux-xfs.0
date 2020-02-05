Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312D1C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0493D214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GyAdvE7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgBEArU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:47:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbgBEArU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dH11112978;
        Wed, 5 Feb 2020 00:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=lLpFIE7rxrR7E5mZj4M3DsEJc3LehYaDEYtlPiUmyys=;
 b=GyAdvE7uYhQlvK5LCM87gADk/10bBhGWhniSq5e+k1ay1kbRQUOAFUOBc66PBBnkib/a
 FwkLauIsHATBxh2gMY3kDHHktfOpMgwbB4l9+5nWW9EV2vLlJwZnCTMysH/dfEByq9Ga
 ZL/TbKfyNCwKqoCtTp+RZ54/d+ZgSj5q5vEJPu3xV2SXxYiHJWkD2rzKNwi0FpWnvgNk
 ZtIkc1e5HKRdtLXUnh5bL2XGJDX55VmEeNObDSWGVOiG1Efo2eMMpC3sQvEmmqbuSp82
 vS4rXSQ2I8z+GLKvUEmq2RdgKqvjc8tIYykNlyiJVgbmj25Dfwc7sEJBFLt3B883TEn6 rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xykbp80mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150e1RM115692;
        Wed, 5 Feb 2020 00:47:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xykc30ym8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150lGwJ011224;
        Wed, 5 Feb 2020 00:47:16 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:16 -0800
Subject: [PATCH 6/7] xfs_repair: check plausibility of root dir pointer
 before trashing it
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 04 Feb 2020 16:47:15 -0800
Message-ID: <158086363533.2079685.15692340020655871081.stgit@magnolia>
In-Reply-To: <158086359783.2079685.9581209719946834913.stgit@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
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
index 111306fe..b34d41d4 100644
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
@@ -438,6 +469,20 @@ calc_mkfs(
 
 	rootino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
 
+	/*
+	 * If the root inode isn't where we think it is, check its plausibility
+	 * as a root directory.  It's possible that somebody changed sunit
+	 * since the filesystem was created, which can change the value of the
+	 * above computation.  Don't blow up the root directory if this is the
+	 * case.
+	 */
+	if (mp->m_sb.sb_rootino != rootino && has_plausible_rootdir(mp)) {
+		do_warn(
+_("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"PRIu64") possibly due to sunit change\n"),
+			mp->m_sb.sb_rootino, rootino);
+		rootino = mp->m_sb.sb_rootino;
+	}
+
 	validate_sb_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
 	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,

