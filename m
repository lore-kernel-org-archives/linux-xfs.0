Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 22:24:57 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4L5OrfB020521
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 22:24:54 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4L5L4Yx006226
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 01:21:04 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4L5OnIv160264
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 23:24:49 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4L5OnjC028311
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 23:24:49 -0600
Subject: Re: [PATCH 0/6][TAKE4] fallocate system call
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070518234444.f53a4230.akpm@linux-foundation.org>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	 <20070329115126.GB7374@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070517141115.GA24260@amitarora.in.ibm.com>
	 <20070518234444.f53a4230.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 20 May 2007 22:24:42 -0700
Message-Id: <1179725082.3936.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Fri, 2007-05-18 at 23:44 -0700, Andrew Morton wrote:
> On Thu, 17 May 2007 19:41:15 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > fallocate() is a new system call being proposed here which will allow
> > applications to preallocate space to any file(s) in a file system.
> 
> I merged the first three patches into -mm, thanks.
> 
> All the system call numbers got changed due to recent additions.  They
> may change in the future, too - nothing is stable until the code lands
> in mainline.
> 
In case you haven't realize it, the ia64 fallocate() patch comes with
Amit's takes 4 fallocate patch series (3/6) missing one line change,
thus fail to compile on ia64.

Here is the updated one. Patch tested on ia64. (compile and fsx)

fallocate() on ia64

ia64 fallocate syscall support.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 arch/ia64/kernel/entry.S  |    1 +
 include/asm-ia64/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc1/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6.22-rc1.orig/arch/ia64/kernel/entry.S	2007-05-18 16:30:16.000000000 -0700
+++ linux-2.6.22-rc1/arch/ia64/kernel/entry.S	2007-05-18 16:32:45.000000000 -0700
@@ -1585,5 +1585,6 @@
 	data8 sys_getcpu
 	data8 sys_epoll_pwait			// 1305
 	data8 sys_utimensat
+	data8 sys_fallocate
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
Index: linux-2.6.22-rc1/include/asm-ia64/unistd.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-ia64/unistd.h	2007-05-18 16:30:16.000000000 -0700
+++ linux-2.6.22-rc1/include/asm-ia64/unistd.h	2007-05-18 17:34:58.000000000 -0700
@@ -296,11 +296,12 @@
 #define __NR_getcpu			1304
 #define __NR_epoll_pwait		1305
 #define __NR_utimensat			1306
+#define __NR_fallocate			1307
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			283 /* length of syscall table */
+#define NR_syscalls			285 /* length of syscall table */
 
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND


> I didn't merge any of the ext4 changes as they appear to be in Ted's
> devel tree.  Although I didn't check that they are 100% the same in 
> that tree.
> 
Since both Amit and Ted are traveling, I will jump in...

Most likely it's not the same one. What in Ted's devel tree is "takes 2"
patches.

I have incorporated takes 4 patches in the backing ext4 patch git tree
here:

I have tested these patch series on ia64,ppc64,x86 and x86_64. I am not
sure if Ted got a chance to update his ext4 git tree from this patch
queue git tree yet. 

> What's the plan to get some ext4 updates into mainline, btw?  Things
> seem to be rather gradual.


Last time Ted and I discussed we all agree fallocate patches should go
into mainline. Actually most patches marked before the "unstable
patches" can get into mainline, especially the following patches
(contains a few bug fixes patches)

# New patch to fix whitespace before applying new patches
whitespace.patch
 
#New patch to remove unnecessary exported symbols
ext4_remove_exported_symbles.patch
 
# New patch to add mount option to turn off extents
ext4_noextent_mount_opt.patch
# Now Turn on extents feature by default
ext4_extents_on_by_default.patch
 
#New patch to propagate inode flags
ext4-propagate_flags.patch
 
#New patch to add extent sanity checks
ext4-extent-sanity-checks.patch
 
#New patch to free blocks when failed to insert an extent
ext4-free-blocks-on-insert-extent-failure.patch

We already missed rc-1 window, but if possible, I would like to see ext4
fallocate patches and above patches in mainline 2.6.22. The nanosecond
timestamp patch is probably good to go also.

Regards,
Mingming
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
