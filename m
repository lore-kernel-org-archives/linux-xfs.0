Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 580C27F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE2D88F8033
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:05:00 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	yRnF24AwrAbeUJw7 for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 11:04:58 -0700 (PDT)
Date: Sat, 3 Oct 2015 02:04:14 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <201510030251.LfYJ2hol%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Waiman Long <Waiman.Long@hpe.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kbuild-all@01.org, Tejun Heo <tj@kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Waiman,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

config: ia64-allnoconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=ia64 

All error/warnings (new ones prefixed by >>):

   include/linux/sched.h:326:19: error: storage class specified for parameter 'mmlist_lock'
    extern spinlock_t mmlist_lock;
                      ^
   include/linux/sched.h:328:1: warning: empty declaration
    struct task_struct;
    ^
   include/linux/sched.h:334:13: error: storage class specified for parameter 'sched_init'
    extern void sched_init(void);
                ^
   include/linux/sched.h:335:13: error: storage class specified for parameter 'sched_init_smp'
    extern void sched_init_smp(void);
                ^
   include/linux/sched.h:336:24: error: storage class specified for parameter 'schedule_tail'
    extern asmlinkage void schedule_tail(struct task_struct *prev);
                           ^
   include/linux/sched.h:337:13: error: storage class specified for parameter 'init_idle'
    extern void init_idle(struct task_struct *idle, int cpu);
                ^
   include/linux/sched.h:338:13: error: storage class specified for parameter 'init_idle_bootup_task'
    extern void init_idle_bootup_task(struct task_struct *idle);
                ^
   include/linux/sched.h:340:22: error: storage class specified for parameter 'cpu_isolated_map'
    extern cpumask_var_t cpu_isolated_map;
                         ^
   include/linux/sched.h:342:12: error: storage class specified for parameter 'runqueue_is_locked'
    extern int runqueue_is_locked(int cpu);
               ^
   include/linux/sched.h:349:53: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void nohz_balance_enter_idle(int cpu) { }
                                                        ^
   include/linux/sched.h:350:48: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void set_cpu_sd_state_idle(void) { }
                                                   ^
   include/linux/sched.h:356:13: error: storage class specified for parameter 'show_state_filter'
    extern void show_state_filter(unsigned long state_filter);
                ^
   include/linux/sched.h:359:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:363:13: error: storage class specified for parameter 'show_regs'
    extern void show_regs(struct pt_regs *);
                ^
   include/linux/sched.h:370:13: error: storage class specified for parameter 'show_stack'
    extern void show_stack(struct task_struct *task, unsigned long *sp);
                ^
   include/linux/sched.h:372:13: error: storage class specified for parameter 'cpu_init'
    extern void cpu_init (void);
                ^
   include/linux/sched.h:373:13: error: storage class specified for parameter 'trap_init'
    extern void trap_init(void);
                ^
   include/linux/sched.h:374:13: error: storage class specified for parameter 'update_process_times'
    extern void update_process_times(int user);
                ^
   include/linux/sched.h:375:13: error: storage class specified for parameter 'scheduler_tick'
    extern void scheduler_tick(void);
                ^
   include/linux/sched.h:377:13: error: storage class specified for parameter 'sched_show_task'
    extern void sched_show_task(struct task_struct *p);
                ^
   include/linux/sched.h:390:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:393:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:396:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:399:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:407:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:415:13: error: storage class specified for parameter '__sched_text_start'
    extern char __sched_text_start[], __sched_text_end[];
                ^
   include/linux/sched.h:415:35: error: storage class specified for parameter '__sched_text_end'
    extern char __sched_text_start[], __sched_text_end[];
                                      ^
   include/linux/sched.h:418:12: error: storage class specified for parameter 'in_sched_functions'
    extern int in_sched_functions(unsigned long addr);
               ^
   include/linux/sched.h:421:20: error: storage class specified for parameter 'schedule_timeout'
    extern signed long schedule_timeout(signed long timeout);
                       ^
   include/linux/sched.h:422:20: error: storage class specified for parameter 'schedule_timeout_interruptible'
    extern signed long schedule_timeout_interruptible(signed long timeout);
                       ^
   include/linux/sched.h:423:20: error: storage class specified for parameter 'schedule_timeout_killable'
    extern signed long schedule_timeout_killable(signed long timeout);
                       ^
   include/linux/sched.h:424:20: error: storage class specified for parameter 'schedule_timeout_uninterruptible'
    extern signed long schedule_timeout_uninterruptible(signed long timeout);
                       ^
   In file included from include/linux/linkage.h:7:0,
                    from include/linux/kernel.h:6,
                    from include/linux/sched.h:17,
                    from arch/ia64/kernel/asm-offsets.c:9:
