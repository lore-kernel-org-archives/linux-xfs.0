Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEFEC3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1143E214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D5hkLDcI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgBEACi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42218 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBEACi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NvxsC095785;
        Wed, 5 Feb 2020 00:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kcNU8w5IkR57m7sytjdxTjauP66DhWVeXLbvEV1iWQo=;
 b=D5hkLDcIN+mUYqjrlMAwfMOjLB4RWg71So6E6DABNw3cKIR+hu56SlPTbwN4+0eVQnmv
 lT2MVAQ5xVyTyYqiZLtjdE1Jso85mzrVOe8H1jlX3txhV+xC+jJKA7p8vOASbf5SYjKf
 9sS+7DT0sOY2Qzf9zUVK8XXijMQb12h+9A+ISmiIb4UUHxdLfonD3aRhfeHWj5/9MIPi
 qZyGv525EA62E+jAbB9IafYPP5NToK67oORgBHG3LhB4oVPkxbTbpT+J6PB2R4tDjqdU
 PkbeHKiWA0ubfzMEOST+QjyaY+PSEwAdIv4L8rno5F6lZxnb1q2d6CA8oxmCeb2Cu9k1 oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xyhkfg8a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NxOL6037899;
        Wed, 5 Feb 2020 00:02:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xyhmqwbha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01502Y1W023368;
        Wed, 5 Feb 2020 00:02:34 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:34 -0800
Subject: [PATCH 1/2] xfs: refactor calls to xfs_admin
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:33 -0800
Message-ID: <158086095320.1990521.15734406558551927388.stgit@magnolia>
In-Reply-To: <158086094707.1990521.17646841467136148296.stgit@magnolia>
References: <158086094707.1990521.17646841467136148296.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
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

