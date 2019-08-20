Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF2AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E6E2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ezeBlgxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbfHTUbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbfHTUbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT8pE180653;
        Tue, 20 Aug 2019 20:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+9WDTLV+gac7m4St+PU/rBrD+ojEklTwhN7Ik+ZgRs4=;
 b=ezeBlgxELkY5Sv2afQpaokUcASZ6Yr49kPhDgKEKMW8WJfsjEwUBJWwGbnezV8FNuvmd
 UqUFykNaIu8OT4V8CNnWP9bsYGjMkpGeyes41ERtt63ekPGvWeWkuVwlI59OvDgfK8hJ
 jVw7C+edjUO8NXfS6o7vCdF9MiC6zc/K5s+o6VYiDk1RYhG1e8UCPFE3HBxYRivlLv9q
 S9rZKjVafIVBHiaIhDkR30M0w/AT4NO9oFb8yDco95CGNBgihAXNlNMCv14o/xHu2Vx3
 /pFiyMEnoWWxoT11z6KrjfsSxq7eXwBodwIYhOOFUq+BbbtfaMvZvGOllMZ1L6iaihJX Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hph0mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTBvC071243;
        Tue, 20 Aug 2019 20:31:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ugj7pners-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKVVfY028308;
        Tue, 20 Aug 2019 20:31:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:30 -0700
Subject: [PATCH 03/12] libfrog: try the v4 fs geometry ioctl after failing
 the v5 ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:30 -0700
Message-ID: <156633309007.1215978.12240756059931527276.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=941
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a v5 fs geometry query fails, try the v4 interface before falling
back to the v1 interface.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index a3b748f8..06e4e663 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -84,6 +84,10 @@ xfrog_geometry(
 	if (!ret)
 		return 0;
 
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V4, fsgeo);
+	if (!ret)
+		return 0;
+
 	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
 }
 

