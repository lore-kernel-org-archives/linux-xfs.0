Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BAE67F56
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:13:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 26CA48F8037
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:13:31 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	0lzUFe65eLxO5VGw for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 11:13:27 -0700 (PDT)
Date: Sat, 3 Oct 2015 02:12:38 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <201510030218.U4XK1emF%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
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


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Waiman,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

config: m68k-sun3_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

All error/warnings (new ones prefixed by >>):

    {
    ^
   include/linux/jump_label.h:201:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void jump_label_lock(void) {}
                                             ^
   include/linux/jump_label.h:202:44: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void jump_label_unlock(void) {}
                                               ^
   include/linux/jump_label.h:205:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/jump_label.h:218:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/jump_label.h:223:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/jump_label.h:233:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/jump_label.h:251:1: warning: empty declaration
    struct static_key_true {
    ^
   include/linux/jump_label.h:255:1: warning: empty declaration
    struct static_key_false {
    ^
   In file included from include/linux/vtime.h:4:0,
                    from include/linux/hardirq.h:7,
                    from include/linux/interrupt.h:12,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
   include/linux/context_tracking_state.h:7:1: warning: empty declaration
    struct context_tracking {
    ^
   include/linux/context_tracking_state.h:43:51: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline bool context_tracking_in_user(void) { return false; }
                                                      ^
   include/linux/context_tracking_state.h:44:50: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline bool context_tracking_active(void) { return false; }
                                                     ^
   include/linux/context_tracking_state.h:45:54: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline bool context_tracking_is_enabled(void) { return false; }
                                                         ^
   include/linux/context_tracking_state.h:46:58: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline bool context_tracking_cpu_is_enabled(void) { return false; }
                                                             ^
   In file included from include/linux/hardirq.h:7:0,
                    from include/linux/interrupt.h:12,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
   include/linux/vtime.h:10:1: warning: empty declaration
    struct task_struct;
    ^
   include/linux/vtime.h:32:51: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline bool vtime_accounting_enabled(void) { return false; }
                                                      ^
   include/linux/vtime.h:69:64: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_task_switch(struct task_struct *prev) { }
                                                                   ^
   include/linux/vtime.h:70:66: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_account_system(struct task_struct *tsk) { }
                                                                     ^
   include/linux/vtime.h:71:64: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_account_user(struct task_struct *tsk) { }
                                                                   ^
   include/linux/vtime.h:72:69: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
                                                                        ^
   include/linux/vtime.h:96:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/vtime.h:100:62: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_user_enter(struct task_struct *tsk) { }
                                                                 ^
   include/linux/vtime.h:101:61: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_user_exit(struct task_struct *tsk) { }
                                                                ^
   include/linux/vtime.h:102:63: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_guest_enter(struct task_struct *tsk) { }
                                                                  ^
   include/linux/vtime.h:103:62: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_guest_exit(struct task_struct *tsk) { }
                                                                 ^
   include/linux/vtime.h:104:70: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void vtime_init_idle(struct task_struct *tsk, int cpu) { }
                                                                         ^
   include/linux/vtime.h:110:65: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline void irqtime_account_irq(struct task_struct *tsk) { }
                                                                    ^
   include/linux/vtime.h:114:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/vtime.h:120:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from arch/m68k/include/asm/hardirq.h:6:0,
                    from include/linux/hardirq.h:8,
                    from include/linux/interrupt.h:12,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
>> arch/m68k/include/asm/irq.h:57:1: warning: empty declaration
    struct irq_data;
    ^
   arch/m68k/include/asm/irq.h:58:1: warning: empty declaration
    struct irq_chip;
    ^
   arch/m68k/include/asm/irq.h:59:1: warning: empty declaration
    struct irq_desc;
    ^
>> arch/m68k/include/asm/irq.h:60:21: error: storage class specified for parameter 'm68k_irq_startup'
    extern unsigned int m68k_irq_startup(struct irq_data *data);
                        ^
>> arch/m68k/include/asm/irq.h:61:21: error: storage class specified for parameter 'm68k_irq_startup_irq'
    extern unsigned int m68k_irq_startup_irq(unsigned int irq);
                        ^
>> arch/m68k/include/asm/irq.h:62:13: error: storage class specified for parameter 'm68k_irq_shutdown'
    extern void m68k_irq_shutdown(struct irq_data *data);
                ^
>> arch/m68k/include/asm/irq.h:63:13: error: storage class specified for parameter 'm68k_setup_auto_interrupt'
    extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int,
                ^
>> arch/m68k/include/asm/irq.h:65:13: error: storage class specified for parameter 'm68k_setup_user_interrupt'
    extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt);
                ^
>> arch/m68k/include/asm/irq.h:66:13: error: storage class specified for parameter 'm68k_setup_irq_controller'
    extern void m68k_setup_irq_controller(struct irq_chip *,
                ^
>> arch/m68k/include/asm/irq.h:70:21: error: storage class specified for parameter 'irq_canonicalize'
    extern unsigned int irq_canonicalize(unsigned int irq);
                        ^
>> arch/m68k/include/asm/irq.h:77:17: error: storage class specified for parameter 'irq_err_count'
    extern atomic_t irq_err_count;
                    ^
   In file included from include/linux/hardirq.h:8:0,
                    from include/linux/interrupt.h:12,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
>> arch/m68k/include/asm/hardirq.h:11:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
>> arch/m68k/include/asm/hardirq.h:18:25: error: storage class specified for parameter 'irq_cpustat_t'
    } ____cacheline_aligned irq_cpustat_t;
                            ^
   In file included from arch/m68k/include/asm/hardirq.h:20:0,
                    from include/linux/hardirq.h:8,
                    from include/linux/interrupt.h:12,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
>> include/linux/irq_cpustat.h:20:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'irq_stat'
    extern irq_cpustat_t irq_stat[];  /* defined in asm/hardirq.h */
                         ^
   In file included from include/linux/interrupt.h:12:0,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
   include/linux/hardirq.h:11:13: error: storage class specified for parameter 'synchronize_irq'
    extern void synchronize_irq(unsigned int irq);
                ^
   include/linux/hardirq.h:12:13: error: storage class specified for parameter 'synchronize_hardirq'
    extern bool synchronize_hardirq(unsigned int irq);
                ^
   include/linux/hardirq.h:17:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/hardirq.h:21:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/hardirq.h:45:13: error: storage class specified for parameter 'irq_enter'
    extern void irq_enter(void);
                ^
   include/linux/hardirq.h:60:13: error: storage class specified for parameter 'irq_exit'
    extern void irq_exit(void);
                ^
   In file included from include/linux/interrupt.h:15:0,
                    from include/linux/kernel_stat.h:8,
                    from arch/m68k/kernel/asm-offsets.c:15:
   include/linux/kref.h:24:1: warning: empty declaration
    struct kref {
    ^
   include/linux/kref.h:33:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:42:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:70:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:98:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:118:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:137:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/kref.h:168:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/kernel_stat.h:8:0,
                    from arch/m68k/kernel/asm-offsets.c:15:
   include/linux/interrupt.h:87:1: warning: empty declaration
    enum {
    ^
>> include/linux/interrupt.h:92:22: error: expected declaration specifiers or '...' before '*' token
    typedef irqreturn_t (*irq_handler_t)(int, void *);
                         ^
>> include/linux/interrupt.h:110:2: error: unknown type name 'irq_handler_t'
     irq_handler_t  handler;
     ^
   include/linux/interrupt.h:114:2: error: unknown type name 'irq_handler_t'
     irq_handler_t  thread_fn;
     ^
   include/linux/interrupt.h:109:1: warning: empty declaration
    struct irqaction {
    ^
>> include/linux/interrupt.h:124:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'no_action'
    extern irqreturn_t no_action(int cpl, void *dev_id);
                       ^
   include/linux/interrupt.h:127:40: error: unknown type name 'irq_handler_t'
    request_threaded_irq(unsigned int irq, irq_handler_t handler,
                                           ^
   include/linux/interrupt.h:128:8: error: unknown type name 'irq_handler_t'
           irq_handler_t thread_fn,
           ^
   include/linux/interrupt.h:132:31: error: unknown type name 'irq_handler_t'
    request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
                                  ^
   include/linux/interrupt.h:139:43: error: unknown type name 'irq_handler_t'
    request_any_context_irq(unsigned int irq, irq_handler_t handler,
                                              ^
   include/linux/interrupt.h:143:38: error: unknown type name 'irq_handler_t'
    request_percpu_irq(unsigned int irq, irq_handler_t handler,
                                         ^
   include/linux/interrupt.h:146:13: error: storage class specified for parameter 'free_irq'
    extern void free_irq(unsigned int, void *);
                ^
   include/linux/interrupt.h:147:13: error: storage class specified for parameter 'free_percpu_irq'
    extern void free_percpu_irq(unsigned int, void __percpu *);
                ^
   include/linux/interrupt.h:149:1: warning: empty declaration
    struct device;
    ^
   include/linux/interrupt.h:153:6: error: unknown type name 'irq_handler_t'
         irq_handler_t handler, irq_handler_t thread_fn,
         ^
   include/linux/interrupt.h:153:29: error: unknown type name 'irq_handler_t'
         irq_handler_t handler, irq_handler_t thread_fn,
                                ^
   include/linux/interrupt.h:158:56: error: unknown type name 'irq_handler_t'
    devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
                                                           ^
   include/linux/interrupt.h:167:4: error: unknown type name 'irq_handler_t'
       irq_handler_t handler, unsigned long irqflags,
       ^
   include/linux/interrupt.h:170:13: error: storage class specified for parameter 'devm_free_irq'
    extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
                ^
   include/linux/interrupt.h:190:13: error: storage class specified for parameter 'disable_irq_nosync'
    extern void disable_irq_nosync(unsigned int irq);
                ^
   include/linux/interrupt.h:191:13: error: storage class specified for parameter 'disable_hardirq'
    extern bool disable_hardirq(unsigned int irq);
                ^
   include/linux/interrupt.h:192:13: error: storage class specified for parameter 'disable_irq'
    extern void disable_irq(unsigned int irq);
                ^
   include/linux/interrupt.h:193:13: error: storage class specified for parameter 'disable_percpu_irq'
    extern void disable_percpu_irq(unsigned int irq);
                ^
   include/linux/interrupt.h:194:13: error: storage class specified for parameter 'enable_irq'
    extern void enable_irq(unsigned int irq);
                ^
   include/linux/interrupt.h:195:13: error: storage class specified for parameter 'enable_percpu_irq'
    extern void enable_percpu_irq(unsigned int irq, unsigned int type);
                ^
   include/linux/interrupt.h:196:13: error: storage class specified for parameter 'irq_wake_thread'
    extern void irq_wake_thread(unsigned int irq, void *dev_id);
                ^
   include/linux/interrupt.h:199:13: error: storage class specified for parameter 'suspend_device_irqs'
    extern void suspend_device_irqs(void);
                ^
   include/linux/interrupt.h:200:13: error: storage class specified for parameter 'resume_device_irqs'
    extern void resume_device_irqs(void);
                ^
   include/linux/interrupt.h:214:1: warning: empty declaration
    struct irq_affinity_notify {
    ^
   include/linux/interrupt.h:271:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:276:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:281:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:285:58: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    static inline int irq_select_affinity(unsigned int irq)  { return 0; }
                                                             ^
   include/linux/interrupt.h:289:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:295:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:312:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:320:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:328:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   include/linux/interrupt.h:336:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
..

vim +125 include/linux/percpu_counter.h

   119		else if (fbc->count < rhs)
   120			return -1;
   121		else
   122			return 0;
   123	}
   124	
 > 125	static inline int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs,
   126						   s32 batch, s64 *pcnt))
   127	{
   128		return percpu_counter_compare(fbc, rhs);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--mP3DRpeJDSE+ciuQ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--mP3DRpeJDSE+ciuQ--
