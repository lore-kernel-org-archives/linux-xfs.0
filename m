Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D16C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 07:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF3320748
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 07:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGXHWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 03:22:07 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56054 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726543AbgGXHWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 03:22:06 -0400
X-IronPort-AV: E=Sophos;i="5.75,389,1589212800"; 
   d="scan'208";a="96847193"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Jul 2020 15:22:03 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 66BBB4CE4BD0;
        Fri, 24 Jul 2020 15:22:01 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 15:22:02 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 24 Jul 2020 15:22:02 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <sandeen@sandeen.net>, <darrick.wong@oracle.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] xfs_io: Remove redundant setting/check for lsattr/stat command
Date:   Fri, 24 Jul 2020 15:14:40 +0800
Message-ID: <20200724071440.23239-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 66BBB4CE4BD0.AAECB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

lsattr/stat command can check exclusive options by argmax = 1
so the related setting/check is redundant.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 io/attr.c | 2 --
 io/stat.c | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index 181ff089..fd82a2e7 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -198,10 +198,8 @@ lsattr_f(
 			break;
 		case 'a':
 			aflag = 1;
-			vflag = 0;
 			break;
 		case 'v':
-			aflag = 0;
 			vflag = 1;
 			break;
 		default:
diff --git a/io/stat.c b/io/stat.c
index 5f513e0d..49c4c27c 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -142,11 +142,6 @@ stat_f(
 		}
 	}
 
-	if (raw && verbose) {
-		exitcode = 1;
-		return command_usage(&stat_cmd);
-	}
-
 	if (fstat(file->fd, &st) < 0) {
 		perror("fstat");
 		exitcode = 1;
-- 
2.21.0



