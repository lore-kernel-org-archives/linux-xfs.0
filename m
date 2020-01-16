Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB210C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9195A2081E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:11:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NKVIqWgh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAPFLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:11:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAPFLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:11:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59A3G170199;
        Thu, 16 Jan 2020 05:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kcNU8w5IkR57m7sytjdxTjauP66DhWVeXLbvEV1iWQo=;
 b=NKVIqWghyS/27skzL7m/RtyqtojAUgBxkl401jGIV0h8oFIBPu0H/KZak1N4UUzcj5PQ
 cjrS6II3lywg+NkPxhmkJYPDgemKs0dna+AP3VcJKXVx6/SqSkY+HXX7pUC+X3T3CmvA
 4OQgQgi5KYlkeKrDuMdMr1K053muts6crYe0uTRnXFkiDHqDOtPElVblXf++rHGl4oJ2
 90+kdVEl56Zh44WGMUDXA3aMhlSPBznCHNaqNRcfeHzXt5OvHsYrLYJrLgw6ZeZiSGQs
 9Qa6oi6WAzpIh7vsUFN3N606tcUYg5UjkdOkJ1OavLdjUgb8Fxx5YVeEPOV7r89xdcp/ Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yr7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G58Mub185637;
        Thu, 16 Jan 2020 05:11:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1at7ryc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5Bbju001043;
        Thu, 16 Jan 2020 05:11:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:37 -0800
Subject: [PATCH 1/2] xfs: refactor calls to xfs_admin
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:36 -0800
Message-ID: <157915149642.2375135.15091840835027007949.stgit@magnolia>
In-Reply-To: <157915149017.2375135.14166864164575311878.stgit@magnolia>
References: <157915149017.2375135.14166864164575311878.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper to run xfs_admin on the scratch device, then refactor
all tests to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config |    1 +
 common/xfs    |    8 ++++++++
 tests/xfs/287 |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/common/config b/common/config
index 9a9c7760..1116cb99 100644
--- a/common/config
+++ b/common/config
@@ -154,6 +154,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
 export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
 export XFS_REPAIR_PROG="$(type -P xfs_repair)"
 export XFS_DB_PROG="$(type -P xfs_db)"
+export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
 export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
diff --git a/common/xfs b/common/xfs
index 706ddf85..d9a9784f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -218,6 +218,14 @@ _scratch_xfs_db()
 	$XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
 }
 
+_scratch_xfs_admin()
+{
+	local options=("$SCRATCH_DEV")
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		options+=("$SCRATCH_LOGDEV")
+	$XFS_ADMIN_PROG "$@" "${options[@]}"
+}
+
 _scratch_xfs_logprint()
 {
 	SCRATCH_OPTIONS=""
diff --git a/tests/xfs/287 b/tests/xfs/287
index 8dc754a5..f77ed2f1 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -70,7 +70,7 @@ $XFS_IO_PROG -r -c "lsproj" $dir/32bit
 _scratch_unmount
 
 # Now, enable projid32bit support by xfs_admin
-xfs_admin -p $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_admin failed"
+_scratch_xfs_admin -p >> $seqres.full 2>&1 || _fail "xfs_admin failed"
 
 # Now mount the fs, 32bit project quotas shall be supported, now
 _qmount_option "pquota"

