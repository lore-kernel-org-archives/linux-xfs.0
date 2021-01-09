Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6679C433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C68523A69
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbhAIGbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:31:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbhAIGbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:31:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 109694Vj110553;
        Sat, 9 Jan 2021 06:30:56 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35y4ekg8mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:30:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096AWfw048062;
        Sat, 9 Jan 2021 06:28:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35y3tgvvwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1096Sso3028213;
        Sat, 9 Jan 2021 06:28:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Jan 2021 06:28:54 +0000
Subject: [PATCH 3/3] xfs_scrub: handle concurrent directory updates during
 name scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:53 -0800
Message-ID: <161017373322.1142776.5174880606166253807.stgit@magnolia>
In-Reply-To: <161017371478.1142776.6610535704942901172.stgit@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=971 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=978 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1034
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
and the kernel does not provide a stable cursor interface, which means
that we can see the same byte sequence multiple times during a scan.
This isn't a confusing name error since the kernel enforces uniqueness
on the byte sequence, so all we need to do here is update the old entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index de3217c2..f5407b5e 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -68,7 +68,7 @@ struct name_entry {
 
 	xfs_ino_t		ino;
 
-	/* Raw UTF8 name */
+	/* Raw dirent name */
 	size_t			namelen;
 	char			name[0];
 };
@@ -627,6 +627,20 @@ unicrash_add(
 	uc->buckets[bucket] = new_entry;
 
 	while (entry != NULL) {
+		/*
+		 * If we see the same byte sequence then someone's modifying
+		 * the namespace while we're scanning it.  Update the existing
+		 * entry's inode mapping and erase the new entry from existence.
+		 */
+		if (new_entry->namelen == entry->namelen &&
+		    !memcmp(new_entry->name, entry->name, entry->namelen)) {
+			entry->ino = new_entry->ino;
+			uc->buckets[bucket] = new_entry->next;
+			name_entry_free(new_entry);
+			*badflags = 0;
+			continue;
+		}
+
 		/* Same normalization? */
 		if (new_entry->normstrlen == entry->normstrlen &&
 		    !u_strcmp(new_entry->normstr, entry->normstr) &&

