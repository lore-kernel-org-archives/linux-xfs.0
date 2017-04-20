Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945408AbdDTRHH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 13:07:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 638E3C04B92C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 17:07:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-37.pek2.redhat.com [10.72.8.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 647C751DE7
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 17:07:05 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_io: add missed inode command into man page
Date: Fri, 21 Apr 2017 01:06:57 +0800
Message-Id: <1492708017-14163-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There's an "inode" command in xfs_io, it's used to query physical
information about an inode. But there's not any information about
it in xfs_io and other related man pages. So document this command
in the xfs_io man page now.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 man/man8/xfs_io.8 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 19e1ae4..ceb6cf4 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -650,6 +650,23 @@ sec uses UNIX timestamp notation and is the seconds elapsed since
 nsec is the nanoseconds since the sec. This value needs to be in
 the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
 Each (sec, nsec) pair constitutes a single timestamp value.
+.RE
+.PD
+.TP
+.BI " inode [ [ -n ] " number " ] [ -v ]"
+The inode command querys physical information about an inode, it
+returns 1 if any inode number greater than 32 bits exists in the
+filesystem, or 0 if none exist by default. The
+.I number
+is used to specify an inode number, then inode command returns this
+inode number if it's in use, or 0 if not. But if use
+.B \-n
+with
+.I number
+, the next used inode number after this number will be returned, or 0
+if can't find the next one.
+.B \-v
+for verbose mode, the inode number's size in bits will be displayed.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
-- 
2.7.4

