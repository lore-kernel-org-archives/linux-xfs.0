Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B3BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 07:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiDUH5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 03:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386263AbiDUH5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 03:57:09 -0400
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D4711172
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1650527658; i=@fujitsu.com;
        bh=FzOoyU0WSsAZMA3qblvHkl4ebvhORug8fwmWIBRv/ws=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=UfosvHbDQtyrH5fxRNJ/SI0OeWXvw6KkkRKIz1DwKBezq45pl42Zu3tBy0/NJNjqA
         3d+kbsNh9YZ4jDNSG66x0Oh30L8ONPjDE9NFMoTuGQytf3P8foJttL1lDLC/zxH7HS
         W9Fs8DBr8PdnV0I3TWZKGU7XDsU9KIlhXarNw+OKmF0FCJ6/vqWyMFYODmXd24wh96
         /TrovO8mUUT4OYHVvTQchG9UJxfbfU8J7Lad2+U/v/h/l26EmqnGEx+wWk59kfcy63
         NMcGXPoS5RBtp7tJ1geOYJOdp09YqAB68LPO4hsfVMQzAm6o+4oj+qjNsFiTzbYkhm
         Wa3b9A9jLkDSw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRWlGSWpSXmKPExsViZ8ORqLuKNzH
  J4N5EaYvXhz8xWlx+wmex688Odgdmj02rOtk8Pm+SC2CKYs3MS8qvSGDNeHsnqGA1T8Wu5hXs
  DYwHuboYuTiEBLYwSpx4e4Gli5ETyFnAJHH0vwVEYg+jxMO5X9lAEmwCmhLPOhcwg9giAvIS/
  Y3fGEFsZoFgiSU9v4HiHBzCAtoSvUdzQcIsAqoSq5qmgM3kFfCQeLqvDcyWEFCQmPLwPTNEXF
  Di5MwnLBBjJCQOvnjBDFGjKHGpA2K8hECFxKxZbUwQtprE1XObmCcw8s9C0j4LSfsCRqZVjFZ
  JRZnpGSW5iZk5uoYGBrqGhqa6ZrqGZpZ6iVW6iXqppbrlqcUluoZ6ieXFeqnFxXrFlbnJOSl6
  eaklmxiBoZpSzLZyB+PKvp96hxglOZiURHkv/kpIEuJLyk+pzEgszogvKs1JLT7EKMPBoSTBy
  8idmCQkWJSanlqRlpkDjBuYtAQHj5IIrxYnUJq3uCAxtzgzHSJ1ilGXY23Dgb3MQix5+XmpUu
  K8U3iAigRAijJK8+BGwGL4EqOslDAvIwMDgxBPQWpRbmYJqvwrRnEORiVh3gyQKTyZeSVwm14
  BHcEEdET1lFiQI0oSEVJSDUx5yVMPHnCe/rHwv5O76D32ICGpI+dszMoVvNXKlJYKbHD2T7wT
  VC2YPXVSmqbI93M/85e+UDu894NmnlPo9YKvlhzi+lO5Zj9SybRc9SIrkv1LBbfkzBV8G1dzy
  35kMVSWW6TxcN3nOVLShvx6vEYf+R9wsvRbiKbc++e1flXy7/LQsL8Kk1e6u/S03b0UcybkPE
  fMVB/dH/XTpXWvua8vF7jCfZf/R/8Gey3xmOUK1q8zQ4snz9G9N6vlVtHSfA/dndv46zYa9ah
  MSvfbtfnkte443y/7Pm45pWWXey4/r/zpwd9WIq/vrg/99r4+eOXBreXnJecqTS6qO59kuGrK
  1rLQ+Cqz5AUcN++8fqvEUpyRaKjFXFScCAC0v1m1XAMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-3.tower-587.messagelabs.com!1650527658!17214!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.85.8; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6012 invoked from network); 21 Apr 2022 07:54:18 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-3.tower-587.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 21 Apr 2022 07:54:18 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id EEC011001A2;
        Thu, 21 Apr 2022 08:54:17 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id D5E6110019B;
        Thu, 21 Apr 2022 08:54:17 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 21 Apr 2022 08:54:12 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <djwong@kernel.org>, <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH] xfs: improve __xfs_set_acl
Date:   Thu, 21 Apr 2022 16:54:50 +0800
Message-ID: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Provide a proper stub for the !CONFIG_XFS_POSIX_ACL case.

Also use a easy way for xfs_get_acl stub.

Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/xfs_acl.h  | 8 +++++---
 fs/xfs/xfs_iops.c | 2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index bb6abdcb265d..263404d0bfda 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -16,11 +16,13 @@ extern int xfs_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 void xfs_forget_acl(struct inode *inode, const char *name);
 #else
-static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type, bool rcu)
+#define xfs_get_acl NULL
+#define xfs_set_acl NULL
+static inline int __xfs_set_acl(struct inode *inode, struct posix_acl *acl,
+				int type)
 {
-	return NULL;
+	return 0;
 }
-# define xfs_set_acl					NULL
 static inline void xfs_forget_acl(struct inode *inode, const char *name)
 {
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b34e8e4344a8..94313b7e9991 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -209,7 +209,6 @@ xfs_generic_create(
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
-#ifdef CONFIG_XFS_POSIX_ACL
 	if (default_acl) {
 		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		if (error)
@@ -220,7 +219,6 @@ xfs_generic_create(
 		if (error)
 			goto out_cleanup_inode;
 	}
-#endif
 
 	xfs_setup_iops(ip);
 
-- 
2.27.0

