Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28C8D7FA6
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC8ACAC014
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:13 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id a4vSGmAUJrovjCIQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:12 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] x86: Fixup lockdep complaint caused by io apic code
Date: Fri, 10 Oct 2014 16:23:42 +0200
Message-Id: <1412951028-4085-38-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

0day kernel testing guys have reported following lockdep complaint:
======================================================
[ INFO: possible circular locking dependency detected ]
3.15.0-rc5-00567-gbafe980 #1 Not tainted
-------------------------------------------------------
swapper/1 is trying to acquire lock:
 (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70

but task is already holding lock:
 (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&port_lock_key){......}:
       <this stack looks somewhat bogus but we do end up taking
        port->lock when printing to serial console>
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<8106eb1c>] down_trylock+0xc/0x30
       [<8107b795>] console_trylock+0x15/0xb0
       [<8107be8f>] vprintk_emit+0x14f/0x4d0
       [<81b969b9>] printk+0x38/0x3a
       [<82137f78>] print_ICs+0x5b/0x3e7
       [<8212bb41>] do_one_initcall+0x8b/0x128
       [<8212bd7d>] kernel_init_freeable+0x19f/0x236
       [<81b9238b>] kernel_init+0xb/0xd0
       [<81bb0080>] ret_from_kernel_thread+0x20/0x30

-> #1 (i8259A_lock){-.....}:
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<81005af1>] unmask_8259A_irq+0x11/0x60
       [<81005b4b>] enable_8259A_irq+0xb/0x10
       [<8107fffb>] irq_enable+0x2b/0x40
       [<8108005d>] irq_startup+0x4d/0x60
       [<8107f2bc>] __setup_irq+0x39c/0x460
       [<8107f433>] setup_irq+0x33/0x80
       [<8212db15>] setup_default_timer_irq+0xf/0x11
       [<8212db2d>] hpet_time_init+0x16/0x18
       [<8212daff>] x86_late_time_init+0x9/0x10
       [<8212ba3d>] start_kernel+0x331/0x3aa
       [<8212b380>] i386_start_kernel+0x12e/0x131

-> #0 (&irq_desc_lock_class){-.-...}:
       [<810743c2>] __lock_acquire+0x19c2/0x1b20
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
       [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
       [<8107eb58>] disable_irq_nosync+0x8/0x10
       [<815f5c78>] serial8250_startup+0x488/0x720
       [<815f205e>] uart_startup.part.4+0x6e/0x1e0
       [<815f2a40>] uart_open+0xe0/0x140
       [<815e4b51>] tty_open+0x141/0x510
       [<81118bc0>] chrdev_open+0x60/0x140
       [<8111372c>] do_dentry_open+0x14c/0x230
       [<8111459e>] finish_open+0x2e/0x40
       [<8112132a>] do_last+0x4aa/0xd30
       [<81121c5a>] path_openat+0xaa/0x610
       [<811221ec>] do_filp_open+0x2c/0x70
       [<81114a81>] do_sys_open+0x111/0x210
       [<81114b9d>] SyS_open+0x1d/0x20
       [<8212bda4>] kernel_init_freeable+0x1c6/0x236
       [<81b9238b>] kernel_init+0xb/0xd0
       [<81bb0080>] ret_from_kernel_thread+0x20/0x30

I believe the core of the problem is that print_PIC() calls printk()
from under i8259A_lock. I've checked and that doesn't seem to happen
anywhere else in the kernel. So let's move printk() from under that
lock.

As a side note this problem has existed for a long time but it was
uncovered by my patch resulting in extended lockdep coverage of printk
code.

Reported-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/x86/kernel/apic/io_apic.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658de705..b815a4c9e5e5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1770,7 +1770,7 @@ __apicdebuginit(void) print_local_APICs(int maxcpu)
 
 __apicdebuginit(void) print_PIC(void)
 {
-	unsigned int v;
+	unsigned int v0, v1, v2;
 	unsigned long flags;
 
 	if (!legacy_pic->nr_legacy_irqs)
@@ -1780,24 +1780,23 @@ __apicdebuginit(void) print_PIC(void)
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
-	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
-
-	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
+	v0 = inb(0xa1) << 8 | inb(0x21);
+	v1 = inb(0xa0) << 8 | inb(0x20);
 
 	outb(0x0b,0xa0);
 	outb(0x0b,0x20);
-	v = inb(0xa0) << 8 | inb(0x20);
+	v2 = inb(0xa0) << 8 | inb(0x20);
 	outb(0x0a,0xa0);
 	outb(0x0a,0x20);
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v0);
+	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v1);
+	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v2);
 
-	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	v0 = inb(0x4d1) << 8 | inb(0x4d0);
+	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v0);
 }
 
 static int __initdata show_lapic = 1;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
