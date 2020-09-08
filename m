Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A04C43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 14:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6777322525
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 14:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgIHOyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 10:54:07 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47426 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728975AbgIHOYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 10:24:52 -0400
X-IronPort-AV: E=Sophos;i="5.76,405,1592841600"; 
   d="scan'208";a="99008939"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Sep 2020 21:23:42 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 6A72D48990E5;
        Tue,  8 Sep 2020 21:23:41 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 8 Sep 2020 21:23:40 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 8 Sep 2020 21:23:35 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <fstests@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <david@fromorbit.com>,
        <ira.weiny@intel.com>, <linux-xfs@vger.kernel.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH 1/2] common/rc: Check 'tPnE' flags on a directory instead of a regilar file
Date:   Tue, 8 Sep 2020 21:15:22 +0800
Message-ID: <20200908131523.20899-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 6A72D48990E5.AA09C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'tPnE' flags are only valid for a directory so check them on a directory.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 common/rc | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index aa5a7409..cf31eebc 100644
--- a/common/rc
+++ b/common/rc
@@ -2168,8 +2168,14 @@ _require_xfs_io_command()
 		fi
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
-		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
-		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
+		# 'tPnE' flags are only valid for a directory so check them on a directory.
+		if echo "$param" | egrep -q 't|P|n|E'; then
+			testio=`$XFS_IO_PROG -F -c "chattr +$param" $TEST_DIR 2>&1`
+			$XFS_IO_PROG -F -r -c "chattr -$param" $TEST_DIR 2>&1
+		else
+			testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
+			$XFS_IO_PROG -F -r -c "chattr -$param" $testfile 2>&1
+		fi
 		param_checked="+$param"
 		;;
 	"chproj")
-- 
2.21.0



