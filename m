Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 243B37F69
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE98DAC010
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:13 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xMrJCKkF41P2eCrn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] lockdep: Dump info via tracing
Date: Fri, 10 Oct 2014 16:23:25 +0200
Message-Id: <1412951028-4085-21-git-send-email-jack@suse.cz>
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

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/locking/lockdep.c | 707 +++++++++++++++++++++++++++--------------------
 1 file changed, 402 insertions(+), 305 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e4339b46d..b15e7dec55f6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -77,6 +77,26 @@ module_param(lock_stat, int, 0644);
  */
 static arch_spinlock_t lockdep_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+static void sprint_ip_sym(char *buf, unsigned long ip)
+{
+	sprintf(buf, "[<%p>] %pS\n", (void *) ip, (void *) ip);
+}
+
+static void trace_print_stack_trace(struct stack_trace *trace, int spaces)
+{
+	int i, n;
+	char buf[256];
+
+	if (!trace->entries)
+		return;
+
+	for (i = 0; i < trace->nr_entries; i++) {
+		n = sprintf(buf, "%*c", 1 + spaces, ' ');
+		sprint_ip_sym(buf + n, trace->entries[i]);
+		trace_printk(buf);
+	}
+}
+
 static int graph_lock(void)
 {
 	arch_spin_lock(&lockdep_lock);
@@ -382,9 +402,9 @@ static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
 static void print_lockdep_off(const char *bug_msg)
 {
-	printk(KERN_DEBUG "%s\n", bug_msg);
-	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
-	printk(KERN_DEBUG "Please attach the output of /proc/lock_stat to the bug report\n");
+	trace_printk("%s\n", bug_msg);
+	trace_printk("turning off the locking correctness validator.\n");
+	trace_printk("Please attach the output of /proc/lock_stat to the bug report\n");
 }
 
 static int save_trace(struct stack_trace *trace)
@@ -417,7 +437,7 @@ static int save_trace(struct stack_trace *trace)
 			return 0;
 
 		print_lockdep_off("BUG: MAX_STACK_TRACE_ENTRIES too low!");
-		dump_stack();
+		trace_dump_stack(0);
 
 		return 0;
 	}
@@ -506,7 +526,7 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
-static void __print_lock_name(struct lock_class *class)
+static void __sprint_lock_name(char *buf, struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN];
 	const char *name;
@@ -514,28 +534,28 @@ static void __print_lock_name(struct lock_class *class)
 	name = class->name;
 	if (!name) {
 		name = __get_key_name(class->key, str);
-		printk("%s", name);
+		strcpy(buf, name);
 	} else {
-		printk("%s", name);
+		strcpy(buf, name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
+			sprintf(buf + strlen(buf), "#%d", class->name_version);
 		if (class->subclass)
-			printk("/%d", class->subclass);
+			sprintf(buf + strlen(buf), "/%d", class->subclass);
 	}
 }
 
-static void print_lock_name(struct lock_class *class)
+static void sprint_lock_name(char *buf, struct lock_class *class)
 {
 	char usage[LOCK_USAGE_CHARS];
 
 	get_usage_chars(class, usage);
 
-	printk(" (");
-	__print_lock_name(class);
-	printk("){%s}", usage);
+	strcpy(buf, " (");
+	__sprint_lock_name(buf, class);
+	sprintf(buf + strlen(buf), "){%s}", usage);
 }
 
-static void print_lockdep_cache(struct lockdep_map *lock)
+static void sprint_lockdep_cache(char *buf, struct lockdep_map *lock)
 {
 	const char *name;
 	char str[KSYM_NAME_LEN];
@@ -544,14 +564,14 @@ static void print_lockdep_cache(struct lockdep_map *lock)
 	if (!name)
 		name = __get_key_name(lock->key->subkeys, str);
 
-	printk("%s", name);
+	strcpy(buf, name);
 }
 
-static void print_lock(struct held_lock *hlock)
+static void sprint_lock(char *buf, struct held_lock *hlock)
 {
-	print_lock_name(hlock_class(hlock));
-	printk(", at: ");
-	print_ip_sym(hlock->acquire_ip);
+	sprint_lock_name(buf, hlock_class(hlock));
+	strcat(buf, ", at: ");
+	sprint_ip_sym(buf + strlen(buf), hlock->acquire_ip);
 }
 
 static void lockdep_print_held_locks(struct task_struct *curr)
