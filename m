Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB681C47257
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A647B20735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7lGaFLK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgEIQbr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgEIQbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgNC072327;
        Sat, 9 May 2020 16:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gVVPuL0W4jO+ff2/Q7Y+jATkpGmG+KqaCxaX4OIz+2g=;
 b=V7lGaFLK0TRqcxUix1Xu/G8GeDkRkPfYLnCOkRrx65jWiRFjc+woicHUuYf2IirYt5sq
 Jfo4fVGPbp5aq5H5VgLuE4c2/McFvryaKAHN/Ot7qBwQ1y54MSOktl4czLGxhhxN6znF
 qW2w1iKK4nEZFsx+T7NYx87V1JkNEh+wyhaETf6AbrGRtvzeCgj88TJm0mq83oqsdtkX
 7ojs0EiqvVSc1EWmruOXeM/PapFbDijanse+kAOW2PyqoV3nc5VZdMgTnzieWk+sHonr
 ioIZtujymkOi9MWz3Ftt7vo+F92DX99z9Yos0rKImL6QdHZO9KnViCnzFcCdi9IaTqEA SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30wkxqs6ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRdUF132591;
        Sat, 9 May 2020 16:29:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30wwxb5gpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GTidR025535;
        Sat, 9 May 2020 16:29:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:29:43 -0700
Subject: [PATCH 2/3] find_api_violations: fix sed expression
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:29:43 -0700
Message-ID: <158904178381.982835.124483584305094681.stgit@magnolia>
In-Reply-To: <158904177147.982835.3876574696663645345.stgit@magnolia>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Apparently, the grep program in Ubuntu 20.04 is pickier about requiring
'(' to be escaped inside range expressions.  This causes a regression in
xfs/437, so fix it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/find-api-violations.sh |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
index b175ca10..c25fccca 100755
--- a/tools/find-api-violations.sh
+++ b/tools/find-api-violations.sh
@@ -18,8 +18,14 @@ check_if_api_calls() {
 	while read f; do grep "^$f(" libxfs/*.c; done | sed -e 's/^.*:xfs_/xfs_/g' -e 's/.$//g'
 }
 
+# Generate a grep search expression for troublesome API call sites.
+# " foo(", ",foo(", "-foo(", and "(foo(" are examples.
+grep_pattern() {
+	sed -e 's/^/[[:space:],-\\(]/g' -e 's/$/(/g'
+}
+
 find_libxfs_violations() {
-	grep -r -n -f <(find_possible_api_calls | check_if_api_calls | sed -e 's/^/[[:space:],-(]/g' -e 's/$/(/g' ) $tool_dirs
+	grep -r -n -f <(find_possible_api_calls | check_if_api_calls | grep_pattern) $tool_dirs
 }
 
 # libxfs calls without negated error codes
@@ -33,7 +39,7 @@ find_possible_libxfs_api_calls() {
 }
 
 find_libxfs_api_violations() {
-	grep -r -n -f <(find_possible_libxfs_api_calls | sed -e 's/^/[[:space:],-(]/g' -e 's/$/(/g') $tool_dirs
+	grep -r -n -f <(find_possible_libxfs_api_calls | grep_pattern) $tool_dirs
 }
 
 (find_libxfs_violations ; find_errcode_violations ; find_libxfs_api_violations) | sort -g -t ':' -k 2 | sort -g -t ':' -k 1 | uniq

