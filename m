Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F3607F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:07:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45049304032
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:07:08 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id hDFgfKYumpKvWtnH for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:07:06 -0700 (PDT)
Date: Sat, 3 Oct 2015 02:05:58 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <201510030217.xqhLjnfK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
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


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Waiman,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

config: i386-alldefconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/proportions.h:12:0,
                    from include/linux/sched.h:43,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/linux/percpu_counter.h: In function '__percpu_counter_compare':
   include/linux/percpu_counter.h:126:30: error: expected declaration specifiers before ')' token
            s32 batch, s64 *pcnt))
                                 ^
   include/linux/percpu_counter.h:133:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:141:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:146:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:155:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:160:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:165:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:170:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:177:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:182:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/percpu_counter.h:187:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/sched.h:43:0,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/linux/proportions.h:17:1: warning: empty declaration
    struct prop_global {
    ^
   include/linux/proportions.h:38:1: warning: empty declaration
    struct prop_descriptor {
    ^
   include/linux/proportions.h:51:1: warning: empty declaration
    struct prop_local_percpu {
    ^
   include/linux/proportions.h:73:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/proportions.h:102:1: warning: empty declaration
    struct prop_local_single {
    ^
   include/linux/proportions.h:129:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/seccomp.h:4:0,
                    from include/linux/sched.h:44,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/uapi/linux/seccomp.h:47:1: warning: empty declaration
    struct seccomp_data {
    ^
   In file included from include/linux/sched.h:44:0,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/linux/seccomp.h:13:1: warning: empty declaration
    struct seccomp_filter;
    ^
   include/linux/seccomp.h:25:1: warning: empty declaration
    struct seccomp {
    ^
>> include/linux/seccomp.h:31:12: error: storage class specified for parameter '__secure_computing'
    extern int __secure_computing(void);
               ^
   include/linux/seccomp.h:33:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
>> include/linux/seccomp.h:42:12: error: storage class specified for parameter 'seccomp_phase1'
    extern u32 seccomp_phase1(struct seccomp_data *sd);
               ^
>> include/linux/seccomp.h:48:13: error: storage class specified for parameter 'prctl_get_seccomp'
    extern long prctl_get_seccomp(void);
                ^
>> include/linux/seccomp.h:49:13: error: storage class specified for parameter 'prctl_set_seccomp'
    extern long prctl_set_seccomp(unsigned long, char __user *);
                ^
   include/linux/seccomp.h:52:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/seccomp.h:90:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/seccomp.h:94:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/sched.h:46:0,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/linux/rculist.h:31:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:51:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:79:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:101:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:130:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:156:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:173:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:201:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:344:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:358:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:397:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:427:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rculist.h:454:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/sched.h:47:0,
                    from include/linux/uaccess.h:4,
                    from include/linux/crypto.h:26,
                    from arch/x86/kernel/asm-offsets.c:8:
   include/linux/rtmutex.h:19:12: error: storage class specified for parameter 'max_lock_depth'
    extern int max_lock_depth; /* for sysctl */
               ^
   include/linux/rtmutex.h:29:1: warning: empty declaration
    struct rt_mutex {
    ^
   include/linux/rtmutex.h:42:1: warning: empty declaration
    struct rt_mutex_waiter;
    ^
   include/linux/rtmutex.h:43:1: warning: empty declaration
    struct hrtimer_sleeper;
    ^
   include/linux/rtmutex.h:52:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     {
     ^
   include/linux/rtmutex.h:85:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/rtmutex.h:89:13: error: storage class specified for parameter '__rt_mutex_init'
    extern void __rt_mutex_init(struct rt_mutex *lock, const char *name);
                ^
   include/linux/rtmutex.h:90:13: error: storage class specified for parameter 'rt_mutex_destroy'
    extern void rt_mutex_destroy(struct rt_mutex *lock);
                ^
   include/linux/rtmutex.h:92:13: error: storage class specified for parameter 'rt_mutex_lock'
    extern void rt_mutex_lock(struct rt_mutex *lock);
                ^
   include/linux/rtmutex.h:93:12: error: storage class specified for parameter 'rt_mutex_lock_interruptible'
    extern int rt_mutex_lock_interruptible(struct rt_mutex *lock);
               ^
   include/linux/rtmutex.h:94:12: error: storage class specified for parameter 'rt_mutex_timed_lock'
    extern int rt_mutex_timed_lock(struct rt_mutex *lock,
               ^
   include/linux/rtmutex.h:97:12: error: storage class specified for parameter 'rt_mutex_trylock'
    extern int rt_mutex_trylock(struct rt_mutex *lock);
               ^
   include/linux/rtmutex.h:99:13: error: storage class specified for parameter 'rt_mutex_unlock'
    extern void rt_mutex_unlock(struct rt_mutex *lock);
                ^
   In file included from include/linux/resource.h:4:0,
                    from include/linux/sched.h:51,
                    from include/linux/uaccess.h:4,

vim +/__secure_computing +31 include/linux/seccomp.h

c2e1f2e30 Kees Cook        2014-06-05   7  
^1da177e4 Linus Torvalds   2005-04-16   8  #ifdef CONFIG_SECCOMP
^1da177e4 Linus Torvalds   2005-04-16   9  
^1da177e4 Linus Torvalds   2005-04-16  10  #include <linux/thread_info.h>
^1da177e4 Linus Torvalds   2005-04-16  11  #include <asm/seccomp.h>
^1da177e4 Linus Torvalds   2005-04-16  12  
e2cfabdfd Will Drewry      2012-04-12 @13  struct seccomp_filter;
e2cfabdfd Will Drewry      2012-04-12  14  /**
e2cfabdfd Will Drewry      2012-04-12  15   * struct seccomp - the state of a seccomp'ed process
e2cfabdfd Will Drewry      2012-04-12  16   *
e2cfabdfd Will Drewry      2012-04-12  17   * @mode:  indicates one of the valid values above for controlled
e2cfabdfd Will Drewry      2012-04-12  18   *         system calls available to a process.
dbd952127 Kees Cook        2014-06-27  19   * @filter: must always point to a valid seccomp-filter or NULL as it is
dbd952127 Kees Cook        2014-06-27  20   *          accessed without locking during system call entry.
e2cfabdfd Will Drewry      2012-04-12  21   *
e2cfabdfd Will Drewry      2012-04-12  22   *          @filter must only be accessed from the context of current as there
dbd952127 Kees Cook        2014-06-27  23   *          is no read locking.
e2cfabdfd Will Drewry      2012-04-12  24   */
932ecebb0 Will Drewry      2012-04-12 @25  struct seccomp {
932ecebb0 Will Drewry      2012-04-12  26  	int mode;
e2cfabdfd Will Drewry      2012-04-12  27  	struct seccomp_filter *filter;
932ecebb0 Will Drewry      2012-04-12  28  };
^1da177e4 Linus Torvalds   2005-04-16  29  
a4412fc94 Andy Lutomirski  2014-07-21  30  #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
a4412fc94 Andy Lutomirski  2014-07-21 @31  extern int __secure_computing(void);
a4412fc94 Andy Lutomirski  2014-07-21  32  static inline int secure_computing(void)
^1da177e4 Linus Torvalds   2005-04-16 @33  {
^1da177e4 Linus Torvalds   2005-04-16  34  	if (unlikely(test_thread_flag(TIF_SECCOMP)))
a4412fc94 Andy Lutomirski  2014-07-21  35  		return  __secure_computing();
acf3b2c71 Will Drewry      2012-04-12  36  	return 0;
^1da177e4 Linus Torvalds   2005-04-16  37  }
13aa72f0f Andy Lutomirski  2014-07-21  38  
13aa72f0f Andy Lutomirski  2014-07-21  39  #define SECCOMP_PHASE1_OK	0
13aa72f0f Andy Lutomirski  2014-07-21  40  #define SECCOMP_PHASE1_SKIP	1
13aa72f0f Andy Lutomirski  2014-07-21  41  
d39bd00de Andy Lutomirski  2014-07-21 @42  extern u32 seccomp_phase1(struct seccomp_data *sd);
13aa72f0f Andy Lutomirski  2014-07-21  43  int seccomp_phase2(u32 phase1_result);
a4412fc94 Andy Lutomirski  2014-07-21  44  #else
a4412fc94 Andy Lutomirski  2014-07-21  45  extern void secure_computing_strict(int this_syscall);
a4412fc94 Andy Lutomirski  2014-07-21  46  #endif
e4da89d02 Will Drewry      2012-04-17  47  
1d9d02fee Andrea Arcangeli 2007-07-15 @48  extern long prctl_get_seccomp(void);
e2cfabdfd Will Drewry      2012-04-12 @49  extern long prctl_set_seccomp(unsigned long, char __user *);
1d9d02fee Andrea Arcangeli 2007-07-15  50  
932ecebb0 Will Drewry      2012-04-12  51  static inline int seccomp_mode(struct seccomp *s)
5cec93c21 Andy Lutomirski  2011-06-05  52  {

:::::: The code at line 31 was first introduced by commit
:::::: a4412fc9486ec85686c6c7929e7e829f62ae377e seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing

:::::: TO: Andy Lutomirski <luto@amacapital.net>
:::::: CC: Kees Cook <keescook@chromium.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--17pEHd4RhPHOinZp
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
dbdd6xsS7m5lEBUKva//B2VF8BXCigAA

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--17pEHd4RhPHOinZp--
