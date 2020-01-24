Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6E4C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2302071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3fyeujk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgAXAS5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:18:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34518 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAXAS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:18:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O09q26183453;
        Fri, 24 Jan 2020 00:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LA921WI6yfojEG96jHlZJ9/YUVJQ88zMY3s/z0maJyQ=;
 b=D3fyeujkVhvRjjD8mQ1UTFCnhQB4XachxlqXfi1iYBIh6mrPNT116Mvj/S+iaKiIKE6C
 tYBti3/N3RWnqT58V2zTbkrJONbfcYSPAFU58Sl2ShKU2N6FRJ2EXZEk0ADAMR5UObl+
 pyeozQwICK9Ms3GJGtn5kfXwwLMiI52CxADDVgvVslde02Dv+TVoNISbHYegxD39hxMK
 2mTBXpT6kLRNWKZcdXiJ4RTDRkoXea0gb+0mrH+z6mHl2omL//wtSpKYUi9nIhQqtb/X
 oWTbZ74+lLwv6m+HziWcCSwdbC2kycWxFLyAxJLw2b8rXQsq2kqKgJGhkNUmdhJGm3Pp Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyqnsax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:18:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0EZkq156418;
        Fri, 24 Jan 2020 00:16:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xqnrs0akb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:16:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0GrMD030562;
        Fri, 24 Jan 2020 00:16:53 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:16:52 -0800
Subject: [PATCH 3/8] man: reformat xfs_quota commands in the manpage for
 testing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:16:50 -0800
Message-ID: <157982501072.2765410.10319214860660759283.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reformat the xfs_quota commands listed in the xfs_quota.8 manpage so
that we can implement a fstest that checks that each command actually
has a section in the manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_quota.8 |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)


diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index d9c5f649..e6fe7cd1 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -228,8 +228,7 @@ option sends the output to
 .I file
 instead of stdout.
 .HP
-.B
-free
+.B free
 [
 .B \-bir
 ] [
@@ -398,8 +397,7 @@ option reports information without the header line. The
 .B \-t
 option performs a terse report.
 .HP
-.B
-state
+.B state
 [
 .B \-gpu
 ] [
@@ -420,8 +418,7 @@ instead of stdout. The
 .B \-a
 option reports state on all filesystems and not just the current path.
 .HP
-.B
-limit
+.B limit
 [
 .BR \-g " | " \-p " | " \-u
 ]
@@ -519,8 +516,7 @@ identified by the current path.
 Quota must not be enabled on the filesystem, else this operation will
 report an error.
 .HP
-.B
-dump
+.B dump
 [
 .BR \-g " | " \-p " | " \-u
 ] [
@@ -547,8 +543,7 @@ The file must be in the format produced by the
 .B dump
 command.
 .HP
-.B
-quot
+.B quot
 [
 .BR \-g " | " \-p " | " \-u
 ] [

