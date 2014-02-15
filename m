Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AF577F3F
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 23:25:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 137F230409A
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 21:25:44 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id JmpxhrIibj11NT56 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 21:25:40 -0800 (PST)
Date: Sat, 15 Feb 2014 05:25:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215052531.GX18016@ZenIV.linux.org.uk>
References: <20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oleg Nesterov <oleg@redhat.com>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, Feb 13, 2014 at 09:58:47AM -0800, Linus Torvalds wrote:
> On Thu, Feb 13, 2014 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > And we should be careful with SIGQUEUE_PREALLOC, at least
> > collect_signal() should not do list_del_init()... Plus we need to
> > handle the SEND_SIG_FORCED-like case.
> 
> I don't think the users need to care. They'd just call
> "sigqueue_free()" not knowing about our preallocations etc. That kind
> of detail should be confined to inside signal.c.
> 
> But there really aren't that many users. There's a couple of
> "dequeue_signal_lock()" users, but they don't actually *want* the
> siginfo at all (they're kernel threads), so we can just make that
> function free the siginfo immediately (and get rid of the totally
> unnecessay kernel stack allocation). And outside of signal.c only
> signalfd uses "dequeue_signal()" itself, and that would be the only
> one that would need to be taught to use (in signalfd_copyinfo()) and
> then free the sigqueue entry.
> 
> So it really looks like the right thing to do, and fairly
> straightforward. But I'm leaving the coding proof to Al, since he
> already offered ;)

OK, _very_ preliminary patch follows.  It's uglier than it has to and it's
not in the form I would consider suitable for merge.  It doesn't depend
on conversions of architectures to use of ksignal as prereqs; instead of
that it has config symbol (ARCH_USES_KSIGNAL) that can be selected on
architectures already through that conversion (in this patch - just on
x86, since that was all I could test on at the moment; e.g. alpha and
arm could also get such selects right now).  If it isn't selected, everything
builds as usual.  With large siginfo on stack for signal path, as before.
We get ksiginfo_t as an alias for siginfo_t in that case, dismiss_siginfo()
is a no-op, etc.  If it _is_ selected, ksiginfo_t is much smaller than
siginfo_t.

Of course, we pay for that with ifdefs in places that need to understand
[k]siginfo_t guts; signalfd_copyinfo(), copy_siginfo_from_user{,32}() and
copy_ksiginfo_to_user{,32}(), tracepoint for deliver_signal(), collect_signal(),
trivial ones in dequeue_signal() and an ugly bugger in ptrace_signal().
No way around that until all architectures are converted.  Other places
get away with some siginfo_t replaced with ksiginfo_t and dismiss_siginfo()
added in some places.  arch/x86/ia32/ia32_signal.c needed a bit of change
(we probably ought to unify copy_siginfo_from_user32() on all architectures
that have it, actually).

