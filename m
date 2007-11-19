Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 10:42:21 -0800 (PST)
Received: from strike.wu-wien.ac.at (strike.wu-wien.ac.at [137.208.89.120])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAJIg0gc018040
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 10:42:07 -0800
Message-ID: <4741D198.2060908@strike.wu-wien.ac.at>
Date: Mon, 19 Nov 2007 19:10:32 +0100
From: Alexander Bergolth <leo@strike.wu-wien.ac.at>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com> <20070504232028.GA19744@tuatara.stupidest.org>
In-Reply-To: <20070504232028.GA19744@tuatara.stupidest.org>
Content-Type: multipart/mixed;
 boundary="------------090607070609050208000105"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090607070609050208000105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

Several months ago, you posted a patch for 8k stacks together with
irqstacks:

On 05/05/2007 01:20 AM, Chris Wedgwood wrote:
> Almost three years ago I posted patches to split the CONFIG_4KSTACKS
> option into two options.  I quickly just ported that to 2.6.21 just
> now (very quickly, I might have goofed fixing up the rejects).

Do you have a working version of your patch for 2.6.23?
I've been using a similar patch (attached) for several years now but
since 2.6.23, it produces oopses like below. The patch applies cleanly
but there seems to be some major change between 2.6.22 and 2.6.23 that
isn't covered correctly.

Thanks,
--leo

P.S.: The attached patch is part of ATrpms' 8k kernel:
http://atrpms.net/dist/f8/kernel-tuxonice/
2.6.23.1-49_0.99.cubbi_tuxonice_8k and
2.6.23.1-42_0.99.cubbi_tuxonice_8k both show the problem, the
corresponding versions without _8k work without any problem.
2.6.22.1-41_0.99.cubbi_tuxonice_8k on Fedora 7 worked fine too.

