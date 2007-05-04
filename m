Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 16:20:38 -0700 (PDT)
Received: from smtp108.sbc.mail.mud.yahoo.com (smtp108.sbc.mail.mud.yahoo.com [68.142.198.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l44NKVfB031820
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 16:20:32 -0700
Date: Fri, 4 May 2007 16:20:28 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504232028.GA19744@tuatara.stupidest.org>
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504173049.14606033@harpe.intellique.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, May 04, 2007 at 05:30:49PM +0200, Emmanuel Florac wrote:

> # CONFIG_4KSTACKS is not set
>
> So the problem lies elsewhere...

CONFIG_4KSTACKS is badly named.

It means you have 4K process + 4K interrupt stacks.  Without this set
you have just a single 8K stack for processes and interrupts.

One argument for 4K+4K stacks is that 8K+0K isn't really safer in many
cases --- it just appears that way becasue the problems are harder to
hit.

Almost three years ago I posted patches to split the CONFIG_4KSTACKS
option into two options.  I quickly just ported that to 2.6.21 just
now (very quickly, I might have goofed fixing up the rejects).

You could if you have time try this and enable CONFIG_I386_IRQSTACKS
but don't enable CONFIG_I386_4KSTACKS and see if that helps...




diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index 458bc16..f32fbec 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -56,15 +56,22 @@ config DEBUG_RODATA
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
-config 4KSTACKS
+config I386_4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
 	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
+	  on the VM subsystem for higher order allocations.
+
+config I386_IRQSTACKS
+	bool "Allocate separate IRQ stacks"
+	depends on DEBUG_KERNEL
+	default y
+	help
+	  If you say Y here the kernel will allocate and use separate
+	  stacks for interrupts.
 
 config X86_FIND_SMP_CONFIG
 	bool
diff --git a/arch/i386/defconfig b/arch/i386/defconfig
diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
index 8db8d51..f6224fd 100644
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -47,7 +47,7 @@ void ack_bad_irq(unsigned int irq)
 #endif
 }
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -58,7 +58,7 @@ union irq_ctx {
 
 static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -71,7 +71,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
@@ -99,7 +99,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	}
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = hardirq_ctx[smp_processor_id()];
@@ -136,7 +136,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 			: "memory", "cc"
 		);
 	} else
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 		desc->handle_irq(irq, desc);
 
 	irq_exit();
@@ -144,7 +144,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 
 /*
  * These should really be __section__(".bss.page_aligned") as well, but
@@ -234,7 +234,7 @@ asmlinkage void do_softirq(void)
 }
 
 EXPORT_SYMBOL(do_softirq);
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 
 /*
  * Interrupt statistics:
diff --git a/include/asm-i386/irq.h b/include/asm-i386/irq.h
index 11761cd..7db95e1 100644
--- a/include/asm-i386/irq.h
+++ b/include/asm-i386/irq.h
@@ -24,14 +24,14 @@ static __inline__ int irq_canonicalize(int irq)
 # define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
   extern void irq_ctx_init(int cpu);
   extern void irq_ctx_exit(int cpu);
 # define __ARCH_HAS_DO_SOFTIRQ
-#else
+#else /* !CONFIG_I386_IRQSTACKS */
 # define irq_ctx_init(cpu) do { } while (0)
 # define irq_ctx_exit(cpu) do { } while (0)
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 
 #ifdef CONFIG_IRQBALANCE
 extern int irqbalance_disable(char *str);
diff --git a/include/asm-i386/module.h b/include/asm-i386/module.h
index 02f8f54..7d5d2df 100644
--- a/include/asm-i386/module.h
+++ b/include/asm-i386/module.h
@@ -62,11 +62,11 @@ struct mod_arch_specific
 #error unknown processor family
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_4KSTACKS
 #define MODULE_STACKSIZE "4KSTACKS "
-#else
+#else /* not using CONFIG_I386_4KSTACKS */
 #define MODULE_STACKSIZE ""
-#endif
+#endif /* CONFIG_I386_4KSTACKS */
 
 #define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
 
diff --git a/include/asm-i386/thread_info.h b/include/asm-i386/thread_info.h
index 4b187bb..f5268e0 100644
--- a/include/asm-i386/thread_info.h
+++ b/include/asm-i386/thread_info.h
@@ -53,7 +53,7 @@ struct thread_info {
 #endif
 
 #define PREEMPT_ACTIVE		0x10000000
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_4KSTACKS
 #define THREAD_SIZE            (4096)
 #else
 #define THREAD_SIZE		(8192)