The sucker survived LTP syscall tests and hasn't died on xfstests yet either
(== doesn't seem to leak horribly).  Consider it a proof-of-concept and no
more than that.  One thing I'm really not satisfied with is signal sending
pathway - it would probably make a lot of sense to use ksiginfo there as
well, and have insertion into queue simply steal info->q instead of allocating
and copying.  Another is that ifdefs like that are tolerable only if we
plan to convert everything during this cycle; I believe it to be doable,
actually.  Having that sucker go before the conversions would make for
simpler logistics wrt architecture trees, but it may be better to get
all conversions merged first.  Not sure...  Anyway, here is it; comments
are welcome.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/Kconfig b/arch/Kconfig
index 80bbb8c..f753561 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -522,4 +522,7 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
+config ARCH_USES_KSIGNAL
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..4ec468d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select ARCH_USES_KSIGNAL
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 2206757..611a03e 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -34,7 +34,7 @@
 #include <asm/sys_ia32.h>
 #include <asm/smap.h>
 
-int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
+int __copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 {
 	int err = 0;
 	bool ia32 = test_thread_flag(TIF_IA32);
@@ -105,6 +105,25 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 	return err;
 }
 
+int copy_siginfo_to_user32(compat_siginfo_t __user *to, const ksiginfo_t *from)
+{
+	int err = 0;
+	if (!from->q) {
+		if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
+			return -EFAULT;
+		put_user_try {
+			/* fast case */
+			put_user_ex(from->si_signo, &to->si_signo);
+			put_user_ex(0, &to->si_errno);
+			put_user_ex((short)from->si_code, &to->si_code);
+			put_user_ex(from->si_pid, &to->si_pid);
+			put_user_ex(from->si_uid, &to->si_uid);
+		} put_user_catch(err);
+		return err;
+	}
+	return __copy_siginfo_to_user32(to, &from->q->info);
+}
+
 int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 {
 	int err = 0;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 55298db..673ab73 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -201,10 +201,11 @@ static int sock_xmit(struct nbd_device *nbd, int send, void *buf, int size,
 						msg.msg_flags);
 
 		if (signal_pending(current)) {
-			siginfo_t info;
+			ksiginfo_t info;
 			printk(KERN_WARNING "nbd (pid %d: %s) got signal %d\n",
 				task_pid_nr(current), current->comm,
 				dequeue_signal_lock(current, &current->blocked, &info));
+			dismiss_siginfo(&info);
 			result = -EINTR;
 			sock_shutdown(nbd, !send);
 			break;
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b963939..ecacac5 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2337,7 +2337,7 @@ static void fsg_disable(struct usb_function *f)
 
 static void handle_exception(struct fsg_common *common)
 {
-	siginfo_t		info;
+	ksiginfo_t	info;
 	int			i;
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
@@ -2351,6 +2351,7 @@ static void handle_exception(struct fsg_common *common)
 	for (;;) {
 		int sig =
 			dequeue_signal_lock(current, &current->blocked, &info);
+		dismiss_siginfo(&info);
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 67be295..e79a23e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1371,7 +1371,7 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 }
 
 static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
-		const siginfo_t *siginfo)
+		const ksiginfo_t *siginfo)
 {
 	mm_segment_t old_fs = get_fs();
 	set_fs(KERNEL_DS);
@@ -1578,7 +1578,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const siginfo_t *siginfo, struct pt_regs *regs)
+			  const ksiginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -1827,7 +1827,7 @@ static int elf_note_info_init(struct elf_note_info *info)
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const siginfo_t *siginfo, struct pt_regs *regs)
+			  const ksiginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
 	struct core_thread *ct;
diff --git a/fs/coredump.c b/fs/coredump.c
index e3ad709..44ff98d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -484,7 +484,7 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
-void do_coredump(const siginfo_t *siginfo)
+void do_coredump(const ksiginfo_t *siginfo)
 {
 	struct core_state core_state;
 	struct core_name cn;
diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 2b60ce1..aefdff2 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -119,13 +119,14 @@ static int jffs2_garbage_collect_thread(void *_c)
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current) || freezing(current)) {
-			siginfo_t info;
+			ksiginfo_t info;
 			unsigned long signr;
 
 			if (try_to_freeze())
 				goto again;
 
 			signr = dequeue_signal_lock(current, &current->blocked, &info);
+			dismiss_siginfo(&info);
 
 			switch(signr) {
 			case SIGSTOP:
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 424b7b6..d6f3c47 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -78,8 +78,9 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
  * Copied from copy_siginfo_to_user() in kernel/signal.c
  */
 static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
-			     siginfo_t const *kinfo)
+			     const ksiginfo_t *from)
 {
+	const siginfo_t *kinfo;
 	long err;
 
 	BUILD_BUG_ON(sizeof(struct signalfd_siginfo) != 128);
@@ -89,6 +90,19 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 	 */
 	err = __clear_user(uinfo, sizeof(*uinfo));
 
+#ifdef CONFIG_ARCH_USES_KSIGNAL
+	if (!from->q) {
+		err |= __put_user(from->si_signo, &uinfo->ssi_signo);
+		err |= __put_user(0, &uinfo->ssi_errno);
+		err |= __put_user((short) from->si_code, &uinfo->ssi_code);
+		err |= __put_user(from->si_pid, &uinfo->ssi_pid);
+		err |= __put_user(from->si_uid, &uinfo->ssi_uid);
+		goto out;
+	}
+	kinfo = &from->q->info;
+#else
+	kinfo = from;
+#endif
 	/*
 	 * If you change siginfo_t structure, please be sure
 	 * this code is fixed accordingly.
@@ -152,10 +166,11 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 		break;
 	}
 
+out:
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
-static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
+static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, ksiginfo_t *info,
 				int nonblock)
 {
 	ssize_t ret;
@@ -207,7 +222,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
 	ssize_t ret, total = 0;
-	siginfo_t info;
+	ksiginfo_t info;
 
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
@@ -219,6 +234,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 		if (unlikely(ret <= 0))
 			break;
 		ret = signalfd_copyinfo(siginfo, &info);
+		dismiss_siginfo(&info);
 		if (ret < 0)
 			break;
 		siginfo++;
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 3d1a3af..43a6895 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -15,6 +15,11 @@
 #define __SI_CODE(T,N)	((T) | ((N) & 0xffff))
 
 struct siginfo;
+#ifndef CONFIG_ARCH_USES_KSIGNAL
+#define small_siginfo siginfo
+#else
+struct small_siginfo;
+#endif
 void do_schedule_next_timer(struct siginfo *info);
 
 #ifndef HAVE_ARCH_COPY_SIGINFO
@@ -32,6 +37,8 @@ static inline void copy_siginfo(struct siginfo *to, struct siginfo *from)
 
 #endif
 
-extern int copy_siginfo_to_user(struct siginfo __user *to, const struct siginfo *from);
+extern int copy_ksiginfo_from_user(struct small_siginfo *to, const struct siginfo __user *from);
+extern int copy_siginfo_to_user(struct siginfo __user *to, const struct small_siginfo *from);
+extern int __copy_siginfo_to_user(struct siginfo __user *to, const struct siginfo *from);
 
 #endif
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b4a745d..912d8d4 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -56,7 +56,7 @@ struct linux_binprm {
 
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
-	const siginfo_t *siginfo;
+	const ksiginfo_t *siginfo;
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 3f448c6..9ab31c9 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -362,7 +362,9 @@ long compat_get_bitmap(unsigned long *mask, const compat_ulong_t __user *umask,
 long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
 		       unsigned long bitmap_size);
 int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from);
-int copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *from);
+int copy_ksiginfo_from_user32(ksiginfo_t *to, struct compat_siginfo __user *from);
+int copy_siginfo_to_user32(struct compat_siginfo __user *to, const ksiginfo_t *from);
+int __copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
 long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index d016a12..3c9f79c 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -15,9 +15,9 @@ extern int dump_skip(struct coredump_params *cprm, size_t nr);
 extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 extern int dump_align(struct coredump_params *cprm, int align);
 #ifdef CONFIG_COREDUMP
-extern void do_coredump(const siginfo_t *siginfo);
+extern void do_coredump(const ksiginfo_t *siginfo);
 #else
-static inline void do_coredump(const siginfo_t *siginfo) {}
+static inline void do_coredump(const ksiginfo_t *siginfo) {}
 #endif
 
 #endif /* _LINUX_COREDUMP_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..60834bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1428,7 +1428,7 @@ struct task_struct {
 	struct io_context *io_context;
 
 	unsigned long ptrace_message;
-	siginfo_t *last_siginfo; /* For ptrace use.  */
+	ksiginfo_t *last_siginfo; /* For ptrace use.  */
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
@@ -2177,9 +2177,9 @@ extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, ksiginfo_t *info);
 
