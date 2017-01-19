Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbdASHnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 02:43:19 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6AD24C04BD3C
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 07:35:23 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs_io: add DAX and CoW extent-size flags to chattr manpage
Date: Thu, 19 Jan 2017 15:35:11 +0800
Message-Id: <20170119073511.11590-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

Manpage is not updated after adding set/clear DAX and CoW
extent-size flags support to xfs_io.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 man/man8/xfs_io.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 885df7f..fccddcf 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -798,7 +798,7 @@ can be used to restrict the output to directories only).
 This is a depth first descent, it does not follow symlinks and
 it also does not cross mount points.
 .TP
-.BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfS " ]"
+.BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
 Change extended inode flags on the currently open file. The
 .B \-R
 and
-- 
2.9.3

