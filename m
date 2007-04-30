Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 20:10:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U39tfB005951
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 20:09:58 -0700
Date: Mon, 30 Apr 2007 13:09:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] ia64 fallocate syscall
Message-ID: <20070430030924.GN32602149@melbourne.sgi.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430004702.GM32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

ia64 fallocate syscall support.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 arch/ia64/kernel/entry.S  |    1 +
 include/asm-ia64/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/arch/ia64/kernel/entry.S
===================================================================
--- 2.6.x-xfs-new.orig/arch/ia64/kernel/entry.S	2007-03-29 19:01:41.000000000 +1000
+++ 2.6.x-xfs-new/arch/ia64/kernel/entry.S	2007-04-27 19:12:56.829396661 +1000
@@ -1612,5 +1612,6 @@ sys_call_table:
 	data8 sys_vmsplice
 	data8 sys_ni_syscall			// reserved for move_pages
 	data8 sys_getcpu
+	data8 sys_fallocate
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
Index: 2.6.x-xfs-new/include/asm-ia64/unistd.h
===================================================================
--- 2.6.x-xfs-new.orig/include/asm-ia64/unistd.h	2007-03-29 19:03:37.000000000 +1000
+++ 2.6.x-xfs-new/include/asm-ia64/unistd.h	2007-04-27 19:18:18.215568425 +1000
@@ -293,11 +293,12 @@
 #define __NR_vmsplice			1302
 /* 1303 reserved for move_pages */
 #define __NR_getcpu			1304
+#define __NR_fallocate			1305
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			281 /* length of syscall table */
+#define NR_syscalls			282 /* length of syscall table */
 
 #define __ARCH_WANT_SYS_RT_SIGACTION
 
