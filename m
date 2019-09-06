Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8529C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFA02082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SIRBhBcr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392127AbfIFDdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:33:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392118AbfIFDdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:33:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863TMxQ106292;
        Fri, 6 Sep 2019 03:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3nYVxhiSzPkdR4PyabA134kovsz5M/t52+7NpteRt6Y=;
 b=SIRBhBcrwnb0yMPOXn5THPOOIWHNByMYQ/Jl4LDhk83Vw2TLenY742PIOsZIXUyfqdEP
 JI9BK+mrcpJ3eBN8Eh0+/BNv3FRG8j3nyvKujrR7iAm9CmiqkHkERNs9WJH0wmNz2Tyi
 FrnTgjFWJ5jlN9DvOI87/uFdNamsyXK8XhO7v5I0fQSTyKK2oOCZUMBkU99nNuC9bmI/
 /Z/omFRzdz8ZGbBllkWb70fRrTxE9v2qGwX45SELGmvybTFKa1n1h8aTSc0hyHz6sji8
 2xstm37Yy6HFvaOhyaaSZ5RCvJzsTbR34i1mkT4kARkBIBd07dkhElO0M5fulVBfaB58 lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n033b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xa79069084;
        Fri, 6 Sep 2019 03:33:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr4jrqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863Xfp4013851;
        Fri, 6 Sep 2019 03:33:41 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:33:41 -0700
Subject: [PATCH 3/5] libfrog: add online scrub/repair for superblock counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:33:41 -0700
Message-ID: <156774082101.2643094.1783403731035812142.stgit@magnolia>
In-Reply-To: <156774080205.2643094.9791648860536208060.stgit@magnolia>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Wire up the new superblock summary counter ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/scrub.c |    6 ++++++
 libfrog/scrub.h |    7 +++++++
 scrub/scrub.c   |    2 ++
 3 files changed, 15 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 228e4339..04e44565 100644
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

