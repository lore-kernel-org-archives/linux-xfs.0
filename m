Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED227C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD6921D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="euSLoeGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfIYVbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:31:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfIYVbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:31:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLT2aZ005746;
        Wed, 25 Sep 2019 21:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=akSy6j6WMSmpaMRGS3oKuZrIfAORRpheKg0Cr5+txmw=;
 b=euSLoeGgygil4t7L4zuM0FFyeFFmzX6UbrBqbmsSr9PoMPk7VJ+aR9xnSgwNdJUoQm4Y
 C3kr2iQFdyGPLHYX68HnWK3z1geacJAm77p+s79PLcx5r5BxyRFJSahSYXu8Qlp/B9/f
 +jo+YgFYSO57BQXqm44iejq3nY5mTiNaZHlrtiPxXgzjjSECAHoZApkm4nhUzItblpbU
 EbHL1W/BImmNRUuaBFq2tFno5UJWPiIM6IBS6fMpJwvtu/NMHMqkrM7xmvUtTzU75fK8
 NFAXsiHhwdXIMKHBiAizfSMa2etiZKgW4egrAqQCq1srar/KFGGzMeKG/BjkCKmQ918M qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTFbF085339;
        Wed, 25 Sep 2019 21:31:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakmcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLVPLL013237;
        Wed, 25 Sep 2019 21:31:25 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:25 -0700
Subject: [PATCH 3/5] libfrog: add online scrub/repair for superblock counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:31:23 -0700
Message-ID: <156944708372.296129.3605667306853139478.stgit@magnolia>
In-Reply-To: <156944706528.296129.7604742756772046951.stgit@magnolia>
References: <156944706528.296129.7604742756772046951.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Wire up the new superblock summary counter ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libfrog/scrub.c |    6 ++++++
 libfrog/scrub.h |    7 +++++++
 scrub/scrub.c   |    2 ++
 3 files changed, 15 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 12c0926f..e9671da2 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -129,6 +129,12 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "project quotas",
 		.type	= XFROG_SCRUB_TYPE_FS,
 	},
+	[XFS_SCRUB_TYPE_FSCOUNTERS] = {
+		.name	= "fscounters",
+		.descr	= "filesystem summary counters",
+		.type	= XFROG_SCRUB_TYPE_FS,
+		.flags	= XFROG_SCRUB_DESCR_SUMMARY,
+	},
 };
 
 int
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 6fda8975..e43d8c24 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -20,8 +20,15 @@ struct xfrog_scrub_descr {
 	const char		*name;
 	const char		*descr;
 	enum xfrog_scrub_type	type;
+	unsigned int		flags;
 };
 
+/*
+ * The type of metadata checked by this scrubber is a summary of other types
+ * of metadata.  This scrubber should be run after all the others.
+ */
+#define XFROG_SCRUB_DESCR_SUMMARY	(1 << 0)
+
 extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 153d29d5..083ed9a1 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -293,6 +293,8 @@ xfs_scrub_metadata(
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
 		if (sc->type != scrub_type)
 			continue;
+		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
+			continue;
 
 		meta.sm_type = type;
 		meta.sm_flags = 0;

