Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164445AbdDXFCQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 01:02:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A80680465
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 05:02:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-80.pek2.redhat.com [10.72.8.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1B907BAEC
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 05:02:14 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2 1/2] xfs_io: add missed inode command into man page
Date: Mon, 24 Apr 2017 13:02:07 +0800
Message-Id: <1493010128-8153-1-git-send-email-zlang@redhat.com>
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

Hi,

This V2 follow Eric's suggestion, changed some description, and moved
the inode command from "FILE I/O" section to "OTHER COMMANDS" section.

Thanks,
Zorro

 man/man8/xfs_io.8 | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 19e1ae4..a7c2a1e 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -923,6 +923,30 @@ verbose output will be printed.
 .RE
 .IP
 .B [NOTE: Not currently operational on Linux.]
+.RE
+.PD
+.TP
+.BI "inode  [ [ -n ] " number " ] [ -v ]"
+The inode command queries physical information about an inode. With
+no arguments, it will return 1 or 0, indicating whether or not if any
+inode numbers greater than 32 bits are currently in use in the filesystem.
+If given an inode
+.I number
+as an argument, then inode command will return this inode
+.I number
+if it's in use, or 0 if not. With
+.BI \-n " number"
+, the next used inode number after this
+.I number
+will be returned, or 0 if can't find the next one. With
+.B \-v
+the command will also report the number of bits (32 or 64) used by the
+inode
+.I number
+printed in the result; if no inode
+.I number
+was specified on the commandline, the maximum possible inode number in
+the system will be printed along with its size.
 .PD
 .TP
 .BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]
-- 
2.7.4

