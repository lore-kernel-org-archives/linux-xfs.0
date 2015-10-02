Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF0B97F56
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:16:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50DA8AC026
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:16:37 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	u7KvHT4wlNMdbc1Z for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 11:16:35 -0700 (PDT)
Date: Sat, 3 Oct 2015 02:15:17 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <201510030254.MzYyojDo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
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


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Waiman,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

config: openrisc-or1ksim_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All error/warnings (new ones prefixed by >>):

   include/linux/sched.h:3179:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/ptrace.h:6:0,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/err.h:24:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/err.h:29:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/err.h:34:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/err.h:39:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/err.h:51:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/err.h:57:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:15:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/debug_locks.h:8:1: warning: empty declaration
   include/linux/debug_locks.h:10:12: error: storage class specified for parameter 'debug_locks'
   include/linux/debug_locks.h:11:12: error: storage class specified for parameter 'debug_locks_silent'
   include/linux/debug_locks.h:15:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/debug_locks.h:22:12: error: storage class specified for parameter 'debug_locks_off'
   include/linux/debug_locks.h:48:1: warning: empty declaration
   include/linux/debug_locks.h:57:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/debug_locks.h:61:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/debug_locks.h:66:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/debug_locks.h:71:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:17:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/range.h:4:1: warning: empty declaration
   include/linux/range.h:24:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:19:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/bit_spinlock.h:16:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/bit_spinlock.h:41:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/bit_spinlock.h:57:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/bit_spinlock.h:74:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/bit_spinlock.h:89:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:20:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/shrinker.h:11:1: warning: empty declaration
   include/linux/shrinker.h:49:1: warning: empty declaration
   include/linux/shrinker.h:70:12: error: storage class specified for parameter 'register_shrinker'
   include/linux/shrinker.h:71:13: error: storage class specified for parameter 'unregister_shrinker'
   In file included from include/linux/page_ext.h:5:0,
                    from include/linux/mm.h:22,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/stacktrace.h:6:1: warning: empty declaration
   include/linux/stacktrace.h:7:1: warning: empty declaration
   In file included from include/linux/mm.h:22:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/page_ext.h:7:1: warning: empty declaration
   include/linux/page_ext.h:8:1: warning: empty declaration
   include/linux/page_ext.h:69:1: warning: empty declaration
   include/linux/page_ext.h:72:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page_ext.h:76:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page_ext.h:81:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page_ext.h:85:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/pid_namespace.h:6:0,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/mm.h:25:1: warning: empty declaration
   include/linux/mm.h:26:1: warning: empty declaration
   include/linux/mm.h:27:1: warning: empty declaration
   include/linux/mm.h:28:1: warning: empty declaration
   include/linux/mm.h:29:1: warning: empty declaration
   include/linux/mm.h:30:1: warning: empty declaration
   include/linux/mm.h:31:1: warning: empty declaration
   include/linux/mm.h:34:22: error: storage class specified for parameter 'max_mapnr'
   include/linux/mm.h:37:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/mm.h:44:22: error: storage class specified for parameter 'totalram_pages'
   include/linux/mm.h:45:15: error: storage class specified for parameter 'high_memory'
   include/linux/mm.h:46:12: error: storage class specified for parameter 'page_cluster'
   include/linux/mm.h:49:12: error: storage class specified for parameter 'sysctl_legacy_va_layout'
   In file included from include/asm-generic/pgtable-nopmd.h:6:0,
                    from arch/openrisc/include/asm/pgtable.h:28,
                    from include/linux/mm.h:55,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/asm-generic/pgtable-nopud.h:13:31: error: storage class specified for parameter 'pud_t'
   include/asm-generic/pgtable-nopud.h:25:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable-nopud.h:26:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable-nopud.h:27:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable-nopud.h:28:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable-nopud.h:38:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
   In file included from arch/openrisc/include/asm/pgtable.h:28:0,
                    from include/linux/mm.h:55,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/asm-generic/pgtable-nopmd.h:8:1: warning: empty declaration
   include/asm-generic/pgtable-nopmd.h:17:18: error: expected specifier-qualifier-list before 'pud_t'
   include/asm-generic/pgtable-nopmd.h:17:31: error: storage class specified for parameter 'pmd_t'
