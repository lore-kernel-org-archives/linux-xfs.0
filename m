Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 15:13:00 -0700 (PDT)
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l45MCrfB009680
	for <xfs@oss.sgi.com>; Sat, 5 May 2007 15:12:54 -0700
Date: Sat, 5 May 2007 15:12:50 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS crash on linux raid
Message-ID: <20070505221249.GA21960@tuatara.stupidest.org>
References: <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com> <20070504232028.GA19744@tuatara.stupidest.org> <20070505171931.6fe9b6f5@galadriel.home> <463CB5C4.7040803@sandeen.net> <20070505203525.GA16477@tuatara.stupidest.org> <20070505225819.0dd3c0fa@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505225819.0dd3c0fa@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sat, May 05, 2007 at 10:58:19PM +0200, Emmanuel Florac wrote:

> Well I prefer staying away from the very latest bleeding edge, so I
> stick to 2.6.20.11 for now.

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index f68cc6f..908b755 100644
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
diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
index 3201d42..0da8251 100644
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -33,7 +33,7 @@ void ack_bad_irq(unsigned int irq)
 }
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -44,7 +44,7 @@ union irq_ctx {
 
 static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -57,7 +57,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	/* high bit used in ret_from_ code */
 	int irq = ~regs->orig_eax;
 	struct irq_desc *desc = irq_desc + irq;
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
@@ -85,7 +85,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	}
 #endif
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = hardirq_ctx[smp_processor_id()];
@@ -122,7 +122,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 			: "memory", "cc"
 		);
 	} else
-#endif
+#endif /* CONFIG_I386_IRQSTACKS */
 		desc->handle_irq(irq, desc);
 
 	irq_exit();
@@ -130,7 +130,7 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
 	return 1;
 }
 
-#ifdef CONFIG_4KSTACKS
+#ifdef CONFIG_I386_IRQSTACKS
 
 /*
  * These should really be __section__(".bss.page_aligned") as well, but
@@ -220,7 +220,7 @@ asmlinkage void do_softirq(void)
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
