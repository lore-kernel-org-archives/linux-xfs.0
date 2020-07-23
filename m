Return-Path: <SRS0=I6cU=BC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5017C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 05:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB78820768
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 05:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgGWFet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 01:34:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60446 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725822AbgGWFet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 01:34:49 -0400
X-IronPort-AV: E=Sophos;i="5.75,385,1589212800"; 
   d="scan'208";a="96784071"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Jul 2020 13:34:47 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id C19484CE4BD9;
        Thu, 23 Jul 2020 13:34:42 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 23 Jul 2020 13:34:42 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 13:34:42 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <sandeen@sandeen.net>, <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] io/attr.c: Disallow specifying both -D and -R options for chattr command
Date:   Thu, 23 Jul 2020 13:27:23 +0800
Message-ID: <20200723052723.30063-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: C19484CE4BD9.AB980
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-D and -R options are mutually exclusive actually but chattr command
doesn't check it so that always applies -D option when both of them
are specified.  For example:
------------------------------------
# mkdir testdir
# mkdir testdir/tdir
# touch testdir/tfile
# xfs_io -c "chattr -D -R +s" testdir
# xfs_io -c "lsattr -R" testdir
----s----------- testdir/tdir
---------------- testdir/tfile
----s----------- testdir
------------------------------------

Add a check to disallow the combination.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 io/attr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io/attr.c b/io/attr.c
index 80e28514..f82a0881 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -320,6 +320,13 @@ chattr_f(
 		}
 	}
 
+	if (recurse_all && recurse_dir) {
+		fprintf(stderr, _("%s: -R and -D options are mutually exclusive\n"),
+			progname);
+		exitcode = 1;
+		return 0;
+	}
+
 	if (recurse_all || recurse_dir) {
 		nftw(name, chattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-- 
2.21.0



