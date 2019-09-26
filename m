Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68026C352A9
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3762A2245B
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HTY8CEk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfIZTJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 15:09:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfIZTJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 15:09:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QJ8Y22090059;
        Thu, 26 Sep 2019 19:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1JXeNCg0nOaNPS67E6+4IhpXYlyKRCXtWOQlk5BSFGE=;
 b=HTY8CEk/XuFgw/JWQKk2o3EXihd+gyqo28OxoP0l5heaUkBZ7DZuNwhVbFskzFA6HeW3
 OXZU+F+EClEM5q65z7ym3Rrb0oM9W43aSYDskwrYI94Mzg/cadxq6xr0D2S9YNldIBiz
 eKAHHXkv++k2ixgm7R2qOXhcxAl2yXAMA9CKltBEQpq+V1uM/m2fHCgQVWE+Wu61uTuX
 /nPCpdwEceeTeX0GcC6HF2htxmjS+JUaVUbU0/wbn+3noykp+CKAuDRyWwlyIsacyhzx
 0JHBg5OnwsquN/RO118lF4LKSEUuL1orSNSB3Qyv8yk/bRLRFD4sQdY3LYsikKZBIedr Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btqdu9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:09:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QIsUva037989;
        Thu, 26 Sep 2019 19:09:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v8yjwyjsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:09:29 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8QJ9ScK026666;
        Thu, 26 Sep 2019 19:09:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 12:09:28 -0700
Date:   Thu, 26 Sep 2019 12:09:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190926190927.GH9916@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944765991.303060.7541074919992777157.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

(Ab)use the btheight command to calculate the geometry of the incore
extent tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/btheight.c |   87 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 27 deletions(-)

diff --git a/db/btheight.c b/db/btheight.c
index 8aa17c89..3406ac77 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -22,18 +22,37 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
 	return libxfs_rmapbt_maxrecs(blocklen, leaf);
 }
 
+static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
+{
+	blocklen -= 2 * sizeof(void *);
+
+	return blocklen / sizeof(struct xfs_bmbt_rec);
+}
+
+static int fs_blocksize(struct xfs_mount *mp)
+{
+	return mp->m_sb.sb_blocksize;
+}
+
+static int iext_blocksize(struct xfs_mount *mp)
+{
+	return 256;
+}
+
 struct btmap {
 	const char	*tag;
 	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
 				   int leaf);
+	int		(*default_blocksize)(struct xfs_mount *mp);
 } maps[] = {
-	{"bnobt", libxfs_allocbt_maxrecs},
-	{"cntbt", libxfs_allocbt_maxrecs},
-	{"inobt", libxfs_inobt_maxrecs},
-	{"finobt", libxfs_inobt_maxrecs},
-	{"bmapbt", libxfs_bmbt_maxrecs},
-	{"refcountbt", refc_maxrecs},
-	{"rmapbt", rmap_maxrecs},
+	{"bnobt", libxfs_allocbt_maxrecs, fs_blocksize},
+	{"cntbt", libxfs_allocbt_maxrecs, fs_blocksize},
+	{"inobt", libxfs_inobt_maxrecs, fs_blocksize},
+	{"finobt", libxfs_inobt_maxrecs, fs_blocksize},
+	{"bmapbt", libxfs_bmbt_maxrecs, fs_blocksize},
+	{"refcountbt", refc_maxrecs, fs_blocksize},
+	{"rmapbt", rmap_maxrecs, fs_blocksize},
+	{"iext", iext_maxrecs, iext_blocksize},
 };
 
 static void
