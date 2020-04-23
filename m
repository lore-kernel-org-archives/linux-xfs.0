Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A38C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E172087E
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yU4AHFKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgDWXbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:31:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWXbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:31:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSi09110781;
        Thu, 23 Apr 2020 23:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RkWAWftHwPyILJRfbB5y32PffGbc+ts+Pv3Lqrrujjw=;
 b=yU4AHFKju18k9z0QX1JQsRfbRqsFN9+uymG6M2Ws/0uMe6s8HV2Rs4ZbCrwl0NBLiu2Q
 VZm5VFJEEA5JDOQPfOAEV7W+6yHxBTOgy1Wz7UjVzUtVOGvXheb2NGQX/7irJEzC5jbb
 y91/NBSFzVD0SodZ5R8EwVX0yk1x7f/iGLnMy4VtDTMnEvNjgnXWcFmjzl1GATGY/+5m
 isjDCccz37SQlQMre/aJIcbyVNXMETCLCRkvJeNtJWM+OojcRAD6s7o4GQl6l/5XEu40
 fxI1yWTSYilzgx/b4IAtgvLMPapcFiu1TcLZGMdbT5o5RZs6NMYUJdbJ23qXBD890XJa SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30jvq4xbq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNRa1r160134;
        Thu, 23 Apr 2020 23:31:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30k7qw2c74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:46 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNVj5o003277;
        Thu, 23 Apr 2020 23:31:45 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:45 -0700
Subject: [PATCH 5/5] xfs/122: fix for linux 5.7 stuff
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:42 -0700
Message-ID: <158768470283.3019327.12107082366634108750.stgit@magnolia>
In-Reply-To: <158768467175.3019327.8681440148230401150.stgit@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some regressions on xfsprogs 5.7.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |    2 ++
 tests/xfs/122.out |    1 +
 2 files changed, 3 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 64b63cb1..dbf3a22b 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -181,6 +181,8 @@ xfs_fsop_getparents_handlereq_t
 xfs_dinode_core_t
 struct xfs_iext_cursor
 struct xfs_ino_geometry
+struct xfs_attrlist
+struct xfs_attrlist_ent
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 91a3bdae..45c42e59 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -58,6 +58,7 @@ offsetof(xfs_sb_t, sb_width) = 188
 sizeof(struct xfs_acl) = 4
 sizeof(struct xfs_acl_entry) = 12
 sizeof(struct xfs_ag_geometry) = 128
+sizeof(struct xfs_agfl) = 36
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56