-static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, ksiginfo_t *info)
 {
 	unsigned long flags;
 	int ret;
@@ -2204,7 +2204,6 @@ extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
 				const struct cred *, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
-extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern __must_check bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..c999b4a 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -236,12 +236,29 @@ static inline int valid_signal(unsigned long sig)
 struct timespec;
 struct pt_regs;
 
+#ifdef CONFIG_ARCH_USES_KSIGNAL
+typedef struct small_siginfo {
+	int si_signo;
+	int si_code;
+	union { struct {	/* yecch... */
+		__kernel_pid_t _pid;
+		__ARCH_SI_UID_T _uid;
+	} _kill; } _sifields;
+	struct sigqueue *q;
+} ksiginfo_t;
+extern void dismiss_siginfo(ksiginfo_t *);
+#else
+#define small_siginfo siginfo
+#define ksiginfo_t siginfo_t
+#define dismiss_siginfo(info) ((void)0)
+#endif
+
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int do_send_sig_info(int sig, struct siginfo *info,
 				struct task_struct *p, bool group);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
-extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
+extern int do_sigtimedwait(const sigset_t *, ksiginfo_t *,
 				const struct timespec *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(sigset_t *);
@@ -281,13 +298,13 @@ struct old_sigaction {
 
 struct ksignal {
 	struct k_sigaction ka;
-	siginfo_t info;
+	ksiginfo_t info;
 	int sig;
 };
 
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal_to_deliver(ksiginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
-extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
+extern void signal_delivered(int sig, ksiginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 
 /*
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 1e98b55..c9e7a0e 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -146,7 +146,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
  * Called without locks, shortly before returning to user mode
  * (or handling more signals).
  */
-static inline void tracehook_signal_handler(int sig, siginfo_t *info,
+static inline void tracehook_signal_handler(int sig, ksiginfo_t *info,
 					    const struct k_sigaction *ka,
 					    struct pt_regs *regs, int stepping)
 {
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 39a8a43..1494a3e 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -23,6 +23,27 @@
 		}						\
 	} while (0)
 
+#ifndef CONFIG_ARCH_USES_KSIGNAL
+#define TP_SI_ERRNO(info)	info->si_errno
+#else
+#define TP_SI_ERRNO(info)	info->q ? info->q->info.si_errno : 0
+#endif
+
+#define TP_STORE_KSIGINFO(__entry, info)			\
+	do {							\
+		if (info == (ksiginfo_t *)SEND_SIG_NOINFO ||	\
+		    info == (ksiginfo_t *)SEND_SIG_FORCED) {	\
+			__entry->errno	= 0;			\
+			__entry->code	= SI_USER;		\
+		} else if (info == (ksiginfo_t *)SEND_SIG_PRIV) {\
+			__entry->errno	= 0;			\
+			__entry->code	= SI_KERNEL;		\
+		} else {					\
+			__entry->errno	= TP_SI_ERRNO(info);	\
+			__entry->code	= info->si_code;	\
+		}						\
+	} while (0)
+
 #ifndef TRACE_HEADER_MULTI_READ
 enum {
 	TRACE_SIGNAL_DELIVERED,
@@ -95,7 +116,7 @@ TRACE_EVENT(signal_generate,
  */
 TRACE_EVENT(signal_deliver,
 
-	TP_PROTO(int sig, struct siginfo *info, struct k_sigaction *ka),
+	TP_PROTO(int sig, ksiginfo_t *info, struct k_sigaction *ka),
 
 	TP_ARGS(sig, info, ka),
 
@@ -109,7 +130,7 @@ TRACE_EVENT(signal_deliver,
 
 	TP_fast_assign(
 		__entry->sig	= sig;
-		TP_STORE_SIGINFO(__entry, info);
+		TP_STORE_KSIGINFO(__entry, info);
 		__entry->sa_handler	= (unsigned long)ka->sa.sa_handler;
 		__entry->sa_flags	= ka->sa.sa_flags;
 	),
diff --git a/kernel/compat.c b/kernel/compat.c
index 0a09e48..82084b4 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -579,7 +579,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 
 	BUG_ON(info.si_code & __SI_MASK);
 	info.si_code |= __SI_CHLD;
-	return copy_siginfo_to_user32(uinfo, &info);
+	return __copy_siginfo_to_user32(uinfo, &info);
 }
 
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
@@ -981,7 +981,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 	compat_sigset_t s32;
 	sigset_t s;
 	struct timespec t;
-	siginfo_t info;
+	ksiginfo_t info;
 	long ret;
 
 	if (sigsetsize != sizeof(sigset_t))
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1f4bcb3..11223d4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -589,7 +589,7 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 	return 0;
 }
 
-static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
+static int ptrace_getsiginfo(struct task_struct *child, ksiginfo_t *info)
 {
 	unsigned long flags;
 	int error = -ESRCH;
@@ -605,7 +605,7 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 	return error;
 }
 
-static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
+static int ptrace_setsiginfo(struct task_struct *child, ksiginfo_t *info)
 {
 	unsigned long flags;
 	int error = -ESRCH;
@@ -613,11 +613,14 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
 		if (likely(child->last_siginfo != NULL)) {
+			dismiss_siginfo(child->last_siginfo);
 			*child->last_siginfo = *info;
 			error = 0;
 		}
 		unlock_task_sighand(child, &flags);
 	}
+	if (error)
+		dismiss_siginfo(info);
 	return error;
 }
 
@@ -666,7 +669,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		if (unlikely(is_compat_task())) {
 			compat_siginfo_t __user *uinfo = compat_ptr(data);
 
-			if (copy_siginfo_to_user32(uinfo, &info) ||
+			if (__copy_siginfo_to_user32(uinfo, &info) ||
 			    __put_user(info.si_code, &uinfo->si_code)) {
 				ret = -EFAULT;
 				break;
@@ -677,7 +680,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		{
 			siginfo_t __user *uinfo = (siginfo_t __user *) data;
 
-			if (copy_siginfo_to_user(uinfo, &info) ||
+			if (__copy_siginfo_to_user(uinfo, &info) ||
 			    __put_user(info.si_code, &uinfo->si_code)) {
 				ret = -EFAULT;
 				break;
@@ -805,7 +808,7 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	bool seized = child->ptrace & PT_SEIZED;
 	int ret = -EIO;
-	siginfo_t siginfo, *si;
+	ksiginfo_t siginfo, *si;
 	void __user *datavp = (void __user *) data;
 	unsigned long __user *datalp = datavp;
 	unsigned long flags;
@@ -839,9 +842,8 @@ int ptrace_request(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_SETSIGINFO:
-		if (copy_from_user(&siginfo, datavp, sizeof siginfo))
-			ret = -EFAULT;
-		else
+		ret = copy_ksiginfo_from_user(&siginfo, datavp);
+		if (!ret)
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
@@ -1107,7 +1109,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 {
 	compat_ulong_t __user *datap = compat_ptr(data);
 	compat_ulong_t word;
-	siginfo_t siginfo;
+	ksiginfo_t siginfo;
 	int ret;
 
 	switch (request) {
@@ -1139,8 +1141,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		break;
 
 	case PTRACE_SETSIGINFO:
-		memset(&siginfo, 0, sizeof siginfo);
-		if (copy_siginfo_from_user32(
+		if (copy_ksiginfo_from_user32(
 			    &siginfo, (struct compat_siginfo __user *) datap))
 			ret = -EFAULT;
 		else
diff --git a/kernel/signal.c b/kernel/signal.c
index 48cf9fc..2b641aa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -540,7 +540,18 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
+#ifdef CONFIG_ARCH_USES_KSIGNAL
+void dismiss_siginfo(ksiginfo_t *info)
+{
+	if (info->q)
+		__sigqueue_free(info->q);
+	info->q = NULL;
+}
+EXPORT_SYMBOL(dismiss_siginfo);
+#endif
+
+static void collect_signal(int sig, struct sigpending *list,
+			   ksiginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
 
@@ -561,8 +572,14 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 	if (first) {
 still_pending:
 		list_del_init(&first->list);
+#ifndef CONFIG_ARCH_USES_KSIGNAL
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
+#else
+		info->si_signo = sig;
+		info->si_code = first->info.si_code;
+		info->q = first;
+#endif
 	} else {
 		/*
 		 * Ok, it wasn't in the queue.  This must be
@@ -570,15 +587,19 @@ still_pending:
 		 * out of queue space.  So zero out the info.
 		 */
 		info->si_signo = sig;
-		info->si_errno = 0;
 		info->si_code = SI_USER;
 		info->si_pid = 0;
 		info->si_uid = 0;
+#ifndef CONFIG_ARCH_USES_KSIGNAL
+		info->si_errno = 0;
+#else
+		info->q = NULL;
+#endif
 	}
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
-			siginfo_t *info)
+			ksiginfo_t *info)
 {
 	int sig = next_signal(pending, mask);
 
@@ -604,7 +625,7 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+int dequeue_signal(struct task_struct *tsk, sigset_t *mask, ksiginfo_t *info)
 {
 	int signr;
 
@@ -659,7 +680,12 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 */
 		current->jobctl |= JOBCTL_STOP_DEQUEUED;
 	}
+#ifndef CONFIG_ARCH_USES_KSIGNAL
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
+#else
+	if ((info->si_code & __SI_MASK) == __SI_TIMER &&
+	    info->q->info.si_sys_private) {
+#endif
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
@@ -667,7 +693,11 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 * about to disable them again anyway.
 		 */
 		spin_unlock(&tsk->sighand->siglock);
+#ifndef CONFIG_ARCH_USES_KSIGNAL
 		do_schedule_next_timer(info);
+#else
+		do_schedule_next_timer(&info->q->info);
+#endif
 		spin_lock(&tsk->sighand->siglock);
 	}
 	return signr;
@@ -1836,7 +1866,8 @@ static int sigkill_pending(struct task_struct *tsk)
  * If we actually decide not to stop at all because the tracer
  * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int why, int clear_code,
+			ksiginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
@@ -1960,16 +1991,17 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 
 static void ptrace_do_notify(int signr, int exit_code, int why)
 {
-	siginfo_t info;
+	ksiginfo_t info;
 
-	memset(&info, 0, sizeof info);
 	info.si_signo = signr;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
 	info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+	info.q = NULL;
 
 	/* Let the debugger run.  */
 	ptrace_stop(exit_code, why, 1, &info);
+	dismiss_siginfo(&info);
 }
 
 void ptrace_notify(int exit_code)
@@ -2141,7 +2173,7 @@ static void do_jobctl_trap(void)
 	}
 }
 
-static int ptrace_signal(int signr, siginfo_t *info)
+static int ptrace_signal(int signr, ksiginfo_t *info)
 {
 	ptrace_signal_deliver();
 	/*
@@ -2170,8 +2202,11 @@ static int ptrace_signal(int signr, siginfo_t *info)
 	 * have updated *info via PTRACE_SETSIGINFO.
 	 */
 	if (signr != info->si_signo) {
+		dismiss_siginfo(info);
 		info->si_signo = signr;
+#ifndef CONFIG_ARCH_USES_KSIGNAL
 		info->si_errno = 0;
+#endif
 		info->si_code = SI_USER;
 		rcu_read_lock();
 		info->si_pid = task_pid_vnr(current->parent);
@@ -2182,14 +2217,25 @@ static int ptrace_signal(int signr, siginfo_t *info)
 
 	/* If the (new) signal is now blocked, requeue it.  */
 	if (sigismember(&current->blocked, signr)) {
+#ifndef CONFIG_ARCH_USES_KSIGNAL
 		specific_send_sig_info(signr, info, current);
+#else
+		if (!info->q) {
+			struct siginfo s = {.si_code = info->si_code,
+					    .si_signo = signr,
+					    .si_pid = info->si_pid,
+					    .si_uid = info->si_uid};
+			specific_send_sig_info(signr, &s, current);
+		} else
+			specific_send_sig_info(signr, &info->q->info, current);
+#endif
 		signr = 0;
 	}
 
 	return signr;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
+int get_signal_to_deliver(ksiginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
 	struct sighand_struct *sighand = current->sighand;
@@ -2363,6 +2409,7 @@ relock:
 			 */
 			do_coredump(info);
 		}
+		dismiss_siginfo(info);
 
 		/*
 		 * Death signals, no core dump.
@@ -2377,7 +2424,7 @@ relock:
 /**
  * signal_delivered - 
  * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
+ * @info:		ksiginfo_t of signal being delivered
  * @ka:			sigaction setting that chose the handler
  * @regs:		user register state
  * @stepping:		nonzero if debugger single-step or block-step in use
@@ -2387,7 +2434,7 @@ relock:
  * is always blocked, and the signal itself is blocked unless %SA_NODEFER
  * is set in @ka->sa.sa_flags.  Tracing is notified.
  */
-void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
+void signal_delivered(int sig, ksiginfo_t *info, struct k_sigaction *ka,
 			struct pt_regs *regs, int stepping)
 {
 	sigset_t blocked;
@@ -2412,6 +2459,7 @@ void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
 	else
 		signal_delivered(ksig->sig, &ksig->info, &ksig->ka,
 			signal_pt_regs(), stepping);
+	dismiss_siginfo(&ksig->info);
 }
 
 /*
@@ -2721,7 +2769,7 @@ COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
 }
 #endif
 
-int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
+int __copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 {
 	int err;
 
@@ -2804,13 +2852,35 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 	return err;
 }
 
+int copy_siginfo_to_user(siginfo_t __user *to, const ksiginfo_t *from)
+{
+	const siginfo_t *info;
+#ifdef CONFIG_ARCH_USES_KSIGNAL
+	if (!from->q) {
+		int err;
+		if (!access_ok (VERIFY_WRITE, to, sizeof(siginfo_t)))
+			return -EFAULT;
+		err = __put_user(from->si_signo, &to->si_signo);
+		err |= __put_user(0, &to->si_errno);
+		err |= __put_user((short) from->si_code, &to->si_code);
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		return err;
+	}
+	info = &from->q->info;
+#else
+	info = from;
+#endif
+	return __copy_siginfo_to_user(to, info);
+}
+
 /**
  *  do_sigtimedwait - wait for queued signals specified in @which
  *  @which: queued signals to wait for
  *  @info: if non-null, the signal's siginfo is returned here
  *  @ts: upper bound on process time suspension
  */
-int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
+int do_sigtimedwait(const sigset_t *which, ksiginfo_t *info,
 			const struct timespec *ts)
 {
 	struct task_struct *tsk = current;
@@ -2878,7 +2948,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 {
 	sigset_t these;
 	struct timespec ts;
-	siginfo_t info;
+	ksiginfo_t info;
 	int ret;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
@@ -2999,6 +3069,73 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int, sig)
 	return do_tkill(0, pid, sig);
 }
 
+int copy_ksiginfo_from_user(ksiginfo_t *to, const siginfo_t __user *from)
+{
+#ifndef CONFIG_ARCH_USES_KSIGNAL
+	return copy_from_user(to, from, sizeof(siginfo_t)) ? -EFAULT : 0;
+#else
+	struct sigqueue *q;
+	if (!access_ok(VERIFY_READ, from, sizeof(siginfo_t)))
+		return -EFAULT;
+	if (__get_user(to->si_code, &from->si_code))
+		return -EFAULT;
+	if (to->si_code == SI_USER) {
+		if (__get_user(to->si_signo, &from->si_signo) ||
+		    __get_user(to->si_uid, &from->si_uid) ||
+		    __get_user(to->si_pid, &from->si_pid))
+			return -EFAULT;
+		to->q = NULL;
+		return 0;
+	}
+	q = __sigqueue_alloc(-1, current, GFP_KERNEL, 0);
+	if (!q)
+		return -ENOMEM;
+	if (copy_from_user(&q->info, from, sizeof(siginfo_t))) {
+		__sigqueue_free(q);
+		return -EFAULT;
+	}
+	to->q = q;
+	to->si_code = q->info.si_code;
+	to->si_signo = q->info.si_signo;
+	return 0;
+#endif
+}
+
+#ifdef CONFIG_COMPAT
+
+int copy_ksiginfo_from_user32(ksiginfo_t *to, compat_siginfo_t __user *from)
+{
+#ifndef CONFIG_ARCH_USES_KSIGNAL
+	return copy_siginfo_from_user32(to, from);
+#else
+	struct sigqueue *q;
+	if (!access_ok(VERIFY_READ, from, sizeof(compat_siginfo_t)))
+		return -EFAULT;
+	if (__get_user(to->si_code, &from->si_code))
+		return -EFAULT;
+	if (to->si_code == SI_USER) {
+		if (__get_user(to->si_signo, &from->si_signo) ||
+		    __get_user(to->si_uid, &from->si_uid) ||
+		    __get_user(to->si_pid, &from->si_pid))
+			return -EFAULT;
+		to->q = NULL;
+		return 0;
+	}
+	q = __sigqueue_alloc(-1, current, GFP_KERNEL, 0);
+	if (!q)
+		return -ENOMEM;
+	if (copy_siginfo_from_user32(&q->info, from)) {
+		__sigqueue_free(q);
+		return -EFAULT;
+	}
+	to->q = q;
+	to->si_code = q->info.si_code;
+	to->si_signo = q->info.si_signo;
+	return 0;
+#endif
+}
+#endif
+
 static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
 {
 	/* Not even root can pretend to send signals from the kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