@@ -108,7 +127,7 @@ calc_height(
 static int
 construct_records_per_block(
 	char		*tag,
-	int		blocksize,
+	int		*blocksize,
 	unsigned int	*records_per_block)
 {
 	char		*toktag;
@@ -119,8 +138,10 @@ construct_records_per_block(
 
 	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++) {
 		if (!strcmp(m->tag, tag)) {
-			records_per_block[0] = m->maxrecs(mp, blocksize, 1);
-			records_per_block[1] = m->maxrecs(mp, blocksize, 0);
+			if (*blocksize < 0)
+				*blocksize = m->default_blocksize(mp);
+			records_per_block[0] = m->maxrecs(mp, *blocksize, 1);
+			records_per_block[1] = m->maxrecs(mp, *blocksize, 0);
 			return 0;
 		}
 	}
@@ -178,38 +199,50 @@ construct_records_per_block(
 		fprintf(stderr, _("%s: header type not found.\n"), tag);
 		goto out;
 	}
-	if (!strcmp(p, "short"))
+	if (!strcmp(p, "short")) {
+		if (*blocksize < 0)
+			*blocksize = mp->m_sb.sb_blocksize;
 		blocksize -= XFS_BTREE_SBLOCK_LEN;
-	else if (!strcmp(p, "shortcrc"))
+	} else if (!strcmp(p, "shortcrc")) {
+		if (*blocksize < 0)
+			*blocksize = mp->m_sb.sb_blocksize;
 		blocksize -= XFS_BTREE_SBLOCK_CRC_LEN;
-	else if (!strcmp(p, "long"))
+	} else if (!strcmp(p, "long")) {
+		if (*blocksize < 0)
+			*blocksize = mp->m_sb.sb_blocksize;
 		blocksize -= XFS_BTREE_LBLOCK_LEN;
-	else if (!strcmp(p, "longcrc"))
+	} else if (!strcmp(p, "longcrc")) {
+		if (*blocksize < 0)
+			*blocksize = mp->m_sb.sb_blocksize;
 		blocksize -= XFS_BTREE_LBLOCK_CRC_LEN;
-	else {
+	} else if (!strcmp(p, "iext")) {
+		if (*blocksize < 0)
+			*blocksize = 256;
+		blocksize -= 2 * sizeof(void *);
+	} else {
 		fprintf(stderr, _("%s: unrecognized btree header type."),
 				p);
 		goto out;
 	}
 
-	if (record_size > blocksize) {
+	if (record_size > *blocksize) {
 		fprintf(stderr,
 _("%s: record size must be less than selected block size (%u bytes).\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
-	if (key_size > blocksize) {
+	if (key_size > *blocksize) {
 		fprintf(stderr,
 _("%s: key size must be less than selected block size (%u bytes).\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
-	if (ptr_size > blocksize) {
+	if (ptr_size > *blocksize) {
 		fprintf(stderr,
 _("%s: pointer size must be less than selected block size (%u bytes).\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
@@ -221,8 +254,8 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
 		goto out;
 	}
 
-	records_per_block[0] = blocksize / record_size;
-	records_per_block[1] = blocksize / (key_size + ptr_size);
+	records_per_block[0] = *blocksize / record_size;
+	records_per_block[1] = *blocksize / (key_size + ptr_size);
 	ret = 0;
 out:
 	free(toktag);
@@ -238,12 +271,12 @@ report(
 	char			*tag,
 	unsigned int		report_what,
 	unsigned long long	nr_records,
-	unsigned int		blocksize)
+	int			blocksize)
 {
 	unsigned int		records_per_block[2];
 	int			ret;
 
-	ret = construct_records_per_block(tag, blocksize, records_per_block);
+	ret = construct_records_per_block(tag, &blocksize, records_per_block);
 	if (ret)
 		return;
 
@@ -302,7 +335,7 @@ btheight_f(
 	int		argc,
 	char		**argv)
 {
-	long long	blocksize = mp->m_sb.sb_blocksize;
+	long long	blocksize = -1;
 	uint64_t	nr_records = 0;
 	int		report_what = REPORT_DEFAULT;
 	int		i, c;
@@ -355,7 +388,7 @@ _("The largest block size this command will consider is %u bytes.\n"),
 		return 0;
 	}
 
-	if (blocksize < 128) {
+	if (blocksize >= 0 && blocksize < 128) {
 		fprintf(stderr,
 _("The smallest block size this command will consider is 128 bytes.\n"));
 		return 0;