@@ -559,21 +579,24 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	int i, depth = curr->lockdep_depth;
 
 	if (!depth) {
-		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
+		trace_printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
-	printk("%d lock%s held by %s/%d:\n",
+	trace_printk("%d lock%s held by %s/%d:\n",
 		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
-		printk(" #%d: ", i);
-		print_lock(curr->held_locks + i);
+		char buf[256];
+
+		sprintf(buf, " #%d: ", i);
+		sprint_lock(buf + strlen(buf), curr->held_locks + i);
+		trace_printk(buf);
 	}
 }
 
 static void print_kernel_ident(void)
 {
-	printk("%s %.*s %s\n", init_utsname()->release,
+	trace_printk("%s %.*s %s\n", init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version,
 		print_tainted());
@@ -669,11 +692,11 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 
 	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
 		debug_locks_off();
-		printk(KERN_ERR
+		trace_printk(
 			"BUG: looking up invalid subclass: %u\n", subclass);
-		printk(KERN_ERR
+		trace_printk(KERN_ERR
 			"turning off the locking correctness validator.\n");
-		dump_stack();
+		trace_dump_stack(0);
 		return NULL;
 	}
 
@@ -737,10 +760,10 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
  	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
-		printk("INFO: trying to register non-static key.\n");
-		printk("the code is fine but needs lockdep annotation.\n");
-		printk("turning off the locking correctness validator.\n");
-		dump_stack();
+		trace_printk("INFO: trying to register non-static key.\n");
+		trace_printk("the code is fine but needs lockdep annotation.\n");
+		trace_printk("turning off the locking correctness validator.\n");
+		trace_dump_stack(0);
 
 		return NULL;
 	}
@@ -772,7 +795,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		raw_local_irq_restore(flags);
 
 		print_lockdep_off("BUG: MAX_LOCKDEP_KEYS too low!");
-		dump_stack();
+		trace_dump_stack(0);
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
@@ -798,11 +821,11 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		graph_unlock();
 		raw_local_irq_restore(flags);
 
-		printk("\nnew class %p: %s", class->key, class->name);
+		trace_printk("\nnew class %p: %s", class->key, class->name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		printk("\n");
-		dump_stack();
+			trace_printk("#%d", class->name_version);
+		trace_printk("\n");
+		trace_dump_stack(0);
 
 		raw_local_irq_save(flags);
 		if (!graph_lock()) {
@@ -842,7 +865,7 @@ static struct lock_list *alloc_list_entry(void)
 			return NULL;
 
 		print_lockdep_off("BUG: MAX_LOCKDEP_ENTRIES too low!");
-		dump_stack();
+		trace_dump_stack(0);
 		return NULL;
 	}
 	return list_entries + nr_list_entries++;
@@ -1078,12 +1101,15 @@ static inline int __bfs_backwards(struct lock_list *src_entry,
 static noinline int
 print_circular_bug_entry(struct lock_list *target, int depth)
 {
+	char buf[256];
+
 	if (debug_locks_silent)
 		return 0;
-	printk("\n-> #%u", depth);
-	print_lock_name(target->class);
-	printk(":\n");
-	print_stack_trace(&target->trace, 6);
+	sprintf(buf, "\n-> #%u", depth);
+	sprint_lock_name(buf + strlen(buf), target->class);
+	strcat(buf, ":\n");
+	trace_printk(buf);
+	trace_print_stack_trace(&target->trace, 6);
 
 	return 0;
 }
@@ -1096,6 +1122,7 @@ print_circular_lock_scenario(struct held_lock *src,
 	struct lock_class *source = hlock_class(src);
 	struct lock_class *target = hlock_class(tgt);
 	struct lock_class *parent = prt->class;
+	char buf[256];
 
 	/*
 	 * A direct locking problem where unsafe_class lock is taken
@@ -1111,31 +1138,36 @@ print_circular_lock_scenario(struct held_lock *src,
 	 * from the safe_class lock to the unsafe_class lock.
 	 */
 	if (parent != source) {
-		printk("Chain exists of:\n  ");
-		__print_lock_name(source);
-		printk(" --> ");
-		__print_lock_name(parent);
-		printk(" --> ");
-		__print_lock_name(target);
-		printk("\n\n");
+		trace_printk("Chain exists of:\n  ");
+		__sprint_lock_name(buf, source);
+		strcat(buf, " --> ");
+		__sprint_lock_name(buf + strlen(buf), parent);
+		strcat(buf, " --> ");
+		__sprint_lock_name(buf + strlen(buf), target);
+		strcat(buf, "\n\n");
+		trace_printk(buf);
 	}
 
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0                    CPU1\n");
-	printk("       ----                    ----\n");
-	printk("  lock(");
-	__print_lock_name(target);
-	printk(");\n");
-	printk("                               lock(");
-	__print_lock_name(parent);
-	printk(");\n");
-	printk("                               lock(");
-	__print_lock_name(target);
-	printk(");\n");
-	printk("  lock(");
-	__print_lock_name(source);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	trace_printk(" Possible unsafe locking scenario:\n\n");
+	trace_printk("       CPU0                    CPU1\n");
+	trace_printk("       ----                    ----\n");
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), target);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	strcpy(buf, "                               lock(");
+	__sprint_lock_name(buf + strlen(buf), parent);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	strcpy(buf, "                               lock(");
+	__sprint_lock_name(buf + strlen(buf), target);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), source);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("\n *** DEADLOCK ***\n\n");
 }
 
 /*
@@ -1148,22 +1180,25 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 			struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
+	char buf[256];
 
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("======================================================\n");
-	printk("[ INFO: possible circular locking dependency detected ]\n");
+	trace_printk("\n");
+	trace_printk("======================================================\n");
+	trace_printk("[ INFO: possible circular locking dependency detected ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------------------------\n");
-	printk("%s/%d is trying to acquire lock:\n",
+	trace_printk("-------------------------------------------------------\n");
+	sprintf(buf, "%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
-	print_lock(check_src);
-	printk("\nbut task is already holding lock:\n");
-	print_lock(check_tgt);
-	printk("\nwhich lock already depends on the new lock.\n\n");
-	printk("\nthe existing dependency chain (in reverse order) is:\n");
+	sprint_lock(buf + strlen(buf), check_src);
+	trace_printk(buf);
+	trace_printk("\nbut task is already holding lock:\n");
+	sprint_lock(buf, check_tgt);
+	trace_printk(buf);
+	trace_printk("\nwhich lock already depends on the new lock.\n\n");
+	trace_printk("\nthe existing dependency chain (in reverse order) is:\n");
 
 	print_circular_bug_entry(entry, depth);
 
@@ -1203,14 +1238,14 @@ static noinline int print_circular_bug(struct lock_list *this,
 		parent = get_lock_parent(parent);
 	}
 
-	printk("\nother info that might help us debug this:\n\n");
+	trace_printk("\nother info that might help us debug this:\n\n");
 	print_circular_lock_scenario(check_src, check_tgt,
 				     first_parent);
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -1367,25 +1402,28 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 static void print_lock_class_header(struct lock_class *class, int depth)
 {
 	int bit;
+	char buf[256];
 
-	printk("%*s->", depth, "");
-	print_lock_name(class);
-	printk(" ops: %lu", class->ops);
-	printk(" {\n");
+	sprintf(buf, "%*s->", depth, "");
+	sprint_lock_name(buf + strlen(buf), class);
+	sprintf(buf + strlen(buf), " ops: %lu {\n", class->ops);
+	trace_printk(buf);
 
 	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
 		if (class->usage_mask & (1 << bit)) {
 			int len = depth;
 
-			len += printk("%*s   %s", depth, "", usage_str[bit]);
-			len += printk(" at:\n");
-			print_stack_trace(class->usage_traces + bit, len);
+			len += sprintf(buf, "%*s   %s", depth, "", usage_str[bit]);
+			len += sprintf(buf + strlen(buf), " at:\n");
+			trace_printk(buf);
+			trace_print_stack_trace(class->usage_traces + bit, len);
 		}
 	}
-	printk("%*s }\n", depth, "");
+	trace_printk("%*s }\n", depth, "");
 
-	printk("%*s ... key      at: ",depth,"");
-	print_ip_sym((unsigned long)class->key);
+	sprintf(buf, "%*s ... key      at: ",depth,"");
+	sprint_ip_sym(buf + strlen(buf), (unsigned long)class->key);
+	trace_printk(buf);
 }
 
 /*
@@ -1403,12 +1441,12 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 
 	do {
 		print_lock_class_header(entry->class, depth);
-		printk("%*s ... acquired at:\n", depth, "");
-		print_stack_trace(&entry->trace, 2);
-		printk("\n");
+		trace_printk("%*s ... acquired at:\n", depth, "");
+		trace_print_stack_trace(&entry->trace, 2);
+		trace_printk("\n");
 
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			trace_printk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 
@@ -1428,6 +1466,7 @@ print_irq_lock_scenario(struct lock_list *safe_entry,
 	struct lock_class *safe_class = safe_entry->class;
 	struct lock_class *unsafe_class = unsafe_entry->class;
 	struct lock_class *middle_class = prev_class;
+	char buf[256];
 
 	if (middle_class == safe_class)
 		middle_class = next_class;
@@ -1446,33 +1485,39 @@ print_irq_lock_scenario(struct lock_list *safe_entry,
 	 * from the safe_class lock to the unsafe_class lock.
 	 */
 	if (middle_class != unsafe_class) {
-		printk("Chain exists of:\n  ");
-		__print_lock_name(safe_class);
-		printk(" --> ");
-		__print_lock_name(middle_class);
-		printk(" --> ");
-		__print_lock_name(unsafe_class);
-		printk("\n\n");
+		trace_printk("Chain exists of:\n");
+		strcpy(buf, "  ");
+		__sprint_lock_name(buf + strlen(buf), safe_class);
+		strcat(buf, " --> ");
+		__sprint_lock_name(buf + strlen(buf), middle_class);
+		strcat(buf, " --> ");
+		__sprint_lock_name(buf + strlen(buf), unsafe_class);
+		strcat(buf, "\n\n");
+		trace_printk(buf);
 	}
 
-	printk(" Possible interrupt unsafe locking scenario:\n\n");
-	printk("       CPU0                    CPU1\n");
-	printk("       ----                    ----\n");
-	printk("  lock(");
-	__print_lock_name(unsafe_class);
-	printk(");\n");
-	printk("                               local_irq_disable();\n");
-	printk("                               lock(");
-	__print_lock_name(safe_class);
-	printk(");\n");
-	printk("                               lock(");
-	__print_lock_name(middle_class);
-	printk(");\n");
-	printk("  <Interrupt>\n");
-	printk("    lock(");
-	__print_lock_name(safe_class);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	trace_printk(" Possible interrupt unsafe locking scenario:\n\n");
+	trace_printk("       CPU0                    CPU1\n");
+	trace_printk("       ----                    ----\n");
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), unsafe_class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("                               local_irq_disable();\n");
+	strcpy(buf, "                               lock(");
+	__sprint_lock_name(buf + strlen(buf), safe_class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	strcpy(buf, "                               lock(");
+	__sprint_lock_name(buf + strlen(buf), middle_class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("  <Interrupt>\n");
+	strcpy(buf, "    lock(");
+	__sprint_lock_name(buf + strlen(buf), safe_class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("\n *** DEADLOCK ***\n\n");
 }
 
 static int
@@ -1487,65 +1532,74 @@ print_bad_irq_dependency(struct task_struct *curr,
 			 enum lock_usage_bit bit2,
 			 const char *irqclass)
 {
+	char buf[256];
+
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("======================================================\n");
-	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
+	trace_printk("\n");
+	trace_printk("======================================================\n");
+	trace_printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
 	print_kernel_ident();
-	printk("------------------------------------------------------\n");
-	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
+	trace_printk("------------------------------------------------------\n");
+	trace_printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
 		curr->hardirq_context, hardirq_count() >> HARDIRQ_SHIFT,
 		curr->softirq_context, softirq_count() >> SOFTIRQ_SHIFT,
 		curr->hardirqs_enabled,
 		curr->softirqs_enabled);
-	print_lock(next);
-
-	printk("\nand this task is already holding:\n");
-	print_lock(prev);
-	printk("which would create a new lock dependency:\n");
-	print_lock_name(hlock_class(prev));
-	printk(" ->");
-	print_lock_name(hlock_class(next));
-	printk("\n");
-
-	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
+	sprint_lock(buf, next);
+	trace_printk(buf);
+
+	trace_printk("\nand this task is already holding:\n");
+	sprint_lock(buf, prev);
+	trace_printk(buf);
+	trace_printk("which would create a new lock dependency:\n");
+	sprint_lock_name(buf, hlock_class(prev));
+	strcat(buf, " ->");
+	sprint_lock_name(buf + strlen(buf), hlock_class(next));
+	strcat(buf, "\n");
+	trace_printk(buf);
+
+	trace_printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
 		irqclass);
-	print_lock_name(backwards_entry->class);
-	printk("\n... which became %s-irq-safe at:\n", irqclass);
+	sprint_lock_name(buf, backwards_entry->class);
+	strcat(buf, "\n");
+	trace_printk(buf);
+	trace_printk("... which became %s-irq-safe at:\n", irqclass);
 
-	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
+	trace_print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
 
-	printk("\nto a %s-irq-unsafe lock:\n", irqclass);
-	print_lock_name(forwards_entry->class);
-	printk("\n... which became %s-irq-unsafe at:\n", irqclass);
-	printk("...");
+	trace_printk("\nto a %s-irq-unsafe lock:\n", irqclass);
+	sprint_lock_name(buf, forwards_entry->class);
+	strcat(buf, "\n");
+	trace_printk(buf);
+	trace_printk("... which became %s-irq-unsafe at:\n", irqclass);
+	trace_printk("...");
 
-	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
+	trace_print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
-	printk("\nother info that might help us debug this:\n\n");
+	trace_printk("\nother info that might help us debug this:\n\n");
 	print_irq_lock_scenario(backwards_entry, forwards_entry,
 				hlock_class(prev), hlock_class(next));
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
-	printk(" and the holding lock:\n");
+	trace_printk("\nthe dependencies between %s-irq-safe lock", irqclass);
+	trace_printk(" and the holding lock:\n");
 	if (!save_trace(&prev_root->trace))
 		return 0;
 	print_shortest_lock_dependencies(backwards_entry, prev_root);
 
-	printk("\nthe dependencies between the lock to be acquired");
-	printk(" and %s-irq-unsafe lock:\n", irqclass);
+	trace_printk("\nthe dependencies between the lock to be acquired");
+	trace_printk(" and %s-irq-unsafe lock:\n", irqclass);
 	if (!save_trace(&next_root->trace))
 		return 0;
 	print_shortest_lock_dependencies(forwards_entry, next_root);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -1699,44 +1753,51 @@ print_deadlock_scenario(struct held_lock *nxt,
 {
 	struct lock_class *next = hlock_class(nxt);
 	struct lock_class *prev = hlock_class(prv);
-
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0\n");
-	printk("       ----\n");
-	printk("  lock(");
-	__print_lock_name(prev);
-	printk(");\n");
-	printk("  lock(");
-	__print_lock_name(next);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
-	printk(" May be due to missing lock nesting notation\n\n");
+	char buf[256];
+
+	trace_printk(" Possible unsafe locking scenario:\n\n");
+	trace_printk("       CPU0\n");
+	trace_printk("       ----\n");
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), prev);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), next);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("\n *** DEADLOCK ***\n\n");
+	trace_printk(" May be due to missing lock nesting notation\n\n");
 }
 
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
 {
+	char buf[256];
+
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=============================================\n");
-	printk("[ INFO: possible recursive locking detected ]\n");
+	trace_printk("\n");
+	trace_printk("=============================================\n");
+	trace_printk("[ INFO: possible recursive locking detected ]\n");
 	print_kernel_ident();
-	printk("---------------------------------------------\n");
-	printk("%s/%d is trying to acquire lock:\n",
+	trace_printk("---------------------------------------------\n");
+	trace_printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
-	print_lock(next);
-	printk("\nbut task is already holding lock:\n");
-	print_lock(prev);
+	sprint_lock(buf, next);
+	trace_printk(buf);
+	trace_printk("\nbut task is already holding lock:\n");
+	sprint_lock(buf, prev);
+	trace_printk(buf);
 
-	printk("\nother info that might help us debug this:\n");
+	trace_printk("\nother info that might help us debug this:\n");
 	print_deadlock_scenario(next, prev);
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -1894,13 +1955,16 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * Debugging printouts:
 	 */
 	if (verbose(hlock_class(prev)) || verbose(hlock_class(next))) {
+		char buf[256];
+
 		graph_unlock();
-		printk("\n new dependency: ");
-		print_lock_name(hlock_class(prev));
-		printk(" => ");
-		print_lock_name(hlock_class(next));
-		printk("\n");
-		dump_stack();
+		strcpy(buf, "\n new dependency: ");
+		sprint_lock_name(buf + strlen(buf), hlock_class(prev));
+		strcat(buf, " => ");
+		sprint_lock_name(buf + strlen(buf), hlock_class(next));
+		strcat(buf, "\n");
+		trace_printk(buf);
+		trace_dump_stack(0);
 		return graph_lock();
 	}
 	return 1;
@@ -2025,7 +2089,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 cache_hit:
 			debug_atomic_inc(chain_lookup_hits);
 			if (very_verbose(class))
-				printk("\nhash chain already cached, key: "
+				trace_printk("\nhash chain already cached, key: "
 					"%016Lx tail class: [%p] %s\n",
 					(unsigned long long)chain_key,
 					class->key, class->name);
@@ -2033,7 +2097,7 @@ cache_hit:
 		}
 	}
 	if (very_verbose(class))
-		printk("\nnew hash chain, key: %016Lx tail class: [%p] %s\n",
+		trace_printk("\nnew hash chain, key: %016Lx tail class: [%p] %s\n",
 			(unsigned long long)chain_key, class->key, class->name);
 	/*
 	 * Allocate a new chain entry from the static array, and add
@@ -2055,7 +2119,7 @@ cache_hit:
 			return 0;
 
 		print_lockdep_off("BUG: MAX_LOCKDEP_CHAINS too low!");
-		dump_stack();
+		trace_dump_stack(0);
 		return 0;
 	}
 	chain = lock_chains + nr_lock_chains++;
@@ -2203,55 +2267,61 @@ static void
 print_usage_bug_scenario(struct held_lock *lock)
 {
 	struct lock_class *class = hlock_class(lock);
-
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0\n");
-	printk("       ----\n");
-	printk("  lock(");
-	__print_lock_name(class);
-	printk(");\n");
-	printk("  <Interrupt>\n");
-	printk("    lock(");
-	__print_lock_name(class);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	char buf[256];
+
+	trace_printk(" Possible unsafe locking scenario:\n\n");
+	trace_printk("       CPU0\n");
+	trace_printk("       ----\n");
+	strcpy(buf, "  lock(");
+	__sprint_lock_name(buf + strlen(buf), class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("  <Interrupt>\n");
+	strcpy(buf, "    lock(");
+	__sprint_lock_name(buf + strlen(buf), class);
+	strcat(buf, ");\n");
+	trace_printk(buf);
+	trace_printk("\n *** DEADLOCK ***\n\n");
 }
 
 static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
 {
+	char buf[256];
+
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=================================\n");
-	printk("[ INFO: inconsistent lock state ]\n");
+	trace_printk("\n");
+	trace_printk("=================================\n");
+	trace_printk("[ INFO: inconsistent lock state ]\n");
 	print_kernel_ident();
-	printk("---------------------------------\n");
+	trace_printk("---------------------------------\n");
 
-	printk("inconsistent {%s} -> {%s} usage.\n",
+	trace_printk("inconsistent {%s} -> {%s} usage.\n",
 		usage_str[prev_bit], usage_str[new_bit]);
 
-	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
+	trace_printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
 		curr->comm, task_pid_nr(curr),
 		trace_hardirq_context(curr), hardirq_count() >> HARDIRQ_SHIFT,
 		trace_softirq_context(curr), softirq_count() >> SOFTIRQ_SHIFT,
 		trace_hardirqs_enabled(curr),
 		trace_softirqs_enabled(curr));
-	print_lock(this);
+	sprint_lock(buf, this);
+	trace_printk(buf);
 
-	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
-	print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
+	trace_printk("{%s} state was registered at:\n", usage_str[prev_bit]);
+	trace_print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
 
 	print_irqtrace_events(curr);
-	printk("\nother info that might help us debug this:\n");
+	trace_printk("\nother info that might help us debug this:\n");
 	print_usage_bug_scenario(this);
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -2285,32 +2355,36 @@ print_irq_inversion_bug(struct task_struct *curr,
 	struct lock_list *entry = other;
 	struct lock_list *middle = NULL;
 	int depth;
+	char buf[256];
 
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=========================================================\n");
-	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
+	trace_printk("\n");
+	trace_printk("=========================================================\n");
+	trace_printk("[ INFO: possible irq lock inversion dependency detected ]\n");
 	print_kernel_ident();
-	printk("---------------------------------------------------------\n");
-	printk("%s/%d just changed the state of lock:\n",
+	trace_printk("---------------------------------------------------------\n");
+	trace_printk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
-	print_lock(this);
+	sprint_lock(buf, this);
+	trace_printk(buf);
 	if (forwards)
-		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
+		trace_printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
-		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
-	print_lock_name(other->class);
-	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
+		trace_printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
+	sprint_lock_name(buf, other->class);
+	strcat(buf, "\n");
+	trace_printk(buf);
+	trace_printk("\nand interrupts could create inverse lock ordering between them.\n\n");
 
-	printk("\nother info that might help us debug this:\n");
+	trace_printk("\nother info that might help us debug this:\n");
 
 	/* Find a middle lock (if one exists) */
 	depth = get_lock_depth(other);
 	do {
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			trace_printk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 		middle = entry;
@@ -2326,13 +2400,13 @@ print_irq_inversion_bug(struct task_struct *curr,
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
+	trace_printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
 	if (!save_trace(&root->trace))
 		return 0;
 	print_shortest_lock_dependencies(other, root);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -2387,15 +2461,21 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 
 void print_irqtrace_events(struct task_struct *curr)
 {
-	printk("irq event stamp: %u\n", curr->irq_events);
-	printk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
-	print_ip_sym(curr->hardirq_enable_ip);
-	printk("hardirqs last disabled at (%u): ", curr->hardirq_disable_event);
-	print_ip_sym(curr->hardirq_disable_ip);
-	printk("softirqs last  enabled at (%u): ", curr->softirq_enable_event);
-	print_ip_sym(curr->softirq_enable_ip);
-	printk("softirqs last disabled at (%u): ", curr->softirq_disable_event);
-	print_ip_sym(curr->softirq_disable_ip);
+	char buf[256];
+
+	trace_printk("irq event stamp: %u\n", curr->irq_events);
+	sprintf(buf, "hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
+	sprint_ip_sym(buf + strlen(buf), curr->hardirq_enable_ip);
+	trace_printk(buf);
+	sprintf(buf, "hardirqs last disabled at (%u): ", curr->hardirq_disable_event);
+	sprint_ip_sym(buf + strlen(buf), curr->hardirq_disable_ip);
+	trace_printk(buf);
+	sprintf(buf, "softirqs last  enabled at (%u): ", curr->softirq_enable_event);
+	sprint_ip_sym(buf + strlen(buf), curr->softirq_enable_ip);
+	trace_printk(buf);
+	sprintf(buf, "softirqs last disabled at (%u): ", curr->softirq_disable_event);
+	sprint_ip_sym(buf + strlen(buf), curr->softirq_disable_ip);
+	trace_printk(buf);
 }
 
 static int HARDIRQ_verbose(struct lock_class *class)
@@ -2937,10 +3017,13 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	 * We must printk outside of the graph_lock:
 	 */
 	if (ret == 2) {
-		printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
-		print_lock(this);
+		char buf[256];
+
+		trace_printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
+		sprint_lock(buf, this);
+		trace_printk(buf);
 		print_irqtrace_events(curr);
-		dump_stack();
+		trace_dump_stack(0);
 	}
 
 	return ret;
@@ -2982,7 +3065,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	 * Sanity check, the lock-class key must be persistent:
 	 */
 	if (!static_obj(key)) {
-		printk("BUG: key %p not in .data!\n", key);
+		trace_printk("BUG: key %p not in .data!\n", key);
 		/*
 		 * What it says above ^^^^^, I suggest you read it.
 		 */
@@ -3007,31 +3090,34 @@ print_lock_nested_lock_not_held(struct task_struct *curr,
 				struct held_lock *hlock,
 				unsigned long ip)
 {
+	char buf[256];
+
 	if (!debug_locks_off())
 		return 0;
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("==================================\n");
-	printk("[ BUG: Nested lock was not taken ]\n");
+	trace_printk("\n");
+	trace_printk("==================================\n");
+	trace_printk("[ BUG: Nested lock was not taken ]\n");
 	print_kernel_ident();
-	printk("----------------------------------\n");
+	trace_printk("----------------------------------\n");
 
-	printk("%s/%d is trying to lock:\n", curr->comm, task_pid_nr(curr));
-	print_lock(hlock);
+	trace_printk("%s/%d is trying to lock:\n", curr->comm, task_pid_nr(curr));
+	sprint_lock(buf, hlock);
+	trace_printk(buf);
 
-	printk("\nbut this task is not holding:\n");
-	printk("%s\n", hlock->nest_lock->name);
+	trace_printk("\nbut this task is not holding:\n");
+	trace_printk("%s\n", hlock->nest_lock->name);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
-	printk("\nother info that might help us debug this:\n");
+	trace_printk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -3081,11 +3167,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	}
 	atomic_inc((atomic_t *)&class->ops);
 	if (very_verbose(class)) {
-		printk("\nacquire class [%p] %s", class->key, class->name);
+		trace_printk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		printk("\n");
-		dump_stack();
+			trace_printk("#%d", class->name_version);
+		trace_printk("\n");
+		trace_dump_stack(0);
 	}
 
 	/*
@@ -3192,12 +3278,12 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
 		print_lockdep_off("BUG: MAX_LOCK_DEPTH too low!");
-		printk(KERN_DEBUG "depth: %i  max: %lu!\n",
+		trace_printk("depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
-		dump_stack();
+		trace_dump_stack(0);
 
 		return 0;
 	}
@@ -3212,27 +3298,31 @@ static int
 print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
 {
+	char buf[256];
+
 	if (!debug_locks_off())
 		return 0;
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: bad unlock balance detected! ]\n");
+	trace_printk("\n");
+	trace_printk("=====================================\n");
+	trace_printk("[ BUG: bad unlock balance detected! ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------\n");
-	printk("%s/%d is trying to release lock (",
+	trace_printk("-------------------------------------\n");
+	sprintf(buf, "%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
-	print_lockdep_cache(lock);
-	printk(") at:\n");
-	print_ip_sym(ip);
-	printk("but there are no more locks to release!\n");
-	printk("\nother info that might help us debug this:\n");
+	sprint_lockdep_cache(buf + strlen(buf), lock);
+	strcat(buf, ") at:\n");
+	trace_printk(buf);
+	sprint_ip_sym(buf, ip);
+	trace_printk(buf);
+	trace_printk("but there are no more locks to release!\n");
+	trace_printk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -3532,11 +3622,11 @@ static void check_flags(unsigned long flags)
 
 	if (irqs_disabled_flags(flags)) {
 		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
-			printk("possible reason: unannotated irqs-off.\n");
+			trace_printk("possible reason: unannotated irqs-off.\n");
 		}
 	} else {
 		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
-			printk("possible reason: unannotated irqs-on.\n");
+			trace_printk("possible reason: unannotated irqs-on.\n");
 		}
 	}
 
@@ -3657,27 +3747,31 @@ static int
 print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
 {
+	char buf[256];
+
 	if (!debug_locks_off())
 		return 0;
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=================================\n");
-	printk("[ BUG: bad contention detected! ]\n");
+	trace_printk("\n");
+	trace_printk("=================================\n");
+	trace_printk("[ BUG: bad contention detected! ]\n");
 	print_kernel_ident();
-	printk("---------------------------------\n");
-	printk("%s/%d is trying to contend lock (",
+	trace_printk("---------------------------------\n");
+	sprintf(buf, "%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
-	print_lockdep_cache(lock);
-	printk(") at:\n");
-	print_ip_sym(ip);
-	printk("but there are no locks held!\n");
-	printk("\nother info that might help us debug this:\n");
+	sprint_lockdep_cache(buf + strlen(buf), lock);
+	strcat(buf, ") at:\n");
+	trace_printk(buf);
+	sprint_ip_sym(buf, ip);
+	trace_printk(buf);
+	trace_printk("but there are no locks held!\n");
+	trace_printk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 
 	return 0;
 }
@@ -4033,23 +4127,26 @@ static void
 print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 		     const void *mem_to, struct held_lock *hlock)
 {
+	char buf[256];
+
 	if (!debug_locks_off())
 		return;
 	if (debug_locks_silent)
 		return;
 
-	printk("\n");
-	printk("=========================\n");
-	printk("[ BUG: held lock freed! ]\n");
+	trace_printk("\n");
+	trace_printk("=========================\n");
+	trace_printk("[ BUG: held lock freed! ]\n");
 	print_kernel_ident();
-	printk("-------------------------\n");
-	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
+	trace_printk("-------------------------\n");
+	trace_printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
-	print_lock(hlock);
+	sprint_lock(buf, hlock);
+	trace_printk(buf);
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 }
 
 static inline int not_in_range(const void* mem_from, unsigned long mem_len,
@@ -4096,15 +4193,15 @@ static void print_held_locks_bug(void)
 	if (debug_locks_silent)
 		return;
 
-	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: %s/%d still has locks held! ]\n",
+	trace_printk("\n");
+	trace_printk("=====================================\n");
+	trace_printk("[ BUG: %s/%d still has locks held! ]\n",
 	       current->comm, task_pid_nr(current));
 	print_kernel_ident();
-	printk("-------------------------------------\n");
+	trace_printk("-------------------------------------\n");
 	lockdep_print_held_locks(current);
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 }
 
 void debug_check_no_locks_held(void)
@@ -4195,12 +4292,12 @@ asmlinkage __visible void lockdep_sys_exit(void)
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
-		printk("\n");
-		printk("================================================\n");
-		printk("[ BUG: lock held when returning to user space! ]\n");
+		trace_printk("\n");
+		trace_printk("================================================\n");
+		trace_printk("[ BUG: lock held when returning to user space! ]\n");
 		print_kernel_ident();
-		printk("------------------------------------------------\n");
-		printk("%s/%d is leaving the kernel with locks still held!\n",
+		trace_printk("------------------------------------------------\n");
+		trace_printk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
 		lockdep_print_held_locks(curr);
 	}
@@ -4215,14 +4312,14 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n");
-	printk("===============================\n");
-	printk("[ INFO: suspicious RCU usage. ]\n");
+	trace_printk("\n");
+	trace_printk("===============================\n");
+	trace_printk("[ INFO: suspicious RCU usage. ]\n");
 	print_kernel_ident();
-	printk("-------------------------------\n");
-	printk("%s:%d %s!\n", file, line, s);
-	printk("\nother info that might help us debug this:\n\n");
-	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
+	trace_printk("-------------------------------\n");
+	trace_printk("%s:%d %s!\n", file, line, s);
+	trace_printk("\nother info that might help us debug this:\n\n");
+	trace_printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
 	       !rcu_lockdep_current_cpu_online()
 			? "RCU used illegally from offline CPU!\n"
 			: !rcu_is_watching()
@@ -4249,10 +4346,10 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	 * rcu_read_lock_bh() and so on from extended quiescent states.
 	 */
 	if (!rcu_is_watching())
-		printk("RCU used illegally from extended quiescent state!\n");
+		trace_printk("RCU used illegally from extended quiescent state!\n");
 
 	lockdep_print_held_locks(curr);
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	trace_printk("\nstack backtrace:\n");
+	trace_dump_stack(0);
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
