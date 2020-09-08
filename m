Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80136C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 14:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531312065E
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 14:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgIHOqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 10:46:00 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2468 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729785AbgIHO0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 10:26:09 -0400
X-IronPort-AV: E=Sophos;i="5.76,405,1592841600"; 
   d="scan'208";a="99008941"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Sep 2020 21:23:48 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 3538948990E5;
        Tue,  8 Sep 2020 21:23:47 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 8 Sep 2020 21:23:46 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 8 Sep 2020 21:23:42 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <fstests@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <david@fromorbit.com>,
        <ira.weiny@intel.com>, <linux-xfs@vger.kernel.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH 2/2] common/rc: Add extra check for xfs_io -c "chattr" on XFS
Date:   Tue, 8 Sep 2020 21:15:23 +0800
Message-ID: <20200908131523.20899-2-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200908131523.20899-1-yangx.jy@cn.fujitsu.com>
References: <20200908131523.20899-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 3538948990E5.A9CDD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On XFS, ioctl(FSSETXATTR)(called by xfs_io -c "chattr") maskes off unsupported
or invalid flags silently.  For example,
1) With kernel v4.4 which doesn't support dax flag, try to set dax flag on a
file by the lastest xfs_io -c "chattr" command:
--------------------------------------------
# xfs_io -f -c "chattr +x" testfile;echo $?
0
# xfs_io -c "lsattr" testfile
----------------X testfile
--------------------------------------------
2) Realtime inheritance flag is only valid for a directory and try to set
realtime inheritance flag on a file:
--------------------------------------------
# xfs_io -f -c "chattr +t" testfile;echo $?
0
# xfs_io -c "lsattr" testfile
----------------X testfile
--------------------------------------------

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 common/rc | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/common/rc b/common/rc
index cf31eebc..e40f0a8a 100644
--- a/common/rc
+++ b/common/rc
@@ -2158,6 +2158,7 @@ _require_xfs_io_command()
 	local param="$*"
 	local param_checked=""
 	local opts=""
+	local attr_info=""
 
 	local testfile=$TEST_DIR/$$.xfs_io
 	local testio
@@ -2171,9 +2172,11 @@ _require_xfs_io_command()
 		# 'tPnE' flags are only valid for a directory so check them on a directory.
 		if echo "$param" | egrep -q 't|P|n|E'; then
 			testio=`$XFS_IO_PROG -F -c "chattr +$param" $TEST_DIR 2>&1`
+			attr_info=`$XFS_IO_PROG -F -r -c "lsattr" $TEST_DIR | awk '{print $1}'`
 			$XFS_IO_PROG -F -r -c "chattr -$param" $TEST_DIR 2>&1
 		else
 			testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
+			attr_info=`$XFS_IO_PROG -F -r -c "lsattr" $testfile | awk '{print $1}'`
 			$XFS_IO_PROG -F -r -c "chattr -$param" $testfile 2>&1
 		fi
 		param_checked="+$param"
@@ -2297,6 +2300,19 @@ _require_xfs_io_command()
 		echo $testio | grep -q "\(invalid option\|not supported\)" && \
 			_notrun "xfs_io $command doesn't support $param"
 	fi
+
+	# On XFS, ioctl(FSSETXATTR)(called by xfs_io -c "chattr") maskes off unsupported
+	# or invalid flags silently so need to check these flags by extra ioctl(FSGETXATTR)
+	# (called by xfs_io -c "lsattr").
+	# The following URL explains why we don't change the behavior of XFS.
+	# https://www.spinics.net/lists/linux-xfs/msg44725.html
+	if [ -n "$attr_info" -a "$FSTYP" = "xfs" ]; then
+		local num=${#param}
+		for i in $(seq 0 $((num-1))); do
+			echo $attr_info | grep -q "${param:$i:1}" || \
+				_notrun "xfs_io $command +${param:$i:1} support is missing (unknown flag in kernel)"
+		done
+	fi
 }
 
 # check that kernel and filesystem support direct I/O
-- 
2.21.0



