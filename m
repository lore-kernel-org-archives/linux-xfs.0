Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbcIJErd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Sep 2016 00:47:33 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_repair: update the manual content about xfs_repair exit status
Date: Sat, 10 Sep 2016 12:47:29 +0800
Message-Id: <1473482849-5706-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com, Zorro Lang <zlang@redhat.com>

The man 8 xfs_repair said "xfs_repair run without the -n option will
always return a status code of 0". That's not correct.

xfs_repair will return 2 if it find valuable metadata changes in log
which needs to be replayed, 1 if it can't fix the corruption or some
other errors happened and 0 if nothing wrong or all the corruptions
were fixed.

Generally xfs_repair -L will always return 0, except it can't clear
the log.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

I  trusted the xfs_repair manpage, and thought xfs_repair will always return 0.
But recently I found it lies when I tried to review someone xfstests case.

A correct manpage will help more people to write right cases, so I try to modify
the manpage, by search all exit/do_error in xfsprogs/repair. I'm not the best
one who learn about xfs_repair, so I just hope I did the right thing:-P Please
feel free to correct me.

Thanks,
Zorro

 man/man8/xfs_repair.8 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 1b4d9e3..1f8f13b 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -504,12 +504,23 @@ that is known to be free. The entry is therefore invalid and is deleted.
 This message refers to a large directory.
 If the directory were small, the message would read "junking entry ...".
 .SH EXIT STATUS
+.TP
 .B xfs_repair \-n
 (no modify node)
 will return a status of 1 if filesystem corruption was detected and
 0 if no filesystem corruption was detected.
+.TP
 .B xfs_repair
-run without the \-n option will always return a status code of 0.
+run without the \-n option will return a status code of 2 if it find the
+filesystem has valuable metadata changes in log which needs to be
+replayed, 1 if there's corruption left to be fixed or can't find log head
+and tail or some other errors happened, and 0 if nothing wrong or all the
+corruptions were fixed.
+.TP
+.B xfs_repair \-L
+(Force Log Zeroing)
+will return a status code of 1 if it can't clear the log, or will always
+return 0.
 .SH BUGS
 The filesystem to be checked and repaired must have been
 unmounted cleanly using normal system administration procedures
-- 
2.7.4

