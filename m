Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFE5C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331272469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XspdrLRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1XkX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgB1XkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWpP0027989;
        Fri, 28 Feb 2020 23:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8Ifs+gX7YQCBlTZnrgUaHCy+V0rHwYuWoRhKCPoi5eU=;
 b=XspdrLRd45utsDGAAGN43UJGpmAV/R+NmF9e3r89QEB03R15ZQf7YgUTWFq5XgDuJ211
 JlD0VSYx9ixLtuzDz6IDbdogIdEH5lyJM/zZKACxqtIh/N1eBjLAqdQY+Uq9WTgMDTYX
 uz5Ljy7He/RVsVSRMVDW6kfizSuixTvbTtaebKLTsvRDxMqUDo0doZhtQxp166yOp9GJ
 hUrAIR3HlpDuKx4vO+aUpSZAFcNeQD0kEELveUBn/MRwI6MnW9qZZmcf9rm4qwG332Xo
 ClPKpIttVup0syn5bdC51XVyYPPHVFoAytY2HorE4qFxC22Ngj87N9lVwcRyYKgCgB43 Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3nt51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWkQo156418;
        Fri, 28 Feb 2020 23:36:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsgb3wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNaDHg012444;
        Fri, 28 Feb 2020 23:36:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:12 -0800
Subject: [PATCH 7/7] libfrog: always fsync when flushing a device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:36:11 -0800
Message-ID: <158293297145.1548526.12740789073744748201.stgit@magnolia>
In-Reply-To: <158293292760.1548526.16432706349096704475.stgit@magnolia>
References: <158293292760.1548526.16432706349096704475.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=996 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always call fsync() when we're flushing a device, even if it is a block
device.  It's probably redundant to call fsync /and/ BLKFLSBUF, but the
latter has odd behavior so we want to make sure the standard flush
methods have a chance to run first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/linux.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/libfrog/linux.c b/libfrog/linux.c
index 60bc1dc4..40a839d1 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -155,14 +155,18 @@ platform_flush_device(
 	if (major(device) == RAMDISK_MAJOR)
 		return 0;
 
+	ret = fsync(fd);
+	if (ret)
+		return ret;
+
 	ret = fstat(fd, &st);
 	if (ret)
 		return ret;
 
-	if (S_ISREG(st.st_mode))
-		return fsync(fd);
+	if (S_ISBLK(st.st_mode))
+		return ioctl(fd, BLKFLSBUF, 0);
 
-	return ioctl(fd, BLKFLSBUF, 0);
+	return 0;
 }
 
 void

