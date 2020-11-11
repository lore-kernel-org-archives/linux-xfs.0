Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7BAC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295EF21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pziv/WKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgKKAnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKAnQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZFbG016794;
        Wed, 11 Nov 2020 00:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LlQIkWrl4lGTHdvVLFEfeOVtlqYiQ7ENoW54OAsj6LA=;
 b=pziv/WKbQi+VLgISfmC2E7BVWH7JwckPM2NWO5wUEEFTjkyC+jXOAD5nZwQZcvRHjxj+
 RNx5sFmQzZrSha/8ICbuDDlZVg/56Kvk0KRR6ttdawD4f/iAGn2yQf2fpmq2rUKYQ9k6
 dYhxN2d8u4gvOiszk00qhtIo7CNEzACF7F4rd+xE8DD5X+CcXbxnzoPAHmCvBwFhWtIh
 KOTrSYTU9rLwszw4PMmSTYxRW/djDsS5u4ZqtaCqRc/yAaIAOs9MQiiqyfrbDc/Cm06A
 0VBoWdjpUcbHe9IeA5XaCTeXP0fu5UFil7mqBHUkFxVSTOGcoFbG7eMhduBw8dFAz0be 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72emv3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VDZC095304;
        Wed, 11 Nov 2020 00:43:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55patg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:13 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0hCnK013514;
        Wed, 11 Nov 2020 00:43:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:00 -0800
Subject: [PATCH 1/6] common: extract rt extent size for _get_file_block_size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:42:59 -0800
Message-ID: <160505537946.1388647.16793832491247950385.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

_get_file_block_size is intended to return the size (in bytes) of the
fundamental allocation unit for a file.  This is required for remapping
operations like fallocate and reflink, which can only operate on
allocation units.  Since the XFS realtime volume can be configure for
allocation units larger than 1 fs block, we need to factor that in here.

Note that ext* with bigalloc does not allocations to be aligned to the
cluster size, so no update is needed there.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc  |   13 ++++++++++---
 common/xfs |   20 ++++++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 65ebfe20..019b9b2b 100644
--- a/common/rc
+++ b/common/rc
@@ -3975,11 +3975,18 @@ _get_file_block_size()
 		echo "Missing mount point argument for _get_file_block_size"
 		exit 1
 	fi
-	if [ "$FSTYP" = "ocfs2" ]; then
+
+	case "$FSTYP" in
+	"ocfs2")
 		stat -c '%o' $1
-	else
+		;;
+	"xfs")
+		_xfs_get_file_block_size $1
+		;;
+	*)
 		_get_block_size $1
-	fi
+		;;
+	esac
 }
 
 # Get the minimum block size of an fs.
diff --git a/common/xfs b/common/xfs
index 79dab058..3f5c14ba 100644
--- a/common/xfs
+++ b/common/xfs
@@ -174,6 +174,26 @@ _scratch_mkfs_xfs()
 	return $mkfs_status
 }
 
+# Get the size of an allocation unit of a file.  Normally this is just the
+# block size of the file, but for realtime files, this is the realtime extent
+# size.
+_xfs_get_file_block_size()
+{
+	local path="$1"
+
+	if ! ($XFS_IO_PROG -c "stat -v" "$path" 2>&1 | egrep -q '(rt-inherit|realtime)'); then
+		_get_block_size "$path"
+		return
+	fi
+
+	# Otherwise, call xfs_info until we find a mount point or the root.
+	path="$(readlink -m "$path")"
+	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
+		path="$(dirname "$path")"
+	done
+	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
+}
+
 # xfs_check script is planned to be deprecated. But, we want to
 # be able to invoke "xfs_check" behavior in xfstests in order to
 # maintain the current verification levels.

