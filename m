Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2733C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940B721D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WiWrjn2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829270AbgJ0TDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:03:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56900 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:03:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItCDi021959;
        Tue, 27 Oct 2020 19:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=B3qEeDKmVr51/Bd/pfeSVgNTeOSAfwZxTiAY/OSV6Xc=;
 b=WiWrjn2x9CBUK2BizzcvQU2uOSgETmfZZq3vRnOkVH5TPSaBzD5XBg8tnOXxdfsy1Kd3
 qeepmf4hR9E7weo5osxdYRWaOLzBiCvZyAAByCV2rtAZ7hDA/CXOyRnnYMn/vDyAtEMe
 uB6/ym2kWurN7oIeC4D88vau5drZinqqr5ovVEjEM9lM4RWhQw1QpncesVA2v2VaiS8E
 81COnCqfZ4tumhpxiXTk1xe47OXPxV3zbhhhaPb5UDKA5oDsdEQT+qatDz1BLzlyCxTg
 iefnsxJ69eNG3LzD6ffUuLAaDpMLWTJsLRJDaiB6TZ/MFaRp1TbINcfRN8NUyyf7cjsO jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sav0bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsRo3076905;
        Tue, 27 Oct 2020 19:01:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwumrhcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:01:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ1b5I022896;
        Tue, 27 Oct 2020 19:01:37 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:01:36 -0700
Subject: [PATCH 1/9] common: extract rt extent size for _get_file_block_size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:01:35 -0700
Message-ID: <160382529579.1202316.931742119756545034.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

_get_file_block_size is intended to return the size (in bytes) of the
fundamental allocation unit for a file.  This is required for remapping
operations like fallocate and reflink, which can only operate on
allocation units.  Since the XFS realtime volume can be configure for
allocation units larger than 1 fs block, we need to factor that in here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc  |   13 ++++++++++---
 common/xfs |   20 ++++++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 27a27ea3..41f93047 100644
--- a/common/rc
+++ b/common/rc
@@ -3974,11 +3974,18 @@ _get_file_block_size()
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

