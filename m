Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB5IgTbT146798 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 12:42:30 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7428129BF45
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 10:42:29 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id uBRE6ccjRHELMdBD for
	<xfs@oss.sgi.com>; Mon, 05 Dec 2011 10:42:29 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 5 Dec 2011 13:42:27 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB5IgMl5138182 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 13:42:22 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	pB5IgMcT017491 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 16:42:22 -0200
Subject: [PATCH] security: Delay freeing inode->i_security till the end of
	RCU grace period
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 05 Dec 2011 12:42:21 -0600
Message-ID: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-security-module@vger.kernel.org
Cc: Eric Paris <eparis@parisplace.org>, XFS Mailing List <xfs@oss.sgi.com>

while running test case 234 from xfstests test suite, I was getting an
occational memory fault in inode_has_perm() with the following stack

------------------------------
Pid: 32611, comm: setquota Not tainted 3.2.0-rc4+ #1 IBM  System x3630 M3
RIP: 0010:[<ffffffff811e57ff>]  [<ffffffff811e57ff>] inode_has_perm+0x1f/0x40
RSP: 0018:ffff880642bcdb78  EFLAGS: 00010246
RAX: 0000000000800002 RBX: ffff88064f2205f8 RCX: 0000000000800000
RDX: 0000000000800000 RSI: 0000000000000000 RDI: ffff880649e58480
RBP: ffff880642bcdb78 R08: ffff880642bcdb88 R09: 0000000000000080
R10: ffff880658ffff00 R11: ffff880642bcdb88 R12: 0000000000000081
R13: ffff88064f2205f8 R14: ffff8806592b8100 R15: 0000000000000000
FS:  00007f56dfa3a700(0000) GS:ffff88067f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000642b30000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process setquota (pid: 32611, threadinfo ffff880642bcc000, task ffff8806592b8100)
Stack:
ffff880642bcdc18 ffffffff811e5d79 0000000000000009 0000000000000000
ffff88064f2205f8 0000000000000000 0000000000000000 0000000000000000
0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
[<ffffffff811e5d79>] selinux_inode_permission+0xa9/0x100
[<ffffffff811e323c>] security_inode_permission+0x1c/0x30
[<ffffffff81162509>] inode_permission+0x49/0x100
[<ffffffff81164b57>] link_path_walk+0x87/0x810
[<ffffffff810fedfa>] ? unlock_page+0x2a/0x40
[<ffffffff81165955>] path_lookupat+0x55/0x690
[<ffffffff81125867>] ? handle_pte_fault+0xf7/0xb50
[<ffffffff81165fc1>] do_path_lookup+0x31/0xc0
[<ffffffff81162168>] ? getname_flags+0x1f8/0x280
[<ffffffff81166df9>] user_path_at+0x59/0xa0
[<ffffffff8112641b>] ? handle_mm_fault+0x15b/0x270
[<ffffffff814af8c0>] ? do_page_fault+0x1e0/0x460
[<ffffffff81146a62>] ? kmem_cache_alloc+0x152/0x190
[<ffffffff8115b9c7>] vfs_fstatat+0x47/0x80
[<ffffffff81077571>] ? do_sigaction+0x91/0x1d0
[<ffffffff8115badb>] vfs_stat+0x1b/0x20
[<ffffffff8115bb04>] sys_newstat+0x24/0x50
[<ffffffff810c3c4f>] ? audit_syscall_entry+0x1bf/0x1f0
[<ffffffff814b29c2>] system_call_fastpath+0x16/0x1b
Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 f6 46 0d 02 75 23 48 8b 76 38 48 8b
7f 68 45 89 c1 49 89 c8 89 d1 <0f> b7 46 20 8b 7f 04 8b 76 1c 89 c2 e8 a0 f9 ff ff c9 c3 31 c0 
RIP  [<ffffffff811e57ff>] inode_has_perm+0x1f/0x40
RSP <ffff880642bcdb78>
CR2: 0000000000000020
---[ end trace 5d054c892d311b3f ]---
----------------------------------------------------------------------------

Debugging the problem deeper I found the reason for the memory fault
was due to the fact that the free of the security data structure 
happens immediately, where as the whole inode data structure happens
at the end of the RCU grace period thru call_rcu().

IOW, there are few processes that still have the inode data structure
and they expect it to be intact till end of the RCU grace period.
But, the function security/selinux/hooks.c:inode_free_security() sets
the field inode->i_security to NULL, which causes the process that
is trying to dereference inode->i_security in inode_has_perm() trip
as shown in the stack trace above.

Fix: Instead of freeing i_security and setting inode->isecurity
to NULL in inode_free_security(), schedule the data structure
to be removed at the end of RCU grace period using call_rcu().

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 security/selinux/hooks.c          |   11 ++++++++---
 security/selinux/include/objsec.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1126c10..07ef579 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -216,6 +216,13 @@ static int inode_alloc_security(struct inode *inode)
 	return 0;
 }
 
+static void sec_callback(struct rcu_head *head)
+{
+	struct inode_security_struct *isec =
+		container_of(head, struct inode_security_struct, sec_rcu);
+	kmem_cache_free(sel_inode_cache, isec);
+
+}
 static void inode_free_security(struct inode *inode)
 {
 	struct inode_security_struct *isec = inode->i_security;
@@ -225,9 +232,7 @@ static void inode_free_security(struct inode *inode)
 	if (!list_empty(&isec->list))
 		list_del_init(&isec->list);
 	spin_unlock(&sbsec->isec_lock);
-
-	inode->i_security = NULL;
-	kmem_cache_free(sel_inode_cache, isec);
+	call_rcu(&isec->sec_rcu, sec_callback);
 }
 
 static int file_alloc_security(struct file *file)
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 26c7eee..45ded3c 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -44,6 +44,7 @@ struct inode_security_struct {
 	u16 sclass;		/* security class of this object */
 	unsigned char initialized;	/* initialization flag */
 	struct mutex lock;
+	struct rcu_head sec_rcu;
 };
 
 struct file_security_struct {
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
