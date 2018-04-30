Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeD3BP3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 29 Apr 2018 21:15:29 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] fsck.xfs: do not use 'function' keyword
Message-ID: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
Date: Sun, 29 Apr 2018 20:15:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>

It was pointed out on irc that fsck.xfs uses the 'function' keyword
although it invokes /bin/sh - 'function' is a bashism.  It's not needed
here, so just remove it.

Fixes: 04a2d5d ("fsck.xfs: allow forced repairs using xfs_repair")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This might be a 4.16.1 item, if strict-sh initscripts fail to run fsck.xfs at
boot time ...?

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index c9fc3eb..1916c07 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -6,7 +6,7 @@
 NAME=$0
 
 # get the right return code for fsck
-function repair2fsck_code() {
+repair2fsck_code() {
 	case $1 in
 	0)  return 0 # everything is ok
 		;;