>> arch/ia64/include/asm/linkage.h:6:35: error: expected declaration specifiers before '__attribute__'
    #define asmlinkage CPP_ASMLINKAGE __attribute__((syscall_linkage))
                                      ^
>> include/linux/sched.h:425:1: note: in expansion of macro 'asmlinkage'
    asmlinkage void schedule(void);
    ^
   In file included from arch/ia64/kernel/asm-offsets.c:9:0:
   include/linux/sched.h:426:13: error: storage class specified for parameter 'schedule_preempt_disabled'
    extern void schedule_preempt_disabled(void);
                ^
   include/linux/sched.h:428:13: error: storage class specified for parameter 'io_schedule_timeout'
    extern long io_schedule_timeout(long timeout);
                ^
   include/linux/sched.h:431:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:435:1: warning: empty declaration
    struct nsproxy;
    ^
   include/linux/sched.h:436:1: warning: empty declaration
    struct user_namespace;
    ^
   include/linux/sched.h:439:13: error: storage class specified for parameter 'arch_pick_mmap_layout'
    extern void arch_pick_mmap_layout(struct mm_struct *mm);
                ^
   include/linux/sched.h:441:1: error: storage class specified for parameter 'arch_get_unmapped_area'
    arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
    ^
   include/linux/sched.h:444:1: error: storage class specified for parameter 'arch_get_unmapped_area_topdown'
    arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
    ^
   include/linux/sched.h:461:13: error: storage class specified for parameter 'set_dumpable'
    extern void set_dumpable(struct mm_struct *mm, int value);
                ^
   include/linux/sched.h:469:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:474:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:510:1: warning: empty declaration
    struct sighand_struct {
    ^
   include/linux/sched.h:517:1: warning: empty declaration
    struct pacct_struct {
    ^
   include/linux/sched.h:525:1: warning: empty declaration
    struct cpu_itimer {
    ^
   include/linux/sched.h:541:1: warning: empty declaration
    struct prev_cputime {
    ^
   include/linux/sched.h:550:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:567:1: warning: empty declaration
    struct task_cputime {
    ^
   include/linux/sched.h:589:1: warning: empty declaration
    struct task_cputime_atomic {
    ^
   include/linux/sched.h:626:1: warning: empty declaration
    struct thread_group_cputimer {
    ^
   include/linux/sched.h:632:1: warning: empty declaration
    struct autogroup;
    ^
   include/linux/sched.h:641:1: warning: empty declaration
    struct signal_struct {
    ^
   include/linux/sched.h:806:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:814:1: warning: empty declaration
    struct user_struct {
    ^
   include/linux/sched.h:848:12: error: storage class specified for parameter 'uids_sysfs_init'
    extern int uids_sysfs_init(void);
               ^
   include/linux/sched.h:850:28: error: storage class specified for parameter 'find_user'
    extern struct user_struct *find_user(kuid_t);
                               ^
   include/linux/sched.h:852:27: error: storage class specified for parameter 'root_user'
    extern struct user_struct root_user;
                              ^
   include/linux/sched.h:856:1: warning: empty declaration
    struct backing_dev_info;
    ^
   include/linux/sched.h:857:1: warning: empty declaration
    struct reclaim_state;
    ^
   include/linux/sched.h:906:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:917:1: warning: empty declaration
    enum cpu_idle_type {
    ^
   include/linux/sched.h:956:1: warning: empty declaration
    struct wake_q_node {
    ^
   include/linux/sched.h:960:1: warning: empty declaration
    struct wake_q_head {
    ^
   include/linux/sched.h:970:13: error: storage class specified for parameter 'wake_q_add'
    extern void wake_q_add(struct wake_q_head *head,
                ^
   include/linux/sched.h:972:13: error: storage class specified for parameter 'wake_up_q'
    extern void wake_up_q(struct wake_q_head *head);
                ^
   include/linux/sched.h:1155:1: warning: empty declaration
    struct sched_domain_attr;
    ^
   include/linux/sched.h:1160:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1164:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1171:1: warning: empty declaration
    struct io_context;   /* See blkdev.h */
    ^
>> include/linux/sched.h:1175:13: error: storage class specified for parameter 'prefetch_stack'
    extern void prefetch_stack(struct task_struct *t);
                ^
   include/linux/sched.h:1180:1: warning: empty declaration
    struct audit_context;  /* See audit.c */
    ^
   include/linux/sched.h:1181:1: warning: empty declaration
    struct mempolicy;
    ^
   include/linux/sched.h:1182:1: warning: empty declaration
    struct pipe_inode_info;
    ^
   include/linux/sched.h:1183:1: warning: empty declaration
    struct uts_namespace;
    ^
   include/linux/sched.h:1185:1: warning: empty declaration
    struct load_weight {
    ^
   include/linux/sched.h:1204:1: warning: empty declaration
    struct sched_avg {
    ^
   include/linux/sched.h:1246:1: warning: empty declaration
    struct sched_entity {
    ^
   include/linux/sched.h:1278:1: warning: empty declaration
    struct sched_rt_entity {
    ^
   include/linux/sched.h:1294:1: warning: empty declaration
    struct sched_dl_entity {
    ^
   include/linux/sched.h:1343:1: warning: empty declaration
    union rcu_special {
    ^
   include/linux/sched.h:1350:1: warning: empty declaration
    struct rcu_node;
    ^
   include/linux/sched.h:1352:1: warning: empty declaration
    enum perf_event_task_context {
    ^
   include/linux/sched.h:1360:1: warning: empty declaration
    struct tlbflush_unmap_batch {
    ^
   include/linux/sched.h:1378:1: warning: empty declaration
    struct task_struct {
    ^
   include/linux/sched.h:1850:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1853:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1857:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1860:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1864:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1870:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1875:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1885:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1890:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1894:1: warning: empty declaration
    struct pid_namespace;
    ^
   include/linux/sched.h:1913:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1919:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1924:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1930:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1937:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/sched.h:1942:19: error: storage class specified for parameter 'pid_alive'
    static inline int pid_alive(const struct task_struct *p);
                      ^
   include/linux/sched.h:1942:19: warning: parameter 'pid_alive' declared 'inline'
   include/linux/sched.h:1942:42: warning: 'always_inline' attribute ignored [-Wattributes]
    static inline int pid_alive(const struct task_struct *p);
                                             ^
   include/linux/sched.h:1942:19: error: 'no_instrument_function' attribute applies only to functions
    static inline int pid_alive(const struct task_struct *p);
                      ^
   include/linux/sched.h:1944:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
..

vim +/__attribute__ +6 arch/ia64/include/asm/linkage.h

^1da177e include/asm-ia64/linkage.h      Linus Torvalds 2005-04-16   1  #ifndef __ASM_LINKAGE_H
^1da177e include/asm-ia64/linkage.h      Linus Torvalds 2005-04-16   2  #define __ASM_LINKAGE_H
^1da177e include/asm-ia64/linkage.h      Linus Torvalds 2005-04-16   3  
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24   4  #ifndef __ASSEMBLY__
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24   5  
^1da177e include/asm-ia64/linkage.h      Linus Torvalds 2005-04-16  @6  #define asmlinkage CPP_ASMLINKAGE __attribute__((syscall_linkage))
^1da177e include/asm-ia64/linkage.h      Linus Torvalds 2005-04-16   7  
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24   8  #else
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24   9  
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24  10  #include <asm/asmmacro.h>
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24  11  
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24  12  #endif
ab7efcc9 include/asm-ia64/linkage.h      Jan Beulich    2006-03-24  13  
e1b5bb6d arch/ia64/include/asm/linkage.h Al Viro        2013-01-21  14  #define cond_syscall(x) asm(".weak\t" #x "#\n" #x "#\t=\tsys_ni_syscall#")

:::::: The code at line 6 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--RnlQjJ0d97Da+TV1
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--RnlQjJ0d97Da+TV1--
