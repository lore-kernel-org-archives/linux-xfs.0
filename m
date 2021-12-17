Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80D2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 02:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhLQCBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 21:01:45 -0500
Received: from mail1.bemta36.messagelabs.com ([85.158.142.113]:26166 "EHLO
        mail1.bemta36.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232386AbhLQCBp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 21:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1639706503; i=@fujitsu.com;
        bh=31g8bw5Ftd07IiS0hoOwHbq8lIXZfgmSMzTNA0Rou4Y=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=S4tkTzIJ3W+pXgwcGPzW0UNvucja6kWWq9a8BLClaExt6MZyTvGplxOgHb4T+qdX2
         WAfoRHKMbZOyLJrPMYCYNaSHgJEmKGsAn4gNx4e3N6JIl9fLGavK7Y/iyY6lmX0+nA
         xg+USxctB9aWDCURbPDNyGnL9TlSy5+W7HWsZ0x09VjvdX2vrPsm8/QZ8ubMvoaccU
         ReBPH425gsJmMggm9pQMefHBGZtzfZGWhyw2QZElXOqsTNc7jFCBtXS0uUsTQQiHXY
         W+ebgzug6Q9c/pS3yRV5O/oK306gwjKacCwEfu8NFcDRbqc2NGfQUdfufio7g3hvdO
         eRTSkr2r1I/og==
Received: from [100.115.68.153] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.ess.symcld.net id 46/2F-07141-78FEBB16; Fri, 17 Dec 2021 02:01:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRWlGSWpSXmKPExsViZ8MxSbf9/e5
  Egy9T2SwuP+Gz2PVnB7sDk8emVZ1sHp83yQUwRbFm5iXlVySwZqxryC7o5q14fu8uYwPjZ64u
  Ri4OIYEtjBKTNu9jhXAWMEk039/BBOHsYZTYtHcRexcjJwebgKbEs84FzCC2iIC4xONFt5hAb
  GYBF4k9W56ygNjCAhYSS5bOB6rh4GARUJU4uE4JJMwr4CFx/d4qsFYJAQWJKQ/fM0PEBSVOzn
  zCAjFGQuLgixdQNYoSlzq+MULYFRKzZrUxQdhqElfPbWKewMg/C0n7LCTtCxiZVjHaJhVlpme
  U5CZm5ugaGhjoGhqa6ppZ6BqZ6CVW6SbqpZbqJqfmlRQlAmX1EsuL9VKLi/WKK3OTc1L08lJL
  NjECAzWl2EViB+PNvp96hxglOZiURHnjL+xOFOJLyk+pzEgszogvKs1JLT7EKMPBoSTB+/oNU
  E6wKDU9tSItMwcYNTBpCQ4eJRHepS+A0rzFBYm5xZnpEKlTjLocl6/PW8QsxJKXn5cqJc4b/w
  6oSACkKKM0D24ELIIvMcpKCfMyMjAwCPEUpBblZpagyr9iFOdgVBLmfQcyhSczrwRu0yugI5i
  AjghPAjuiJBEhJdXAdOz/Exvh1O8JFzP5Z7pce6m2yWzD89vRupouevUyJr++NPps2j9Np7bh
  wtuIdw/aizVnmV6MkBFv/1UqV5VcsrZ5zpwj90oyeRsFYiyeNTg+Mmh3MHCZ66L5eFcNYxIv7
  8V7RQt+qQeVfS23cVx6cb8p/7JFH7Xm8HpOPJOas2ibwtd7fFZKa/R0JhtaHMvWOGv7pq3Mim
  +l5IN7mx86ZF4X+e1hkP750oolUwMunZi42Sf78KINCxdwXrVdZ6N9dXvs2gt8ER8vmK8oXRr
  986WDV9MblXWdTPaG8expeTqfXhYtyOmJ+RPcFO1e/3PGTI+eZC/Zjl87H2WxBrpzck2eq33F
  Z7IPh8aR0ncblFiKMxINtZiLihMBnxHlM1sDAAA=
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-18.tower-528.messagelabs.com!1639706502!14709!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15274 invoked from network); 17 Dec 2021 02:01:43 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-18.tower-528.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Dec 2021 02:01:43 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id A376910044A;
        Fri, 17 Dec 2021 02:01:42 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 95D7D100440;
        Fri, 17 Dec 2021 02:01:42 +0000 (GMT)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.26; Fri, 17 Dec 2021 02:01:20 +0000
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH] xfs: Fix comments mentioning xfs_ialloc
Date:   Fri, 17 Dec 2021 10:01:59 +0800
Message-ID: <1639706519-2239-1-git-send-email-xuyang2018.jy@fujitsu.com>
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

Since kernel commit 1abcf261016e ("xfs: move on-disk inode allocation out of xfs_ialloc()"),
xfs_ialloc has been renamed to xfs_init_new_inode. So update this in comments.

Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/xfs_icache.c | 3 ++-
 fs/xfs/xfs_iops.c   | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e1472004170e..39758015f302 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -770,7 +770,8 @@ xfs_iget(
 
 	/*
 	 * If we have a real type for an on-disk inode, we can setup the inode
-	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
+	 * now.	 If it's a new inode being created, xfs_init_new_inode will
+	 * handle it.
 	 */
 	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0)
 		xfs_setup_existing_inode(ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4..f2ceb6c3fc50 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1332,9 +1332,9 @@ xfs_diflags_to_iflags(
  * Initialize the Linux inode.
  *
  * When reading existing inodes from disk this is called directly from xfs_iget,
- * when creating a new inode it is called from xfs_ialloc after setting up the
- * inode. These callers have different criteria for clearing XFS_INEW, so leave
- * it up to the caller to deal with unlocking the inode appropriately.
+ * when creating a new inode it is called from xfs_init_new_inode after setting
+ * up the inode. These callers have different criteria for clearing XFS_INEW, so
+ * leave it up to the caller to deal with unlocking the inode appropriately.
  */
 void
 xfs_setup_inode(
-- 
2.23.0