>> include/asm-generic/pgtable-nopmd.h:29:34: error: expected ')' before 'pud'
   include/asm-generic/pgtable-nopmd.h:30:33: error: expected ')' before 'pud'
   include/asm-generic/pgtable-nopmd.h:31:37: error: expected ')' before 'pud'
>> include/asm-generic/pgtable-nopmd.h:32:36: error: expected ')' before '*' token
   include/asm-generic/pgtable-nopmd.h:43:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
   include/asm-generic/pgtable-nopmd.h:59:51: error: expected declaration specifiers or '...' before 'pmd_t'
   include/asm-generic/pgtable-nopmd.h:60:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from arch/openrisc/include/asm/pgtable.h:32:0,
                    from include/linux/mm.h:55,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
>> arch/openrisc/include/asm/fixmap.h:40:1: warning: empty declaration
>> arch/openrisc/include/asm/fixmap.h:65:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/fixmap.h:82:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:55:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
>> arch/openrisc/include/asm/pgtable.h:46:13: error: storage class specified for parameter 'paging_init'
>> arch/openrisc/include/asm/pgtable.h:203:22: error: storage class specified for parameter 'empty_zero_page'
>> arch/openrisc/include/asm/pgtable.h:237:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:238:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:239:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:240:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:241:40: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:242:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:243:46: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:246:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:252:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:258:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:264:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:270:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:276:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:282:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:288:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:294:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:300:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:317:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:335:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   arch/openrisc/include/asm/pgtable.h:349:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>> arch/openrisc/include/asm/pgtable.h:366:34: error: expected ')' before '*' token
>> arch/openrisc/include/asm/pgtable.h:414:14: error: storage class specified for parameter 'swapper_pg_dir'
   arch/openrisc/include/asm/pgtable.h:424:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from arch/openrisc/include/asm/pgtable.h:441:0,
                    from include/linux/mm.h:55,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/asm-generic/pgtable.h:27:12: error: storage class specified for parameter 'ptep_set_access_flags'
   include/asm-generic/pgtable.h:34:29: error: expected declaration specifiers or '...' before 'pmd_t'
   include/asm-generic/pgtable.h:35:6: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/asm-generic/pgtable.h:33:12: error: storage class specified for parameter 'pmdp_set_access_flags'
   include/asm-generic/pgtable.h:42:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:70:10: error: expected declaration specifiers or '...' before 'pmd_t'
   include/asm-generic/pgtable.h:71:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:85:30: error: expected declaration specifiers or '...' before 'pmd_t'
   include/asm-generic/pgtable.h:92:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:127:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:144:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:150:14: error: storage class specified for parameter 'ptep_clear_flush'
   include/asm-generic/pgtable.h:156:14: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pmdp_huge_clear_flush'
>> include/asm-generic/pgtable.h:162:1: warning: empty declaration
   include/asm-generic/pgtable.h:164:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:180:34: error: expected declaration specifiers or '...' before 'pmd_t'
   include/asm-generic/pgtable.h:181:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:189:29: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/asm-generic/pgtable.h:188:13: error: storage class specified for parameter 'pmdp_splitting_flush'
   include/asm-generic/pgtable.h:197:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pmdp_collapse_flush'
   include/asm-generic/pgtable.h:209:62: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/asm-generic/pgtable.h:209:13: error: storage class specified for parameter 'pgtable_trans_huge_deposit'
   include/asm-generic/pgtable.h:214:68: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/asm-generic/pgtable.h:214:18: error: storage class specified for parameter 'pgtable_trans_huge_withdraw'
   include/asm-generic/pgtable.h:219:8: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/asm-generic/pgtable.h:218:13: error: storage class specified for parameter 'pmdp_invalidate'
   include/asm-generic/pgtable.h:224:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:237:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>> include/asm-generic/pgtable.h:249:34: error: expected ')' before 'pmd_a'
   include/asm-generic/pgtable.h:292:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>> include/asm-generic/pgtable.h:334:26: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:335:26: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:338:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:348:47: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:359:47: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:373:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:385:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:411:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:422:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:466:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>> include/asm-generic/pgtable.h:470:40: error: expected ')' before 'pmd'
   include/asm-generic/pgtable.h:476:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:480:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pmd_mksoft_dirty'
   include/asm-generic/pgtable.h:486:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:491:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:496:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:515:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:525:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:534:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:545:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:570:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:576:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:585:40: error: expected ')' before 'pmd'
   include/asm-generic/pgtable.h:589:45: error: expected ')' before 'pmd'
   include/asm-generic/pgtable.h:594:35: error: expected ')' before 'pmd'
   include/asm-generic/pgtable.h:603:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pmd_read_atomic'
   include/asm-generic/pgtable.h:617:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:647:61: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:689:44: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:708:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/asm-generic/pgtable.h:712:38: error: expected ')' before 'pmd'
   include/asm-generic/pgtable.h:726:38: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:730:38: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:734:40: error: expected ')' before '*' token
   include/asm-generic/pgtable.h:738:40: error: expected ')' before '*' token
   In file included from include/linux/mm.h:55:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
