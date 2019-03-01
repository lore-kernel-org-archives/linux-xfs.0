Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41524 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfCAOGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:33 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 1/2] fchownat.2: add project support updates
Date: Fri,  1 Mar 2019 23:06:22 +0900
Message-Id: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>, linux-man@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Cc: linux-man@vger.kernel.org
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 man2/chown.2 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man2/chown.2 b/man2/chown.2
index 50db789ac..fad74df20 100644
--- a/man2/chown.2
+++ b/man2/chown.2
@@ -217,6 +217,11 @@ instead operate on the link itself, like
 .BR fchownat ()
 dereferences symbolic links, like
 .BR chown ().)
+.TP
+.B AT_FCHOWN_PROJID
+Use
+.I group
+to change file's project ID instead of its group ID.
 .PP
 See
 .BR openat (2)
-- 
2.19.1
