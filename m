Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 19:32:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K2Wn2t015233
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 19:32:51 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6965E6C3A91
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 19:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BUVynFFsO58LYgtT for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 19:33:21 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E92FC1802E67F
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:33:20 -0500 (CDT)
Message-ID: <47E1CCF0.9070904@sandeen.net>
Date: Wed, 19 Mar 2008 21:33:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix xfsqa 049 when using whole scratch device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

if SCRATCH_DEV happens to be a whole device, mke2fs will wait
for confirmation.

(mke2fs -F would work, too...)

-Eric

Index: xfs-cmds/xfstests/049
===================================================================
--- xfs-cmds.orig/xfstests/049
+++ xfs-cmds/xfstests/049
@@ -60,7 +60,7 @@ echo "--- mounts" >> $seq.full
 mount >> $seq.full
 
 _log "Create ext2 fs on scratch"
-mkfs -t ext2 $SCRATCH_DEV >> $seq.full 2>&1 \
+echo y | mkfs -t ext2 $SCRATCH_DEV >> $seq.full 2>&1 \
     || _fail "!!! failed to mkfs ext2"
 
 _log "Mount ext2 fs on scratch"
