Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FECC3F2C6
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E7F20866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VEKNJbAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCDCqq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:46:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgCDCqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 21:46:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242iBFi180818;
        Wed, 4 Mar 2020 02:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kcNU8w5IkR57m7sytjdxTjauP66DhWVeXLbvEV1iWQo=;
 b=VEKNJbAPJOW5clsUTP9Qj8/IV7lI/v39C34n+MH6EeExfWa6DtZqBPRLq1JO/QyhY6k2
 BlLL5rib0OGDE6m1PRmAs9zP+2tpxMTV6qTognzfOMyB3Z4Brs/7baCQxFo5jUQw4B62
 E15Gg36jwIjnRu6Rly8eV4Gi5W8rjkoHVJATdfj6jJnCuJxWDw4UFHtkuytMIxcq6sYz
 CAfEEC3EC7dXIUs8BFPI5lTs43u/abC4o/OePXhJ6TCgmrS+GwSm+xjusdv4dhiwU3jM
 vnQbAF6tDKWUy506Q9iF6T+ZfwtwOPNM6V3P7K7mjtV1EWvlVGrAQ523QQ4hrx8Fu2Gy Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwqud0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242ifed104810;
        Wed, 4 Mar 2020 02:46:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yg1p63s3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0242kg73006524;
        Wed, 4 Mar 2020 02:46:42 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 18:46:41 -0800
Subject: [PATCH 2/3] xfs: refactor calls to xfs_admin
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 03 Mar 2020 18:46:40 -0800
Message-ID: <158329000059.2374922.2321079684090223330.stgit@magnolia>
In-Reply-To: <158328998787.2374922.4223951558305234252.stgit@magnolia>
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040019
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

