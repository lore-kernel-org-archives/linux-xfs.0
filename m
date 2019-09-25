Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812F4C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4940820872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ojMS8AKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfIYVlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:41:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfIYVlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:41:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQbV058345;
        Wed, 25 Sep 2019 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g3AOgnmL9gXtWcW12jEdMYOzVe2gSO3Ft9sUJld/FaU=;
 b=ojMS8AKd6U8UrWwM3FF2hC6CgniJDoOZLOoCZ/rKYaBAsI6ljERJzB9LJ6BWET5k0k6G
 pBAyXfMYNAqDHv9O1kyQiQCJJHCVTVUmq7g6hfNb7Csk6xC7sjWSke9245tm+FgZ/92p
 AW/8mcYGJS4O9CELgkN9CcpcCYqO1LLaBP1DPy6NmDvKERv2u6l6SBezopwupDNUALBx
 aEiehmXGmQFMMsRqn4WO6J2oQYy6Q9jlbMDnMf4OSYPa1SyuMKBcZhVtw2LLPldD6RNG
 qJ39fC/5O5Ec6gicJ28YY1hrqAUlaL8sR3VEtS9VYtmw+jdIzNnB4/+7v50sUWkIrw+I 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:41:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdLT6107817;
        Wed, 25 Sep 2019 21:41:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qam4e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:41:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLf5Od018128;
        Wed, 25 Sep 2019 21:41:05 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:41:05 -0700
Subject: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:59 -0700
Message-ID: <156944765991.303060.7541074919992777157.stgit@magnolia>
In-Reply-To: <156944764785.303060.15428657522073378525.stgit@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
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
index e2c9759f..be604ebc 100644
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
+static int disk_blocksize(struct xfs_mount *mp)
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
+	{"bnobt", libxfs_allocbt_maxrecs, disk_blocksize},
+	{"cntbt", libxfs_allocbt_maxrecs, disk_blocksize},
+	{"inobt", libxfs_inobt_maxrecs, disk_blocksize},
+	{"finobt", libxfs_inobt_maxrecs, disk_blocksize},
+	{"bmapbt", libxfs_bmbt_maxrecs, disk_blocksize},
+	{"refcountbt", refc_maxrecs, disk_blocksize},
+	{"rmapbt", rmap_maxrecs, disk_blocksize},
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
 			_("%s: record size must be less than %u bytes.\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
-	if (key_size > blocksize) {
+	if (key_size > *blocksize) {
 		fprintf(stderr,
 			_("%s: key size must be less than %u bytes.\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
-	if (ptr_size > blocksize) {
+	if (ptr_size > *blocksize) {
 		fprintf(stderr,
 			_("%s: pointer size must be less than %u bytes.\n"),
-			tag, blocksize);
+			tag, *blocksize);
 		goto out;
 	}
 
@@ -221,8 +254,8 @@ construct_records_per_block(
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

