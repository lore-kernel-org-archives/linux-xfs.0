Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBB1C55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA09A21556
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iV8HXAfc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829283AbgJ0TEN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:04:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1822827AbgJ0TEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:04:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIt3Yj108039;
        Tue, 27 Oct 2020 19:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sj+qu+vI2/5m699ZBpH0ronawW0mrEB0FVs91jkGSck=;
 b=iV8HXAfc4P6mzQs3354Vr4ThfKlFE40v5/Aehuho6r4C0C/i0WLCj4pUkTCTxF19S/+l
 xHeYOUnlmBQj+f36BdOmFUWkm+h7KOwZ3khhkqQY0grTteT7xuO7Zhmq571uuf9h83+E
 8iGh8puESrIW4nQDJ79Eq0MpMgtIbQBmTl1zaMCadx3Q4jOyzs/q1drXNsVvWXJiJguu
 vGapDBV+44bGF8DZNTLbS21B78gVH6tXjLaprjoAvCCWwDJBS9T/Rzhn9MskOcuPh9+c
 LsUB6zXv2XLxtnW4EzGm+B04nqYsktyF5SDyEz2fPIzZc9vwyzgCYSiUtP89gkFlS/mG Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kuv06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:04:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIuMkD091061;
        Tue, 27 Oct 2020 19:04:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1r3way-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:04:10 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ49A3028450;
        Tue, 27 Oct 2020 19:04:09 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:04:08 -0700
Subject: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:04:07 -0700
Message-ID: <160382544732.1203848.9001133589345314135.stgit@magnolia>
In-Reply-To: <160382543472.1203848.8335854864075548402.stgit@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add these new ondisk structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |    1 +
 tests/xfs/122.out |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index a4248031..db21f2d5 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -182,6 +182,7 @@ struct xfs_iext_cursor
 struct xfs_ino_geometry
 struct xfs_attrlist
 struct xfs_attrlist_ent
+struct xfs_legacy_ictimestamp
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index b0773756..f229465a 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -97,6 +97,7 @@ sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
 sizeof(struct xfs_inumbers) = 24
 sizeof(struct xfs_inumbers_req) = 64
+sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

