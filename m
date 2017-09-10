Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34767 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdIJAas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:30:48 -0400
Received: by mail-pg0-f65.google.com with SMTP id v82so2988864pgb.1
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:30:48 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 3/5] replace use of SIGCLD with SIGCHLD
Date: Sat,  9 Sep 2017 17:30:33 -0700
Message-Id: <20170910003035.14285-3-raj.khem@gmail.com>
In-Reply-To: <20170910003035.14285-1-raj.khem@gmail.com>
References: <20170910003035.14285-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 common/main.c    | 2 +-
 doc/xfsdump.html | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/main.c b/common/main.c
index b34e974..49dd361 100644
--- a/common/main.c
+++ b/common/main.c
@@ -2237,7 +2237,7 @@ static sig_printmap_t sig_printmap[ ] = {
 	{SIGTERM,	"SIGTERM"},
 	{SIGUSR1,	"SIGUSR1"},
 	{SIGUSR2,	"SIGUSR2"},
-	{SIGCLD,	"SIGCLD"},
+	{SIGCHLD,	"SIGCHLD"},
 	{SIGPWR,	"SIGPWR"},
 	{SIGURG,	"SIGURG"},
 	{SIGPOLL,	"SIGPOLL"},
diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index 8cc02d4..9399bd6 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -334,7 +334,7 @@ the ring buffer. It ignores signals and does not terminate until it
 receives a RING_OP_DIE message. It then exits 0.
 <p>
 The main process sleeps waiting for any of its children to die
-(ie. waiting for a SIGCLD). All children that it cares about (stream
+(ie. waiting for a SIGCHLD). All children that it cares about (stream
 managers and ring buffer slaves) are registered through the child
 manager abstraction. When a child dies wait status and other info is
 stored with its entry in the child manager. main() ignores the deaths
-- 
2.14.1

