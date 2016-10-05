Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42960 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbcJEUF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 16:05:29 -0400
Date: Wed, 5 Oct 2016 21:05:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161005200522.GE19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20161003013737.GR19539@ZenIV.linux.org.uk>
 <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com>
 <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com>
 <20161004214219.GN4205@htj.duckdns.org>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org>
 <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Wed, Oct 05, 2016 at 02:57:04PM -0400, CAI Qian wrote:

> Not sure if this related, and there is always a lockdep regards procfs happened
> below unless masking by other lockdep issues before the cgroup hang. Also, this
> hang is always reproducible.

Sigh...  Let's get the /proc/*/auxv out of the way - this should deal with it:

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d588d14..489d2d6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -400,23 +400,6 @@ static const struct file_operations proc_pid_cmdline_ops = {
 	.llseek	= generic_file_llseek,
 };
 
-static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
-			 struct pid *pid, struct task_struct *task)
-{
-	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
-	if (mm && !IS_ERR(mm)) {
-		unsigned int nwords = 0;
-		do {
-			nwords += 2;
-		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
-		seq_write(m, mm->saved_auxv, nwords * sizeof(mm->saved_auxv[0]));
-		mmput(mm);
-		return 0;
-	} else
-		return PTR_ERR(mm);
-}
-
-
 #ifdef CONFIG_KALLSYMS
 /*
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
@@ -1014,6 +997,30 @@ static const struct file_operations proc_environ_operations = {
 	.release	= mem_release,
 };
 
+static int auxv_open(struct inode *inode, struct file *file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
+}
+
+static ssize_t auxv_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct mm_struct *mm = file->private_data;
+	unsigned int nwords = 0;
+	do {
+		nwords += 2;
+	} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
+	return simple_read_from_buffer(buf, count, ppos, mm->saved_auxv,
+				       nwords * sizeof(mm->saved_auxv[0]));
+}
+
+static const struct file_operations proc_auxv_operations = {
+	.open		= auxv_open,
+	.read		= auxv_read,
+	.llseek		= generic_file_llseek,
+	.release	= mem_release,
+};
+
 static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
@@ -2822,7 +2829,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
-	ONE("auxv",       S_IRUSR, proc_pid_auxv),
+	REG("auxv",       S_IRUSR, proc_auxv_operations),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	ONE("limits",	  S_IRUGO, proc_pid_limits),
@@ -3210,7 +3217,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",   S_IRUSR, proc_environ_operations),
-	ONE("auxv",      S_IRUSR, proc_pid_auxv),
+	REG("auxv",      S_IRUSR, proc_auxv_operations),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	ONE("limits",	 S_IRUGO, proc_pid_limits),
