Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A649BC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A19122CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5brn7MT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfIDEhU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDEhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aWLQ040514;
        Wed, 4 Sep 2019 04:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aECdyCrdhmzMzNt2PJeBVAUnUM2FIBONN6usX+Yq0ro=;
 b=E5brn7MTfTWG5lpf5cYKrZIF7MbXz8BTiz4RqCttyCF65yRVLuBC+/WvK8mTSCLLM+p5
 2WPKbHE6PGK66Slyl48c8DPJuy+thJorxzGJrpaXwvX4jQWQtrCNyuTtOKrM2HNL+2/8
 slj1V8BWV8qRT1r4nTJSncr04xjiq5JWnfWoLlJ4PPN4O0Au9ABlMfATfVSWGZQG6uhG
 wA7rvmYoYJuGjJsIZze+X0XBE5jPOm2zzxEWkRKdHJBD4ecFD0oebmlTIgPtMeTi/gul
 bPpFh8aK1DRdNSWF1lOF01NcYrXryl+TaIvkrGGxWcBaIXKfLBbnIDgAFMDCa0vaUmxD pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ut6d1r037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFUc027391;
        Wed, 4 Sep 2019 04:37:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ut1hmtvkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844bGdu016173;
        Wed, 4 Sep 2019 04:37:16 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:16 -0700
Subject: [PATCH 02/10] man: document new fs summary counter scrub command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:37:15 -0700
Message-ID: <156757183522.1838441.14863203188193553450.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the scrub ioctl documentation to include the new fs summary
counter scrubber.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 1e80ee71..046e3e36 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -159,6 +159,11 @@ corruption.
 .TP
 .B XFS_SCRUB_TYPE_PQUOTA
 Examine all user, group, or project quota records for corruption.
+
+.TP
+.B XFS_SCRUB_TYPE_FSCOUNTERS
+Examine all filesystem summary counters (free blocks, inode count, free inode
+count) for errors.
 .RE
 
 .PD 1

