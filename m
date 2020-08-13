Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9530C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B17E02078B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rcT54rZ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHMX1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:27:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMX1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 19:27:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNIPU0116498;
        Thu, 13 Aug 2020 23:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bZ2mqNu6l++TYaw/MeX8Qaa1I0RAhiRHtOYNLj2Gw3o=;
 b=rcT54rZ7o1GKBhBDLNBQohIIkC4rn3rmqPnnNC3pIj7ngrQ59epBgz6itgmjUMy8Ibq8
 1JrMhuXKSmDlvGycQsWxyBG2aWF4dkvSslo+HddtZfX8K70LhktrAMr0DWl9sJohd85Y
 jIN6u+431B5EceTXOTBtdK/v6PQPWipkk80ONfrODREr2JYsGVfBVdyzhbA2mbjqQOuP
 sm4scogVC7PlErycZhDczE3N8/xo1jOPAZJhqPhEZgoVj5KFHtUkLMUrI8xz+F1RIU7e
 L4SEuaOERWpry3sIOFsNg+oALfod6XgZG3rreTAWWMQBNCA8LjT+dTMznK0VQXTuAIa6 fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32t2ye1vdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 23:27:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNDgka074354;
        Thu, 13 Aug 2020 23:27:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32t5msdgmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 23:27:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07DNRcx1027063;
        Thu, 13 Aug 2020 23:27:38 GMT
Received: from localhost (/10.159.233.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 23:27:35 +0000
Subject: [PATCH 3/4] man: update mkfs.xfs inode flag option documentation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 13 Aug 2020 16:27:35 -0700
Message-ID: <159736125533.3063459.18063990185908155478.stgit@magnolia>
In-Reply-To: <159736123670.3063459.13610109048148937841.stgit@magnolia>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The mkfs manpage says that the extent size, cow extent size, realtime,
and project id inheritance bits are passed on to "newly created
children".  This isn't technically true -- it's only passed on to newly
created regular files and directories.  It is not passed on to special
files.

Fix this minor inaccuracy in the documentation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9d762a43011a..7d3f3552ff12 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -285,7 +285,8 @@ Set the copy-on-write extent size hint on all inodes created by
 .BR mkfs.xfs "."
 The value must be provided in units of filesystem blocks.
 If the value is zero, the default value (currently 32 blocks) will be used.
-Directories will pass on this hint to newly created children.
+Directories will pass on this hint to newly created regular files and
+directories.
 .TP
 .BI name= value
 This can be used to specify the name of the special file containing
@@ -380,20 +381,23 @@ this information.
 If set, all inodes created by
 .B mkfs.xfs
 will be created with the realtime flag set.
-Directories will pass on this flag to newly created children.
+Directories will pass on this flag to newly created regular files and
+directories.
 .TP
 .BI projinherit= value
 All inodes created by
 .B mkfs.xfs
 will be assigned this project quota id.
-Directories will pass on the project id to newly created children.
+Directories will pass on the project id to newly created regular files and
+directories.
 .TP
 .BI extszinherit= value
 All inodes created by
 .B mkfs.xfs
 will have this extent size hint applied.
 The value must be provided in units of filesystem blocks.
-Directories will pass on this hint to newly created children.
+Directories will pass on this hint to newly created regular files and
+directories.
 .RE
 .TP
 .B \-f

