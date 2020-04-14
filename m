Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4F3C2BA19
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C26C206D5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 15:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M//Qx2Mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440832AbgDNPoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:44:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgDNPoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Apr 2020 11:44:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03EFeAgS035858;
        Tue, 14 Apr 2020 15:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lIdEqhqSZBVvN9jT0prqQ4DgyHxgeEqcNTcvLSd9m3k=;
 b=M//Qx2Mq7zdUvQrKRD1mrdnccH32MliNkd1N1NVBwfaFZNgcEdZvueZU8kS5MlO8dqVk
 5n0v324uvgjrHNlcEFG7PZ0LsU/1RmyrWBSR/9OOtJZd0TypFYHf7Z22GPLksF0G48fb
 DKZVjSAYLVVZPpApQMQS8T3F/CBWWXydpvPuaVNDMU7LKm6tGLqt5mvKO6Ab4fd0pg4Q
 rSvI+aclYf1enyyyORcQmJF+HLOZ+7VLa0nbsU4G1OOmAwA+SMI2dIdZkqQOGcQ3NJ0i
 5yzkqxcluGh5IIwsKJHqCEhu9jt1wjd3yjdx2p7KoMPGmmLTMsvxZ7Hv7NjoXNAjQLC4 Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30b5um5m1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 15:44:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03EFbFYt178307;
        Tue, 14 Apr 2020 15:44:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30ctaagjbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 15:44:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03EFi0d9014888;
        Tue, 14 Apr 2020 15:44:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 08:44:00 -0700
Date:   Tue, 14 Apr 2020 08:43:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub: don't set WorkingDirectory= in systemd job
Message-ID: <20200414154359.GE6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=9
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=945
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=9 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Somewhere between systemd 237 and 245, they changed the order in which a
job has its uid/gid set; capabilities applied; and working directory
set.  Whereas before they did it in an order such that you could set the
working directory to a path inaccessible to 'nobody' (either because
they did it before changing the uid or after adding capabilities), now
they don't and users instead get a service failure:

xfs_scrub@-boot.service: Changing to the requested working directory failed: Permission denied
xfs_scrub@-boot.service: Failed at step CHDIR spawning /usr/sbin/xfs_scrub: Permission denied
xfs_scrub@-boot.service: Main process exited, code=exited, status=200/CHDIR

Regardless, xfs_scrub works just fine with PWD set to /, so remove that
directive.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub@.service.in |    1 -
 1 file changed, 1 deletion(-)

diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 56acea67..6fb3f6ea 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -5,7 +5,6 @@ Documentation=man:xfs_scrub(8)
 
 [Service]
 Type=oneshot
-WorkingDirectory=%I
 PrivateNetwork=true
 ProtectSystem=full
 ProtectHome=read-only