>> arch/openrisc/include/asm/pgtable.h:448:16: error: storage class specified for parameter 'pte_addr_t'
   In file included from include/linux/pid_namespace.h:6:0,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/mm.h:73:22: error: storage class specified for parameter 'sysctl_user_reserve_kbytes'
   include/linux/mm.h:74:22: error: storage class specified for parameter 'sysctl_admin_reserve_kbytes'
   include/linux/mm.h:76:12: error: storage class specified for parameter 'sysctl_overcommit_memory'
   include/linux/mm.h:77:12: error: storage class specified for parameter 'sysctl_overcommit_ratio'
   include/linux/mm.h:78:22: error: storage class specified for parameter 'sysctl_overcommit_kbytes'
   include/linux/mm.h:80:12: error: storage class specified for parameter 'overcommit_ratio_handler'
   include/linux/mm.h:82:12: error: storage class specified for parameter 'overcommit_kbytes_handler'
   include/linux/mm.h:102:27: error: storage class specified for parameter 'vm_area_cachep'
   include/linux/mm.h:209:17: error: storage class specified for parameter 'protection_map'
   include/linux/mm.h:226:1: warning: empty declaration
   include/linux/mm.h:254:7: error: expected declaration specifiers or '...' before 'pmd_t'
   include/linux/mm.h:248:1: warning: empty declaration
   include/linux/mm.h:307:1: warning: empty declaration
   include/linux/mm.h:308:1: warning: empty declaration
   In file included from include/linux/mm.h:317:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/page-flags.h:74:1: warning: empty declaration
   include/linux/page-flags.h:212:1: warning: empty declaration
   include/linux/page-flags.h:214:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:215:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:215:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:215:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:215:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:216:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:216:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:216:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:216:34: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:217:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:218:49: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:219:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:219:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:219:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:219:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:220:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:220:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:220:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:220:26: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:221:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:222:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:222:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:222:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:223:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:223:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:223:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:224:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:224:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:224:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:224:26: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:224:26: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:225:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:225:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:225:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:225:33: error: expected declaration specifiers before ';' token
   include/linux/page-flags.h:226:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:226:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:226:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:226:27: error: expected declaration specifiers before ';' token
   include/linux/page-flags.h:227:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:227:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:227:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:227:30: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:228:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:228:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:228:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:228:34: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:229:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:231:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:231:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:231:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:238:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:238:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:238:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:238:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:239:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:240:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:240:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:240:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:240:31: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:240:31: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:241:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:241:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:241:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:241:36: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:247:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:247:36: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:247:36: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:248:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:248:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:248:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:251:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:251:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:251:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:251:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:252:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:252:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:252:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:252:30: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:261:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:261:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:261:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:267:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:267:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:267:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:270:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:270:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:270:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:270:36: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:271:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:274:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:274:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:274:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:274:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:275:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:275:2: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:275:31: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:284:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:284:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:284:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:292:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:292:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:292:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:324:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:341:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:347:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:365:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:371:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:381:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:392:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:397:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:410:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:410:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:410:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:410:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:411:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:411:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:411:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:414:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:486:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:487:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:490:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:534:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:539:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:544:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:561:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:566:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:572:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:580:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:585:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:591:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:601:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:607:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:613:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:619:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   include/linux/page-flags.h:669:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
   In file included from include/linux/mm.h:318:0,
                    from include/linux/pid_namespace.h:6,
                    from include/linux/ptrace.h:8,
                    from arch/openrisc/kernel/asm-offsets.c:32:
   include/linux/huge_mm.h:6:34: error: expected declaration specifiers or '...' before 'pmd_t'
