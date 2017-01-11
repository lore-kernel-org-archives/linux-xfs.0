Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761559AbdAKFSb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 00:18:31 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 450468F039
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 05:18:32 +0000 (UTC)
Received: from dhcp-12-135.nay.redhat.com (dhcp-12-135.nay.redhat.com [10.66.12.135])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0B5IU6G031069
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 00:18:31 -0500
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_repair: update the manual content about xfs_repair exit status
Date: Wed, 11 Jan 2017 13:18:28 +0800
Message-Id: <1484111908-12558-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The man 8 xfs_repair said "xfs_repair run without the -n option will
always return a status code of 0". That's not correct.

xfs_repair will return 2 if it finds a fs log which needs to be
replayed or cleared, 1 if runtime error is encountered, and 0 for
all other cases.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This patch has been stayed in my local xfsprogs repo for a long
time. So I'm sending it out again :)

Thanks,
Zorro

 man/man8/xfs_repair.8 | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 1b4d9e3..314f2c2 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -504,12 +504,18 @@ that is known to be free. The entry is therefore invalid and is deleted.
 This message refers to a large directory.
 If the directory were small, the message would read "junking entry ...".
 .SH EXIT STATUS
+.TP
 .B xfs_repair \-n
-(no modify node)
+(no modify mode)
 will return a status of 1 if filesystem corruption was detected and
 0 if no filesystem corruption was detected.
+.TP
 .B xfs_repair
-run without the \-n option will always return a status code of 0.
+run without the \-n option will return a status code of 2 if it finds a
+filesystem log which needs to be replayed (by a mount/umount cycle) or
+cleared (by -L option), 1 if a runtime error is encountered, filesystem
+may be even more broken than before, so repair needs to be run again,
+and 0 in all other cases, whether or not filesystem corruption was detected.
 .SH BUGS
 The filesystem to be checked and repaired must have been
 unmounted cleanly using normal system administration procedures
-- 
2.7.4

