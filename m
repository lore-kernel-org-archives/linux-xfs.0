Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B9BC3F2D1
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C0992468A
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZLzU+Pv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgB2BtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:49:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2BtT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 20:49:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1hXVo146064
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zqT1waGPcGmCGRIp8XihIg6CH2fSFKFZVWZrYUCkLjY=;
 b=ZLzU+Pv3WU4kLwIwMYMcqmXieociE8P1WEqCybj3w6nxxF4JauzR3B73blS8g0nOGx3X
 KC953WIyMaP1eywtCeG+0A0dYswQWXUHoW19RBo/dup2nGkBkxnGWTuGENtoNC4a8Ih2
 mmGwd2W65D90fGavL0nojUuecHKnOjLNJjOUHqEfxUM4yzvqoegEOY9lmbiNgQ9rUk6r
 A0yot7mE8wTaUldmwKTz8YexZjxWCoV63fCA1C8DzmqlsvJry+hCiidSbKvEtr/dK1qc
 YYYgBrI40L/28qLfXgq8ewZts3czEdbXUTqpwJwLEvYh2R0fJZgRI/kndGMyMHYvtsys vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnx737-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1ihNh107137
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ydcsgst84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01T1nHXN017012
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:49:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:49:16 -0800
Subject: [PATCH 2/3] xfs: mark extended attr corrupt when lookup-by-hash
 fails
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 17:49:15 -0800
Message-ID: <158294095587.1730101.1908515041366122931.stgit@magnolia>
In-Reply-To: <158294094367.1730101.10848559171120744339.stgit@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=820 spamscore=0 suspectscore=1 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=887 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_xattr_listent, we attempt to validate the extended attribute
hash structures by performing a attr lookup by (hashed) name.  If the
lookup returns ENODATA, that means that the hash information is corrupt.
The _process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..54ea1efa7ddc 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -163,6 +163,11 @@ xchk_xattr_listent(
 	args.valuelen = valuelen;
 
 	error = xfs_attr_get_ilocked(context->dp, &args);
+	if (error == -ENODATA) {
+		/* ENODATA means the hash lookup failed and the attr is bad */
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
 	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
 			&error))
 		goto fail_xref;