>> include/linux/huge_mm.h:4:12: error: storage class specified for parameter 'do_huge_pmd_anonymous_page'
   include/linux/huge_mm.h:9:5: error: expected declaration specifiers or '...' before 'pmd_t'
   include/linux/huge_mm.h:9:21: error: expected declaration specifiers or '...' before 'pmd_t'

vim +29 include/asm-generic/pgtable-nopmd.h

^1da177e4 Linus Torvalds 2005-04-16   2  #define _PGTABLE_NOPMD_H
^1da177e4 Linus Torvalds 2005-04-16   3  
^1da177e4 Linus Torvalds 2005-04-16   4  #ifndef __ASSEMBLY__
^1da177e4 Linus Torvalds 2005-04-16   5  
^1da177e4 Linus Torvalds 2005-04-16   6  #include <asm-generic/pgtable-nopud.h>
^1da177e4 Linus Torvalds 2005-04-16   7  
34ee55014 Andrew Morton  2008-07-28  @8  struct mm_struct;
34ee55014 Andrew Morton  2008-07-28   9  
^1da177e4 Linus Torvalds 2005-04-16  10  #define __PAGETABLE_PMD_FOLDED
^1da177e4 Linus Torvalds 2005-04-16  11  
^1da177e4 Linus Torvalds 2005-04-16  12  /*
^1da177e4 Linus Torvalds 2005-04-16  13   * Having the pmd type consist of a pud gets the size right, and allows
^1da177e4 Linus Torvalds 2005-04-16  14   * us to conceptually access the pud entry that this pmd is folded into
^1da177e4 Linus Torvalds 2005-04-16  15   * without casting.
^1da177e4 Linus Torvalds 2005-04-16  16   */
^1da177e4 Linus Torvalds 2005-04-16  17  typedef struct { pud_t pud; } pmd_t;
^1da177e4 Linus Torvalds 2005-04-16  18  
^1da177e4 Linus Torvalds 2005-04-16  19  #define PMD_SHIFT	PUD_SHIFT
^1da177e4 Linus Torvalds 2005-04-16  20  #define PTRS_PER_PMD	1
^1da177e4 Linus Torvalds 2005-04-16  21  #define PMD_SIZE  	(1UL << PMD_SHIFT)
^1da177e4 Linus Torvalds 2005-04-16  22  #define PMD_MASK  	(~(PMD_SIZE-1))
^1da177e4 Linus Torvalds 2005-04-16  23  
^1da177e4 Linus Torvalds 2005-04-16  24  /*
^1da177e4 Linus Torvalds 2005-04-16  25   * The "pud_xxx()" functions here are trivial for a folded two-level
^1da177e4 Linus Torvalds 2005-04-16  26   * setup: the pmd is never bad, and a pmd always exists (as it's folded
^1da177e4 Linus Torvalds 2005-04-16  27   * into the pud entry)
^1da177e4 Linus Torvalds 2005-04-16  28   */
^1da177e4 Linus Torvalds 2005-04-16 @29  static inline int pud_none(pud_t pud)		{ return 0; }
^1da177e4 Linus Torvalds 2005-04-16  30  static inline int pud_bad(pud_t pud)		{ return 0; }
^1da177e4 Linus Torvalds 2005-04-16  31  static inline int pud_present(pud_t pud)	{ return 1; }
^1da177e4 Linus Torvalds 2005-04-16 @32  static inline void pud_clear(pud_t *pud)	{ }
^1da177e4 Linus Torvalds 2005-04-16  33  #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
^1da177e4 Linus Torvalds 2005-04-16  34  
^1da177e4 Linus Torvalds 2005-04-16  35  #define pud_populate(mm, pmd, pte)		do { } while (0)

:::::: The code at line 29 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--2fHTh5uZTiUOsy+g
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--2fHTh5uZTiUOsy+g--
