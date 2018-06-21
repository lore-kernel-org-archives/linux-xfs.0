Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:53540 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932633AbeFUFrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 01:47:21 -0400
Message-Id: <201806210547.w5L5l5Mh029257@www262.sakura.ne.jp>
Subject: [PATCH] Makefile: Fix backtrace breakage
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
MIME-Version: 1.0
Date: Thu, 21 Jun 2018 14:47:05 +0900
References: <8fda53b0-9d86-943b-e8b4-fd9d6553f010@i-love.sakura.ne.jp> <20180621001509.GQ19934@dastard>
In-Reply-To: <20180621001509.GQ19934@dastard>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <ak@linux.intel.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Dave Chinner <david@fromorbit.com>, Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Omar Sandoval <osandov@fb.com>

>From 7208bf13827fa7c7d6196ee20f7678eff0d29b36 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 21 Jun 2018 14:15:10 +0900
Subject: [PATCH] Makefile: Fix backtrace breakage

Dave Chinner noticed that backtrace part is missing in a lockdep report.

  [   68.760085] the existing dependency chain (in reverse order) is:
  [   69.258520]
  [   69.258520] -> #1 (fs_reclaim){+.+.}:
  [   69.623516]
  [   69.623516] -> #0 (sb_internal){.+.+}:
  [   70.152322]
  [   70.152322] other info that might help us debug this:

Since the kernel was using CONFIG_FTRACE_MCOUNT_RECORD=n &&
CONFIG_FRAME_POINTER=n, objtool_args was not properly calculated
due to incorrectly placed "endif" in commit 96f60dfa5819a065 ("trace:
Use -mcount-record for dynamic ftrace").

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 34d9e9c..55f22f4 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -239,6 +239,7 @@ cmd_record_mcount =						\
 	     "$(CC_FLAGS_FTRACE)" ]; then			\
 		$(sub_cmd_record_mcount)			\
 	fi;
+endif
 endif # CONFIG_FTRACE_MCOUNT_RECORD
 
 ifdef CONFIG_STACK_VALIDATION
@@ -263,7 +264,6 @@ ifneq ($(RETPOLINE_CFLAGS),)
   objtool_args += --retpoline
 endif
 endif
-endif
 
 
 ifdef CONFIG_MODVERSIONS
-- 
1.8.3.1