-------------------- 8< --------------------
BUG: unable to handle kernel NULL pointer dereference at virtual address
00000050
printing eip: 00000050 *pde = 3ed4c067
Oops: 0000 [#1] SMP
Modules linked in: ipv6 ext2 mbcache loop ahci sr_mod cdrom ata_generic
firewire_ohci firewire_core pata_pdc2027x crc_itu_t sata_sil iTCO_wdt
i2c_i801 button parport_pc parport iTCO_vendor_support i2c_core ata_piix
pcspkr intel_agp sky2 floppy sg dm_snapshot dm_zero dm_mirror dm_mod
pata_it821x libata sd_mod scsi_mod raid456 async_xor async_memcpy
async_tx xor raid1 xfs uhci_hcd ohci_hcd ehci_hcd
CPU:    0
EIP:    0060:[<00000050>]    Not tainted VLI
EFLAGS: 00210082   (2.6.23.1-49_0.99.cubbi_tuxonice_8k.fc8 #1)
EIP is at 0x50
eax: 00000001   ebx: f8947796   ecx: 01073000   edx: c0799200
esi: f8897310   edi: f79d8000   ebp: f79d8a2c   esp: c07defa0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rklogd (pid: 1787, ti=c07de000 task=f74fb840 task.ti=f744e000)
Stack: 00200292 f894472d 00000000 000000dc f7f5a6a0 f7f8f2b4 00000002
00000001
       00200292 00000001 00000012 00000012 c041e022 c0465fcb c0741700
c0741700
       00000012 00000000 c04672e5 c07def7c 00000012 c0467249 c0741700
c04074cb
Call Trace:
 [<f894472d>] ata_interrupt+0x1ab/0x1be [libata]
 [<c041e022>] ack_ioapic_quirk_irq+0x34/0x86
 [<c0465fcb>] handle_IRQ_event+0x23/0x51
 [<c04672e5>] handle_fasteoi_irq+0x9c/0xa6
 [<c0467249>] handle_fasteoi_irq+0x0/0xa6
 [<c04074cb>] do_IRQ+0x8c/0xb9
 =======================
Code:  Bad EIP value.
EIP: [<00000050>] 0x50 SS:ESP 0068:c07defa0
BUG: unable to handle kernel paging request at virtual address 010b2fc8
printing eip: c07dee7c *pde = 00000000
Oops: 0002 [#2] SMP
Modules linked in: ipv6 ext2 mbcache loop ahci sr_mod cdrom ata_generic
firewire_ohci firewire_core pata_pdc2027x crc_itu_t sata_sil iTCO_wdt
i2c_i801 button parport_pc parport iTCO_vendor_support i2c_core ata_piix
pcspkr intel_agp sky2 floppy sg dm_snapshot dm_zero dm_mirror dm_mod
pata_it821x libata sd_mod scsi_mod raid456 async_xor async_memcpy
async_tx xor raid1 xfs uhci_hcd ohci_hcd ehci_hcd
CPU:    0
EIP:    0060:[<c07dee7c>]    Tainted: G      D VLI
EFLAGS: 00210086   (2.6.23.1-49_0.99.cubbi_tuxonice_8k.fc8 #1)
EIP is at hardirq_stack+0x1e7c/0x40000
eax: 00200046   ebx: f74fb88c   ecx: 00200286   edx: 01073000
esi: 00051b65   edi: 001e8480   ebp: 00200006   esp: c07dee58
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rklogd (pid: 1787, ti=c07de000 task=f74fb840 task.ti=f744e000)
Stack: c0425763 153fdb8a 00000001 13125d1e 00000001 f7bb5840 f74fb840
f7bb5840
       c07dee90 c042ab0f 001e8480 00000000 00000001 00000000 00200082
c0427c1d
       ffffff10 c04300ad 00000000 0000000f f7bb5840 00000000 c180c200
00000000
Call Trace:
 [<c0425763>] __check_preempt_curr_fair+0x55/0x86
 [<c042ab0f>] check_preempt_curr_fair+0x6b/0x71
 [<c0427c1d>] try_to_wake_up+0x2ef/0x2f9
 [<c04300ad>] do_exit+0x11b/0x6fc
 [<c0434d58>] del_timer+0x48/0x4e
 [<f894564f>] ata_scsi_qc_complete+0x3bd/0x3cb [libata]
 [<c062cdeb>] do_page_fault+0x521/0x5ef
 [<f893feea>] __ata_qc_complete+0x8c/0x92 [libata]
 [<f8940dd9>] ata_hsm_move+0x6d1/0x70c [libata]
 [<f8897310>] it821x_passthru_bmdma_stop+0x17/0x36 [pata_it821x]
 [<c062c8ca>] do_page_fault+0x0/0x5ef
 [<c062b5b2>] error_code+0x72/0x78
 [<f8947796>] ata_altstatus+0x1c/0x20 [libata]
 [<f894796c>] ata_bmdma_stop+0x1a/0x23 [libata]
 [<f8947796>] ata_altstatus+0x1c/0x20 [libata]
 [<f8897310>] it821x_passthru_bmdma_stop+0x17/0x36 [pata_it821x]
 [<f894472d>] ata_interrupt+0x1ab/0x1be [libata]
 [<c041e022>] ack_ioapic_quirk_irq+0x34/0x86
 [<c0465fcb>] handle_IRQ_event+0x23/0x51
 [<c04672e5>] handle_fasteoi_irq+0x9c/0xa6
 [<c0467249>] handle_fasteoi_irq+0x0/0xa6
 [<c04074cb>] do_IRQ+0x8c/0xb9
 =======================
Code: 00 00 00 86 00 21 00 63 57 42 c0 8a db 3f 15 01 00 00 00 1e 5d 12
13 01 00 00 00 40 58 bb f7 40 b8 4f f7 40 58 bb f7 90 ee 7d c0 <0f> ab
42 c0 80 84 1e 00 00 00 00 00 01 00 00 00 00 00 00 00 82
EIP: [<c07dee7c>] hardirq_stack+0x1e7c/0x40000 SS:ESP 0068:c07dee58
Fixing recursive fault but reboot is needed!
-------------------- 8< --------------------

-- 
e-mail   ::: Alexander.Bergolth (at) wu-wien.ac.at
fax      ::: +43-1-31336-906050
location ::: Computer Center | Vienna University of Economics | Austria


--------------090607070609050208000105
Content-Type: text/x-patch;
 name="linux-2.6.22-8k_stacks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.22-8k_stacks.patch"

--- linux-2.6.22.i686/arch/i386/Kconfig.debug.orig	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22.i686/arch/i386/Kconfig.debug	2007-07-22 13:49:57.000000000 +0200
@@ -85,4 +85,9 @@
           option saves about 4k and might cause you much additional grey
           hair.
 
+ config IRQSTACKS
+ 	bool "use IRQ stacks"
+ 	depends on !4KSTACKS
+ 	default n
+ 
 endmenu
--- linux-2.6.22.i686/arch/i386/kernel/irq.c.orig	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22.i686/arch/i386/kernel/irq.c	2007-07-22 13:50:50.000000000 +0200
@@ -50,7 +50,7 @@
 #endif
 }
 
-#ifdef CONFIG_4KSTACKS
+#if defined(CONFIG_4KSTACKS) || defined(CONFIG_IRQSTACKS)
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -74,7 +74,7 @@
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
+#if defined(CONFIG_4KSTACKS) || defined(CONFIG_IRQSTACKS)
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
@@ -102,7 +102,7 @@
 	}
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#if defined(CONFIG_4KSTACKS) || defined(CONFIG_IRQSTACKS)
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = hardirq_ctx[smp_processor_id()];
@@ -147,7 +147,7 @@
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
+#if defined(CONFIG_4KSTACKS) || defined(CONFIG_IRQSTACKS)
 
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
 		__attribute__((__section__(".bss.page_aligned")));
--- linux-2.6.22.i686/include/asm-i386/irq.h.orig	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22.i686/include/asm-i386/irq.h	2007-07-22 13:51:34.000000000 +0200
@@ -24,7 +24,7 @@
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#if defined(CONFIG_4KSTACKS) || defined(CONFIG_IRQSTACKS)
   extern void irq_ctx_init(int cpu);
   extern void irq_ctx_exit(int cpu);
 # define __ARCH_HAS_DO_SOFTIRQ

--------------090607070609050208000105--
