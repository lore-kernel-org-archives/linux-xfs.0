Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 01:58:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3U8vgNw022382
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 01:57:49 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD421160F3E4
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 01:58:23 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id TRD0Zy1GSbOidjaa for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 01:58:23 -0700 (PDT)
Date: Wed, 30 Apr 2008 02:58:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Fix current xfs build
Message-ID: <20080430085812.GG14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org


Linus' current git tree appears to be missing a header file which makes
xfs fail to build.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 1bc9f60..4edc469 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -75,6 +75,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/spinlock.h>
+#include <linux/random.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
