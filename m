Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-restructure,
	created. xfs-for-linus-3.15-rc6-858-gd12984e
Message-Id: <20140610060707.2E7CE7F6D@oss.sgi.com>
Date: Tue, 10 Jun 2014 01:07:06 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2465098445983478595=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2465098445983478595==
Content-Type: text/plain

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-libxfs-restructure has been created
        at  d12984ec02037de7af328580075ba1bb88272ffd (commit)

- Log -----------------------------------------------------------------
commit d12984ec02037de7af328580075ba1bb88272ffd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jun 10 09:55:44 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/. This is done as one big chunk simpy to get it done
    quickly
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit f212d6fcf5c1cc3a3980dd320804c1dfb9f49b75
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jun 10 09:34:14 2014 +1000

    libxfs: move header files
    
    Move all the header files that are shared with userspace into
    libxfs. This is done as one big chunk simpy to get it done quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit e10404cf914273de8016d5992c7049bdb9a9a089
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jun 10 09:18:10 2014 +1000

    xfs: create libxfs infrastructure
    
    To minimise the differences between kernel and userspace code,
    split the kernel code into the same structure as the userspace code.
    That is, the gneric core functionality of XFS is moved to a libxfs/
    directory and treat it as a layering barrier in the XFS code.
    
    This patch introduces the libxfs directory, the build infrastructure
    and an initial source and header file to build. The libxfs directory
    will contain the header files that are needed to build libxfs - most
    of userspace does not care about the location of these header files
    as they are accessed indirectly. Hence keeping them inside libxfs
    makes it easy to track the changes and script the sync process as
    the directory structure will be identical.
    
    To allow this changeover to occur in the kernel code, there are some
    temporary infrastructure in the makefiles to grab the header
    filesystem from both locations. Once all the files are moved,
    modifications will be made in the source code that will make the
    need for these include directives go away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit f3a19b3ad85dcc4a073270e1fb594eff37709788
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jun 10 08:58:24 2014 +1000

    xfs: Nuke XFS_ERROR macro
    
    XFS_ERROR was designed long ago to trap return values, but it's not
    runtime configurable, it's not consistently used, and we can do
    similar error trapping with ftrace scripts and triggers from
    userspace.
    
    Just nuke XFS_ERROR and associated bits.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d5a6cda3cf2c0860543db26bb5df7ed4404f74cd
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jun 10 08:55:14 2014 +1000

    xfs: return is not a function
    
    return is not a function.  "return(EIO);" is silly;
    "return (EIO);" moreso.  return is not a function.
    Nuke the pointless parens.
    
    [dchinner: catch a couple of extra cases in xfs_attr_list.c,
    xfs_acl.c and xfs_linux.h.]
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1a72690b705f8d0142108188f4a2d84367e51efb
Merge: 1860e37 7691283
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Jun 10 08:48:28 2014 +1000

    Merge branch 'for-next' into xfs-error-negate

commit 1860e379875dfe7271c649058aeddffe5afd9d0d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 8 11:19:54 2014 -0700

    Linux 3.15

commit bb077d600689dbf9305758efed1e16775db1c84c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 8 10:09:49 2014 -0700

    Revert "x86/smpboot: Initialize secondary CPU only if master CPU will wait for it"
    
    This reverts commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f.
    
    It came in very late, and already has one reported failure: Sitsofe
    reports that the current tree fails to boot on his EeePC, and bisected
    it down to this.  Rather than waste time trying to figure out what's
    wrong, just revert it.
    
    Reported-by: Sitsofe Wheeler <sitsofe@gmail.com>
    Cc: Igor Mammedov <imammedo@redhat.com>
    Cc: Toshi Kani <toshi.kani@hp.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit c593e8978722f7f4a12932733cfeed6c0c74fbaa
Merge: 052e5c7 01a9a8a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jun 7 15:12:18 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
    
    Pull btrfs fix from Chris Mason:
     "I had this in my 3.16 merge window queue, but it is small and obvious
      enough for 3.15.  I cherry-picked and retested against current rc8"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs:
      Btrfs: send, fix corrupted path strings for long paths

commit 052e5c7e28cc22017f9ad3f67026f911fdfc2edc
Merge: 813895f f145377
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jun 7 15:01:39 2014 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
    
    Pull SCSI target fixes from Nicholas Bellinger:
     "Here are the remaining fixes for v3.15.
    
      This series includes:
    
       - iser-target fix for ImmediateData exception reference count bug
         (Sagi + nab)
       - iscsi-target fix for MC/S login + potential iser-target MRDSL
         buffer overrun (Santosh + Roland)
       - iser-target fix for v3.15-rc multi network portal shutdown
         regression (nab)
       - target fix for allowing READ_CAPCITY during ALUA Standby access
         state (Chris + nab)
       - target fix for NULL pointer dereference of alua_access_state for
         un-configured devices (Chris + nab)"
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending:
      target: Fix alua_access_state attribute OOPs for un-configured devices
      target: Allow READ_CAPACITY opcode in ALUA Standby access state
      iser-target: Fix multi network portal shutdown regression
      iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param_value()
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure

commit 813895f8dcb31bc6b0e9f5fc35e8c687a467f3dd
Merge: d4c5491 745c516
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jun 7 14:50:38 2014 -0700

    Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull x86 fixes from Peter Anvin:
     "A significantly larger than I'd like set of patches for just below the
      wire.  All of these, however, fix real problems.
    
      The one thing that is genuinely scary in here is the change of SMP
      initialization, but that *does* fix a confirmed hang when booting
      virtual machines.
    
      There is also a patch to actually do the right thing about not
      offlining a CPU when there are not enough interrupt vectors available
      in the system; the accounting was done incorrectly.  The worst case
      for that patch is that we fail to offline CPUs when we should (the new
      code is strictly more conservative than the old), so is not
      particularly risky.
    
      Most of the rest is minor stuff; the EFI patches are all about
      exporting correct information to boot loaders and kexec"
    
    * 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      x86/boot: EFI_MIXED should not prohibit loading above 4G
      x86/smpboot: Initialize secondary CPU only if master CPU will wait for it
      x86/smpboot: Log error on secondary CPU wakeup failure at ERR level
      x86: Fix list/memory corruption on CPU hotplug
      x86: irq: Get correct available vectors for cpu disable
      x86/efi: Do not export efi runtime map in case old map
      x86/efi: earlyprintk=efi,keep fix

commit 745c51673e289acf4d9ffc2835524de73ef923fd
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Sat Jun 7 12:26:20 2014 +0100

    x86/boot: EFI_MIXED should not prohibit loading above 4G
    
    commit 7d453eee36ae ("x86/efi: Wire up CONFIG_EFI_MIXED") introduced a
    regression for the functionality to load kernels above 4G. The relevant
    (incorrect) reasoning behind this change can be seen in the commit
    message,
    
      "The xloadflags field in the bzImage header is also updated to reflect
      that the kernel supports both entry points by setting both of
      XLF_EFI_HANDOVER_32 and XLF_EFI_HANDOVER_64 when CONFIG_EFI_MIXED=y.
      XLF_CAN_BE_LOADED_ABOVE_4G is disabled so that the kernel text is
      guaranteed to be addressable with 32-bits."
    
    This is obviously bogus since 32-bit EFI loaders will never place the
    kernel above the 4G mark. So this restriction is entirely unnecessary.
    
    But things are worse than that - since we want to encourage people to
    always compile with CONFIG_EFI_MIXED=y so that their kernels work out of
    the box for both 32-bit and 64-bit firmware, commit 7d453eee36ae
    effectively disables XLF_CAN_BE_LOADED_ABOVE_4G completely.
    
    Remove the overzealous and superfluous restriction and restore the
    XLF_CAN_BE_LOADED_ABOVE_4G functionality.
    
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Dave Young <dyoung@redhat.com>
    Cc: Vivek Goyal <vgoyal@redhat.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>
    Link: http://lkml.kernel.org/r/1402140380-15377-1-git-send-email-matt@console-pimps.org
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit d4c54919ed86302094c0ca7d48a8cbd4ee753e92
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Fri Jun 6 10:00:01 2014 -0400

    mm: add !pte_present() check on existing hugetlb_entry callbacks
    
    The age table walker doesn't check non-present hugetlb entry in common
    path, so hugetlb_entry() callbacks must check it.  The reason for this
    behavior is that some callers want to handle it in its own way.
    
    [ I think that reason is bogus, btw - it should just do what the regular
      code does, which is to call the "pte_hole()" function for such hugetlb
      entries  - Linus]
    
    However, some callers don't check it now, which causes unpredictable
    result, for example when we have a race between migrating hugepage and
    reading /proc/pid/numa_maps.  This patch fixes it by adding !pte_present
    checks on buggy callbacks.
    
    This bug exists for years and got visible by introducing hugepage
    migration.
    
    ChangeLog v2:
    - fix if condition (check !pte_present() instead of pte_present())
    
    Reported-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: <stable@vger.kernel.org> [3.12+]
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    [ Backported to 3.15.  Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org> ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 01a9a8a9e20012f5676ec9cd16b6aed08b267066
Author: Filipe Manana <fdmanana@gmail.com>
Date:   Wed May 21 17:38:13 2014 +0100

    Btrfs: send, fix corrupted path strings for long paths
    
    If a path has more than 230 characters, we allocate a new buffer to
    use for the path, but we were forgotting to copy the contents of the
    previous buffer into the new one, which has random content from the
    kmalloc call.
    
    Test:
    
        mkfs.btrfs -f /dev/sdd
        mount /dev/sdd /mnt
    
        TEST_PATH="/mnt/fdmanana/.config/google-chrome-mysetup/Default/Pepper_Data/Shockwave_Flash/WritableRoot/#SharedObjects/JSHJ4ZKN/s.wsj.net/[[IMPORT]]/players.edgesuite.net/flash/plugins/osmf/advanced-streaming-plugin/v2.7/osmf1.6/Ak#"
        mkdir -p $TEST_PATH
        echo "hello world" > $TEST_PATH/amaiAdvancedStreamingPlugin.txt
    
        btrfs subvolume snapshot -r /mnt /mnt/mysnap1
        btrfs send /mnt/mysnap1 -f /tmp/1.snap
    
    A test for xfstests follows.
    
    Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
    Cc: Marc Merlin <marc@merlins.org>
    Tested-by: Marc MERLIN <marc@merlins.org>
    Signed-off-by: Chris Mason <clm@fb.com>

commit d54d14bfb49f0b61aed9f20cb84cb692566cf83b
Merge: 624483f 09dc4ab
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 6 09:53:32 2014 -0700

    Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull scheduler fixes from Ingo Molnar:
     "Four misc fixes: each was deemed serious enough to warrant v3.15
      inclusion"
    
    * 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      sched/fair: Fix tg_set_cfs_bandwidth() deadlock on rq->lock
      sched/dl: Fix race in dl_task_timer()
      sched: Fix sched_policy < 0 comparison
      sched/numa: Fix use of spin_{un}lock_irq() when interrupts are disabled

commit 624483f3ea82598ab0f62f1bdb9177f531ab1892
Author: Andrey Ryabinin <a.ryabinin@samsung.com>
Date:   Fri Jun 6 19:09:30 2014 +0400

    mm: rmap: fix use-after-free in __put_anon_vma
    
    While working address sanitizer for kernel I've discovered
    use-after-free bug in __put_anon_vma.
    
    For the last anon_vma, anon_vma->root freed before child anon_vma.
    Later in anon_vma_free(anon_vma) we are referencing to already freed
    anon_vma->root to check rwsem.
    
    This fixes it by freeing the child anon_vma before freeing
    anon_vma->root.
    
    Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@vger.kernel.org> # v3.0+
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f1453773514bb8b0bba0716301e8c8f17f8d39c7
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Jun 6 00:52:57 2014 -0700

    target: Fix alua_access_state attribute OOPs for un-configured devices
    
    This patch fixes a OOPs where an attempt to write to the per-device
    alua_access_state configfs attribute at:
    
      /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP/alua_access_state
    
    results in an NULL pointer dereference when the backend device has not
    yet been configured.
    
    This patch adds an explicit check for DF_CONFIGURED, and fails with
    -ENODEV to avoid this case.
    
    Reported-by: Chris Boot <crb@tiger-computing.co.uk>
    Reported-by: Philip Gaw <pgaw@darktech.org.uk>
    Cc: Chris Boot <crb@tiger-computing.co.uk>
    Cc: Philip Gaw <pgaw@darktech.org.uk>
    Cc: stable@vger.kernel.org # 3.8+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit e7810c2d2c37fa8e58dda74b00790dab60fe6fba
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Thu Jun 5 23:37:00 2014 -0700

    target: Allow READ_CAPACITY opcode in ALUA Standby access state
    
    This patch allows READ_CAPACITY + SAI_READ_CAPACITY_16 opcode
    processing to occur while the associated ALUA group is in Standby
    access state.
    
    This is required to avoid host side LUN probe failures during the
    initial scan if an ALUA group has already implicitly changed into
    Standby access state.
    
    This addresses a bug reported by Chris + Philip using dm-multipath
    + ESX hosts configured with ALUA multipath.
    
    Reported-by: Chris Boot <crb@tiger-computing.co.uk>
    Reported-by: Philip Gaw <pgaw@darktech.org.uk>
    Cc: Chris Boot <crb@tiger-computing.co.uk>
    Cc: Philip Gaw <pgaw@darktech.org.uk>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: stable@vger.kernel.org
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 177875423eb01179738f6badcbb9eef4be789a0e
Merge: 3e1a878 a3530e8
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Thu Jun 5 13:09:44 2014 -0700

    Merge tag 'efi-urgent' into x86/urgent
    
     * Fix earlyprintk=efi,keep support by switching to an ioremap() mapping
       of the framebuffer when early_ioremap() is no longer available and
       dropping __init from functions that may be invoked after
       free_initmem() - Dave Young
    
     * We shouldn't be exporting the EFI runtime map in sysfs if not using
       the new 1:1 EFI mapping code since in that case the mappings are not
       static across a kexec reboot - Dave Young
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

commit 951e273060d15b233a7f7ccaf76ba682b5b05a03
Merge: 1c5aefb 22c91aa
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 5 12:51:05 2014 -0700

    Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull perf fixes from Ingo Molnar:
     "Two last minute tooling fixes"
    
    * 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      perf probe: Fix perf probe to find correct variable DIE
      perf probe: Fix a segfault if asked for variable it doesn't find

commit 1c5aefb5b12a90e29866c960a57c1f8f75def617
Merge: 54539cd 54a2178
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 5 12:31:32 2014 -0700

    Merge branch 'futex-fixes' (futex fixes from Thomas Gleixner)
    
    Merge futex fixes from Thomas Gleixner:
     "So with more awake and less futex wreckaged brain, I went through my
      list of points again and came up with the following 4 patches.
    
      1) Prevent pi requeueing on the same futex
    
         I kept Kees check for uaddr1 == uaddr2 as a early check for private
         futexes and added a key comparison to both futex_requeue and
         futex_wait_requeue_pi.
    
         Sebastian, sorry for the confusion yesterday night.  I really
         misunderstood your question.
    
         You are right the check is pointless for shared futexes where the
         same physical address is mapped to two different virtual addresses.
    
      2) Sanity check atomic acquisiton in futex_lock_pi_atomic
    
         That's basically what Darren suggested.
    
         I just simplified it to use futex_top_waiter() to find kernel
         internal state.  If state is found return -EINVAL and do not bother
         to fix up the user space variable.  It's corrupted already.
    
      3) Ensure state consistency in futex_unlock_pi
    
         The code is silly versus the owner died bit.  There is no point to
         preserve it on unlock when the user space thread owns the futex.
    
         What's worse is that it does not update the user space value when
         the owner died bit is set.  So the kernel itself creates observable
         inconsistency.
    
         Another "optimization" is to retry an atomic unlock.  That's
         pointless as in a sane environment user space would not call into
         that code if it could have unlocked it atomically.  So we always
         check whether there is kernel state around and only if there is
         none, we do the unlock by setting the user space value to 0.
    
      4) Sanitize lookup_pi_state
    
         lookup_pi_state is ambigous about TID == 0 in the user space value.
    
         This can be a valid state even if there is kernel state on this
         uaddr, but we miss a few corner case checks.
    
         I tried to come up with a smaller solution hacking the checks into
         the current cruft, but it turned out to be ugly as hell and I got
         more confused than I was before.  So I rewrote the sanity checks
         along the state documentation with awful lots of commentry"
    
    * emailed patches from Thomas Gleixner <tglx@linutronix.de>:
      futex: Make lookup_pi_state more robust
      futex: Always cleanup owner tid in unlock_pi
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)

commit 54a217887a7b658e2650c3feff22756ab80c7339
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jun 3 12:27:08 2014 +0000

    futex: Make lookup_pi_state more robust
    
    The current implementation of lookup_pi_state has ambigous handling of
    the TID value 0 in the user space futex.  We can get into the kernel
    even if the TID value is 0, because either there is a stale waiters bit
    or the owner died bit is set or we are called from the requeue_pi path
    or from user space just for fun.
    
    The current code avoids an explicit sanity check for pid = 0 in case
    that kernel internal state (waiters) are found for the user space
    address.  This can lead to state leakage and worse under some
    circumstances.
    
    Handle the cases explicit:
    
           Waiter | pi_state | pi->owner | uTID      | uODIED | ?
    
      [1]  NULL   | ---      | ---       | 0         | 0/1    | Valid
      [2]  NULL   | ---      | ---       | >0        | 0/1    | Valid
    
      [3]  Found  | NULL     | --        | Any       | 0/1    | Invalid
    
      [4]  Found  | Found    | NULL      | 0         | 1      | Valid
      [5]  Found  | Found    | NULL      | >0        | 1      | Invalid
    
      [6]  Found  | Found    | task      | 0         | 1      | Valid
    
      [7]  Found  | Found    | NULL      | Any       | 0      | Invalid
    
      [8]  Found  | Found    | task      | ==taskTID | 0/1    | Valid
      [9]  Found  | Found    | task      | 0         | 0      | Invalid
      [10] Found  | Found    | task      | !=taskTID | 0/1    | Invalid
    
     [1] Indicates that the kernel can acquire the futex atomically. We
         came came here due to a stale FUTEX_WAITERS/FUTEX_OWNER_DIED bit.
    
     [2] Valid, if TID does not belong to a kernel thread. If no matching
         thread is found then it indicates that the owner TID has died.
    
     [3] Invalid. The waiter is queued on a non PI futex
    
     [4] Valid state after exit_robust_list(), which sets the user space
         value to FUTEX_WAITERS | FUTEX_OWNER_DIED.
    
     [5] The user space value got manipulated between exit_robust_list()
         and exit_pi_state_list()
    
     [6] Valid state after exit_pi_state_list() which sets the new owner in
         the pi_state but cannot access the user space value.
    
     [7] pi_state->owner can only be NULL when the OWNER_DIED bit is set.
    
     [8] Owner and user space value match
    
     [9] There is no transient state which sets the user space TID to 0
         except exit_robust_list(), but this is indicated by the
         FUTEX_OWNER_DIED bit. See [4]
    
    [10] There is no transient state which leaves owner and user space
         TID out of sync.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Kees Cook <keescook@chromium.org>
    Cc: Will Drewry <wad@chromium.org>
    Cc: Darren Hart <dvhart@linux.intel.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 13fbca4c6ecd96ec1a1cfa2e4f2ce191fe928a5e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jun 3 12:27:07 2014 +0000

    futex: Always cleanup owner tid in unlock_pi
    
    If the owner died bit is set at futex_unlock_pi, we currently do not
    cleanup the user space futex.  So the owner TID of the current owner
    (the unlocker) persists.  That's observable inconsistant state,
    especially when the ownership of the pi state got transferred.
    
    Clean it up unconditionally.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Kees Cook <keescook@chromium.org>
    Cc: Will Drewry <wad@chromium.org>
    Cc: Darren Hart <dvhart@linux.intel.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit b3eaa9fc5cd0a4d74b18f6b8dc617aeaf1873270
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jun 3 12:27:06 2014 +0000

    futex: Validate atomic acquisition in futex_lock_pi_atomic()
    
    We need to protect the atomic acquisition in the kernel against rogue
    user space which sets the user space futex to 0, so the kernel side
    acquisition succeeds while there is existing state in the kernel
    associated to the real owner.
    
    Verify whether the futex has waiters associated with kernel state.  If
    it has, return -EINVAL.  The state is corrupted already, so no point in
    cleaning it up.  Subsequent calls will fail as well.  Not our problem.
    
    [ tglx: Use futex_top_waiter() and explain why we do not need to try
      	restoring the already corrupted user space state. ]
    
    Signed-off-by: Darren Hart <dvhart@linux.intel.com>
    Cc: Kees Cook <keescook@chromium.org>
    Cc: Will Drewry <wad@chromium.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit e9c243a5a6de0be8e584c604d353412584b592f8
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Jun 3 12:27:06 2014 +0000

    futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
    
    If uaddr == uaddr2, then we have broken the rule of only requeueing from
    a non-pi futex to a pi futex with this call.  If we attempt this, then
    dangling pointers may be left for rt_waiter resulting in an exploitable
    condition.
    
    This change brings futex_requeue() in line with futex_wait_requeue_pi()
    which performs the same check as per commit 6f7b0a2a5c0f ("futex: Forbid
    uaddr == uaddr2 in futex_wait_requeue_pi()")
    
    [ tglx: Compare the resulting keys as well, as uaddrs might be
      	different depending on the mapping ]
    
    Fixes CVE-2014-3153.
    
    Reported-by: Pinkie Pie
    Signed-off-by: Will Drewry <wad@chromium.org>
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Reviewed-by: Darren Hart <dvhart@linux.intel.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Jun 5 15:42:45 2014 +0200

    x86/smpboot: Initialize secondary CPU only if master CPU will wait for it
    
    Hang is observed on virtual machines during CPU hotplug,
    especially in big guests with many CPUs. (It reproducible
    more often if host is over-committed).
    
    It happens because master CPU gives up waiting on
    secondary CPU and allows it to run wild. As result
    AP causes locking or crashing system. For example
    as described here:
    
       https://lkml.org/lkml/2014/3/6/257
    
    If master CPU have sent STARTUP IPI successfully,
    and AP signalled to master CPU that it's ready
    to start initialization, make master CPU wait
    indefinitely till AP is onlined.
    To ensure that AP won't ever run wild, make it
    wait at early startup till master CPU confirms its
    intention to wait for AP. If AP doesn't respond in 10
    seconds, the master CPU will timeout and cancel
    AP onlining.
    
    Signed-off-by: Igor Mammedov <imammedo@redhat.com>
    Acked-by: Toshi Kani <toshi.kani@hp.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/1401975765-22328-4-git-send-email-imammedo@redhat.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit feef1e8ecbadf24f8e6829c935df8683cabae41b
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Jun 5 15:42:44 2014 +0200

    x86/smpboot: Log error on secondary CPU wakeup failure at ERR level
    
    If system is running without debug level logging,
    it will not log error if do_boot_cpu() failed to
    wakeup AP. It may lead to silent AP bringup
    failures at boot time.
    Change message level to KERN_ERR to make error
    visible to user as it's done on other architectures.
    
    Signed-off-by: Igor Mammedov <imammedo@redhat.com>
    Acked-by: Toshi Kani <toshi.kani@hp.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/1401975765-22328-3-git-send-email-imammedo@redhat.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 89f898c1e195fa6235c869bb457e500b7b3ac49d
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Jun 5 15:42:43 2014 +0200

    x86: Fix list/memory corruption on CPU hotplug
    
    currently if AP wake up is failed, master CPU marks AP as not
    present in do_boot_cpu() by calling set_cpu_present(cpu, false).
    That leads to following list corruption on the next physical CPU
    hotplug:
    
    [  418.107336] WARNING: CPU: 1 PID: 45 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
    [  418.115268] list_add corruption. prev->next should be next (ffff88003dc57600), but was ffff88003e20c3a0. (prev=ffff88003e20c3a0).
    [  418.123693] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipt_REJECT cfg80211 xt_conntrack rfkill ee
    [  418.138979] CPU: 1 PID: 45 Comm: kworker/u10:1 Not tainted 3.14.0-rc6+ #387
    [  418.149989] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
    [  418.165750] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
    [  418.166433]  0000000000000021 ffff880038ca7988 ffffffff8159b22d 0000000000000021
    [  418.176460]  ffff880038ca79d8 ffff880038ca79c8 ffffffff8106942c ffff880038ca79e8
    [  418.177453]  ffff88003e20c3a0 ffff88003dc57600 ffff88003e20c3a0 00000000ffffffea
    [  418.178445] Call Trace:
    [  418.185811]  [<ffffffff8159b22d>] dump_stack+0x49/0x5c
    [  418.186440]  [<ffffffff8106942c>] warn_slowpath_common+0x8c/0xc0
    [  418.187192]  [<ffffffff81069516>] warn_slowpath_fmt+0x46/0x50
    [  418.191231]  [<ffffffff8136ef51>] ? acpi_ns_get_node+0xb7/0xc7
    [  418.193889]  [<ffffffff812f796e>] __list_add+0xbe/0xd0
    [  418.196649]  [<ffffffff812e2aa9>] kobject_add_internal+0x79/0x200
    [  418.208610]  [<ffffffff812e2e18>] kobject_add_varg+0x38/0x60
    [  418.213831]  [<ffffffff812e2ef4>] kobject_add+0x44/0x70
    [  418.229961]  [<ffffffff813e2c60>] device_add+0xd0/0x550
    [  418.234991]  [<ffffffff813f0e95>] ? pm_runtime_init+0xe5/0xf0
    [  418.250226]  [<ffffffff813e32be>] device_register+0x1e/0x30
    [  418.255296]  [<ffffffff813e82a3>] register_cpu+0xe3/0x130
    [  418.266539]  [<ffffffff81592be5>] arch_register_cpu+0x65/0x150
    [  418.285845]  [<ffffffff81355c0d>] acpi_processor_hotadd_init+0x5a/0x9b
    ...
    Which is caused by the fact that generic_processor_info() allocates
    logical CPU id by calling:
    
     cpu = cpumask_next_zero(-1, cpu_present_mask);
    
    which returns id of previously failed to wake up CPU, since its
    bit is cleared by do_boot_cpu() and as result register_cpu()
    tries to register another CPU with the same id as already
    present but failed to be onlined CPU.
    
    Taking in account that AP will not do anything if master CPU
    failed to wake it up, there is no reason to mark that AP as not
    present and break next cpu hotplug attempts. As a side effect of
    not marking AP as not present, user would be allowed to online
    it again later.
    
    Also fix memory corruption in acpi_unmap_lsapic()
    
    if during CPU hotplug master CPU failed to wake up AP
    it set percpu x86_cpu_to_apicid to BAD_APICID=0xFFFF for AP.
    
    However following attempt to unplug that CPU will lead to
    out of bound write access to __apicid_to_node[] which is
    32768 items long on x86_64 kernel.
    
    So with above fix of cpu_present_mask make sure that a present
    CPU has a valid APIC ID by not setting x86_cpu_to_apicid
    to BAD_APICID in do_boot_cpu() on failure and allow
    acpi_processor_remove()->acpi_unmap_lsapic() cleanly remove CPU.
    
    Signed-off-by: Igor Mammedov <imammedo@redhat.com>
    Acked-by: Toshi Kani <toshi.kani@hp.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/1401975765-22328-2-git-send-email-imammedo@redhat.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 09dc4ab03936df5c5aa711d27c81283c6d09f495
Author: Roman Gushchin <klamm@yandex-team.ru>
Date:   Mon May 19 15:10:09 2014 +0400

    sched/fair: Fix tg_set_cfs_bandwidth() deadlock on rq->lock
    
    tg_set_cfs_bandwidth() sets cfs_b->timer_active to 0 to
    force the period timer restart. It's not safe, because
    can lead to deadlock, described in commit 927b54fccbf0:
    "__start_cfs_bandwidth calls hrtimer_cancel while holding rq->lock,
    waiting for the hrtimer to finish. However, if sched_cfs_period_timer
    runs for another loop iteration, the hrtimer can attempt to take
    rq->lock, resulting in deadlock."
    
    Three CPUs must be involved:
    
      CPU0               CPU1                         CPU2
      take rq->lock      period timer fired
      ...                take cfs_b lock
      ...                ...                          tg_set_cfs_bandwidth()
      throttle_cfs_rq()  release cfs_b lock           take cfs_b lock
      ...                distribute_cfs_runtime()     timer_active = 0
      take cfs_b->lock   wait for rq->lock            ...
      __start_cfs_bandwidth()
      {wait for timer callback
       break if timer_active == 1}
    
    So, CPU0 and CPU1 are deadlocked.
    
    Instead of resetting cfs_b->timer_active, tg_set_cfs_bandwidth can
    wait for period timer callbacks (ignoring cfs_b->timer_active) and
    restart the timer explicitly.
    
    Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
    Reviewed-by: Ben Segall <bsegall@google.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/87wqdi9g8e.wl\%klamm@yandex-team.ru
    Cc: pjt@google.com
    Cc: chris.j.arges@canonical.com
    Cc: gregkh@linuxfoundation.org
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 0f397f2c90ce68821ee864c2c53baafe78de765d
Author: Kirill Tkhai <tkhai@yandex.ru>
Date:   Tue May 20 13:33:42 2014 +0400

    sched/dl: Fix race in dl_task_timer()
    
    Throttled task is still on rq, and it may be moved to other cpu
    if user is playing with sched_setaffinity(). Therefore, unlocked
    task_rq() access makes the race.
    
    Juri Lelli reports he got this race when dl_bandwidth_enabled()
    was not set.
    
    Other thing, pointed by Peter Zijlstra:
    
       "Now I suppose the problem can still actually happen when
        you change the root domain and trigger a effective affinity
        change that way".
    
    To fix that we do the same as made in __task_rq_lock(). We do not
    use __task_rq_lock() itself, because it has a useful lockdep check,
    which is not correct in case of dl_task_timer(). We do not need
    pi_lock locked here. This case is an exception (PeterZ):
    
       "The only reason we don't strictly need ->pi_lock now is because
        we're guaranteed to have p->state == TASK_RUNNING here and are
        thus free of ttwu races".
    
    Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@vger.kernel.org> # v3.14+
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/3056991400578422@web14g.yandex.ru
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit b14ed2c273f8ab872ae4e6735fe5ab09cb14b8c3
Author: Richard Weinberger <richard@nod.at>
Date:   Mon Jun 2 22:38:34 2014 +0200

    sched: Fix sched_policy < 0 comparison
    
    attr.sched_policy is u32, therefore a comparison against < 0 is never true.
    Fix this by casting sched_policy to int.
    
    This issue was reported by coverity CID 1219934.
    
    Fixes: dbdb22754fde ("sched: Disallow sched_attr::sched_policy < 0")
    Signed-off-by: Richard Weinberger <richard@nod.at>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/1401741514-7045-1-git-send-email-richard@nod.at
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit e9dd685ce81815811fb4da72e6ab10a694ac8468
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Tue May 27 17:02:04 2014 -0400

    sched/numa: Fix use of spin_{un}lock_irq() when interrupts are disabled
    
    As Peter Zijlstra told me, we have the following path:
    
    do_exit()
      exit_itimers()
        itimer_delete()
          spin_lock_irqsave(&timer->it_lock, &flags);
          timer_delete_hook(timer);
            kc->timer_del(timer) := posix_cpu_timer_del()
              put_task_struct()
                __put_task_struct()
                  task_numa_free()
                    spin_lock(&grp->lock);
    
    Which means that task_numa_free() can be called with interrupts
    disabled, which means that we should not be using spin_lock_irq() but
    spin_lock_irqsave() instead. Otherwise we are enabling interrupts while
    holding an interrupt unsafe lock!
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Thomas Gleixner<tglx@linutronix.de>
    Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/20140527182541.GH11096@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 22c91aa23547a4363fd2a9ffddde95c899ac8aa0
Merge: fad01e8 082f96a
Author: Ingo Molnar <mingo@kernel.org>
Date:   Thu Jun 5 09:52:41 2014 +0200

    Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent
    
    Pull perf/urgent fixes from Jiri Olsa:
    
     * Fix perf probe to find correct variable DIE (Masami Hiramatsu)
    
     * Fix a segfault in perf probe if asked for variable it doesn't find (Masami Hiramatsu)
    
    Signed-off-by: Jiri Olsa <jolsa@kernel.org>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 54539cd217d687d9acf385eab22ec02b3f7a86a0
Merge: c717d15 0c36b39
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 4 09:56:03 2014 -0700

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
    
    Pull percpu fix from Tejun Heo:
     "It is very late but this is an important percpu-refcount fix from
      Sebastian Ott.
    
      The problem is that percpu_ref_*() used __this_cpu_*() instead of
      this_cpu_*().  The difference between the two is that the latter is
      atomic on the local cpu while the former is not.  this_cpu_inc() is
      guaranteed to increment the percpu counter on the cpu that the
      operation is executed on without any synchronization; however,
      __this_cpu_inc() doesn't and if the local cpu invokes the function
      from different contexts (e.g.  process and irq) of the same CPU, it's
      not guaranteed to actually increment as it may be implemented as rmw.
    
      This bug existed from the get-go but it hasn't been noticed earlier
      probably because on x86 __this_cpu_inc() is equivalent to
      this_cpu_inc() as both get translated into single instruction;
      however, s390 uses the generic rmw implementation and gets affected by
      the bug.  Kudos to Sebastian and Heiko for diagnosing it.
    
      The change is very low risk and fixes a critical issue on the affected
      architectures, so I think it's a good candidate for inclusion although
      it's very late in the devel cycle.  On the other hand, this has been
      broken since v3.11, so backporting it through -stable post -rc1 won't
      be the end of the world.
    
      I'll ping Christoph whether __this_cpu_*() ops can be better annotated
      so that it can trigger lockdep warning when used from multiple
      contexts"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu:
      percpu-refcount: fix usage of this_cpu_ops

commit 0c36b390a546055b6815d4b93a2c9fed4d980ffb
Author: Sebastian Ott <sebott@linux.vnet.ibm.com>
Date:   Wed Jun 4 15:58:24 2014 +0200

    percpu-refcount: fix usage of this_cpu_ops
    
    The percpu-refcount infrastructure uses the underscore variants of
    this_cpu_ops in order to modify percpu reference counters.
    (e.g. __this_cpu_inc()).
    
    However the underscore variants do not atomically update the percpu
    variable, instead they may be implemented using read-modify-write
    semantics (more than one instruction).  Therefore it is only safe to
    use the underscore variant if the context is always the same (process,
    softirq, or hardirq). Otherwise it is possible to lose updates.
    
    This problem is something that Sebastian has seen within the aio
    subsystem which uses percpu refcounters both in process and softirq
    context leading to reference counts that never dropped to zeroes; even
    though the number of "get" and "put" calls matched.
    
    Fix this by using the non-underscore this_cpu_ops variant which
    provides correct per cpu atomic semantics and fixes the corrupted
    reference counts.
    
    Cc: Kent Overstreet <kmo@daterainc.com>
    Cc: <stable@vger.kernel.org> # v3.11+
    Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    References: http://lkml.kernel.org/g/alpine.LFD.2.11.1406041540520.21183@denkbrett

commit c717d1561493c58d030405c7e30e35459db31912
Merge: 9e9a928 bf81022
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 4 07:48:54 2014 -0700

    Merge tag 'pm-3.15-final' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
    
    Pull intel pstate fixes from Rafael Wysocki:
     "Final power management fixes for 3.15
    
       - Taking non-idle time into account when calculating core busy time
         was a mistake and led to a performance regression.  Since the
         problem it was supposed to address is now taken care of in a
         different way, we don't need to do it any more, so drop the
         non-idle time tracking from intel_pstate.  Dirk Brandewie.
    
       - Changing to fixed point math throughout the busy calculation
         introduced rounding errors that adversely affect the accuracy of
         intel_pstate's computations.  Fix from Dirk Brandewie.
    
       - The PID controller algorithm used by intel_pstate assumes that the
         time interval between two adjacent samples will always be the same
         which is not the case for deferable timers (used by intel_pstate)
         when the system is idle.  This leads to inaccurate predictions and
         artificially increases convergence times for the minimum P-state.
         Fix from Dirk Brandewie.
    
       - intel_pstate carries out computations using 32-bit variables that
         may overflow for large enough values of APERF/MPERF.  Switch to
         using 64-bit variables for computations, from Doug Smythies"
    
    * tag 'pm-3.15-final' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm:
      intel_pstate: Improve initial busy calculation
      intel_pstate: add sample time scaling
      intel_pstate: Correct rounding in busy calculation
      intel_pstate: Remove C0 tracking

commit 9e9a928eed8796a0a1aaed7e0b676db86ba84594
Merge: d2cfd31 0a4ae72
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 4 07:48:01 2014 -0700

    Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
    
    Pull drm fixes from Dave Airlie:
     "All fairly small: radeon stability and a panic path fix.
    
      Mostly radeon fixes, suspend/resume fix, stability on the CIK
      chipsets, along with a locking check avoidance patch for panic times
      regression"
    
    * 'drm-fixes' of git://people.freedesktop.org/~airlied/linux:
      drm/radeon: use the CP DMA on CIK
      drm/radeon: sync page table updates
      drm/radeon: fix vm buffer size estimation
      drm/crtc-helper: skip locking checks in panicking path
      drm/radeon/dpm: resume fixes for some systems

commit 082f96a93eb5ba9bf771518a0dda590624568e8e
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Thu May 29 21:19:30 2014 +0900

    perf probe: Fix perf probe to find correct variable DIE
    
    Fix perf probe to find correct variable DIE which has location or
    external instance by tracking down the lexical blocks.
    
    Current die_find_variable() expects that the all variable DIEs
    which has DW_TAG_variable have a location. However, since recent
    dwarf information may have declaration variable DIEs at the
    entry of function (subprogram), die_find_variable() returns it.
    
    To solve this problem, it must track down the DIE tree to find
    a DIE which has an actual location or a reference for external
    instance.
    
    e.g. finding a DIE which origin is <0xdc73>;
    
     <1><11496>: Abbrev Number: 95 (DW_TAG_subprogram)
        <11497>   DW_AT_abstract_origin: <0xdc42>
        <1149b>   DW_AT_low_pc      : 0x1850
    [...]
     <2><114cc>: Abbrev Number: 119 (DW_TAG_variable) <- this is a declaration
        <114cd>   DW_AT_abstract_origin: <0xdc73>
     <2><114d1>: Abbrev Number: 119 (DW_TAG_variable)
    [...]
     <3><115a7>: Abbrev Number: 105 (DW_TAG_lexical_block)
        <115a8>   DW_AT_ranges      : 0xaa0
     <4><115ac>: Abbrev Number: 96 (DW_TAG_variable) <- this has a location
        <115ad>   DW_AT_abstract_origin: <0xdc73>
        <115b1>   DW_AT_location    : 0x486c        (location list)
    
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Tested-by: Arnaldo Carvalho de Melo <acme@kernel.org>
    Acked-by: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Link: http://lkml.kernel.org/r/20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp
    Signed-off-by: Jiri Olsa <jolsa@kernel.org>

commit 0c188a07b6a399e3df66534c29fef0a2082aaf57
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Thu May 29 19:52:32 2014 +0900

    perf probe: Fix a segfault if asked for variable it doesn't find
    
    Fix a segfault bug by asking for variable it doesn't find.
    Since the convert_variable() didn't handle error code returned
    from convert_variable_location(), it just passed an incomplete
    variable field and then a segfault was occurred when formatting
    the field.
    
    This fixes that bug by handling success code correctly in
    convert_variable(). Other callers of convert_variable_location()
    are correctly checking the return code.
    
    This bug was introduced by following commit. But another hidden
    erroneous error handling has been there previously (-ENOMEM case).
    
     commit 3d918a12a1b3088ac16ff37fa52760639d6e2403
    
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
    Tested-by: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Link: http://lkml.kernel.org/r/20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp
    Signed-off-by: Jiri Olsa <jolsa@kernel.org>

commit ac2a55395eddccd6e3e39532df9869d61e97b2ee
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Tue May 13 11:39:34 2014 -0400

    x86: irq: Get correct available vectors for cpu disable
    
    check_irq_vectors_for_cpu_disable() can overestimate the number of
    available interrupt vectors, so the check for cpu down succeeds, but
    the actual cpu removal fails.
    
    It iterates from FIRST_EXTERNAL_VECTOR to NR_VECTORS, which is wrong
    because the systems vectors are not taken into account.
    
    Limit the search to first_system_vector instead of NR_VECTORS.
    
    The second indicator for vector availability the used_vectors bitmap
    is not taken into account at all. So system vectors,
    e.g. IA32_SYSCALL_VECTOR (0x80) and IRQ_MOVE_CLEANUP_VECTOR (0x20),
    are accounted as available.
    
    Add a check for the used_vectors bitmap and do not account vectors
    which are marked there.
    
    [ tglx: Simplified code. Rewrote changelog and code comments. ]
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Acked-by: Prarit Bhargava <prarit@redhat.com>
    Cc: Seiji Aguchi <seiji.aguchi@hds.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: K. Y. Srinivasan <kys@microsoft.com>
    Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
    Cc: x86@kernel.org
    Link: http://lkml.kernel.org/r/1400160305-17774-2-git-send-email-prarit@redhat.com
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 0a4ae727d6aa459247b027387edb6ff99f657792
Merge: ba6f582 91b0275
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jun 4 13:29:13 2014 +1000

    Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes
    
    The first one is a one liner fixing a stupid typo in the VM handling code and is only relevant if play with one of the VM defines.
    
    The other two switches CIK to use the CPDMA instead of the SDMA for buffer moves, as it turned out the SDMA is still sometimes not 100% reliable.
    
    * 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux:
      drm/radeon: use the CP DMA on CIK
      drm/radeon: sync page table updates
      drm/radeon: fix vm buffer size estimation

commit 2363d196686e44c0158929e7cf96c8589a24a81b
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Tue Jun 3 18:27:52 2014 -0700

    iser-target: Fix multi network portal shutdown regression
    
    This patch fixes a iser-target specific regression introduced in
    v3.15-rc6 with:
    
    commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a
    Author: Sagi Grimberg <sagig@mellanox.com>
    Date:   Tue Apr 29 13:13:47 2014 +0300
    
        Target/iscsi,iser: Avoid accepting transport connections during stop stage
    
    where the change to set iscsi_np->enabled = false within
    iscsit_clear_tpg_np_login_thread() meant that a iscsi_np with
    two iscsi_tpg_np exports would have it's parent iscsi_np set
    to a disabled state, even if other iscsi_tpg_np exports still
    existed.
    
    This patch changes iscsit_clear_tpg_np_login_thread() to only
    set iscsi_np->enabled = false when shutdown = true, and also
    changes iscsit_del_np() to set iscsi_np->enabled = true when
    iscsi_np->np_exports is non zero.
    
    Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 79d59d08082dd0a0a18f8ceb78c99f9f321d72aa
Author: Roland Dreier <roland@purestorage.com>
Date:   Thu May 29 13:32:30 2014 -0700

    iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param_value()
    
    In non-leading connection login, iscsi_login_non_zero_tsih_s1() calls
    iscsi_change_param_value() with the buffer it uses to hold the login
    PDU, not a temporary buffer.  This leads to the login header getting
    corrupted and login failing for non-leading connections in MC/S.
    
    Fix this by adding a wrapper iscsi_change_param_sprintf() that handles
    the temporary buffer itself to avoid confusion.  Also handle sending a
    reject in case of failure in the wrapper, which lets the calling code
    get quite a bit smaller and easier to read.
    
    Finally, bump the size of the temporary buffer from 32 to 64 bytes to be
    safe, since "MaxRecvDataSegmentLength=" by itself is 25 bytes; with a
    trailing NUL, a value >= 1M will lead to a buffer overrun.  (This isn't
    the default but we don't need to run right at the ragged edge here)
    
    Reported-by: Santosh Kulkarni <santosh.kulkarni@calsoftinc.com>
    Signed-off-by: Roland Dreier <roland@purestorage.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 6cc44a6fb46e1ecc1c28125aa8fa34d317aa9ea7
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri May 23 00:48:35 2014 -0700

    iser-target: Add missing target_put_sess_cmd for ImmedateData failure
    
    This patch addresses a bug where an early exception for SCSI WRITE
    with ImmediateData=Yes was missing the target_put_sess_cmd() call
    to drop the extra se_cmd->cmd_kref reference obtained during the
    normal iscsit_setup_scsi_cmd() codepath execution.
    
    This bug was manifesting itself during session shutdown within
    isert_cq_rx_comp_err() where target_wait_for_sess_cmds() would
    end up waiting indefinately for the last se_cmd->cmd_kref put to
    occur for the failed SCSI WRITE + ImmediateData descriptors.
    
    This fix follows what traditional iscsi-target code already does
    for the same failure case within iscsit_get_immediate_data().
    
    Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
    Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
    Cc: Or Gerlitz <ogerlitz@mellanox.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit d2cfd3105094f593bc1fbd0b042a7752ddf08691
Merge: c9482a5 192a98e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jun 3 12:07:30 2014 -0700

    Merge tag 'sound-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
    
    Pull sound fixes from Takashi Iwai:
     "A few addition of HD-audio fixups for ALC260 and AD1986A codecs.  All
      marked as stable fixes.
    
      The fixes are pretty local and they are old machines, so quite safe to
      apply"
    
    * tag 'sound-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound:
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
      ALSA: hda/analog - Fix silent output on ASUS A8JN

commit c9482a5bdcc09be9096f40e858c5fe39c389cd52
Author: Jianyu Zhan <nasa4836@gmail.com>
Date:   Sat Apr 26 15:40:28 2014 +0800

    kernfs: move the last knowledge of sysfs out from kernfs
    
    There is still one residue of sysfs remaining: the sb_magic
    SYSFS_MAGIC. However this should be kernfs user specific,
    so this patch moves it out. Kerrnfs user should specify their
    magic number while mouting.
    
    Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit cae61ba37b4c2672704cbd8a626fbd85be7e67d9
Merge: ca75517 418c96a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 2 18:16:41 2014 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Pull networking fixes from David Miller:
    
     1) Unbreak zebra and other netlink apps, from Eric W Biederman.
    
     2) Some new qmi_wwan device IDs, from Aleksander Morgado.
    
     3) Fix info leak in DCB netlink handler of qlcnic driver, from Dan
        Carpenter.
    
     4) inet_getid() and ipv6_select_ident() do not generate monotonically
        increasing ID numbers, fix from Eric Dumazet.
    
     5) Fix memory leak in __sk_prepare_filter(), from Leon Yu.
    
     6) Netlink leftover bytes warning message is user triggerable, rate
        limit it.  From Michal Schmidt.
    
     7) Fix non-linear SKB panic in ipvs, from Peter Christensen.
    
     8) Congestion window undo needs to be performed even if only never
        retransmitted data is SACK'd, fix from Yuching Cheng.
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net: (24 commits)
      net: filter: fix possible memory leak in __sk_prepare_filter()
      net: ec_bhf: Add runtime dependencies
      tcp: fix cwnd undo on DSACK in F-RTO
      netlink: Only check file credentials for implicit destinations
      ipheth: Add support for iPad 2 and iPad 3
      team: fix mtu setting
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: qmi_wwan: interface #11 in Sierra Wireless MC73xx is not QMI
      net: qmi_wwan: add additional Sierra Wireless QMI devices
      bridge: Prevent insertion of FDB entry with disallowed vlan
      netlink: rate-limit leftover bytes warning and print process name
      bridge: notify user space after fdb update
      net: qmi_wwan: add Netgear AirCard 341U
      net: fix wrong mac_len calculation for vlans
      batman-adv: fix NULL pointer dereferences
      net/mlx4_core: Reset RoCE VF gids when guest driver goes down
      emac: aggregation of v1-2 PLB errors for IER register
      emac: add missing support of 10mbit in emac/rgmii
      can: only rename enabled led triggers when changing the netdev name
      ipvs: Fix panic due to non-linear skb
      ...

commit 418c96ac151a16a5094a95d14252c92c1d47ec67
Author: Leon Yu <chianglungyu@gmail.com>
Date:   Sun Jun 1 05:37:25 2014 +0000

    net: filter: fix possible memory leak in __sk_prepare_filter()
    
    __sk_prepare_filter() was reworked in commit bd4cf0ed3 (net: filter:
    rework/optimize internal BPF interpreter's instruction set) so that it should
    have uncharged memory once things went wrong. However that work isn't complete.
    Error is handled only in __sk_migrate_filter() while memory can still leak in
    the error path right after sk_chk_filter().
    
    Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
    Signed-off-by: Leon Yu <chianglungyu@gmail.com>
    Acked-by: Alexei Starovoitov <ast@plumgrid.com>
    Tested-by: Alexei Starovoitov <ast@plumgrid.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ca755175f245b91f72cfa474aaa8acd9c26996f4
Merge: 3b8d267 2ac295a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 2 17:04:37 2014 -0700

    Merge tag 'md/3.15-fixes' of git://neil.brown.name/md
    
    Pull two md bugfixes from Neil Brown:
     "Two md bugfixes for possible corruption when restarting reshape
    
      If a raid5/6 reshape is restarted (After stopping and re-assembling
      the array) and the array is marked read-only (or read-auto), then the
      reshape will appear to complete immediately, without actually moving
      anything around.  This can result in corruption.
    
      There are two patches which do much the same thing in different
      places.  They are separate because one is an older bug and so can be
      applied to more -stable kernels"
    
    * tag 'md/3.15-fixes' of git://neil.brown.name/md:
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".

commit 3aab01d800eb195de3f273d9a195fe070a507d56
Author: Jean Delvare <jdelvare@suse.de>
Date:   Sat May 31 17:32:27 2014 +0200

    net: ec_bhf: Add runtime dependencies
    
    The ec_bhf driver is specific to the Beckhoff CX embedded PC series.
    These are based on Intel x86 CPU. So we can add a dependency on
    X86, with COMPILE_TEST as an alternative to still allow for broader
    build-testing.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Cc: Darek Marcinkiewicz <reksio@newterm.pl>
    Cc: David S. Miller <davem@davemloft.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 3b8d2676d15d6b2326757adb66b70a9cd6650373
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Mon Jun 2 19:57:16 2014 -0400

    libata: Blacklist queued trim for Crucial M500
    
    Queued trim only works for some users with MU05 firmware.  Revert to
    blacklisting all firmware versions.
    
    Introduced by commit d121f7d0cbb8 ("libata: Update queued trim blacklist
    for M5x0 drives") which this effectively reverts, while retaining the
    blacklisting of M550.
    
    See
    
        https://bugzilla.kernel.org/show_bug.cgi?id=71371
    
    for reports of trouble with MU05 firmware.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 92b4e113155f9c8de9ef71ecdf55d796b68e7318
Merge: 8ee7a33 368b69a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 2 16:57:23 2014 -0700

    Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull x86 fix from Peter Anvin:
     "A single quite small patch that managed to get overlooked earlier, to
      prevent a user space triggerable oops on systems without HPET"
    
    * 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET

commit 8ee7a330fbb78344802cc6c3cc8be023b6d05aa0
Merge: da579dd 5dc2808
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 2 16:56:42 2014 -0700

    Merge tag 'usb-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
    
    Pull USB fixes from Greg KH:
     "Here are some fixes for 3.15-rc8 that resolve a number of tiny USB
      issues that have been reported, and there are some new device ids as
      well.
    
      All have been tested in linux-next"
    
    * tag 'usb-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb:
      xhci: delete endpoints from bandwidth list before freeing whole device
      usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
      USB: cdc-wdm: properly include types.h
      usb: cdc-wdm: export cdc-wdm uapi header
      USB: serial: option: add support for Novatel E371 PCIe card
      USB: ftdi_sio: add NovaTech OrionLXm product ID
      USB: io_ti: fix firmware download on big-endian machines (part 2)
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

commit da579dd6a180693368ade74b3ac38701d35f686e
Merge: fad01e8 9326c5c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 2 16:55:18 2014 -0700

    Merge tag 'staging-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
    
    Pull staging driver fixes from Greg KH:
     "Here are some staging driver fixes for 3.15.
    
      Three are for the speakup drivers (one fixes a regression caused in
      3.15-rc, and the other two resolve a tty issue found by Ben Hutchings)
      The comedi and r8192e_pci driver fixes also resolve reported issues"
    
    * tag 'staging-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging:
      staging: r8192e_pci: fix htons error
      Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt
      Staging: speakup: Move pasting into a work item
      staging: comedi: ni_daq_700: add mux settling delay
      speakup: fix incorrect perms on speakup_acntsa.c

commit 0cfa5c07d6d1d7f8e710fc671c5ba1ce85e09fa4
Author: Yuchung Cheng <ycheng@google.com>
Date:   Fri May 30 15:25:59 2014 -0700

    tcp: fix cwnd undo on DSACK in F-RTO
    
    This bug is discovered by an recent F-RTO issue on tcpm list
    https://www.ietf.org/mail-archive/web/tcpm/current/msg08794.html
    
    The bug is that currently F-RTO does not use DSACK to undo cwnd in
    certain cases: upon receiving an ACK after the RTO retransmission in
    F-RTO, and the ACK has DSACK indicating the retransmission is spurious,
    the sender only calls tcp_try_undo_loss() if some never retransmisted
    data is sacked (FLAG_ORIG_DATA_SACKED).
    
    The correct behavior is to unconditionally call tcp_try_undo_loss so
    the DSACK information is used properly to undo the cwnd reduction.
    
    Signed-off-by: Yuchung Cheng <ycheng@google.com>
    Signed-off-by: Neal Cardwell <ncardwell@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2d7a85f4b06e9c27ff629f07a524c48074f07f81
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri May 30 11:04:00 2014 -0700

    netlink: Only check file credentials for implicit destinations
    
    It was possible to get a setuid root or setcap executable to write to
    it's stdout or stderr (which has been set made a netlink socket) and
    inadvertently reconfigure the networking stack.
    
    To prevent this we check that both the creator of the socket and
    the currentl applications has permission to reconfigure the network
    stack.
    
    Unfortunately this breaks Zebra which always uses sendto/sendmsg
    and creates it's socket without any privileges.
    
    To keep Zebra working don't bother checking if the creator of the
    socket has privilege when a destination address is specified.  Instead
    rely exclusively on the privileges of the sender of the socket.
    
    Note from Andy: This is exactly Eric's code except for some comment
    clarifications and formatting fixes.  Neither I nor, I think, anyone
    else is thrilled with this approach, but I'm hesitant to wait on a
    better fix since 3.15 is almost here.
    
    Note to stable maintainers: This is a mess.  An earlier series of
    patches in 3.15 fix a rather serious security issue (CVE-2014-0181),
    but they did so in a way that breaks Zebra.  The offending series
    includes:
    
        commit aa4cf9452f469f16cea8c96283b641b4576d4a7b
        Author: Eric W. Biederman <ebiederm@xmission.com>
        Date:   Wed Apr 23 14:28:03 2014 -0700
    
            net: Add variants of capable for use on netlink messages
    
    If a given kernel version is missing that series of fixes, it's
    probably worth backporting it and this patch.  if that series is
    present, then this fix is critical if you care about Zebra.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 22fd2a52f715550930938fc79140defc098287d6
Author: Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri May 30 12:17:00 2014 +0200

    ipheth: Add support for iPad 2 and iPad 3
    
    Each iPad model has a different product id, this patch adds support for iPad 2
    (pid 0x12a2) and iPad 3 (pid 0x12a6). Note that iPad 2 must be jailbroken and a
    third-party app must be used for tethering to work. On iPad 3, tethering works
    out of the box (assuming your ISP is nice).
    
    Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 9d0d68faea6962d62dd501cd6e71ce5cc8ed262b
Author: Jiri Pirko <jiri@resnulli.us>
Date:   Thu May 29 20:46:17 2014 +0200

    team: fix mtu setting
    
    Now it is not possible to set mtu to team device which has a port
    enslaved to it. The reason is that when team_change_mtu() calls
    dev_set_mtu() for port device, notificator for NETDEV_PRECHANGEMTU
    event is called and team_device_event() returns NOTIFY_BAD forbidding
    the change. So fix this by returning NOTIFY_DONE here in case team is
    changing mtu in team_change_mtu().
    
    Introduced-by: 3d249d4c "net: introduce ethernet teaming device"
    Signed-off-by: Jiri Pirko <jiri@resnulli.us>
    Acked-by: Flavio Leitner <fbl@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 39c36094d78c39e038c1e499b2364e13bce36f54
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu May 29 08:45:14 2014 -0700

    net: fix inet_getid() and ipv6_select_ident() bugs
    
    I noticed we were sending wrong IPv4 ID in TCP flows when MTU discovery
    is disabled.
    Note how GSO/TSO packets do not have monotonically incrementing ID.
    
    06:37:41.575531 IP (id 14227, proto: TCP (6), length: 4396)
    06:37:41.575534 IP (id 14272, proto: TCP (6), length: 65212)
    06:37:41.575544 IP (id 14312, proto: TCP (6), length: 57972)
    06:37:41.575678 IP (id 14317, proto: TCP (6), length: 7292)
    06:37:41.575683 IP (id 14361, proto: TCP (6), length: 63764)
    
    It appears I introduced this bug in linux-3.1.
    
    inet_getid() must return the old value of peer->ip_id_count,
    not the new one.
    
    Lets revert this part, and remove the prevention of
    a null identification field in IPv6 Fragment Extension Header,
    which is dubious and not even done properly.
    
    Fixes: 87c48fa3b463 ("ipv6: make fragment identifications less predictable")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit fc0d6e9cd0aefbe5de5ebafb1805f2c59539725b
Author: Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu May 29 13:51:36 2014 +0200

    net: qmi_wwan: interface #11 in Sierra Wireless MC73xx is not QMI
    
    This interface is unusable, as the cdc-wdm character device doesn't reply to
    any QMI command. Also, the out-of-tree Sierra Wireless GobiNet driver fully
    skips it.
    
    Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
    Acked-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 9a793e71ebd6fc4a2649f33811589a9c4fe7f4e8
Author: Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu May 29 13:44:45 2014 +0200

    net: qmi_wwan: add additional Sierra Wireless QMI devices
    
    A set of new VID/PIDs retrieved from the out-of-tree GobiNet/GobiSerial
    Sierra Wireless drivers.
    
    Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
    Acked-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit e0d7968ab6c8bce2437b36fa7f04117e333f196d
Author: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Date:   Mon May 26 15:15:53 2014 +0900

    bridge: Prevent insertion of FDB entry with disallowed vlan
    
    br_handle_local_finish() is allowing us to insert an FDB entry with
    disallowed vlan. For example, when port 1 and 2 are communicating in
    vlan 10, and even if vlan 10 is disallowed on port 3, port 3 can
    interfere with their communication by spoofed src mac address with
    vlan id 10.
    
    Note: Even if it is judged that a frame should not be learned, it should
    not be dropped because it is destined for not forwarding layer but higher
    layer. See IEEE 802.1Q-2011 8.13.10.
    
    Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    Acked-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit bfc5184b69cf9eeb286137640351c650c27f118a
Author: Michal Schmidt <mschmidt@redhat.com>
Date:   Mon Jun 2 18:25:02 2014 +0200

    netlink: rate-limit leftover bytes warning and print process name
    
    Any process is able to send netlink messages with leftover bytes.
    Make the warning rate-limited to prevent too much log spam.
    
    The warning is supposed to help find userspace bugs, so print the
    triggering command name to implicate the buggy program.
    
    [v2: Use pr_warn_ratelimited instead of printk_ratelimited.]
    
    Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 192a98e280e560510a62aca8cfa83b4ae7c095bb
Author: Takashi Iwai <tiwai@suse.de>
Date:   Mon Jun 2 15:16:07 2014 +0200

    ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
    
    The conversion to a fixup table for Replacer model with ALC260 in
    commit 20f7d928 took the wrong widget NID for COEF setups.  Namely,
    NID 0x1a should have been used instead of NID 0x20, which is the
    common node for all Realtek codecs but ALC260.
    
    Fixes: 20f7d928fa6e ('ALSA: hda/realtek - Replace ALC260 model=replacer with the auto-parser')
    Cc: <stable@vger.kernel.org> [v3.4+]
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit e30cf2d2bed3aed74a651c64de323ba26e4ff7d0
Author: Ronan Marquet <ronan.marquet@orange.fr>
Date:   Sun Jun 1 18:38:53 2014 +0200

    ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
    
    Correcion of wrong fixup entries add in commit ca8f0424 to replace
    static model quirk for PB V7900 laptop (will model).
    
    [note: the removal of ALC260_FIXUP_HP_PIN_0F chain is also needed as a
     part of the fix; otherwise the pin is set up wrongly as a headphone,
     and user-space (PulseAudio) may be wrongly trying to detect the jack
     state -- tiwai]
    
    Fixes: ca8f04247eaa ('ALSA: hda/realtek - Add the fixup codes for ALC260 model=will')
    Signed-off-by: Ronan Marquet <ronan.marquet@orange.fr>
    Cc: <stable@vger.kernel.org> [v3.4+]
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit a3530e8fe980f756b823d451fe9243f26db95fa5
Author: Dave Young <dyoung@redhat.com>
Date:   Fri May 30 11:20:10 2014 +0800

    x86/efi: Do not export efi runtime map in case old map
    
    For ioremapped efi memory aka old_map the virt addresses are not persistant
    across kexec reboot. kexec-tools will read the runtime maps from sysfs then
    pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
    kexec boot failure.
    
    To address this issue do not export runtime maps in case efi old_map so
    userspace can use no efi boot instead.
    
    Signed-off-by: Dave Young <dyoung@redhat.com>
    Acked-by: Borislav Petkov <bp@suse.de>
    Acked-by: Vivek Goyal <vgoyal@redhat.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

commit bf8102228a8bf053051f311e5486042fe0542894
Author: Doug Smythies <dsmythies@telus.net>
Date:   Fri May 30 10:10:57 2014 -0700

    intel_pstate: Improve initial busy calculation
    
    This change makes the busy calculation using 64 bit math which prevents
    overflow for large values of aperf/mperf.
    
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Doug Smythies <dsmythies@telus.net>
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c4ee841f602e5eef8eab673295c49c5b49d7732b
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Thu May 29 09:32:24 2014 -0700

    intel_pstate: add sample time scaling
    
    The PID assumes that samples are of equal time, which for a deferable
    timers this is not true when the system goes idle.  This causes the
    PID to take a long time to converge to the min P state and depending
    on the pattern of the idle load can make the P state appear stuck.
    
    The hold-off value of three sample times before using the scaling is
    to give a grace period for applications that have high performance
    requirements and spend a lot of time idle,  The poster child for this
    behavior is the ffmpeg benchmark in the Phoronix test suite.
    
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f0fe3cd7e12d8290c82284b5c8aee723cbd0371a
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Thu May 29 09:32:23 2014 -0700

    intel_pstate: Correct rounding in busy calculation
    
    Changing to fixed point math throughout the busy calculation in
    commit e66c1768 (Change busy calculation to use fixed point
    math.) Introduced some inaccuracies by rounding the busy value at two
    points in the calculation.  This change removes roundings and moves
    the rounding to the output of the PID where the calculations are
    complete and the value returned as an integer.
    
    Fixes: e66c17683746 (intel_pstate: Change busy calculation to use fixed point math.)
    Reported-by: Doug Smythies <dsmythies@telus.net>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit adacdf3f2b8e65aa441613cf61c4f598e9042690
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Thu May 29 09:32:22 2014 -0700

    intel_pstate: Remove C0 tracking
    
    Commit fcb6a15c (intel_pstate: Take core C0 time into account for core
    busy calculation) introduced a regression referenced below.  The issue
    with "lockup" after suspend that this commit was addressing is now dealt
    with in the suspend path.
    
    Fixes: fcb6a15c2e7e (intel_pstate: Take core C0 time into account for core busy calculation)
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=66581
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=75121
    Reported-by: Doug Smythies <dsmythies@telus.net>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 91b0275c0ecd1870c5f8bfb73e2da2d6c29414b3
Author: Christian König <christian.koenig@amd.com>
Date:   Fri May 30 17:52:27 2014 +0200

    drm/radeon: use the CP DMA on CIK
    
    The SDMA sometimes doesn't seem to work reliable.
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Cc: stable@vger.kernel.org

commit 37903b5e08ec9a481a811287b4db3dfe61f6e31f
Author: Christian König <christian.koenig@amd.com>
Date:   Fri May 30 15:21:16 2014 +0200

    drm/radeon: sync page table updates
    
    Only necessary if we don't use the same engine for buffer moves and table updates.
    
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 2f93dc32b09a2c97f6f33bafe4c6bdcec7cae774
Author: Christian König <christian.koenig@amd.com>
Date:   Sat May 31 20:38:34 2014 +0200

    drm/radeon: fix vm buffer size estimation
    
    Only relevant if we got VM_BLOCK_SIZE>9, but better save than sorry.
    
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit c65c7a306610ee7c13669a8f5601b472c19dc6f1
Author: Jon Maxwell <jmaxwell37@gmail.com>
Date:   Thu May 29 17:27:16 2014 +1000

    bridge: notify user space after fdb update
    
    There has been a number incidents recently where customers running KVM have
    reported that VM hosts on different Hypervisors are unreachable. Based on
    pcap traces we found that the bridge was broadcasting the ARP request out
    onto the network. However some NICs have an inbuilt switch which on occasions
    were broadcasting the VMs ARP request back through the physical NIC on the
    Hypervisor. This resulted in the bridge changing ports and incorrectly learning
    that the VMs mac address was external. As a result the ARP reply was directed
    back onto the external network and VM never updated it's ARP cache. This patch
    will notify the bridge command, after a fdb has been updated to identify such
    port toggling.
    
    Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
    Reviewed-by: Jiri Pirko <jiri@resnulli.us>
    Acked-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    Acked-by: Stephen Hemminger <stephen@networkplumber.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ba6f582606655754d9dfbfc9dffe75dcf806f1dd
Author: Sergei Antonov <saproj@gmail.com>
Date:   Mon May 12 00:30:48 2014 +0200

    drm/crtc-helper: skip locking checks in panicking path
    
    Skip locking checks in drm_helper_*_in_use() if they are called in panicking
    path. See similar code in drm_warn_on_modeset_not_all_locked().
    
    After panic information has been output, these WARN_ONs go off outputing a lot
    of lines and scrolling the panic information out of the screen. Here is a
    partial call trace showing how execution reaches them:
    
    ? drm_helper_crtc_in_use()
    ? __drm_helper_disable_unused_functions()
    ? several *_set_config functions
    ? drm_fb_helper_restore_fbdev_mode()
    
    Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Sergei Antonov <saproj@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3640da2faa952a2e9439a254c1ce76033ca0a6dc
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri May 30 12:40:15 2014 -0400

    drm/radeon/dpm: resume fixes for some systems
    
    Setting the power state prior to restoring the display
    hardware leads to blank screens on some systems.  Drop
    the power state set from dpm resume.  The power state
    will get set as part of the mode set sequence.  Also
    add an explicit power state set after mode set resume
    to cover PX and headless systems.
    
    bug:
    https://bugzilla.kernel.org/show_bug.cgi?id=76761
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4324be1e0bab67194a263be263b7e48c176d43c7
Author: Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed May 28 21:05:03 2014 +0200

    net: qmi_wwan: add Netgear AirCard 341U
    
    Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
    Acked-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 4b9b1cdf83c4facba89e0646aeac8ead679851b8
Author: Nikolay Aleksandrov <nikolay@redhat.com>
Date:   Wed May 28 18:03:48 2014 +0200

    net: fix wrong mac_len calculation for vlans
    
    After 1e785f48d29a ("net: Start with correct mac_len in
    skb_network_protocol") skb->mac_len is used as a start of the
    calculation in skb_network_protocol() but that is not always correct. If
    skb->protocol == 8021Q/AD, usually the vlan header is already inserted
    in the skb (i.e. vlan reorder hdr == 0). Usually when the packet enters
    dev_hard_xmit it has mac_len == 0 so we take 2 bytes from the
    destination mac address (skb->data + VLAN_HLEN) as a type in
    skb_network_protocol() and return vlan_depth == 4. In the case where TSO is
    off, then the mac_len is set but it's == 18 (ETH_HLEN + VLAN_HLEN), so
    skb_network_protocol() returns a type from inside the packet and
    offset == 22. Also make vlan_depth unsigned as suggested before.
    As suggested by Eric Dumazet, move the while() loop in the if() so we
    can avoid additional testing in fast path.
    
    Here are few netperf tests + debug printk's to illustrate:
    cat netperf.tso-on.reorder-on.bugged
    - Vlan -> device (reorder on, default, this case is okay)
    MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
    192.168.3.1 () port 0 AF_INET
    Recv   Send    Send
    Socket Socket  Message  Elapsed
    Size   Size    Size     Time     Throughput
    bytes  bytes   bytes    secs.    10^6bits/sec
    
     87380  16384  16384    10.00    7111.54
    [   81.605435] skb->len 65226 skb->gso_size 1448 skb->proto 0x800
    skb->mac_len 0 vlan_depth 0 type 0x800
    
    - Vlan -> device (reorder off, bad)
    cat netperf.tso-on.reorder-off.bugged
    MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
    192.168.3.1 () port 0 AF_INET
    Recv   Send    Send
    Socket Socket  Message  Elapsed
    Size   Size    Size     Time     Throughput
    bytes  bytes   bytes    secs.    10^6bits/sec
    
     87380  16384  16384    10.00     241.35
    [  204.578332] skb->len 1518 skb->gso_size 0 skb->proto 0x8100
    skb->mac_len 0 vlan_depth 4 type 0x5301
    0x5301 are the last two bytes of the destination mac.
    
    And if we stop TSO, we may get even the following:
    [   83.343156] skb->len 2966 skb->gso_size 1448 skb->proto 0x8100
    skb->mac_len 18 vlan_depth 22 type 0xb84
    Because mac_len already accounts for VLAN_HLEN.
    
    After the fix:
    cat netperf.tso-on.reorder-off.fixed
    MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
    192.168.3.1 () port 0 AF_INET
    Recv   Send    Send
    Socket Socket  Message  Elapsed
    Size   Size    Size     Time     Throughput
    bytes  bytes   bytes    secs.    10^6bits/sec
    
     87380  16384  16384    10.01    5001.46
    [   81.888489] skb->len 65230 skb->gso_size 1448 skb->proto 0x8100
    skb->mac_len 0 vlan_depth 18 type 0x800
    
    CC: Vlad Yasevich <vyasevic@redhat.com>
    CC: Eric Dumazet <eric.dumazet@gmail.com>
    CC: Daniel Borkman <dborkman@redhat.com>
    CC: David S. Miller <davem@davemloft.net>
    
    Fixes:1e785f48d29a ("net: Start with correct mac_len in
    skb_network_protocol")
    Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 1 19:12:24 2014 -0700

    Linux 3.15-rc8

commit 204fe0380b14557a3179cf18f1101d4ed6532172
Merge: 568180a 8212f58
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 1 18:30:07 2014 -0700

    Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
    
    Pull powerpc fix from Ben Herrenschmidt:
     "Here's just one trivial patch to wire up sys_renameat2 which I seem to
      have completely missed so far.
    
      (My test build scripts fwd me warnings but miss the ones generated for
      missing syscalls)"
    
    * 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc:
      powerpc: Wire renameat2() syscall

commit 568180a517aee88a8afdc9938f6884e047a2613f
Merge: 3243970 f3f0d95
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 1 18:28:58 2014 -0700

    Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
    
    Pull MIPS fixes from Ralf Baechle:
     "A fair number of fixes across the field.  Nothing terribly
      complicated; the one liners in below changelog should be fairly
      descriptive.
    
      Noteworthy is the SB1 change which the result of changes to binutils
      resulting in one big gas warning for most files being assembled as
      well as the asid_cache and branch emulation fixes which fix corruption
      or possible uninteded behaviour of kernel or application code.  The
      remainder of fixes are more platforms or subsystem specific"
    
    * 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus:
      MIPS: R46000: Fix Micro-assembler field overflow for R4600 V2
      MIPS: ptrace: Avoid smp_processor_id() in preemptible code
      MIPS: Lemote 2F: cs5536: mfgpt: use raw locks
      MIPS: SB1: Fix excessive kernel warnings.
      MIPS: RC32434: fix broken PCI resource initialization
      MIPS: malta: memory.c: Initialize the 'memsize' variable
      MIPS: Fix typo when reporting cache and ftlb errors for ImgTec cores
      MIPS: Fix inconsistancy of __NR_Linux_syscalls value
      MIPS: Fix branch emulation of branch likely instructions.
      MIPS: Fix a typo error in AUDIT_ARCH definition
      MIPS: Change type of asid_cache to unsigned long

commit 32439700fe1c0fc3c2d3f2aedd3ad6707c88b8ba
Merge: a4bf79e 6acbfb9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 1 18:26:59 2014 -0700

    Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull scheduler fixes from Ingo Molnar:
     "Various fixlets, mostly related to the (root-only) SCHED_DEADLINE
      policy, but also a hotplug bug fix and a fix for a NR_CPUS related
      overallocation bug causing a suspend/resume regression"
    
    * 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      sched: Fix hotplug vs. set_cpus_allowed_ptr()
      sched/cpupri: Replace NR_CPUS arrays
      sched/deadline: Replace NR_CPUS arrays
      sched/deadline: Restrict user params max value to 2^63 ns
      sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE
      sched: Disallow sched_attr::sched_policy < 0
      sched: Make sched_setattr() correctly return -EFBIG

commit 8212f58a9b151d842fa60a70f354e43c61fad839
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Mon Jun 2 09:24:27 2014 +1000

    powerpc: Wire renameat2() syscall
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 6ce995c6f466e59a5f16e6eae8b265c1d13bb202
Merge: dbfc4b6 af0a171
Author: David S. Miller <davem@davemloft.net>
Date:   Sat May 31 20:01:47 2014 -0700

    Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
    
    Included changes:
    - prevent NULL dereference in multicast code
    
    Antonion Quartulli says:
    
    ====================
    pull request net: batman-adv 20140527
    
    here you have another very small fix intended for net/linux-3.15.
    It prevents some multicast functions from dereferencing a NULL pointer.
    (Actually it was nothing more than a typo)
    I hope it is not too late for such a small patch.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a4bf79eb6a42e863e0fccf19f9383c618e8efc43
Merge: 80e0679 397335f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat May 31 09:47:55 2014 -0700

    Merge branch 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull core futex/rtmutex fixes from Thomas Gleixner:
     "Three fixlets for long standing issues in the futex/rtmutex code
      unearthed by Dave Jones syscall fuzzer:
    
       - Add missing early deadlock detection checks in the futex code
       - Prevent user space from attaching a futex to kernel threads
       - Make the deadlock detector of rtmutex work again
    
      Looks large, but is more comments than code change"
    
    * 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      rtmutex: Fix deadlock detector for real
      futex: Prevent attaching to kernel threads
      futex: Add another early deadlock detection check

commit 80e0679469a481ab8baa4fe982205f99004a0686
Merge: 9f12600 18ee37a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat May 31 09:19:02 2014 -0700

    Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
    
    Pull drm fixes from Dave Airlie:
     "Mostly quiet now:
    
      i915:
        fixing userspace visiblie issues, all stable marked
    
      radeon:
        one more pll fix, two crashers, one suspend/resume regression"
    
    * 'drm-fixes' of git://people.freedesktop.org/~airlied/linux:
      drm/radeon: Resume fbcon last
      drm/radeon: only allocate necessary size for vm bo list
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: lower the ref * post PLL maximum once more
      drm/i915: Prevent negative relocation deltas from wrapping
      drm/i915: Only copy back the modified fields to userspace from execbuffer
      drm/i915: Fix dynamic allocation of physical handles

commit 9f12600fe425bc28f0ccba034a77783c09c15af4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat May 31 09:13:21 2014 -0700

    dcache: add missing lockdep annotation
    
    lock_parent() very much on purpose does nested locking of dentries, and
    is careful to maintain the right order (lock parent first).  But because
    it didn't annotate the nested locking order, lockdep thought it might be
    a deadlock on d_lock, and complained.
    
    Add the proper annotation for the inner locking of the child dentry to
    make lockdep happy.
    
    Introduced by commit 046b961b45f9 ("shrink_dentry_list(): take parent's
    ->d_lock earlier").
    
    Reported-and-tested-by: Josh Boyer <jwboyer@fedoraproject.org>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit af0a171c07174661db71f92e442d4e6e90984b77
Author: Marek Lindner <mareklindner@neomailbox.ch>
Date:   Thu Apr 24 03:41:26 2014 +0800

    batman-adv: fix NULL pointer dereferences
    
    Was introduced with 4c8755d69cbde2ec464a39c932aed0a83f9ff89f
    ("batman-adv: Send multicast packets to nodes with a WANT_ALL flag")
    
    Reported-by: Sven Eckelmann <sven@narfation.org>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Acked-by: Antonio Quartulli <antonio@meshcoding.com>
    Signed-off-by: Linus Lüssing <linus.luessing@web.de>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit dbfc4b698ab83494eb8a03f5f3c478cec29a4f62
Merge: 554215c f44a5f4
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 30 17:56:09 2014 -0700

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
    
    Pablo Neira Ayuso says:
    
    ====================
    The following patchset contains a late fix for IPVS:
    
    * Fix crash when trying to remove the transport header with non-linear
      skbuffs, this was introduced in 3.6-rc. Patch from Peter Christensen
      via the IPVS folks.
    
    I'll pass this to -stable once this hits mainstream.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 554215c5ca08d196ed48a66693e7fc6e5f81f00e
Merge: 111c609 45fb4f8
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 30 17:32:53 2014 -0700

    Merge tag 'linux-can-fixes-for-3.15-20140528' of git://gitorious.org/linux-can/linux-can
    
    Marc Kleine-Budde says:
    
    ====================
    pull-request: can 2014-05-28
    
    here's a pull request for v3.15, hope it's not too late.
    
    Oliver Hartkopp fixed a bug in the CAN led trigger device renaming code.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 111c6094bd7731cb1a415b2ea7d450fa23d6857c
Author: Jack Morgenstein <jackm@dev.mellanox.co.il>
Date:   Tue May 27 09:26:38 2014 +0300

    net/mlx4_core: Reset RoCE VF gids when guest driver goes down
    
    Reset the GIDs assigned to a VF in the port RoCE GID table when
    that guest goes down (either crashes or goes down cleanly).
    
    As part of this fix, we refactor the RoCE gid table driver copy,
    moving it to the mlx4_port_info structure (together with the MAC
    and VLAN tables).
    
    As with the MAC and VLAN tables, we now use a mutex per port
    for the GID table so that modifying the driver copy and
    modifying the firmware copy of a port GID table becomes an
    atomic operation (thus avoiding driver-copy/FW-copy mismatches).
    
    Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
    Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 09271db6e0f2b282f9bfe0ab6e8b644a93237c5e
Author: Ivan Mikhaylov <ivan@ru.ibm.com>
Date:   Mon May 26 22:34:39 2014 +0400

    emac: aggregation of v1-2 PLB errors for IER register
    
    Aggreagation of version 1-2 because of version 1 can hit
    PLB errors too. If it's not set so we missing events for PLB bits
    and driver can't process those interrupts.
    
    Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit faacd3af0cf4a3ef5565da86038812a25f6fe9eb
Author: Ivan Mikhaylov <ivan@ru.ibm.com>
Date:   Mon May 26 22:24:17 2014 +0400

    emac: add missing support of 10mbit in emac/rgmii
    
    In chips of emac/rgmii b'000' for 0/1 channel isn't suitable which
    resulted in non working network interface in this mode.
    
    Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 18ee37a485653aa635cfab9a3710e9bcf5fbca01
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri May 30 16:41:23 2014 +0200

    drm/radeon: Resume fbcon last
    
    So a few people complained that
    
    commit 177cf92de4aa97ec1435987e91696ed8b5023130
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Tue Apr 1 22:14:59 2014 +0200
    
        drm/crtc-helpers: fix dpms on logic
    
    which was merged into 3.15-rc1, broke resume on radeons. Strangely git
    bisect lead everyone to
    
    commit 25f397a429dfa43f22c278d0119a60a343aa568f
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Fri Jul 19 18:57:11 2013 +0200
    
        drm/crtc-helper: explicit DPMS on after modeset
    
    which was merged long ago and actually part of 3.14.
    
    Digging deeper I've noticed (again) that the call to
    drm_helper_resume_force_mode in the radeon resume handlers was a no-op
    previously because everything gets shut down on suspend. radeon does
    this with explicit calls to drm_helper_connector_dpms with DPMS_OFF.
    But with 177c we now force the dpms state to ON, so suddenly
    resume_force_mode actually forced the crtcs back on.
    
    This is the intention of the change after all, the problem is that
    radeon resumes the fbdev console layer _before_ restoring the display,
    through calling fb_set_suspend. And fbcon does an immediate ->set_par,
    which in turn causes the same forced mode restore to happen.
    
    Two concurrent modeset operations didn't lead to happiness. Fix this
    by delaying the fbcon resume until the end of the readeon resum
    functions.
    
    v2: Fix up a bit of the spelling fail.
    
    References: https://lkml.org/lkml/2014/5/29/1043
    References: https://lkml.org/lkml/2014/5/2/388
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=74751
    Tested-by: Ken Moffat <zarniwhoop@ntlworld.com>
    Cc: Alex Deucher <alexdeucher@gmail.com>
    Cc: Ken Moffat <zarniwhoop@ntlworld.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Dave Airlie <airlied@gmail.com>

commit 1446e04c9b9b7d27437a5fefee37d9984afcd560
Merge: efb27e7 7d95f6c
Author: Dave Airlie <airlied@gmail.com>
Date:   Sat May 31 09:19:05 2014 +1000

    Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes
    
    this is the next pull request for stashed up radeon fixes for 3.15. This is finally calming down with only four patches in this pull request.
    
    * 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux:
      drm/radeon: only allocate necessary size for vm bo list
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: lower the ref * post PLL maximum once more

commit 1487385edb55a68a629cf3a30fc04958ad798df1
Merge: 1326af2 0f68f39
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 30 12:07:48 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
    
    Pull input subsystem fixes from Dmitry Torokhov:
     "A couple of driver/build fixups and also redone quirk for Synaptics
      touchpads on Lenovo boxes (now using PNP IDs instead of DMI data to
      limit number of quirks)"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input:
      Input: synaptics - change min/max quirk table to pnp-id matching
      Input: synaptics - add a matches_pnp_id helper function
      Input: synaptics - T540p - unify with other LEN0034 models
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: ambakmi - request a shared interrupt for AMBA KMI devices
      Input: pxa27x-keypad - fix generating scancode
      Input: atmel-wm97xx - only build for AVR32
      Input: fix ps2/serio module dependency

commit 1326af2464fc29290d1710447297d33a90a6ece4
Merge: 24e19d2 2fe2023
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 30 12:06:15 2014 -0700

    Merge tag 'firewire-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394
    
    Pull firewire fix from Stefan Richter:
     "A regression fix for the IEEE 1394 subsystem: re-enable IRQ-based
      asynchronous request reception at addresses below 128 TB"
    
    * tag 'firewire-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394:
      firewire: revert to 4 GB RDMA, fix protocols using Memory Space

commit 24e19d279f9e289e965b4bc4710fbccab824c4c4
Merge: 6538b8e 63d832c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 30 12:04:56 2014 -0700

    Merge tag 'dm-3.15-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
    
    Pull device-mapper fixes from Mike Snitzer:
     "A dm-cache stable fix to split discards on cache block boundaries
      because dm-cache cannot yet handle discards that span cache blocks.
    
      Really fix a dm-mpath LOCKDEP warning that was introduced in -rc1.
    
      Add a 'no_space_timeout' control to dm-thinp to restore the ability to
      queue IO indefinitely when no data space is available.  This fixes a
      change in behavior that was introduced in -rc6 where the timeout
      couldn't be disabled"
    
    * tag 'dm-3.15-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm:
      dm mpath: really fix lockdep warning
      dm cache: always split discards on cache block boundaries
      dm thin: add 'no_space_timeout' dm-thin-pool module param

commit 6538b8ea886e472f4431db8ca1d60478f838d14b
Author: Minchan Kim <minchan@kernel.org>
Date:   Wed May 28 15:53:59 2014 +0900

    x86_64: expand kernel stack to 16K
    
    While I play inhouse patches with much memory pressure on qemu-kvm,
    3.14 kernel was randomly crashed. The reason was kernel stack overflow.
    
    When I investigated the problem, the callstack was a little bit deeper
    by involve with reclaim functions but not direct reclaim path.
    
    I tried to diet stack size of some functions related with alloc/reclaim
    so did a hundred of byte but overflow was't disappeard so that I encounter
    overflow by another deeper callstack on reclaim/allocator path.
    
    Of course, we might sweep every sites we have found for reducing
    stack usage but I'm not sure how long it saves the world(surely,
    lots of developer start to add nice features which will use stack
    agains) and if we consider another more complex feature in I/O layer
    and/or reclaim path, it might be better to increase stack size(
    meanwhile, stack usage on 64bit machine was doubled compared to 32bit
    while it have sticked to 8K. Hmm, it's not a fair to me and arm64
    already expaned to 16K. )
    
    So, my stupid idea is just let's expand stack size and keep an eye
    toward stack consumption on each kernel functions via stacktrace of ftrace.
    For example, we can have a bar like that each funcion shouldn't exceed 200K
    and emit the warning when some function consumes more in runtime.
    Of course, it could make false positive but at least, it could make a
    chance to think over it.
    
    I guess this topic was discussed several time so there might be
    strong reason not to increase kernel stack size on x86_64, for me not
    knowing so Ccing x86_64 maintainers, other MM guys and virtio
    maintainers.
    
    Here's an example call trace using up the kernel stack:
    
             Depth    Size   Location    (51 entries)
             -----    ----   --------
       0)     7696      16   lookup_address
       1)     7680      16   _lookup_address_cpa.isra.3
       2)     7664      24   __change_page_attr_set_clr
       3)     7640     392   kernel_map_pages
       4)     7248     256   get_page_from_freelist
       5)     6992     352   __alloc_pages_nodemask
       6)     6640       8   alloc_pages_current
       7)     6632     168   new_slab
       8)     6464       8   __slab_alloc
       9)     6456      80   __kmalloc
      10)     6376     376   vring_add_indirect
      11)     6000     144   virtqueue_add_sgs
      12)     5856     288   __virtblk_add_req
      13)     5568      96   virtio_queue_rq
      14)     5472     128   __blk_mq_run_hw_queue
      15)     5344      16   blk_mq_run_hw_queue
      16)     5328      96   blk_mq_insert_requests
      17)     5232     112   blk_mq_flush_plug_list
      18)     5120     112   blk_flush_plug_list
      19)     5008      64   io_schedule_timeout
      20)     4944     128   mempool_alloc
      21)     4816      96   bio_alloc_bioset
      22)     4720      48   get_swap_bio
      23)     4672     160   __swap_writepage
      24)     4512      32   swap_writepage
      25)     4480     320   shrink_page_list
      26)     4160     208   shrink_inactive_list
      27)     3952     304   shrink_lruvec
      28)     3648      80   shrink_zone
      29)     3568     128   do_try_to_free_pages
      30)     3440     208   try_to_free_pages
      31)     3232     352   __alloc_pages_nodemask
      32)     2880       8   alloc_pages_current
      33)     2872     200   __page_cache_alloc
      34)     2672      80   find_or_create_page
      35)     2592      80   ext4_mb_load_buddy
      36)     2512     176   ext4_mb_regular_allocator
      37)     2336     128   ext4_mb_new_blocks
      38)     2208     256   ext4_ext_map_blocks
      39)     1952     160   ext4_map_blocks
      40)     1792     384   ext4_writepages
      41)     1408      16   do_writepages
      42)     1392      96   __writeback_single_inode
      43)     1296     176   writeback_sb_inodes
      44)     1120      80   __writeback_inodes_wb
      45)     1040     160   wb_writeback
      46)      880     208   bdi_writeback_workfn
      47)      672     144   process_one_work
      48)      528     112   worker_thread
      49)      416     240   kthread
      50)      176     176   ret_from_fork
    
    [ Note: the problem is exacerbated by certain gcc versions that seem to
      generate much bigger stack frames due to apparently bad coalescing of
      temporaries and generating too many spills.  Rusty saw gcc-4.6.4 using
      35% more stack on the virtio path than 4.8.2 does, for example.
    
      Minchan not only uses such a bad gcc version (4.6.3 in his case), but
      some of the stack use is due to debugging (CONFIG_DEBUG_PAGEALLOC is
      what causes that kernel_map_pages() frame, for example). But we're
      clearly getting too close.
    
      The VM code also seems to have excessive stack frames partly for the
      same compiler reason, triggered by excessive inlining and lots of
      function arguments.
    
      We need to improve on our stack use, but in the meantime let's do this
      simple stack increase too.  Unlike most earlier reports, there is
      nothing simple that stands out as being really horribly wrong here,
      apart from the fact that the stack frames are just bigger than they
      should need to be.        - Linus ]
    
    Signed-off-by: Minchan Kim <minchan@kernel.org>
    Cc: Peter Anvin <hpa@zytor.com>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Michael S Tsirkin <mst@redhat.com>
    Cc: Dave Hansen <dave.hansen@intel.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: PJ Waskiewicz <pjwaskiewicz@gmail.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 6f6111e4a73d0f6370eb8be4f8e4523210b6a67d
Merge: fe45736 8cbf74d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 30 09:52:55 2014 -0700

    Merge branch 'for-linus-2' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs dcache livelock fix from Al Viro:
     "Fixes for livelocks in shrink_dentry_list() introduced by fixes to
      shrink list corruption; the root cause was that trylock of parent's
      ->d_lock could be disrupted by d_walk() happening on other CPUs,
      resulting in shrink_dentry_list() making no progress *and* the same
      d_walk() being called again and again for as long as
      shrink_dentry_list() doesn't get past that mess.
    
      The solution is to have shrink_dentry_list() treat that trylock
      failure not as 'try to do the same thing again', but 'lock them in the
      right order'"
    
    * 'for-linus-2' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs:
      dentry_kill() doesn't need the second argument now
      dealing with the rest of shrink_dentry_list() livelock
      shrink_dentry_list(): take parent's ->d_lock earlier
      expand dentry_kill(dentry, 0) in shrink_dentry_list()
      split dentry_kill()
      lift the "already marked killed" case into shrink_dentry_list()

commit 8cbf74da435d1bd13dbb790f94c7ff67b2fb6af4
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu May 29 09:18:26 2014 -0400

    dentry_kill() doesn't need the second argument now
    
    it's 1 in the only remaining caller.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b2b80195d8829921506880f6dccd21cabd163d0d
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu May 29 09:11:45 2014 -0400

    dealing with the rest of shrink_dentry_list() livelock
    
    We have the same problem with ->d_lock order in the inner loop, where
    we are dropping references to ancestors.  Same solution, basically -
    instead of using dentry_kill() we use lock_parent() (introduced in the
    previous commit) to get that lock in a safe way, recheck ->d_count
    (in case if lock_parent() has ended up dropping and retaking ->d_lock
    and somebody managed to grab a reference during that window), trylock
    the inode->i_lock and use __dentry_kill() to do the rest.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 046b961b45f93a92e4c70525a12f3d378bced130
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu May 29 08:54:52 2014 -0400

    shrink_dentry_list(): take parent's ->d_lock earlier
    
    The cause of livelocks there is that we are taking ->d_lock on
    dentry and its parent in the wrong order, forcing us to use
    trylock on the parent's one.  d_walk() takes them in the right
    order, and unfortunately it's not hard to create a situation
    when shrink_dentry_list() can't make progress since trylock
    keeps failing, and shrink_dcache_parent() or check_submounts_and_drop()
    keeps calling d_walk() disrupting the very shrink_dentry_list() it's
    waiting for.
    
    Solution is straightforward - if that trylock fails, let's unlock
    the dentry itself and take locks in the right order.  We need to
    stabilize ->d_parent without holding ->d_lock, but that's doable
    using RCU.  And we'd better do that in the very beginning of the
    loop in shrink_dentry_list(), since the checks on refcount, etc.
    would need to be redone anyway.
    
    That deals with a half of the problem - killing dentries on the
    shrink list itself.  Another one (dropping their parents) is
    in the next commit.
    
    locking parent is interesting - it would be easy to do rcu_read_lock(),
    lock whatever we think is a parent, lock dentry itself and check
    if the parent is still the right one.  Except that we need to check
    that *before* locking the dentry, or we are risking taking ->d_lock
    out of order.  Fortunately, once the D1 is locked, we can check if
    D2->d_parent is equal to D1 without the need to lock D2; D2->d_parent
    can start or stop pointing to D1 only under D1->d_lock, so taking
    D1->d_lock is enough.  In other words, the right solution is
    rcu_read_lock/lock what looks like parent right now/check if it's
    still our parent/rcu_read_unlock/lock the child.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 7d95f6cc4ef73572a43d4a0a1907a13ace17a62a
Author: Christian König <christian.koenig@amd.com>
Date:   Wed May 28 12:24:17 2014 +0200

    drm/radeon: only allocate necessary size for vm bo list
    
    No need to always allocate the theoretical maximum here.
    
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit ec65da385d46f63740c1c9230b891a6dcbd64c71
Author: Marek Olšák <marek.olsak@amd.com>
Date:   Tue May 27 02:56:36 2014 +0200

    drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
    
    It hangs the hardware.
    
    Signed-off-by: Marek Olšák <marek.olsak@amd.com>
    Reviewed-by: Christian König <christian.koenig@amd.com>
    Cc: stable@vger.kernel.org

commit 60a445405a1731bac2279eab354173c9c3156747
Author: Christian König <christian.koenig@amd.com>
Date:   Wed May 21 17:43:59 2014 +0200

    drm/radeon: avoid crash if VM command submission isn't available
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    CC: stable@vger.kernel.org

commit 4b21ce1b4b5d262e7d4656b8ececc891fc3cb806
Author: Christian König <christian.koenig@amd.com>
Date:   Wed May 21 15:25:41 2014 +0200

    drm/radeon: lower the ref * post PLL maximum once more
    
    Let's be conservative and use 100 here until we find something better.
    
    Bugs: https://bugzilla.kernel.org/show_bug.cgi?id=75241
    
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 598e306184d26fa1d546334f2eb370b4d94a4ad3
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri May 23 09:21:06 2014 +0200

    ALSA: hda/analog - Fix silent output on ASUS A8JN
    
    ASUS A8JN with AD1986A codec seems following the normal EAPD in the
    normal order (0 = off, 1 = on) unlike other machines with AD1986A.
    Apply the workaround used for Toshiba laptop that showed the same
    problem.
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75041
    Cc: <stable@vger.kernel.org> [3.11+]
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit fe45736f4134b9656c656ac5e15b915192f2704a
Merge: a991639 3f8517e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 29 18:31:09 2014 -0700

    Merge branch 'fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm
    
    Pull ARM fixes from Russell King:
     "The usual random collection of relatively small ARM fixes"
    
    * 'fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm:
      ARM: 8063/1: bL_switcher: fix individual online status reporting of removed CPUs
      ARM: 8064/1: fix v7-M signal return
      ARM: 8057/1: amba: Add Qualcomm vendor ID.
      ARM: 8052/1: unwind: Fix handling of "Pop r4-r[4+nnn],r14" opcode
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      ARM: 8048/1: fix v7-M setup stack location

commit a991639c26c7231ddb6de7f34899fb70832b7d04
Merge: f035b3d ceb2183
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 29 14:14:43 2014 -0700

    Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
    
    Pull arm64 fix from Will Deacon:
     "Fix CoW regression for transparent hugepages by routing set_pmd_at to
      set_pte_at, which correctly handles PTE_WRITE and will mark the
      resulting table entry as read-only where appropriate"
    
    * tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux:
      arm64: mm: fix pmd_write CoW brokenness

commit f035b3d32256b93a4c39622afe6ac7ade8eedbea
Merge: 15a7b60 9b961aa
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 29 14:05:57 2014 -0700

    Merge tag 'pm+acpi-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
    
    Pull ACPI and power management fixes from Rafael Wysocki:
     "These are three stable-candidate fixes, one for the ACPI thermal
      driver and two for cpufreq drivers.
    
      Specifics:
    
       - A workqueue is destroyed too early during the ACPI thermal driver
         module unload which leads to a NULL pointer dereference in the
         driver's remove callback.  Fix from Aaron Lu.
    
       - A wrong argument is passed to devm_regulator_get_optional() in the
         probe routine of the cpu0 cpufreq driver which leads to resource
         leaks if the driver is unbound from the cpufreq platform device.
         Fix from Lucas Stach.
    
       - A lock is missing in cpufreq_governor_dbs() which leads to memory
         corruption and NULL pointer dereferences during system
         suspend/resume, for example.  Fix from Bibek Basu"
    
    * tag 'pm+acpi-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm:
      ACPI / thermal: fix workqueue destroy order
      cpufreq: cpu0: drop wrong devm usage
      cpufreq: remove race while accessing cur_policy

commit 15a7b60ea157d4e7cb498ac88515a558d79d7da2
Merge: f2159d1 5178438
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 29 13:59:18 2014 -0700

    Merge tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mike.turquette/linux
    
    Pull clock fixes from Mike Turquette:
     "Small number of user-visible regression fixes for clock drivers.
    
      There is a memory leak fix for an ST platform, an infinite Loop Of
      Doom fix for the recent changes to the basic clock divider (hopefully
      the last fix for those recent changes) and some Tegra PLL changes
      which keep PCI from being hosed on that platform"
    
    * tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mike.turquette/linux:
      clk: st: Fix memory leak
      clk: divider: Fix table round up function
      clk: tegra: Fix enabling of PLLE
      clk: tegra: Introduce divider mask and shift helpers
      clk: tegra: Fix PLLE programming

commit 2fe2023adf695d08af5b598b2be3b288a95d563c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu May 29 15:23:26 2014 +0200

    firewire: revert to 4 GB RDMA, fix protocols using Memory Space
    
    Undo a feature introduced in v3.14 by commit fcd46b34425d
    "firewire: Enable remote DMA above 4 GB".  That change raised the
    minimum address at which protocol drivers and user programs can register
    for request reception from 0x0001'0000'0000 to 0x8000'0000'0000.
    It turned out that at least one vendor-specific protocol exists which
    uses lower addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=76921
    
    For the time being, revert most of commit fcd46b34425d so that affected
    protocols work like with kernel v3.13 and before.  Just keep the valid
    documentation parts from the regressing commit, and the ability to
    identify controllers which could be programmed to accept >32 bit
    physical DMA addresses.  The rest of fcd46b34425d should probably be
    brought back as an optional instead of default feature.
    
    Reported-by: Fabien Spindler <fabien.spindler@inria.fr>
    Cc: <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit ff2fde9929feb2aef45377ce56b8b12df85dda69
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 28 13:59:13 2014 -0400

    expand dentry_kill(dentry, 0) in shrink_dentry_list()
    
    Result will be massaged to saner shape in the next commits.  It is
    ugly, no questions - the point of that one is to be a provably
    equivalent transformation (and it might be worth splitting a bit
    more).
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e55fd011549eae01a230e3cace6f4d031b6a3453
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 28 13:51:12 2014 -0400

    split dentry_kill()
    
    ... into trylocks and everything else.  The latter (actual killing)
    is __dentry_kill().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit ceb218359de22e70980801d4fa04fffbfc44adb8
Author: Will Deacon <will.deacon@arm.com>
Date:   Tue May 27 19:11:58 2014 +0100

    arm64: mm: fix pmd_write CoW brokenness
    
    Commit 9c7e535fcc17 ("arm64: mm: Route pmd thp functions through pte
    equivalents") changed the pmd manipulator and accessor functions to
    convert the target pmd to a pte, process it with the pte functions, then
    convert it back. Along the way, we gained support for PTE_WRITE, however
    this is completely ignored by set_pmd_at, and so we fail to set the
    PMD_SECT_RDONLY for PMDs, resulting in all sorts of lovely failures (like
    CoW not working).
    
    Partially reverting the offending commit (by making use of
    PMD_SECT_RDONLY explicitly for pmd_{write,wrprotect,mkwrite} functions)
    leads to further issues because pmd_write can then return potentially
    incorrect values for page table entries marked as RDONLY, leading to
    BUG_ON(pmd_write(entry)) tripping under some THP workloads.
    
    This patch fixes the issue by routing set_pmd_at through set_pte_at,
    which correctly takes the PTE_WRITE flag into account. Given that
    THP mappings are always anonymous, the additional cache-flushing code
    in __sync_icache_dcache won't impose any significant overhead as the
    flush will be skipped.
    
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Acked-by: Steve Capper <steve.capper@arm.com>
    Tested-by: Marc Zyngier <marc.zyngier@arm.com>
    Signed-off-by: Will Deacon <will.deacon@arm.com>

commit 2ac295a544dcae9299cba13ce250419117ae7fd1
Author: NeilBrown <neilb@suse.de>
Date:   Thu May 29 11:40:03 2014 +1000

    md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
    
    Commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97
       md: fix problem when adding device to read-only array with bitmap.
    
    added a called to md_reap_sync_thread() which cause a reshape thread
    to be interrupted (in particular, it could cause md_thread() to never even
    call md_do_sync()).
    However it didn't set MD_RECOVERY_INTR so ->finish_reshape() would not
    know that the reshape didn't complete.
    
    This only happens when mddev->ro is set and normally reshape threads
    don't run in that situation.  But raid5 and raid10 can start a reshape
    thread during "run" is the array is in the middle of a reshape.
    They do this even if ->ro is set.
    
    So it is best to set MD_RECOVERY_INTR before abortingg the
    sync thread, just in case.
    
    Though it rare for this to trigger a problem it can cause data corruption
    because the reshape isn't finished properly.
    So it is suitable for any stable which the offending commit was applied to.
    (3.2 or later)
    
    Fixes: 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97
    Cc: stable@vger.kernel.org (3.2+)
    Signed-off-by: NeilBrown <neilb@suse.de>

commit 5dc2808c4729bf080487e61b80ee04e0fdb12a37
Author: Mathias Nyman <mathias.nyman@linux.intel.com>
Date:   Wed May 28 23:51:13 2014 +0300

    xhci: delete endpoints from bandwidth list before freeing whole device
    
    Lists of endpoints are stored for bandwidth calculation for roothub ports.
    Make sure we remove all endpoints from the list before the whole device,
    containing its endpoints list_head stuctures, is freed.
    
    This used to be done in the wrong order in xhci_mem_cleanup(),
    and triggered an oops in resume from S4 (hibernate).
    
    Cc: stable <stable@vger.kernel.org>
    Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9326c5ca0982f548cc08c0cffb14dcbd020f3d43
Author: Sean MacLennan <seanm@seanm.ca>
Date:   Wed May 28 11:19:00 2014 -0400

    staging: r8192e_pci: fix htons error
    
    A sparse error fixup removed a htons() which is required for the driver
    to function. This patch puts the htons() back and fixes the sparse
    warning correctly by changing the left side cast.
    
    Signed-off-by: Sean MacLennan <seanm@seanm.ca>
    Cc: stable <stable@vger.kernel.org> # 3.14
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit b38f09ccc3fd453180e96273bf3f34083c30809a
Author: Mathias Nyman <mathias.nyman@linux.intel.com>
Date:   Wed May 28 23:18:35 2014 +0300

    usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
    
    Sony VAIO t-series machines are not capable of switching usb2 ports over
    from Intel EHCI to xHCI controller. If tried the USB2 port will be left
    unconnected and unusable.
    
    This patch should be backported to stable kernels as old as 3.12,
    that contain the commit 26b76798e0507429506b93cd49f8c4cfdab06896
    "Intel xhci: refactor EHCI/xHCI port switching"
    
    Cc: stable <stable@vger.kernel.org> # 3.12
    Reported-by: Jorge <xxopxe@gmail.com>
    Tested-by: Jorge <xxopxe@gmail.com>
    Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f2159d1e99612ceb94bf9a2dc2fbca409d828b1b
Merge: 2826958 77f0780
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 28 11:17:41 2014 -0700

    Merge tag 'sound-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
    
    Pull sound fixes from Takashi Iwai:
     "Just two small stable fixes: an HD-audio fix for the new Intel
      chipsets and a PM handling fix in PCM dmaengine core"
    
    * tag 'sound-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound:
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
      ALSA: pcm_dmaengine: Add check during device suspend

commit 282695802957b069d293a9f8773a14399093bd6f
Merge: 4efdedc b6dd6f4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 28 11:15:57 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs fix from Al Viro:
     "Oh, well...  Still nothing useful on that livelock (I had something
      that looked kinda-sorta like a non-invasive solution, but it
      deadlocks), so it's just Miklos' vmsplice fix for now"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs:
      vfs: fix vmplice_to_user()

commit 3f8517e7937d04ac7df9082c741fefc9c873065b
Author: Nicolas Pitre <nicolas.pitre@linaro.org>
Date:   Fri May 23 22:31:44 2014 +0100

    ARM: 8063/1: bL_switcher: fix individual online status reporting of removed CPUs
    
    The content of /sys/devices/system/cpu/cpu*/online  is still 1 for those
    CPUs that the switcher has removed even though the global state in
    /sys/devices/system/cpu/online is updated correctly.
    
    It turns out that commit 0902a9044f ("Driver core: Use generic
    offline/online for CPU offline/online") has changed the way those files
    retrieve their content by relying on on the generic attribute handling
    code.  The switcher, by calling cpu_down() directly, bypasses this
    handling and the attribute value doesn't get updated.
    
    Fix this by calling device_offline()/device_online() instead.
    
    Signed-off-by: Nicolas Pitre <nico@linaro.org>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit 397335f004f41e5fcf7a795e94eb3ab83411a17c
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu May 22 03:25:39 2014 +0000

    rtmutex: Fix deadlock detector for real
    
    The current deadlock detection logic does not work reliably due to the
    following early exit path:
    
    	/*
    	 * Drop out, when the task has no waiters. Note,
    	 * top_waiter can be NULL, when we are in the deboosting
    	 * mode!
    	 */
    	if (top_waiter && (!task_has_pi_waiters(task) ||
    			   top_waiter != task_top_pi_waiter(task)))
    		goto out_unlock_pi;
    
    So this not only exits when the task has no waiters, it also exits
    unconditionally when the current waiter is not the top priority waiter
    of the task.
    
    So in a nested locking scenario, it might abort the lock chain walk
    and therefor miss a potential deadlock.
    
    Simple fix: Continue the chain walk, when deadlock detection is
    enabled.
    
    We also avoid the whole enqueue, if we detect the deadlock right away
    (A-A). It's an optimization, but also prevents that another waiter who
    comes in after the detection and before the task has undone the damage
    observes the situation and detects the deadlock and returns
    -EDEADLOCK, which is wrong as the other task is not in a deadlock
    situation.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
    Cc: stable@vger.kernel.org
    Link: http://lkml.kernel.org/r/20140522031949.725272460@linutronix.de
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 4efdedca932658cc54866ee19001af3cbffa3769
Merge: 9e3d633 a4e91d0
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 28 08:08:03 2014 -0700

    Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
    
    Pull kvm fixes from Paolo Bonzini:
     "Small fixes for x86, slightly larger fixes for PPC, and a forgotten
      s390 patch.  The PPC fixes are important because they fix breakage
      that is new in 3.15"
    
    * tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm:
      KVM: s390: announce irqfd capability
      KVM: x86: disable master clock if TSC is reset during suspend
      KVM: vmx: disable APIC virtualization in nested guests
      KVM guest: Make pv trampoline code executable
      KVM: PPC: Book3S: ifdef on CONFIG_KVM_BOOK3S_32_HANDLER for 32bit
      KVM: PPC: Book3S HV: Add missing code for transaction reclaim on guest exit
      KVM: PPC: Book3S: HV: make _PAGE_NUMA take effect

commit 9e3d6331789b113e4abc831ed3447fb67a105430
Merge: cd79bde 011e4b0
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 28 08:06:50 2014 -0700

    Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
    
    Pull two powerpc fixes from Ben Herrenschmidt:
     "Here's a pair of powerpc fixes for 3.15 which are also going to
      stable.
    
      One's a fix for building with newer binutils (the problem currently
      only affects the BookE kernels but the affected macro might come back
      into use on BookS platforms at any time).  Unfortunately, the binutils
      maintainer did a backward incompatible change to a construct that we
      use so we have to add Makefile check.
    
      The other one is a fix for CPUs getting stuck in kexec when running
      single threaded.  Since we routinely use kexec on power (including in
      our newer bootloaders), I deemed that important enough"
    
    * 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc:
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode
      powerpc: Fix 64 bit builds with binutils 2.24

commit 64fd72e0a44bdd62c5ca277cb24d0d02b2d8e9dc
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 28 09:48:44 2014 -0400

    lift the "already marked killed" case into shrink_dentry_list()
    
    It can happen only when dentry_kill() is called with unlock_on_failure
    equal to 0 - other callers had dentry pinned until the moment they've
    got ->d_lock and DCACHE_DENTRY_KILLED is set only after lockref_mark_dead().
    
    IOW, only one of three call sites of dentry_kill() might end up reaching
    that code.  Just move it there.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f3f0d95146901a94eff8fe723eef2a6daf0ae152
Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date:   Tue Apr 8 08:58:01 2014 +0200

    MIPS: R46000: Fix Micro-assembler field overflow for R4600 V2
    
    Fix uasm warning, which triggered because of workaround for R4600 V2 CPUs.
    
    Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6716/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 57c7ea513f0e4b033ba602550992e2ca0e6b8d2c
Author: Alex Smith <alex.smith@imgtec.com>
Date:   Thu May 1 12:51:19 2014 +0100

    MIPS: ptrace: Avoid smp_processor_id() in preemptible code
    
    ptrace_{get,set}_watch_regs access current_cpu_data to get the watch
    register count/masks, which calls smp_processor_id(). However they are
    run in preemptible context and therefore trigger warnings like so:
    
    [ 6340.092000] BUG: using smp_processor_id() in preemptible [00000000] code: gdb/367
    [ 6340.092000] caller is ptrace_get_watch_regs+0x44/0x220
    
    Since the watch register count/masks should be the same across all
    CPUs, use boot_cpu_data instead. Note that this may need to change in
    future should a heterogenous system be supported where the count/masks
    are not the same across all CPUs (the current code is also incorrect
    for this scenario - current_cpu_data here would not necessarily be
    correct for the CPU that the target task will execute on).
    
    Signed-off-by: Alex Smith <alex.smith@imgtec.com>
    Reviewed-by: Paul Burton <paul.burton@imgtec.com>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6879/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit f02ffb199d3af57407a79075f3e0e6c0e8980b6c
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Tue May 13 17:07:04 2014 +0200

    MIPS: Lemote 2F: cs5536: mfgpt: use raw locks
    
    The lock is taken in the raw irq path and therefore a rawlock should be
    used instead of a normal spinlock.
    While here I drop the export symbol on that variable since there are no
    other users.
    
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Cc: linux-mips@linux-mips.org
    Cc: Hua Yan <yanh@lemote.com>
    Cc: Huacai Chen <chenhc@lemote.com>
    Cc: Alex Smith <alex.smith@imgtec.com>
    Cc: Hongliang Tao <taohl@lemote.com>
    Cc: Wu Zhangjin <wuzhangjin@gmail.com>
    Patchwork: https://patchwork.linux-mips.org/patch/6936/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit bb6c0bd3fdb67c8a1fceea1d4700b9ee593309f9
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Wed May 28 08:36:23 2014 +0200

    MIPS: SB1: Fix excessive kernel warnings.
    
    A kernel build with binutils 2.24 is going to emit warnings like
    
      CC      kernel/sys.o
    {standard input}: Assembler messages:
    {standard input}:701: Warning: the 32-bit MIPS architecture does not support the `mdmx' extension
    {standard input}:701: Warning: the `mdmx' extension requires 64-bit FPRs
    {standard input}:701: Warning: the `mips3d' extension requires MIPS32 revision 2 or greater
    {standard input}:701: Warning: the `mips3d' extension requires 64-bit FPRs
    
    for almost every file.  This is caused by changes to gas' interpretation
    of .set semantics.  Fixed by explicitly disabling MIPS3D and MDMX for
    Sibyte builds.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit b6dd6f4738837439c520e73995ec93fe1de2ec72
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue May 27 16:41:16 2014 +0200

    vfs: fix vmplice_to_user()
    
    Commit 6130f5315ee8 "switch vmsplice_to_user() to copy_page_to_iter()" in
    v3.15-rc1 broke vmsplice(2).
    
    This patch fixes two bugs:
    
     - count is not initialized to a proper value, which resulted in no data
       being copied
    
     - if rw_copy_check_uvector() returns negative then the iov might be leaked.
    
    Tested OK.
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5178438041cc94680e606e5a9c6d1ad9c911199b
Merge: 72b1c2c 4ccc402
Author: Mike Turquette <mturquette@linaro.org>
Date:   Tue May 27 21:11:08 2014 -0700

    Merge tag 'clk-tegra-fixes-3.15' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes
    
    PLLE fixes for 3.15

commit 3991b31ea072b070081ca3bfa860a077eda67de5
Author: NeilBrown <neilb@suse.de>
Date:   Wed May 28 13:39:23 2014 +1000

    md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
    
    If mddev->ro is set, md_to_sync will (correctly) abort.
    However in that case MD_RECOVERY_INTR isn't set.
    
    If a RESHAPE had been requested, then ->finish_reshape() will be
    called and it will think the reshape was successful even though
    nothing happened.
    
    Normally a resync will not be requested if ->ro is set, but if an
    array is stopped while a reshape is on-going, then when the array is
    started, the reshape will be restarted.  If the array is also set
    read-only at this point, the reshape will instantly appear to success,
    resulting in data corruption.
    
    Consequently, this patch is suitable for any -stable kernel.
    
    Cc: stable@vger.kernel.org (any)
    Signed-off-by: NeilBrown <neilb@suse.de>

commit 011e4b02f1da156ac7fea28a9da878f3c23af739
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Tue May 27 16:25:34 2014 +0530

    powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode
    
    If we try to perform a kexec when the machine is in ST (Single-Threaded) mode
    (ppc64_cpu --smt=off), the kexec operation doesn't succeed properly, and we
    get the following messages during boot:
    
    [    0.089866] POWER8 performance monitor hardware support registered
    [    0.089985] power8-pmu: PMAO restore workaround active.
    [    5.095419] Processor 1 is stuck.
    [   10.097933] Processor 2 is stuck.
    [   15.100480] Processor 3 is stuck.
    [   20.102982] Processor 4 is stuck.
    [   25.105489] Processor 5 is stuck.
    [   30.108005] Processor 6 is stuck.
    [   35.110518] Processor 7 is stuck.
    [   40.113369] Processor 9 is stuck.
    [   45.115879] Processor 10 is stuck.
    [   50.118389] Processor 11 is stuck.
    [   55.120904] Processor 12 is stuck.
    [   60.123425] Processor 13 is stuck.
    [   65.125970] Processor 14 is stuck.
    [   70.128495] Processor 15 is stuck.
    [   75.131316] Processor 17 is stuck.
    
    Note that only the sibling threads are stuck, while the primary threads (0, 8,
    16 etc) boot just fine. Looking closer at the previous step of kexec, we observe
    that kexec tries to wakeup (bring online) the sibling threads of all the cores,
    before performing kexec:
    
    [ 9464.131231] Starting new kernel
    [ 9464.148507] kexec: Waking offline cpu 1.
    [ 9464.148552] kexec: Waking offline cpu 2.
    [ 9464.148600] kexec: Waking offline cpu 3.
    [ 9464.148636] kexec: Waking offline cpu 4.
    [ 9464.148671] kexec: Waking offline cpu 5.
    [ 9464.148708] kexec: Waking offline cpu 6.
    [ 9464.148743] kexec: Waking offline cpu 7.
    [ 9464.148779] kexec: Waking offline cpu 9.
    [ 9464.148815] kexec: Waking offline cpu 10.
    [ 9464.148851] kexec: Waking offline cpu 11.
    [ 9464.148887] kexec: Waking offline cpu 12.
    [ 9464.148922] kexec: Waking offline cpu 13.
    [ 9464.148958] kexec: Waking offline cpu 14.
    [ 9464.148994] kexec: Waking offline cpu 15.
    [ 9464.149030] kexec: Waking offline cpu 17.
    
    Instrumenting this piece of code revealed that the cpu_up() operation actually
    fails with -EBUSY. Thus, only the primary threads of all the cores are online
    during kexec, and hence this is a sure-shot receipe for disaster, as explained
    in commit e8e5c2155b (powerpc/kexec: Fix orphaned offline CPUs across kexec),
    as well as in the comment above wake_offline_cpus().
    
    It turns out that cpu_up() was returning -EBUSY because the variable
    'cpu_hotplug_disabled' was set to 1; and this disabling of CPU hotplug was done
    by migrate_to_reboot_cpu() inside kernel_kexec().
    
    Now, migrate_to_reboot_cpu() was originally written with the assumption that
    any further code will not need to perform CPU hotplug, since we are anyway in
    the reboot path. However, kexec is clearly not such a case, since we depend on
    onlining CPUs, atleast on powerpc.
    
    So re-enable cpu-hotplug after returning from migrate_to_reboot_cpu() in the
    kexec path, to fix this regression in kexec on powerpc.
    
    Also, wrap the cpu_up() in powerpc kexec code within a WARN_ON(), so that we
    can catch such issues more easily in the future.
    
    Fixes: c97102ba963 (kexec: migrate to reboot cpu)
    Cc: stable@vger.kernel.org
    Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 7998eb3dc700aaf499f93f50b3d77da834ef9e1d
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Thu May 15 09:33:42 2014 -0700

    powerpc: Fix 64 bit builds with binutils 2.24
    
    With binutils 2.24, various 64 bit builds fail with relocation errors
    such as
    
    arch/powerpc/kernel/built-in.o: In function `exc_debug_crit_book3e':
    	(.text+0x165ee): relocation truncated to fit: R_PPC64_ADDR16_HI
    	against symbol `interrupt_base_book3e' defined in .text section
    	in arch/powerpc/kernel/built-in.o
    arch/powerpc/kernel/built-in.o: In function `exc_debug_crit_book3e':
    	(.text+0x16602): relocation truncated to fit: R_PPC64_ADDR16_HI
    	against symbol `interrupt_end_book3e' defined in .text section
    	in arch/powerpc/kernel/built-in.o
    
    The assembler maintainer says:
    
     I changed the ABI, something that had to be done but unfortunately
     happens to break the booke kernel code.  When building up a 64-bit
     value with lis, ori, shl, oris, ori or similar sequences, you now
     should use @high and @higha in place of @h and @ha.  @h and @ha
     (and their associated relocs R_PPC64_ADDR16_HI and R_PPC64_ADDR16_HA)
     now report overflow if the value is out of 32-bit signed range.
     ie. @h and @ha assume you're building a 32-bit value. This is needed
     to report out-of-range -mcmodel=medium toc pointer offsets in @toc@h
     and @toc@ha expressions, and for consistency I did the same for all
     other @h and @ha relocs.
    
    Replacing @h with @high in one strategic location fixes the relocation
    errors. This has to be done conditionally since the assembler either
    supports @h or @high but not both.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 7ac3764fcafc06e72e1a79a9d998b9fdd900b2a6
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue May 27 16:32:10 2014 -0700

    USB: cdc-wdm: properly include types.h
    
    The file include/uapi/linux/usb/cdc-wdm.h uses a __u16 so it needs to
    include types.h as well to make the build system happy.
    
    Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
    Cc: stable <stable@vger.kernel.org> # 3.10+
    Cc: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7d1896360f4d055d68565ef8ed56a677580f1a39
Author: Bjørn Mork <bjorn@mork.no>
Date:   Sat May 10 16:31:40 2014 +0200

    usb: cdc-wdm: export cdc-wdm uapi header
    
    The include/uapi/linux/usb/cdc-wdm.h header defines cdc-wdm
    userspace APIs and should be exported by make headers_install.
    
    Cc: <stable@vger.kernel.org> # 3.10, 3.12, 3.14
    Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
    Signed-off-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit efb27e73e12633a24dfdc67b8a6a58c4b427f3e4
Merge: c720816 d23db88
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed May 28 09:18:32 2014 +1000

    Merge tag 'drm-intel-fixes-2014-05-27' of git://anongit.freedesktop.org/drm-intel into drm-fixes
    
    Fixes from Chris, all cc: stable.
    
    * tag 'drm-intel-fixes-2014-05-27' of git://anongit.freedesktop.org/drm-intel:
      drm/i915: Prevent negative relocation deltas from wrapping
      drm/i915: Only copy back the modified fields to userspace from execbuffer
      drm/i915: Fix dynamic allocation of physical handles

commit cd79bde29f00a346eec3fe17c1c5073c37ed95e7
Merge: aa699a1 aa0818c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 27 15:59:34 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.dk/linux-block
    
    Pull virtio_blk fix from Jens Axboe:
     "There's a start/stop queue race in virtio_blk, which causes stalls and
      erratic behaviour for some.  I've had this queued up for 3.16 for a
      while, but I think we should push it into the current series as well.
    
      So I cherry picked the commit and added a stable marker as well, so it
      can propagate down"
    
    * 'for-linus' of git://git.kernel.dk/linux-block:
      virtio_blk: fix race between start and stop queue

commit aa699a1d84474eb993867822b6aefc47a9a6ce0c
Merge: 758b671 acbf6d2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 27 15:58:20 2014 -0700

    Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull two timer fixes from Thomas Gleixner:
     "Two small fixlets for ARM SoC clocksource drivers:
    
       - avoid calling functions which might sleep from interrupt [disabled]
         context in tcb_clksrc used on Atmel SoCs
    
       - use irq_force_affinity() to pin the per cpu timer interrupt on a
         not yet online cpu in the SiRFprimaII driver"
    
    * 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      clocksource: tcb_clksrc: Make tc_mode interrupt safe
      clocksource: marco: Fix the affinity set for local timer of CPU1

commit 8a61ba3a47ac39f660702aa66a172185dd605a86
Author: Alexej Starschenko <starschenko@gmail.com>
Date:   Wed May 7 10:43:29 2014 +0200

    USB: serial: option: add support for Novatel E371 PCIe card
    
    Adds product ID for the Novatel E371 PCI Express Mini Card.
    
    $ lsusb
    Bus 001 Device 024: ID 1410:9011 Novatel Wireless
    
    $ usb-devices
    T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#= 24 Spd=480 MxCh= 0
    D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=1410 ProdID=9011 Rev=00.03
    S:  Manufacturer=Novatel Wireless, Inc.
    S:  Product=Novatel Wireless HSPA
    S:  SerialNumber=012773002115811
    C:  #Ifs= 6 Cfg#= 1 Atr=e0 MxPwr=500mA
    I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
    I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
    I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
    I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
    I:  If#= 6 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
    I:  If#= 7 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
    
    Tested with kernel 3.2.0.
    
    Signed-off-by: Alexej Starschenko <starschenko@gmail.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d0839d757e6294921c31b1c4ca4f1dcc5df63bcd
Author: George McCollister <george.mccollister@gmail.com>
Date:   Sat Apr 26 12:04:47 2014 +0200

    USB: ftdi_sio: add NovaTech OrionLXm product ID
    
    The NovaTech OrionLXm uses an onboard FTDI serial converter for JTAG and
    console access.
    
    Here is the lsusb output:
    Bus 004 Device 123: ID 0403:7c90 Future Technology Devices
    International, Ltd
    
    Signed-off-by: George McCollister <george.mccollister@gmail.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c03890ff5e24a4bf59059f2d179f427559b7330a
Author: Johan Hovold <jhovold@gmail.com>
Date:   Sat Apr 26 11:53:44 2014 +0200

    USB: io_ti: fix firmware download on big-endian machines (part 2)
    
    A recent patch that purported to fix firmware download on big-endian
    machines failed to add the corresponding sparse annotation to the
    i2c-header. This was reported by the kbuild test robot.
    
    Adding the appropriate annotation revealed another endianess bug related
    to the i2c-header Size-field in a code path that is exercised when the
    firmware is actually being downloaded (and not just verified and left
    untouched unless older than the firmware at hand).
    
    This patch adds the required sparse annotation to the i2c-header and
    makes sure that the Size-field is sent in little-endian byte order
    during firmware download also on big-endian machines.
    
    Note that this patch is only compile-tested, but that there is no
    functional change for little-endian systems.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Cc: Ludovic Drolez <ldrolez@debian.org>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 758b67126facde350bcbfbb1cd760aa6050f8647
Merge: 51d5665 1b0fe6b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 27 13:59:24 2014 -0700

    Merge tag 'fixes-for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
    
    Pull ARM SoC fixes from Olof Johansson:
     "A slightly larger set of fixes than we'd like at this point in the
      release.  Hopefully our very last batch before 3.15:
    
      OMAP:
       - Fix boot regression with CPU_IDLE enabled
       - Fixes for audio playback on OMAP5
       - Clock rate setting fix for OMAP3
       - Misc idle/PM fixes
      Exynos:
       - Removal of a couple of power domains to work around issues with
         access when they are powered down
       - Enabling missing highspeed-i2c driver to make MMC regulators work
       - Secondary CPU spin-up fix for 4212
       - Remove MDMA1 engine to avoid conflicts on secure mode platforms
       - A few other DT fixes
      Marvell:
       - PCI-e fixes for clocks and resource allocation
    
      plus a few other smaller fixes, add a MAINTAINERS entry for reset
      drivers, etc"
    
    * tag 'fixes-for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc: (21 commits)
      MAINTAINERS: Add reset controller framework entry
      ARM: trusted_foundations: fix compile error on non-SMP
      ARM: at91: sam9260: fix compilation issues
      ARM: mvebu: fix definitions of PCIe interfaces on Armada 38x
      ARM: imx: fix error handling in ipu device registration
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled
      ARM: dts: Keep LDO4 always ON for exynos5250-arndale board
      ARM: dts: Fix SPI interrupt numbers for exynos5420
      ARM: dts: fix incorrect ak8975 compatible for exynos4412-trats2 board
      ARM: OMAP2+: Fix DMA hang after off-idle
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards
      ARM: dts: Remove g2d_pd node for exynos5420
      ARM: dts: Remove mau_pd node for exynos5420
      ARM: exynos_defconfig: enable HS-I2C to fix for mmc partition mount
      ARM: dts: disable MDMA1 node for exynos5420
      ARM: EXYNOS: fix the secondary CPU boot of exynos4212
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM
      ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
      ARM: mvebu: mvebu-soc-id: add missing clk_put() call
      ARM: at91/dt: sam9260: correct external trigger value
      ...

commit 51d566523bc0b42cebecf21f635396281954e03c
Merge: c949ddf 7ea4564
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 27 13:58:46 2014 -0700

    Merge tag 'pinctrl-v3.15-4' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
    
    Pull pinctrl fix from Linus Walleij:
     "A single last pinctrl fix for the v3.15 series: the vt8500 driver was
      failing to update the output value when the combined set direction
      output and set value was executed"
    
    * tag 'pinctrl-v3.15-4' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl:
      pinctrl: vt8500: Ensure value reg is updated when setting direction

commit c949ddf9eb140f69dbf4495f234b558fc9691cbb
Merge: c720816 fbeb91f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 27 13:57:00 2014 -0700

    Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma
    
    Pull slave-dmaengine fixes from Vinod Koul:
     "We have three small fixes.
    
      First one from Andy reverts the devm_request irq as we need to ensure
      the tasklet is killed after irq is freed, so we need to do free irq in
      our code.  Other two from Arnd are fixing the compilation issue in
      omap and sa11x0 drivers with ARM randconfigs"
    
    * 'fixes' of git://git.infradead.org/users/vkoul/slave-dma:
      dmaengine: sa11x0: remove broken #ifdef
      dmaengine: omap: hide filter_fn for built-in drivers
      dmaengine: dw: went back to plain {request,free}_irq() calls

commit 1b0fe6be858d47e7e80fe0adc47c7366f5924244
Author: Philipp Zabel <p.zabel@pengutronix.de>
Date:   Tue May 27 15:58:09 2014 +0200

    MAINTAINERS: Add reset controller framework entry
    
    Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 63d832c30142cdceb478b1cac7d943d83b95b2dc
Author: Hannes Reinecke <hare@suse.de>
Date:   Mon May 26 14:45:39 2014 +0200

    dm mpath: really fix lockdep warning
    
    lockdep complains about a circular locking.  And indeed, we need to
    release the lock before calling dm_table_run_md_queue_async().
    
    As such, commit 4cdd2ad ("dm mpath: fix lock order inconsistency in
    multipath_ioctl") must also be reverted in addition to fixing the
    lock order in the other dm_table_run_md_queue_async() callers.
    
    Reported-by: Bart van Assche <bvanassche@acm.org>
    Tested-by: Bart van Assche <bvanassche@acm.org>
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

commit aa0818c6ee8d8e4772725a43550823347bc1ad30
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Fri May 16 23:31:21 2014 +0800

    virtio_blk: fix race between start and stop queue
    
    When there isn't enough vring descriptor for adding to vq,
    blk-mq will be put as stopped state until some of pending
    descriptors are completed & freed.
    
    Unfortunately, the vq's interrupt may come just before
    blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
    still be kept as stopped even though lots of descriptors
    are completed and freed in the interrupt handler. The worst
    case is that all pending descriptors are freed in the
    interrupt handler, and the queue is kept as stopped forever.
    
    This patch fixes the problem by starting/stopping blk-mq
    with holding vq_lock.
    
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <axboe@fb.com>
    
    Conflicts:
    	drivers/block/virtio_blk.c

commit f1daa838e861ae1a0fb7cd9721a21258430fcc8c
Author: Heinz Mauelshagen <heinzm@redhat.com>
Date:   Fri May 23 14:10:01 2014 -0400

    dm cache: always split discards on cache block boundaries
    
    The DM cache target cannot cope with discards that span multiple cache
    blocks, so each discard bio that spans more than one cache block must
    get split by the DM core.
    
    Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
    Acked-by: Joe Thornber <ejt@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org # v3.9+

commit 45fb4f8d81578e0a17c45c4593a3305afbf7a48b
Author: Oliver Hartkopp <socketcan@hartkopp.net>
Date:   Tue May 27 13:30:56 2014 +0200

    can: only rename enabled led triggers when changing the netdev name
    
    Commit a1ef7bd9fce8 ("can: rename LED trigger name on netdev renames") renames
    the led trigger names according to the changed netdevice name.
    
    As not every CAN driver supports and initializes the led triggers, checking for
    the CAN private datastructure with safe_candev_priv() in the notifier chain is
    not enough.
    
    This patch adds a check when CONFIG_CAN_LEDS is enabled and the driver does not
    support led triggers.
    
    For stable 3.9+
    
    Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
    Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
    Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
    Cc: linux-stable <stable@vger.kernel.org>
    Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

commit d23db88c3ab233daed18709e3a24d6c95344117f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri May 23 08:48:08 2014 +0200

    drm/i915: Prevent negative relocation deltas from wrapping
    
    This is pure evil. Userspace, I'm looking at you SNA, repacks batch
    buffers on the fly after generation as they are being passed to the
    kernel for execution. These batches also contain self-referenced
    relocations as a single buffer encompasses the state commands, kernels,
    vertices and sampler. During generation the buffers are placed at known
    offsets within the full batch, and then the relocation deltas (as passed
    to the kernel) are tweaked as the batch is repacked into a smaller buffer.
    This means that userspace is passing negative relocations deltas, which
    subsequently wrap to large values if the batch is at a low address. The
    GPU hangs when it then tries to use the large value as a base for its
    address offsets, rather than wrapping back to the real value (as one
    would hope). As the GPU uses positive offsets from the base, we can
    treat the relocation address as the minimum address read by the GPU.
    For the upper bound, we trust that userspace will not read beyond the
    end of the buffer.
    
    So, how do we fix negative relocations from wrapping? We can either
    check that every relocation looks valid when we write it, and then
    position each object such that we prevent the offset wraparound, or we
    just special-case the self-referential behaviour of SNA and force all
    batches to be above 256k. Daniel prefers the latter approach.
    
    This fixes a GPU hang when it tries to use an address (relocation +
    offset) greater than the GTT size. The issue would occur quite easily
    with full-ppgtt as each fd gets its own VM space, so low offsets would
    often be handed out. However, with the rearrangement of the low GTT due
    to capturing the BIOS framebuffer, it is already affecting kernels 3.15
    onwards. I think only IVB+ is susceptible to this bug, but the workaround
    should only kick in rarely, so it seems sensible to always apply it.
    
    v3: Use a bias for batch buffers to prevent small negative delta relocations
    from wrapping.
    
    v4 from Daniel:
    - s/BIAS/BATCH_OFFSET_BIAS/
    - Extract eb_vma_misplaced/i915_vma_misplaced since the conditions
      were growing rather cumbersome.
    - Add a comment to eb_get_batch explaining why we do this.
    - Apply the batch offset bias everywhere but mention that we've only
      observed it on gen7 gpus.
    - Drop PIN_OFFSET_FIX for now, that slipped in from a feature patch.
    
    v5: Add static to eb_get_batch, spotted by 0-day tester.
    
    Testcase: igt/gem_bad_reloc
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=78533
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk> (v3)
    Cc: stable@vger.kernel.org
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9aab8bff7aa3bee567213ad3c1fdfb217bb980a2
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri May 23 10:45:52 2014 +0100

    drm/i915: Only copy back the modified fields to userspace from execbuffer
    
    We only want to modifiy a single field in the userspace view of the
    execbuffer command buffer, so explicitly change that rather than copy
    everything back again.
    
    This serves two purposes:
    
    1. The single fields are much cheaper to copy (constant size so the
    copy uses special case code) and much smaller than the whole array.
    
    2. We modify the array for internal use that need to be masked from
    the user.
    
    Note: We need this backported since without it the next bugfix will
    blow up when userspace recycles batchbuffers and relocations.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: stable@vger.kernel.org
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 00731155a73020c8e3c215723be193f96b4fcb1f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed May 21 12:42:56 2014 +0100

    drm/i915: Fix dynamic allocation of physical handles
    
    A single object may be referenced by multiple registers fundamentally
    breaking the static allotment of ids in the current design. When the
    object is used the second time, the physical address of the first
    assignment is relinquished and a second one granted. However, the
    hardware is still reading (and possibly writing) to the old physical
    address now returned to the system. Eventually hilarity will ensue, but
    in the short term, it just means that cursors are broken when using more
    than one pipe.
    
    v2: Fix up leak of pci handle when handling an error during attachment,
    and avoid a double kmap/kunmap. (Ville)
    Rebase against -fixes.
    
    v3: And fix the error handling added in v2 (Ville)
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77351
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Cc: Jani Nikula <jani.nikula@linux.intel.com>
    Cc: stable@vger.kernel.org
    Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0f68f39c393bc06ac5ccc8794f0e2ed841e41c3e
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon May 19 22:54:09 2014 -0700

    Input: synaptics - change min/max quirk table to pnp-id matching
    
    Most of the affected models share pnp-ids for the touchpad. So switching
    to pnp-ids give us 2 advantages:
    1) It shrinks the quirk list
    2) It will lower the new quirk addition frequency, ie the recently added W540
       quirk would not have been necessary since it uses the same LEN0034 pnp ids
       as other models already added before it
    
    As an added bonus it actually puts the quirk on the actual psmouse, rather
    then on the machine, which is technically more correct.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit e2f611029b370bb7a04236215ad4b36aa8cb98cd
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon May 19 22:53:23 2014 -0700

    Input: synaptics - add a matches_pnp_id helper function
    
    This is a preparation patch for simplifying the min/max quirk table.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 6d396ede224dc596d92d7cab433713536e68916c
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon May 19 22:52:30 2014 -0700

    Input: synaptics - T540p - unify with other LEN0034 models
    
    The T540p has a touchpad with pnp-id LEN0034, all the models with this
    pnp-id have the same min/max values, except the T540p where the values are
    slightly off. Fix them to be identical.
    
    This is a preparation patch for simplifying the quirk table.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 9b961aa99b8155ecc07dd727643ca97424544256
Merge: c720816 e3beb0a 2807bd1
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon May 26 23:20:16 2014 +0200

    Merge branches 'pm-cpufreq' and 'acpi-thermal'
    
    * pm-cpufreq:
      cpufreq: cpu0: drop wrong devm usage
      cpufreq: remove race while accessing cur_policy
    
    * acpi-thermal:
      ACPI / thermal: fix workqueue destroy order

commit 2807bd18cc60ec471917b5158e98e4d7b7e030fb
Author: Aaron Lu <aaron.lu@intel.com>
Date:   Mon May 26 14:34:07 2014 +0200

    ACPI / thermal: fix workqueue destroy order
    
    When the thermal module is to be removed, we should destroy the wq
    acpi_thermal_pm_queue after the ACPI driver's remove callback is
    executed as we will need to flush the workqueue there, or a NULL pointer
    access will be hit.
    
    Reported-and-tested-by: Kui Zhang <kuizhang@gmail.com>
    References: http://www.spinics.net/lists/kernel/msg1747251.html
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Aaron Lu <aaron.lu@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 66ef3fab94df1004ed02c292d3d4e78485bfc615
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Thu May 15 10:35:44 2014 +0200

    MIPS: RC32434: fix broken PCI resource initialization
    
    The parent field of the 'rc32434_res_pci_mem1' resource points to
    the resource itself which is obviously wrong. Due to the broken
    initialitazion, the PCI devices on the Mikrotik RB532 boards are
    not working since commit 22283178 (MIPS: avoid possible resource
    conflict in register_pci_controller).
    
    Remove the field initialization to fix the issue.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Reported-by: Waldemar Brodkorb <wbx@openadk.org>
    Cc: linux-mips@linux-mips.org
    Cc: Gabor Juhos <juhosg@openwrt.org>
    Patchwork: https://patchwork.linux-mips.org/patch/6940/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit f44a5f45f544561302e855e7bd104e5f506ec01b
Author: Peter Christensen <pch@ordbogen.com>
Date:   Sat May 24 21:40:12 2014 +0200

    ipvs: Fix panic due to non-linear skb
    
    Receiving a ICMP response to an IPIP packet in a non-linear skb could
    cause a kernel panic in __skb_pull.
    
    The problem was introduced in
    commit f2edb9f7706dcb2c0d9a362b2ba849efe3a97f5e ("ipvs: implement
    passive PMTUD for IPIP packets").
    
    Signed-off-by: Peter Christensen <pch@ordbogen.com>
    Acked-by: Julian Anastasov <ja@ssi.bg>
    Signed-off-by: Simon Horman <horms@verge.net.au>

commit c7208164e66f63e3ec1759b98087849286410741
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 16:06:00 2014 -0700

    Linux 3.15-rc7

commit 483a6c9d447f625b991fa04a1530493d893984db
Author: Rabin Vincent <rabin@rab.in>
Date:   Sat May 24 17:38:01 2014 +0100

    ARM: 8064/1: fix v7-M signal return
    
    According to the ARM ARM, the behaviour is UNPREDICTABLE if the PC read
    from the exception return stack is not half word aligned.  See the
    pseudo code for ExceptionReturn() and PopStack().
    
    The signal handler's address has the bit 0 set, and setup_return()
    directly writes this to regs->ARM_pc.  Current hardware happens to
    discard this bit, but QEMU's emulation doesn't and this makes processes
    crash.  Mask out bit 0 before the exception return in order to get
    predictable behaviour.
    
    Fixes: 19c4d593f0b4 ("ARM: ARMv7-M: Add support for exception handling")
    
    Cc: stable@kernel.org
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit fbebf59778600488147744cdf7d7c20d22531025
Author: srinik <srinivas.kandagatla@linaro.org>
Date:   Thu May 15 11:28:44 2014 +0100

    ARM: 8057/1: amba: Add Qualcomm vendor ID.
    
    This patch adds Qualcomm amba vendor Id to the list. This ID is used in mmci driver. The ID selected in same lines like 0x41 is "A" for ARM, 0x51 is "Q" for Qualcomm.
    
    As there are no physical register on Qcom SOC for amba vendor id, this is a fake ID assigned based on "Q" prefix from Qualcomm.
    
    Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit 8203d5b628907ae6141e4eb52f9b48e0f1f46cd2
Author: Nikolay Borisov <Nikolay.Borisov@arm.com>
Date:   Thu May 8 15:54:26 2014 +0100

    ARM: 8052/1: unwind: Fix handling of "Pop r4-r[4+nnn],r14" opcode
    
    The arm EABI states that unwind opcode 10100nnn means pop register r4-4[4+nnn],aditionally there is a similar unwind opcode: 10101nnn which means the same thing plus popping r14. Those two cases are handled by the unwind_exec_pop_r4_to_rN function which checks whether the 4th bit is set and does r14 popping.
    
    However, up until now it has been checking whether the 8th bit was set (mask & 0x80) instead of the 4th (mask & 0x8), a simple to make typo but this meant that we were always popping r14 even if we had the former opcode.
    
    This patch changes the mask so that the 2 unwind opcodes are being handled correctly.
    
    Signed-off-by: Nikolay Borisov <Nikolay.Borisov@arm.com>
    Reviewed-by: Anurag Aggarwal <anurag19aggarwal@gmail.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit 537094b64b229bf3ad146042f83e74cf6abe59df
Author: Andrey Ryabinin <a.ryabinin@samsung.com>
Date:   Wed May 7 08:07:25 2014 +0100

    ARM: 8051/1: put_user: fix possible data corruption in put_user
    
    According to arm procedure call standart r2 register is call-cloberred.
    So after the result of x expression was put into r2 any following
    function call in p may overwrite r2. To fix this, the result of p
    expression must be saved to the temporary variable before the
    assigment x expression to __r2.
    
    Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
    Reviewed-by: Nicolas Pitre <nico@linaro.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit f9ff907b0af561dcde4683f7c9f71dc0f41d3be3
Author: Rabin Vincent <rabin@rab.in>
Date:   Sat May 3 18:19:17 2014 +0100

    ARM: 8048/1: fix v7-M setup stack location
    
    __v7m_setup_stack currently sits in the .proc.info.init section, and
    thus creates a bogus proc info entry (which by the way matches any
    unknown CPU IDs, due to the entry's mask being 0).  Move it out of
    there.
    
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit db1003f23189cdbb2d450dff1edbc8e318797344
Merge: ef0d2c1 656f88d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 12:40:36 2014 -0700

    Merge branch 'afs' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
    
    Pull AFS fixes and cleanups from David Howells:
     "Here are some patches to the AFS filesystem:
    
      1) Fix problems in the clean-up parts of the cache manager service
         handler.
    
      2) Split afs_end_call() introduced in (1) and replace some identical
         code elsewhere with a call to the first half of the split function.
    
      3) Fix an error introduced in the workqueue PREPARE_WORK() elimination
         commits.
    
      4) Clean up argument passing to functions called from the workqueue as
         there's now an insulating layer between them and the workqueue.
         This is possible from (3)"
    
    * 'afs' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs:
      AFS: Pass an afs_call* to call->async_workfn() instead of a work_struct*
      AFS: Fix kafs module unloading
      AFS: Part of afs_end_call() is identical to code elsewhere, so split it
      AFS: Fix cache manager service handlers

commit ef0d2c1686aa256a5f7a4a5f55415563c1ab184c
Merge: f016a64 3568a1d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 12:39:08 2014 -0700

    Merge branch 'rdunlap' (patches from Randy Dunlap)
    
    Merge documentation fixes from Randy Dunlap.
    
    * emailed patches from Randy Dunlap <rdunlap@infradead.org>:
      Documentation: update /proc/stat "intr" count summary
      Documentation: update java sample wrapper for java 7
      Documentation: update thunderbird email client settings
      Documentation: fix typos in drm docbook

commit 3568a1dbf174a1ae0022611998c4e5d588b5014d
Author: Jan Moskyto Matejka <mq@suse.cz>
Date:   Thu May 15 13:55:34 2014 -0700

    Documentation: update /proc/stat "intr" count summary
    
    The sum at the beginning of line "intr" includes also unnumbered
    interrupts.  It implies that the sum at the beginning isn't the sum
    of the remainder of the line, not even an estimation.
    
    Fixed the documentation to mention that.
    
    This behaviour was added to /proc/stat in commit a2eddfa95919 ("x86:
    make /proc/stat account for all interrupts")
    
    Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f76f133b0c3b182c2d4f4de21a04ba4c964d508d
Author: Jonathan Callen <jcallen@gentoo.org>
Date:   Thu May 15 13:54:52 2014 -0700

    Documentation: update java sample wrapper for java 7
    
    The sample wrapper currently fails on some Java 7 .class files.  This
    updates the wrapper to properly handle those files.
    
    Signed-off-by: Jonathan Callen <jcallen@gentoo.org>
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f9a0974d3f7049f6f753ebd28b8f0907983acf3c
Author: Paul McQuade <paulmcquad@gmail.com>
Date:   Thu May 15 13:54:25 2014 -0700

    Documentation: update thunderbird email client settings
    
    Added setting to email-clients that is easier to read and is easier to
    setup thunderbird.  Removed config settings and added GUI settings.
    
    Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f9b899c44fec53c1519b19f853e96191ae96b1c6
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Thu May 15 13:54:06 2014 -0700

    Documentation: fix typos in drm docbook
    
    Fix spelling typo in DocBook/drm.tmpl
    
    Signed-off-by: Masanari Iida <standby24x7@gmail.com>
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f016a6441a18000d5918ee3e05d9bdd4d53fed1c
Merge: 0e37c27 ead82d6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 10:20:36 2014 -0700

    Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
    
    Pull hwmon subsystem fixes from Jean Delvare.
    
    * 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging:
      hwmon: (ntc_thermistor) Fix OF device ID mapping
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: Document temp[1-*]_min_hyst sysfs attribute

commit 0e37c275426c34712d4661d86c375779f3836a7e
Merge: 80a1de2 6aa6caf
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 10:13:50 2014 -0700

    Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
    
    Pull single scsi fix from James Bottomley:
     "This is a single fix for a bug exposed by a sysfs change in 3.13 which
      now causes libsas to trigger a warn on in device removal"
    
    * tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi:
      [SCSI] scsi_transport_sas: move bsg destructor into sas_rphy_remove

commit 80a1de29a5a67abac02cb10c32545eb231e0e778
Merge: 0374300 27b1142
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 25 10:08:48 2014 -0700

    Merge branch 'for-3.15' of git://linux-nfs.org/~bfields/linux
    
    Pull two nfsd bugfixes from Bruce Fields:
     "Just two bugfixes, one for a merge-window-introduced ACL regression,
      the other for a longer-standing v4 state bug"
    
    * 'for-3.15' of git://linux-nfs.org/~bfields/linux:
      nfsd4: warn on finding lockowner without stateid's
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: fix corruption on setting an ACL.

commit ead82d6792ef5c600d535bca6ec50a4da14ff7c7
Author: Jean Delvare <jdelvare@suse.de>
Date:   Sun May 25 17:23:08 2014 +0200

    hwmon: (ntc_thermistor) Fix OF device ID mapping
    
    The mapping from OF device IDs to platform device IDs is wrong.
    TYPE_NCPXXWB473 is 0, TYPE_NCPXXWL333 is 1, so
    ntc_thermistor_id[TYPE_NCPXXWB473] is { "ncp15wb473", TYPE_NCPXXWB473 }
    while
    ntc_thermistor_id[TYPE_NCPXXWL333] is { "ncp18wb473", TYPE_NCPXXWB473 }.
    
    So the name is wrong for all but the "ntc,ncp15wb473" entry, and the
    type is wrong for the "ntc,ncp15wl333" entry.
    
    So map the entries by index, it is neither elegant nor robust but at
    least it is correct.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Fixes: 9e8269de hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
    Cc: Doug Anderson <dianders@chromium.org>

commit 59cf4243e557aa64ab2ef51280454aa1f3828e14
Author: Jean Delvare <jdelvare@suse.de>
Date:   Sun May 25 17:23:08 2014 +0200

    hwmon: (ntc_thermistor) Fix dependencies
    
    In commit 9e8269de, support was added for ntc_thermistor devices being
    declared in the device tree and implemented on top of IIO. With that
    change, a dependency was added to the ntc_thermistor driver:
    
    	depends on (!OF && !IIO) || (OF && IIO)
    
    This construct has the drawback that the driver can no longer be
    selected when OF is set and IIO isn't, nor when IIO is set and OF is
    not. This is a regression for the original users of the driver.
    
    As the new code depends on IIO and is useless without OF, include it
    only if both are enabled, and set the dependencies accordingly. This
    is clearer, more simple and more correct.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Fixes: 9e8269de hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
    Cc: Doug Anderson <dianders@chromium.org>

commit 0132514588f3a0685861221058116a383bff4deb
Author: Jean Delvare <jdelvare@suse.de>
Date:   Sun May 25 17:23:07 2014 +0200

    hwmon: Document temp[1-*]_min_hyst sysfs attribute
    
    The temp[1-*]_min_hyst sysfs attribute is already implemented by 3
    hwmon drivers (adt7x10, lm77 and lm92) but was missing from the
    standard interface.
    
    Also add temp[1-*]_lcrit_hyst for consistency, even though no driver
    implement that one for the time being.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>

commit 2ff89d64f23e99da64995844ea42c83b0b4d58c6
Author: Markos Chandras <markos.chandras@imgtec.com>
Date:   Fri May 23 13:31:31 2014 +0100

    MIPS: malta: memory.c: Initialize the 'memsize' variable
    
    If the 'memsize' environmental variable is not set by the bootloader
    the 'memsize' variable is not initialized, leading to potential memory
    problems. This patch fixes the problem by setting the initial
    value to '0' to force the kernel to set a good default memory size.
    
    Cc: <stable@vger.kernel.org> # v3.15+
    Reported-by: Matheus Almeida <Matheus.Almeida@imgtec.com>
    Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
    Cc: linux-mips@linux-mips.org
    Cc: Markos Chandras <markos.chandras@imgtec.com>
    Cc: stable@vger.kernel.org
    Patchwork: https://patchwork.linux-mips.org/patch/6984/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 721a9205396c4ef2a811dd665ec2a232163b583d
Author: Markos Chandras <markos.chandras@imgtec.com>
Date:   Wed May 21 12:35:00 2014 +0100

    MIPS: Fix typo when reporting cache and ftlb errors for ImgTec cores
    
    Introduced by the following two commits:
    75b5b5e0a262790fa11043fe45700499c7e3d818
    "MIPS: Add support for FTLBs"
    6de20451857ed14a4eecc28d08f6de5925d1cf96
    "MIPS: Add printing of ES bit for Imgtec cores when cache error occurs"
    
    Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
    Reported-by: Matheus Almeida <Matheus.Almeida@imgtec.com>
    Cc: linux-mips@linux-mips.org
    Cc: Markos Chandras <markos.chandras@imgtec.com>
    Cc: stable@vger.kernel.org # v3.14+
    Patchwork: https://patchwork.linux-mips.org/patch/6980/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit defb79f08630f4d1944c75ad0070026d0f534fda
Author: Huacai Chen <chenhc@lemote.com>
Date:   Sun May 25 10:00:36 2014 +0800

    MIPS: Fix inconsistancy of __NR_Linux_syscalls value
    
    Originally, __NR_O32_Linux_syscalls, __NR_N32_Linux_syscalls and
    __NR_64_Linux_syscalls have the same values as __NR_Linux_syscalls in
    corresponding ABIs. But after commit 367f0b50e502d (MIPS: Wire up
    renameat2 syscall) they are not the same. I think this is incorrect and
    need a fix.
    
    Signed-off-by: Huacai Chen <chenhc@lemote.com>
    Cc: John Crispin <john@phrozen.org>
    Cc: Steven J. Hill <Steven.Hill@imgtec.com>
    Cc: Aurelien Jarno <aurelien@aurel32.net>
    Cc: linux-mips@linux-mips.org
    Cc: Fuxin Zhang <zhangfx@lemote.com>
    Cc: Zhangjin Wu <wuzhangjin@gmail.com>
    Patchwork: https://patchwork.linux-mips.org/patch/6987/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 8646224cdb945eca4293e2131e5be47930ce3e80
Merge: 7df566b 5ca2504
Author: David S. Miller <davem@davemloft.net>
Date:   Sat May 24 14:06:19 2014 -0400

    Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
    
    John W. Linville says:
    
    ====================
    pull request: wireless 2014-05-23
    
    I have two more fixes intended for the 3.15 stream...
    
    For the iwlwifi one, Emmanuel says:
    
    "A race has been discovered in the beacon filtering code. Since the
    fix is too big for 3.15, I disable here the feature."
    
    For the bluetooth one, Gustavo says:
    
    "This pull request contains a very important fix for 3.15. Here we fix the
    permissions of a debugfs file that would otherwise allow unauthorized users
    to write content to it."
    
    Please let me know if there are problems!
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 7df566bbdd0af0785542b89466a937e94257fcfb
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri May 23 19:37:21 2014 +0300

    qlcnic: info leak in qlcnic_dcb_peer_app_info()
    
    This function is called from dcbnl_build_peer_app().  The "info"
    struct isn't initialized at all so we disclose 2 bytes of uninitialized
    stack data.  We should clear it before passing it to the user.
    
    Fixes: 48365e485275 ('qlcnic: dcb: Add support for CEE Netlink interface.')
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 1d61367f522726e789aec68f7da1803c365fa4d3
Author: Bart De Schuymer <bdschuym@pandora.be>
Date:   Thu May 22 20:57:13 2014 +0200

    ebtables: Update MAINTAINERS entry.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 037430078fbbb956a9bd6ada00f528e9d1e4c92c
Merge: 1ee1cea c1f43dd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 16:52:15 2014 -0700

    Merge tag 'dmaengine-fixes-3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine
    
    Pull dmaengine fixes from Dan Williams:
     "Two fixes for -stable:
    
       - async_mult() sometimes maps less buffers than initially requested.
          We end up freeing dmaengine_unmap_data on an invalid pool.
    
       - mv_xor: register write ordering fix"
    
    * tag 'dmaengine-fixes-3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine:
      dmaengine: fix dmaengine_unmap failure
      dma: mv_xor: Flush descriptors before activating a channel

commit 1ee1ceafb572f1a925809168267a7962a4289de8
Merge: 5fa6a68 8ecc1ba
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 15:41:52 2014 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
    
    Pull sparc fixes from David Miller:
     "A small bunch of bug fixes, in particular:
    
       1) On older cpus we need a different chunk of virtual address space
          to map the huge page TSB.
    
       2) Missing memory barrier in Niagara2 memcpy.
    
       3) trinity showed some places where fault validation was
          unnecessarily loud on sparc64
    
       4) Some sysfs printf's need a type adjustment, from Toralf Förster"
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc:
      sparc64: fix format string mismatch in arch/sparc/kernel/sysfs.c
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.

commit 5fa6a683c061cd4662b436135cc76552dbc29a43
Merge: f02f79d b6ed549
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 15:29:43 2014 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Pull networking fixes from David Miller:
     "It looks like a sizeble collection but this is nearly 3 weeks of bug
      fixing while you were away.
    
       1) Fix crashes over IPSEC tunnels with NAT, the latter can reroute
          the packet through a non-IPSEC protected path and the code has to
          be able to handle SKBs attached to routes lacking an attached xfrm
          state.  From Steffen Klassert.
    
       2) Fix OOPSs in ipv4 and ipv6 ipsec layers for unsupported
          sub-protocols, also from Steffen Klassert.
    
       3) Set local_df on fragmented netfilter skbs otherwise we won't be
          able to forward successfully, from Florian Westphal.
    
       4) cdc_mbim ipv6 neighbour code does __vlan_find_dev_deep without
          holding RCU lock, from Bjorn Mork.
    
       5) local_df test in ip_may_fragment is inverted, from Florian
          Westphal.
    
       6) jme driver doesn't check for DMA mapping failures, from Neil
          Horman.
    
       7) qlogic driver doesn't calculate number of TX queues properly, from
          Shahed Shaikh.
    
       8) fib_info_cnt can drift irreversibly positive if we fail to
          allocate the fi->fib_metrics array, from Sergey Popovich.
    
       9) Fix use after free in ip6_route_me_harder(), also from Sergey
          Popovich.
    
      10) When SYSCTL is disabled, we don't handle local_port_range and
          ping_group_range defaults properly at all, from Cong Wang.
    
      11) Unaccelerated VLAN tagged frames improperly handled by cdc_mbim
          driver, fix from Bjorn Mork.
    
      12) cassini driver needs nested lock annotations for TX locking, from
          Emil Goode.
    
      13) On init error ipv6 VTI driver can unregister pernet ops twice,
          oops.  Fix from Mahtias Krause.
    
      14) If macvlan device is down, don't propagate IFF_ALLMULTI changes,
          from Peter Christensen.
    
      15) Missing NULL pointer check while parsing netlink config options in
          ip6_tnl_validate().  From Susant Sahani.
    
      16) Fix handling of neighbour entries during ipv6 router reachability
          probing, from Duan Jiong.
    
      17) x86 and s390 JIT address randomization has some address
          calculation bugs leading to crashes, from Alexei Starovoitov and
          Heiko Carstens.
    
      18) Clear up those uglies with nop patching and net_get_random_once(),
          from Hannes Frederic Sowa.
    
      19) Option length miscalculated in ip6_append_data(), fix also from
          Hannes Frederic Sowa.
    
      20) A while ago we fixed a race during device unregistry when a
          namespace went down, turns out there is a second place that needs
          similar protection.  From Cong Wang.
    
      21) In the new Altera TSE driver multicast filtering isn't working,
          disable it and just use promisc mode until the cause is found.
          From Vince Bridgers.
    
      22) When we disable router enabling in ipv6 we have to flush the
          cached routes explicitly, from Duan Jiong.
    
      23) NBMA tunnels should not cache routes on the tunnel object because
          the key is variable, from Timo Teräs.
    
      24) With stacked devices GRO information in skb->cb[] can be not setup
          properly, make sure it is in all code paths.  From Eric Dumazet.
    
      25) Really fix stacked vlan locking, multiple levels of nesting with
          intervening non-vlan devices are possible.  From Vlad Yasevich.
    
      26) Fallback ipip tunnel device's mtu is not setup properly, from
          Steffen Klassert.
    
      27) The packet scheduler's tcindex filter can crash because we
          structure copy objects with list_head's inside, oops.  From Cong
          Wang.
    
      28) Fix CHECKSUM_COMPLETE handling for ipv6 GRE tunnels, from Eric
          Dumazet.
    
      29) In some configurations 'itag' in __mkroute_input() can end up
          being used uninitialized because of how fib_validate_source()
          works.  Fix it by explitly initializing itag to zero like all the
          other fib_validate_source() callers do, from Li RongQing"
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net: (116 commits)
      batman: fix a bogus warning from batadv_is_on_batman_iface()
      ipv4: initialise the itag variable in __mkroute_input
      bonding: Send ALB learning packets using the right source
      bonding: Don't assume 802.1Q when sending alb learning packets.
      net: doc: Update references to skb->rxhash
      stmmac: Remove unbalanced clk_disable call
      ipv6: gro: fix CHECKSUM_COMPLETE support
      net_sched: fix an oops in tcindex filter
      can: peak_pci: prevent use after free at netdev removal
      ip_tunnel: Initialize the fallback device properly
      vlan: Fix build error wth vlan_get_encap_level()
      can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option
      MAINTAINERS: Pravin Shelar is Open vSwitch maintainer.
      bnx2x: Convert return 0 to return rc
      bonding: Fix alb mode to only use first level vlans.
      bonding: Fix stacked device detection in arp monitoring
      macvlan: Fix lockdep warnings with stacked macvlan devices
      vlan: Fix lockdep warning with stacked vlan devices.
      net: Allow for more then a single subclass for netif_addr_lock
      net: Find the nesting level of a given device by type.
      ...

commit 72b1c2c3a4de8891b06df18da95514d69eae65de
Author: Valentin Ilie <valentin.ilie@gmail.com>
Date:   Tue Apr 22 16:15:54 2014 +0300

    clk: st: Fix memory leak
    
    When it fails to allocate div, gate should be free'd before return
    
    Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>

commit 5644b4277fa1d8697479468ad404426a8644149b
Merge: 3aae97c 68d0e40
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri May 23 23:59:28 2014 +0200

    Merge tag 'samsung-fixes-2nd-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes
    
    Samsung-fixes-2 for 3.15
    - keep LD04 always on for exynos5250-arndale
    - fix spi interrupt numbers for exynos5420
    - fix ak8975 compatible for exynos4412-trats2
    
    * tag 'samsung-fixes-2nd-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung:
      ARM: dts: Keep LDO4 always ON for exynos5250-arndale board
      ARM: dts: Fix SPI interrupt numbers for exynos5420
      ARM: dts: fix incorrect ak8975 compatible for exynos4412-trats2 board
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit fe52e7505f8bf365d5ab0eeee19ababe406cbaaf
Author: Maxime COQUELIN <maxime.coquelin@st.com>
Date:   Wed May 7 18:48:52 2014 +0200

    clk: divider: Fix table round up function
    
    Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
    table dividers") introduces a regression in its _table_round_up function.
    
    When the divider passed to this function is greater than the max divider
    available in the table, this function returns table's max divider.
    Problem is that it causes an infinite loop in clk_divider_bestdiv() because
    _next_div() will never return a value greater than maxdiv.
    
    Instead of returning table's max divider, this patch returns INT_MAX.
    
    Reported-by: Fabio Estevam <festevam@gmail.com>
    Reported-by: Shawn Guo <shawn.guo@freescale.com>
    Tested-by: Fabio Estevam <festevam@gmail.com>
    Tested-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>

commit 3aae97c8b1dbefb23217d193e2818d1490651c95
Author: Alexandre Courbot <acourbot@nvidia.com>
Date:   Fri May 23 09:23:32 2014 +0900

    ARM: trusted_foundations: fix compile error on non-SMP
    
    The setup_max_cpus variable is only defined if CONFIG_SMP is set. Add
    a preprocessor condition to avoid the following compilation error if
    CONFIG_SMP is not set:
    
        arch/arm/include/asm/trusted_foundations.h: In function 'register_trusted_foundations':
        arch/arm/include/asm/trusted_foundations.h:57:2: error: 'setup_max_cpus' undeclared (first use in this function)
    
    Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
    Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Stephen Warren <swarren@nvidia.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 8ef42ddd9a53b73e6fc3934278710c27f80f324f
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Fri May 23 10:45:54 2014 -0400

    USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume
    
    Not all host controller drivers have bus-suspend and bus-resume
    methods.  When one doesn't, it will cause problems if runtime PM is
    enabled in the kernel.  The PM core will attempt to suspend the
    controller's root hub, the suspend will fail because there is no
    bus-suspend routine, and a -EBUSY error code will be returned to the
    PM core.  This will cause the suspend attempt to be repeated shortly
    thereafter, in a never-ending loop.
    
    Part of the problem is that the original error code -ENOENT gets
    changed to -EBUSY in usb_runtime_suspend(), on the grounds that the PM
    core will interpret -ENOENT as meaning that the root hub has gotten
    into a runtime-PM error state.  While this change is appropriate for
    real USB devices, it's not such a good idea for a root hub.  In fact,
    considering the root hub to be in a runtime-PM error state would not
    be far from the truth.  Therefore this patch updates
    usb_runtime_suspend() so that it adjusts error codes only for
    non-root-hub devices.
    
    Furthermore, the patch attempts to prevent the problem from occurring
    in the first place by not enabling runtime PM by default for root hubs
    whose host controller driver doesn't have bus_suspend and bus_resume
    methods.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Reported-by: Will Deacon <will.deacon@arm.com>
    Tested-by: Will Deacon <will.deacon@arm.com>
    CC: <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 28a821c306889b9f2c3fff49abedc9b2c743eb73
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Mon May 19 01:03:06 2014 +0100

    Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt
    
    This function is largely a duplicate of paste_selection() in
    drivers/tty/vt/selection.c, but with its own selection state.  The
    speakup selection mechanism should really be merged with vt.
    
    For now, apply the changes from 'TTY: vt, fix paste_selection ldisc
    handling', 'tty: Make ldisc input flow control concurrency-friendly',
    and 'tty: Fix unsafe vt paste_selection()'.
    
    References: https://bugs.debian.org/735202
    References: https://bugs.debian.org/744015
    Reported-by: Paul Gevers <elbrus@debian.org>
    Reported-and-tested-by: Jarek Czekalski <jarekczek@poczta.onet.pl>
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Cc: <stable@vger.kernel.org> # v3.8 but needs backporting for < 3.12
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d7500135802ca55b3f4e01a16544e8b34082f8c3
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Mon May 19 00:56:22 2014 +0100

    Staging: speakup: Move pasting into a work item
    
    Input is handled in softirq context, but when pasting we may
    need to sleep.  speakup_paste_selection() currently tries to
    bodge this by busy-waiting if in_atomic(), but that doesn't
    help because the ldisc may also sleep.
    
    For bonus breakage, speakup_paste_selection() changes the
    state of current, even though it's not running in process
    context.
    
    Move it into a work item and make sure to cancel it on exit.
    
    References: https://bugs.debian.org/735202
    References: https://bugs.debian.org/744015
    Reported-by: Paul Gevers <elbrus@debian.org>
    Reported-and-tested-by: Jarek Czekalski <jarekczek@poczta.onet.pl>
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Cc: stable@vger.kernel.org
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f02f79dbcb9c0326588c1cbe24b40887737e71d3
Merge: e6a32c3 2b4cfe6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 10:04:04 2014 -0700

    Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull scheduler fixes from Ingo Molnar:
     "The biggest commit is an irqtime accounting loop latency fix, the rest
      are misc fixes all over the place: deadline scheduling, docs, numa,
      balancer and a bad to-idle latency fix"
    
    * 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      sched/numa: Initialize newidle balance stats in sd_numa_init()
      sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in idle_balance()
      sched: Skip double execution of pick_next_task_fair()
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
      sched/deadline: Fix memory leak
      sched/deadline: Fix sched_yield() behavior
      sched: Sanitize irq accounting madness
      sched/docbook: Fix 'make htmldocs' warnings caused by missing description

commit e6a32c3ad1e78a33dda5ee9e9ca5704288d35fd4
Merge: 2b2d323 b69cf53
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 10:02:34 2014 -0700

    Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull perf fixes from Ingo Molnar:
     "The biggest changes are fixes for races that kept triggering Trinity
      crashes, plus liblockdep build fixes and smaller misc fixes.
    
      The liblockdep bits in perf/urgent are a pull mistake - they should
      have been in locking/urgent - but by the time I noticed other commits
      were added and testing was done :-/ Sorry about that"
    
    * 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()
      perf: Prevent false warning in perf_swevent_add
      perf: Limit perf_event_attr::sample_period to 63 bits
      tools/liblockdep: Remove all build files when doing make clean
      tools/liblockdep: Build liblockdep from tools/Makefile
      perf/x86/intel: Fix Silvermont's event constraints
      perf: Fix perf_event_init_context()
      perf: Fix race in removing an event

commit 2b2d323a31dc8b369a4c0e33705339399021fa83
Merge: fc3ac5c 77c01be
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 09:41:33 2014 -0700

    Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
    
    Pull drm radeon and nouveau fixes from Dave Airlie:
     "Fixes for the other big two.
    
      The radeon VCE one is large but it fixes some userspace triggerable
      issues, otherwise its blackscreens and oopses.
    
      Nouveau fixes a bleeding laptop panel issue when displayport is used
      sometimes"
    
    * 'drm-fixes' of git://people.freedesktop.org/~airlied/linux:
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)
      drm/radeon: avoid segfault on device open when accel is not working.
      drm/radeon: fix typo in finding PLL params
      drm/radeon: fix register typo on si
      drm/radeon: fix buffer placement under memory pressure v2
      drm/radeon: fix page directory update size estimation
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix DCE83 check for mullins
      drm/radeon: check VCE relocation buffer range v3
      drm/radeon: also try GART for CPU accessed buffers
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup
      drm/nvd9/therm: handle another kind of PWM fan

commit fc3ac5c75bae55ca6a070eb72038a94d4f130d8d
Merge: 9abd09a 0d9327a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 09:38:07 2014 -0700

    Merge branch 'akpm' (incoming from Andrew)
    
    Merge misc fixes from Andrew Morton:
     "9 fixes"
    
    * emailed patches from Andrew Morton <akpm@linux-foundation.org>:
      MAINTAINERS: add closing angle bracket to Vince Bridgers' email address
      Documentation: fix DOCBOOKS=... building
      ocfs2: fix double kmem_cache_destroy in dlm_init
      mm/memory-failure.c: fix memory leak by race between poison and unpoison
      wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR
      memcg: fix swapcache charge from kernel thread context
      mm: madvise: fix MADV_WILLNEED on shmem swapouts
      mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

commit 0d9327ab70038ac8c7af6e20456578ab80158f2d
Author: Tobias Klauser <tklauser@distanz.ch>
Date:   Thu May 22 11:54:24 2014 -0700

    MAINTAINERS: add closing angle bracket to Vince Bridgers' email address
    
    Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
    Cc: Vince Bridgers <vbridgers2013@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit e60cbeedc48d80689c249ab5dcc3c31ad0452dea
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu May 22 11:54:23 2014 -0700

    Documentation: fix DOCBOOKS=... building
    
    Prior to commit 4266129964b8 ("[media] DocBook: Move all media docbook
    stuff into its own directory") it was possible to build only a single
    (or more) book(s) by calling, for example
    
        make htmldocs DOCBOOKS=80211.xml
    
    This now fails:
    
        cp: target `.../Documentation/DocBook//media_api' is not a directory
    
    Ignore errors from that copy to make this possible again.
    
    Fixes: 4266129964b8 ("[media] DocBook: Move all media docbook stuff into its own directory")
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Acked-by: Randy Dunlap <rdunlap@xenotime.net>
    Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 66db6cfd49825f4e3462ceee3bcbb292d57da6fb
Author: Joseph Qi <joseph.qi@huawei.com>
Date:   Thu May 22 11:54:22 2014 -0700

    ocfs2: fix double kmem_cache_destroy in dlm_init
    
    In dlm_init, if create dlm_lockname_cache failed in
    dlm_init_master_caches, it will destroy dlm_lockres_cache which created
    before twice.  And this will cause system die when loading modules.
    
    Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
    Cc: Mark Fasheh <mfasheh@suse.com>
    Cc: Joel Becker <jlbec@evilplan.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 3e030ecc0fc7de10fd0da10c1c19939872a31717
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Thu May 22 11:54:21 2014 -0700

    mm/memory-failure.c: fix memory leak by race between poison and unpoison
    
    When a memory error happens on an in-use page or (free and in-use)
    hugepage, the victim page is isolated with its refcount set to one.
    
    When you try to unpoison it later, unpoison_memory() calls put_page()
    for it twice in order to bring the page back to free page pool (buddy or
    free hugepage list).  However, if another memory error occurs on the
    page which we are unpoisoning, memory_failure() returns without
    releasing the refcount which was incremented in the same call at first,
    which results in memory leak and unconsistent num_poisoned_pages
    statistics.  This patch fixes it.
    
    Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: <stable@vger.kernel.org>    [2.6.32+]
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit ad0f614e4723db8cead439cf414108cbf975b224
Author: Masatake YAMATO <yamato@redhat.com>
Date:   Thu May 22 11:54:20 2014 -0700

    wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR
    
    In commit ad86622b478e ("wait: swap EXIT_ZOMBIE and EXIT_DEAD to hide
    EXIT_TRACE from user-space") the order of task state definitions were
    changed: EXIT_DEAD and EXIT_ZOMBIE were swapped.  Though the charterers
    for the states in TASK_STATE_TO_CHAR_STR string were not updated.  This
    patch synchronizes the string to the order of definitions.
    
    Signed-off-by: Masatake YAMATO <yamato@redhat.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 6f6acb00514c10be35529402f36ad7a288f08c2e
Author: Michal Hocko <mhocko@suse.cz>
Date:   Thu May 22 11:54:19 2014 -0700

    memcg: fix swapcache charge from kernel thread context
    
    Commit 284f39afeaa4 ("mm: memcg: push !mm handling out to page cache
    charge function") explicitly checks for page cache charges without any
    mm context (from kernel thread context[1]).
    
    This seemed to be the only possible case where memory could be charged
    without mm context so commit 03583f1a631c ("memcg: remove unnecessary
    !mm check from try_get_mem_cgroup_from_mm()") removed the mm check from
    get_mem_cgroup_from_mm().  This however caused another NULL ptr
    dereference during early boot when loopback kernel thread splices to
    tmpfs as reported by Stephan Kulow:
    
      BUG: unable to handle kernel NULL pointer dereference at 0000000000000360
      IP: get_mem_cgroup_from_mm.isra.42+0x2b/0x60
      Oops: 0000 [#1] SMP
      Modules linked in: btrfs dm_multipath dm_mod scsi_dh multipath raid10 raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod parport_pc parport nls_utf8 isofs usb_storage iscsi_ibft iscsi_boot_sysfs arc4 ecb fan thermal nfs lockd fscache nls_iso8859_1 nls_cp437 sg st hid_generic usbhid af_packet sunrpc sr_mod cdrom ata_generic uhci_hcd virtio_net virtio_blk ehci_hcd usbcore ata_piix floppy processor button usb_common virtio_pci virtio_ring virtio edd squashfs loop ppa]
      CPU: 0 PID: 97 Comm: loop1 Not tainted 3.15.0-rc5-5-default #1
      Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
      Call Trace:
        __mem_cgroup_try_charge_swapin+0x40/0xe0
        mem_cgroup_charge_file+0x8b/0xd0
        shmem_getpage_gfp+0x66b/0x7b0
        shmem_file_splice_read+0x18f/0x430
        splice_direct_to_actor+0xa2/0x1c0
        do_lo_receive+0x5a/0x60 [loop]
        loop_thread+0x298/0x720 [loop]
        kthread+0xc6/0xe0
        ret_from_fork+0x7c/0xb0
    
    Also Branimir Maksimovic reported the following oops which is tiggered
    for the swapcache charge path from the accounting code for kernel threads:
    
      CPU: 1 PID: 160 Comm: kworker/u8:5 Tainted: P           OE 3.15.0-rc5-core2-custom #159
      Hardware name: System manufacturer System Product Name/MAXIMUSV GENE, BIOS 1903 08/19/2013
      task: ffff880404e349b0 ti: ffff88040486a000 task.ti: ffff88040486a000
      RIP: get_mem_cgroup_from_mm.isra.42+0x2b/0x60
      Call Trace:
        __mem_cgroup_try_charge_swapin+0x45/0xf0
        mem_cgroup_charge_file+0x9c/0xe0
        shmem_getpage_gfp+0x62c/0x770
        shmem_write_begin+0x38/0x40
        generic_perform_write+0xc5/0x1c0
        __generic_file_aio_write+0x1d1/0x3f0
        generic_file_aio_write+0x4f/0xc0
        do_sync_write+0x5a/0x90
        do_acct_process+0x4b1/0x550
        acct_process+0x6d/0xa0
        do_exit+0x827/0xa70
        kthread+0xc3/0xf0
    
    This patch fixes the issue by reintroducing mm check into
    get_mem_cgroup_from_mm.  We could do the same trick in
    __mem_cgroup_try_charge_swapin as we do for the regular page cache path
    but it is not worth troubles.  The check is not that expensive and it is
    better to have get_mem_cgroup_from_mm more robust.
    
    [1] - http://marc.info/?l=linux-mm&m=139463617808941&w=2
    
    Fixes: 03583f1a631c ("memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()")
    Reported-and-tested-by: Stephan Kulow <coolo@suse.com>
    Reported-by: Branimir Maksimovic <branimir.maksimovic@gmail.com>
    Signed-off-by: Michal Hocko <mhocko@suse.cz>
    Acked-by: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Hugh Dickins <hughd@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 55231e5c898c5c03c14194001e349f40f59bd300
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu May 22 11:54:17 2014 -0700

    mm: madvise: fix MADV_WILLNEED on shmem swapouts
    
    MADV_WILLNEED currently does not read swapped out shmem pages back in.
    
    Commit 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page
    cache radix trees") made find_get_page() filter exceptional radix tree
    entries but failed to convert all find_get_page() callers that WANT
    exceptional entries over to find_get_entry().  One of them is shmem swap
    readahead in madvise, which now skips over any swap-out records.
    
    Convert it to find_get_entry().
    
    Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Reported-by: Hugh Dickins <hughd@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 7fcbbaf18392f0b17c95e2f033c8ccf87eecde1d
Author: Jens Axboe <axboe@fb.com>
Date:   Thu May 22 11:54:16 2014 -0700

    mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT
    
    In some testing I ran today (some fio jobs that spread over two nodes),
    we end up spending 40% of the time in filemap_check_errors().  That
    smells fishy.  Looking further, this is basically what happens:
    
    blkdev_aio_read()
        generic_file_aio_read()
            filemap_write_and_wait_range()
                if (!mapping->nr_pages)
                    filemap_check_errors()
    
    and filemap_check_errors() always attempts two test_and_clear_bit() on
    the mapping flags, thus dirtying it for every single invocation.  The
    patch below tests each of these bits before clearing them, avoiding this
    issue.  In my test case (4-socket box), performance went from 1.7M IOPS
    to 4.0M IOPS.
    
    Signed-off-by: Jens Axboe <axboe@fb.com>
    Acked-by: Jeff Moyer <jmoyer@redhat.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit b985194c8c0a130ed155b71662e39f7eaea4876f
Author: Chen Yucong <slaoub@gmail.com>
Date:   Thu May 22 11:54:15 2014 -0700

    hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage
    
    For handling a free hugepage in memory failure, the race will happen if
    another thread hwpoisoned this hugepage concurrently.  So we need to
    check PageHWPoison instead of !PageHWPoison.
    
    If hwpoison_filter(p) returns true or a race happens, then we need to
    unlock_page(hpage).
    
    Signed-off-by: Chen Yucong <slaoub@gmail.com>
    Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Cc: <stable@vger.kernel.org>	[2.6.36+]
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit ffed54dced86723f352323f15789d9ad6bee25e1
Author: Ian Abbott <abbotti@mev.co.uk>
Date:   Mon May 19 11:29:04 2014 +0100

    staging: comedi: ni_daq_700: add mux settling delay
    
    I got a patch from the original author, Fred Brooks, to add a small
    settling delay after setting the AI channel multiplexor.  The lack of
    delay resulted in unstable or scrambled data on faster processors.
    
    Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
    Reported-by: Fred Brooks <nsaspook@nsaspook.com>
    Cc: <stable@vger.kernel.org> # 3.7.x - 3.15.x
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 478da752d0cf652fb3b5d82e2ece94e92724de88
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 24 13:59:53 2014 +0930

    speakup: fix incorrect perms on speakup_acntsa.c
    
    22c9bcad859d5c969289b3b37084a96c621f8f2c contained a bad
    substitution for ROOT_W => S_IRUSR|S_IRUGO instead of
    S_IWUSR|S_IRUGO.
    
    Fixes: 22c9bcad859d5c969289b3b37084a96c621f8f2c
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9abd09acd664c68f06242da191209d9c70df6953
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri May 23 09:23:51 2014 -0700

    parisc: 'renameat2()' doesn't need (or have) a separate compat system call
    
    The 'renameat2()' system call was incorrectly added as a ENTRY_COMP() in
    the parisc system call table by commit 18e480aa07f78 ("parisc: add
    renameat2 syscall").  That causes a link-time error due to there not
    being any compat version of that system call:
    
      arch/parisc/kernel/built-in.o: In function `sys_call_table':
      (.rodata+0xad0): undefined reference to `compat_sys_renameat2'
      make: *** [vmlinux] Error 1
    
    Easily fixed by marking the system call as being the same for compat as
    for native by using ENTRY_SAME() instead of ENTRY_COMP().
    
    Reported-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Miklos Szeredi <miklos@szeredi.hu>
    Acked-by: Helge Deller <deller@gmx.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 756abc8d6de06f0afc2121f69030f0d3f4f8177a
Merge: 85aea46 13984e9
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri May 23 18:13:15 2014 +0200

    Merge tag 'at91-fixes2' of git://github.com/at91linux/linux-at91 into fixes
    
    Second 3.15 fixes for AT91
    - two fixes concerning iio ADC triggers for at91sam9260 and at91sam9g20
      one for the "device" file, the other for the DT.
    
    * tag 'at91-fixes2' of git://github.com/at91linux/linux-at91:
      ARM: at91: sam9260: fix compilation issues
      ARM: at91/dt: sam9260: correct external trigger value
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 85aea469ef65091ddcfadb848af1ef7ef1d9cedd
Merge: 767bf9f d903bc9
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri May 23 18:11:01 2014 +0200

    Merge tag 'mvebu-fixes-3.15-2' of git://git.infradead.org/linux-mvebu into fixes
    
    mvebu fixes for v3.15 (incremental #2)
    
     - Armada 38x
        - fix PCIe dt nodes for handling more interfaces
    
     - mvebu
        - mvebu-soc-id: fix clock handling and PCIe interface disabling.
    
    * tag 'mvebu-fixes-3.15-2' of git://git.infradead.org/linux-mvebu:
      ARM: mvebu: fix definitions of PCIe interfaces on Armada 38x
      ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
      ARM: mvebu: mvebu-soc-id: add missing clk_put() call
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 5ca2504ea36df1da815029a9e9277c08540042eb
Merge: b6ed549 2c316e6
Author: John W. Linville <linville@tuxdriver.com>
Date:   Fri May 23 10:55:58 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem

commit 656f88ddf1ec3abf2cd20b8b4028c44e8e95f56d
Author: David Howells <dhowells@redhat.com>
Date:   Wed May 21 15:55:26 2014 +0100

    AFS: Pass an afs_call* to call->async_workfn() instead of a work_struct*
    
    call->async_workfn() can take an afs_call* arg rather than a work_struct* as
    the functions assigned there are now called from afs_async_workfn() which has
    to call container_of() anyway.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Reviewed-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
    Reviewed-by: Tejun Heo <tj@kernel.org>

commit 150a6b478982475c60fa25b7060ab990ece5483d
Author: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Date:   Wed May 21 14:58:26 2014 +0100

    AFS: Fix kafs module unloading
    
    At present, it is not possible to successfully unload the kafs module if there
    are outstanding async outgoing calls (those made with afs_make_call()).  This
    appears to be due to the changes introduced by:
    
    	commit 059499453a9abd1857d442b44da8b4c126dc72a8
    	Author: Tejun Heo <tj@kernel.org>
    	Date:   Fri Mar 7 10:24:50 2014 -0500
    	Subject: afs: don't use PREPARE_WORK
    
    which didn't go far enough.  The problem is due to:
    
     (1) The aforementioned commit introduced a separate handler function pointer
         in the call, call->async_workfn, in addition to the original workqueue
         item, call->async_work, for asynchronous operations because workqueues
         subsystem cannot handle the workqueue item pointer being changed whilst
         the item is queued or being processed.
    
     (2) afs_async_workfn() was introduced in that commit to be the callback for
         call->async_work.  Its sole purpose is to run whatever call->async_workfn
         points to.
    
     (3) call->async_workfn is only used from afs_async_workfn(), which is only
         set on async_work by afs_collect_incoming_call() - ie. for incoming
         calls.
    
     (4) call->async_workfn is *not* set by afs_make_call() when outgoing calls are
         made, and call->async_work is set afs_process_async_call() - and not
         afs_async_workfn().
    
     (5) afs_process_async_call() now changes call->async_workfn rather than
         call->async_work to point to afs_delete_async_call() to clean up, but this
         is only effective for incoming calls because call->async_work does not
         point to afs_async_workfn() for outgoing calls.
    
     (6) Because, for incoming calls, call->async_work remains pointing to
         afs_process_async_call() this results in an infinite loop.
    
    Instead, make the workqueue uniformly vector through call->async_workfn, via
    afs_async_workfn() and simply initialise call->async_workfn to point to
    afs_process_async_call() in afs_make_call().
    
    Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Reviewed-by: Tejun Heo <tj@kernel.org>

commit 6cf12869f5c1a837f18af5f8b2308fa243772735
Author: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Date:   Wed May 21 16:04:11 2014 +0100

    AFS: Part of afs_end_call() is identical to code elsewhere, so split it
    
    Split afs_end_call() into two pieces, one of which is identical to code in
    afs_process_async_call().  Replace the latter with a call to the first part of
    afs_end_call().
    
    Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
    Signed-off-by: David Howells <dhowells@redhat.com>

commit 77f07800cb456bed6e5c345e6e4e83e8eda62437
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri May 23 09:02:44 2014 +0200

    ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
    
    The recent Intel H97/Z97 chipsets need the similar setups like other
    Intel chipsets for snooping, etc.  Especially without snooping, the
    audio playback stutters or gets corrupted.  This fix patch just adds
    the corresponding PCI ID entry with the proper flags.
    
    Reported-and-tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit 41ca86e8502952116234fa558f4277092a5aaae9
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Thu May 22 23:19:00 2014 +0200

    MIPS: Fix branch emulation of branch likely instructions.
    
    Two issues:
    
      o For beql_op, beql_op, bne_op, bnel_op, blez_op, blezl_op, bgtz_op and
        bgtzl_op the wrong field was being checked for the instruction opcode.
      o For blez_op / blezl_op and bgtz_op / bgtzl_op the test was testing
        for the wrong opcode.
    
    This bug got introduced by d8d4e3ae0b5c179c0bfd3f0af5b352d13bea9cfa [MIPS
    Kprobes: Refactor branch emulation].
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
    Acked-by: Victor Kamensky <kamensky@cisco.com>

commit 6aa6caff30f5dcb9e55b03b9710c30b83750cae5
Author: Joe Lawrence <joe.lawrence@stratus.com>
Date:   Thu May 22 17:30:54 2014 -0400

    [SCSI] scsi_transport_sas: move bsg destructor into sas_rphy_remove
    
    The recent change in sysfs, bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
    "sysfs: make __sysfs_remove_dir() recursive" revealed an asymmetric
    rphy device creation/deletion sequence in scsi_transport_sas:
    
      modprobe mpt2sas
        sas_rphy_add
          device_add A               rphy->dev
          device_add B               sas_device transport class
          device_add C               sas_end_device transport class
          device_add D               bsg class
    
      rmmod mpt2sas
        sas_rphy_delete
          sas_rphy_remove
            device_del B
            device_del C
            device_del A
              sysfs_remove_group     recursive sysfs dir removal
          sas_rphy_free
            device_del D             warning
    
      where device A is the parent of B, C, and D.
    
    When sas_rphy_free tries to unregister the bsg request queue (device D
    above), the ensuing sysfs cleanup discovers that its sysfs group has
    already been removed and emits a warning, "sysfs group... not found for
    kobject 'end_device-X:0'".
    
    Since bsg creation is a side effect of sas_rphy_add, move its
    complementary removal call into sas_rphy_remove. This imposes the
    following tear-down order for the devices above: D, B, C, A.
    
    Note the sas_device and sas_end_device transport class devices (B and C
    above) are created and destroyed both via the list match traversal in
    attribute_container_device_trigger, so the order in which they are
    handled is fixed. This is fine as long as they are deleted before their
    parent device.
    
    Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
    Acked-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>

commit 7ea456436ff6563b6cf89d3254ae76a8ceab499b
Author: Alexey Charkov <alchark@gmail.com>
Date:   Tue Apr 29 23:42:00 2014 +0400

    pinctrl: vt8500: Ensure value reg is updated when setting direction
    
    Current code only touches the direction register when setting direction
    to output, which breaks logic like
    
    echo high > /sys/class/gpio/gpio0/direction
    
    which is expected to also set the value. This patch also adds a call
    to update the value register when setting direction to output.
    
    Signed-off-by: Alexey Charkov <alchark@gmail.com>
    Acked-by: Tony Prisk <linux@prisktech.co.nz>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

commit b6ed5498601df40489606dbc14a9c7011c16630b
Author: Cong Wang <cwang@twopensource.com>
Date:   Thu May 22 11:57:17 2014 -0700

    batman: fix a bogus warning from batadv_is_on_batman_iface()
    
    batman tries to search dev->iflink to check if it's a batman interface,
    but ->iflink could be 0, which is not a valid ifindex. It should just
    avoid iflink == 0 case.
    
    Reported-by: Jet Chen <jet.chen@intel.com>
    Tested-by: Jet Chen <jet.chen@intel.com>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Steffen Klassert <steffen.klassert@secunet.com>
    Cc: Antonio Quartulli <antonio@open-mesh.com>
    Cc: Marek Lindner <mareklindner@neomailbox.ch>
    Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
    Signed-off-by: Cong Wang <cwang@twopensource.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit fbdc0ad095c0a299e9abf5d8ac8f58374951149a
Author: Li RongQing <roy.qing.li@gmail.com>
Date:   Thu May 22 16:36:55 2014 +0800

    ipv4: initialise the itag variable in __mkroute_input
    
    the value of itag is a random value from stack, and may not be initiated by
    fib_validate_source, which called fib_combine_itag if CONFIG_IP_ROUTE_CLASSID
    is not set
    
    This will make the cached dst uncertainty
    
    Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
    Acked-by: Alexei Starovoitov <ast@plumgrid.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d0c21d43a5a12aaebb1e42e10cf78e6491fc9e5a
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Wed May 21 13:19:48 2014 -0400

    bonding: Send ALB learning packets using the right source
    
    ALB learning packets are currentlyalways sent using the slave mac
    address for all vlans configured on top of bond.   This is not always
    correct, as vlans may change their mac address.
    This patch introduced a concept of strict matching where the
    source of learning packets can either strictly match the address
    passed in, or it can determine a more correct address to use.
    
    There are 3 casese to consider:
      1) Switchover.  In this case, we have a new active slave and we need
         tell the switch about all addresses available on the slave.
      2) Monitor.  We'll periodically refresh learning info for all slaves.
         In this case, we refresh all addresses for current active, and just
         the slave address for other slaves.
      3) Teaching of disabled adddress.  This happens as part of the
         failover and in this case, we alwyas to use just the address
         provided.
    
    CC: Jay Vosburgh <j.vosburgh@gmail.com>
    CC: Veaceslav Falico <vfalico@gmail.com>
    CC: Andy Gospodarek <andy@greyhouse.net>
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d6b694c0b3f20c3ee54d29d4109fa1978d11a033
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Wed May 21 11:24:39 2014 -0400

    bonding: Don't assume 802.1Q when sending alb learning packets.
    
    TLB/ALB learning packets always assume 802.1Q vlan protocol, but
    that is no longer the case since we now have support for Q-in-Q
    on top of bonding.  Pass the vlan protocol to alb_send_lp_vid()
    so that the packets are properly tagged.
    
    CC: Jay Vosburgh <j.vosburgh@gmail.com>
    CC: Veaceslav Falico <vfalico@gmail.com>
    CC: Andy Gospodarek <andy@greyhouse.net>
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Acked-by: Veaceslav Falico <vfalico@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a3431acf742455ba738c9fb143802d4ad6937164
Merge: b0db5cd 0b5a958
Author: David S. Miller <davem@davemloft.net>
Date:   Thu May 22 15:41:20 2014 -0400

    Merge tag 'linux-can-fixes-for-3.15-20140521' of git://gitorious.org/linux-can/linux-can
    
    Marc Kleine-Budde says:
    
    ====================
    pull-request: can 2014-05-21
    
    this is a pull request for net/master, for the v3.15 release cycle, with a
    single patch. Christopher R. Baker found a use after free during unloading of
    the peak_pci driver. This is fixes in a patch by Stephane Grosjean.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit b0db5cdf3975134ca967e8b8370a8f0c91ce2329
Author: Tobias Klauser <tklauser@distanz.ch>
Date:   Tue May 20 13:52:13 2014 +0200

    net: doc: Update references to skb->rxhash
    
    In commit 61b905da33 ("net: Rename skb->rxhash to skb->hash"), skb->rxhash
    was renamed to skb->hash. Update references in Documentation
    accordingly.
    
    Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
    Acked-by: Daniel Borkmann <dborkman@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 89df20d951b310f3e33422554054ae6e58a3c7a9
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 20 11:38:18 2014 +0200

    stmmac: Remove unbalanced clk_disable call
    
    The stmmac_open call was calling clk_disable_unprepare on phy init
    failure, but it never calls clk_prepare_enable, this causes
    a WARN_ON in the clk framework to trigger if for some reason phy init
    fails.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
    Acked-by: Chen-Yu Tsai <wens@csie.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2c316e699fa40f2fc161ebb770b6e2845db4f3b0
Merge: 20b4f9c 7bacc78
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu May 22 13:53:27 2014 -0400

    Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes

commit acbf6d21ac81195071b97ebb114b0b37bd9fcc86
Author: David Jander <david@protonic.nl>
Date:   Thu May 8 12:06:25 2014 +0200

    clocksource: tcb_clksrc: Make tc_mode interrupt safe
    
    tc_mode() can be called from interrupt context and thus must not call
    clk_*prepare*() functions.
    
    Signed-off-by: David Jander <david@protonic.nl>
    Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
    Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

commit f214be50f317d78c47532d4ca8aa0ba5e79fc1ca
Author: Zhiwu Song <Zhiwu.Song@csr.com>
Date:   Wed May 7 14:46:44 2014 +0800

    clocksource: marco: Fix the affinity set for local timer of CPU1
    
    irqchip will reject the affinity set to CPUs which is not online
    yet. but in the CPU1 wakeup stage, OS only sets CPU1 to be online
    after local timer is set, so that causes the irq_set_affinity not
    work. this patch moves to irq_force_affinity() for the low level
    boot stage.
    
    Signed-off-by: Zhiwu Song <Zhiwu.Song@csr.com>
    Signed-off-by: Barry Song <Baohua.Song@csr.com>
    Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

commit 13984e9bb15528f70059bbbbda3f9028157eebf6
Author: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date:   Wed May 7 19:45:48 2014 +0200

    ARM: at91: sam9260: fix compilation issues
    
    Use the hexadecimal values for the triggers to match what is done for the device
    tree. This also fixes compilation issues as the defines have been moved
    elsewhere.
    
    Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

commit d903bc9ee9b67410d02923d98a8dd4ecf5a1bc69
Merge: b25bcf1 c2a3dd9
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Thu May 22 15:16:37 2014 +0000

    Merge branch 'mvebu/dt-fixes' into mvebu/fixes

commit c2a3dd9d2b30f65b4f4a62cb5a9b2c7131bd1ac4
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Tue May 20 16:43:28 2014 +0200

    ARM: mvebu: fix definitions of PCIe interfaces on Armada 38x
    
    Due a copy/paste error, the 'reg' values for the third PCIe interface
    on Armada 380, and the third and fourth PCIe interfaces on Armada 385
    are wrong: they are equal to the one of the second PCIe interface.
    
    This patch fixes this by using the appropriate 'reg' values for those
    PCIe interfaces.
    
    Without this fix, the third and fourth PCIe interfaces are unusable on
    those platforms.
    
    Reported-by: Nadav Haklai <nadavh@marvell.com>
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1400597008-4148-1-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: 0d3d96ab0059 ("ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs")
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit dc93f7b68a039fe7d918613163b1cdd21b279ec5
Author: Huacai Chen <chenhc@lemote.com>
Date:   Wed May 21 10:49:19 2014 +0800

    MIPS: Fix a typo error in AUDIT_ARCH definition
    
    Missing a "|" in AUDIT_ARCH_MIPSEL64N32 macro definition.
    
    Signed-off-by: Huacai Chen <chenhc@lemote.com>
    Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
    Cc: John Crispin <john@phrozen.org>
    Cc: Steven J. Hill <Steven.Hill@imgtec.com>
    Cc: Aurelien Jarno <aurelien@aurel32.net>
    Cc: linux-mips@linux-mips.org
    Cc: Fuxin Zhang <zhangfx@lemote.com>
    Cc: Zhangjin Wu <wuzhangjin@gmail.com>
    Patchwork: https://patchwork.linux-mips.org/patch/6978/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 6acbfb96976fc3350e30d964acb1dbbdf876d55e
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri May 16 11:50:42 2014 +0800

    sched: Fix hotplug vs. set_cpus_allowed_ptr()
    
    Lai found that:
    
      WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x2d/0x4b()
      ...
      migration_cpu_stop+0x1d/0x22
    
    was caused by set_cpus_allowed_ptr() assuming that cpu_active_mask is
    always a sub-set of cpu_online_mask.
    
    This isn't true since 5fbd036b552f ("sched: Cleanup cpu_active madness").
    
    So set active and online at the same time to avoid this particular
    problem.
    
    Fixes: 5fbd036b552f ("sched: Cleanup cpu_active madness")
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Michael wang <wangyun@linux.vnet.ibm.com>
    Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
    Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    Cc: Toshi Kani <toshi.kani@hp.com>
    Link: http://lkml.kernel.org/r/53758B12.8060609@cn.fujitsu.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 4dac0b638310d2e92f6e19958b73d4c97c9734bb
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed May 14 16:04:26 2014 +0200

    sched/cpupri: Replace NR_CPUS arrays
    
    Tejun reported that his resume was failing due to order-3 allocations
    from sched_domain building.
    
    Replace the NR_CPUS arrays in there with a dynamically allocated
    array.
    
    Reported-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/n/tip-7cysnkw1gik45r864t1nkudh@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 944770ab54babaef29d9d1dc8189898b3ee8afcf
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed May 14 16:13:56 2014 +0200

    sched/deadline: Replace NR_CPUS arrays
    
    Tejun reported that his resume was failing due to order-3 allocations
    from sched_domain building.
    
    Replace the NR_CPUS arrays in there with a dynamically allocated
    array.
    
    Reported-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Juri Lelli <juri.lelli@gmail.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/n/tip-kat4gl1m5a6dwy6nzuqox45e@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit b0827819b0da4acfbc1df1e05edcf50efd07cbd1
Author: Juri Lelli <juri.lelli@gmail.com>
Date:   Tue May 13 14:11:31 2014 +0200

    sched/deadline: Restrict user params max value to 2^63 ns
    
    Michael Kerrisk noticed that creating SCHED_DEADLINE reservations
    with certain parameters (e.g, a runtime of something near 2^64 ns)
    can cause a system freeze for some amount of time.
    
    The problem is that in the interface we have
    
     u64 sched_runtime;
    
    while internally we need to have a signed runtime (to cope with
    budget overruns)
    
     s64 runtime;
    
    At the time we setup a new dl_entity we copy the first value in
    the second. The cast turns out with negative values when
    sched_runtime is too big, and this causes the scheduler to go crazy
    right from the start.
    
    Moreover, considering how we deal with deadlines wraparound
    
     (s64)(a - b) < 0
    
    we also have to restrict acceptable values for sched_{deadline,period}.
    
    This patch fixes the thing checking that user parameters are always
    below 2^63 ns (still large enough for everyone).
    
    It also rewrites other conditions that we check, since in
    __checkparam_dl we don't have to deal with deadline wraparounds
    and what we have now erroneously fails when the difference between
    values is too big.
    
    Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Suggested-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@vger.kernel.org>
    Cc: Dario Faggioli<raistlin@linux.it>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/20140513141131.20d944f81633ee937f256385@gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit ce5f7f8200ca2504f6f290044393d73ca314965a
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon May 12 22:50:34 2014 +0200

    sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE
    
    The way we read POSIX one should only call sched_getparam() when
    sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.
    
    Given that we currently return sched_param::sched_priority=0 for all
    others, extend the same behaviour to SCHED_DEADLINE.
    
    Requested-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: Dario Faggioli <raistlin@linux.it>
    Cc: linux-man <linux-man@vger.kernel.org>
    Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
    Cc: Juri Lelli <juri.lelli@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: <stable@vger.kernel.org>
    Link: http://lkml.kernel.org/r/20140512205034.GH13467@laptop.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit dbdb22754fde671dc93d2fae06f8be113d47f2fb
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri May 9 10:49:03 2014 +0200

    sched: Disallow sched_attr::sched_policy < 0
    
    The scheduler uses policy=-1 to preserve the current policy state to
    implement sys_sched_setparam(), this got exposed to userspace by
    accident through sys_sched_setattr(), cure this.
    
    Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: <stable@vger.kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/20140509085311.GJ30445@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 143cf23df25b7082cd706c3c53188e741e7881c3
Author: Michael Kerrisk <mtk.manpages@gmail.com>
Date:   Fri May 9 16:54:15 2014 +0200

    sched: Make sched_setattr() correctly return -EFBIG
    
    The documented[1] behavior of sched_attr() in the proposed man page text is:
    
        sched_attr::size must be set to the size of the structure, as in
        sizeof(struct sched_attr), if the provided structure is smaller
        than the kernel structure, any additional fields are assumed
        '0'. If the provided structure is larger than the kernel structure,
        the kernel verifies all additional fields are '0' if not the
        syscall will fail with -E2BIG.
    
    As currently implemented, sched_copy_attr() returns -EFBIG for
    for this case, but the logic in sys_sched_setattr() converts that
    error to -EFAULT. This patch fixes the behavior.
    
    [1] http://thread.gmane.org/gmane.linux.kernel/1615615/focus=1697760
    
    Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@vger.kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/536CEC17.9070903@gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 767bf9f00ec753a3bba653844d7b858b8720707f
Merge: d1d70e5 4b353a7
Author: Olof Johansson <olof@lixom.net>
Date:   Wed May 21 22:19:27 2014 -0700

    Merge tag 'omap-for-v3.15/fixes-v3-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes
    
    Pull "omap fixes for v3.15-rc cycle" from Tony Lindgren:
    
    Regression fixes for omaps for NAND, DMA, cpu_idle and audio.
    Also a minor one line fix for audio clock on 54xx.
    
    * tag 'omap-for-v3.15/fixes-v3-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap:
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled
      ARM: OMAP2+: Fix DMA hang after off-idle
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit d1d70e5dc2cfa9047bb935c41ba808ebb8135696
Author: Emil Goode <emilgoode@gmail.com>
Date:   Mon May 19 15:07:54 2014 +0800

    ARM: imx: fix error handling in ipu device registration
    
    If we fail to allocate struct platform_device pdev we
    dereference it after the goto label err.
    
    This bug was found using coccinelle.
    
    Fixes: afa77ef (ARM: mx3: dynamically allocate "ipu-core" devices)
    Signed-off-by: Emil Goode <emilgoode@gmail.com>
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 3bc4a87c03e75c88471450380cb194bf30ea4a87
Merge: 4b660a7 702b691
Author: Olof Johansson <olof@lixom.net>
Date:   Wed May 21 22:16:30 2014 -0700

    Merge tag 'samsung-fixes' of http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes
    
    Samsung fixes for 3.15 from Kukjin Kim:
    
    - Remove g2d_pd and mau_pd nodes on exynos5420.
      Since the power domains are linked to the CMU blocks,
      kernel panic happens during access clocks when the
      power domains are disabled. Now this is a best solution.
    - Enable HS-I2C on exynos5 by default
      MMC partition cannot be mounted for RFS without the
      enabling HS-I2C because regulators for MMC power are
      connected to HS-I2C bus.
    - Disable MDMA1 node on exynos5420
      When MDMA1 runs in secure mode it makes kernel fault,
      so need to disalbe it on exynos5420 by default instead
      of each board.
    - Fix the secondary CPU boot for exynos4212
    
    * tag 'samsung-fixes' of http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung:
      ARM: dts: Remove g2d_pd node for exynos5420
      ARM: dts: Remove mau_pd node for exynos5420
      ARM: exynos_defconfig: enable HS-I2C to fix for mmc partition mount
      ARM: dts: disable MDMA1 node for exynos5420
      ARM: EXYNOS: fix the secondary CPU boot of exynos4212
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 77c01bef72a5ce5cb24adae6066ed81a52004d30
Merge: 763b257 4f2f203
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu May 22 09:15:57 2014 +1000

    Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes
    
    radeon fixes, VCE one is big but does fix a userspace crash.
    
    * 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux:
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)
      drm/radeon: avoid segfault on device open when accel is not working.
      drm/radeon: fix typo in finding PLL params
      drm/radeon: fix register typo on si
      drm/radeon: fix buffer placement under memory pressure v2
      drm/radeon: fix page directory update size estimation
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix DCE83 check for mullins
      drm/radeon: check VCE relocation buffer range v3
      drm/radeon: also try GART for CPU accessed buffers

commit 763b2573cf59da8f906b9f2c8a2d437482761005
Merge: 4b660a7 0f1d360
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu May 22 09:14:50 2014 +1000

    Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
    
    fixes nasty panel bleeding bug.
    
    * 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6:
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup
      drm/nvd9/therm: handle another kind of PWM fan

commit 368b69a5b010cb00fc9ea04d588cff69af1a1359
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Wed May 14 16:23:13 2014 -0700

    x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET
    
    The oops can be triggered in qemu using -no-hpet (but not nohpet) by
    running a 32-bit program and reading a couple of pages before the vdso.
    This should send SIGBUS instead of OOPSing.
    
    The bug was introduced by:
    
    commit 7a59ed415f5b57469e22e41fc4188d5399e0b194
    Author: Stefani Seibold <stefani@seibold.net>
    Date:   Mon Mar 17 23:22:09 2014 +0100
    
        x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
    
    which is new in 3.15.
    
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Link: http://lkml.kernel.org/r/e99025d887d6670b6c4d81e6ccfeeb83770b21e9.1400109621.git.luto@amacapital.net
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

commit 4b660a7f5c8099d88d1a43d8ae138965112592c7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 06:42:02 2014 +0900

    Linux 3.15-rc6

commit 4de462ab63e23953fd05da511aeb460ae10cc726
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon May 19 21:56:34 2014 -0700

    ipv6: gro: fix CHECKSUM_COMPLETE support
    
    When GRE support was added in linux-3.14, CHECKSUM_COMPLETE handling
    broke on GRE+IPv6 because we did not update/use the appropriate csum :
    
    GRO layer is supposed to use/update NAPI_GRO_CB(skb)->csum instead of
    skb->csum
    
    Tested using a GRE tunnel and IPv6 traffic. GRO aggregation now happens
    at the first level (ethernet device) instead of being done in gre
    tunnel. Native IPv6+TCP is still properly aggregated.
    
    Fixes: bf5a755f5e918 ("net-gre-gro: Add GRE support to the GRO stack")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Jerry Chu <hkchu@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c1f43dd9c20d85e66c4d77e284f64ac114abe3f8
Author: Xuelin Shi <xuelin.shi@freescale.com>
Date:   Wed May 21 14:02:37 2014 -0700

    dmaengine: fix dmaengine_unmap failure
    
    The count which is used to get_unmap_data maybe not the same as the
    count computed in dmaengine_unmap which causes to free data in a
    wrong pool.
    
    This patch fixes this issue by keeping the map count with unmap_data
    structure and use this count to get the pool.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Xuelin Shi <xuelin.shi@freescale.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5a9a55bf9157d3490b0c8c4c81d4708602c26e07
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Wed May 21 14:02:35 2014 -0700

    dma: mv_xor: Flush descriptors before activating a channel
    
    We need to use writel() instead of writel_relaxed() when starting
    a channel, to ensure all the descriptors have been flushed before
    the activation.
    
    While at it, remove the unneeded read-modify-write and make the
    code simpler.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Lior Amsalem <alior@marvell.com>
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6538d625215f29671864649336645dea19214135
Merge: 11da37b 8050936
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 05:55:12 2014 +0900

    Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
    
    Pull two powerpc fixes from Ben Herrenschmidt:
     "Here are a couple of fixes for 3.15.  One from Anton fixes a nasty
      regression I introduced when trying to fix a loss of irq_work whose
      consequences is that we can completely lose timer interrupts on a
      CPU... not pretty.
    
      The other one is a change to our PCIe reset hook to use a firmware
      call instead of direct config space accesses to trigger a fundamental
      reset on the root port.  This is necessary so that the FW gets a
      chance to disable the link down error monitoring, which would
      otherwise trip and cause subsequent fatal EEH error"
    
    * 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc:
      powerpc: irq work racing with timer interrupt can result in timer interrupt hang
      powerpc/powernv: Reset root port in firmware

commit bf63ac73b3e132e6bf0c8798aba7b277c3316e19
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon May 19 12:15:49 2014 -0700

    net_sched: fix an oops in tcindex filter
    
    Kelly reported the following crash:
    
            IP: [<ffffffff817a993d>] tcf_action_exec+0x46/0x90
            PGD 3009067 PUD 300c067 PMD 11ff30067 PTE 800000011634b060
            Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
            CPU: 1 PID: 639 Comm: dhclient Not tainted 3.15.0-rc4+ #342
            Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
            task: ffff8801169ecd00 ti: ffff8800d21b8000 task.ti: ffff8800d21b8000
            RIP: 0010:[<ffffffff817a993d>]  [<ffffffff817a993d>] tcf_action_exec+0x46/0x90
            RSP: 0018:ffff8800d21b9b90  EFLAGS: 00010283
            RAX: 00000000ffffffff RBX: ffff88011634b8e8 RCX: ffff8800cf7133d8
            RDX: ffff88011634b900 RSI: ffff8800cf7133e0 RDI: ffff8800d210f840
            RBP: ffff8800d21b9bb0 R08: ffffffff8287bf60 R09: 0000000000000001
            R10: ffff8800d2b22b24 R11: 0000000000000001 R12: ffff8800d210f840
            R13: ffff8800d21b9c50 R14: ffff8800cf7133e0 R15: ffff8800cad433d8
            FS:  00007f49723e1840(0000) GS:ffff88011a800000(0000) knlGS:0000000000000000
            CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
            CR2: ffff88011634b8f0 CR3: 00000000ce469000 CR4: 00000000000006e0
            Stack:
             ffff8800d2170188 ffff8800d210f840 ffff8800d2171b90 0000000000000000
             ffff8800d21b9be8 ffffffff817c55bb ffff8800d21b9c50 ffff8800d2171b90
             ffff8800d210f840 ffff8800d21b0300 ffff8800d21b9c50 ffff8800d21b9c18
            Call Trace:
             [<ffffffff817c55bb>] tcindex_classify+0x88/0x9b
             [<ffffffff817a7f7d>] tc_classify_compat+0x3e/0x7b
             [<ffffffff817a7fdf>] tc_classify+0x25/0x9f
             [<ffffffff817b0e68>] htb_enqueue+0x55/0x27a
             [<ffffffff817b6c2e>] dsmark_enqueue+0x165/0x1a4
             [<ffffffff81775642>] __dev_queue_xmit+0x35e/0x536
             [<ffffffff8177582a>] dev_queue_xmit+0x10/0x12
             [<ffffffff818f8ecd>] packet_sendmsg+0xb26/0xb9a
             [<ffffffff810b1507>] ? __lock_acquire+0x3ae/0xdf3
             [<ffffffff8175cf08>] __sock_sendmsg_nosec+0x25/0x27
             [<ffffffff8175d916>] sock_aio_write+0xd0/0xe7
             [<ffffffff8117d6b8>] do_sync_write+0x59/0x78
             [<ffffffff8117d84d>] vfs_write+0xb5/0x10a
             [<ffffffff8117d96a>] SyS_write+0x49/0x7f
             [<ffffffff8198e212>] system_call_fastpath+0x16/0x1b
    
    This is because we memcpy struct tcindex_filter_result which contains
    struct tcf_exts, obviously struct list_head can not be simply copied.
    This is a regression introduced by commit 33be627159913b094bb578
    (net_sched: act: use standard struct list_head).
    
    It's not very easy to fix it as the code is a mess:
    
           if (old_r)
                   memcpy(&cr, r, sizeof(cr));
           else {
                   memset(&cr, 0, sizeof(cr));
                   tcf_exts_init(&cr.exts, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
           }
           ...
           tcf_exts_change(tp, &cr.exts, &e);
           ...
           memcpy(r, &cr, sizeof(cr));
    
    the above code should equal to:
    
            tcindex_filter_result_init(&cr);
            if (old_r)
                   cr.res = r->res;
            ...
            if (old_r)
                   tcf_exts_change(tp, &r->exts, &e);
            else
                   tcf_exts_change(tp, &cr.exts, &e);
            ...
            r->res = cr.res;
    
    after this change, since there is no need to copy struct tcf_exts.
    
    And it also fixes other places zero'ing struct's contains struct tcf_exts.
    
    Fixes: commit 33be627159913b0 (net_sched: act: use standard struct list_head)
    Reported-by: Kelly Anderson <kelly@xilka.com>
    Tested-by: Kelly Anderson <kelly@xilka.com>
    Cc: David S. Miller <davem@davemloft.net>
    Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 11da37b26301be772c289c5406aec347ad140bd6
Merge: 3062556 51a6025
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 05:40:13 2014 +0900

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
    
    Pull two btrfs fixes from Chris Mason:
     "This has two fixes that we've been testing for 3.16, but since both
      are safe and fix real bugs, it makes sense to send for 3.15 instead"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs:
      Btrfs: send, fix incorrect ref access when using extrefs
      Btrfs: fix EIO on reading file after ioctl clone works on it

commit 30625569031641eba1cd1f71148cf188500861a2
Merge: 5e9d9fc f140662
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 05:38:51 2014 +0900

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
    
    Pull two ceph fixes from Sage Weil:
     "The first patch fixes a problem when we have a page count of 0 for
      sendpage which is triggered by zfs.  The second fixes a bug in CRUSH
      that was resolved in the userland code a while back but fell through
      the cracks on the kernel side"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client:
      crush: decode and initialize chooseleaf_vary_r
      libceph: fix corruption when using page_count 0 page in rbd

commit 5e9d9fc4edd3f591e3cf76dd19a8b2a9c8d5cee1
Merge: 80932ec ee4eec4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 05:36:07 2014 +0900

    Merge tag 'xfs-for-linus-3.15-rc6' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs fixes from Dave Chinner:
     "Code inspection of the XFS error number sign translations found a
      bunch of issues, including returning incorrectly signed errors for
      some data integrity operations.
    
      These leak to userspace and result in applications not getting the
      errors correctly reported.  Hence they need fixing sooner rather than
      later.
    
      A couple of the bugs are in data integrity operations, a couple more
      are in the new COLLAPSE_RANGE code.  One of these came in through a
      recent ext4 merge and so I had to update the base tree to 3.15-rc5
      before fixing the issues"
    
    * tag 'xfs-for-linus-3.15-rc6' of git://oss.sgi.com/xfs/xfs:
      xfs: list_lru_init returns a negative error
      xfs: negate xfs_icsb_init_counters error value
      xfs: negate mount workqueue init error value
      xfs: fix wrong err sign on xfs_set_acl()
      xfs: fix wrong errno from xfs_initxattrs
      xfs: correct error sign on COLLAPSE_RANGE errors
      xfs: xfs_commit_metadata returns wrong errno
      xfs: fix incorrect error sign in xfs_file_aio_read
      xfs: xfs_dir_fsync() returns positive errno

commit 80932ec1c0da97674417b35ac5aec31732993d8d
Merge: 989d216 68b7752
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 05:34:57 2014 +0900

    Merge branch 'renameat2' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs
    
    Pull renameat2 arch support from Miklos Szeredi:
     "I've collected architecture patches for the renameat2 syscall that
      maintainers acked and/or asked me to queue.
    
      This adds architecture support for the renameat2 syscall to m68k,
      parisc, ia64 and through asm-generic to arc, arm64, c6x, hexagon,
      metag, openrisc, score, tile, unicore32"
    
    * 'renameat2' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs:
      scripts/checksyscalls.sh: Make renameat optional
      asm-generic: Add renameat2 syscall
      ia64: add renameat2 syscall
      parisc: add renameat2 syscall
      m68k: add renameat2 syscall

commit 8ecc1bad4c9b485ceb47182d282980d0b0fe20ac
Author: Toralf Förster <toralf.foerster@gmx.de>
Date:   Mon May 19 10:26:31 2014 +0200

    sparc64: fix format string mismatch in arch/sparc/kernel/sysfs.c
    
    found by cppcheck
    
    Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 989d216f86bbef47059c10aca77be9f56305a7ec
Merge: 677d1bb 2c16c9f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 04:29:39 2014 +0900

    Merge tag 'iommu-fixes-v3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu
    
    Pull iommu fixes from Joerg Roedel:
     "Three fixes for the AMD IOMMU driver:
       - fix a locking issue around get_user_pages()
       - fix two issues with device aliasing and exclusion range handling"
    
    * tag 'iommu-fixes-v3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu:
      iommu/amd: fix enabling exclusion range for an exact device
      iommu/amd: Take mmap_sem when calling get_user_pages
      iommu/amd: Fix interrupt remapping for aliased devices

commit 677d1bb0cbcfc43d10e95ab0c28b9045a1de7b5b
Merge: f6ce579 629c27a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 04:28:21 2014 +0900

    Merge tag 'stable/for-linus-3.15-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft
    
    Pull iscsi_ibft fix from Konrad Rzeszutek Wilk:
     "Fix iBFT regression on Broadcom NICs introduced in 3.2"
    
    * tag 'stable/for-linus-3.15-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft:
      iscsi_ibft: Fix finding Broadcom specific ibft sign

commit f6ce579d91029123e4b83137d7bf5bc487b7dfb9
Merge: fba69f0 3c90c55
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 22 04:26:23 2014 +0900

    Merge tag 'renesas-sh-drivers-for-v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas
    
    Pull SH driver fix from Simon Horman:
     "Compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
    
      This resolves a regression introduced in v3.14 by commit bf98c1eac1d4
      ("ARM: Rename ARCH_SHMOBILE to ARCH_SHMOBILE_LEGACY")"
    
    * tag 'renesas-sh-drivers-for-v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas:
      drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI

commit 27b11428b7de097c42f205beabb1764f4365443b
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Thu May 8 11:19:41 2014 -0400

    nfsd4: warn on finding lockowner without stateid's
    
    The current code assumes a one-to-one lockowner<->lock stateid
    correspondance.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit a1b8ff4c97b4375d21b6d6c45d75877303f61b3b
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Tue May 20 15:55:21 2014 -0400

    nfsd4: remove lockowner when removing lock stateid
    
    The nfsv4 state code has always assumed a one-to-one correspondance
    between lock stateid's and lockowners even if it appears not to in some
    places.
    
    We may actually change that, but for now when FREE_STATEID releases a
    lock stateid it also needs to release the parent lockowner.
    
    Symptoms were a subsequent LOCK crashing in find_lockowner_str when it
    calls same_lockowner_ino on a lockowner that unexpectedly has an empty
    so_stateids list.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit 6c67c7c38cf32c2a9cbccb6b21aadf61a85fbfb4
Author: David Howells <dhowells@redhat.com>
Date:   Wed May 21 14:48:05 2014 +0100

    AFS: Fix cache manager service handlers
    
    Fix the cache manager RPC service handlers.  The afs_send_empty_reply() and
    afs_send_simple_reply() functions:
    
     (a) Kill the call and free up the buffers associated with it if they fail.
    
     (b) Return with call intact if it they succeed.
    
    However, none of the callers actually check the result or clean up if
    successful - and may use the now non-existent data if it fails.
    
    This was detected by Dan Carpenter using a static checker:
    
    	The patch 08e0e7c82eea: "[AF_RXRPC]: Make the in-kernel AFS
    	filesystem use AF_RXRPC." from Apr 26, 2007, leads to the following
    	static checker warning:
    	"fs/afs/cmservice.c:155 SRXAFSCB_CallBack()
    		 warn: 'call' was already freed."
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

commit e5eb925a1804c4a52994ba57f4f68ee7a9132905
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Wed May 21 11:42:10 2014 +0200

    MIPS: Change type of asid_cache to unsigned long
    
    asid_cache must be unsigned long otherwise on 64 bit systems it will
    become 0 if the value in get_new_mmu_context() reaches 0xffffffff and
    in the end the assumption of ASID_FIRST_VERSION is not true anymore
    thus leads to more dangerous things.
    
    Initial patch by Yong Zhang <yong.zhang@windriver.com>
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Reported-by: libin <huawei.libin@huawei.com>

commit fba69f042ad99f68c0268ef1c012f3199f898fac
Merge: 84e12d9 97d9d23
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 19:01:08 2014 +0900

    Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
    
    Pull media fixes from Mauro Carvalho Chehab:
     "Most of the changes are drivers fixes (rtl28xuu, fc2580, ov7670,
      davinci, gspca, s5p-fimc and s5c73m3).
    
      There is also a compat32 fix and one infoleak fixup at the media
      controller"
    
    * 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media:
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] media-device: fix infoleak in ioctl media_enum_entities()
      [media] fc2580: fix tuning failure on 32-bit arch
      [media] Prefer gspca_sonixb over sn9c102 for all devices
      [media] media: davinci: vpfe: make sure all the buffers unmapped and released
      [media] staging: media: davinci: vpfe: make sure all the buffers are released
      [media] media: davinci: vpbe_display: fix releasing of active buffers
      [media] media: davinci: vpif_display: fix releasing of active buffers
      [media] media: davinci: vpif_capture: fix releasing of active buffers
      [media] s5p-fimc: Fix YUV422P depth
      [media] s5c73m3: Add missing rename of v4l2_of_get_next_endpoint() function
      [media] rtl28xxu: silence error log about disabled rtl2832_sdr module
      [media] rtl28xxu: do not hard depend on staging SDR module

commit 84e12d992a54bc64590989b50d292e510a7d73cd
Merge: 439c610 bb4e506
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 19:00:09 2014 +0900

    Merge tag 'staging-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
    
    Pull staging driver fixes from Greg KH:
     "Here are five staging driver fixes for 3.15-rc6 that resolve some
      reported issues.  They are for the imx and rtl8723au drivers"
    
    * tag 'staging-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging:
      staging: rtl8723au: Do not reset wdev->iftype in netdev_close()
      staging: rtl8723au: Use correct pipe type for USB interrupts
      imx-drm: imx-tve: correct DDC property name to 'ddc-i2c-bus'
      imx-drm: imx-drm-core: skip components whose parent device is disabled
      imx-drm: imx-drm-core: fix imx_drm_encoder_get_mux_id

commit 439c6109922c8faa920c9b8680d63937189d6915
Merge: 957cf25 f5c16f2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:59:25 2014 +0900

    Merge tag 'driver-core-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
    
    Pull driver core fixes from Greg KH:
     "Here are two driver core (well, sysfs) fixes for 3.15-rc6 that resolve
      some reported issues and a regression from 3.13"
    
    * tag 'driver-core-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core:
      sysfs: make sure read buffer is zeroed
      kernfs, sysfs, cgroup: restrict extra perm check on open to sysfs

commit 957cf2582adf2a2164bbbd87036138221c5c118a
Merge: b84293b d0b4cc4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:57:25 2014 +0900

    Merge tag 'pci-v3.15-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
    
    Pull PCI fixes from Bjorn Helgaas:
     "These are fixes for an SHPCHP hotplug regression, a "wait for pending
      transaction" problem (used in device reset paths), and an email
      address update.
    
      PCI device hotplug:
        - Fix SHPCHP bus speed mismatch issue (Marcel Apfelbaum)
    
      Miscellaneous:
        - Fix pci_wait_for_pending_transaction() (Gavin Shan)
        - Update email address (Ben Hutchings)"
    
    * tag 'pci-v3.15-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci:
      PCI: Wrong register used to check pending traffic
      PCI: shpchp: Check bridge's secondary (not primary) bus speed
      PCI: Update my email address

commit b84293b23efd8c98416624866389854fd5dc0020
Merge: 026d68b f9c6d49
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:56:35 2014 +0900

    Merge tag 'random_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random
    
    Pull /dev/random fix from Ted Ts'o:
     "This fixes a BUG_ON-causing regression that was introduced during the
      last merge window"
    
    * tag 'random_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random:
      random: fix BUG_ON caused by accounting simplification

commit 026d68be45a217f65f1617d08271f6838bfc07d7
Merge: b2e3432 d2c834a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:55:17 2014 +0900

    Merge tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mike.turquette/linux
    
    Pull clock framework fixes from Mike Turquette:
     "Clock framework and driver fixes, all of which fix user-visible
      regressions.
    
      As usual most fixes are for platform-specific clock drivers, but there
      are also two fixes to the clk core after recent changes to the way
      that clock unregistration is handled"
    
    * tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mike.turquette/linux:
      clk: tegra: Fix wrong value written to PLLE_AUX
      clk: shmobile: clk-mstp: change to using clock-indices
      clk: Fix slab corruption in clk_unregister()
      clk: Fix double free due to devm_clk_register()
      clk: socfpga: fix clock driver for 3.15
      clk: divider: Fix best div calculation for power-of-two and table dividers
      clk: bcm281xx: don't use unnamed structs or unions

commit b2e3432af1546a9f44a8278a8a91abfbd439259e
Merge: 081069f fd30c37
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:53:55 2014 +0900

    Merge tag 'spi-v3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
    
    Pull spi fixes from Mark Brown:
     "A few core fixes around outlying cases here, nothing that should
      affect most users but useful fixes.  The diffstat is rather larger
      than one might hope due some simple code motion in the fix for
      !CONFIG_DMA, the actual meaningful change is much smaller.
    
       - Fix handling of unsupported dual and quad mode support on slave
         registration so that drivers that can degrade gracefully do so,
         preventing regressions for drivers this is added.
       - Fix build in !CONFIG_DMA cases following addition of generic DMA
         mapping support.
       - Fix error handling for queue creation which due to wider kernel
         changes can be triggered more easily.
       - A couple of driver specific fixes"
    
    * tag 'spi-v3.15-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi:
      spi/pxa2xx: Prevent DMA from transferring too many bytes
      spi: core: Don't destroy master queue if we fail to create it
      spi: qup: Fix return value checking for pm_runtime_get_sync()
      spi: core: Protect DMA code by #ifdef CONFIG_HAS_DMA
      spi: core: Ignore unsupported Dual/Quad Transfer Mode bits

commit 081069ff817ea7434016c482156e1ef0a7ffb4f3
Merge: 06eb4cc 99e4b98
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:53:13 2014 +0900

    Merge tag 'gpio-v3.15-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
    
    Pull GPIO fixes from Linus Walleij:
     - fix a null pointer bug in the ICH6 chipset driver
     - fix device tree registration for the mcp23s08 driver
    
    * tag 'gpio-v3.15-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio:
      gpio: mcp23s08: Bug fix of SPI device tree registration.
      gpio: ich: set regs and reglen for i3100 and ich6 chipset

commit 7bacc782270ff7db3b9f29fa5d24ad2ee1e8e81d
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun May 18 19:05:23 2014 +0300

    iwlwifi: mvm: disable beacon filtering
    
    This feature has been causing trouble - disable it for now.
    
    Cc: <stable@vger.kernel.org> [3.13+]
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 06eb4cc2e7ad1b32a3b2580eff772c29b53a2cc6
Merge: 6ab9028 36e9d2e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:36:40 2014 +0900

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
    
    Pull more cgroup fixes from Tejun Heo:
     "Three more patches to fix cgroup_freezer breakage due to the recent
      cgroup internal locking changes - an operation cgroup_freezer was
      using now requires sleepable context and cgroup_freezer was invoking
      that while holding a spin lock.  cgroup_freezer was using an overly
      elaborate hierarchical locking scheme.
    
      While it's possible to convert the hierarchical spinlocks directly to
      mutexes, this patch simplifies the overall locking so that it uses a
      global mutex.  This has the added benefit of avoiding iterating
      potentially huge number of tasks under a spinlock.  While the patch is
      on the larger side in the devel cycle, the changes made are mostly
      straight-forward and the locking logic is a lot simpler afterwards"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup:
      cgroup: fix rcu_read_lock() leak in update_if_frozen()
      cgroup_freezer: replace freezer->lock with freezer_mutex
      cgroup: introduce task_css_is_root()

commit 6ab9028d00da2ed34f46a72fa3271b04a402f1e1
Merge: 1f5518b 3685f251
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:35:42 2014 +0900

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
    
    Pull libata fixes from Tejun Heo:
     "Mostly device-specific fixes.  The only thing which isn't is the fix
      for zpodd oops-on-detach bug"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata:
      ahci: imx: PLL clock needs 100us to settle down
      ata: pata_at91 only works on sam9
      libata: clean up ZPODD when a port is detached
      ahci: imx: software workaround for phy reset issue in resume
      ahci: imx: add namespace for register enums
      ahci: disable DEVSLP for Intel Valleyview

commit 1f5518b4e7febc2a1026fba2ff311ba54be1abc4
Merge: a7aa96a 3901c11
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:34:35 2014 +0900

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
    
    Pull crypto fixes from Herbert Xu:
     "This fixes a NULL pointer dereference on allocation failure in caam,
      as well as a regression in the ctr mode on s390 that was added with
      the recent concurrency fixes"
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6:
      crypto: s390 - fix aes,des ctr mode concurrency finding.
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

commit a7aa96a92eff3c4b2c7df8c8535691a5a487207d
Merge: b140027 1e1110c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:03:14 2014 +0900

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
    
    Pull scsi target fixes from Nicholas Bellinger:
     "This series include:
    
       - Close race between iser-target network portal shutdown + accepting
         new connection logins (sagi)
       - Fix free-after-use regression in tcm_fc post conversion to
         percpu-ida pre-allocation (nab)
       - Explicitly disable Immediate + Unsolicited Data for iser-target
         connections when T10-PI is enabled (sagi + nab)
       - Allow pi_prot_type + emulate_write_cache attributes to be set to
         zero regardless of backend support (andy)
       - memory leak fix (mikulas)"
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending:
      target: fix memory leak on XCOPY
      target: Don't allow setting WC emulation if device doesn't support
      iscsi-target: Disable Immediate + Unsolicited Data with ISER Protection
      tcm_fc: Fix free-after-use regression in ft_free_cmd
      iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
      Target/iscsi,iser: Avoid accepting transport connections during stop stage
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
      Target/iser: Fix wrong connection requests list addition
      target: Allow non-supporting backends to set pi_prot_type to 0

commit b14002761c01dcd2e416ad6d922bd0acf21e4a9d
Merge: 478c7cf d765396
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 18:02:12 2014 +0900

    Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
    
    Pull i2c fixes from Wolfram Sang:
     "Some I2C bugfixes for 3.15.  Typical stuff, I'd say"
    
    * 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux:
      i2c: rcar: bail out on zero length transfers
      i2c: qup: Fix pm_runtime_get_sync usage
      i2c: s3c2410: resume race fix
      i2c: nomadik: Don't use IS_ERR for devm_ioremap
      i2c: designware: Mask all interrupts during i2c controller enable

commit 478c7cf7a8ff7ad587bd76f8ce9cfeede0df45fb
Merge: 23de4a7 658a0f4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 17:58:34 2014 +0900

    Merge tag 'pm+acpi-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
    
    Pull ACPI and power management fixes from Rafael Wysocki:
     "Still fixing regressions (partly by reverting commits that broke
      things for people), fixing other stable-candidate bugs and adding some
      blacklist entries for ACPI video and _OSI.
    
      Two ACPICA regression fixes (one recent and one for a 3.14 commit), a
      fix for an ACPI-related regression in TPM (introduced in 3.14), a
      revert of the ACPI AC driver conversion in 3.13 that went wrong for an
      unknown reason, two reverts of commits that attempted to remove an old
      user space interface in /proc and broke some utilities, in 3.13 too, a
      fix for a CPU hotplug bug in the ACPI processor driver (stable
      material), two (stable candidate) fixes for intel_pstate and a few new
      blacklist entries, mostly for systems that shipped with Windows 8.
    
      Specifics:
    
       - ACPICA fix for a stale pointer access introduced by a recent commit
         in the XSDT validation code from Lv Zheng.
    
       - ACPICA fix for the default value of the command line switch to
         favor 32-bit FADT addresses (in case there's a conflict between a
         64-bit and a 32-bit address).  The previous default was that the
         32-bit version would take precedence and we tried to change it to
         the other way around and it didn't work.  From Lv Zheng.
    
       - A TPM commit related to ACPI _DSM in 3.14 caused the driver to
         refuse to load if a specific _DSM was missing and that broke resume
         from system suspend on Chromebooks that require the TPM hardware to
         be restored to a working state during resume by the OS.  Restore
         the old behavior to load the driver if the _DSM in question is not
         present, but prevent it from using the feature the _DSM is for.
    
       - ACPI AC driver conversion in 3.13 broke thermal management on at
         least one machine and has to be reverted.  From Guenter Roeck.
    
       - Two reverts of 3.13 commits that attempted to remove the old ACPI
         battery interface in /proc, but turned out to break some utilities
         still using that interface.  From Lan Tianyu.
    
       - ACPI processor driver fix to prevent acpi_processor_add() from
         modifying the CPU device's .offline field which leads to breakage
         if the initial online of the CPU fails.  From Igor Mammedov.
    
       - Two intel_pstate fixes, one to take a BayTrail documentation update
         into account and one to avoid forcing the maximum P-state on init
         which causes CPU PM trouble on systems with P-states coordination
         when one of the CPU cores is initialized after an offline/online
         cycle triggered by user space.  Both stable candidates, from Dirk
         Brandewie.
    
       - Fix for the ACPI video DMI blacklist entry for Dell Inspiron 7520
         from Aaron Lu.
    
       - Two new ACPI video blacklist entries for machines shipping with
         Win8 that need to use native backlight so that it can be controlled
         in a usual way (which doesn't work otherwise due bugs in the ACPI
         tables) from Hans de Goede.
    
       - Two ACPI _OSI quirks for systems that need them to work correctly
         with Linux from Edward Lin and Hans de Goede"
    
    * tag 'pm+acpi-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm:
      ACPI / video: Revert native brightness quirk for ThinkPad T530
      intel_pstate: remove setting P state to MAX on init
      ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.
      ACPI / video: correct DMI tag for Dell Inspiron 7520
      intel_pstate: Set turbo VID for BayTrail
      ACPI / TPM: Fix resume regression on Chromebooks
      ACPI / proc: Do not say when /proc interfaces will be deleted in Kconfig
      ACPI / processor: do not mark present at boot but not onlined CPU as onlined
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      ACPI: blacklist win8 OSI for Dell Inspiron 7737
      ACPI / video: Add use_native_backlight quirks for more systems
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
      ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().

commit 23de4a7af7bc3d687f783a612b8e824865b7e6ce
Merge: 31a3fca 4cdd2ad
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 17:57:31 2014 +0900

    Merge tag 'dm-3.15-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
    
    Pull device mapper fixes from Mike Snitzer:
     "A dm-crypt fix for a cpu hotplug crash that switches from using
      per-cpu data to a mempool allocation (which offers allocation with cpu
      locality, and there is no inter-cpu communication on slab allocation).
    
      A couple dm-thinp stable fixes to address "out-of-data-space" issues.
    
      A dm-multipath fix for a LOCKDEP warning introduced in 3.15-rc1"
    
    * tag 'dm-3.15-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm:
      dm mpath: fix lock order inconsistency in multipath_ioctl
      dm thin: add timeout to stop out-of-data-space mode holding IO forever
      dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

commit 31a3fcab118f169613777c913f6a35b1ab138591
Merge: 60b5f90 dfc44f8
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 21 17:54:55 2014 +0900

    Merge tag 'dt-for-linus' of git://git.secretlab.ca/git/linux
    
    Pull device tree fixes from Grant Likely:
     "Drivercore bugfixes for v3.15
    
      This branch contains bug fixes important to get into v3.15.  There is
      a fix for modifying properties seen during early boot, a fix for an
      incorrect prototype when CONFIG_OF=n, and a couple of corrections to
      device tree memory nodes on a few platforms"
    
    * tag 'dt-for-linus' of git://git.secretlab.ca/git/linux:
      mips: dts: Fix missing device_type="memory" property in memory nodes
      arm: dts: Fix missing device_type="memory" for ste-ccu8540
      of: fix CONFIG_OF=n prototype of of_node_full_name()
      of: make of_update_property() usable earlier in the boot process

commit 0b5a958cf4df3a5cd578b861471e62138f55c85e
Author: Stephane Grosjean <s.grosjean@peak-system.com>
Date:   Tue May 20 11:38:56 2014 +0200

    can: peak_pci: prevent use after free at netdev removal
    
    As remarked by Christopher R. Baker in his post at
    
    http://marc.info/?l=linux-can&m=139707295706465&w=2
    
    there's a possibility for an use after free condition at device removal.
    
    This simplified patch introduces an additional variable to prevent the issue.
    Thanks for catching this.
    
    Cc: linux-stable <stable@vger.kernel.org>
    Reported-by: Christopher R. Baker <cbaker@rec.ri.cmu.edu>
    Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
    Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

commit fbeb91fe8e4107dc88df4eaa21de02c3fd9d1cd5
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 8 16:56:13 2014 +0200

    dmaengine: sa11x0: remove broken #ifdef
    
    The sa11x0_dma_pm_ops unconditionally reference sa11x0_dma_resume
    and sa11x0_dma_suspend, which currently breaks if CONFIG_PM_SLEEP
    is disabled.
    
    There is probably a better way to remove the reference in this
    case, but the safe choice is to have the suspend/resume code always
    built in the driver.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: dmaengine@vger.kernel.org
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit a8246fedacadaab18b23b280ea3cf916ef5fc30e
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 8 16:56:12 2014 +0200

    dmaengine: omap: hide filter_fn for built-in drivers
    
    It is not possible to reference the omap_dma_filter_fn filter
    function from a built-in driver if the dmaengine driver itself
    is a loadable module, which is a valid configuration otherwise.
    
    This provides only the dummy alternative if the function
    is referenced by a built-in driver to allow a successful
    build. The filter function is only required by ATAGS based
    platforms, which will continue to be broken after this change
    for the bogus configuration. When booting from DT, with the
    dma channels correctly listed there, it will work fine.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Tony Lindgren <tony@atomide.com>
    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: dmaengine@vger.kernel.org
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 78ff4be45a4c51d8fb21ad92e4fabb467c6c3eeb
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Mon May 19 11:36:56 2014 +0200

    ip_tunnel: Initialize the fallback device properly
    
    We need to initialize the fallback device to have a correct mtu
    set on this device. Otherwise the mtu is set to null and the device
    is unusable.
    
    Fixes: fd58156e456d ("IPIP: Use ip-tunneling code.")
    Cc: Pravin B Shelar <pshelar@nicira.com>
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d8d33c3b8a42fbd9ad23a61498fa5db1d83644e0
Merge: d050de6 524369e
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 21 01:58:30 2014 -0400

    Merge tag 'linux-can-fixes-for-3.15-20140519' of git://gitorious.org/linux-can/linux-can
    
    Marc Kleine-Budde says:
    
    ====================
    pull-request: can 2014-05-19
    
    this is a pull request for net/master, for the v3.15 release cycle,
    with a single patch.
    
    Oliver Hartkopp's patch removes a Kconfig option in the c_can driver,
    which was added as a workaround during the v3.15 development. With all
    cleanup patches this workaround is not needed anymore.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d050de607f062233cf5e75b2e8f40f20c4b04b91
Merge: e1618d4 3b084e9
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 21 01:24:19 2014 -0400

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
    
    Pablo Neira Ayuso says:
    
    ====================
    Netfilter/nftables fixes for net
    
    The following patchset contains nftables fixes for your net tree, they
    are:
    
    1) Fix crash when using the goto action in a rule by making sure that
       we always fall back on the base chain. Otherwise, this may try to
       access the counter memory area of non-base chains, which does not
       exists.
    
    2) Fix several aspects of the rule tracing that are currently broken:
    
       * Reset rule number counter after goto/jump action, otherwise the
         tracing reports a bogus rule number.
       * Fix tracing of the goto action.
       * Fix bogus rule number counter after goto.
       * Fix missing return trace after finishing the walk through the
         non-base chain.
       * Fix missing trace when matching non-terminal rule.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 80c578930ce77ba8bcfb226a184b482020bdda7b
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue May 20 13:38:33 2014 -0400

    dm thin: add 'no_space_timeout' dm-thin-pool module param
    
    Commit 85ad643b ("dm thin: add timeout to stop out-of-data-space mode
    holding IO forever") introduced a fixed 60 second timeout.  Users may
    want to either disable or modify this timeout.
    
    Allow the out-of-data-space timeout to be configured using the
    'no_space_timeout' dm-thin-pool module param.  Setting it to 0 will
    disable the timeout, resulting in IO being queued until more data space
    is added to the thin-pool.
    
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org # 3.14+

commit 51a60253a58514524b7a347c4e68553821a79d04
Author: Filipe Manana <fdmanana@gmail.com>
Date:   Tue May 13 22:01:02 2014 +0100

    Btrfs: send, fix incorrect ref access when using extrefs
    
    When running send, if an inode only has extended reference items
    associated to it and no regular references, send.c:get_first_ref()
    was incorrectly assuming the reference it found was of type
    BTRFS_INODE_REF_KEY due to use of the wrong key variable.
    This caused weird behaviour when using the found item has a regular
    reference, such as weird path string, and occasionally (when lucky)
    a crash:
    
    [  190.600652] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
    [  190.600994] Modules linked in: btrfs xor raid6_pq binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc psmouse serio_raw evbug pcspkr i2c_piix4 e1000 floppy
    [  190.602565] CPU: 2 PID: 14520 Comm: btrfs Not tainted 3.13.0-fdm-btrfs-next-26+ #1
    [  190.602728] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
    [  190.602868] task: ffff8800d447c920 ti: ffff8801fa79e000 task.ti: ffff8801fa79e000
    [  190.603030] RIP: 0010:[<ffffffff813266b4>]  [<ffffffff813266b4>] memcpy+0x54/0x110
    [  190.603262] RSP: 0018:ffff8801fa79f880  EFLAGS: 00010202
    [  190.603395] RAX: ffff8800d4326e3f RBX: 000000000000036a RCX: ffff880000000000
    [  190.603553] RDX: 000000000000032a RSI: ffe708844042936a RDI: ffff8800d43271a9
    [  190.603710] RBP: ffff8801fa79f8c8 R08: 00000000003a4ef0 R09: 0000000000000000
    [  190.603867] R10: 793a4ef09f000000 R11: 9f0000000053726f R12: ffff8800d43271a9
    [  190.604020] R13: 0000160000000000 R14: ffff8802110134f0 R15: 000000000000036a
    [  190.604020] FS:  00007fb423d09b80(0000) GS:ffff880216200000(0000) knlGS:0000000000000000
    [  190.604020] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [  190.604020] CR2: 00007fb4229d4b78 CR3: 00000001f5d76000 CR4: 00000000000006e0
    [  190.604020] Stack:
    [  190.604020]  ffffffffa01f4d49 ffff8801fa79f8f0 00000000000009f9 ffff8801fa79f8c8
    [  190.604020]  00000000000009f9 ffff880211013260 000000000000f971 ffff88021147dba8
    [  190.604020]  00000000000009f9 ffff8801fa79f918 ffffffffa02367f5 ffff8801fa79f928
    [  190.604020] Call Trace:
    [  190.604020]  [<ffffffffa01f4d49>] ? read_extent_buffer+0xb9/0x120 [btrfs]
    [  190.604020]  [<ffffffffa02367f5>] fs_path_add_from_extent_buffer+0x45/0x60 [btrfs]
    [  190.604020]  [<ffffffffa0238806>] get_first_ref+0x1f6/0x210 [btrfs]
    [  190.604020]  [<ffffffffa0238994>] __get_cur_name_and_parent+0x174/0x3a0 [btrfs]
    [  190.604020]  [<ffffffff8118df3d>] ? kmem_cache_alloc_trace+0x11d/0x1e0
    [  190.604020]  [<ffffffffa0236674>] ? fs_path_alloc+0x24/0x60 [btrfs]
    [  190.604020]  [<ffffffffa0238c91>] get_cur_path+0xd1/0x240 [btrfs]
    (...)
    
    Steps to reproduce (either crash or some weirdness like an odd path string):
    
        mkfs.btrfs -f -O extref /dev/sdd
        mount /dev/sdd /mnt
    
        mkdir /mnt/testdir
        touch /mnt/testdir/foobar
    
        for i in `seq 1 2550`; do
            ln /mnt/testdir/foobar /mnt/testdir/foobar_link_`printf "%04d" $i`
        done
    
        ln /mnt/testdir/foobar /mnt/testdir/final_foobar_name
    
        rm -f /mnt/testdir/foobar
        for i in `seq 1 2550`; do
            rm -f /mnt/testdir/foobar_link_`printf "%04d" $i`
        done
    
        btrfs subvolume snapshot -r /mnt /mnt/mysnap
        btrfs send /mnt/mysnap -f /tmp/mysnap.send
    
    Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
    Signed-off-by: Chris Mason <clm@fb.com>
    Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

commit d3ecfcdf9108c833e4e501bfa02ecf673a0ace59
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Fri May 9 10:01:02 2014 +0800

    Btrfs: fix EIO on reading file after ioctl clone works on it
    
    For inline data extent, we need to make its length aligned, otherwise,
    we can get a phantom extent map which confuses readpages() to return -EIO.
    
    This can be detected by xfstests/btrfs/035.
    
    Reported-by: David Disseldorp <ddiss@suse.de>
    Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
    Signed-off-by: Chris Mason <clm@fb.com>

commit e1618d461ca18d40f9c3ef70598abb72e75d27ae
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Tue May 20 10:59:26 2014 -0400

    vlan: Fix build error wth vlan_get_encap_level()
    
    The new function vlan_get_encap_level() uses vlan_dev_priv()
    which is only conditionally avaialble when VLAN support is
    enabled.  Make vlan_get_encap_level() conditionally available
    as well.
    
    Fixes: 44a4085538c8 ("bonding: Fix stacked device detection in arp monitoring")
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    CC: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 4f2f203976964e267dc477de6648bdb3acd2b74b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon May 19 19:21:29 2014 -0400

    drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)
    
    When the PX card is off don't try and access it. Avoid hw access
    to the card while it's off (e.g., reading back invalid temperature).
    
    v2: be less strict
    
    bug:
    https://bugzilla.kernel.org/show_bug.cgi?id=76321
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 24f47acc78b0ab5e2201f859fe1f693ae90c7c83
Author: Jérôme Glisse <jglisse@redhat.com>
Date:   Wed May 7 16:35:24 2014 -0400

    drm/radeon: avoid segfault on device open when accel is not working.
    
    When accel is not working on device with virtual address space radeon
    segfault because the ib buffer is NULL and trying to map it inside the
    virtual address space trigger segfault. This patch only map the ib
    buffer if accel is working.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 74ad54f249de39bc040cce7237b1b854a9c6f0ad
Author: Christian König <christian.koenig@amd.com>
Date:   Tue May 13 12:50:54 2014 +0200

    drm/radeon: fix typo in finding PLL params
    
    Otherwise the limit is raised to high.
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Tested-by: Ken Moffat <zarniwhoop@ntlworld.com>

commit 4955bb073f1be6dd884b5d10041ba4bade6495bf
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon May 5 16:40:42 2014 -0400

    drm/radeon: fix register typo on si
    
    Probably a copy paste typo.
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Cc: stable@vger.kernel.org

commit 4b09556660bfe1b43d72ca858524c6baf2c6cb1d
Author: Christian König <christian.koenig@amd.com>
Date:   Sat May 10 18:17:09 2014 +0200

    drm/radeon: fix buffer placement under memory pressure v2
    
    Some buffers (UVD/VM page tables) must be placed in VRAM,
    but the byte restriction for moving buffers didn't took this
    into account.
    
    v2: keep closer to the original code
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Reviewed-by: Marek Olšák <marek.olsak@amd.com>

commit 4906f6891ef987637b766dfaef1c6fc95804253a
Author: Christian König <christian.koenig@amd.com>
Date:   Mon May 12 14:46:11 2014 +0200

    drm/radeon: fix page directory update size estimation
    
    Take padding into account as well.
    
    Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=75651
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

commit d8ade3526b2aa0505132c404c05a38b73ea15490
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu May 8 20:04:03 2014 -0400

    drm/radeon: handle non-VGA class pci devices with ATRM
    
    Newer PX systems have non-VGA pci class dGPUs.  Update
    the ATRM fetch method to handle those cases.
    
    bug:
    https://bugzilla.kernel.org/show_bug.cgi?id=75401
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Cc: stable@vger.kernel.org

commit 89d2618dbd114e679b860c3de1df3fe43ee40f6e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu May 8 18:26:23 2014 -0400

    drm/radeon: fix DCE83 check for mullins
    
    Mullins is DCE83 just like Kabini.  Set the proper number
    of endpoints on mullins.
    
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 2fc5703abda201f138faf63bdca743d04dbf4b1a
Author: Leo Liu <leo.liu@amd.com>
Date:   Mon May 5 15:42:18 2014 -0400

    drm/radeon: check VCE relocation buffer range v3
    
    v2 (chk): fix image size storage
    v3 (chk): fix UV size calculation
    
    Signed-off-by: Leo Liu <leo.liu@amd.com>
    Signed-off-by: Christian König <christian.koenig@amd.com>

commit 544092596e8ac269f70e70961b5e9381909c9b1e
Author: Christian König <christian.koenig@amd.com>
Date:   Mon May 5 18:40:12 2014 +0200

    drm/radeon: also try GART for CPU accessed buffers
    
    Placing them exclusively into VRAM might not work all the time.
    
    Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=78297
    
    Signed-off-by: Christian König <christian.koenig@amd.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Cc: stable@vger.kernel.org

commit 68b7752462aba4716d9236b28aaa91b48fe059cd
Author: James Hogan <james.hogan@imgtec.com>
Date:   Wed Apr 23 11:08:06 2014 +0100

    scripts/checksyscalls.sh: Make renameat optional
    
    The new renameat2 syscall provides all the functionality of renameat
    with an additional flags argument, so make renameat optional so that
    future architectures can omit it without getting a warning.
    
    This patch doesn't affect existing architectures.
    
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Cc: linux-arch@vger.kernel.org

commit 63ba600028a001fa19f427486527387f54926d61
Author: James Hogan <james.hogan@imgtec.com>
Date:   Wed Apr 23 11:08:05 2014 +0100

    asm-generic: Add renameat2 syscall
    
    Add the renameat2 syscall to the generic syscall list, which is used by the
    following architectures: arc, arm64, c6x, hexagon, metag, openrisc, score,
    tile, unicore32.
    
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Cc: linux-arch@vger.kernel.org
    Cc: Vineet Gupta <vgupta@synopsys.com>
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: linux-arm-kernel@lists.infradead.org
    Cc: Mark Salter <msalter@redhat.com>
    Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
    Cc: Richard Kuo <rkuo@codeaurora.org>
    Cc: linux-hexagon@vger.kernel.org
    Cc: linux-metag@vger.kernel.org
    Cc: Jonas Bonn <jonas@southpole.se>
    Cc: Chen Liqin <liqin.linux@gmail.com>
    Cc: Lennox Wu <lennox.wu@gmail.com>
    Cc: Chris Metcalf <cmetcalf@tilera.com>
    Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>

commit 3ca976a2cf95c1d4254a1eb8e13b5063522691d5
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue May 20 10:59:38 2014 +0200

    ia64: add renameat2 syscall
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Acked-by: Tony Luck <tony.luck@intel.com>

commit 18e480aa07f78abc7938adfe1035a5d9ce188ad8
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue May 20 10:59:37 2014 +0200

    parisc: add renameat2 syscall
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Acked-by: Helge Deller <deller@gmx.de>

commit cc79f00f7611cbb8f1ff1b92fe829548efcb4f08
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue May 20 10:59:37 2014 +0200

    m68k: add renameat2 syscall
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

commit 60b5f90d0fac7585f1a43ccdad06787b97eda0ab
Merge: c7d6891 665ebe9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 16:50:38 2014 +0900

    Merge tag 'sound-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
    
    Pull sound fixes from Takashi Iwai:
     "Unfortunately this update became bigger than previous pull requests,
      which is almost a pattern in rc5-6.  But, the only obvious big changes
      are for the new Intel DSP ASoC drivers, so the impact must be fairly
      limited.
    
      Other than that, usual small fixes in various fields: HD-audio, ASoC
      core and ASoC fsl and codec drivers"
    
    * tag 'sound-3.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound: (26 commits)
      ALSA: sb_mixer: missing return statement
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile
      ASoC: Intel: Fix Baytrail SST DSP firmware loading
      ALSA: hda - mask buggy stream DMA0 for Broadwell display controller
      ALSA: hda - Add new GPU codec ID to snd-hda
      ASoC: fsl_esai: Set PCRC and PRRC registers at the end of hw_params()
      ASoC: fsl_esai: Only bypass sck_div for EXTAL source
      ASoC: fsl_esai: Fix incorrect condition within ratio range check for FP
      ASoC: dapm: Fix SUSPEND -> OFF bias sequence
      ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()
      ASoC: pcm: Fix incorrect condition check for case SNDRV_PCM_TRIGGER_SUSPEND
      ALSA: hda - add headset mic detect quirks for three Dell laptops
      ASoC: Update Cirrus Logic CODEC maintainers.
      ASoC: Intel: Fix block offset calculations.
      ASoC: Intel: Fix check for pdata usage before dereference.
      ASoC: Intel: Fix stream position pointer.
      ASoC: Intel: Fix allow hw_params to be called more than once.
      ASoC: Intel: Fix Audio DSP usage when IOMMU is enabled.
      ASoC: Intel: Fix Haswell/Broadwell DSP page table creation.
      ASoC: Intel: Fix allocated block list usage when adding blocks.
      ...

commit c7d6891a770aa97dd36c2df3545031e64c6a0ef3
Merge: 6ed8bf8 7bb3940
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 16:47:33 2014 +0900

    Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
    
    Pull MIPS fixes from Ralf Baechle:
     "MIPS fixes for various loose ends:
    
       - Fix workarounds for R4000 erratum.
       - Patch up DEC, Siemens-Nixdorf and Loongson hardware support.
       - Wire up renameat2 syscall.
       - Delete unused file - it was causing false warnings from maintenance
         scripts.
       - Revert a patch because it's functionality is now implemented twice
         which causes superfluous /proc/cpuinfo output.
       - Fix a microMIPS regression"
    
    * 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus:
      MIPS: mm: Fix broken microMIPS kernel regression.
      MIPS: Add new AUDIT_ARCH token for the N32 ABI on MIPS64
      MIPS: Wire up renameat2 syscall.
      MIPS: inst.h: Rename BITFIELD_FIELD to __BITFIELD_FIELD.
      MIPS: Remove file missed when removing rm9k support a while ago.
      MIPS/loongson2_cpufreq: Fix CPU clock rate setting
      MIPS: Loongson: No need to select GENERIC_HARDIRQS_NO__DO_IRQ
      MIPS: csum_partial.S CPU_DADDI_WORKAROUNDS bug fix
      MIPS: __strncpy_from_user_asm CPU_DADDI_WORKAROUNDS bug fix
      MIPS: __delay CPU_DADDI_WORKAROUNDS bug fix
      MIPS: DEC/SNI: O32 wrapper stack switching fixes
      MIPS: DEC: Bus error handler <asm/cpu-type.h> fixes
      MAINTAINERS: TURBOchannel: Update entry
      Revert "MIPS: MT: proc: Add support for printing VPE and TC ids"

commit 0f1d360b2ee3a2a0f510d3f1bcd3f5ebe5d41265
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue May 20 16:13:54 2014 +1000

    drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup
    
    Fixes a LVDS bleed issue on Lenovo W530 that can occur under a
    number of circumstances.
    
    Cc: <stable@vger.kernel.org > # v3.9+
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 6679b2ccc914e84384b1acf0de4423e3738cce9f
Author: Martin Peres <martin.peres@free.fr>
Date:   Mon May 12 15:05:01 2014 +0200

    drm/nvd9/therm: handle another kind of PWM fan
    
    Signed-off-by: Martin Peres <martin.peres@free.fr>
    Tested-by: SaveTheRobots <john.rowley08@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 6ed8bf82fe44752f748bdc19567f79a961cf916c
Merge: 8d900e7 c776cd8
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:35:28 2014 +0900

    Merge branch 'parisc-3.15-4' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
    
    Pull parisc fixes from Helge Deller:
     "There are two patches in here:
    
      The first patch greatly improves latency and corrects the memory
      ordering in our light-weight atomic locking syscall.
    
      The second patch ratelimits printing of userspace segfaults in the
      same way as it's done on other platforms.  This fixes a possible DOS
      on parisc since it prevents the syslog to grow too fast.  For example,
      when the debian acl2 package was built on our debian buildd servers,
      this package produced lots of gigabytes in syslog in very short time
      and thus filled our harddisks, which then turned the server nearly
      completely unaccessible and unresponsive"
    
    * 'parisc-3.15-4' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux:
      parisc: Improve LWS-CAS performance
      parisc: ratelimit userspace segfault printing

commit 8d900e7f3178dccb123c877253bdb193827654c6
Merge: 41abc90 4797ec2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:33:48 2014 +0900

    Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
    
    Pull two arm64 fixes from Catalin Marinas:
     - arm64 migrate_irqs() fix following commit ffde1de64012 (irqchip: Gic:
       Support forced affinity setting)
     - fix arm64 pud_huge() to return 0 when only 2 levels page tables are
       used (__PAGETABLE_PMD_FOLDED defined and pmd_huge already covers
       block entries at the first level), otherwise KVM gets confused
    
    * tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux:
      arm64: fix pud_huge() for 2-level pagetables
      arm64: use cpu_online_mask when using forced irq_set_affinity

commit 41abc90228f98774263572ec99e7ab820f091002
Merge: a7b08063 ffe6902
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:30:34 2014 +0900

    Merge tag 'metag-for-v3.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag
    
    Pull Metag architecture and related fixes from James Hogan:
     "Mostly fixes for metag and parisc relating to upgrowing stacks.
    
       - Fix missing compiler barriers in metag memory barriers.
       - Fix BUG_ON on metag when RLIMIT_STACK hard limit is increased
         beyond safe value.
       - Make maximum stack size configurable.  This reduces the default
         user stack size back to 80MB (especially on parisc after their
         removal of _STK_LIM_MAX override).  This only affects metag and
         parisc.
       - Remove metag _STK_LIM_MAX override to match other arches and follow
         parisc, now that it is safe to do so (due to the BUG_ON fix
         mentioned above).
       - Finally now that both metag and parisc _STK_LIM_MAX overrides have
         been removed, it makes sense to remove _STK_LIM_MAX altogether"
    
    * tag 'metag-for-v3.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag:
      asm-generic: remove _STK_LIM_MAX
      metag: Remove _STK_LIM_MAX override
      parisc,metag: Do not hardcode maximum userspace stack size
      metag: Reduce maximum stack size to 256MB
      metag: fix memory barriers

commit a7b0806392b527e8a616e7ea6f17aafe33949a9f
Merge: 172de65 4ba4801
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:28:33 2014 +0900

    Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
    
    Pull drm/intel fixes from Dave Airlie:
     "Just some intel fixes.
    
      I have some radeon ones but I need to get some patches dropped from
      the pull req"
    
    * 'drm-fixes' of git://people.freedesktop.org/~airlied/linux:
      drm/i915: Increase WM memory latency values on SNB
      drm/i915: restore backlight precision when converting from ACPI
      drm/i915: Use the first mode if there is no preferred mode in the EDID
      drm/i915/dp: force eDP lane count to max available lanes on BDW
      drm/i915/vlv: reset VLV media force wake request register
      drm/i915/SDVO: For sysfs link put directory and target in correct order
      drm/i915: use lane count and link rate from VBT as minimums for eDP
      drm/i915: clean up VBT eDP link param decoding
      drm/i915: consider the source max DP lane count too

commit 172de656b98efd81399aec83837dccaa276622c4
Merge: 95d0858 fa81511
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:21:11 2014 +0900

    Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull x86 fixes from Peter Anvin.
    
    * 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()
      x86, rdrand: When nordrand is specified, disable RDSEED as well

commit 95d08585e093a9f07562b4a3984370b4d72f1a57
Merge: 3f017a4 84ea7fe
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:19:10 2014 +0900

    Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull timer fix from Thomas Gleixner:
     "A single bug fix for a long standing issue:
    
       - Updating the expiry value of a relative timer _after_ letting the
         idle logic select a target cpu for the timer based on its stale
         expiry value is outright stupid.  Thanks to Viresh for spotting the
         brainfart"
    
    * 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      hrtimer: Set expiry time before switch_hrtimer_base()

commit 3f017a4ca2de0a87767ab047b2bd2f3f11e87a9e
Merge: 14186fe 2ed9fd2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 20 14:18:04 2014 +0900

    Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull irq fixes from Thomas Gleixner:
     "Two small updates from the irq departement:
    
       - Provide missing inline stub for a SMP only function
    
       - Add sub-maintainer for the drivers/irqchip/ part of the irq
         subsystem.  YAY!"
    
    * 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip:
      MAINTAINERS: Add co-maintainer for drivers/irqchip
      genirq: Provide irq_force_affinity fallback for non-SMP

commit f5c16f29bf5e57ba4051fc7785ba7f035f798c71
Author: Tejun Heo <tj@kernel.org>
Date:   Mon May 19 15:52:10 2014 -0400

    sysfs: make sure read buffer is zeroed
    
    13c589d5b0ac ("sysfs: use seq_file when reading regular files")
    switched sysfs from custom read implementation to seq_file to enable
    later transition to kernfs.  After the change, the buffer passed to
    ->show() is acquired through seq_get_buf(); unfortunately, this
    introduces a subtle behavior change.  Before the commit, the buffer
    passed to ->show() was always zero as it was allocated using
    get_zeroed_page().  Because seq_file doesn't clear buffers on
    allocation and neither does seq_get_buf(), after the commit, depending
    on the behavior of ->show(), we may end up exposing uninitialized data
    to userland thus possibly altering userland visible behavior and
    leaking information.
    
    Fix it by explicitly clearing the buffer.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Ron <ron@debian.org>
    Fixes: 13c589d5b0ac ("sysfs: use seq_file when reading regular files")
    Cc: stable <stable@vger.kernel.org> # 3.13+
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4ba4801d73d14690ed15774424e8b1d4c18323a5
Merge: 14186fe e95a2f7
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue May 20 09:56:26 2014 +1000

    Merge tag 'drm-intel-fixes-2014-05-16' of git://anongit.freedesktop.org/drm-intel into drm-fixes
    
    Intel fixes for regressions, black screens and hangs, for 3.15.
    
    * tag 'drm-intel-fixes-2014-05-16' of git://anongit.freedesktop.org/drm-intel:
      drm/i915: Increase WM memory latency values on SNB
      drm/i915: restore backlight precision when converting from ACPI
      drm/i915: Use the first mode if there is no preferred mode in the EDID
      drm/i915/dp: force eDP lane count to max available lanes on BDW
      drm/i915/vlv: reset VLV media force wake request register
      drm/i915/SDVO: For sysfs link put directory and target in correct order
      drm/i915: use lane count and link rate from VBT as minimums for eDP
      drm/i915: clean up VBT eDP link param decoding
      drm/i915: consider the source max DP lane count too

commit e3beb0ac521d50d158a9d253373eae8421ac3998
Author: Lucas Stach <l.stach@pengutronix.de>
Date:   Fri May 16 12:20:42 2014 +0200

    cpufreq: cpu0: drop wrong devm usage
    
    This driver is using devres managed calls incorrectly, giving the cpu0
    device as first parameter instead of the cpufreq platform device.
    This results in resources not being freed if the cpufreq platform device
    is unbound, for example if probing has to be deferred for a missing
    regulator.
    
    Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c5450db85b828d0c46ac8fc570fb8a51bf07ac40
Author: Bibek Basu <bbasu@nvidia.com>
Date:   Mon May 19 10:24:01 2014 +0530

    cpufreq: remove race while accessing cur_policy
    
    While accessing cur_policy during executing events
    CPUFREQ_GOV_START, CPUFREQ_GOV_STOP, CPUFREQ_GOV_LIMITS,
    same mutex lock is not taken, dbs_data->mutex, which leads
    to race and data corruption while running continious suspend
    resume test. This is seen with ondemand governor with suspend
    resume test using rtcwake.
    
     Unable to handle kernel NULL pointer dereference at virtual address 00000028
     pgd = ed610000
     [00000028] *pgd=adf11831, *pte=00000000, *ppte=00000000
     Internal error: Oops: 17 [#1] PREEMPT SMP ARM
     Modules linked in: nvhost_vi
     CPU: 1 PID: 3243 Comm: rtcwake Not tainted 3.10.24-gf5cf9e5 #1
     task: ee708040 ti: ed61c000 task.ti: ed61c000
     PC is at cpufreq_governor_dbs+0x400/0x634
     LR is at cpufreq_governor_dbs+0x3f8/0x634
     pc : [<c05652b8>] lr : [<c05652b0>] psr: 600f0013
     sp : ed61dcb0 ip : 000493e0 fp : c1cc14f0
     r10: 00000000 r9 : 00000000 r8 : 00000000
     r7 : eb725280 r6 : c1cc1560 r5 : eb575200 r4 : ebad7740
     r3 : ee708040 r2 : ed61dca8 r1 : 001ebd24 r0 : 00000000
     Flags: nZCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
     Control: 10c5387d Table: ad61006a DAC: 00000015
     [<c05652b8>] (cpufreq_governor_dbs+0x400/0x634) from [<c055f700>] (__cpufreq_governor+0x98/0x1b4)
     [<c055f700>] (__cpufreq_governor+0x98/0x1b4) from [<c0560770>] (__cpufreq_set_policy+0x250/0x320)
     [<c0560770>] (__cpufreq_set_policy+0x250/0x320) from [<c0561dcc>] (cpufreq_update_policy+0xcc/0x168)
     [<c0561dcc>] (cpufreq_update_policy+0xcc/0x168) from [<c0561ed0>] (cpu_freq_notify+0x68/0xdc)
     [<c0561ed0>] (cpu_freq_notify+0x68/0xdc) from [<c008eff8>] (notifier_call_chain+0x4c/0x8c)
     [<c008eff8>] (notifier_call_chain+0x4c/0x8c) from [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68)
     [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68) from [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28)
     [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28) from [<c00aac6c>] (pm_qos_update_bounded_target+0xd8/0x310)
     [<c00aac6c>] (pm_qos_update_bounded_target+0xd8/0x310) from [<c00ab3b0>] (__pm_qos_update_request+0x64/0x70)
     [<c00ab3b0>] (__pm_qos_update_request+0x64/0x70) from [<c004b4b8>] (tegra_pm_notify+0x114/0x134)
     [<c004b4b8>] (tegra_pm_notify+0x114/0x134) from [<c008eff8>] (notifier_call_chain+0x4c/0x8c)
     [<c008eff8>] (notifier_call_chain+0x4c/0x8c) from [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68)
     [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68) from [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28)
     [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28) from [<c00ac228>] (pm_notifier_call_chain+0x1c/0x34)
     [<c00ac228>] (pm_notifier_call_chain+0x1c/0x34) from [<c00ad38c>] (enter_state+0xec/0x128)
     [<c00ad38c>] (enter_state+0xec/0x128) from [<c00ad400>] (pm_suspend+0x38/0xa4)
     [<c00ad400>] (pm_suspend+0x38/0xa4) from [<c00ac114>] (state_store+0x70/0xc0)
     [<c00ac114>] (state_store+0x70/0xc0) from [<c027b1e8>] (kobj_attr_store+0x14/0x20)
     [<c027b1e8>] (kobj_attr_store+0x14/0x20) from [<c019cd9c>] (sysfs_write_file+0x104/0x184)
     [<c019cd9c>] (sysfs_write_file+0x104/0x184) from [<c0143038>] (vfs_write+0xd0/0x19c)
     [<c0143038>] (vfs_write+0xd0/0x19c) from [<c0143414>] (SyS_write+0x4c/0x78)
     [<c0143414>] (SyS_write+0x4c/0x78) from [<c000f080>] (ret_fast_syscall+0x0/0x30)
     Code: e1a00006 eb084346 e59b0020 e5951024 (e5903028)
     ---[ end trace 0488523c8f6b0f9d ]---
    
    Signed-off-by: Bibek Basu <bbasu@nvidia.com>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: 3.11+ <stable@vger.kernel.org> # 3.11+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 20b4f9c73ff4137d720c4f378e1a780ac6a6c04d
Merge: faf1dc6 40b9397
Author: John W. Linville <linville@tuxdriver.com>
Date:   Mon May 19 16:34:27 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth

commit 3685f2516116c5f3b9d498d531955ad70216ad84
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Sat May 17 20:46:01 2014 +0800

    ahci: imx: PLL clock needs 100us to settle down
    
    The commit e783c51 (ahci: imx: software workaround for phy reset issue
    in resume) calls imx_sata_phy_reset() to reset phy immediately after
    SATA MPLL is enabled.  It seems working fine mostly, but fails in some
    case as below.
    
    ...
    ahci-imx 2200000.sata: failed to reset phy: -110
    ahci-imx: probe of 2200000.sata failed with error -110
    
    After talking to the designer, we learnt that when enabling i.MX6Q SATA
    MPLL, we need to wait 100us for it to settle down for safety.  Add this
    required delay to fix above failure.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit d0b4cc4e32705ff00d90d32da7783c266c702c04
Author: Gavin Shan <gwshan@linux.vnet.ibm.com>
Date:   Mon May 19 13:06:46 2014 +1000

    PCI: Wrong register used to check pending traffic
    
    The incorrect register offset is passed to pci_wait_for_pending(), which is
    caused by commit 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor
    pci_wait_for_pending_transaction())").
    
    Fixes: 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
    Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Alex Williamson <alex.williamson@gmail.com>
    CC: stable@vger.kernel.org	# v3.14+

commit 4b353a706a86598ba47307c47301c3c428b79e09
Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date:   Mon May 12 17:37:59 2014 -0400

    ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled
    
    On OMAP4 panda board, there have been several bug reports about boot
    hang and lock-ups with CPU_IDLE enabled. The root cause of the issue
    is missing interrupts while in idle state. Commit cb7094e8 {cpuidle / omap4 :
    use CPUIDLE_FLAG_TIMER_STOP flag} moved the broadcast notifiers to common
    code for right reasons but on OMAP4 which suffers from a nasty ROM code
    bug with GIC, commit ff999b8a {ARM: OMAP4460: Workaround for ROM bug ..},
    we loose interrupts which leads to issues like lock-up, hangs etc.
    
    Patch reverts commit cb7094 {cpuidle / omap4 : use CPUIDLE_FLAG_TIMER_STOP
    flag} and 54769d6 {cpuidle: OMAP4: remove timer broadcast initialization} to
    avoid the issue. With this change, OMAP4 panda boards, the mentioned
    issues are getting fixed. We no longer loose interrupts which was the cause
    of the regression.
    
    Fixes: cb7094e8 (cpuidle / omap4 : use CPUIDLE_FLAG_TIMER_STOP flag)
    Fixes: ff999b8a (cpuidle: OMAP4: remove timer broadcast initialization)
    Cc: stable@vger.kernel.org # v3.9+
    Cc: Roger Quadros <rogerq@ti.com>
    Cc: Kevin Hilman <khilman@linaro.org>
    Cc: Tony Lindgren <tony@atomide.com>
    Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
    Reported-tested-by: Roger Quadros <rogerq@ti.com>
    Reported-tested-by: Kevin Hilman <khilman@linaro.org>
    Tested-by: Tony Lindgren <tony@atomide.com>
    Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 68d0e40298f064a5cff40670caded0480274d4b2
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue May 20 01:15:46 2014 +0900

    ARM: dts: Keep LDO4 always ON for exynos5250-arndale board
    
    LDO4 regulator was getting disabled preventing the system from
    going into low power states. Keep it always on to fix it.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit e3b6c271abddb5363b01b79d6e6e4343008cd991
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue May 20 01:14:03 2014 +0900

    ARM: dts: Fix SPI interrupt numbers for exynos5420
    
    Updated as per the user manual.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit 30cc798b63fd21ba58c94f4f8b4c1e55137fd029
Author: Beomho Seo <beomho.seo@samsung.com>
Date:   Tue May 20 01:12:50 2014 +0900

    ARM: dts: fix incorrect ak8975 compatible for exynos4412-trats2 board
    
    This patch fixed incorrect compatible for ak8975 magnetic sensor.
    ak8975 magnetic sensor use compatible "ak8975" or "asahi-kasei,ak8975"
    In this patch, use "asahi-kasei,ak8975" according to dt bindings document.
    
    Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
    Reviewed-by: Tomasz Figa <t.figa@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit b69cf53640da2b86439596118cfa95233154ee76
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Mar 14 10:50:33 2014 +0100

    perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()
    
    Alexander noticed that we use RCU iteration on rb->event_list but do
    not use list_{add,del}_rcu() to add,remove entries to that list, nor
    do we observe proper grace periods when re-using the entries.
    
    Merge ring_buffer_detach() into ring_buffer_attach() such that
    attaching to the NULL buffer is detaching.
    
    Furthermore, ensure that between any 'detach' and 'attach' of the same
    event we observe the required grace period, but only when strictly
    required. In effect this means that only ioctl(.request =
    PERF_EVENT_IOC_SET_OUTPUT) will wait for a grace period, while the
    normal initial attach and final detach will not be delayed.
    
    This patch should, I think, do the right thing under all
    circumstances, the 'normal' cases all should never see the extra grace
    period, but the two cases:
    
     1) PERF_EVENT_IOC_SET_OUTPUT on an event which already has a
        ring_buffer set, will now observe the required grace period between
        removing itself from the old and attaching itself to the new buffer.
    
        This case is 'simple' in that both buffers are present in
        perf_event_set_output() one could think an unconditional
        synchronize_rcu() would be sufficient; however...
    
     2) an event that has a buffer attached, the buffer is destroyed
        (munmap) and then the event is attached to a new/different buffer
        using PERF_EVENT_IOC_SET_OUTPUT.
    
        This case is more complex because the buffer destruction does:
          ring_buffer_attach(.rb = NULL)
        followed by the ioctl() doing:
          ring_buffer_attach(.rb = foo);
    
        and we still need to observe the grace period between these two
        calls due to us reusing the event->rb_entry list_head.
    
    In order to make 2 happen we use Paul's latest cond_synchronize_rcu()
    call.
    
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/20140507123526.GD13658@twins.programming.kicks-ass.net
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 39af6b1678afa5880dda7e375cf3f9d395087f6d
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Mon Apr 7 11:04:08 2014 +0200

    perf: Prevent false warning in perf_swevent_add
    
    The perf cpu offline callback takes down all cpu context
    events and releases swhash->swevent_hlist.
    
    This could race with task context software event being just
    scheduled on this cpu via perf_swevent_add while cpu hotplug
    code already cleaned up event's data.
    
    The race happens in the gap between the cpu notifier code
    and the cpu being actually taken down. Note that only cpu
    ctx events are terminated in the perf cpu hotplug code.
    
    It's easily reproduced with:
      $ perf record -e faults perf bench sched pipe
    
    while putting one of the cpus offline:
      # echo 0 > /sys/devices/system/cpu/cpu1/online
    
    Console emits following warning:
      WARNING: CPU: 1 PID: 2845 at kernel/events/core.c:5672 perf_swevent_add+0x18d/0x1a0()
      Modules linked in:
      CPU: 1 PID: 2845 Comm: sched-pipe Tainted: G        W    3.14.0+ #256
      Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
       0000000000000009 ffff880077233ab8 ffffffff81665a23 0000000000200005
       0000000000000000 ffff880077233af8 ffffffff8104732c 0000000000000046
       ffff88007467c800 0000000000000002 ffff88007a9cf2a0 0000000000000001
      Call Trace:
       [<ffffffff81665a23>] dump_stack+0x4f/0x7c
       [<ffffffff8104732c>] warn_slowpath_common+0x8c/0xc0
       [<ffffffff8104737a>] warn_slowpath_null+0x1a/0x20
       [<ffffffff8110fb3d>] perf_swevent_add+0x18d/0x1a0
       [<ffffffff811162ae>] event_sched_in.isra.75+0x9e/0x1f0
       [<ffffffff8111646a>] group_sched_in+0x6a/0x1f0
       [<ffffffff81083dd5>] ? sched_clock_local+0x25/0xa0
       [<ffffffff811167e6>] ctx_sched_in+0x1f6/0x450
       [<ffffffff8111757b>] perf_event_sched_in+0x6b/0xa0
       [<ffffffff81117a4b>] perf_event_context_sched_in+0x7b/0xc0
       [<ffffffff81117ece>] __perf_event_task_sched_in+0x43e/0x460
       [<ffffffff81096f1e>] ? put_lock_stats.isra.18+0xe/0x30
       [<ffffffff8107b3c8>] finish_task_switch+0xb8/0x100
       [<ffffffff8166a7de>] __schedule+0x30e/0xad0
       [<ffffffff81172dd2>] ? pipe_read+0x3e2/0x560
       [<ffffffff8166b45e>] ? preempt_schedule_irq+0x3e/0x70
       [<ffffffff8166b45e>] ? preempt_schedule_irq+0x3e/0x70
       [<ffffffff8166b464>] preempt_schedule_irq+0x44/0x70
       [<ffffffff816707f0>] retint_kernel+0x20/0x30
       [<ffffffff8109e60a>] ? lockdep_sys_exit+0x1a/0x90
       [<ffffffff812a4234>] lockdep_sys_exit_thunk+0x35/0x67
       [<ffffffff81679321>] ? sysret_check+0x5/0x56
    
    Fixing this by tracking the cpu hotplug state and displaying
    the WARN only if current cpu is initialized properly.
    
    Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: stable@vger.kernel.org
    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Jiri Olsa <jolsa@redhat.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1396861448-10097-1-git-send-email-jolsa@redhat.com
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 0819b2e30ccb93edf04876237b6205eef84ec8d2
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu May 15 20:23:48 2014 +0200

    perf: Limit perf_event_attr::sample_period to 63 bits
    
    Vince reported that using a large sample_period (one with bit 63 set)
    results in wreckage since while the sample_period is fundamentally
    unsigned (negative periods don't make sense) the way we implement
    things very much rely on signed logic.
    
    So limit sample_period to 63 bits to avoid tripping over this.
    
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: stable@vger.kernel.org
    Link: http://lkml.kernel.org/n/tip-p25fhunibl4y3qi0zuqmyf4b@git.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit f0d71b3dcb8332f7971b5f2363632573e6d9486a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon May 12 20:45:35 2014 +0000

    futex: Prevent attaching to kernel threads
    
    We happily allow userspace to declare a random kernel thread to be the
    owner of a user space PI futex.
    
    Found while analysing the fallout of Dave Jones syscall fuzzer.
    
    We also should validate the thread group for private futexes and find
    some fast way to validate whether the "alleged" owner has RW access on
    the file which backs the SHM, but that's a separate issue.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Darren Hart <darren@dvhart.com>
    Cc: Davidlohr Bueso <davidlohr@hp.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Clark Williams <williams@redhat.com>
    Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
    Cc: Roland McGrath <roland@hack.frob.com>
    Cc: Carlos ODonell <carlos@redhat.com>
    Cc: Jakub Jelinek <jakub@redhat.com>
    Cc: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Link: http://lkml.kernel.org/r/20140512201701.194824402@linutronix.de
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: stable@vger.kernel.org

commit 866293ee54227584ffcb4a42f69c1f365974ba7f
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon May 12 20:45:34 2014 +0000

    futex: Add another early deadlock detection check
    
    Dave Jones trinity syscall fuzzer exposed an issue in the deadlock
    detection code of rtmutex:
      http://lkml.kernel.org/r/20140429151655.GA14277@redhat.com
    
    That underlying issue has been fixed with a patch to the rtmutex code,
    but the futex code must not call into rtmutex in that case because
        - it can detect that issue early
        - it avoids a different and more complex fixup for backing out
    
    If the user space variable got manipulated to 0x80000000 which means
    no lock holder, but the waiters bit set and an active pi_state in the
    kernel is found we can figure out the recursive locking issue by
    looking at the pi_state owner. If that is the current task, then we
    can safely return -EDEADLK.
    
    The check should have been added in commit 59fa62451 (futex: Handle
    futex_pi OWNER_DIED take over correctly) already, but I did not see
    the above issue caused by user space manipulation back then.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Darren Hart <darren@dvhart.com>
    Cc: Davidlohr Bueso <davidlohr@hp.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Clark Williams <williams@redhat.com>
    Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
    Cc: Roland McGrath <roland@hack.frob.com>
    Cc: Carlos ODonell <carlos@redhat.com>
    Cc: Jakub Jelinek <jakub@redhat.com>
    Cc: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Link: http://lkml.kernel.org/r/20140512201701.097349971@linutronix.de
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: stable@vger.kernel.org

commit 02fb05a598e9393382f55132a36aff84f4d76ad5
Author: Tushar Behera <tushar.behera@linaro.org>
Date:   Mon May 19 14:53:53 2014 +0530

    ALSA: pcm_dmaengine: Add check during device suspend
    
    Currently snd_dmaengine_pcm_trigger() calls dmaengine_pause()
    unconditinally during device suspend. In case where DMA controller
    doesn't support PAUSE/RESUME functionality, this call is not able
    to stop the DMA controller. In this scenario, audio playback doesn't
    resume after device resume.
    
    Calling dmaengine_pause/dmaengine_terminate_all conditionally fixes
    the issue.
    
    It has been tested with audio playback on Samsung platform having
    PL330 DMA controller which doesn't support PAUSE/RESUME.
    
    Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
    Acked-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit 524369e2391f4b422d0efdd11d526a373a11a43a
Author: Oliver Hartkopp <socketcan@hartkopp.net>
Date:   Tue May 6 19:45:38 2014 +0200

    can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option
    
    In 2b9aecdce2 ("can: c_can: Disable rx split as workaround") a new Kconfig
    option was introduced as a workaround. The tests performed by Alexander Stein
    confirmed this option to be obsolete with all the other cleanups and fixes
    that had been discussed that time:
    http://marc.info/?l=linux-can&m=139746476821294&w=2
    
    Both (author and tester) agreed to remove this Kconfig option again:
    http://marc.info/?l=linux-can&m=139883820714229&w=2
    
    As some more cleanups took place since then a simple revert is not possible.
    This patch removes the entire option as it would behave when disabled.
    Further beautification’s can be done later.
    
    Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
    Tested-by: Alexander Stein <alexander.stein@systec-electronic.com>
    Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

commit 4f337ed5c014752b000f593182fdcfa3ecf0d166
Author: Jesse Gross <jesse@nicira.com>
Date:   Fri May 16 15:57:59 2014 -0700

    MAINTAINERS: Pravin Shelar is Open vSwitch maintainer.
    
    Pravin will be maintaining Open vSwitch going forward.
    
    CC: Pravin Shelar <pshelar@nicira.com>
    Signed-off-by: Jesse Gross <jesse@nicira.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 02948344fbf511c6eec28687dc76bb64b758ff93
Author: Joe Perches <joe@perches.com>
Date:   Thu May 15 23:51:43 2014 -0700

    bnx2x: Convert return 0 to return rc
    
    These "return 0;" uses seem wrong as there are
    rc variables where error return values are set
    but unused.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Acked-by: Dmitry Kravkov <Dmitry.Kravkov@qlogic.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 1e1110c43b1cda9fe77fc4a04835e460550e6b3c
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Sat May 17 06:49:22 2014 -0400

    target: fix memory leak on XCOPY
    
    On each processed XCOPY command, two "kmalloc-512" memory objects are
    leaked. These represent two allocations of struct xcopy_pt_cmd in
    target_core_xcopy.c.
    
    The reason for the memory leak is that the cmd_kref field is not
    initialized (thus, it is zero because the allocations were done with
    kzalloc). When we decrement zero kref in target_put_sess_cmd, the result
    is not zero, thus target_release_cmd_kref is not called.
    
    This patch fixes the bug by moving kref initialization from
    target_get_sess_cmd to transport_init_se_cmd (this function is called from
    target_core_xcopy.c, so it will correctly initialize cmd_kref). It can be
    easily verified that all code that calls target_get_sess_cmd also calls
    transport_init_se_cmd earlier, thus moving kref_init shouldn't introduce
    any new problems.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org	# 3.12+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa
Author: David S. Miller <davem@davemloft.net>
Date:   Sat May 17 11:28:05 2014 -0700

    sparc64: Add membar to Niagara2 memcpy code.
    
    This is the prevent previous stores from overlapping the block stores
    done by the memcpy loop.
    
    Based upon a glibc patch by Jose E. Marchesi
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a8d0d8417c0bdc870d28afb83bc12e61a818efa3
Merge: 6bd64ac f60c370
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 16 22:29:17 2014 -0400

    Merge branch 'bond_stacked_vlans'
    
    Vlad Yasevich says:
    
    ====================
    Fixed stacked vlan usage on top of bonds
    
    Bonding device driver now support q-in-q on top for bonds.  There are
    a few issues here though.
    
    First, when arp monitoring is used, bonding driver will not correctly
    tag traffic if the source of the arp device was configured on top of
    q-in-q.  It may also incorrectly pick the wrong vlan id if the ordering
    of that upper devices isn't as expected (there is no guarntee on ordering).
    
    Second, the alb/tlb may use what would be considered 'inner' vlans in
    its learning announcements, as it simply announces all vlans configured
    on top of the bond without regard for encapsulation/stacking.
    
    This series fixes the above 2 issues.  This series also depends on the
    functionality introduced in
    	http://patchwork.ozlabs.org/patch/349766/
    
    Since v1:
      - Changed how patch1 verifies the device path.  We no longer use the
        _all_upper version of the function.  We find the path and if it was
        found, then collect the vlan information.
      - Use the constant to devine maximum vlan nest level support on top
        of bonding.  This can be changed if 2 is too low.
      - Inlude patch2 into the series.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f60c3704e87d39356d00c71bf51e55c2c55ad4f5
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:20:39 2014 -0400

    bonding: Fix alb mode to only use first level vlans.
    
    ALB/TLB learning packets use all vlans configured on top
    of the bond.  This ends up being incorrect if we have a stack
    of vlans on top of the bond.  ALB/TLB should only use
    first level/outer most vlans in its announcements.
    
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 44a4085538c844e79d6ee6bcf46fabf7c57a9a38
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:20:38 2014 -0400

    bonding: Fix stacked device detection in arp monitoring
    
    Prior to commit fbd929f2dce460456807a51e18d623db3db9f077
    	bonding: support QinQ for bond arp interval
    
    the arp monitoring code allowed for proper detection of devices
    stacked on top of vlans.  Since the above commit, the
    code can still detect a device stacked on top of single
    vlan, but not a device stacked on top of Q-in-Q configuration.
    The search will only set the inner vlan tag if the route
    device is the vlan device.  However, this is not always the
    case, as it is possible to extend the stacked configuration.
    
    With this patch it is possible to provision devices on
    top Q-in-Q vlan configuration that should be used as
    a source of ARP monitoring information.
    
    For example:
    ip link add link bond0 vlan10 type vlan proto 802.1q id 10
    ip link add link vlan10 vlan100 type vlan proto 802.1q id 100
    ip link add link vlan100 type macvlan
    
    Note:  This patch limites the number of stacked VLANs to 2,
    just like before.  The original, however had another issue
    in that if we had more then 2 levels of VLANs, we would end
    up generating incorrectly tagged traffic.  This is no longer
    possible.
    
    Fixes: fbd929f2dce460456807a51e18d623db3db9f077 (bonding: support QinQ for bond arp interval)
    CC: Jay Vosburgh <j.vosburgh@gmail.com>
    CC: Veaceslav Falico <vfalico@redhat.com>
    CC: Andy Gospodarek <andy@greyhouse.net>
    CC: Ding Tianhong <dingtianhong@huawei.com>
    CC: Patric McHardy <kaber@trash.net>
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f9c6d4987b23e0a514464bae6771933a48e4cd01
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri May 16 21:40:41 2014 -0400

    random: fix BUG_ON caused by accounting simplification
    
    Commit ee1de406ba6eb1 ("random: simplify accounting logic") simplified
    things too much, in that it allows the following to trigger an
    overflow that results in a BUG_ON crash:
    
    dd if=/dev/urandom of=/dev/zero bs=67108707 count=1
    
    Thanks to Peter Zihlstra for discovering the crash, and Hannes
    Frederic for analyizing the root cause.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reported-by: Peter Zijlstra <peterz@infradead.org>
    Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Cc: Greg Price <price@mit.edu>

commit 6bd64ac0f9c264082241da0db0dcc72a13e672a8
Merge: 29e9824 c674ac3
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 16 22:15:23 2014 -0400

    Merge branch 'stacked_netdevice_locking'
    
    Vlad Yasevich says:
    
    ====================
    Fix lockdep issues with stacked devices
    
    Recent commit dc8eaaa006350d24030502a4521542e74b5cb39f
        vlan: Fix lockdep warning when vlan dev handle notification
    
    attempted to solve lockdep issues with vlans where multiple
    vlans were stacked.  However, the code does not work correctly
    when the vlan stack is interspersed with other devices in between
    the vlans.  Additionally, similar lockdep issues show up with other
    devices.
    
    This series provides a generic way to solve these issue for any
    devices that can be stacked.  It also addresses the concern for
    vlan and macvlan devices.  I am not sure whether it makes sense
    to do so for other types like team, vxlan, and bond.
    
    Thanks
    -vlad
    
    Since v2:
      - Remove rcu variants from patch1, since that function is called
        only under rtnl.
      - Fix whitespace problems reported by checkpatch
    
    Since v1:
      - Fixed up a goofed-up rebase.
        * is_vlan_dev() should be bool and that change belongs in patch3.
        * patch4 should not have any vlan changes in it.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c674ac30c549596295eb0a5af7f4714c0b905b6f
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:04:56 2014 -0400

    macvlan: Fix lockdep warnings with stacked macvlan devices
    
    Macvlan devices try to avoid stacking, but that's not always
    successfull or even desired.  As an example, the following
    configuration is perefectly legal and valid:
    
    eth0 <--- macvlan0 <---- vlan0.10 <--- macvlan1
    
    However, this configuration produces the following lockdep
    trace:
    [  115.620418] ======================================================
    [  115.620477] [ INFO: possible circular locking dependency detected ]
    [  115.620516] 3.15.0-rc1+ #24 Not tainted
    [  115.620540] -------------------------------------------------------
    [  115.620577] ip/1704 is trying to acquire lock:
    [  115.620604]  (&vlan_netdev_addr_lock_key/1){+.....}, at: [<ffffffff815df49c>] dev_uc_sync+0x3c/0x80
    [  115.620686]
    but task is already holding lock:
    [  115.620723]  (&macvlan_netdev_addr_lock_key){+.....}, at: [<ffffffff815da5be>] dev_set_rx_mode+0x1e/0x40
    [  115.620795]
    which lock already depends on the new lock.
    
    [  115.620853]
    the existing dependency chain (in reverse order) is:
    [  115.620894]
    -> #1 (&macvlan_netdev_addr_lock_key){+.....}:
    [  115.620935]        [<ffffffff810d57f2>] lock_acquire+0xa2/0x130
    [  115.620974]        [<ffffffff816f62e7>] _raw_spin_lock_nested+0x37/0x50
    [  115.621019]        [<ffffffffa07296c3>] vlan_dev_set_rx_mode+0x53/0x110 [8021q]
    [  115.621066]        [<ffffffff815da557>] __dev_set_rx_mode+0x57/0xa0
    [  115.621105]        [<ffffffff815da5c6>] dev_set_rx_mode+0x26/0x40
    [  115.621143]        [<ffffffff815da6be>] __dev_open+0xde/0x140
    [  115.621174]        [<ffffffff815da9ad>] __dev_change_flags+0x9d/0x170
    [  115.621174]        [<ffffffff815daaa9>] dev_change_flags+0x29/0x60
    [  115.621174]        [<ffffffff815e7f11>] do_setlink+0x321/0x9a0
    [  115.621174]        [<ffffffff815ea59f>] rtnl_newlink+0x51f/0x730
    [  115.621174]        [<ffffffff815e6e75>] rtnetlink_rcv_msg+0x95/0x250
    [  115.621174]        [<ffffffff81608b19>] netlink_rcv_skb+0xa9/0xc0
    [  115.621174]        [<ffffffff815e6dca>] rtnetlink_rcv+0x2a/0x40
    [  115.621174]        [<ffffffff81608150>] netlink_unicast+0xf0/0x1c0
    [  115.621174]        [<ffffffff8160851f>] netlink_sendmsg+0x2ff/0x740
    [  115.621174]        [<ffffffff815bc9db>] sock_sendmsg+0x8b/0xc0
    [  115.621174]        [<ffffffff815bd4b9>] ___sys_sendmsg+0x369/0x380
    [  115.621174]        [<ffffffff815bdbb2>] __sys_sendmsg+0x42/0x80
    [  115.621174]        [<ffffffff815bdc02>] SyS_sendmsg+0x12/0x20
    [  115.621174]        [<ffffffff816ffd69>] system_call_fastpath+0x16/0x1b
    [  115.621174]
    -> #0 (&vlan_netdev_addr_lock_key/1){+.....}:
    [  115.621174]        [<ffffffff810d4d43>] __lock_acquire+0x1773/0x1a60
    [  115.621174]        [<ffffffff810d57f2>] lock_acquire+0xa2/0x130
    [  115.621174]        [<ffffffff816f62e7>] _raw_spin_lock_nested+0x37/0x50
    [  115.621174]        [<ffffffff815df49c>] dev_uc_sync+0x3c/0x80
    [  115.621174]        [<ffffffffa0696d2a>] macvlan_set_mac_lists+0xca/0x110 [macvlan]
    [  115.621174]        [<ffffffff815da557>] __dev_set_rx_mode+0x57/0xa0
    [  115.621174]        [<ffffffff815da5c6>] dev_set_rx_mode+0x26/0x40
    [  115.621174]        [<ffffffff815da6be>] __dev_open+0xde/0x140
    [  115.621174]        [<ffffffff815da9ad>] __dev_change_flags+0x9d/0x170
    [  115.621174]        [<ffffffff815daaa9>] dev_change_flags+0x29/0x60
    [  115.621174]        [<ffffffff815e7f11>] do_setlink+0x321/0x9a0
    [  115.621174]        [<ffffffff815ea59f>] rtnl_newlink+0x51f/0x730
    [  115.621174]        [<ffffffff815e6e75>] rtnetlink_rcv_msg+0x95/0x250
    [  115.621174]        [<ffffffff81608b19>] netlink_rcv_skb+0xa9/0xc0
    [  115.621174]        [<ffffffff815e6dca>] rtnetlink_rcv+0x2a/0x40
    [  115.621174]        [<ffffffff81608150>] netlink_unicast+0xf0/0x1c0
    [  115.621174]        [<ffffffff8160851f>] netlink_sendmsg+0x2ff/0x740
    [  115.621174]        [<ffffffff815bc9db>] sock_sendmsg+0x8b/0xc0
    [  115.621174]        [<ffffffff815bd4b9>] ___sys_sendmsg+0x369/0x380
    [  115.621174]        [<ffffffff815bdbb2>] __sys_sendmsg+0x42/0x80
    [  115.621174]        [<ffffffff815bdc02>] SyS_sendmsg+0x12/0x20
    [  115.621174]        [<ffffffff816ffd69>] system_call_fastpath+0x16/0x1b
    [  115.621174]
    other info that might help us debug this:
    
    [  115.621174]  Possible unsafe locking scenario:
    
    [  115.621174]        CPU0                    CPU1
    [  115.621174]        ----                    ----
    [  115.621174]   lock(&macvlan_netdev_addr_lock_key);
    [  115.621174]                                lock(&vlan_netdev_addr_lock_key/1);
    [  115.621174]                                lock(&macvlan_netdev_addr_lock_key);
    [  115.621174]   lock(&vlan_netdev_addr_lock_key/1);
    [  115.621174]
     *** DEADLOCK ***
    
    [  115.621174] 2 locks held by ip/1704:
    [  115.621174]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815e6dbb>] rtnetlink_rcv+0x1b/0x40
    [  115.621174]  #1:  (&macvlan_netdev_addr_lock_key){+.....}, at: [<ffffffff815da5be>] dev_set_rx_mode+0x1e/0x40
    [  115.621174]
    stack backtrace:
    [  115.621174] CPU: 3 PID: 1704 Comm: ip Not tainted 3.15.0-rc1+ #24
    [  115.621174] Hardware name: Hewlett-Packard HP xw8400 Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
    [  115.621174]  ffffffff82339ae0 ffff880465f79568 ffffffff816ee20c ffffffff82339ae0
    [  115.621174]  ffff880465f795a8 ffffffff816e9e1b ffff880465f79600 ffff880465b019c8
    [  115.621174]  0000000000000001 0000000000000002 ffff880465b019c8 ffff880465b01230
    [  115.621174] Call Trace:
    [  115.621174]  [<ffffffff816ee20c>] dump_stack+0x4d/0x66
    [  115.621174]  [<ffffffff816e9e1b>] print_circular_bug+0x200/0x20e
    [  115.621174]  [<ffffffff810d4d43>] __lock_acquire+0x1773/0x1a60
    [  115.621174]  [<ffffffff810d3172>] ? trace_hardirqs_on_caller+0xb2/0x1d0
    [  115.621174]  [<ffffffff810d57f2>] lock_acquire+0xa2/0x130
    [  115.621174]  [<ffffffff815df49c>] ? dev_uc_sync+0x3c/0x80
    [  115.621174]  [<ffffffff816f62e7>] _raw_spin_lock_nested+0x37/0x50
    [  115.621174]  [<ffffffff815df49c>] ? dev_uc_sync+0x3c/0x80
    [  115.621174]  [<ffffffff815df49c>] dev_uc_sync+0x3c/0x80
    [  115.621174]  [<ffffffffa0696d2a>] macvlan_set_mac_lists+0xca/0x110 [macvlan]
    [  115.621174]  [<ffffffff815da557>] __dev_set_rx_mode+0x57/0xa0
    [  115.621174]  [<ffffffff815da5c6>] dev_set_rx_mode+0x26/0x40
    [  115.621174]  [<ffffffff815da6be>] __dev_open+0xde/0x140
    [  115.621174]  [<ffffffff815da9ad>] __dev_change_flags+0x9d/0x170
    [  115.621174]  [<ffffffff815daaa9>] dev_change_flags+0x29/0x60
    [  115.621174]  [<ffffffff811e1db1>] ? mem_cgroup_bad_page_check+0x21/0x30
    [  115.621174]  [<ffffffff815e7f11>] do_setlink+0x321/0x9a0
    [  115.621174]  [<ffffffff810d394c>] ? __lock_acquire+0x37c/0x1a60
    [  115.621174]  [<ffffffff815ea59f>] rtnl_newlink+0x51f/0x730
    [  115.621174]  [<ffffffff815ea169>] ? rtnl_newlink+0xe9/0x730
    [  115.621174]  [<ffffffff815e6e75>] rtnetlink_rcv_msg+0x95/0x250
    [  115.621174]  [<ffffffff810d329d>] ? trace_hardirqs_on+0xd/0x10
    [  115.621174]  [<ffffffff815e6dbb>] ? rtnetlink_rcv+0x1b/0x40
    [  115.621174]  [<ffffffff815e6de0>] ? rtnetlink_rcv+0x40/0x40
    [  115.621174]  [<ffffffff81608b19>] netlink_rcv_skb+0xa9/0xc0
    [  115.621174]  [<ffffffff815e6dca>] rtnetlink_rcv+0x2a/0x40
    [  115.621174]  [<ffffffff81608150>] netlink_unicast+0xf0/0x1c0
    [  115.621174]  [<ffffffff8160851f>] netlink_sendmsg+0x2ff/0x740
    [  115.621174]  [<ffffffff815bc9db>] sock_sendmsg+0x8b/0xc0
    [  115.621174]  [<ffffffff8119d4af>] ? might_fault+0x5f/0xb0
    [  115.621174]  [<ffffffff8119d4f8>] ? might_fault+0xa8/0xb0
    [  115.621174]  [<ffffffff8119d4af>] ? might_fault+0x5f/0xb0
    [  115.621174]  [<ffffffff815cb51e>] ? verify_iovec+0x5e/0xe0
    [  115.621174]  [<ffffffff815bd4b9>] ___sys_sendmsg+0x369/0x380
    [  115.621174]  [<ffffffff816faa0d>] ? __do_page_fault+0x11d/0x570
    [  115.621174]  [<ffffffff810cfe9f>] ? up_read+0x1f/0x40
    [  115.621174]  [<ffffffff816fab04>] ? __do_page_fault+0x214/0x570
    [  115.621174]  [<ffffffff8120a10b>] ? mntput_no_expire+0x6b/0x1c0
    [  115.621174]  [<ffffffff8120a0b7>] ? mntput_no_expire+0x17/0x1c0
    [  115.621174]  [<ffffffff8120a284>] ? mntput+0x24/0x40
    [  115.621174]  [<ffffffff815bdbb2>] __sys_sendmsg+0x42/0x80
    [  115.621174]  [<ffffffff815bdc02>] SyS_sendmsg+0x12/0x20
    [  115.621174]  [<ffffffff816ffd69>] system_call_fastpath+0x16/0x1b
    
    Fix this by correctly providing macvlan lockdep class.
    
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d38569ab2bba6e6b3233acfc3a84cdbcfbd1f79f
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:04:55 2014 -0400

    vlan: Fix lockdep warning with stacked vlan devices.
    
    This reverts commit dc8eaaa006350d24030502a4521542e74b5cb39f.
    	vlan: Fix lockdep warning when vlan dev handle notification
    
    Instead we use the new new API to find the lock subclass of
    our vlan device.  This way we can support configurations where
    vlans are interspersed with other devices:
      bond -> vlan -> macvlan -> vlan
    
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 25175ba5c9bff9aaf0229df34bb5d54c81633ec3
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:04:54 2014 -0400

    net: Allow for more then a single subclass for netif_addr_lock
    
    Currently netif_addr_lock_nested assumes that there can be only
    a single nesting level between 2 devices.  However, if we
    have multiple devices of the same type stacked, this fails.
    For example:
     eth0 <-- vlan0.10 <-- vlan0.10.20
    
    A more complicated configuration may stack more then one type of
    device in different order.
    Ex:
      eth0 <-- vlan0.10 <-- macvlan0 <-- vlan1.10.20 <-- macvlan1
    
    This patch adds an ndo_* function that allows each stackable
    device to report its nesting level.  If the device doesn't
    provide this function default subclass of 1 is used.
    
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 4085ebe8c31face855fd01ee40372cb4aab1df3a
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Fri May 16 17:04:53 2014 -0400

    net: Find the nesting level of a given device by type.
    
    Multiple devices in the kernel can be stacked/nested and they
    need to know their nesting level for the purposes of lockdep.
    This patch provides a generic function that determines a nesting
    level of a particular device by its type (ex: vlan, macvlan, etc).
    We only care about nesting of the same type of devices.
    
    For example:
      eth0 <- vlan0.10 <- macvlan0 <- vlan1.20
    
    The nesting level of vlan1.20 would be 1, since there is another vlan
    in the stack under it.
    
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d2c834abe2b39a2d5a6c38ef44de87c97cbb34b4
Author: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Date:   Fri May 16 16:50:20 2014 +0300

    clk: tegra: Fix wrong value written to PLLE_AUX
    
    The value written to PLLE_AUX was incorrect due to a wrong variable
    being used. Without this fix SATA does not work.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
    Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
    Reviewed-by: Thierry Reding <treding@nvidia.com>
    Tested-by: Thierry Reding <treding@nvidia.com>
    Acked-by: Thierry Reding <treding@nvidia.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>
    [mturquette@linaro.org: improved changelog]

commit bb4e506565cfc0a2f534dfda1fb7ca5c26f7a604
Author: Jes Sorensen <Jes.Sorensen@redhat.com>
Date:   Fri May 16 22:59:18 2014 +0200

    staging: rtl8723au: Do not reset wdev->iftype in netdev_close()
    
    wdev->ifdev should be set by .change_virtual_intf(). This solves the
    problem of WARN() messages on module unload.
    
    Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9ce2482fc6b22709df087d4a8387b67893176312
Author: Tony Lindgren <tony@atomide.com>
Date:   Fri May 16 14:05:35 2014 -0700

    ARM: OMAP2+: Fix DMA hang after off-idle
    
    Commit 6ddeb6d84459 (dmaengine: omap-dma: move IRQ handling to omap-dma)
    added support for handling interrupts in the omap dmaengine driver
    instead of the legacy driver. Because of different handling for
    interrupts this however caused omap3 to hang eventually after hitting
    off-idle.
    
    Any of the virtual 32 DMA channels can be assigned to any of the
    four DMA interrupts. So commit 6ddeb6d84459 made the omap dmaengine
    driver to use the second DMA interrupt while keeping the legacy code
    still using the first DMA interrupt.
    
    This means we need to save and restore both IRQENABLE_L1 in addition
    to IRQENABLE_L0. As there is a chance that the DSP might be using
    IRQENABLE_L2 or IRQENABLE_L3 lines, let's not touch those until
    this has been confirmed. Let's just add a comment to the code for
    now.
    
    Fixes: 6ddeb6d84459 (dmaengine: omap-dma: move IRQ handling to omap-dma)
    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 5005e0b76781c37d0a16dd6dd17d015098e8ce92
Author: Roger Quadros <rogerq@ti.com>
Date:   Fri May 16 14:45:40 2014 -0700

    ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards
    
    Commit c66d039197e4 broke NAND for non-DT boot on all OMAP2 and OMAP3
    boards using board_nand_init(). Following error is seen at boot
    
    [    0.154998]  (null): Unsupported NAND ECC scheme selected
    
    For OMAP2 and OMAP3 platforms, the ecc_opt parameter in platform data
    must be set to OMAP_ECC_HAM1_CODE_HW to work properly.
    
    Tested on omap3-beagle c4.
    
    Fixes: c66d039197e4 (mtd: nand: omap: combine different flavours of 1-bit hamming ecc schemes)
    Cc: stable@vger.kernel.org # v3.12+
    Signed-off-by: Roger Quadros <rogerq@ti.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 658a0f4e661a6c07395de318a58f9058ba2faf8f
Merge: 68c8829 07d1d29
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Fri May 16 23:43:56 2014 +0200

    Merge branch 'acpi-video'
    
    * acpi-video:
      ACPI / video: Revert native brightness quirk for ThinkPad T530

commit 5c13190273870b7cf81b9367ad077322af035e80
Merge: 89ca3b8 0f9e19a
Author: Tony Lindgren <tony@atomide.com>
Date:   Fri May 16 14:43:40 2014 -0700

    Merge tag 'for-v3.15-rc/omap-fixes-b' of git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending into omap-for-v3.15/fixes-v3
    
    Two small OMAP fixes for v3.15-rc.  One fixes "slow motion" or
    "choppy" audio playback on OMAP5.  The other applies an OMAP3630 fix
    for clock rate setting for camera to other OMAP3 chips.
    
    Basic build, boot, and PM test results are available here:
    
    http://www.pwsan.com/omap/testlogs/prcm-fixes-b-v3.15-rc/20140514112639/

commit 29e98242783ed3ba569797846a606ba66f781625
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri May 16 11:34:37 2014 -0700

    net: gro: make sure skb->cb[] initial content has not to be zero
    
    Starting from linux-3.13, GRO attempts to build full size skbs.
    
    Problem is the commit assumed one particular field in skb->cb[]
    was clean, but it is not the case on some stacked devices.
    
    Timo reported a crash in case traffic is decrypted before
    reaching a GRE device.
    
    Fix this by initializing NAPI_GRO_CB(skb)->last at the right place,
    this also removes one conditional.
    
    Thanks a lot to Timo for providing full reports and bisecting this.
    
    Fixes: 8a29111c7ca6 ("net: gro: allow to build full sized skb")
    Bisected-by: Timo Teras <timo.teras@iki.fi>
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Tested-by: Timo Teräs <timo.teras@iki.fi>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 22fb22eaebf4d16987f3fd9c3484c436ee0badf2
Author: Timo Teräs <timo.teras@iki.fi>
Date:   Fri May 16 08:34:39 2014 +0300

    ipv4: ip_tunnels: disable cache for nbma gre tunnels
    
    The connected check fails to check for ip_gre nbma mode tunnels
    properly. ip_gre creates temporary tnl_params with daddr specified
    to pass-in the actual target on per-packet basis from neighbor
    layer. Detect these tunnels by inspecting the actual tunnel
    configuration.
    
    Minimal test case:
     ip route add 192.168.1.1/32 via 10.0.0.1
     ip route add 192.168.1.2/32 via 10.0.0.2
     ip tunnel add nbma0 mode gre key 1 tos c0
     ip addr add 172.17.0.0/16 dev nbma0
     ip link set nbma0 up
     ip neigh add 172.17.0.1 lladdr 192.168.1.1 dev nbma0
     ip neigh add 172.17.0.2 lladdr 192.168.1.2 dev nbma0
     ping 172.17.0.1
     ping 172.17.0.2
    
    The second ping should be going to 192.168.1.2 and head 10.0.0.2;
    but cached gre tunnel level route is used and it's actually going
    to 192.168.1.1 via 10.0.0.1.
    
    The lladdr's need to go to separate dst for the bug to trigger.
    Test case uses separate route entries, but this can also happen
    when the route entry is same: if there is a nexthop exception or
    the GRE tunnel is IPsec'ed in which case the dst points to xfrm
    bundle unique to the gre lladdr.
    
    Fixes: 7d442fab0a67 ("ipv4: Cache dst in tunnels")
    Signed-off-by: Timo Teräs <timo.teras@iki.fi>
    Cc: Tom Herbert <therbert@google.com>
    Cc: Eric Dumazet <edumazet@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d1c0b471b340f43fa857d19150e029257d7bb475
Author: Fabian Godehardt <fg@emlix.com>
Date:   Fri May 16 06:21:44 2014 +0200

    net/dsa/dsa.c: increment chip_index during of_node handling on dsa_of_probe()
    
    Adding more than one chip on device-tree currently causes the probing
    routine to always use the first chips data pointer.
    
    Signed-off-by: Fabian Godehardt <fg@emlix.com>
    Acked-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2e47b291953c35afa4e20a65475954c1a1b9afe1
Author: Lorenzo Colitti <lorenzo@google.com>
Date:   Thu May 15 16:38:41 2014 -0700

    net: ipv6: make "ip -6 route get mark xyz" work.
    
    Currently, "ip -6 route get mark xyz" ignores the mark passed in
    by userspace. Make it honour the mark, just like IPv4 does.
    
    Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2f67cc87d662e935d2cfaea5a3fb7138ac35c5de
Merge: 0d08fce cc2f338
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 16 16:28:53 2014 -0400

    Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
    
    Include changes:
    - fix NULL dereference in batadv_orig_hardif_seq_print_text()
    - fix reference counting imbalance when using fragmentation
    - avoid access to orig_node objects after they have been free'd
    - fix local TT check for outgoing arp requests in DAT

commit 0d08fceb2e21c30ca3e1e462e678723f806acf18
Author: David Vrabel <david.vrabel@citrix.com>
Date:   Fri May 16 12:26:04 2014 +0100

    xen-netback: fix race between napi_complete() and interrupt handler
    
    When the NAPI budget was not all used, xenvif_poll() would call
    napi_complete() /after/ enabling the interrupt.  This resulted in a
    race between the napi_complete() and the napi_schedule() in the
    interrupt handler.  The use of local_irq_save/restore() avoided by
    race iff the handler is running on the same CPU but not if it was
    running on a different CPU.
    
    Fix this properly by calling napi_complete() before reenabling
    interrupts (in the xenvif_napi_schedule_or_enable_irq() call).
    
    Signed-off-by: David Vrabel <david.vrabel@citrix.com>
    Acked-by: Wei Liu <wei.liu2@citrix.com>
    Acked-by: Ian Campbell <ian.campbell@citrix.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 07d1d29ee1e194b932328ad2dc1d40297062ab7f
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Fri May 16 21:10:41 2014 +0200

    ACPI / video: Revert native brightness quirk for ThinkPad T530
    
    Seems it helps some users, but causes issues for other users:
    https://bugzilla.redhat.com/show_bug.cgi?id=1089545
    
    So lets drop it for now until we've figured out a better fix.
    
    Fixes: 43d949024425 (ACPI / video: Add use_native_backlight quirks for more systems)
    References: https://bugzilla.redhat.com/show_bug.cgi?id=1089545
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 202630b445d2618d94e4f099567fcee5618dab27
Merge: fde0133 025a58f
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 16 15:45:56 2014 -0400

    Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
    
    John W. Linville says:
    
    ====================
    pull request: wireless 2014-05-15
    
    Please pull this batch of fixes for the 3.15 stream...
    
    For the mac80211 bits, Johannes says:
    
    "One fix is to get better VHT performance and the other fixes tracing
    garbage or other potential issues with the interface name tracing."
    
    And...
    
    "This has a fix from Emmanuel for a problem I failed to fix - when
    association is in progress then it needs to be cancelled while
    suspending (I had fixed the same for authentication). Also included a
    fix from myself for a userspace API problem that hit the iw tool and a
    fix to the remain-on-channel framework."
    
    For the iwlwifi bits, Emmanuel says:
    
    "Alex fixes the scan by disabling the fragmented scan. David prevents
    scan offload while associated, the firmware seems not to like it. I
    fix a stupid bug I made in BT Coex, and fix a bad #ifdef clause in rate
    scaling.  Along with that there is a fix for a NULL pointer exception
    that can happen if we load the driver and our ISR gets called because
    the interrupt line is shared. The fix has been tested by the reporter."
    
    And...
    
    "We have here a fix from David Spinadel that makes a previous fix more
    complete, and an off-by-one issue fixed by Eliad in the same area.
    I fix the monitor that broke on the way."
    
    Beyond that...
    
    Daniel Kim's one-liner fixes a brcmfmac regression caused by a typo
    in an earlier commit..
    
    Rajkumar Manoharan fixes an ath9k oops reported by David Herrmann.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit fde0133b9cfa4e01b275e942ffc32fd78e27d27c
Author: Nathaniel W Filardo <nwf@cs.jhu.edu>
Date:   Thu May 15 15:51:22 2014 +0100

    af_rxrpc: Fix XDR length check in rxrpc key demarshalling.
    
    There may be padding on the ticket contained in the key payload, so just ensure
    that the claimed token length is large enough, rather than exactly the right
    size.
    
    Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 6e14a5eeb158215881ef4507833a3574d0dbad19
Author: Zhangfei Gao <zhangfei.gao@linaro.org>
Date:   Thu May 15 13:35:34 2014 +0800

    net: phy: resume phydev when going to RESUMING
    
    With commit be9dad1f9f26604fb ("net: phy: suspend phydev when going
    to HALTED"), an unused PHY device will be put in a low-power mode
    using BMCR_PDOWN. Some Ethernet drivers might be calling phy_start()
    and phy_stop() from ndo_open and ndo_close() respectively, while
    calling phy_connect() and phy_disconnect() from probe and remove.
    In such a case, the PHY will be powered down during the phy_stop()
    call, but will fail to be powered up in phy_start().
    This patch fixes this scenario.
    
    Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
    Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 0c2e3fa9583192b0255fa9ec0260350e6ed202bd
Merge: 81c7080 9433c18
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 16 15:13:18 2014 -0400

    Merge branch 'mlx4-net'
    
    Or Gerlitz says:
    
    ====================
    mlx4: Fix VF MAC address change under RoCE usage
    
    This short series provides proper handling for the case where a
    VF netdevice change their MAC address under a RoCE use case. The code
    it deals with was introduced in 3.15-rc1
    
    Prior to this series the source MAC used for the VM RoCE CM
    packets remains as before the MAC modification. Hence RoCE CM
    packets sent by the VF will not carry the same source MAC
    address as the non-CM packets.
    
    Earlier 3.15-rc commit f24f790 "net/mlx4_core: Load the Eth driver
    first" handled just one instance of the problem, but this one
    provides a more generic and proper solution which covers all
    cases of VF mac change.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 9433c188915c1383ee36259119bc3a9c6f98cfc3
Author: Matan Barak <matanb@mellanox.com>
Date:   Thu May 15 15:29:28 2014 +0300

    IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC changes
    
    When we receive a netdev event indicating a netdev change and/or
    a netdev address change, we must change the MAC index used by the
    proxy QP1 (in the QP context), otherwise RoCE CM packets sent by the
    VF will not carry the same source MAC address as the non-CM packets.
    
    We use the UPDATE_QP command to perform this change.
    
    In order to avoid modifying a QP context based on netdev event,
    while the driver attempts to destroy this QP (e.g either the mlx4_ib
    or ib_mad modules are unloaded), we use mutex locking in both flows.
    
    Since the relevant mlx4 proxy GSI QP is created indirectly by the
    mad module when they create their GSI QP, the mlx4 didn't need to
    keep track on that QP prior to this change.
    
    Now, when QP modifications are needed to this QP from within the
    driver, we added refernece to it.
    
    Signed-off-by: Matan Barak <matanb@mellanox.com>
    Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ce8d9e0d6746ff67c1870386b7121a4448f21130
Author: Matan Barak <matanb@mellanox.com>
Date:   Thu May 15 15:29:27 2014 +0300

    net/mlx4_core: Add UPDATE_QP SRIOV wrapper support
    
    This patch adds UPDATE_QP SRIOV wrapper support.
    
    The mechanism is a general one, but currently only source MAC
    index changes are allowed for VFs.
    
    Signed-off-by: Matan Barak <matanb@mellanox.com>
    Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit be02f259fda66bcfc60ecd78a819e1ce28c8bfb9
Author: Jes Sorensen <Jes.Sorensen@redhat.com>
Date:   Fri May 16 10:05:04 2014 +0200

    staging: rtl8723au: Use correct pipe type for USB interrupts
    
    Use a correct pipe type when filling un interrupt urbs. This should
    finally take care of the WARN() messages on the console when USB urbs
    are submitted.
    
    Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f140662f35a7332b5c3188ee667856323783ed5a
Author: Ilya Dryomov <ilya.dryomov@inktank.com>
Date:   Fri May 9 18:27:34 2014 +0400

    crush: decode and initialize chooseleaf_vary_r
    
    Commit e2b149cc4ba0 ("crush: add chooseleaf_vary_r tunable") added the
    crush_map::chooseleaf_vary_r field but missed the decode part.  This
    lead to misdirected requests caused by incorrect raw crush mapping
    sets.
    
    Fixes: http://tracker.ceph.com/issues/8226
    
    Reported-and-Tested-by: Dmitry Smirnov <onlyjob@member.fsf.org>
    Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
    Reviewed-by: Sage Weil <sage@inktank.com>

commit 178eda29ca721842f2146378e73d43e0044c4166
Author: Chunwei Chen <tuxoko@gmail.com>
Date:   Wed Apr 23 12:35:09 2014 +0800

    libceph: fix corruption when using page_count 0 page in rbd
    
    It has been reported that using ZFSonLinux on rbd will result in memory
    corruption. The bug report can be found here:
    
    https://github.com/zfsonlinux/spl/issues/241
    http://tracker.ceph.com/issues/7790
    
    The reason is that ZFS will send pages with page_count 0 into rbd, which in
    turns send them to tcp_sendpage. However, tcp_sendpage cannot deal with
    page_count 0, as it will do get_page and put_page, and erroneously free the
    page.
    
    This type of issue has been noted before, and handled in iscsi, drbd,
    etc. So, rbd should also handle this. This fix address this issue by fall back
    to slower sendmsg when page_count 0 detected.
    
    Cc: Sage Weil <sage@inktank.com>
    Cc: Yehuda Sadeh <yehuda@inktank.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
    Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 4797ec2dc83a43be35bad56037d1b53db9e2b5d5
Author: Mark Salter <msalter@redhat.com>
Date:   Thu May 15 15:19:22 2014 +0100

    arm64: fix pud_huge() for 2-level pagetables
    
    The following happens when trying to run a kvm guest on a kernel
    configured for 64k pages. This doesn't happen with 4k pages:
    
      BUG: failure at include/linux/mm.h:297/put_page_testzero()!
      Kernel panic - not syncing: BUG!
      CPU: 2 PID: 4228 Comm: qemu-system-aar Tainted: GF            3.13.0-0.rc7.31.sa2.k32v1.aarch64.debug #1
      Call trace:
      [<fffffe0000096034>] dump_backtrace+0x0/0x16c
      [<fffffe00000961b4>] show_stack+0x14/0x1c
      [<fffffe000066e648>] dump_stack+0x84/0xb0
      [<fffffe0000668678>] panic+0xf4/0x220
      [<fffffe000018ec78>] free_reserved_area+0x0/0x110
      [<fffffe000018edd8>] free_pages+0x50/0x88
      [<fffffe00000a759c>] kvm_free_stage2_pgd+0x30/0x40
      [<fffffe00000a5354>] kvm_arch_destroy_vm+0x18/0x44
      [<fffffe00000a1854>] kvm_put_kvm+0xf0/0x184
      [<fffffe00000a1938>] kvm_vm_release+0x10/0x1c
      [<fffffe00001edc1c>] __fput+0xb0/0x288
      [<fffffe00001ede4c>] ____fput+0xc/0x14
      [<fffffe00000d5a2c>] task_work_run+0xa8/0x11c
      [<fffffe0000095c14>] do_notify_resume+0x54/0x58
    
    In arch/arm/kvm/mmu.c:unmap_range(), we end up doing an extra put_page()
    on the stage2 pgd which leads to the BUG in put_page_testzero(). This
    happens because a pud_huge() test in unmap_range() returns true when it
    should always be false with 2-level pages tables used by 64k pages.
    This patch removes support for huge puds if 2-level pagetables are
    being used.
    
    Signed-off-by: Mark Salter <msalter@redhat.com>
    [catalin.marinas@arm.com: removed #ifndef around PUD_SIZE check]
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
    Cc: <stable@vger.kernel.org> # v3.11+

commit dfc44f8030653b345fc6fb337558c3a07536823f
Author: Leif Lindholm <leif.lindholm@linaro.org>
Date:   Thu Apr 17 18:42:00 2014 +0100

    mips: dts: Fix missing device_type="memory" property in memory nodes
    
    A few platforms lack a 'device_type = "memory"' for their memory
    nodes, relying on an old ppc quirk in order to discover its memory.
    Add the missing data so that all parsing code can find memory nodes
    correctly.
    
    Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
    Cc: linux-mips@linux-mips.org
    Cc: devicetree@vger.kernel.org
    Cc: Mark Rutland <mark.rutland@arm.com>
    Cc: <stable@vger.kernel.org>
    Acked-by: John Crispin <blogic@openwrt.org>
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

commit bfaed5abad998bfc88a66e6e71c7b08dcf82f04e
Author: Leif Lindholm <leif.lindholm@linaro.org>
Date:   Thu Apr 17 18:41:59 2014 +0100

    arm: dts: Fix missing device_type="memory" for ste-ccu8540
    
    The current .dts for ste-ccu8540 lacks a 'device_type = "memory"' for
    its memory node, relying on an old ppc quirk in order to discover its
    memory. Fix the data so that all parsing code can handle it correctly.
    
    Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
    Acked-by: Lee Jones <lee.jones@linaro.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Cc: linux-arm-kernel@lists.infradead.org
    Cc: devicetree@vger.kernel.org
    Cc: Mark Rutland <mark.rutland@arm.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

commit 81c708068dfedece038e07d818ba68333d8d885d
Author: Nikolay Aleksandrov <nikolay@redhat.com>
Date:   Thu May 15 13:35:23 2014 +0200

    bonding: fix out of range parameters for bond_intmax_tbl
    
    I've missed to add a NULL entry to the bond_intmax_tbl when I introduced
    it with the conversion of arp_interval so add it now.
    
    CC: Jay Vosburgh <j.vosburgh@gmail.com>
    CC: Veaceslav Falico <vfalico@gmail.com>
    CC: Andy Gospodarek <andy@greyhouse.net>
    
    Fixes: 7bdb04ed0dbf ("bonding: convert arp_interval to use the new option API")
    Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
    Acked-by: Veaceslav Falico <vfalico@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 583757446ba6850eff96cef6565d729266da9c5b
Author: Zoltan Kiss <zoltan.kiss@citrix.com>
Date:   Thu May 15 11:08:34 2014 +0100

    xen-netback: Fix grant ref resolution in RX path
    
    The original series for reintroducing grant mapping for netback had a patch [1]
    to handle receiving of packets from an another VIF. Grant copy on the receiving
    side needs the grant ref of the page to set up the op.
    The original patch assumed (wrongly) that the frags array haven't changed. In
    the case reported by Sander, the sending guest sent a packet where the linear
    buffer and the first frag were under PKT_PROT_LEN (=128) bytes.
    xenvif_tx_submit() then pulled up the linear area to 128 bytes, and ditched the
    first frag. The receiving side had an off-by-one problem when gathered the grant
    refs.
    This patch fixes that by checking whether the actual frag's page pointer is the
    same as the page in the original frag list. It can handle any kind of changes on
    the original frags array, like:
    - removing granted frags from the array at any point
    - adding local pages to the frags list anywhere
    - reordering the frags
    It's optimized to the most common case, when there is 1:1 relation between the
    frags and the list, plus works optimal when frags are removed from the end or
    the beginning.
    
    [1]: 3e2234: xen-netback: Handle foreign mapped pages on the guest RX path
    
    Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
    Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
    Acked-by: Ian Campbell <ian.campbell@citrix.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit be7a010d6fa33dca9327ad8e91844278dfd1e712
Author: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Date:   Thu May 15 15:56:14 2014 +0800

    ipv6: update Destination Cache entries when gateway turn into host
    
    RFC 4861 states in 7.2.5:
    
    	The IsRouter flag in the cache entry MUST be set based on the
             Router flag in the received advertisement.  In those cases
             where the IsRouter flag changes from TRUE to FALSE as a result
             of this update, the node MUST remove that router from the
             Default Router List and update the Destination Cache entries
             for all destinations using that neighbor as a router as
             specified in Section 7.3.3.  This is needed to detect when a
             node that is used as a router stops forwarding packets due to
             being configured as a host.
    
    Currently, when dealing with NA Message which IsRouter flag changes from
    TRUE to FALSE, the kernel only removes router from the Default Router List,
    and don't update the Destination Cache entries.
    
    Now in order to update those Destination Cache entries, i introduce
    function rt6_clean_tohost().
    
    Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
    Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f895f0cfbb77ff432bb6ae4df27b608adbe6573f
Merge: b394745 6d004d6
Author: David S. Miller <davem@davemloft.net>
Date:   Thu May 15 23:23:48 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
    
    Conflicts:
    	net/ipv4/ip_vti.c
    
    Steffen Klassert says:
    
    ====================
    pull request (net): ipsec 2014-05-15
    
    This pull request has a merge conflict in net/ipv4/ip_vti.c
    between commit 8d89dcdf80d8 ("vti: don't allow to add the same
    tunnel twice") and commit a32452366b72  ("vti4:Don't count header
    length twice"). It can be solved like it is done in linux-next.
    
    1) Fix a ipv6 xfrm output crash when a packet is rerouted
       by netfilter to not use IPsec.
    
    2) vti4 counts some header lengths twice leading to an incorrect
       device mtu. Fix this by counting these headers only once.
    
    3) We don't catch the case if an unsupported protocol is submitted
       to the xfrm protocol handlers, this can lead to NULL pointer
       dereferences. Fix this by adding the appropriate checks.
    
    4) vti6 may unregister pernet ops twice on init errors.
       Fix this by removing one of the calls to do it only once.
       From Mathias Krause.
    
    5) Set the vti tunnel mark before doing a lookup in the error
       handlers. Otherwise we don't find the correct xfrm state.
    ====================
    
    The conflict in ip_vti.c was simple, 'net' had a commit
    removing a line from vti_tunnel_init() and this tree
    being merged had a commit adding a line to the same
    location.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit b394745df2d9d4c30bf1bcc55773bec6f3bc7c67
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Wed May 14 13:12:49 2014 -0700

    net: phy: Don't call phy_resume if phy_init_hw failed
    
    After the call to phy_init_hw failed in phy_attach_direct, phy_detach is called
    to detach the phy device from its network device. If the attached driver is a
    generic phy driver, this also detaches the driver. Subsequently phy_resume
    is called, which assumes without checking that a driver is attached to the
    device. This will result in a crash such as
    
    Unable to handle kernel paging request for data at address 0xffffffffffffff90
    Faulting instruction address: 0xc0000000003a0e18
    Oops: Kernel access of bad area, sig: 11 [#1]
    ...
    NIP [c0000000003a0e18] .phy_attach_direct+0x68/0x17c
    LR [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c
    Call Trace:
    [c0000003fc0475d0] [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c (unreliable)
    [c0000003fc047670] [c0000000003a0ff8] .phy_connect_direct+0x28/0x98
    [c0000003fc047700] [c0000000003f0074] .of_phy_connect+0x4c/0xa4
    
    Only call phy_resume if phy_init_hw was successful.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 07b8dae38b09bcfede7e726f172e39b5ce8390d9
Author: Andy Grover <agrover@redhat.com>
Date:   Wed May 14 15:48:06 2014 -0700

    target: Don't allow setting WC emulation if device doesn't support
    
    Just like for pSCSI, if the transport sets get_write_cache, then it is
    not valid to enable write cache emulation for it. Return an error.
    
    see https://bugzilla.redhat.com/show_bug.cgi?id=1082675
    
    Reviewed-by: Chris Leech <cleech@redhat.com>
    Signed-off-by: Andy Grover <agrover@redhat.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 52d0aa7980cfee85c831b2969e659055395386d4
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed May 14 20:54:26 2014 +0000

    iscsi-target: Disable Immediate + Unsolicited Data with ISER Protection
    
    This patch explicitly disables Immediate + Unsolicited Data for ISER
    connections during login in iscsi_login_zero_tsih_s2() when protection
    has been enabled for the session by the underlying hardware.
    
    This is currently required because protection / signature memory regions
    (MRs) expect T10 PI to occur on RDMA READs + RDMA WRITEs transfers, and
    not on a immediate data payload associated with ISCSI_OP_SCSI_CMD, or
    unsolicited data-out associated with a ISCSI_OP_SCSI_DATA_OUT.
    
    v2 changes:
      - Add TARGET_PROT_DOUT_INSERT check (Sagi)
      - Add pr_debug noisemaker (Sagi)
      - Add goto to avoid early return from MRDSL check (nab)
    
    Cc: Sagi Grimberg <sagig@mellanox.com>
    Cc: Or Gerlitz <ogerlitz@mellanox.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit ed8ec8f707ed4760c124d47b27c93df8ec5b1eba
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon May 12 12:18:32 2014 -0700

    tcm_fc: Fix free-after-use regression in ft_free_cmd
    
    This patch fixes a free-after-use regression in ft_free_cmd(), where
    ft_sess_put() is called with cmd->sess after percpu_ida_free() has
    already released the tag.
    
    Fix this bug by saving the ft_sess pointer ahead of percpu_ida_free(),
    and pass it directly to ft_sess_put().
    
    The regression was originally introduced in v3.13-rc1 commit:
    
      commit 5f544cfac956971099e906f94568bc3fd1a7108a
      Author: Nicholas Bellinger <nab@daterainc.com>
      Date:   Mon Sep 23 12:12:42 2013 -0700
    
          tcm_fc: Convert to per-cpu command map pre-allocation of ft_cmd
    
    Reported-by: Jun Wu <jwu@stormojo.com>
    Cc: Mark Rustad <mark.d.rustad@intel.com>
    Cc: Robert Love <robert.w.love@intel.com>
    Cc: <stable@vger.kernel.org> #3.13+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7cbfcc953789ff864c2bf8365a82a3fba4869649
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Thu May 1 13:44:56 2014 -0700

    iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
    
    This patch changes an incorrect use of BUG_ON to instead generate a
    REJECT + PROTOCOL_ERROR in iscsit_process_nop_out() code.  This case
    can occur with traditional TCP where a flood of zeros in the data
    stream can reach this block for what is presumed to be a NOP-OUT with
    a solicited reply, but without a valid iscsi_cmd pointer.
    
    This incorrect BUG_ON was introduced during the v3.11-rc timeframe
    with the following commit:
    
    commit 778de368964c5b7e8100cde9f549992d521e9c89
    Author: Nicholas Bellinger <nab@linux-iscsi.org>
    Date:   Fri Jun 14 16:07:47 2013 -0700
    
        iscsi/isert-target: Refactor ISCSI_OP_NOOP RX handling
    
    Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
    Cc: stable@vger.kernel.org # 3.11+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Tue Apr 29 13:13:47 2014 +0300

    Target/iscsi,iser: Avoid accepting transport connections during stop stage
    
    When the target is in stop stage, iSER transport initiates RDMA disconnects.
    The iSER initiator may wish to establish a new connection over the
    still existing network portal. In this case iSER transport should not
    accept and resume new RDMA connections. In order to learn that, iscsi_np
    is added with enabled flag so the iSER transport can check when deciding
    weather to accept and resume a new connection request.
    
    The iscsi_np is enabled after successful transport setup, and disabled
    before iscsi_np login threads are cleaned up.
    
    Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 531b7bf4bd795d9a09eac92504322a472c010bc8
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Tue Apr 29 13:13:45 2014 +0300

    Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
    
    RDMA CM and iSCSI target flows are asynchronous and completely
    uncorrelated. Relying on the fact that iscsi_accept_np will be called
    after CM connection request event and will wait for it is a mistake.
    
    When attempting to login to a few targets this flow is racy and
    unpredictable, but for parallel login to dozens of targets will
    race and hang every time.
    
    The correct synchronizing mechanism in this case is pending on
    a semaphore rather than a wait_for_event. We keep the pending
    interruptible for iscsi_np cleanup stage.
    
    (Squash patch to remove dead code into parent - nab)
    
    Reported-by: Slava Shwartsman <valyushash@gmail.com>
    Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 9fe63c88b1d59f1ce054d6948ccd3096496ecedb
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Tue Apr 29 13:13:44 2014 +0300

    Target/iser: Fix wrong connection requests list addition
    
    Should be adding list_add_tail($new, $head) and not
    the other way around.
    
    Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
    Cc: stable@vger.kernel.org # 3.10+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 448ba904160f9d8f69217c28a1692cee5afbff88
Author: Andy Grover <agrover@redhat.com>
Date:   Tue Apr 15 14:13:12 2014 -0700

    target: Allow non-supporting backends to set pi_prot_type to 0
    
    Userspace tools assume if a value is read from configfs, it is valid
    and will not cause an error if the same value is written back. The only
    valid value for pi_prot_type for backends not supporting DIF is 0, so allow
    this particular value to be set without returning an error.
    
    Reported-by: Krzysztof Chojnowski <frirajder@gmail.com>
    Signed-off-by: Andy Grover <agrover@redhat.com>
    Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
    Cc: stable@vger.kernel.org # 3.14+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

commit 48f0459fb766415b63ba0e65d528262a9c23b4f7
Merge: 200b916 d91e5c0
Author: David S. Miller <davem@davemloft.net>
Date:   Thu May 15 16:46:54 2014 -0400

    Merge branch 'altera_tse'
    
    Vince Bridgers says:
    
    ====================
    Altera TSE: Fix Sparse errors and misc issues
    
    This is version 2 of a patch series to correct sparse errors, cppcheck
    warnings, and workaound a multicast filtering issue in the Altera TSE
    Ethernet driver. Multicast filtering is not working as expected, so if
    present in the hardware will not be used and promiscuous mode enabled
    instead. This workaround will be replaced with a working solution when
    completely debugged, integrated and tested.
    
    Version 2 is different from the first submission by breaking out the
    workaround as a seperate patch and addressing a few structure instance
    declarations by making them const per review comments.
    
    If you find this patch acceptable, please consider this for inclusion into
    the Altera TSE driver source code.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d91e5c02555ae838e9d783b9e83e125fd10dca73
Author: Vince Bridgers <vbridgers2013@gmail.com>
Date:   Wed May 14 14:38:37 2014 -0500

    Altera TSE: Disable Multicast filtering to workaround problem
    
    This patch disables multicast hash filtering if present in the hardware
    and uses promiscuous mode instead until the problem with multicast
    filtering has been debugged, integrated and tested.
    
    Signed-off-by: Vince Bridgers <vbridgers2013@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 898305806ad56ae11dc2c80931062e6a2c7bba48
Author: Vince Bridgers <vbridgers2013@gmail.com>
Date:   Wed May 14 14:38:36 2014 -0500

    Altera TSE: Fix sparse errors and warnings
    
    This patch fixes the many sparse errors and warnings contained in the
    initial submission of the Altera Triple Speed Ethernet driver, and a
    few minor cppcheck warnings. Changes are tested on ARM and NIOS2
    example designs, and compile tested against multiple architectures.
    Typical issues addressed were as follows:
    
    altera_tse_ethtool.c:136:19: warning: incorrect type in argument
        1 (different address spaces)
    altera_tse_ethtool.c:136:19:    expected void const volatile
        [noderef] <asn:2>*addr
    altera_tse_ethtool.c:136:19:    got unsigned int *<noident>
    ...
    altera_sgdma.c:129:31: warning: cast removes address space of
        expression
    
    Signed-off-by: Vince Bridgers <vbridgers2013@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 5513a510fad73594e29e1e48e760e0a644a8a4f3
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Wed May 14 21:57:26 2014 -0400

    nfsd4: fix corruption on setting an ACL.
    
    As of 06f9cc12caa862f5bc86ebdb4f77568a4bef0167 "nfsd4: don't create
    unnecessary mask acl", any non-trivial ACL will be left with an
    unitialized entry, and a trivial ACL may write one entry beyond what's
    allocated.
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit 200b916f3575bdf11609cb447661b8d5957b0bbf
Author: Cong Wang <cwang@twopensource.com>
Date:   Mon May 12 15:11:20 2014 -0700

    rtnetlink: wait for unregistering devices in rtnl_link_unregister()
    
    From: Cong Wang <cwang@twopensource.com>
    
    commit 50624c934db18ab90 (net: Delay default_device_exit_batch until no
    devices are unregistering) introduced rtnl_lock_unregistering() for
    default_device_exit_batch(). Same race could happen we when rmmod a driver
    which calls rtnl_link_unregister() as we call dev->destructor without rtnl
    lock.
    
    For long term, I think we should clean up the mess of netdev_run_todo()
    and net namespce exit code.
    
    Cc: Eric W. Biederman <ebiederm@xmission.com>
    Cc: David S. Miller <davem@davemloft.net>
    Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
    Signed-off-by: Cong Wang <cwang@twopensource.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c776cd89fc705fc8b5c2e5ad906bf5d791620fed
Author: John David Anglin <dave.anglin@bell.net>
Date:   Sun May 11 18:40:50 2014 -0400

    parisc: Improve LWS-CAS performance
    
    The attached change significantly improves the performance of the LWS-CAS code
    in syscall.S.
    This allows a number of packages to build (e.g., zeromq3, gtest and libxs)
    that previously failed because slow LWS-CAS performance under contention. In
    particular, interrupts taken while the lock was taken degraded performance
    significantly.
    
    The change does the following:
    
    1) Disables interrupts around the CAS operation, and
    2) Changes the loads and stores to use the ordered completer, "o", on
    PA 2.0. "o" and "ma" with a zero offset are equivalent. The latter is
    accepted on both PA 1.X and 2.0.
    
    The use of ordered loads and stores probably makes no difference on all
    existing hardware, but it seemed pedantically correct. In particular, the CAS
    operation must complete before LDCW lock is released. As written before, a
    processor could reorder the operations.
    
    I don't believe the period interrupts are disabled is long enough to
    significantly increase interrupt latency. For example, the TLB insert code is
    longer. Worst case is a memory fault in the CAS operation.
    
    Signed-off-by: John David Anglin <dave.anglin@bell.net>
    Cc: stable@vger.kernel.org # 3.13+
    Signed-off-by: Helge Deller <deller@gmx.de>

commit fef47e2a2e1e75fe50a10f634a80f16808348cc6
Author: Helge Deller <deller@gmx.de>
Date:   Mon May 5 18:07:12 2014 +0200

    parisc: ratelimit userspace segfault printing
    
    Ratelimit printing of userspace segfaults and make it runtime
    configurable via the /proc/sys/debug/exception-trace variable. This
    should resolve syslog from growing way too fast and thus prevents
    possible system service attacks.
    
    Signed-off-by: Helge Deller <deller@gmx.de>
    Cc: stable@vger.kernel.org # 3.13+

commit 93fa9d32670f5592c8e56abc9928fc194e1e72fc
Author: Marcel Apfelbaum <marcel.a@redhat.com>
Date:   Thu May 15 12:42:49 2014 -0600

    PCI: shpchp: Check bridge's secondary (not primary) bus speed
    
    When a new device is added below a hotplug bridge, the bridge's secondary
    bus speed and the device's bus speed must match.  The shpchp driver
    previously checked the bridge's *primary* bus speed, not the secondary bus
    speed.
    
    This caused hot-add errors like:
    
      shpchp 0000:00:03.0: Speed of bus ff and adapter 0 mismatch
    
    Check the secondary bus speed instead.
    
    [bhelgaas: changelog]
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=75251
    Fixes: 3749c51ac6c1 ("PCI: Make current and maximum bus speeds part of the PCI core")
    Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Michael S. Tsirkin <mst@redhat.com>
    CC: stable@vger.kernel.org	# v2.6.34+

commit cc2f33860cea0e48ebec096130bd0f7c4bf6e0bc
Author: Antonio Quartulli <antonio@open-mesh.com>
Date:   Sat Mar 29 17:27:38 2014 +0100

    batman-adv: fix local TT check for outgoing arp requests in DAT
    
    Change introduced by 88e48d7b3340ef07b108eb8a8b3813dd093cc7f7
    ("batman-adv: make DAT drop ARP requests targeting local clients")
    implements a check that prevents DAT from using the caching
    mechanism when the client that is supposed to provide a reply
    to an arp request is local.
    
    However change brought by be1db4f6615b5e6156c807ea8985171c215c2d57
    ("batman-adv: make the Distributed ARP Table vlan aware")
    has not converted the above check into its vlan aware version
    thus making it useless when the local client is behind a vlan.
    
    Fix the behaviour by properly specifying the vlan when
    checking for a client being local or not.
    
    Reported-by: Simon Wunderlich <simon@open-mesh.com>
    Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>

commit 377fe0f968b30a1a714fab53a908061914f30e26
Author: Antonio Quartulli <antonio@open-mesh.com>
Date:   Fri May 2 01:35:13 2014 +0200

    batman-adv: increase orig refcount when storing ref in gw_node
    
    A pointer to the orig_node representing a bat-gateway is
    stored in the gw_node->orig_node member, but the refcount
    for such orig_node is never increased.
    This leads to memory faults when gw_node->orig_node is accessed
    and the originator has already been freed.
    
    Fix this by increasing the refcount on gw_node creation
    and decreasing it on gw_node free.
    
    Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>

commit be181015a189cd141398b761ba4e79d33fe69949
Author: Antonio Quartulli <antonio@open-mesh.com>
Date:   Wed Apr 23 14:05:16 2014 +0200

    batman-adv: fix reference counting imbalance while sending fragment
    
    In the new fragmentation code the batadv_frag_send_packet()
    function obtains a reference to the primary_if, but it does
    not release it upon return.
    
    This reference imbalance prevents the primary_if (and then
    the related netdevice) to be properly released on shut down.
    
    Fix this by releasing the primary_if in batadv_frag_send_packet().
    
    Introduced by ee75ed88879af88558818a5c6609d85f60ff0df4
    ("batman-adv: Fragment and send skbs larger than mtu")
    
    Cc: Martin Hundebøll <martin@hundeboll.net>
    Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Acked-by: Martin Hundebøll <martin@hundeboll.net>

commit 16a4142363b11952d3aa76ac78004502c0c2fe6e
Author: Marek Lindner <mareklindner@neomailbox.ch>
Date:   Thu Apr 24 03:44:25 2014 +0800

    batman-adv: fix indirect hard_iface NULL dereference
    
    If hard_iface is NULL and goto out is made batadv_hardif_free_ref()
    doesn't check for NULL before dereferencing it to get to refcount.
    
    Introduced in cb1c92ec37fb70543d133a1fa7d9b54d6f8a1ecd
    ("batman-adv: add debugfs support to view multiif tables").
    
    Reported-by: Sven Eckelmann <sven@narfation.org>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Acked-by: Antonio Quartulli <antonio@meshcoding.com>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit 3b084e99a3fabaeb0f9c65a0806cde30f0b2835e
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu May 15 17:18:26 2014 +0200

    netfilter: nf_tables: fix trace of matching non-terminal rule
    
    Add the corresponding trace if we have a full match in a non-terminal
    rule. Note that the traces will look slightly different than in
    x_tables since the log message after all expressions have been
    evaluated (contrary to x_tables, that emits it before the target
    action). This manifests in two differences in nf_tables wrt. x_tables:
    
    1) The rule that enables the tracing is included in the trace.
    
    2) If the rule emits some log message, that is shown before the
       trace log message.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 025a58fd9d5785d63c398e96ac543db2639c7ddc
Merge: e84d2f8 faf1dc6
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu May 15 10:24:28 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem

commit 4c358e15553ed88bf2ddae422624624e1dd663d1
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu May 15 14:44:30 2014 +1000

    of: fix CONFIG_OF=n prototype of of_node_full_name()
    
    Make the CONFIG_OF=n prototpe of of_node_full_name() mateh the CONFIG_OF=y
    version.
    
    Fixes compile warnings like this:
    
    sound/soc/soc-core.c: In function 'soc_check_aux_dev':
    sound/soc/soc-core.c:1667:3: warning: passing argument 1 of 'of_node_full_name' discards 'const' qualifier from pointer target type [enabled by default]
       codecname = of_node_full_name(aux_dev->codec_of_node);
    
    when CONFIG_OF is not defined.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

commit a4e91d04b86504f145cc5f766c2609357a68b186
Merge: 16a9602 ebc3226
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu May 15 14:46:57 2014 +0200

    Merge tag 'kvm-s390-for-3.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master
    
    Here is a fix that aligns the irqfd code changes for 3.15
    with the right capability number. irqfd for s390x was
    introduced with 3.15-rc1, so this fix should still go into
    Linus tree for 3.15

commit 68c8829d0602d2a217f21b7c9dfa40ec21fea019
Merge: 75fa7d2 d40a63c
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu May 15 14:10:22 2014 +0200

    Merge branch 'pm-cpufreq'
    
    * pm-cpufreq:
      intel_pstate: remove setting P state to MAX on init
      intel_pstate: Set turbo VID for BayTrail

commit 75fa7d2826b520ad278512a39f9450d03265ed12
Merge: 3011ef6 5ff365f f6e6e1b
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu May 15 14:09:45 2014 +0200

    Merge branches 'acpi-video' and 'acpi-blacklist'
    
    * acpi-video:
      ACPI / video: correct DMI tag for Dell Inspiron 7520
      ACPI / video: Add use_native_backlight quirks for more systems
    
    * acpi-blacklist:
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      ACPI: blacklist win8 OSI for Dell Inspiron 7737

commit 3011ef60d8406ad549f99cf40b2bbd6df095ce73
Merge: 7d18aec 9801284 3afcb96
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu May 15 14:09:23 2014 +0200

    Merge branches 'acpi-ac' and 'acpi-proc'
    
    * acpi-ac:
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
    
    * acpi-proc:
      ACPI / proc: Do not say when /proc interfaces will be deleted in Kconfig
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"

commit 7d18aecd39180ac803e837ee0508a3bc12b168f3
Merge: 85dbd58 f759546 0b9d46d
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu May 15 14:07:32 2014 +0200

    Merge branches 'acpica', 'acpi-tpm' and 'acpi-processor'
    
    * acpica:
      ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.
      ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
    
    * acpi-tpm:
      ACPI / TPM: Fix resume regression on Chromebooks
    
    * acpi-processor:
      ACPI / processor: do not mark present at boot but not onlined CPU as onlined

commit e95a2f7509f5219177d6821a0a8754f93892ca56
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Thu May 8 15:09:19 2014 +0300

    drm/i915: Increase WM memory latency values on SNB
    
    On SNB the BIOS provided WM memory latency values seem insufficient to
    handle high resolution displays.
    
    In this particular case the display mode was a 2560x1440@60Hz, which
    makes the pixel clock 241.5 MHz. It was empirically found that a memory
    latency value if 1.2 usec is enough to avoid underruns, whereas the BIOS
    provided value of 0.7 usec was clearly too low. Incidentally 1.2 usec
    is what the typical BIOS provided values are on IVB systems.
    
    Increase the WM memory latency values to at least 1.2 usec on SNB.
    Hopefully this won't have a significant effect on power consumption.
    
    v2: Increase the latency values regardless of the pixel clock
    
    Cc: Robert N <crshman@gmail.com>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70254
    Tested-by: Robert Navarro <crshman@gmail.com>
    Tested-by: Vitaly Minko <vitaly.minko@gmail.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit ebc3226202d5956a5963185222982d435378b899
Author: Cornelia Huck <cornelia.huck@de.ibm.com>
Date:   Fri May 9 15:00:46 2014 +0200

    KVM: s390: announce irqfd capability
    
    s390 has acquired irqfd support with commit "KVM: s390: irq routing for
    adapter interrupts" (84223598778ba08041f4297fda485df83414d57e) but
    failed to announce it. Let's fix that.
    
    Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
    Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

commit 721e82c08c1afd6b47367b0e0c4a62140b0667f3
Author: Aaron Lu <aaron.lu@intel.com>
Date:   Mon May 12 16:55:45 2014 +0800

    drm/i915: restore backlight precision when converting from ACPI
    
    When we set backlight on behalf of ACPI opregion, we will convert the
    backlight value in the 0-255 range defined in opregion to the actual
    hardware level. Commit 22505b82a2 (drm/i915: avoid brightness overflow
    when doing scale) is meant to fix the overflow problem when doing the
    conversion, but it also caused a problem that the converted hardware
    level doesn't quite represent the intended value: say user wants maximum
    backlight level(255 in opregion's range), then we will calculate the
    actual hardware level to be: level = freq / max * level, where freq is
    the hardware's max backlight level(937 on an user's box), and max and
    level are all 255. The converted value should be 937 but the above
    calculation will yield 765.
    
    To fix this issue, just use 64 bits to do the calculation to keep the
    precision and avoid overflow at the same time.
    
    Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=72491
    Reported-by: Nico Schottelius <nico-bugzilla.kernel.org@schottelius.org>
    Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@vger.kernel.org
    Signed-off-by: Aaron Lu <aaron.lu@intel.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit afba0b5a221c0dacbbdf3a778d539fbc90fc6191
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue May 13 16:07:37 2014 +0100

    drm/i915: Use the first mode if there is no preferred mode in the EDID
    
    This matches the algorithm used by earlier kernels when selecting the
    mode for the fbcon. And only if there is no modes at all, do we fall
    back to using the BIOS configuration. Seamless transition is still
    preserved (from the BIOS configuration to ours) so long as the BIOS has
    also chosen what we hope is the native configuration.
    
    Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=78655
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Tested-by: Knut Petersen <Knut_Petersen@t-online.de>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    [Jani: applied Chris' "Please imagine that I wrote this correctly."]
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit f4cdbc21444a45d207a8dc175f44d2facfbd0845
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Wed May 14 13:02:19 2014 +0300

    drm/i915/dp: force eDP lane count to max available lanes on BDW
    
    There are certain BDW high res eDP machines that regressed due to
    
    commit 38aecea0ccbb909d635619cba22f1891e589b434
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Mon Mar 3 11:18:10 2014 +0100
    
        drm/i915: reverse dp link param selection, prefer fast over wide again
    
    The commit lead to 2 lanes at 5.4 Gbps being used instead of 4 lanes at
    2.7 Gbps on the affected machines. Link training succeeded for both, but
    the screen remained blank with the former config. Further investigation
    showed that 4 lanes at 5.4 Gbps worked also.
    
    The root cause for the blank screen using 2 lanes remains unknown, but
    apparently the driver for a certain other operating system by default
    uses the max available lanes. Follow suit on Broadwell eDP, for at least
    until we figure out what is going on.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76711
    Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
    Tested-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit fa81511bb0bbb2b1aace3695ce869da9762624ff
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 14 16:33:54 2014 -0700

    x86-64, modify_ldt: Make support for 16-bit segments a runtime option
    
    Checkin:
    
    b3b42ac2cbae x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
    
    disabled 16-bit segments on 64-bit kernels due to an information
    leak.  However, it does seem that people are genuinely using Wine to
    run old 16-bit Windows programs on Linux.
    
    A proper fix for this ("espfix64") is coming in the upcoming merge
    window, but as a temporary fix, create a sysctl to allow the
    administrator to re-enable support for 16-bit segments.
    
    It adds a "/proc/sys/abi/ldt16" sysctl that defaults to zero (off). If
    you hit this issue and care about your old Windows program more than
    you care about a kernel stack address information leak, you can do
    
       echo 1 > /proc/sys/abi/ldt16
    
    as root (add it to your startup scripts), and you should be ok.
    
    The sysctl table is only added if you have COMPAT support enabled on
    x86-64, but I assume anybody who runs old windows binaries very much
    does that ;)
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Link: http://lkml.kernel.org/r/CA%2B55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com
    Cc: <stable@vger.kernel.org>

commit ffe6902b66aaa4ca6694bc19639259c16d84ddb1
Author: James Hogan <james.hogan@imgtec.com>
Date:   Thu May 1 15:05:07 2014 +0100

    asm-generic: remove _STK_LIM_MAX
    
    _STK_LIM_MAX could be used to override the RLIMIT_STACK hard limit from
    an arch's include/uapi/asm-generic/resource.h file, but is no longer
    used since both parisc and metag removed the override. Therefore remove
    it entirely, setting the hard RLIMIT_STACK limit to RLIM_INFINITY
    directly in include/asm-generic/resource.h.
    
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: linux-arch@vger.kernel.org
    Cc: Helge Deller <deller@gmx.de>
    Cc: John David Anglin <dave.anglin@bell.net>

commit c70458f50cd4271410aa75011f56ffabc0e2d34a
Author: James Hogan <james.hogan@imgtec.com>
Date:   Thu May 1 12:31:14 2014 +0100

    metag: Remove _STK_LIM_MAX override
    
    Meta overrode _STK_LIM_MAX (the default RLIMIT_STACK hard limit) to
    256MB, apparently in an attempt to prevent setup_arg_pages's
    STACK_GROWSUP code from choosing the maximum stack size of 1GB, which is
    far too large for Meta's limited virtual address space and hits a BUG_ON
    (stack_top is usually 0x3ffff000).
    
    However the commit "metag: Reduce maximum stack size to 256MB" reduces
    the absolute stack size limit to a safe value for metag. This allows the
    default _STK_LIM_MAX override to be removed, bringing the default
    behaviour in line with all other architectures. Parisc in particular
    recently removed their override of _STK_LIMT_MAX in commit e0d8898d76a7
    (parisc: remove _STK_LIM_MAX override) since it subtly affects stack
    allocation semantics in userland. Meta's uapi/asm/resource.h can now be
    removed and switch to using generic-y.
    
    Suggested-by: Helge Deller <deller@gmx.de>
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Cc: linux-metag@vger.kernel.org
    Cc: John David Anglin <dave.anglin@bell.net>

commit 042d27acb64924a0e8a43e972485913a32407beb
Author: Helge Deller <deller@gmx.de>
Date:   Wed Apr 30 23:26:02 2014 +0200

    parisc,metag: Do not hardcode maximum userspace stack size
    
    This patch affects only architectures where the stack grows upwards
    (currently parisc and metag only). On those do not hardcode the maximum
    initial stack size to 1GB for 32-bit processes, but make it configurable
    via a config option.
    
    The main problem with the hardcoded stack size is, that we have two
    memory regions which grow upwards: stack and heap. To keep most of the
    memory available for heap in a flexmap memory layout, it makes no sense
    to hard allocate up to 1GB of the memory for stack which can't be used
    as heap then.
    
    This patch makes the stack size for 32-bit processes configurable and
    uses 80MB as default value which has been in use during the last few
    years on parisc and which hasn't showed any problems yet.
    
    Signed-off-by: Helge Deller <deller@gmx.de>
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
    Cc: linux-parisc@vger.kernel.org
    Cc: linux-metag@vger.kernel.org
    Cc: John David Anglin <dave.anglin@bell.net>

commit d71f290b4e98a39f49f2595a13be3b4d5ce8e1f1
Author: James Hogan <james.hogan@imgtec.com>
Date:   Tue May 13 23:58:24 2014 +0100

    metag: Reduce maximum stack size to 256MB
    
    Specify the maximum stack size for arches where the stack grows upward
    (parisc and metag) in asm/processor.h rather than hard coding in
    fs/exec.c so that metag can specify a smaller value of 256MB rather than
    1GB.
    
    This fixes a BUG on metag if the RLIMIT_STACK hard limit is increased
    beyond a safe value by root. E.g. when starting a process after running
    "ulimit -H -s unlimited" it will then attempt to use a stack size of the
    maximum 1GB which is far too big for metag's limited user virtual
    address space (stack_top is usually 0x3ffff000):
    
    BUG: failure at fs/exec.c:589/shift_arg_pages()!
    
    Signed-off-by: James Hogan <james.hogan@imgtec.com>
    Cc: Helge Deller <deller@gmx.de>
    Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
    Cc: linux-parisc@vger.kernel.org
    Cc: linux-metag@vger.kernel.org
    Cc: John David Anglin <dave.anglin@bell.net>
    Cc: stable@vger.kernel.org # only needed for >= v3.9 (arch/metag)

commit 2425ce84026c385b73ae72039f90d042d49e0394
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu May 8 15:51:37 2014 -0400

    metag: fix memory barriers
    
    Volatile access doesn't really imply the compiler barrier. Volatile access
    is only ordered with respect to other volatile accesses, it isn't ordered
    with respect to general memory accesses. Gcc may reorder memory accesses
    around volatile access, as we can see in this simple example (if we
    compile it with optimization, both increments of *b will be collapsed to
    just one):
    
    void fn(volatile int *a, long *b)
    {
    	(*b)++;
    	*a = 10;
    	(*b)++;
    }
    
    Consequently, we need the compiler barrier after a write to the volatile
    variable, to make sure that the compiler doesn't reorder the volatile
    write with something else.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: James Hogan <james.hogan@imgtec.com>

commit 4cdd2ad78098244c1bc9ec4374ea1c225fd1cd6f
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue May 13 13:49:39 2014 -0400

    dm mpath: fix lock order inconsistency in multipath_ioctl
    
    Commit 3e9f1be1b40 ("dm mpath: remove process_queued_ios()") did not
    consistently take the multipath device's spinlock (m->lock) before
    calling dm_table_run_md_queue_async() -- which takes the q->queue_lock.
    
    Found with code inspection using hint from reported lockdep warning.
    
    Reported-by: Bart Van Assche <bvanassche@acm.org>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

commit 85ad643b7e7e52d37620fb272a9fd577a8095647
Author: Joe Thornber <ejt@redhat.com>
Date:   Fri May 9 15:59:38 2014 +0100

    dm thin: add timeout to stop out-of-data-space mode holding IO forever
    
    If the pool runs out of data space, dm-thin can be configured to
    either error IOs that would trigger provisioning, or hold those IOs
    until the pool is resized.  Unfortunately, holding IOs until the pool is
    resized can result in a cascade of tasks hitting the hung_task_timeout,
    which may render the system unavailable.
    
    Add a fixed timeout so IOs can only be held for a maximum of 60 seconds.
    If LVM is going to resize a thin-pool that is out of data space it needs
    to be prompt about it.
    
    Signed-off-by: Joe Thornber <ejt@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org # 3.14+

commit 8d07e8a5f5bc7b90f755d9b427ea930024f4c986
Author: Joe Thornber <ejt@redhat.com>
Date:   Tue May 6 16:28:14 2014 +0100

    dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
    
    Commit 3e1a0699 ("dm thin: fix out of data space handling") introduced
    a regression in the metadata commit() method by returning an error if
    the pool is in PM_OUT_OF_DATA_SPACE mode.  This oversight caused a thin
    device to return errors even if the default queue_if_no_space ENOSPC
    handling mode is used.
    
    Fix commit() to only fail if pool is in PM_READ_ONLY or PM_FAIL mode.
    
    Reported-by: qindehua@163.com
    Signed-off-by: Joe Thornber <ejt@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org # 3.14+

commit 610f2de3559c383caf8fbbf91e9968102dff7ca0
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Feb 20 18:01:01 2014 -0500

    dm crypt: fix cpu hotplug crash by removing per-cpu structure
    
    The DM crypt target used per-cpu structures to hold pointers to a
    ablkcipher_request structure.  The code assumed that the work item keeps
    executing on a single CPU, so it didn't use synchronization when
    accessing this structure.
    
    If a CPU is disabled by writing 0 to /sys/devices/system/cpu/cpu*/online,
    the work item could be moved to another CPU.  This causes dm-crypt
    crashes, like the following, because the code starts using an incorrect
    ablkcipher_request:
    
     smpboot: CPU 7 is now offline
     BUG: unable to handle kernel NULL pointer dereference at 0000000000000130
     IP: [<ffffffffa1862b3d>] crypt_convert+0x12d/0x3c0 [dm_crypt]
     ...
     Call Trace:
      [<ffffffffa1864415>] ? kcryptd_crypt+0x305/0x470 [dm_crypt]
      [<ffffffff81062060>] ? finish_task_switch+0x40/0xc0
      [<ffffffff81052a28>] ? process_one_work+0x168/0x470
      [<ffffffff8105366b>] ? worker_thread+0x10b/0x390
      [<ffffffff81053560>] ? manage_workers.isra.26+0x290/0x290
      [<ffffffff81058d9f>] ? kthread+0xaf/0xc0
      [<ffffffff81058cf0>] ? kthread_create_on_node+0x120/0x120
      [<ffffffff813464ac>] ? ret_from_fork+0x7c/0xb0
      [<ffffffff81058cf0>] ? kthread_create_on_node+0x120/0x120
    
    Fix this bug by removing the per-cpu definition.  The structure
    ablkcipher_request is accessed via a pointer from convert_context.
    Consequently, if the work item is rescheduled to a different CPU, the
    thread still uses the same ablkcipher_request.
    
    This change may undermine performance improvements intended by commit
    c0297721 ("dm crypt: scale to multiple cpus") on select hardware.  In
    practice no performance difference was observed on recent hardware.  But
    regardless, correctness is more important than performance.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org

commit e84d2f8d2ae33c8215429824e1ecf24cbca9645e
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Wed May 14 09:48:21 2014 +0200

    net: filter: s390: fix JIT address randomization
    
    This is the s390 variant of Alexei's JIT bug fix.
    (patch description below stolen from Alexei's patch)
    
    bpf_alloc_binary() adds 128 bytes of room to JITed program image
    and rounds it up to the nearest page size. If image size is close
    to page size (like 4000), it is rounded to two pages:
    round_up(4000 + 4 + 128) == 8192
    then 'hole' is computed as 8192 - (4000 + 4) = 4188
    If prandom_u32() % hole selects a number >= PAGE_SIZE - sizeof(*header)
    then kernel will crash during bpf_jit_free():
    
    kernel BUG at arch/x86/mm/pageattr.c:887!
    Call Trace:
     [<ffffffff81037285>] change_page_attr_set_clr+0x135/0x460
     [<ffffffff81694cc0>] ? _raw_spin_unlock_irq+0x30/0x50
     [<ffffffff810378ff>] set_memory_rw+0x2f/0x40
     [<ffffffffa01a0d8d>] bpf_jit_free_deferred+0x2d/0x60
     [<ffffffff8106bf98>] process_one_work+0x1d8/0x6a0
     [<ffffffff8106bf38>] ? process_one_work+0x178/0x6a0
     [<ffffffff8106c90c>] worker_thread+0x11c/0x370
    
    since bpf_jit_free() does:
      unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
      struct bpf_binary_header *header = (void *)addr;
    to compute start address of 'bpf_binary_header'
    and header->pages will pass junk to:
      set_memory_rw(addr, header->pages);
    
    Fix it by making sure that &header->image[prandom_u32() % hole] and &header
    are in the same page.
    
    Fixes: aa2d2c73c21f2 ("s390/bpf,jit: address randomize and write protect jit code")
    
    Reported-by: Alexei Starovoitov <ast@plumgrid.com>
    Cc: <stable@vger.kernel.org> # v3.11+
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit faf1dc64e345ac4de5c4429df6ed492255ae2248
Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Date:   Wed May 14 14:39:21 2014 +0530

    ath9k_htc: Stop ANI before doing hw_reset
    
    During remain on channel request, ANI worker thread is not stopped
    before doing hw reset. This is causing kernel crash in
    hw_per_calibration. This change ensures that ANI is stopped before
    doing chip reset and it will be rescheduled later when the chip is
    configured back to home channel and having valid bss.
    
    Reported-by: David Herrmann <dh.herrmann@gmail.com>
    Tested-by: David Herrmann <dh.herrmann@gmail.com>
    Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit eac94da8b4cc3dd4336ed434fbc2370c3c850003
Merge: 209f6c3 b4b177a
Author: John W. Linville <linville@tuxdriver.com>
Date:   Wed May 14 15:39:45 2014 -0400

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211

commit f5738e2ef88070ef1372e6e718124d88e9abe4ac
Author: Ursula Braun <ursula.braun@de.ibm.com>
Date:   Tue May 13 14:38:02 2014 +0200

    af_iucv: wrong mapping of sent and confirmed skbs
    
    When sending data through IUCV a MESSAGE COMPLETE interrupt
    signals that sent data memory can be freed or reused again.
    With commit f9c41a62bba3f3f7ef3541b2a025e3371bcbba97
    "af_iucv: fix recvmsg by replacing skb_pull() function" the
    MESSAGE COMPLETE callback iucv_callback_txdone() identifies
    the wrong skb as being confirmed, which leads to data corruption.
    This patch fixes the skb mapping logic in iucv_callback_txdone().
    
    Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
    Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 03a58baa785f48a85126ab043a14cb80b7e670e0
Author: Kalesh AP <kalesh.purayil@emulex.com>
Date:   Tue May 13 14:03:11 2014 +0530

    be2net: enable interrupts in EEH resume
    
    On some BE3 FW versions, after a HW reset, interrupts will remain disabled
    for each function. So, explicitly enable the interrupts in the eeh_resume
    handler, else after an eeh recovery interrupts wouldn't work.
    
    Signed-off-by: Kalesh AP <kalesh.purayil@emulex.com>
    Signed-off-by: Sathya Perla <sathya.perla@emulex.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 702b691e4a711e699cf3cccba879c1d945665c0d
Author: Arun Kumar K <arun.kk@samsung.com>
Date:   Thu May 15 04:17:17 2014 +0900

    ARM: dts: Remove g2d_pd node for exynos5420
    
    G2D power domain also controls the CMU block of G2D. Since
    clock registers can be accessed anytime for viewing
    clk_summary, it can cause a system crash if g2d power domain
    is disabled.
    
    Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit c5b817e44bc97a3d119822459f69ea7d1dc528ee
Author: Tushar Behera <tushar.behera@linaro.org>
Date:   Thu May 15 04:16:03 2014 +0900

    ARM: dts: Remove mau_pd node for exynos5420
    
    MAU powerdomain provides clocks for Audio sub-system block.
    This block comprises of the I2S audio controller, audio DMA
    blocks and Audio sub-system clock registers.
    
    Right now, there is no way to hook up power-domains with
    clock providers.  During late boot when this power-domain
    gets disabled, we get following external abort.
    
    Unhandled fault: imprecise external abort (0x1406) at 0x00000000
    Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
    
    Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
    Tested-by: Doug Anderson <dianders@chromium.org>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit a8f1d0889e902cbac8c18a40ec927a109e48a52e
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Thu May 15 04:14:16 2014 +0900

    ARM: exynos_defconfig: enable HS-I2C to fix for mmc partition mount
    
    High speed I2C is used on Exynos5 based SoCs. Enable it.
    
    The MMC partition for Root filesystem cannot be mounted
    without this enabling HS-I2C and regulators on many boards
    are connected HS-I2C bus so the regulators don't come by
    default without this.
    
    Actually, we are not able to get arndale-octa board to boot
    and mount an MMC partition without this change.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Tested-by: Javi Merino <javi.merino@arm.com>
    [kgene.kim@samsung.com: modified description]
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit e6015c1f8a9032c2aecb78d23edf49582563bd47
Author: Seungwon Jeon <tgih.jun@samsung.com>
Date:   Fri May 9 07:02:33 2014 +0900

    ARM: dts: disable MDMA1 node for exynos5420
    
    This change places MDMA1 in disabled node for Exynos5420.
    If MDMA1 region is configured with secure mode, it makes
    the boot failure with the following on smdk5420 board.
    ("Unhandled fault: imprecise external abort (0x1406) at 0x00000000")
    Thus, arndale-octa board don't need to do the same thing anymore.
    
    Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
    Tested-by: Javi Merino <javi.merino@arm.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit 989ff3fdf939b15f0cb91406746da0ded0c06ef0
Author: Kyungmin Park <kyungmin.park@samsung.com>
Date:   Fri May 9 06:19:18 2014 +0900

    ARM: EXYNOS: fix the secondary CPU boot of exynos4212
    
    This patch fixes the offset of CPU boot address and changes
    the parameter of smc call for SMC_CMD_CPU1BOOT command on
    exynos4212.
    
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
    Reviewed-by: Tomasz Figa <t.figa@samsung.com>
    Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

commit c4b160685fc85e41fe8c08478cc61f4877d26973
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Mon May 12 10:38:18 2014 -0400

    jme: Fix unmap loop counting error:
    
    In my recent fix (76a691d0a: fix dma unmap warning), Ben Hutchings noted that my
    loop count was incorrect.  Where j started at startidx, it should have started
    at zero, and gone on for count entries, not to endidx.  Additionally, a DMA
    resource exhaustion should drop the frame and (for now), return
    NETDEV_TX_OK, not NETEV_TX_BUSY.  This patch fixes both of those issues:
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
    CC: Ben Hutchings <ben@decadent.org.uk>
    CC: "David S. Miller" <davem@davemloft.net>
    CC: Guo-Fu Tseng <cooldavid@cooldavid.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 0b5fe736fe923f1f5e05413878d5990e92ffbdf5
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed May 14 11:10:40 2014 -0700

    Input: synaptics - add min/max quirk for the ThinkPad W540
    
    https://bugzilla.redhat.com/show_bug.cgi?id=1096436
    
    Cc: stable@vger.kernel.org
    Tested-and-reported-by: ajayr@bigfoot.com
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 0f9e19ad88eee820f517b85531b555a0fa73e7e4
Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
Date:   Fri May 9 11:10:05 2014 +0300

    ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM
    
    McPDM need to be configured to NO_IDLE mode when it is in used otherwise
    vital clocks will be gated which results 'slow motion' audio playback.
    
    Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Paul Walmsley <paul@pwsan.com>

commit d7653964c590ba846aa11a8f6edf409773cbc492
Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date:   Mon May 5 18:36:21 2014 +0200

    i2c: rcar: bail out on zero length transfers
    
    This hardware does not support zero length transfers. Instead, the
    driver does one (random) byte transfers currently with undefined results
    for the slaves. We now bail out.
    
    Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
    Cc: stable@kernel.org

commit fa01d096bfcfd89398b1f3a3f91805dab76f7fe5
Author: Andy Gross <agross@codeaurora.org>
Date:   Fri May 2 20:54:29 2014 -0500

    i2c: qup: Fix pm_runtime_get_sync usage
    
    This patch corrects the error check on the call to pm_runtime_get_sync.
    
    Signed-off-by: Andy Gross <agross@codeaurora.org>
    Reviewed-by: Ivan T. Ivanov <iivanov@mm-sol.com>
    Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

commit ce78cc071f5f541480e381cc0241d37590041a9d
Author: Olof Johansson <olof@lixom.net>
Date:   Fri Apr 11 15:19:41 2014 -0700

    i2c: s3c2410: resume race fix
    
    Don't unmark the device as suspended until after it's been re-setup.
    
    The main race would be w.r.t. an i2c driver that gets resumed at the same
    time (asyncronously), that is allowed to do a transfer since suspended
    is set to 0 before reinit, but really should have seen the -EIO return
    instead.
    
    Signed-off-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
    Cc: stable@kernel.org

commit 37e5eb0bae7bb4d98c2153c3c3400b5c00c3cad1
Author: Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu Apr 10 16:19:29 2014 +0200

    i2c: nomadik: Don't use IS_ERR for devm_ioremap
    
    devm_ioremap() returns NULL on error, not an error.
    
    Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
    Cc: stable@kernel.org

commit 47bb27e78867997040a228328f2a631c3c7f2c82
Author: Du, Wenkai <wenkai.du@intel.com>
Date:   Thu Apr 10 23:03:19 2014 +0000

    i2c: designware: Mask all interrupts during i2c controller enable
    
    There have been "i2c_designware 80860F41:00: controller timed out" errors
    on a number of Baytrail platforms. The issue is caused by incorrect value in
    Interrupt Mask Register (DW_IC_INTR_MASK)  when i2c core is being enabled.
    This causes call to __i2c_dw_enable() to immediately start the transfer which
    leads to timeout. There are 3 failure modes observed:
    
    1. Failure in S0 to S3 resume path
    
    The default value after reset for DW_IC_INTR_MASK is 0x8ff. When we start
    the first transaction after resuming from system sleep, TX_EMPTY interrupt
    is already unmasked because of the hardware default.
    
    2. Failure in normal operational path
    
    This failure happens rarely and is hard to reproduce. Debug trace showed that
    DW_IC_INTR_MASK had value of 0x254 when failure occurred, which meant
    TX_EMPTY was unmasked.
    
    3. Failure in S3 to S0 suspend path
    
    This failure also happens rarely and is hard to reproduce. Adding debug trace
    that read DW_IC_INTR_MASK made this failure not reproducible. But from ISR
    call trace we could conclude TX_EMPTY was unmasked when problem occurred.
    
    The patch masks all interrupts before the controller is enabled to resolve the
    faulty DW_IC_INTR_MASK conditions.
    
    Signed-off-by: Wenkai Du <wenkai.du@intel.com>
    Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    [wsa: improved the comment and removed typo in commit msg]
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
    Cc: stable@kernel.org

commit 7bb394094080a26de06efcd6a870cb2ba21cfb16
Author: Steven J. Hill <Steven.Hill@imgtec.com>
Date:   Thu Apr 10 14:06:17 2014 -0500

    MIPS: mm: Fix broken microMIPS kernel regression.
    
    Commit f4ae17aa0f2122b52f642985b46210a1f2eceb0a [MIPS: mm: Use scratch for
    PGD when !CONFIG_MIPS_PGD_C0_CONTEXT] broke microMIPS kernel builds. This
    patch refactors that code similar to what was done for the 'clear_page'
    and 'copy_page' functions.
    
    Signed-off-by: Steven J. Hill <Steven.Hill@imgtec.com>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6744/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 40b9397a1a61a37917b93e7d57e6f2faf3a086b4
Author: Samuel Ortiz <sameo@linux.intel.com>
Date:   Wed May 14 17:53:35 2014 +0200

    Bluetooth: Fix L2CAP LE debugfs entries permissions
    
    0466 was probably meant to be 0644, there's no reason why everyone
    except root could write there.
    
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
    Cc: stable@vger.kernel.org

commit 16a9602158861687c78b6de6dc6a79e6e8a9136f
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Wed May 14 12:43:24 2014 -0300

    KVM: x86: disable master clock if TSC is reset during suspend
    
    Updating system_time from the kernel clock once master clock
    has been enabled can result in time backwards event, in case
    kernel clock frequency is lower than TSC frequency.
    
    Disable master clock in case it is necessary to update it
    from the resume path.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

commit 665ebe926e7b714369b5329d48745bfef17db512
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Wed May 14 16:32:21 2014 +0300

    ALSA: sb_mixer: missing return statement
    
    The if condition here was supposed to return on error but the return
    statement is missing.  The effect is that the ->mixername is set to
    "???" instead of "DT019X".
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit 582da6527da30f6e21a95c9f3f2810d46a8f406e
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Wed May 14 13:36:36 2014 +0200

    of: make of_update_property() usable earlier in the boot process
    
    Commit 75b57ecf9d1d1e17d099ab13b8f48e6e038676be ('of: Make device
    nodes kobjects so they show up in sysfs') has turned Device Tree nodes
    in kobjects and added a sysfs based representation for Device Tree
    nodes. Since the sysfs logic is only available after the execution of
    a core_initcall(), the patch took precautions in of_add_property() and
    of_remove_property() to not do any sysfs related manipulation early in
    the boot process.
    
    However, it forgot to do the same for of_update_property(), which if
    used early in the boot process (before core_initcalls have been
    called), tries to call sysfs_remove_bin_file(), and crashes:
    
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 0 at /home/thomas/projets/linux-2.6/fs/kernfs/dir.c:1216 kernfs_remove_by_name_ns+0x80/0x88()
    kernfs: can not remove '(null)', no directory
    Modules linked in:
    CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc1-00127-g1d7e7b2-dirty #423
    [<c0014910>] (unwind_backtrace) from [<c00110ec>] (show_stack+0x10/0x14)
    [<c00110ec>] (show_stack) from [<c04c84b8>] (dump_stack+0x84/0x94)
    [<c04c84b8>] (dump_stack) from [<c001d8c0>] (warn_slowpath_common+0x6c/0x88)
    [<c001d8c0>] (warn_slowpath_common) from [<c001d90c>] (warn_slowpath_fmt+0x30/0x40)
    [<c001d90c>] (warn_slowpath_fmt) from [<c0104468>] (kernfs_remove_by_name_ns+0x80/0x88)
    [<c0104468>] (kernfs_remove_by_name_ns) from [<c0394d98>] (of_update_property+0xc0/0xf0)
    [<c0394d98>] (of_update_property) from [<c0647248>] (mvebu_timer_and_clk_init+0xfc/0x194)
    [<c0647248>] (mvebu_timer_and_clk_init) from [<c0640934>] (start_kernel+0x218/0x350)
    [<c0640934>] (start_kernel) from [<00008070>] (0x8070)
    ---[ end trace 3406ff24bd97382e ]---
    Unable to handle kernel NULL pointer dereference at virtual address 0000003c
    pgd = c0004000
    [0000003c] *pgd=00000000
    Internal error: Oops: 5 [#1] SMP ARM
    Modules linked in:
    CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.15.0-rc1-00127-g1d7e7b2-dirty #423
    task: c10ad4d8 ti: c10a2000 task.ti: c10a2000
    PC is at kernfs_find_ns+0x8/0xf0
    LR is at kernfs_find_and_get_ns+0x30/0x48
    pc : [<c0103834>]    lr : [<c010394c>]    psr: 600001d3
    sp : c10a3f34  ip : 00000073  fp : 00000000
    r10: 00000000  r9 : cfffc240  r8 : cfdf2980
    r7 : cf812c00  r6 : 00000000  r5 : 00000000  r4 : c10b45e0
    r3 : c10ad4d8  r2 : 00000000  r1 : cf812c00  r0 : 00000000
    Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
    Control: 10c53c7d  Table: 0000404a  DAC: 00000015
    Process swapper/0 (pid: 0, stack limit = 0xc10a2240)
    Stack: (0xc10a3f34 to 0xc10a4000)
    3f20:                                              c10b45e0 00000000 00000000
    3f40: cf812c00 c010394c 00000063 cf812c00 00000001 cf812c00 cfdf29ac c03932cc
    3f60: 00000063 cf812bc0 cfdf29ac cf812c00 ffffffff c03943f8 cfdf2980 c0104468
    3f80: cfdf2a04 cfdf2980 cf812bc0 c06634b0 c10aa3c0 c0394da4 c10f74dc cfdf2980
    3fa0: cf812bc0 c0647248 c10aa3c0 ffffffff c10de940 c10aa3c0 ffffffff c0640934
    3fc0: ffffffff ffffffff c06404ec 00000000 00000000 c06634b0 00000000 10c53c7d
    3fe0: c10aa434 c06634ac c10ae4c8 0000406a 414fc091 00008070 00000000 00000000
    [<c0103834>] (kernfs_find_ns) from [<00000001>] (0x1)
    Code: e5c89001 eaffffcf e92d40f0 e1a06002 (e1d023bc)
    ---[ end trace 3406ff24bd97382f ]---
    Kernel panic - not syncing: Attempted to kill the idle task!
    ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
    
    To fix this problem, we simply skip the sysfs related calls in
    of_update_property(), and rely on of_init() to fix up things when it
    will be called, exactly as is done in of_add_property() and
    of_remove_property().
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Fixes: 75b57ecf9d1d ("of: Make device nodes kobjects so they show up in sysfs")
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

commit b4b177a5556a686909e643f1e9b6434c10de079f
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed May 14 15:34:41 2014 +0200

    mac80211: fix on-channel remain-on-channel
    
    Jouni reported that if a remain-on-channel was active on the
    same channel as the current operating channel, then the ROC
    would start, but any frames transmitted using mgmt-tx on the
    same channel would get delayed until after the ROC.
    
    The reason for this is that the ROC starts, but doesn't have
    any handling for "remain on the same channel", so it stops
    the interface queues. The later mgmt-tx then puts the frame
    on the interface queues (since it's on the current operating
    channel) and thus they get delayed until after the ROC.
    
    To fix this, add some logic to handle remaining on the same
    channel specially and not stop the queues etc. in this case.
    This not only fixes the bug but also improves behaviour in
    this case as data frames etc. can continue to flow.
    
    Cc: stable@vger.kernel.org
    Reported-by: Jouni Malinen <j@w1.fi>
    Tested-by: Jouni Malinen <j@w1.fi>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit ff2354bc6e54cc7e024744b7b4065a081fd87f6e
Merge: 7ca33c7 cffd666
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed May 14 14:27:12 2014 +0200

    Merge tag 'asoc-v3.15-rc5-intel' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus
    
    ASoC: Intel fixes for v3.15
    
    This is a relatively large batch of fixes for the newly added
    Haswell/Baytrail drivers from Intel.  It's a bit larger than is good for
    this point in the cycle but it's all for a newly added driver so not so
    worrying as it might otherwise be.  Some of it's integration problems,
    some of it's the sort of problem usually turned up in stress tests.

commit 7ca33c7a1d7f8566d8b08a0df55b26758d985a15
Merge: 927cdab f9a4059
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed May 14 14:24:09 2014 +0200

    Merge tag 'asoc-v3.15-rc5-drivers' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus
    
    ASoC: Driver fixes for v3.15
    
    A small set of driver fixes, nothing remarkable in itself or of any
    relevance outside of the driver.

commit 927cdab3b6fe7e32990f5563d295eedfc355be6d
Merge: 7189eb9 cf86197
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed May 14 14:23:48 2014 +0200

    Merge tag 'asoc-v3.15-rc5-core' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus
    
    ASoC: Core fixes for v3.15
    
    A few things here:
    
     - Fix the creation of spurious CODEC<->CODEC links which caused DAPM to
       have audio paths which shouldn't be present causing spurious powerups
       and potential audible issues for users.
     - Ensure the suspend->off transition doesn't have spurious transitions
       to prepare added to the sequence.
     - Fix incorrect skipping of PCM suspension for active audio streams.
     - Remove Timur Tabi from the CS4270 maintainers, Cirrus are now doing
       this and Timur no longer has the boards that he was using.

commit cf86197ec5655ed1f54f1f7ba34a01d576e3737d
Merge: 0d1203f 868a6ca
Author: Mark Brown <broonie@linaro.org>
Date:   Wed May 14 12:52:41 2014 +0100

    Merge remote-tracking branch 'asoc/fix/pcm' into asoc-linus

commit 0d1203f29199a1d754bd1ca335c3dc6b14be160b
Merge: 34e0a1e ce85a4d
Author: Mark Brown <broonie@linaro.org>
Date:   Wed May 14 12:52:32 2014 +0100

    Merge remote-tracking branch 'asoc/fix/dapm' into asoc-linus

commit f9a405961eec4ee9a71a433a473b244ae2d74c3c
Merge: b890978 4e17d2d 4f8210f 6ae6698 836b31f 2a1c23e 44330ab
Author: Mark Brown <broonie@linaro.org>
Date:   Wed May 14 12:49:10 2014 +0100

    Merge remote-tracking branches 'asoc/fix/audmux', 'asoc/fix/cs42l52', 'asoc/fix/fsl-esai', 'asoc/fix/fsl-spdif', 'asoc/fix/rcar', 'asoc/fix/tlv320aic31xx' and 'asoc/fix/wm8962' into asoc-linus

commit 5d61b54f5e06621d7b1471cbf8b76bc064117225
Author: Liviu Dudau <Liviu.Dudau@arm.com>
Date:   Tue May 13 23:17:12 2014 -0700

    Input: ambakmi - request a shared interrupt for AMBA KMI devices
    
    Recent ARM boards have the KMI devices share one interrupt line rather
    than having dedicated IRQs. Update the driver to take that into account.
    
    Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit c5ec1948eaab7c1c0f412b2804e65a637f1c7443
Author: Chao Xie <chao.xie@marvell.com>
Date:   Mon May 12 19:20:48 2014 -0700

    Input: pxa27x-keypad - fix generating scancode
    
    The number of columns of pxa27x-keypad used by various boards is not fixed.
    When building keymap with call to:
    
    matrix_keypad_build_keymap(keymap_data, NULL,
                               pdata->matrix_key_rows,
                               pdata->matrix_key_cols,
                               keypad->keycodes, input_dev);
    
    it will internally calculate needed row shift and use it to fill the
    keymap. Therefore when calculating the "scancode" we should no longer use
    constant row shift but also calculate it from number of columns.
    
    Signed-off-by: Chao Xie <chao.xie@marvell.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 3a1cebe7e05027a1c96f2fc1a8eddf5f19b78f42
Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date:   Sun May 11 23:01:13 2014 +0200

    ipv6: fix calculation of option len in ip6_append_data
    
    tot_len does specify the size of struct ipv6_txoptions. We need opt_flen +
    opt_nflen to calculate the overall length of additional ipv6 extensions.
    
    I found this while auditing the ipv6 output path for a memory corruption
    reported by Alexey Preobrazhensky while he fuzzed an instrumented
    AddressSanitizer kernel with trinity. This may or may not be the cause
    of the original bug.
    
    Fixes: 4df98e76cde7c6 ("ipv6: pmtudisc setting not respected with UFO/CORK")
    Reported-by: Alexey Preobrazhensky <preobr@google.com>
    Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 3d4405226d27b3a215e4d03cfa51f536244e5de7
Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date:   Sun May 11 22:59:30 2014 +0200

    net: avoid dependency of net_get_random_once on nop patching
    
    net_get_random_once depends on the static keys infrastructure to patch up
    the branch to the slow path during boot. This was realized by abusing the
    static keys api and defining a new initializer to not enable the call
    site while still indicating that the branch point should get patched
    up. This was needed to have the fast path considered likely by gcc.
    
    The static key initialization during boot up normally walks through all
    the registered keys and either patches in ideal nops or enables the jump
    site but omitted that step on x86 if ideal nops where already placed at
    static_key branch points. Thus net_get_random_once branches not always
    became active.
    
    This patch switches net_get_random_once to the ordinary static_key
    api and thus places the kernel fast path in the - by gcc considered -
    unlikely path.  Microbenchmarks on Intel and AMD x86-64 showed that
    the unlikely path actually beats the likely path in terms of cycle cost
    and that different nop patterns did not make much difference, thus this
    switch should not be noticeable.
    
    Fixes: a48e42920ff38b ("net: introduce new macro net_get_random_once")
    Reported-by: Tuomas Räsänen <tuomasjjrasanen@tjjr.fi>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f2d0801f00b7aff0ac6b3666cbcdab499267418a
Author: Markos Chandras <markos.chandras@imgtec.com>
Date:   Tue Apr 22 15:40:36 2014 +0100

    MIPS: Add new AUDIT_ARCH token for the N32 ABI on MIPS64
    
    A MIPS64 kernel may support ELF files for all 3 MIPS ABIs
    (O32, N32, N64). Furthermore, the AUDIT_ARCH_MIPS{,EL}64 token
    does not provide enough information about the ABI for the 64-bit
    process. As a result of which, userland needs to use complex
    seccomp filters to decide whether a syscall belongs to the o32 or n32
    or n64 ABI. Therefore, a new arch token for MIPS64/n32 is added so it
    can be used by seccomp to explicitely set syscall filters for this ABI.
    
    Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
    Acked-by: Eric Paris <eparis@redhat.com>
    Acked-by: Paul Moore <pmoore@redhat.com>
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: linux-mips@linux-mips.org
    Link: http://sourceforge.net/p/libseccomp/mailman/message/32239040/
    Patchwork: https://patchwork.linux-mips.org/patch/6818/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 9844f5462392b53824e8b86726e7c33b5ecbb676
Author: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
Date:   Wed May 14 11:29:48 2014 +0200

    x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()
    
    The invalidation is required in order to maintain proper semantics
    under CoW conditions. In scenarios where a process clones several
    threads, a thread operating on a core whose DTLB entry for a
    particular hugepage has not been invalidated, will be reading from
    the hugepage that belongs to the forked child process, even after
    hugetlb_cow().
    
    The thread will not see the updated page as long as the stale DTLB
    entry remains cached, the thread attempts to write into the page,
    the child process exits, or the thread gets migrated to a different
    processor.
    
    Signed-off-by: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
    Link: http://lkml.kernel.org/r/20140514092948.GA17391@server-36.huawei.corp
    Suggested-by: Shay Goikhman <shay.goikhman@huawei.com>
    Acked-by: Dave Hansen <dave.hansen@intel.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Cc: <stable@vger.kernel.org> # v2.6.16+ (!)

commit 97d9d23dda6f37d90aefeec4ed619d52df525382
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Sat Apr 26 12:51:31 2014 -0300

    [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
    
    If a struct contains 64-bit fields, it is aligned on 64-bit boundaries
    within containing structs in 64-bit compilations. This is the case with
    struct v4l2_window, which contains pointers and is embedded into struct
    v4l2_format, and that one is embedded into struct v4l2_create_buffers.
    Unlike some other structs, used as a part of the kernel ABI as ioctl()
    arguments, that are packed, these structs aren't packed. This isn't a
    problem per se, but the ioctl-compat code for VIDIOC_CREATE_BUFS contains
    a bug, that triggers in such 64-bit builds. That code wrongly assumes,
    that in struct v4l2_create_buffers, struct v4l2_format immediately follows
    the __u32 memory field, which in fact isn't the case. This bug wasn't
    visible until now, because until recently hardly any applications used
    this ioctl() and mostly embedded 32-bit only drivers implemented it. This
    is changing now with addition of this ioctl() to some USB drivers, e.g.
    UVC. This patch fixes the bug by copying parts of struct
    v4l2_create_buffers separately.
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
    Cc: stable@vger.kernel.org

commit cfece5857ca51d1dcdb157017aba226f594e9dcf
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Mon Apr 14 10:49:34 2014 -0300

    [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
    
    Commit 75e2bdad8901a0b599e01a96229be922eef1e488 "ov7670: allow
    configuration of image size, clock speed, and I/O method" uses a wrong
    index to iterate an array. Apart from being wrong, it also uses an
    unchecked value from user-space, which can cause access to unmapped
    memory in the kernel, triggered by a normal desktop user with rights to
    use V4L2 devices.
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Acked-by: Jonathan Corbet <corbet@lwn.net>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 773cd38f40b8834be991dbfed36683acc1dd41ee
Author: Alexei Starovoitov <ast@plumgrid.com>
Date:   Tue May 13 15:05:55 2014 -0700

    net: filter: x86: fix JIT address randomization
    
    bpf_alloc_binary() adds 128 bytes of room to JITed program image
    and rounds it up to the nearest page size. If image size is close
    to page size (like 4000), it is rounded to two pages:
    round_up(4000 + 4 + 128) == 8192
    then 'hole' is computed as 8192 - (4000 + 4) = 4188
    If prandom_u32() % hole selects a number >= PAGE_SIZE - sizeof(*header)
    then kernel will crash during bpf_jit_free():
    
    kernel BUG at arch/x86/mm/pageattr.c:887!
    Call Trace:
     [<ffffffff81037285>] change_page_attr_set_clr+0x135/0x460
     [<ffffffff81694cc0>] ? _raw_spin_unlock_irq+0x30/0x50
     [<ffffffff810378ff>] set_memory_rw+0x2f/0x40
     [<ffffffffa01a0d8d>] bpf_jit_free_deferred+0x2d/0x60
     [<ffffffff8106bf98>] process_one_work+0x1d8/0x6a0
     [<ffffffff8106bf38>] ? process_one_work+0x178/0x6a0
     [<ffffffff8106c90c>] worker_thread+0x11c/0x370
    
    since bpf_jit_free() does:
      unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
      struct bpf_binary_header *header = (void *)addr;
    to compute start address of 'bpf_binary_header'
    and header->pages will pass junk to:
      set_memory_rw(addr, header->pages);
    
    Fix it by making sure that &header->image[prandom_u32() % hole] and &header
    are in the same page
    
    Fixes: 314beb9bcabfd ("x86: bpf_jit_comp: secure bpf jit against spraying attacks")
    Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
    Acked-by: Eric Dumazet <edumazet@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Tue May 13 18:47:01 2014 +0000

    MAINTAINERS: Add co-maintainer for drivers/irqchip
    
    Thomas Gleixner has asked me to assist with the review and merging of
    patches for the irqchip subsystem.
    
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>
    Link: http://lkml.kernel.org/r/1400006821-32145-1-git-send-email-jason@lakedaemon.net
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 629c27aa0c930b9c67188cfc625bf6cdd2af6764
Author: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Date:   Tue May 13 07:41:32 2014 -0400

    iscsi_ibft: Fix finding Broadcom specific ibft sign
    
    Search for Broadcom specific ibft sign "BIFT"
    along with other possible values on UEFI
    
    This patch is fix for regression introduced in
    “935a9fee51c945b8942be2d7b4bae069167b4886”.
    https://lkml.org/lkml/2011/12/16/353
    
    This impacts Broadcom CNA for iSCSI Boot on UEFI platform.
    
    Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Acked-by: Mike Christie <michaelc@cs.wisc.edu>

commit 209f6c37540a6cc1c74333a7ede0da729488a8cd
Merge: 03e5da1 b538b8c
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue May 13 14:52:34 2014 -0400

    Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes

commit fd30c37331ad8ed7c7e0e4c21f5ee309fec21d7d
Merge: 6c7bdf2 111e0a9 3d89e14
Author: Mark Brown <broonie@linaro.org>
Date:   Tue May 13 19:08:34 2014 +0100

    Merge remote-tracking branches 'spi/fix/pxa2xx' and 'spi/fix/qup' into spi-linus

commit 6c7bdf2d9c89530c87ef92ca79b1f0b2eff7ba30
Merge: d6d211d c3676d5
Author: Mark Brown <broonie@linaro.org>
Date:   Tue May 13 19:08:33 2014 +0100

    Merge remote-tracking branch 'spi/fix/core' into spi-linus

commit 44330ab516c15dda8a1e660eeaf0003f84e43e3f
Author: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Date:   Tue May 13 13:45:15 2014 +0100

    ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile
    
    The register CLASS_D_CONTROL_1 is marked as volatile because it contains
    a bit, DAC_MUTE, which is also mirrored in the ADC_DAC_CONTROL_1
    register. This causes problems for the "Speaker Switch" control, which
    will report an error if the CODEC is suspended because it relies on a
    volatile register.
    
    To resolve this issue mark CLASS_D_CONTROL_1 as non-volatile and
    manually keep the register cache in sync by updating both bits when
    changing the mute status.
    
    Reported-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    Tested-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Mark Brown <broonie@linaro.org>
    Cc: stable@vger.kernel.org

commit cffd6665f57ed18f4be9185c4330c8c98c22e201
Author: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Date:   Tue May 13 15:46:06 2014 +0300

    ASoC: Intel: Fix Baytrail SST DSP firmware loading
    
    Commit 10df350977b1 ("ASoC: Intel: Fix Audio DSP usage when IOMMU is
    enabled.") caused following regression in Baytrail SST:
    
    baytrail-pcm-audio baytrail-pcm-audio: error: DMA alloc failed
    baytrail-pcm-audio baytrail-pcm-audio: error: failed to load firmware
    
    Fix this by calling dma_coerce_mask_and_coherent() in sst_byt_init() with
    the same dma_dev device what is now used in sst_fw_new() when allocating the
    DMA buffer.
    
    Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 6262971a8a5082e3662238f50e3f3c351a2e552f
Merge: 2176d5d 709de13
Author: David S. Miller <davem@davemloft.net>
Date:   Tue May 13 12:53:36 2014 -0400

    Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
    
    Included changes:
    - properly release neigh_ifinfo in batadv_iv_ogm_process_per_outif()
    - properly release orig_ifinfo->router when freeing orig_ifinfo
    - properly release neigh_node objects during periodic check
    - properly release neigh_info objects when the related hard_iface
      is free'd
    
    These changes are all very important because they fix some
    reference counting imbalances that lead to the
    impossibility of releasing the netdev object used by
    batman-adv on shutdown.
    The consequence is that such object cannot be destroyed by
    the networking stack (the refcounter does not reach zero)
    thus bringing the system in hanging state during a normal
    reboot operation or a network reconfiguration.

commit 2176d5d41891753774f648b67470398a5acab584
Author: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Date:   Fri May 9 13:16:48 2014 +0800

    neigh: set nud_state to NUD_INCOMPLETE when probing router reachability
    
    Since commit 7e98056964("ipv6: router reachability probing"), a router falls
    into NUD_FAILED will be probed.
    
    Now if function rt6_select() selects a router which neighbour state is NUD_FAILED,
    and at the same time function rt6_probe() changes the neighbour state to NUD_PROBE,
    then function dst_neigh_output() can directly send packets, but actually the
    neighbour still is unreachable. If we set nud_state to NUD_INCOMPLETE instead
    NUD_PROBE, packets will not be sent out until the neihbour is reachable.
    
    In addition, because the route should be probes with a single NS, so we must
    set neigh->probes to neigh_max_probes(), then the neigh timer timeout and function
    neigh_timer_handler() will not send other NS Messages.
    
    Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 5367742ad5321dd38058420adb4750ed9c7ead1e
Merge: 696dfd9 b18db0b
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue May 13 18:15:16 2014 +0200

    Merge tag 'signed-for-3.15' of git://github.com/agraf/linux-2.6 into kvm-master
    
    Patch queue for 3.15 - 2014-05-12
    
    This request includes a few bug fixes that really shouldn't wait for the next
    release.
    
    It fixes KVM on 32bit PowerPC when built as module. It also fixes the PV KVM
    acceleration when NX gets honored by the host. Furthermore we fix transactional
    memory support and numa support on HV KVM.

commit 367f0b50e502d2c384277ba2ed43b04add2b8b6f
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Tue May 13 17:56:41 2014 +0200

    MIPS: Wire up renameat2 syscall.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit d40a63c45b506b0681918d7c62a15cc9d48c8681
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Thu May 8 12:57:24 2014 -0700

    intel_pstate: remove setting P state to MAX on init
    
    Setting the P state of the core to max at init time is a hold over
    from early implementation of intel_pstate where intel_pstate disabled
    cpufreq and loaded VERY early in the boot sequence.  This was to
    ensure that intel_pstate did not affect boot time. This in not needed
    now that intel_pstate is a cpufreq driver.
    
    Removing this covers the case where a CPU has gone through a manual
    CPU offline/online cycle and the P state is set to MAX on init and the
    CPU immediately goes idle.  Due to HW coordination the P state request
    on the idle CPU will drag all cores to MAX P state until the load is
    reevaluated when to core goes non-idle.
    
    Reported-by: Patrick Marlier <patrick.marlier@gmail.com>
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 36e9d2ebcc15d029b33f42a36146ab5a5bcfcfe7
Author: Tejun Heo <tj@kernel.org>
Date:   Tue May 13 11:28:30 2014 -0400

    cgroup: fix rcu_read_lock() leak in update_if_frozen()
    
    While updating cgroup_freezer locking, 68fafb77d827 ("cgroup_freezer:
    replace freezer->lock with freezer_mutex") introduced a bug in
    update_if_frozen() where it returns with rcu_read_lock() held.  Fix it
    by adding rcu_read_unlock() before returning.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: kbuild test robot <fengguang.wu@intel.com>

commit e5ced8ebb10c20a3b349bd798b69ccabd3b25d21
Author: Tejun Heo <tj@kernel.org>
Date:   Wed May 7 21:31:17 2014 -0400

    cgroup_freezer: replace freezer->lock with freezer_mutex
    
    After 96d365e0b86e ("cgroup: make css_set_lock a rwsem and rename it
    to css_set_rwsem"), css task iterators requires sleepable context as
    it may block on css_set_rwsem.  I missed that cgroup_freezer was
    iterating tasks under IRQ-safe spinlock freezer->lock.  This leads to
    errors like the following on freezer state reads and transitions.
    
      BUG: sleeping function called from invalid context at /work
     /os/work/kernel/locking/rwsem.c:20
      in_atomic(): 0, irqs_disabled(): 0, pid: 462, name: bash
      5 locks held by bash/462:
       #0:  (sb_writers#7){.+.+.+}, at: [<ffffffff811f0843>] vfs_write+0x1a3/0x1c0
       #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8126d78b>] kernfs_fop_write+0xbb/0x170
       #2:  (s_active#70){.+.+.+}, at: [<ffffffff8126d793>] kernfs_fop_write+0xc3/0x170
       #3:  (freezer_mutex){+.+...}, at: [<ffffffff81135981>] freezer_write+0x61/0x1e0
       #4:  (rcu_read_lock){......}, at: [<ffffffff81135973>] freezer_write+0x53/0x1e0
      Preemption disabled at:[<ffffffff81104404>] console_unlock+0x1e4/0x460
    
      CPU: 3 PID: 462 Comm: bash Not tainted 3.15.0-rc1-work+ #10
      Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
       ffff88000916a6d0 ffff88000e0a3da0 ffffffff81cf8c96 0000000000000000
       ffff88000e0a3dc8 ffffffff810cf4f2 ffffffff82388040 ffff880013aaf740
       0000000000000002 ffff88000e0a3de8 ffffffff81d05974 0000000000000246
      Call Trace:
       [<ffffffff81cf8c96>] dump_stack+0x4e/0x7a
       [<ffffffff810cf4f2>] __might_sleep+0x162/0x260
       [<ffffffff81d05974>] down_read+0x24/0x60
       [<ffffffff81133e87>] css_task_iter_start+0x27/0x70
       [<ffffffff8113584d>] freezer_apply_state+0x5d/0x130
       [<ffffffff81135a16>] freezer_write+0xf6/0x1e0
       [<ffffffff8112eb88>] cgroup_file_write+0xd8/0x230
       [<ffffffff8126d7b7>] kernfs_fop_write+0xe7/0x170
       [<ffffffff811f0756>] vfs_write+0xb6/0x1c0
       [<ffffffff811f121d>] SyS_write+0x4d/0xc0
       [<ffffffff81d08292>] system_call_fastpath+0x16/0x1b
    
    freezer->lock used to be used in hot paths but that time is long gone
    and there's no reason for the lock to be IRQ-safe spinlock or even
    per-cgroup.  In fact, given the fact that a cgroup may contain large
    number of tasks, it's not a good idea to iterate over them while
    holding IRQ-safe spinlock.
    
    Let's simplify locking by replacing per-cgroup freezer->lock with
    global freezer_mutex.  This also makes the comments explaining the
    intricacies of policy inheritance and the locking around it as the
    states are protected by a common mutex.
    
    The conversion is mostly straight-forward.  The followings are worth
    mentioning.
    
    * freezer_css_online() no longer needs double locking.
    
    * freezer_attach() now performs propagation simply while holding
      freezer_mutex.  update_if_frozen() race no longer exists and the
      comment is removed.
    
    * freezer_fork() now tests whether the task is in root cgroup using
      the new task_css_is_root() without doing rcu_read_lock/unlock().  If
      not, it grabs freezer_mutex and performs the operation.
    
    * freezer_read() and freezer_change_state() grab freezer_mutex across
      the whole operation and pin the css while iterating so that each
      descendant processing happens in sleepable context.
    
    Fixes: 96d365e0b86e ("cgroup: make css_set_lock a rwsem and rename it to css_set_rwsem")
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: Li Zefan <lizefan@huawei.com>

commit 5024ae29cd285ce9e736776414da645d3a91828c
Author: Tejun Heo <tj@kernel.org>
Date:   Wed May 7 21:31:17 2014 -0400

    cgroup: introduce task_css_is_root()
    
    Determining the css of a task usually requires RCU read lock as that's
    the only thing which keeps the returned css accessible till its
    reference is acquired; however, testing whether a task belongs to the
    root can be performed without dereferencing the returned css by
    comparing the returned pointer against the root one in init_css_set[]
    which never changes.
    
    Implement task_css_is_root() which can be invoked in any context.
    This will be used by the scheduled cgroup_freezer change.
    
    v2: cgroup no longer supports modular controllers.  No need to export
        init_css_set.  Pointed out by Li.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: Li Zefan <lizefan@huawei.com>

commit b25bcf1bcaf6687991ae08dd76cd784bf9fe3d05
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon May 12 16:11:40 2014 +0200

    ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
    
    Since the mvebu-soc-id code in mach-mvebu/ was introduced, several
    users have noticed a regression: the PCIe card connected in the first
    PCIe interface is not detected properly.
    
    This is due to the fact that the mvebu-soc-id code enables the PCIe
    clock of the first PCIe interface, reads the SoC device ID and
    revision number (yes this information is made available as part of
    PCIe registers), and then disables the clock. However, by doing this,
    we gate the clock and therefore loose the complex PCIe configuration
    that was done by the bootloader.
    
    Unfortunately, as of today, the kernel is not capable of doing this
    complex configuration by itself, so we really need to keep the PCIe
    clock enabled. However, we don't want to keep it enabled
    unconditionally: if the PCIe interface is not enabled or PCI support
    is not compiled into the kernel, there is no reason to keep the PCIe
    clock running.
    
    This issue was discussed with Kevin Hilman, and the suggested solution
    was to make the mvebu-soc-id code keep the clock enabled in case it
    will be needed for PCIe. This is therefore the solution implemented in
    this patch.
    
    Long term, we hope to make the kernel more capable in terms of PCIe
    configuration for this platform, which will anyway be needed to
    support the compilation of the PCIe host controller driver as a
    module. In the mean time however, we don't have much other choice than
    to implement the currently proposed solution.
    
    Reported-by: Neil Greatorex <neil@fatboyfat.co.uk>
    Cc: Neil Greatorex <neil@fatboyfat.co.uk>
    Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Cc: Kevin Hilman <khilman@linaro.org>
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1399903900-29977-3-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: af8d1c63afcb ("ARM: mvebu: Add support to get the ID and the revision of a SoC")
    Cc: <stable@vger.kernel.org> # 3.14+: 42a18d1cf484: ARM: mvebu: mvebu-soc-id: add missing clk_put() call
    Cc: <stable@vger.kernel.org> # 3.14+
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Tested-by: Andrew Lunn <andrew@lunn.ch>
    Tested-by: Willy Tarreau <w@1wt.eu>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 42a18d1cf484d02e23afadfa5dc09356e6bef9fa
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon May 12 16:11:39 2014 +0200

    ARM: mvebu: mvebu-soc-id: add missing clk_put() call
    
    The mvebu-soc-id code in mach-mvebu/ needs to enable a clock to read
    the SoC device ID and revision number. To do so, it does a clk_get(),
    then a clk_prepare_enable(), reads the value, and disables the clock
    with clk_disable_unprepare(). However, it forgets to clk_put() the
    clock. This commit fixes this issue.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1399903900-29977-2-git-send-email-thomas.petazzoni@free-electrons.com
    Cc: <stable@vger.kernel.org> # 3.14+
    Fixes: af8d1c63afcb ("ARM: mvebu: Add support to get the ID and the revision of a SoC")
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Tested-by: Andrew Lunn <andrew@lunn.ch>
    Tested-by: Willy Tarreau <w@1wt.eu>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 85dbd5801f62b66e2aa7826aaefcaebead44c8a6
Author: Lv Zheng <lv.zheng@intel.com>
Date:   Tue May 13 16:50:30 2014 +0800

    ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.
    
    We need to find a smarter way to switch to 64-bit FADT addresses according
    to the bug report.  This patch reverts Linux to the original behavior.
    
    Fixes: 0249ed2444d6 (ACPICA: Add option to favor 32-bit FADT addresses.)
    References: https://bugzilla.kernel.org/show_bug.cgi?id=74021
    Reported-and-tested-by: Oswald Buddenhagen <ossi@kde.org>
    Signed-off-by: Lv Zheng <lv.zheng@intel.com>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f5651986fe438c1ba05fdafa383d38bd86713d13
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue May 13 15:45:55 2014 +0200

    nl80211: fix NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL API
    
    My commit removing that also removed it from the header file
    which can break compilation of userspace that needed it, add
    it back for API/ABI compatibility purposes (but no code to
    implement anything for it.)
    
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 5ff365fb6aed4c7ee5aae7b0239ce0b514aefabc
Author: Aaron Lu <aaron.lu@intel.com>
Date:   Tue May 13 09:51:50 2014 +0800

    ACPI / video: correct DMI tag for Dell Inspiron 7520
    
    The DMI tag used to identify Dell Inspiron 7520 should be product name
    instead of product version.
    
    Fixes: 0e9f81d3b7cd (ACPI / video: Add systems that should favour native backlight interface)
    Reported-and-tested-by: Téo Mazars <teomazars@gmail.com>
    References: https://bugzilla.redhat.com/show_bug.cgi?id=909552
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Aaron Lu <aaron.lu@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b538b8ce76f69f7fa225bc0817bbb361b877ea23
Author: David Spinadel <david.spinadel@intel.com>
Date:   Tue May 13 14:29:36 2014 +0300

    iwlwifi: mvm: prevent sched scan while not idle
    
    Prevent sched scan while not idle (including during association or in AP
    mode) instead of while associated only.
    
    This fixes my previous commit which was incomplete:
    
    commit bd5e4744a6ca64299b57a2682c720d00a475a734
    Author: David Spinadel <david.spinadel@intel.com>
    Date:   Thu Apr 24 13:15:29 2014 +0300
    
        iwlwifi: mvm: do no sched scan while associated
    
        Currently the FW doesn't support sched scan while associated,
        Prevent it.
    
    Signed-off-by: David Spinadel <david.spinadel@intel.com>
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit c52666aef9f2dff39276eb53f15d99e2e229870f
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue May 13 12:54:09 2014 +0300

    mac80211: fix suspend vs. association race
    
    If the association is in progress while we suspend, the
    stack will be in a messed up state. Clean it before we
    suspend.
    
    This patch completes Johannes's patch:
    
    1a1cb744de160ee70086a77afff605bbc275d291
    Author: Johannes Berg <johannes.berg@intel.com>
    
        mac80211: fix suspend vs. authentication race
    
    Cc: <stable@vger.kernel.org>
    Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 555724a831b4a146e7bdf16ecc989cda032b076d
Author: Tejun Heo <tj@kernel.org>
Date:   Mon May 12 13:56:27 2014 -0400

    kernfs, sysfs, cgroup: restrict extra perm check on open to sysfs
    
    The kernfs open method - kernfs_fop_open() - inherited extra
    permission checks from sysfs.  While the vfs layer allows ignoring the
    read/write permissions checks if the issuer has CAP_DAC_OVERRIDE,
    sysfs explicitly denied open regardless of the cap if the file doesn't
    have any of the UGO perms of the requested access or doesn't implement
    the requested operation.  It can be debated whether this was a good
    idea or not but the behavior is too subtle and dangerous to change at
    this point.
    
    After cgroup got converted to kernfs, this extra perm check also got
    applied to cgroup breaking libcgroup which opens write-only files with
    O_RDWR as root.  This patch gates the extra open permission check with
    a new flag KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK and enables it for sysfs.
    For sysfs, nothing changes.  For cgroup, root now can perform any
    operation regardless of the permissions as it was before kernfs
    conversion.  Note that kernfs still fails unimplemented operations
    with -EINVAL.
    
    While at it, add comments explaining KERNFS_ROOT flags.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Andrey Wagin <avagin@gmail.com>
    Tested-by: Andrey Wagin <avagin@gmail.com>
    Cc: Li Zefan <lizefan@huawei.com>
    References: http://lkml.kernel.org/g/CANaxB-xUm3rJ-Cbp72q-rQJO5mZe1qK6qXsQM=vh0U8upJ44+A@mail.gmail.com
    Fixes: 2bd59d48ebfb ("cgroup: convert to kernfs")
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 64793110ad4d82e18d88a33307749c6562a6dd04
Author: Eliad Peller <eliad@wizery.com>
Date:   Sun May 11 19:59:43 2014 +0300

    iwlwifi: mvm: fix off-by-one in scan channels configuration
    
    tail should be equal to the last valid index, so
    decrease it by one.
    
    This error causes in "a gap" in some cases (as well as
    some possible out-of-bound write), finally resulting in
    ucode assertion.
    
    Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 2c16c9fdacbbf3bd8ff6390e12c5d28b3f2c78ac
Author: Su Friendy <friendy.su@sony.com.cn>
Date:   Wed May 7 13:54:52 2014 +0800

    iommu/amd: fix enabling exclusion range for an exact device
    
    set_device_exclusion_range(u16 devid, struct ivmd_header *m) enables
    exclusion range for ONE device. IOMMU does not translate the access
    to the exclusion range from the device.
    
    The device is specified by input argument 'devid'. But 'devid' is not
    passed to the actual set function set_dev_entry_bit(), instead
    'm->devid' is passed. 'm->devid' does not specify the exact device
    which needs enable the exclusion range. 'm->devid' represents DeviceID
    field of IVMD, which has different meaning depends on IVMD type.
    
    The caller init_exclusion_range() sets 'devid' for ONE device. When
    m->type is equal to ACPI_IVMD_TYPE_ALL or ACPI_IVMD_TYPE_RANGE,
    'm->devid' is not equal to 'devid'.
    
    This patch fixes 'm->devid' to 'devid'.
    
    Signed-off-by: Su Friendy <friendy.su@sony.com.cn>
    Signed-off-by: Tamori Masahiro <Masahiro.Tamori@jp.sony.com>
    Signed-off-by: Joerg Roedel <joro@8bytes.org>

commit 4378d99295fae5fd42b0ed1a3eeef2a1684e0c17
Author: Jay Cornwall <jay.cornwall@amd.com>
Date:   Mon Apr 28 17:27:46 2014 -0500

    iommu/amd: Take mmap_sem when calling get_user_pages
    
    get_user_pages requires caller to hold a read lock on mmap_sem.
    
    Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
    Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    Signed-off-by: Joerg Roedel <joro@8bytes.org>

commit e028a9e6b8a637af09ac4114083280df4a7045f1
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Tue Apr 22 10:08:40 2014 -0600

    iommu/amd: Fix interrupt remapping for aliased devices
    
    An apparent cut and paste error prevents the correct flags from being
    set on the alias device resulting in MSI on conventional PCI devices
    failing to work.  This also produces error events from the IOMMU like:
    
    AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:14.4 address=0x000000fdf8000000 flags=0x0a00]
    
    Where 14.4 is a PCIe-to-PCI bridge with a device behind it trying to
    use MSI interrupts.
    
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Joerg Roedel <joro@8bytes.org>

commit 7189eb9b8f7962474956196c301676470542f253
Author: Mengdong Lin <mengdong.lin@intel.com>
Date:   Tue May 13 16:57:08 2014 +0800

    ALSA: hda - mask buggy stream DMA0 for Broadwell display controller
    
    Broadwell display controller has 3 stream DMA engines. DMA0 cannot update DMA
    postion buffer properly while DMA1 and DMA2 can work well. So this patch masks
    the buggy DMA0 by keeping it as opened.
    
    This is a tentative workaround, so keep the change small as Takashi suggested.
    
    Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit c1ff0b474c35905061b18e050be14e5a673a5965
Author: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date:   Mon May 12 18:32:55 2014 +0200

    ARM: at91/dt: sam9260: correct external trigger value
    
    The external trigger value is 0b1101 which is 13 but 0xd.
    
    Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

commit ec5fe98886b686f065ef29d8dee1b3ca66f5fd48
Author: Aaron Plattner <aplattner@nvidia.com>
Date:   Mon May 12 20:05:02 2014 -0700

    ALSA: hda - Add new GPU codec ID to snd-hda
    
    Vendor ID 0x10de0071 is used by a yet-to-be-named GPU chip.
    
    Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit c8965932a2e3b70197ec02c6741c29460279e2a8
Author: Susant Sahani <susant@redhat.com>
Date:   Sat May 10 00:11:32 2014 +0530

    ip6_tunnel: fix potential NULL pointer dereference
    
    The function ip6_tnl_validate assumes that the rtnl
    attribute IFLA_IPTUN_PROTO always be filled . If this
    attribute is not filled by  the userspace application
    kernel get crashed with NULL pointer dereference. This
    patch fixes the potential kernel crash when
    IFLA_IPTUN_PROTO is missing .
    
    Signed-off-by: Susant Sahani <susant@redhat.com>
    Acked-by: Thomas Graf <tgraf@suug.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 14186fea0cb06bc43181ce239efe0df6f1af260a
Merge: 77d9278 cf01f4e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:33:09 2014 +0900

    Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
    
    Pull file locking fix from Jeff Layton:
     "Fix for regression in handling of F_GETLK commands"
    
    * tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux:
      locks: only validate the lock vs. f_mode in F_SETLK codepaths

commit 77d92784b46549e00f7b99794cd566045ded62ba
Merge: 68cb363 3a18e13
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:28:52 2014 +0900

    Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
    
    Pull hwmon fixes from Guenter Roeck:
     "Fix resource leak as well as broken store function in emc1403 driver,
      and add support for additional chip revisions"
    
    * tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging:
      hwmon: (emc1403) Support full range of known chip revision numbers
      hwmon: (emc1403) Fix resource leak on module unload
      hwmon: (emc1403) fix inverted store_hyst()

commit 68cb363a4ddc335fddf6e2ccb03e4a907ba7afbf
Merge: efb2b1d 5a838c3
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:25:56 2014 +0900

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
    
    Pull a percpu fix from Tejun Heo:
     "Fix for a percpu allocator bug where it could try to kfree() a memory
      region allocated using vmalloc().  The bug has been there for years
      now and is unlikely to have ever triggered given the size of struct
      pcpu_chunk.  It's still theoretically possible and the fix is simple
      and safe enough, so the patch is marked with -stable"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu:
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

commit efb2b1d5fdf4be71d63d29b881bf3d6f93f53694
Merge: 26a41cd 77668c8
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:24:07 2014 +0900

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
    
    Pull workqueue fixes from Tejun Heo:
     "Fixes for two bugs in workqueue.
    
      One is exiting with internal mutex held in a failure path of
      wq_update_unbound_numa().  The other is a subtle and unlikely
      use-after-possible-last-put in the rescuer logic.  Both have been
      around for quite some time now and are unlikely to have triggered
      noticeably often.  All patches are marked for -stable backport"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq:
      workqueue: fix a possible race condition between rescuer and pwq-release
      workqueue: make rescuer_thread() empty wq->maydays list before exiting
      workqueue: fix bugs in wq_update_unbound_numa() failure path

commit 26a41cd1eeac299d0d7c505f8d38976a553c8fc4
Merge: 619b589 36c38fb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:22:57 2014 +0900

    Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
    
    Pull cgroup fixes from Tejun Heo:
     "During recent restructuring, device_cgroup unified config input check
      and enforcement logic; unfortunately, it turned out to share too much.
      Aristeu's patches fix the breakage and marked for -stable backport.
    
      The other two patches are fallouts from kernfs conversion.  The blkcg
      change is temporary and will go away once kernfs internal locking gets
      simplified (patches pending)"
    
    * 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup:
      blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats()
      device_cgroup: check if exception removal is allowed
      device_cgroup: fix the comment format for recently added functions
      device_cgroup: rework device access check and exception checking
      cgroup: fix the retry path of cgroup_mount()

commit 619b5891903936f3e493bf8cda18a8b6664fcdd7
Merge: 1972663 1f53ba6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:21:01 2014 +0900

    Merge tag 'stable/for-linus-3.15-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
    
    Pull xen bug fixes from David Vrabel:
     - Fix arm64 crash on boot.
     - Quiet a noisy arm build warning (virt_to_pfn() redefined).
    
    * tag 'stable/for-linus-3.15-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip:
      arm64: introduce virt_to_pfn
      xen/events/fifo: correctly align bitops
      arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h

commit 19726630c69eb373d6d5d4f3934c2ed540914344
Merge: 2ddb599 a87c9ad
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:19:32 2014 +0900

    Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
    
    Pull cifs fix from Steve French:
     "Small cifs fix for metadata caching"
    
    * 'for-linus' of git://git.samba.org/sfrench/cifs-2.6:
      cifs: fix actimeo=0 corner case when cifs_i->time == jiffies

commit 2ddb5998d0538bc720288486af3af243af5bac0a
Merge: 200d963 0f62fb2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:11:48 2014 +0900

    Merge tag 'md/3.15-fixes' of git://neil.brown.name/md
    
    Pull md bugfixes from Neil Brown:
     "Two bugfixes for md in 3.15
    
      Both tagged for -stable"
    
    * tag 'md/3.15-fixes' of git://neil.brown.name/md:
      md: avoid possible spinning md thread at shutdown.
      md/raid10: call wait_barrier() for each request submitted.

commit 200d963bf49c3399a5f044d53b5b4a8f133a776c
Merge: 7e338c9 3b27dce
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 13 11:07:02 2014 +0900

    Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
    
    Pull ARM SoC fixes from Olof Johansson:
     "Seems like we've had more fixes than usual this release cycle, but
      there's nothing in particular that we're doing differently.  Perhaps
      it's just one of those cycles where more people are finding more
      regressions (and/or that the latency of when people actually test
      what's been in the tree for a while is catching up so that we get the
      bug reports now).
    
      The bigger changes here are are for TI and Marvell platforms:
       * Timing changes for GPMC (generic localbus) on OMAP causing some
         largeish DTS deltas.
       * Fixes to window allocation on PCI for mvebu touching drivers/
         stuff.  Patches have acks from subsystem maintainers where needed.
       * A fix from Thomas for a botched DT conversion in drivers/edma.
    
      There's a handful of other fixes for the above platforms as well as
      sunxi, at91, i.MX.  I also included a MAINTAINER update for Broadcom,
      and a trivial move of a binding doc.
    
      I know you said you'd be offline this week, but I might as well post
      it for when you return.  :)"
    
    I'm not quite offline yet.  Doing a few pulls in the last hour before my
    internet goes away..
    
    * tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc: (31 commits)
      MAINTAINERS: update Broadcom ARM tree location and add an SoC family
      ARM: dts: i.MX53: Fix ipu register space size
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes
      ARM: sunxi: Enable GMAC in sunxi_defconfig
      ARM: common: edma: Fix xbar mapping
      ARM: sun7i: Fix i2c4 base address
      ARM: Kirkwood: T5325: Fix double probe of Codec
      ARM: mvebu: enable the SATA interface on Armada 375 DB
      ARM: mvebu: specify I2C bus frequency on Armada 370 DB
      ARM: mvebu: use qsgmii phy-mode for Armada XP GP interfaces
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: dts: AM3517: Disable absent IPs inherited from OMAP3
      ARM: dts: OMAP2: Fix interrupts for OMAP2420 mailbox
      ARM: dts: OMAP5: Add mailbox dt node to fix boot warning
      ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU
      ARM: dts: am437x-gp-evm: Do not reset gpio5
      ARM: dts: omap3-igep0020: use SMSC9221 timings
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      ...

commit 8e33f91a0b84ae1964bef77cb92f5d41d97530c8
Author: Ben Dooks <ben.dooks@codethink.co.uk>
Date:   Tue Apr 15 17:06:34 2014 +0100

    clk: shmobile: clk-mstp: change to using clock-indices
    
    With the addition of clock-indices, we need to change the renesas
    clock implementation to use these instead of the local definition
    of "renesas,clock-indices".
    
    Since this will break booting with older device trees, we add a
    simple auto-detection of which properties are present.
    
    Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
    Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>

commit 8471ac1b3fc73aeabdabf9ff3c0a4df71d190448
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Wed Apr 16 00:31:51 2014 +0200

    MIPS: inst.h: Rename BITFIELD_FIELD to __BITFIELD_FIELD.
    
    <uapi/asm/inst.h> is exported to userland so the macro name BITFIELD_FIELD
    pollutes the namespace.  Prefix the name with __ fixes this.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit cdbb03b00451513c35d10812d2d55d7951bae269
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Fri Apr 11 18:28:00 2014 +0200

    MIPS: Remove file missed when removing rm9k support a while ago.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 8e8acb32960f42c81b1d50deac56a2c07bb6a18a
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Thu Apr 3 22:24:01 2014 +0300

    MIPS/loongson2_cpufreq: Fix CPU clock rate setting
    
    Loongson2 has been using (incorrectly) kHz for cpu_clk rate. This has
    been unnoticed, as loongson2_cpufreq was the only place where the rate
    was set/get. After commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
    (cpufreq: introduce cpufreq_generic_get() routine) things however broke,
    and now loops_per_jiffy adjustments are incorrect (1000 times too long).
    The patch fixes this by changing cpu_clk rate to Hz.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Cc: stable@vger.kernel.org
    Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: linux-mips@linux-mips.org
    Cc: linux-kernel@vger.kernel.org
    Cc: cpufreq@vger.kernel.org
    Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
    Patchwork: https://patchwork.linux-mips.org/patch/6678/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 3deff253315effd23fdde86e4d818d8cf3dcc5dc
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Thu Apr 3 11:10:20 2014 +0200

    MIPS: Loongson: No need to select GENERIC_HARDIRQS_NO__DO_IRQ
    
    Commit 0e476d91244e ("MIPS: Loongson: Add Loongson-3 Kconfig options")
    added "select GENERIC_HARDIRQS_NO__DO_IRQ". But the Kconfig symbol
    GENERIC_HARDIRQS_NO__DO_IRQ was already removed in v2.6.38, so that
    select is a nop. Drop it.
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Cc: linux-mips@linux-mips.org
    Cc: linux-kernel@vger.kernel.org
    Patchwork: https://patchwork.linux-mips.org/patch/6677/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 44ba138f55577431cd119840320e31e218d7dd5b
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Fri Apr 4 03:32:54 2014 +0100

    MIPS: csum_partial.S CPU_DADDI_WORKAROUNDS bug fix
    
    This change reverts most of commit
    60724ca59eda766a30be57aec6b49bc3e2bead91 [MIPS: IP checksums: Remove
    unncessary .set pseudos] that introduced warnings with the
    CPU_DADDI_WORKAROUNDS option set:
    
    arch/mips/lib/csum_partial.S: Assembler messages:
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:467: Warning: used $3 with ".set at=$3"
    [...]
    arch/mips/lib/csum_partial.S:577: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:577: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:577: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:601: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:601: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:601: Warning: used $3 with ".set at=$3"
    arch/mips/lib/csum_partial.S:601: Warning: used $3 with ".set at=$3"
    [and so on, and so on...]
    
    The warnings are benign and good code is produced regardless because no
    macros that'd use the assembler's temporary register are involved, however
    the `.set noat' directives removed by the commit referred are crucial to
    guarantee this is still going to be the case after any changes in the
    future.  Therefore they need to be brought back to place which this
    change does.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6686/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 465ca5d6a06bfab861b65bb6b54dca170564326b
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Fri Apr 4 03:32:29 2014 +0100

    MIPS: __strncpy_from_user_asm CPU_DADDI_WORKAROUNDS bug fix
    
    This corrects assembler warnings and broken code generated in
    __strncpy_from_user_asm:
    
    arch/mips/lib/strncpy_user.S: Assembler messages:
    arch/mips/lib/strncpy_user.S:52: Warning: Macro instruction expanded into
    multiple instructions in a branch delay slot
    
    with the CPU_DADDI_WORKAROUNDS option set.  The function schedules delay
    slots manually where there is really no need to as GAS is happy to do it
    all itself, so undo it all and remove `.set noreorder'.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6685/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 2db4bc3418c43f1e810b304c48f8ddff2535075b
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Tue Apr 1 00:57:28 2014 +0100

    MIPS: __delay CPU_DADDI_WORKAROUNDS bug fix
    
    With CPU_DADDI_WORKAROUNDS enabled __delay assembles with a macro in a
    branch delay slot:
    
    {standard input}: Assembler messages:
    {standard input}:18: Warning: Macro instruction expanded into multiple
    instructions in a branch delay slot
    
    and broken code results:
    
    0000000000000000 <__delay>:
       0:	1480ffff 	bnez	a0,0 <__delay>
       4:	24010001 	li	at,1
       8:	0081202f 	dsubu	a0,a0,at
       c:	03e00008 	jr	ra
      10:	00000000 	nop
      14:	00000000 	nop
    
    Consequently the function loops indefinitely, showing up prominently as a
    hang in the delay loop calibration at bootstrap.
    
    This change corrects the problem by forcing the immediate 1 into a
    register while keeping code produced identical where CPU_DADDI_WORKAROUNDS
    is disabled.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6669/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 824122a319d827d42aeb4646a3bf639937fdb2ce
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Tue Apr 1 00:14:41 2014 +0100

    MIPS: DEC/SNI: O32 wrapper stack switching fixes
    
    Commit 231a35d37293ab88d325a9cb94e5474c156282c0 [[MIPS] RM: Collected
    changes] broke DECstation support by introducing an incompatible copy of
    arch/mips/dec/prom/call_o32.S in arch/mips/fw/lib/, built unconditionally.
    The copy happens to land earlier of the two among the modules used in the
    link and is therefore chosen for the DECstation rather than the intended
    original.  As a result random kernel data is corrupted because a pointer
    to the "%s" formatted output template is used as a temporary stack pointer
    rather than being passed down to prom_printf.  This also explains why
    prom_printf still works, up to a point -- the next argument is the actual
    string to output so it works just fine as the output template until enough
    kernel data has been corrupted to cause a crash.
    
    This change adjusts the modified wrapper in arch/mips/fw/lib/call_o32.S to
    let callers request no stack switching by passing a null temporary stack
    pointer in $a1, reworks the DECstation callers to work with the updated
    interface and removes the old copy from arch/mips/dec/prom/call_o32.S.  A
    few minor readability adjustments are included as well, most importantly
    O32_SZREG is now used throughout where applicable rather than hardcoded
    multiplies of 4 and $fp is used to access the argument save area as a more
    usual register to operate the stack with rather than $s0.
    
    Finally an update is made to the temporary stack space used by the SNI
    platform to guarantee 8-byte alignment as per o32 requirements.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6668/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit af37530bbe9cae2a17044525b9f898ff60012157
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Mon Mar 31 23:51:30 2014 +0100

    MIPS: DEC: Bus error handler <asm/cpu-type.h> fixes
    
    Commit 69f24d1784b631b81a54eb57c49bf46536dd2382 [MIPS: Optimize
    current_cpu_type() for better code.] missed an update for two DECstation
    bus error support files that now do not build, this is a fix.
    
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Cc: linux-mips@linux-mips.org
    Patchwork: https://patchwork.linux-mips.org/patch/6667/
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit c406339cf15e53d70c095d590f437ee6ff24595d
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Thu Apr 3 13:29:06 2014 +0200

    MAINTAINERS: TURBOchannel: Update entry
    
    Add mailing list and patchwork URL so patches now have a defined path.
    Also add myself as a TURBOchannel maintainer.  However Maciej is going
    to the the resident TURBOchannel guru.
    
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-by: "Maciej W. Rozycki" <macro@linux-mips.org>

commit 5508d456e9992bb81f21d4bd3b1f60f3eb04eb40
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Thu Apr 3 13:14:05 2014 +0200

    Revert "MIPS: MT: proc: Add support for printing VPE and TC ids"
    
    Reverts commit 795038a6910937fa167d47f6f6183db0eb8fb706 because
    d6d3c9afaab47418ab2d7f874fb8aeac1f067104 provides the same functionality
    in a more generic way.  Both patches applied however means that the
    VPE and TC IDs get printed twice currently.

commit 4f8210f66e5a200c63770ea9445ff913a28a3be2
Author: Nicolin Chen <Guangyu.Chen@freescale.com>
Date:   Tue May 6 16:56:02 2014 +0800

    ASoC: fsl_esai: Set PCRC and PRRC registers at the end of hw_params()
    
    According to Reference Manual -- ESAI Initialization chapter, as the
    standard procedure of ESAI personal reset, the PCRC and PRRC registers
    should be remained in its reset value and then configured after T/RCCR
    and T/RCR configurations's done but before TE/RE's enabling.
    
    So this patch moves PCRC and PRRC settings to the end of hw_params().
    
    Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 57ebbcafab0ce8cce4493c6a243ecdd7066e6ef1
Author: Nicolin Chen <Guangyu.Chen@freescale.com>
Date:   Tue May 6 16:56:00 2014 +0800

    ASoC: fsl_esai: Only bypass sck_div for EXTAL source
    
    ESAI can only output EXTAL clock source directly. But for FSYS clock source,
    ESAI can not output it without getting through PSR PM dividers.
    
    So this patch adds an extra check in the code.
    
    Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 89e47f62cf3eea7ad5e3d7d72ea846be37d6e352
Author: Nicolin Chen <Guangyu.Chen@freescale.com>
Date:   Tue May 6 16:55:59 2014 +0800

    ASoC: fsl_esai: Fix incorrect condition within ratio range check for FP
    
    The range here from 1 to 16 is confined to FP divider only while the
    sck_div indicates if the calculation contains PSR and PM dividers. So
    for the case using PSR and PM since the sck_div is true, the range of
    ratio would simply become bigger than 16.
    
    So this patch fixes the condition here and adds one line comments to
    make the purpose here clear.
    
    Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit ce85a4d726ecd286f933d4eedf01c5acb4f47a38
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Tue May 6 10:32:15 2014 +0200

    ASoC: dapm: Fix SUSPEND -> OFF bias sequence
    
    Currently when the DAPM context bias level is SUSPEND and the target bias level
    is OFF dapm_pre_sequence_async() will first transition to PREPARE and
    dapm_post_sequence_async() will then transition back from PREPARE to STANDBY and
    then to OFF.
    
    This patch makes sure that dapm_pre_sequence_async() only transitions to PREPARE
    when either going to ON or away from ON. This avoids the extra unnecessary
    transitions.
    
    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 111e0a9dc71ed75baa5e739289b9bdb06fda13be
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Thu May 8 17:30:31 2014 +0300

    spi/pxa2xx: Prevent DMA from transferring too many bytes
    
    In case we are doing DMA transfer and the size of the buffer is not multiple
    of 4 bytes the driver truncates that to 4-byte boundary and tries to handle
    remaining bytes using PIO.
    
    Or that is what it tried to do. What actually happens is that it calls
    ALIGN() to the buffer size which aligns it to the next 4-byte boundary
    (doesn't truncate). Doing this results 1-3 bytes extra to be transferred.
    Furthermore we handle remaining bytes using PIO which results one extra
    byte to be transferred. In worst case the driver transfers 4 extra bytes.
    
    While investigating this it turned out that the DMA hardware doesn't even
    have such limitation so we can solve this by dropping the code that tries
    to handle unaligned bytes.
    
    Reported-by: Chiau Ee Chew <chiau.ee.chew@intel.com>
    Reported-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
    Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit ca5106ae3da0179dcee3ae21f3ea94f62e9fdb0c
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Wed May 7 16:20:24 2014 +0200

    ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()
    
    For CODEC to CODEC DAI links the paths are created in snd_soc_dapm_new_pcm().
    Also for CODEC to CODEC links the widgets are connected cross-over via a DAI
    link widget, meaning that the capture widget of one CODEC will be connected to
    the playback widget of the other and vice versa. Whereas
    snd_soc_dapm_connect_dai_link_widgets() directly connects the playback widget of
    the CPU DAI to the playback widget of the CODEC DAI and the capture widget of
    the CPU DAI to the capture widget of the CODEC DAI. So not skipping
    CODEC<->CODEC links in snd_soc_dapm_connect_dai_link_widgets() will create
    incorrect connections between the two CODECs which will cause DAPM to detect
    active paths where there are none and unnecessarily power up widgets.
    
    Fixes: b893ea5 ("ASoC: sapm: Automatically connect DAI link widgets in DAPM graph.")
    Cc: <stable@vger.kernel.org> (for 3.14+)
    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 868a6ca84ee7e547ae01a5e04e232e4a392c50b8
Author: Nicolin Chen <Guangyu.Chen@freescale.com>
Date:   Mon May 12 20:12:05 2014 +0800

    ASoC: pcm: Fix incorrect condition check for case SNDRV_PCM_TRIGGER_SUSPEND
    
    The regular state before we execute SNDRV_PCM_TRIGGER_SUSPEND should be
    SNDRV_PCM_TRIGGER_START, not SNDRV_PCM_TRIGGER_STOP. Thus fix it.
    
    Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit ba77341cfd180022e60f08f55025ad59a8387538
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon May 12 11:01:48 2014 -0700

    Input: atmel-wm97xx - only build for AVR32
    
    Building this driver on ARM/at91 always gives us this error message:
    
    drivers/input/touchscreen/atmel-wm97xx.c:63:2: error: #error Unknown CPU, this driver only supports AT32AP700X CPUs.
    
    Clearly this configuration is not meant to work, so let's just prevent
    it in Kconfig. If we ever want to use it on another platform, we should
    also pass proper resources for GPIO, IRQ and memory, which are hardcoded
    to AT32AP700X at the moment.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 0a4ac2ea2714b5e43293f752737b8c2731a26679
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon May 12 11:00:15 2014 -0700

    Input: fix ps2/serio module dependency
    
    The ps2 mouse and keyboard drivers use the "serio" framework that they
    correctly select in Kconfig, and that in turn depends on the i8042 driver,
    which is also allowed to be disabled for architectures that don't have an
    i8042.
    
    However, Kconfig also allows i8042 to be built as a module while
    the serio framework is built-in, which causes this link error:
    
    drivers/built-in.o: In function `ps2_begin_command':
    :(.text+0x26b6cc): undefined reference to `i8042_check_port_owner'
    :(.text+0x26b6d4): undefined reference to `i8042_lock_chip'
    drivers/built-in.o: In function `ps2_end_command':
    :(.text+0x26b734): undefined reference to `i8042_check_port_owner'
    :(.text+0x26b73c): undefined reference to `i8042_unlock_chip'
    
    On x86, a specific 'select SERIO_I8042' takes care of it, but
    not on the other architecture that potentially have a i8042.
    
    This patch changes the Kconfig logic to ensure that whenever
    there is an i8042, it does get used for the serio driver, avoiding
    the link error above.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 1c3639005f48492e5f2d965779efd814e80f8b15
Author: Nikolay Aleksandrov <nikolay@redhat.com>
Date:   Fri May 9 11:11:39 2014 +0200

    sfc: fix calling of free_irq with already free vector
    
    If the sfc driver is in legacy interrupt mode (either explicitly by
    using interrupt_mode module param or by falling back to it) it will
    hit a warning at kernel/irq/manage.c because it will try to free an irq
    which wasn't allocated by it in the first place because the MSI(X) irqs are
    zero and it'll try to free them unconditionally. So fix it by checking if
    we're in legacy mode and freeing the appropriate irqs.
    
    CC: Zenghui Shi <zshi@redhat.com>
    CC: Ben Hutchings <ben@decadent.org.uk>
    CC: <linux-net-drivers@solarflare.com>
    CC: Shradha Shah <sshah@solarflare.com>
    CC: David S. Miller <davem@davemloft.net>
    
    Fixes: 1899c111a535 ("sfc: Fix IRQ cleanup in case of a probe failure")
    Reported-by: Zenghui Shi <zshi@redhat.com>
    Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
    Acked-by: Shradha Shah <sshah@solarflare.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556
Author: Peter Christensen <pch@ordbogen.com>
Date:   Thu May 8 11:15:37 2014 +0200

    macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
    
    Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
    overflow on the underlying interface.
    
    Attempting the set IFF_ALLMULTI on the underlying interface would cause an
    error and the log message:
    
    "allmulti touches root, set allmulti failed."
    
    Signed-off-by: Peter Christensen <pch@ordbogen.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 03e5da151b8e390f2e28c4edf8fbbb6ca6d7a7ed
Author: Daniel Kim <dekim@broadcom.com>
Date:   Fri May 9 12:37:05 2014 +0200

    brcmfmac: Fix iovar 'bw_cap' set command failure
    
    Fix iovar 'bw_cap' set command failure introduced by
    
      commit ff3b0fba6f25555ef59c55d138a467d0f81d82d7
      Author: Arend van Spriel <arend@broadcom.com>
      Date:   Sat Mar 15 12:00:57 2014 +0100
    
          brcmfmac: fallback to mimo_bw_cap for older firmwares
    
    This resulted in disabling 20MHz operation in the firmware.
    
    Reviewed-by: Arend Van Spriel <arend@broadcom.com>
    Signed-off-by: Daniel Kim <dekim@broadcom.com>
    Signed-off-by: Arend van Spriel <arend@broadcom.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit c5e64d6b70da16979652053e04f794f6d7863282
Merge: d2e5cb4 f9ac71b
Author: John W. Linville <linville@tuxdriver.com>
Date:   Mon May 12 14:12:19 2014 -0400

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211

commit 3a18e1398fc2dc9c32bbdc50664da3a77959a8d1
Author: Josef Gajdusek <atx@atx.name>
Date:   Mon May 12 13:48:26 2014 +0200

    hwmon: (emc1403) Support full range of known chip revision numbers
    
    The datasheet for EMC1413/EMC1414, which is fully compatible to
    EMC1403/1404 and uses the same chip identification, references revision
    numbers 0x01, 0x03, and 0x04. Accept the full range of revision numbers
    from 0x01 to 0x04 to make sure none are missed.
    
    Signed-off-by: Josef Gajdusek <atx@atx.name>
    Cc: stable@vger.kernel.org
    [Guenter Roeck: Updated headline and description]
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>

commit 8759f9046550f463098148bf577ccd32cdb895e3
Author: Jean Delvare <jdelvare@suse.de>
Date:   Mon May 12 11:44:51 2014 +0200

    hwmon: (emc1403) Fix resource leak on module unload
    
    Commit 454aee17f claims to convert driver emc1403 to use
    devm_hwmon_device_register_with_groups, however the patch itself makes
    use of hwmon_device_register_with_groups instead. As the driver remove
    function was still dropped, the hwmon device is no longer unregistered
    on driver removal, leading to a resource leak.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Fixes: 454aee17f hwmon: (emc1403) Convert to use devm_hwmon_device_register_with_groups
    Cc: Guenter Roeck <linux@roeck-us.net>
    Cc: stable@vger.kernel.org [3.13+]
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>

commit 17c048fc4bd95efea208a1920f169547d8588f1f
Author: Josef Gajdusek <atx@atx.name>
Date:   Sun May 11 14:40:44 2014 +0200

    hwmon: (emc1403) fix inverted store_hyst()
    
    Attempts to set the hysteresis value to a temperature below the target
    limit fails with "write error: Numerical result out of range" due to
    an inverted comparison.
    
    Signed-off-by: Josef Gajdusek <atx@atx.name>
    Reviewed-by: Jean Delvare <jdelvare@suse.de>
    Cc: stable@vger.kernel.org
    [Guenter Roeck: Updated headline and description]
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>

commit 601c942176d8ad8334118bddb747e3720bed24f8
Author: Sudeep Holla <sudeep.holla@arm.com>
Date:   Fri May 9 17:37:44 2014 +0100

    arm64: use cpu_online_mask when using forced irq_set_affinity
    
    Commit 01f8fa4f01d8("genirq: Allow forcing cpu affinity of interrupts")
    enabled the forced irq_set_affinity which previously refused to route an
    interrupt to an offline cpu.
    
    Commit ffde1de64012("irqchip: Gic: Support forced affinity setting")
    implements this force logic and disables the cpu online check for GIC
    interrupt controller.
    
    When __cpu_disable calls migrate_irqs, it disables the current cpu in
    cpu_online_mask and uses forced irq_set_affinity to migrate the IRQs
    away from the cpu but passes affinity mask with the cpu being offlined
    also included in it.
    
    When calling irq_set_affinity with force == true in a cpu hotplug path,
    the caller must ensure that the cpu being offlined is not present in the
    affinity mask or it may be selected as the target CPU, leading to the
    interrupt not being migrated.
    
    This patch uses cpu_online_mask when using forced irq_set_affinity so
    that the IRQs are properly migrated away.
    
    Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
    Acked-by: Mark Rutland <mark.rutland@arm.com>
    Cc: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

commit 7e9bc10db275b22a9db0f976b33b5aeed288da73
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sun May 11 17:14:49 2014 +0200

    netfilter: nf_tables: fix missing return trace at the end of non-base chain
    
    Display "return" for implicit rule at the end of a non-base chain,
    instead of when popping chain from the stack.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit f7e7e39b21c285ad73a62fac0736191b8d830704
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sat May 10 18:46:02 2014 +0200

    netfilter: nf_tables: fix bogus rulenum after goto action
    
    After returning from the chain that we just went to with no matchings,
    we get a bogus rule number in the trace. To fix this, we would need
    to iterate over the list of remaining rules in the chain to update the
    rule number counter.
    
    Patrick suggested to set this to the maximum value since the default
    base chain policy is the very last action when the processing the base
    chain is over.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7b9d5ef932297413adcbd8be98fe612b9527a312
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sat May 10 18:42:57 2014 +0200

    netfilter: nf_tables: fix tracing of the goto action
    
    Add missing code to trace goto actions.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 5467a512216753d54f757314c73dbc60f659f9e6
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sat May 10 18:33:11 2014 +0200

    netfilter: nf_tables: fix goto action
    
    This patch fixes a crash when trying to access the counters and the
    default chain policy from the non-base chain that we have reached
    via the goto chain. Fix this by falling back on the original base
    chain after returning from the custom chain.
    
    While fixing this, kill the inline function to account chain statistics
    to improve source code readability.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 1f53ba6e81749a420226e5502c49ab83ba85c81d
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu May 8 15:48:13 2014 +0000

    arm64: introduce virt_to_pfn
    
    virt_to_pfn has been defined in arch/arm/include/asm/memory.h by commit
    e26a9e0 "ARM: Better virt_to_page() handling" and Xen has come to rely
    on it.  Introduce virt_to_pfn on arm64 too.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Acked-by: Catalin Marinas <catalin.marinas@arm.com>

commit 84ea7fe37908254c3bd90910921f6e1045c1747a
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Mon May 12 13:42:29 2014 +0530

    hrtimer: Set expiry time before switch_hrtimer_base()
    
    switch_hrtimer_base() calls hrtimer_check_target() which ensures that
    we do not migrate a timer to a remote cpu if the timer expires before
    the current programmed expiry time on that remote cpu.
    
    But __hrtimer_start_range_ns() calls switch_hrtimer_base() before the
    new expiry time is set. So the sanity check in hrtimer_check_target()
    is operating on stale or even uninitialized data.
    
    Update expiry time before calling switch_hrtimer_base().
    
    [ tglx: Rewrote changelog once again ]
    
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: linaro-kernel@lists.linaro.org
    Cc: linaro-networking@linaro.org
    Cc: fweisbec@gmail.com
    Cc: arvind.chauhan@arm.com
    Link: http://lkml.kernel.org/r/81999e148745fc51bbcd0615823fbab9b2e87e23.1399882253.git.viresh.kumar@linaro.org
    Cc: stable@vger.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit 6d004d6cc73920299adf4cfe25010b348fc94395
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Mon May 12 09:09:26 2014 +0200

    vti: Use the tunnel mark for lookup in the error handlers.
    
    We need to use the mark we get from the tunnels o_key to
    lookup the right vti state in the error handlers. This patch
    ensures that.
    
    Fixes: df3893c1 ("vti: Update the ipv4 side to use it's own receive hook.")
    Fixes: fa9ad96d ("vti6: Update the ipv6 side to use its own receive hook.")
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

commit 3c90c55dcde745bed81f6447f24ba96bda43d984
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Tue May 6 23:26:19 2014 +0200

    drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
    
    If the kernel is built to support multi-ARM configuration with shmobile
    support built in, then drivers/sh is not built. This contains the PM
    runtime code in drivers/sh/pm_runtime.c, which implicitly enables the
    module clocks for all devices, and thus is quite essential.
    Without this, the state of clocks depends on implicit reset state, or on
    the bootloader.
    
    If ARCH_SHMOBILE_MULTI then build the drivers/sh directory, but ensure that
    bits that may conflict (drivers/sh/clk if the common clock framework is
    enabled) or are not used (drivers/sh/intc), are not built.
    Also, only enable the PM runtime code when actually running on a shmobile
    SoCs that needs it.
    
    ARCH_SHMOBILE_MULTI was added a while ago by commit
    efacfce5f8a523457e9419a25d52fe39db00b26a ("ARM: shmobile: Introduce
    ARCH_SHMOBILE_MULTI"), but drivers/sh was compiled for both
    ARCH_SHMOBILE_LEGACY and ARCH_SHMOBILE_MULTI until commit
    bf98c1eac1d4a6bcf00532e4fa41d8126cd6c187 ("ARM: Rename ARCH_SHMOBILE to
    ARCH_SHMOBILE_LEGACY").
    
    Inspired by a patch from Ben Dooks <ben.dooks@codethink.co.uk>.
    
    Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

commit fd71143645a9958e437c8cf394be2c44a6acb23a
Author: Mathias Krause <minipli@googlemail.com>
Date:   Fri May 9 23:43:40 2014 +0200

    vti6: Don't unregister pernet ops twice on init errors
    
    If we fail to register one of the xfrm protocol handlers we will
    unregister the pernet ops twice on the error exit path. This will
    probably lead to a kernel panic as the double deregistration
    leads to a double kfree().
    
    Fix this by removing one of the calls to do it only once.
    
    Fixes: fa9ad96d49 ("vti6: Update the ipv6 side to use its own...")
    Signed-off-by: Mathias Krause <minipli@googlemail.com>
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

commit 8050936caf125fbe54111ba5e696b68a360556ba
Author: Anton Blanchard <anton@samba.org>
Date:   Fri May 9 17:47:12 2014 +1000

    powerpc: irq work racing with timer interrupt can result in timer interrupt hang
    
    I am seeing an issue where a CPU running perf eventually hangs.
    Traces show timer interrupts happening every 4 seconds even
    when a userspace task is running on the CPU. /proc/timer_list
    also shows pending hrtimers have not run in over an hour,
    including the scheduler.
    
    Looking closer, decrementers_next_tb is getting set to
    0xffffffffffffffff, and at that point we will never take
    a timer interrupt again.
    
    In __timer_interrupt() we set decrementers_next_tb to
    0xffffffffffffffff and rely on ->event_handler to update it:
    
            *next_tb = ~(u64)0;
            if (evt->event_handler)
                    evt->event_handler(evt);
    
    In this case ->event_handler is hrtimer_interrupt. This will eventually
    call back through the clockevents code with the next event to be
    programmed:
    
    static int decrementer_set_next_event(unsigned long evt,
                                          struct clock_event_device *dev)
    {
            /* Don't adjust the decrementer if some irq work is pending */
            if (test_irq_work_pending())
                    return 0;
            __get_cpu_var(decrementers_next_tb) = get_tb_or_rtc() + evt;
    
    If irq work came in between these two points, we will return
    before updating decrementers_next_tb and we never process a timer
    interrupt again.
    
    This looks to have been introduced by 0215f7d8c53f (powerpc: Fix races
    with irq_work). Fix it by removing the early exit and relying on
    code later on in the function to force an early decrementer:
    
           /* We may have raced with new irq work */
           if (test_irq_work_pending())
                   set_dec(1);
    
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Cc: stable@vger.kernel.org # 3.14+
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1a466ae96e9f749d02a73315a3e66375e61a61dd
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Thu May 8 14:54:42 2014 -0700

    ptp: fix kconfig dependency warnings
    
    Fix kconfig warnings:
    
    PTP_1588_CLOCK selects NET_PTP_CLASSIFY, which depends on NET,
    so PTP_1588_CLOCK should also depend on NET.
    
    PTP_1588_CLOCK_PCH selects PTP_1588_CLOCK so the former should
    depend on NET.
    
    warning: (IXP4XX_ETH && PTP_1588_CLOCK) selects NET_PTP_CLASSIFY which has unmet direct dependencies (NET)
    
    warning: (SFC && TILE_NET && BFIN_MAC_USE_HWSTAMP && TIGON3 && FEC && E1000E && IGB && IXGBE && I40E && MLX4_EN && SXGBE_ETH && STMMAC_ETH && TI_CPTS && PTP_1588_CLOCK_GIANFAR && PTP_1588_CLOCK_IXP46X && DP83640_PHY && PTP_1588_CLOCK_PCH) selects PTP_1588_CLOCK which has unmet direct dependencies (NET)
    [This warning is caused by the new 'depends on NET' in PTP_1588_CLOCK.]
    
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Acked-by: Richard Cochran <richardcochran@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 7a5091d58419b4e5222abce58a40c072786ea1d6
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Sun May 11 20:25:20 2014 -0700

    x86, rdrand: When nordrand is specified, disable RDSEED as well
    
    One can logically expect that when the user has specified "nordrand",
    the user doesn't want any use of the CPU random number generator,
    neither RDRAND nor RDSEED, so disable both.
    
    Reported-by: Stephan Mueller <smueller@chronox.de>
    Cc: Theodore Ts'o <tytso@mit.edu>
    Link: http://lkml.kernel.org/r/21542339.0lFnPSyGRS@myon.chronox.de
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

commit 372cf1244d7c271806b83b32b09a1c8b1b31b353
Author: Gavin Shan <gwshan@linux.vnet.ibm.com>
Date:   Thu Apr 24 18:00:22 2014 +1000

    powerpc/powernv: Reset root port in firmware
    
    Resetting root port has more stuff to do than that for PCIe switch
    ports and we should have resetting root port done in firmware instead
    of the kernel itself. The problem was introduced by commit 5b2e198e
    ("powerpc/powernv: Rework EEH reset").
    
    Cc: linux-stable <stable@vger.kernel.org>
    Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 21855ff5bcbdd075e1c99772827a84912ab083dd
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Thu May 8 12:57:23 2014 -0700

    intel_pstate: Set turbo VID for BayTrail
    
    A documentation update exposed that there is a separate set of VID
    values that must be used in the turbo/boost P state range.  Add
    enumerating and setting the correct VID for P states in the turbo
    range.
    
    Cc: v3.13+ <stable@vger.kernel.org> # v3.13+
    Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f759546498d820670934c901a2fdf1ce948d2e5c
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon May 12 01:13:28 2014 +0200

    ACPI / TPM: Fix resume regression on Chromebooks
    
    Chromebooks (at least Acer C720 and Pixel) implement an ACPI object
    for TPM, but don't implement the _DSM method to support PPI.  As
    a result, the TPM driver fails to load on those machines after
    commit 1569a4c4ceba (ACPI / TPM: detect PPI features by checking
    availability of _DSM functions) which causes them to fail to
    resume from system suspend, becuase they require the TPM hardware
    to be put into the right state during resume and the TPM driver
    is necessary for that.
    
    Fix the problem by making tpm_add_ppi() return 0 when tpm_ppi_handle
    is still NULL after walking the ACPI namespace in search for the PPI
    _DSM, which allows the TPM driver to load and operate the hardware
    (during system resume in particular), but avoid creating the PPI
    sysfs group in that case.
    
    This change is based on a prototype patch from Jiang Liu.
    
    Fixes: 1569a4c4ceba (ACPI / TPM: detect PPI features by checking availability of _DSM functions)
    References: https://bugzilla.kernel.org/show_bug.cgi?id=74021
    Reported-by: James Duley <jagduley@gmail.com>
    Reported-by: Phillip Dixon <phil@dixon.gen.nz>
    Tested-by: Brandon Casey <drafnel@gmail.com>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1c4abec0baf25ffb92a28cc99d4231feeaa4d3f3
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Thu May 8 09:48:10 2014 +0300

    iwlwifi: mvm: fix setting channel in monitor mode
    
    There was a deadlock in monitor mode when we were setting the
    channel if the channel was not 1.
    
    ======================================================
    [ INFO: possible circular locking dependency detected ]
    3.14.3 #4 Not tainted
    -------------------------------------------------------
    iw/3323 is trying to acquire lock:
     (&local->chanctx_mtx){+.+.+.}, at: [<ffffffffa062e2f2>] ieee80211_vif_release_channel+0x42/0xb0 [mac80211]
    
    but task is already holding lock:
     (&local->iflist_mtx){+.+...}, at: [<ffffffffa0609e0a>] ieee80211_set_monitor_channel+0x5a/0x1b0 [mac80211]
    
    which lock already depends on the new lock.
    
    the existing dependency chain (in reverse order) is:
    
    -> #2 (&local->iflist_mtx){+.+...}:
           [<ffffffff810d95bb>] __lock_acquire+0xb3b/0x13b0
           [<ffffffff810d9ee0>] lock_acquire+0xb0/0x1f0
           [<ffffffff817eb9c8>] mutex_lock_nested+0x78/0x4f0
           [<ffffffffa06225cf>] ieee80211_iterate_active_interfaces+0x2f/0x60 [mac80211]
           [<ffffffffa0518189>] iwl_mvm_recalc_multicast+0x49/0xa0 [iwlmvm]
           [<ffffffffa051822e>] iwl_mvm_configure_filter+0x4e/0x70 [iwlmvm]
           [<ffffffffa05e6d43>] ieee80211_configure_filter+0x153/0x5f0 [mac80211]
           [<ffffffffa05e71f5>] ieee80211_reconfig_filter+0x15/0x20 [mac80211]
           [snip]
    
    -> #1 (&mvm->mutex){+.+.+.}:
           [<ffffffff810d95bb>] __lock_acquire+0xb3b/0x13b0
           [<ffffffff810d9ee0>] lock_acquire+0xb0/0x1f0
           [<ffffffff817eb9c8>] mutex_lock_nested+0x78/0x4f0
           [<ffffffffa0517246>] iwl_mvm_add_chanctx+0x56/0xe0 [iwlmvm]
           [<ffffffffa062ca1e>] ieee80211_new_chanctx+0x13e/0x410 [mac80211]
           [<ffffffffa062d953>] ieee80211_vif_use_channel+0x1c3/0x5a0 [mac80211]
           [<ffffffffa06035ab>] ieee80211_add_virtual_monitor+0x1ab/0x6b0 [mac80211]
           [<ffffffffa06052ea>] ieee80211_do_open+0xe6a/0x15a0 [mac80211]
           [<ffffffffa0605a79>] ieee80211_open+0x59/0x60 [mac80211]
           [snip]
    
    -> #0 (&local->chanctx_mtx){+.+.+.}:
           [<ffffffff810d6cb7>] check_prevs_add+0x977/0x980
           [<ffffffff810d95bb>] __lock_acquire+0xb3b/0x13b0
           [<ffffffff810d9ee0>] lock_acquire+0xb0/0x1f0
           [<ffffffff817eb9c8>] mutex_lock_nested+0x78/0x4f0
           [<ffffffffa062e2f2>] ieee80211_vif_release_channel+0x42/0xb0 [mac80211]
           [<ffffffffa0609ec3>] ieee80211_set_monitor_channel+0x113/0x1b0 [mac80211]
           [<ffffffffa058fb37>] cfg80211_set_monitor_channel+0x77/0x2b0 [cfg80211]
           [<ffffffffa056e0b2>] __nl80211_set_channel+0x122/0x140 [cfg80211]
           [<ffffffffa0581374>] nl80211_set_wiphy+0x284/0xaf0 [cfg80211]
           [snip]
    
    other info that might help us debug this:
    
    Chain exists of:
      &local->chanctx_mtx --> &mvm->mutex --> &local->iflist_mtx
    
     Possible unsafe locking scenario:
    
           CPU0                    CPU1
           ----                    ----
      lock(&local->iflist_mtx);
                                   lock(&mvm->mutex);
                                   lock(&local->iflist_mtx);
      lock(&local->chanctx_mtx);
    
     *** DEADLOCK ***
    
    This deadlock actually occurs:
    INFO: task iw:3323 blocked for more than 120 seconds.
          Not tainted 3.14.3 #4
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    iw              D ffff8800c8afcd80  4192  3323   3322 0x00000000
     ffff880078fdb7e0 0000000000000046 ffff8800c8afcd80 ffff880078fdbfd8
     00000000001d5540 00000000001d5540 ffff8801141b0000 ffff8800c8afcd80
     ffff880078ff9e38 ffff880078ff9e38 ffff880078ff9e40 0000000000000246
    Call Trace:
     [<ffffffff817ea841>] schedule_preempt_disabled+0x31/0x80
     [<ffffffff817ebaed>] mutex_lock_nested+0x19d/0x4f0
     [<ffffffffa06225cf>] ? ieee80211_iterate_active_interfaces+0x2f/0x60 [mac80211]
     [<ffffffffa06225cf>] ? ieee80211_iterate_active_interfaces+0x2f/0x60 [mac80211]
     [<ffffffffa052a680>] ? iwl_mvm_power_mac_update_mode+0xc0/0xc0 [iwlmvm]
     [<ffffffffa06225cf>] ieee80211_iterate_active_interfaces+0x2f/0x60 [mac80211]
     [<ffffffffa0529357>] _iwl_mvm_power_update_binding+0x27/0x80 [iwlmvm]
     [<ffffffffa0516eb1>] iwl_mvm_unassign_vif_chanctx+0x81/0xc0 [iwlmvm]
     [<ffffffffa062d3ff>] __ieee80211_vif_release_channel+0xdf/0x470 [mac80211]
     [<ffffffffa062e2fa>] ieee80211_vif_release_channel+0x4a/0xb0 [mac80211]
     [<ffffffffa0609ec3>] ieee80211_set_monitor_channel+0x113/0x1b0 [mac80211]
     [<ffffffffa058fb37>] cfg80211_set_monitor_channel+0x77/0x2b0 [cfg80211]
     [<ffffffffa056e0b2>] __nl80211_set_channel+0x122/0x140 [cfg80211]
     [<ffffffffa0581374>] nl80211_set_wiphy+0x284/0xaf0 [cfg80211]
    
    This fixes https://bugzilla.kernel.org/show_bug.cgi?id=75541
    
    Cc: <stable@vger.kernel.org> [3.13+]
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 7e338c9991ecee9c2ac7a4cee2c2e11ecb563d02
Merge: 9cf22e8 aa07c71
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 11 18:06:13 2014 +0900

    Merge branch 'for-3.15' of git://linux-nfs.org/~bfields/linux
    
    Pull nfsd fixes from Bruce Fields.
    
    * 'for-3.15' of git://linux-nfs.org/~bfields/linux:
      NFSD: Call ->set_acl with a NULL ACL structure if no entries
      NFSd: call rpc_destroy_wait_queue() from free_client()
      NFSd: Move default initialisers from create_client() to alloc_client()

commit 9cf22e80df77b3f8459559e156f6322657e17090
Merge: d6d211d dd18dbc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 11 17:56:53 2014 +0900

    Merge branch 'akpm' (incoming from Andrew)
    
    Merge misc fixes from Andrew Morton:
     "4 fixes"
    
    * emailed patches from Andrew Morton <akpm@linux-foundation.org>:
      mm, thp: close race between mremap() and split_huge_page()
      mm: postpone the disabling of kmemleak early logging
      MAINTAINERS: update maintainership of LTP
      drivers/rtc/rtc-hym8563.c: set uie_unsupported

commit dd18dbc2d42af75fffa60c77e0f02220bc329829
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Fri May 9 15:37:00 2014 -0700

    mm, thp: close race between mremap() and split_huge_page()
    
    It's critical for split_huge_page() (and migration) to catch and freeze
    all PMDs on rmap walk.  It gets tricky if there's concurrent fork() or
    mremap() since usually we copy/move page table entries on dup_mm() or
    move_page_tables() without rmap lock taken.  To get it work we rely on
    rmap walk order to not miss any entry.  We expect to see destination VMA
    after source one to work correctly.
    
    But after switching rmap implementation to interval tree it's not always
    possible to preserve expected walk order.
    
    It works fine for dup_mm() since new VMA has the same vma_start_pgoff()
    / vma_last_pgoff() and explicitly insert dst VMA after src one with
    vma_interval_tree_insert_after().
    
    But on move_vma() destination VMA can be merged into adjacent one and as
    result shifted left in interval tree.  Fortunately, we can detect the
    situation and prevent race with rmap walk by moving page table entries
    under rmap lock.  See commit 38a76013ad80.
    
    Problem is that we miss the lock when we move transhuge PMD.  Most
    likely this bug caused the crash[1].
    
    [1] http://thread.gmane.org/gmane.linux.kernel.mm/96473
    
    Fixes: 108d6642ad81 ("mm anon rmap: remove anon_vma_moveto_tail")
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Rik van Riel <riel@redhat.com>
    Acked-by: Michel Lespinasse <walken@google.com>
    Cc: Dave Jones <davej@redhat.com>
    Cc: David Miller <davem@davemloft.net>
    Acked-by: Johannes Weiner <hannes@cmpxchg.org>
    Cc: <stable@vger.kernel.org>        [3.7+]
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 3551a9280bcb728980a13783ff295e9f0bdedd9a
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Fri May 9 15:36:59 2014 -0700

    mm: postpone the disabling of kmemleak early logging
    
    Commit 8910ae896c8c ("kmemleak: change some global variables to int"),
    in addition to the atomic -> int conversion, moved the disabling of
    kmemleak_early_log to the beginning of the kmemleak_init() function,
    before the full kmemleak tracing is actually enabled.  In this small
    window, kmem_cache_create() is called by kmemleak which triggers
    additional memory allocation that are not traced.  This patch restores
    the original logic with kmemleak_early_log disabling when kmemleak is
    fully functional.
    
    Fixes: 8910ae896c8c (kmemleak: change some global variables to int)
    
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Sasha Levin <sasha.levin@oracle.com>
    Cc: Li Zefan <lizefan@huawei.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f2eb7f6f7a18fc2eff2f74d2bfa12758c0449f12
Author: Cyril Hrubis <chrubis@suse.cz>
Date:   Fri May 9 15:36:58 2014 -0700

    MAINTAINERS: update maintainership of LTP
    
    Also remove sf.net git repo which is no longer available and update link
    to LTP web pages.
    
    Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
    Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
    Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
    Signed-off-by: Jan Stancek <jstancek@redhat.com>
    Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
    Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 282cba6b00a95f0277ed71551e3f6b0477e8836b
Author: Heiko Stuebner <heiko@sntech.de>
Date:   Fri May 9 15:36:57 2014 -0700

    drivers/rtc/rtc-hym8563.c: set uie_unsupported
    
    The alarm of the hym8563 only supports a minute accuracy, while the uie
    wants an alarm one second in the future.  Therefore things like the
    select() syscall will fail with a timeout, because the next alarm will
    happen in a worst case of 60 seconds.
    
    Signed-off-by: Heiko Stuebner <heiko@sntech.de>
    Cc: Alessandro Zummo <a.zummo@towertech.it>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 709de13f0c532fe9c468c094aff069a725ed57fe
Author: Simon Wunderlich <simon@open-mesh.com>
Date:   Wed Mar 26 15:46:24 2014 +0100

    batman-adv: fix removing neigh_ifinfo
    
    When an interface is removed separately, all neighbors need to be
    checked if they have a neigh_ifinfo structure for that particular
    interface. If that is the case, remove that ifinfo so any references to
    a hard interface can be freed.
    
    This is a regression introduced by
    89652331c00f43574515059ecbf262d26d885717
    ("batman-adv: split tq information in neigh_node struct")
    
    Reported-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit a45e903842226071d231924a5bff09d7535109dc
Merge: a4b4f11 ad3b564
Author: Ingo Molnar <mingo@kernel.org>
Date:   Sun May 11 07:22:28 2014 +0200

    Merge branch 'liblockdep-fixes-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux into perf/urgent
    
    Pull liblockdep fixes from Sasha Levin, to fix two build related bugs.
    
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 3b27dcec920075b6f1f5f8014e32e764fcbb96f8
Merge: 6a7c7b0 cf7eb97
Author: Olof Johansson <olof@lixom.net>
Date:   Sat May 10 22:06:07 2014 -0700

    Merge tag 'davinci-fixes-for-v3.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into fixes
    
    Pull "DaVinci fixes for v3.15" from Sekhar Nori:
    
    The patch fixes EDMA crossbar mapping to actually
    make it work. The patch has been tagged for stable.
    
    * tag 'davinci-fixes-for-v3.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci:
      ARM: common: edma: Fix xbar mapping
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 6a7c7b007a773a846090f2577de32e7b3a3f42ab
Merge: e5e49fe 84e108f
Author: Olof Johansson <olof@lixom.net>
Date:   Sat May 10 20:25:07 2014 -0700

    Merge tag 'sunxi-fixes-for-3.15' of https://github.com/mripard/linux into fixes
    
    Merge 'Allwinner fixes for 3.15' from Maxime Ripard:
    
    Set of fixes for the Allwinner support for 3.15
    
    Some minor things, the major thing being the enabling of the GMAC driver in
    sunxi_defconfig that will un-break Olof's autobooters.
    
    * tag 'sunxi-fixes-for-3.15' of https://github.com/mripard/linux:
      ARM: sunxi: Enable GMAC in sunxi_defconfig
      ARM: sun7i: Fix i2c4 base address
      ARM: sun7i: fix PLL4 clock and add PLL8
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit e5e49fe9dfe33beabd0af593870cc9247ba481a6
Merge: 90f4c59 788296b
Author: Olof Johansson <olof@lixom.net>
Date:   Sat May 10 20:22:29 2014 -0700

    Merge tag 'mvebu-dt-fixes-3.15-2' of git://git.infradead.org/linux-mvebu into fixes
    
    Merge 'ARM: mvebu: DT fixes for v3.15 (incr #2)' from Jason Cooper:
    
    mvebu DT fixes for v3.15 (incremental #2)
    
     - kirkwood: fix mis-located pcie controller nodes
    
    * tag 'mvebu-dt-fixes-3.15-2' of git://git.infradead.org/linux-mvebu:
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 90f4c5944b38b4647373db7a57a2dda1e0c5566a
Author: Matt Porter <mporter@linaro.org>
Date:   Tue May 6 12:09:45 2014 -0400

    MAINTAINERS: update Broadcom ARM tree location and add an SoC family
    
    The Broadcom ARM tree location has changed names to reflect other SoC
    families that are queued here. Also add the 216xx family as maintained.
    
    Signed-off-by: Matt Porter <mporter@linaro.org>
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 6d66da89bf4422c0a0693627fb3e25f74af50f92
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Tue May 6 13:01:34 2014 +0200

    ARM: dts: i.MX53: Fix ipu register space size
    
    The IPU register space is 128MB, not 2GB.
    
    Fixes: abed9a6bf2bb 'ARM i.MX53: Add IPU support'
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Acked-by: Shawn Guo <shawn.guo@freescale.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit d088be8042841f024156ee68fecfef7503d660cb
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sat May 10 13:39:21 2014 +0200

    netfilter: nf_tables: reset rule number counter after jump and goto
    
    Otherwise we start incrementing the rule number counter from the
    previous chain iteration.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3afcb96fee9ba33ce838f2ceaa248358cffe2f56
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Sat May 10 13:51:36 2014 +0200

    ACPI / proc: Do not say when /proc interfaces will be deleted in Kconfig
    
    Do not tell people in the Kconfig help when exactly we are going to
    remove the deprecated ACPI interfaces in /proc, because, honestly,
    we don't know.  We will remove them when they are not used any more.
    
    In particular, do not tell them that the interfaces will be removed
    in a kernel release that already happened long ago.
    
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7b955a9fc164487d7c51acb9787f6d1b01b35ef6
Author: Simon Wunderlich <simon@open-mesh.com>
Date:   Wed Mar 26 15:46:23 2014 +0100

    batman-adv: always run purge_orig_neighbors
    
    The current code will not execute batadv_purge_orig_neighbors() when an
    orig_ifinfo has already been purged. However we need to run it in any
    case. Fix that.
    
    This is a regression introduced by
    7351a4822d42827ba0110677c0cbad88a3d52585
    ("batman-adv: split out router from orig_node")
    
    Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit 000c8dff97311357535d64539e58990526e4de70
Author: Simon Wunderlich <simon@open-mesh.com>
Date:   Wed Mar 26 15:46:22 2014 +0100

    batman-adv: fix neigh reference imbalance
    
    When an interface is removed from batman-adv, the orig_ifinfo of a
    orig_node may be removed without releasing the router first.
    This will prevent the reference for the neighbor pointed at by the
    orig_ifinfo->router to be released, and this leak may result in
    reference leaks for the interface used by this neighbor. Fix that.
    
    This is a regression introduced by
    7351a4822d42827ba0110677c0cbad88a3d52585
    ("batman-adv: split out router from orig_node").
    
    Reported-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit c1e517fbbcdb13f50662af4edc11c3251fe44f86
Author: Simon Wunderlich <simon@open-mesh.com>
Date:   Wed Mar 26 15:46:21 2014 +0100

    batman-adv: fix neigh_ifinfo imbalance
    
    The neigh_ifinfo object must be freed if it has been used in
    batadv_iv_ogm_process_per_outif().
    
    This is a regression introduced by
    89652331c00f43574515059ecbf262d26d885717
    ("batman-adv: split tq information in neigh_node struct")
    
    Reported-by: Antonio Quartulli <antonio@open-mesh.com>
    Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
    Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
    Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>

commit 1448eb566970c6d3cade522419848fdaee24c684
Merge: a9de050 6153871
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 9 16:46:53 2014 -0400

    Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
    
    John W. Linville says:
    
    ====================
    pull request: wireless 2014-05-08
    
    This one is all from Johannes:
    
    "Here are a few small fixes for the current cycle: radiotap TX flags were
    wrong (fix by Bob), Chun-Yeow fixes an SMPS issue with mesh interfaces,
    Eliad fixes a locking bug and a cfg80211 state problem and finally
    Henning sent me a fix for IBSS rate information."
    
    Please let me know if there are problems!
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a9de0500083c18589ba2ea4543135c1bea8419ec
Author: Emil Goode <emilgoode@gmail.com>
Date:   Fri May 9 01:07:17 2014 +0200

    net: cassini: use nested lock annotation
    
    In the cas_lock_tx function we acquire multiple locks in a loop and
    need to use nested lock annotation to prevent lockdep warnings.
    
    Reported-by: Meelis Roos <mroos@linux.ee>
    Signed-off-by: Emil Goode <emilgoode@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit de682941eef3e5f6d1b653a6c214bc8a288f17c1
Author: Yuval Mintz <Yuval.Mintz@qlogic.com>
Date:   Thu May 8 12:34:31 2014 +0300

    bnx2x: Fix UNDI driver unload
    
    Commit 91ebb928b "bnx2x: Add support for Multi-Function UNDI" contains a bug
    which prevent the emptying of the device's Rx buffers before reset.
    As a result, on new boards it is likely HW will reach some fatal assertion
    once its interfaces load after UNDI was previously loaded.
    
    Signed-off-by: Yuval Mintz <Yuval.Mintz@qlogic.com>
    Signed-off-by: Ariel Elior <Ariel.Elior@qlogic.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 27653053be95681a0e87df90c9fbe9d1c16a3e81
Merge: 6b5eeb7 60e71ab
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 9 15:51:25 2014 -0400

    Merge branch 'mdio_net'
    
    Johan Hovold says:
    
    ====================
    net: cpsw and mdio-gpio fixes for v3.15-final
    
    These patches against v3.15-rc4 fix a few issues in the cpsw and
    mdio-gpio drivers.
    
    Resend with proper stable CC (git send-email still fails to parse the
    
    Sorry about the noise.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 60e71ab56b5fbd839aaef4f4af7778d86e0206f0
Author: Johan Hovold <jhovold@gmail.com>
Date:   Thu May 8 10:09:24 2014 +0200

    net: cpsw: add missing of_node_put
    
    Add missing of_node_put to avoid kref leak.
    
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 6954cc1f238199e971ec905c5cc87120806ac981
Author: Johan Hovold <jhovold@gmail.com>
Date:   Thu May 8 10:09:23 2014 +0200

    net: cpsw: fix null dereference at probe
    
    Fix null-pointer dereference at probe when the mdio platform device is
    missing (e.g. when it has been disabled in DT).
    
    Cc: stable <stable@vger.kernel.org>	# v3.8
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 59993f48b38fd46863b23bb1bb1dc3291e7278fb
Author: Johan Hovold <jhovold@gmail.com>
Date:   Thu May 8 10:09:22 2014 +0200

    Revert "net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver"
    
    This reverts commit f8d56d8f892be43a2404356073e16401eb5a42e6 ("net:
     eth: cpsw: Correctly attach to GPIO bitbang MDIO driver").
    
    Fix potential null-pointer dereference at probe if the mdio-gpio device
    has not been successfully probed yet.
    
    The offending commit is plain wrong for a number of reasons. First of
    all it accesses internal driver data of an unrelated device. Neither
    does it check that the data is non-null (which it is in case the device
    has not been probed yet).
    
    Furthermore, the decision on whether to treat any driver data according
    to the mdio-gpio driver's internals is made based on the node name. But
    the name is not compared against "mdio" which is the normal name for the
    node, but rather against "gpio" which the node does not have to be named
    (and shouldn't be according to the binding documentation). [ If this
    hack is to be kept out-of-tree it should at least be matching against
    the compatible property. ]
    
    Cc: Stefan Roese <sr@denx.de>
    Cc: stable <stable@vger.kernel.org>	# v3.14
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 7f52da56f76f61112a9c1db41975376764828e71
Author: Johan Hovold <jhovold@gmail.com>
Date:   Thu May 8 10:09:21 2014 +0200

    net: mdio-gpio: warn about missing bus alias id
    
    Use a sane default bus id (rather than -ENODEV) and print a warning when
    the bus alias id is missing.
    
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 0953f78971040fff09064bb564d9ac0cd1fb4e69
Author: Johan Hovold <jhovold@gmail.com>
Date:   Thu May 8 10:09:20 2014 +0200

    net: mdio-gpio: fix device-tree binding documentation
    
    Fix aliases syntax in device-tree binding example to avoid
    copy-paste errors (the alias would be dropped silently).
    
    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 05adaf1f101f25f40f12c29403e6488f0e45f6b6
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri May 9 14:52:34 2014 +0300

    drm/i915/vlv: reset VLV media force wake request register
    
    Media force wake get hangs the machine when the system is booted without
    displays attached. The assumption is that (at least some versions of)
    the firmware has skipped some initialization in that case.
    
    Empirical evidence suggests we need to reset the media force wake
    request register in addition to the render one to avoid hangs.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=75895
    Reported-by: Imre Deak <imre.deak@intel.com>
    Reported-by: Darren Hart <dvhart@linux.intel.com>
    Tested-by: Darren Hart <dvhart@linux.intel.com>
    Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit 6b5eeb7f874b689403e52a646e485d0191ab9507
Author: Bjørn Mork <bjorn@mork.no>
Date:   Fri May 9 14:45:00 2014 +0200

    net: cdc_mbim: handle unaccelerated VLAN tagged frames
    
    This driver maps 802.1q VLANs to MBIM sessions. The mapping is based on
    a bogus assumption that all tagged frames will use the acceleration API
    because we enable NETIF_F_HW_VLAN_CTAG_TX. This fails for e.g. frames
    tagged in userspace using packet sockets. Such frames will erroneously
    be considered as untagged and silently dropped based on not being IP.
    
    Fix by falling back to looking into the ethernet header for a tag if no
    accelerated tag was found.
    
    Fixes: a82c7ce5bc5b ("net: cdc_ncm: map MBIM IPS SessionID to VLAN ID")
    Cc: Greg Suarez <gsuarez@smithmicro.com>
    Signed-off-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit b3d4056632297232412dda95c9b72b1199fa797d
Merge: 6af55ff a8951d5
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 9 13:17:30 2014 -0400

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
    
    Pablo Neira Ayuso says:
    
    ====================
    Netfilter fixes for net
    
    The following batch contains netfilter fixes for your net tree, they are:
    
    1) Fix use after free in nfnetlink when sending a batch for some
       unsupported subsystem, from Denys Fedoryshchenko.
    
    2) Skip autoload of the nat module if no binding is specified via
       ctnetlink, from Florian Westphal.
    
    3) Set local_df after netfilter defragmentation to avoid a bogus ICMP
       fragmentation needed in the forwarding path, also from Florian.
    
    4) Fix potential user after free in ip6_route_me_harder() when returning
       the error code to the upper layers, from Sergey Popovich.
    
    5) Skip possible bogus ICMP time exceeded emitted from the router (not
       valid according to RFC) if conntrack zones are used, from Vasily Averin.
    
    6) Fix fragment handling when nf_defrag_ipv4 is loaded but nf_conntrack
       is not present, also from Vasily.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit cf01f4eef9fe367ec0d85b38dd7214e29e376cdb
Author: Jeff Layton <jlayton@poochiereds.net>
Date:   Fri May 9 11:41:54 2014 -0400

    locks: only validate the lock vs. f_mode in F_SETLK codepaths
    
    v2: replace missing break in switch statement (as pointed out by Dave
        Jones)
    
    commit bce7560d4946 (locks: consolidate checks for compatible
    filp->f_mode values in setlk handlers) introduced a regression in the
    F_GETLK handler.
    
    flock64_to_posix_lock is a shared codepath between F_GETLK and F_SETLK,
    but the f_mode checks should only be applicable to the F_SETLK codepaths
    according to POSIX.
    
    Instead of just reverting the patch, add a new function to do this
    checking and have the F_SETLK handlers call it.
    
    Cc: Dave Jones <davej@redhat.com>
    Reported-and-Tested-by: Reuben Farrelly <reuben@reub.net>
    Signed-off-by: Jeff Layton <jlayton@poochiereds.net>

commit f9ac71bfcc5c937ff02765dc316cf5bc01d21d97
Author: Eliad Peller <eliad@wizery.com>
Date:   Wed Feb 26 14:46:35 2014 +0200

    mac80211: fix vif name tracing
    
    If sdata doesn't have a valid dev (e.g. in case of monitor
    vif), the vif_name field was initialized with (a length of)
    some short string, but later was set to a different,
    potentially larger one.
    
    This resulted in out-of-bounds write, which usually
    appeared as garbage in the trace log.
    
    Simply trace sdata->name, as it should always have the
    correct name for both cases.
    
    Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 99e4b98dbe3ad1fe38a74d12c3b8d44a55930de4
Author: Michael Welling <mwelling@ieee.org>
Date:   Wed Apr 16 20:00:24 2014 -0500

    gpio: mcp23s08: Bug fix of SPI device tree registration.
    
    The chips variable needs to be incremented for each chip that is
    found in the spi_present_mask when registering via device tree.
    Without this and the checking a negative index is passed to the
    data->chip array in a subsequent loop.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Michael Welling <mwelling@ieee.org>
    Acked-by: Peter Korsgaard <peter@korsgaard.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

commit a7008ee1a423720e755e08f33b63669795c1f072
Author: Vincent Donnefort <vdonnefort@gmail.com>
Date:   Tue Apr 15 14:21:43 2014 +0200

    gpio: ich: set regs and reglen for i3100 and ich6 chipset
    
    This patch fixes kernel NULL pointer BUG introduced by the following commit:
    b667cf488aa9476b0ab64acd91f2a96f188cfd21
    gpio: ich: Add support for multiple register addresses.
    
    Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
    Tested-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

commit 4a817aa78f573c6964f16d9aea3d0d10a226ade4
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri May 9 09:56:53 2014 +0200

    mac80211: allow VHT with peers not capable of 40MHz
    
    There are two (related) issues with this.
    
    One case, reported by Michal, is related to hostap: it unsets the
    20/40 capability bit for stations that associate when it's in 20
    MHz mode.
    
    The other case, reported by Eyal, is that some APs like Netgear
    R6300v2 and probably others based on the BCM4360 chipset can be
    configured for doing VHT at 20Mhz. In this case the beacon has
    a VHT IE but the HT cap indicates transmitter only support 20Mhz.
    
    In both of these cases, we currently avoid VHT and use only HT
    this means we can't use the highest rates (MCS8), so fixing this
    leads to throughput improvements.
    
    Reported-by: Michal Kazior <michal.kazior@tieto.com>
    Reported-by: Eyal Shapira <eyal@wizery.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit a1f3b5fa11dfc636288b9e0190a0289f23d95af6
Author: Hui Wang <hui.wang@canonical.com>
Date:   Fri May 9 11:12:58 2014 +0800

    ALSA: hda - add headset mic detect quirks for three Dell laptops
    
    When we plug a 3-ring headset on the Dell machines (VID: 0x10ec0255,
    SID: 0x1028065c; VID: 0x10ec0255, SID: 0x10280680; VID: 0x10ec0292,
    SID: 0x10280684), the headset mic can't be detected, after apply this
    patch, the headset mic can work well.
    
    And on the machine with SID 0x10280684, and the Lineout and external
    microphone should be routed to docking, this patch also fix this
    problem.
    
    BugLink: https://bugs.launchpad.net/bugs/1297581
    Cc: David Henningsson <david.henningsson@canonical.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Hui Wang <hui.wang@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

commit 6af55ff52b02d492d45db88df3e461fa51a6f753
Author: Darek Marcinkiewicz <reksio@newterm.pl>
Date:   Tue May 6 22:24:50 2014 +0200

    Driver for Beckhoff CX5020 EtherCAT master module.
    
    This driver adds support for EtherCAT master module located on CCAT
    FPGA found on Beckhoff CX series industrial PCs. The driver exposes
    EtherCAT master as an ethernet interface.
    
    EtherCAT is a fieldbus protocol defined on top of ethernet and Beckhoff
    CX5020 PCs come with built-in EtherCAT master module located on a FPGA,
    which in turn is connected to a PCI bus.
    
    Signed-off-by: Dariusz Marcinkiewicz <reksio@newterm.pl>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ba6b918ab234186d3aa1663e296586a1b526b77a
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue May 6 11:02:50 2014 -0700

    ping: move ping_group_range out of CONFIG_SYSCTL
    
    Similarly, when CONFIG_SYSCTL is not set, ping_group_range should still
    work, just that no one can change it. Therefore we should move it out of
    sysctl_net_ipv4.c. And, it should not share the same seqlock with
    ip_local_port_range.
    
    BTW, rename it to ->ping_group_range instead.
    
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Francois Romieu <romieu@fr.zoreil.com>
    Reported-by: Stefan de Konink <stefan@konink.de>
    Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c9d8f1a64225dfcc2f721d73a5984a2444920744
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue May 6 11:02:49 2014 -0700

    ipv4: move local_port_range out of CONFIG_SYSCTL
    
    When CONFIG_SYSCTL is not set, ip_local_port_range should still work,
    just that no one can change it. Therefore we should move it out of sysctl_inet.c.
    Also, rename it to ->ip_local_ports instead.
    
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Francois Romieu <romieu@fr.zoreil.com>
    Reported-by: Stefan de Konink <stefan@konink.de>
    Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a8951d5814e1373807a94f79f7ccec7041325470
Author: Sergey Popovich <popovich_sergei@mail.ru>
Date:   Thu May 8 16:22:35 2014 +0300

    netfilter: Fix potential use after free in ip6_route_me_harder()
    
    Dst is released one line before we access it again with dst->error.
    
    Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
    ip6_route_me_harder()
    
    Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit b18eb2d779240631a098626cb6841ee2dd34fda0
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 7 14:07:32 2014 -0700

    sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
    
    Access to the TSB hash tables during TLB misses requires that there be
    an atomic 128-bit quad load available so that we fetch a matching TAG
    and DATA field at the same time.
    
    On cpus prior to UltraSPARC-III only virtual address based quad loads
    are available.  UltraSPARC-III and later provide physical address
    based variants which are easier to use.
    
    When we only have virtual address based quad loads available this
    means that we have to lock the TSB into the TLB at a fixed virtual
    address on each cpu when it runs that process.  We can't just access
    the PAGE_OFFSET based aliased mapping of these TSBs because we cannot
    take a recursive TLB miss inside of the TLB miss handler without
    risking running out of hardware trap levels (some trap combinations
    can be deep, such as those generated by register window spill and fill
    traps).
    
    Without huge pages it's working perfectly fine, but when the huge TSB
    got added another chunk of fixed virtual address space was not
    allocated for this second TSB mapping.
    
    So we were mapping both the 8K and 4MB TSBs to the same exact virtual
    address, causing multiple TLB matches which gives undefined behavior.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ad3b564deb91c67ff9621255307ed31da870c8f7
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Thu May 8 13:55:13 2014 -0400

    tools/liblockdep: Remove all build files when doing make clean
    
    We forgot to remove the shared library with the version number when
    'make clean' ran, fix the clean pattern.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

commit 0041898ec19f10e2adf5f1245f32df88d627ae8a
Author: S. Lockwood-Childs <sjl@vctlabs.com>
Date:   Thu May 8 13:34:01 2014 -0400

    tools/liblockdep: Build liblockdep from tools/Makefile
    
    add targets to build liblockdep with
      make -C tools liblockdep
    like the way other stuff under tools/ can be built
    
    Signed-off-by: S. Lockwood-Childs <sjl@vctlabs.com>
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

commit aa07c713ecfc0522916f3cd57ac628ea6127c0ec
Author: Kinglong Mee <kinglongmee@gmail.com>
Date:   Fri Apr 18 20:49:04 2014 +0800

    NFSD: Call ->set_acl with a NULL ACL structure if no entries
    
    After setting ACL for directory, I got two problems that caused
    by the cached zero-length default posix acl.
    
    This patch make sure nfsd4_set_nfs4_acl calls ->set_acl
    with a NULL ACL structure if there are no entries.
    
    Thanks for Christoph Hellwig's advice.
    
    First problem:
    ............ hang ...........
    
    Second problem:
    [ 1610.167668] ------------[ cut here ]------------
    [ 1610.168320] kernel BUG at /root/nfs/linux/fs/nfsd/nfs4acl.c:239!
    [ 1610.168320] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
    [ 1610.168320] Modules linked in: nfsv4(OE) nfs(OE) nfsd(OE)
    rpcsec_gss_krb5 fscache ip6t_rpfilter ip6t_REJECT cfg80211 xt_conntrack
    rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
    ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
    ip6table_mangle ip6table_security ip6table_raw ip6table_filter
    ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
    nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
    auth_rpcgss nfs_acl snd_intel8x0 ppdev lockd snd_ac97_codec ac97_bus
    snd_pcm snd_timer e1000 pcspkr parport_pc snd parport serio_raw joydev
    i2c_piix4 sunrpc(OE) microcode soundcore i2c_core ata_generic pata_acpi
    [last unloaded: nfsd]
    [ 1610.168320] CPU: 0 PID: 27397 Comm: nfsd Tainted: G           OE
    3.15.0-rc1+ #15
    [ 1610.168320] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
    VirtualBox 12/01/2006
    [ 1610.168320] task: ffff88005ab653d0 ti: ffff88005a944000 task.ti:
    ffff88005a944000
    [ 1610.168320] RIP: 0010:[<ffffffffa034d5ed>]  [<ffffffffa034d5ed>]
    _posix_to_nfsv4_one+0x3cd/0x3d0 [nfsd]
    [ 1610.168320] RSP: 0018:ffff88005a945b00  EFLAGS: 00010293
    [ 1610.168320] RAX: 0000000000000001 RBX: ffff88006700bac0 RCX:
    0000000000000000
    [ 1610.168320] RDX: 0000000000000000 RSI: ffff880067c83f00 RDI:
    ffff880068233300
    [ 1610.168320] RBP: ffff88005a945b48 R08: ffffffff81c64830 R09:
    0000000000000000
    [ 1610.168320] R10: ffff88004ea85be0 R11: 000000000000f475 R12:
    ffff880068233300
    [ 1610.168320] R13: 0000000000000003 R14: 0000000000000002 R15:
    ffff880068233300
    [ 1610.168320] FS:  0000000000000000(0000) GS:ffff880077800000(0000)
    knlGS:0000000000000000
    [ 1610.168320] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [ 1610.168320] CR2: 00007f5bcbd3b0b9 CR3: 0000000001c0f000 CR4:
    00000000000006f0
    [ 1610.168320] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
    0000000000000000
    [ 1610.168320] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
    0000000000000400
    [ 1610.168320] Stack:
    [ 1610.168320]  ffffffff00000000 0000000b67c83500 000000076700bac0
    0000000000000000
    [ 1610.168320]  ffff88006700bac0 ffff880068233300 ffff88005a945c08
    0000000000000002
    [ 1610.168320]  0000000000000000 ffff88005a945b88 ffffffffa034e2d5
    000000065a945b68
    [ 1610.168320] Call Trace:
    [ 1610.168320]  [<ffffffffa034e2d5>] nfsd4_get_nfs4_acl+0x95/0x150 [nfsd]
    [ 1610.168320]  [<ffffffffa03400d6>] nfsd4_encode_fattr+0x646/0x1e70 [nfsd]
    [ 1610.168320]  [<ffffffff816a6e6e>] ? kmemleak_alloc+0x4e/0xb0
    [ 1610.168320]  [<ffffffffa0327962>] ?
    nfsd_setuser_and_check_port+0x52/0x80 [nfsd]
    [ 1610.168320]  [<ffffffff812cd4bb>] ? selinux_cred_prepare+0x1b/0x30
    [ 1610.168320]  [<ffffffffa0341caa>] nfsd4_encode_getattr+0x5a/0x60 [nfsd]
    [ 1610.168320]  [<ffffffffa0341e07>] nfsd4_encode_operation+0x67/0x110
    [nfsd]
    [ 1610.168320]  [<ffffffffa033844d>] nfsd4_proc_compound+0x21d/0x810 [nfsd]
    [ 1610.168320]  [<ffffffffa0324d9b>] nfsd_dispatch+0xbb/0x200 [nfsd]
    [ 1610.168320]  [<ffffffffa00850cd>] svc_process_common+0x46d/0x6d0 [sunrpc]
    [ 1610.168320]  [<ffffffffa0085433>] svc_process+0x103/0x170 [sunrpc]
    [ 1610.168320]  [<ffffffffa032472f>] nfsd+0xbf/0x130 [nfsd]
    [ 1610.168320]  [<ffffffffa0324670>] ? nfsd_destroy+0x80/0x80 [nfsd]
    [ 1610.168320]  [<ffffffff810a5202>] kthread+0xd2/0xf0
    [ 1610.168320]  [<ffffffff810a5130>] ? insert_kthread_work+0x40/0x40
    [ 1610.168320]  [<ffffffff816c1ebc>] ret_from_fork+0x7c/0xb0
    [ 1610.168320]  [<ffffffff810a5130>] ? insert_kthread_work+0x40/0x40
    [ 1610.168320] Code: 78 02 e9 e7 fc ff ff 31 c0 31 d2 31 c9 66 89 45 ce
    41 8b 04 24 66 89 55 d0 66 89 4d d2 48 8d 04 80 49 8d 5c 84 04 e9 37 fd
    ff ff <0f> 0b 90 0f 1f 44 00 00 55 8b 56 08 c7 07 00 00 00 00 8b 46 0c
    [ 1610.168320] RIP  [<ffffffffa034d5ed>] _posix_to_nfsv4_one+0x3cd/0x3d0
    [nfsd]
    [ 1610.168320]  RSP <ffff88005a945b00>
    [ 1610.257313] ---[ end trace 838254e3e352285b ]---
    
    Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit d2e5cb4e22080578f5d7e66824f85cf0e11d65e4
Merge: cabae81 83f7a85
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu May 8 11:28:35 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes

commit 6153871f77f8fa778cd0cf1e2979db75e25d3532
Merge: 23a456f cabae81
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu May 8 11:13:41 2014 -0400

    Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem

commit 2af89a3cde1beb88a2c65e0558d828c1a9e4677f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 8 16:56:21 2014 +0200

    ata: pata_at91 only works on sam9
    
    The smc driver used by pata_at91 is at91sam9 specific, so building
    this driver on another at91 platform results in this error:
    
    ERROR: "sam9_smc_configure" [drivers/ata/pata_at91.ko] undefined!
    ERROR: "sam9_smc_write_mode" [drivers/ata/pata_at91.ko] undefined!
    ERROR: "sam9_smc_read_mode" [drivers/ata/pata_at91.ko] undefined!
    
    This patch changes the Kconfig dependency to ensure it always works.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: linux-ide@vger.kernel.org
    Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
    Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 3901c1124ec5099254a9396085f7798153a7293f
Author: Harald Freudenberger <freude@linux.vnet.ibm.com>
Date:   Wed May 7 16:51:29 2014 +0200

    crypto: s390 - fix aes,des ctr mode concurrency finding.
    
    An additional testcase found an issue with the last
    series of patches applied: the fallback solution may
    not save the iv value after operation. This very small
    fix just makes sure the iv is copied back to the
    walk/desc struct.
    
    Cc: <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

commit 0b9d46dd7debf8e6dc8614106f1c1909fa8de64d
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Mon May 5 22:49:49 2014 +0200

    ACPI / processor: do not mark present at boot but not onlined CPU as onlined
    
    acpi_processor_add() assumes that present at boot CPUs
    are always onlined, it is not so if a CPU failed to become
    onlined. As result acpi_processor_add() will mark such CPU
    device as onlined in sysfs and following attempts to
    online/offline it using /sys/device/system/cpu/cpuX/online
    attribute will fail.
    
    Do not poke into device internals in acpi_processor_add()
    and touch "struct device { .offline }" attribute, since
    for CPUs onlined at boot it's set by:
      topology_init() -> arch_register_cpu() -> register_cpu()
    before ACPI device tree is parsed, and for hotplugged
    CPUs it's set when userspace onlines CPU via sysfs.
    
    Signed-off-by: Igor Mammedov <imammedo@redhat.com>
    Acked-by: Toshi Kani <toshi.kani@hp.com>
    Cc: 3.11+ <stable@vger.kernel.org> # 3.11+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 98012849e0cbf980326f8e34d571f4474866a88e
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Tue May 6 19:18:28 2014 -0700

    ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
    
    Revert commit cc8ef5270734 (ACPI / AC: convert ACPI ac driver to
    platform bus) that is reported to break thermal management on
    MacBook Air 2013 with ArchLinux.
    
    Fixes: cc8ef5270734 (ACPI / AC: convert ACPI ac driver to platform bus)
    References: https://bugzilla.kernel.org/show_bug.cgi?id=71711
    Cc: Zhang Rui <rui.zhang@intel.com>
    Reported-and-tested-by: Manuel Krause <manuelkrause@netscape.net>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Cc: 3.13+ <stable@vger.kernel.org> # 3.13+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f6e6e1b9fee88c90586787b71dc49bb3ce62bb89
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon May 5 11:38:09 2014 +0200

    ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
    
    Without this this EEE PC exports a non working WMI interface, with this it
    exports a working "good old" eeepc_laptop interface, fixing brightness control
    not working as well as rfkill being stuck in a permanent wireless blocked
    state.
    
    This is not an ideal way to fix this, but various attempts to fix this
    otherwise have failed, see:
    
    References: https://bugzilla.redhat.com/show_bug.cgi?id=1067181
    Reported-and-tested-by: lou.cardone@gmail.com
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b753631b3576bf343151a82513c5d56fcda1e24f
Author: Edward Lin <yidi.lin@canonical.com>
Date:   Wed May 7 10:47:24 2014 +0800

    ACPI: blacklist win8 OSI for Dell Inspiron 7737
    
    With win8 capabiltiy, the machine will boot itself immediately after
    shutdown command has executed.
    
    Work around this issue by disabling win8 capcability.  This workaround
    also makes wireless hotkey work.
    
    Signed-off-by: Edward Lin <yidi.lin@canonical.com>
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 23a456f05353035d1a2b3f1b9a92707acdc036e0
Author: Daniel Mack <zonque@gmail.com>
Date:   Tue May 6 18:52:16 2014 +0200

    net: mdio: of_mdiobus_register(): fall back to mdiobus_register() for !CONFIG_OF
    
    If CONFIG_OF is not set, make of_mdiobus_register() call
    mdiobus_register() instead of returning -ENOSYS.
    
    This way, we can just call of_mdiobus_register() from all DT-enabled
    drivers to handle the compat cases.
    
    Signed-off-by: Daniel Mack <zonque@gmail.com>
    Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
    Acked-by: Florian Fainelli <f.fainelli@gmail.com>
    Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit aeefa1ecfc799b0ea2c4979617f14cecd5cccbfd
Author: Sergey Popovich <popovich_sergei@mail.ru>
Date:   Tue May 6 18:23:08 2014 +0300

    ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation
    
    Increment fib_info_cnt in fib_create_info() right after successfuly
    alllocating fib_info structure, overwise fib_metrics allocation failure
    leads to fib_info_cnt incorrectly decremented in free_fib_info(), called
    on error path from fib_create_info().
    
    Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 7fc1c5f3ca2ade64c8a7c78a1df3130f74f383e4
Merge: 76a691d 84d7ad2
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 7 16:53:28 2014 -0400

    Merge branch 'qlcnic_net'
    
    Rajesh Borundia says:
    
    ====================
    qlcnic: Bug fixes.
    
    This patch series contain following bug fixes.
    
    * Fix panic where driver was accessing un-initialized crb_intr_mask
      in non Multi-Tx queue mode while dumping TX queue.
    * Do not set netdev->real_num_tx_queues directly from driver instead
      use kernel defined netif_set_real_num_tx_queues() API. Also notify
      stack about change in number of Rx queues.
    
    Please apply this series to net.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 84d7ad2c3b8a80888d9a483388ccbd5e5f07438f
Author: Shahed Shaikh <shahed.shaikh@qlogic.com>
Date:   Tue May 6 03:46:49 2014 -0400

    qlcnic: Set real_num_{tx|rx}_queues properly
    
    Do not set netdev->real_num_tx_queues directly,
    let netif_set_real_num_tx_queues() take care of it.
    Do not overwrite netdev->num_tx_queues everytime when driver
    changes its Tx ring size through ethtool -L and also notify
    stack to update number of Rx queues.
    
    Signed-off-by: Shahed Shaikh <shahed.shaikh@qlogic.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d5d2bf3eabb34cc8eaf54db37fdc43f04267985a
Author: Manish Chopra <manish.chopra@qlogic.com>
Date:   Tue May 6 03:46:48 2014 -0400

    qlcnic: Fix panic while dumping TX queues on TX timeout
    
    o In case of non-multi TX queue mode driver does not initialize "crb_intr_mask" pointer
      and driver was accessing that un-initialized pointer while dumping TX queue.
      So dump "crb_intr_mask" only when it is initilaized.
    
    Signed-off-by: Manish Chopra <manish.chopra@qlogic.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 83f7a85f1134c6e914453f5747435415a23d516b
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Apr 13 16:03:11 2014 +0300

    iwlwifi: pcie: disable interrupts upon PCIe alloc
    
    In case RFKILL is in KILL position, the NIC will issue an
    interrupt straight away. This interrupt won't be sent
    because it is masked in the hardware.
    But if our interrupt service routine is called for another
    reason (SHARED_IRQ), then we'll look at the interrupt cause
    and service it. This can cause bad things if we are not
    ready yet.
    Explicitly clean the interrupt cause register to make sure
    we won't service anything before we are ready to.
    
    Cc: <stable@vger.kernel.org> [3.14]
    Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 76a691d0ab71a244f7582a5b0387728befbdb52f
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Mon May 5 14:51:47 2014 -0400

    jme: Fix DMA unmap warning
    
    The jme driver forgot to check the return status from pci_map_page in its tx
    path, causing a dma api warning on unmap.  Easy fix, just do the check and
    augment the tx path to tell the stack that the driver is busy so we re-queue the
    frame.
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
    CC: Guo-Fu Tseng <cooldavid@cooldavid.org>
    CC: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d32aebfd64c8c8649b39cd6789b141525cc9d7c0
Merge: 418a315 c1e756b
Author: David S. Miller <davem@davemloft.net>
Date:   Wed May 7 15:49:16 2014 -0400

    Merge branch 'gso_forward'
    
    Florian Westphal says:
    
    ====================
    net: ip: push gso skb forwarding handling down the stack
    
    Turns out doing the segmentation in forwarding was not a bright idea,
    there are corner-cases where this has unintended side-effects.
    
    This patch pushes the segmentation downwards.
    
    After this, netif_skb_dev_features() function can be removed
    again, it was only added to fetch the features of the output device,
    we can just use skb->dev after the pushdown.
    
    Tested with following setup:
    
    host -> kvm_router  -> kvm_host
      mtu 1500        mtu1280
    
    - 'host' has route to kvm_host with locked mtu of 1500
    - gso/gro enabled on all interfaces
    
    Did tests with all of following combinations:
    - netfilter conntrack off and on on kvm_router
    - virtio-net and e1000 driver on kvm_router
    - tcp and udp bulk xmit from host to kvm_host
    
    for tcp, I added TCPMSS mangling on kvm_host to make it lie about tcp mss.
    
    Also added a dummy '-t mangle -A POSTROUTING -p udp -f'
    rule to make sure no udp fragments are seen in the 'conntrack on'
    and 'virtio-net' case.
    
    Also checked (with ping -M do -s 1400)' that it still sends the wanted
    icmp error message when size exceeds 1280.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c1e756bfcbcac838a86a23f3e4501b556a961e3c
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 5 15:00:44 2014 +0200

    Revert "net: core: introduce netif_skb_dev_features"
    
    This reverts commit d206940319c41df4299db75ed56142177bb2e5f6,
    there are no more callers.
    
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit c7ba65d7b64984ff371cb5630b36af23506c50d5
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 5 15:00:43 2014 +0200

    net: ip: push gso skb forwarding handling down the stack
    
    Doing the segmentation in the forward path has one major drawback:
    
    When using virtio, we may process gso udp packets coming
    from host network stack.  In that case, netfilter POSTROUTING
    will see one packet with udp header followed by multiple ip
    fragments.
    
    Delay the segmentation and do it after POSTROUTING invocation
    to avoid this.
    
    Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 418a31561d594a2b636c1e2fa94ecd9e1245abb1
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 5 00:03:34 2014 +0200

    net: ipv6: send pkttoobig immediately if orig frag size > mtu
    
    If conntrack defragments incoming ipv6 frags it stores largest original
    frag size in ip6cb and sets ->local_df.
    
    We must thus first test the largest original frag size vs. mtu, and not
    vice versa.
    
    Without this patch PKTTOOBIG is still generated in ip6_fragment() later
    in the stack, but
    
    1) IPSTATS_MIB_INTOOBIGERRORS won't increment
    2) packet did (needlessly) traverse netfilter postrouting hook.
    
    Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ca6c5d4ad216d5942ae544bbf02503041bd802aa
Author: Florian Westphal <fw@strlen.de>
Date:   Sun May 4 23:24:31 2014 +0200

    net: ipv4: ip_forward: fix inverted local_df test
    
    local_df means 'ignore DF bit if set', so if its set we're
    allowed to perform ip fragmentation.
    
    This wasn't noticed earlier because the output path also drops such skbs
    (and emits needed icmp error) and because netfilter ip defrag did not
    set local_df until couple of days ago.
    
    Only difference is that DF-packets-larger-than MTU now discarded
    earlier (f.e. we avoid pointless netfilter postrouting trip).
    
    While at it, drop the repeated test ip_exceeds_mtu, checking it once
    is enough...
    
    Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 4f4178f3bb1f470d7fb863ec531e08e20a0fd51c
Author: Bjørn Mork <bjorn@mork.no>
Date:   Sat May 3 16:12:47 2014 +0200

    net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock
    
    Fixes this warning introduced by commit 5b8f15f78e6f
    ("net: cdc_mbim: handle IPv6 Neigbor Solicitations"):
    
    ===============================
    [ INFO: suspicious RCU usage. ]
    3.15.0-rc3 #213 Tainted: G        W  O
    -------------------------------
    net/8021q/vlan_core.c:69 suspicious rcu_dereference_check() usage!
    
    other info that might help us debug this:
    
    rcu_scheduler_active = 1, debug_locks = 1
    no locks held by ksoftirqd/0/3.
    
    stack backtrace:
    CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G        W  O  3.15.0-rc3 #213
    Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
     0000000000000001 ffff880232533bf0 ffffffff813a5ee6 0000000000000006
     ffff880232530090 ffff880232533c20 ffffffff81076b94 0000000000000081
     0000000000000000 ffff8802085ac000 ffff88007fc8ea00 ffff880232533c50
    Call Trace:
     [<ffffffff813a5ee6>] dump_stack+0x4e/0x68
     [<ffffffff81076b94>] lockdep_rcu_suspicious+0xfa/0x103
     [<ffffffff813978a6>] __vlan_find_dev_deep+0x54/0x94
     [<ffffffffa04a1938>] cdc_mbim_rx_fixup+0x379/0x66a [cdc_mbim]
     [<ffffffff813ab76f>] ? _raw_spin_unlock_irqrestore+0x3a/0x49
     [<ffffffff81079671>] ? trace_hardirqs_on_caller+0x192/0x1a1
     [<ffffffffa059bd10>] usbnet_bh+0x59/0x287 [usbnet]
     [<ffffffff8104067d>] tasklet_action+0xbb/0xcd
     [<ffffffff81040057>] __do_softirq+0x14c/0x30d
     [<ffffffff81040237>] run_ksoftirqd+0x1f/0x50
     [<ffffffff8105f13e>] smpboot_thread_fn+0x172/0x18e
     [<ffffffff8105efcc>] ? SyS_setgroups+0xdf/0xdf
     [<ffffffff810594b0>] kthread+0xb5/0xbd
     [<ffffffff813a84b1>] ? __wait_for_common+0x13b/0x170
     [<ffffffff810593fb>] ? __kthread_parkme+0x5c/0x5c
     [<ffffffff813b147c>] ret_from_fork+0x7c/0xb0
     [<ffffffff810593fb>] ? __kthread_parkme+0x5c/0x5c
    
    Fixes: 5b8f15f78e6f ("net: cdc_mbim: handle IPv6 Neigbor Solicitations")
    Signed-off-by: Bjørn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 34e0a1e1563809a07371f44c6e4c3e216dc8684d
Author: Paul Handrigan <Paul.Handrigan@cirrus.com>
Date:   Wed May 7 09:49:36 2014 -0500

    ASoC: Update Cirrus Logic CODEC maintainers.
    
    Remove Timur Tabi as maintainer for CS4270 codec. I would like to thank Timur
    for his work on maintaining this driver.
    
    Signed-off-by: Paul Handrigan <paul.handrigan@cirrus.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit a6f9bf4d2f965b862b95213303d154e02957eed8
Author: Levente Kurusa <levex@linux.com>
Date:   Tue May 6 15:57:48 2014 +0200

    libata: clean up ZPODD when a port is detached
    
    When a ZPODD device is unbound via sysfs, the ACPI notify handler
    is not removed. This causes panics as observed in Bug #74601. The
    panic only happens when the wake happens from outside the kernel
    (i.e. inserting a media or pressing a button). Add a loop to
    ata_port_detach which loops through the port's devices and checks
    if zpodd is enabled, if so call zpodd_exit.
    
    Cc: stable@vger.kernel.org
    Reviewed-by: Aaron Lu <aaron.lu@intel.com>
    Signed-off-by: Levente Kurusa <levex@linux.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit e4c610fe051579ba0a1fadf339905b0231c6ef94
Author: Egbert Eich <eich@suse.de>
Date:   Fri Apr 11 19:07:44 2014 +0200

    drm/i915/SDVO: For sysfs link put directory and target in correct order
    
    When linking the i2c sysfs file into the connector's directory
    pass directory and link target in the right order.
    This code was introduced with:
    
      commit 931c1c26983b4f84e33b78579fc8d57e4a14c6b4
      Author: Imre Deak <imre.deak@intel.com>
      Date:   Tue Feb 11 17:12:51 2014 +0200
    
        drm/i915: sdvo: add i2c sysfs symlink to the connector's directory
    
        This is the same what we do for DP connectors, so make things more
        consistent.
    
    Signed-off-by: Egbert Eich <eich@suse.de>
    Reviewed-by: Imre Deak <imre.deak@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit 56071a207602a451f0c46d3dcc8379b59ef576e2
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Tue May 6 14:56:52 2014 +0300

    drm/i915: use lane count and link rate from VBT as minimums for eDP
    
    Most likely the minimums for both should be enough for enabling the
    native resolution on the eDP, and we'll end up using the predetermined
    optimal link config for the panel.
    
    v2: Add debug prints.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73539
    Tested-by: Markus Blank-Burian <burian@muenster.de>
    Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit e13e2b2c468bc54e872ad68126411d6a3f77001a
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Tue May 6 14:56:51 2014 +0300

    drm/i915: clean up VBT eDP link param decoding
    
    Use defines, do not set anything if VBT has values unknown to us.
    
    Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit eeb6324dd6668b05192708916f2a4bc463f382ca
Author: Paulo Zanoni <paulo.r.zanoni@intel.com>
Date:   Tue May 6 14:56:50 2014 +0300

    drm/i915: consider the source max DP lane count too
    
    Even if the panel claims it can support 4 lanes, there's the
    possibility that the HW can't, so consider this while selecting the
    max lane count.
    
    Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
    Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

commit 696dfd95ba9838327a7013e5988ff3ba60dcc8c8
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed May 7 11:20:54 2014 +0200

    KVM: vmx: disable APIC virtualization in nested guests
    
    While running a nested guest, we should disable APIC virtualization
    controls (virtualized APIC register accesses, virtual interrupt
    delivery and posted interrupts), because we do not expose them to
    the nested guest.
    
    Reported-by: Hu Yaohui <loki2441@gmail.com>
    Suggested-by: Abel Gordon <abel@stratoscale.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

commit 97977f7576a89cb9436c000ae703c0d515e748ac
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Wed May 7 10:56:24 2014 +0300

    dmaengine: dw: went back to plain {request,free}_irq() calls
    
    The commit dbde5c29 "dw_dmac: use devm_* functions to simplify code" turns
    probe function to use devm_* helpers and simultaneously brings a regression. We
    need to ensure irq is disabled, followed by ensuring that don't schedule any
    more tasklets and then its safe to use tasklet_kill().
    
    The free_irq() will ensure that the irq is disabled and also wait till all
    scheduled interrupts are executed by invoking synchronize_irq(). So we need to
    only do tasklet_kill() after invoking free_irq().
    
    Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Cc: stable@vger.kernel.org # v3.11+
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 2b4cfe64dee0d84506b951d81bf55d9891744d25
Author: Jason Low <jason.low2@hp.com>
Date:   Wed Apr 23 18:30:34 2014 -0700

    sched/numa: Initialize newidle balance stats in sd_numa_init()
    
    Also initialize the per-sd variables for newidle load balancing
    in sd_numa_init().
    
    Signed-off-by: Jason Low <jason.low2@hp.com>
    Acked-by: morten.rasmussen@arm.com
    Cc: daniel.lezcano@linaro.org
    Cc: alex.shi@linaro.org
    Cc: preeti@linux.vnet.ibm.com
    Cc: efault@gmx.de
    Cc: vincent.guittot@linaro.org
    Cc: aswin@hp.com
    Cc: chegu_vinod@hp.com
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1398303035-18255-3-git-send-email-jason.low2@hp.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 0e5b5337f0da073e1f17aec3c322ea7826975d0d
Author: Jason Low <jason.low2@hp.com>
Date:   Mon Apr 28 15:45:54 2014 -0700

    sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in idle_balance()
    
    The following commit:
    
      e5fc66119ec9 ("sched: Fix race in idle_balance()")
    
    can potentially cause rq->max_idle_balance_cost to not be updated,
    even when load_balance(NEWLY_IDLE) is attempted and the per-sd
    max cost value is updated.
    
    Preeti noticed a similar issue with updating rq->next_balance.
    
    In this patch, we fix this by making sure we still check/update those values
    even if a task gets enqueued while browsing the domains.
    
    Signed-off-by: Jason Low <jason.low2@hp.com>
    Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: morten.rasmussen@arm.com
    Cc: aswin@hp.com
    Cc: daniel.lezcano@linaro.org
    Cc: alex.shi@linaro.org
    Cc: efault@gmx.de
    Cc: vincent.guittot@linaro.org
    Link: http://lkml.kernel.org/r/1398725155-7591-2-git-send-email-jason.low2@hp.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 6ccdc84b81a0a6c09a7f0427761d2f8cecfc2218
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Apr 24 12:00:47 2014 +0200

    sched: Skip double execution of pick_next_task_fair()
    
    Tim wrote:
    
     "The current code will call pick_next_task_fair a second time in the
      slow path if we did not pull any task in our first try.  This is
      really unnecessary as we already know no task can be pulled and it
      doubles the delay for the cpu to enter idle.
    
      We instrumented some network workloads and that saw that
      pick_next_task_fair is frequently called twice before a cpu enters
      idle.  The call to pick_next_task_fair can add non trivial latency as
      it calls load_balance which runs find_busiest_group on an hierarchy of
      sched domains spanning the cpus for a large system.  For some 4 socket
      systems, we saw almost 0.25 msec spent per call of pick_next_task_fair
      before a cpu can be idled."
    
    Optimize the second call away for the common case and document the
    dependency.
    
    Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Len Brown <len.brown@intel.com>
    Link: http://lkml.kernel.org/r/20140424100047.GP11096@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 6227cb00cc120f9a43ce8313bb0475ddabcb7d01
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Sun Apr 13 09:34:53 2014 -0400

    sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
    
    The check at the beginning of cpupri_find() makes sure that the task_pri
    variable does not exceed the cp->pri_to_cpu array length. But that length
    is CPUPRI_NR_PRIORITIES not MAX_RT_PRIO, where it will miss the last two
    priorities in that array.
    
    As task_pri is computed from convert_prio() which should never be bigger
    than CPUPRI_NR_PRIORITIES, if the check should cause a panic if it is
    hit.
    
    Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: stable@vger.kernel.org
    Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 6a7cd273dc4bc3246f37ebe874754a54ccb29141
Author: Li Zefan <lizefan@huawei.com>
Date:   Thu Apr 17 10:05:02 2014 +0800

    sched/deadline: Fix memory leak
    
    Free cpudl->free_cpus allocated in cpudl_init().
    
    Signed-off-by: Li Zefan <lizefan@huawei.com>
    Acked-by: Juri Lelli <juri.lelli@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@vger.kernel.org> # 3.14+
    Link: http://lkml.kernel.org/r/534F36CE.2000409@huawei.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 5bfd126e80dca70431aef8fdbc1cf14535f3c338
Author: Juri Lelli <juri.lelli@gmail.com>
Date:   Tue Apr 15 13:49:04 2014 +0200

    sched/deadline: Fix sched_yield() behavior
    
    yield_task_dl() is broken:
    
     o it forces current to be throttled setting its runtime to zero;
     o it sets current's dl_se->dl_new to one, expecting that dl_task_timer()
       will queue it back with proper parameters at replenish time.
    
    Unfortunately, dl_task_timer() has this check at the very beginning:
    
    	if (!dl_task(p) || dl_se->dl_new)
    		goto unlock;
    
    So, it just bails out and the task is never replenished. It actually
    yielded forever.
    
    To fix this, introduce a new flag indicating that the task properly yielded
    the CPU before its current runtime expired. While this is a little overdoing
    at the moment, the flag would be useful in the future to discriminate between
    "good" jobs (of which remaining runtime could be reclaimed, i.e. recycled)
    and "bad" jobs (for which dl_throttled task has been set) that needed to be
    stopped.
    
    Reported-by: yjay.kim <yjay.kim@lge.com>
    Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/20140429103953.e68eba1b2ac3309214e3dc5a@gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 2d513868e2a33e1d5315490ef4c861ee65babd65
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri May 2 23:26:24 2014 +0200

    sched: Sanitize irq accounting madness
    
    Russell reported, that irqtime_account_idle_ticks() takes ages due to:
    
           for (i = 0; i < ticks; i++)
                   irqtime_account_process_tick(current, 0, rq);
    
    It's sad, that this code was written way _AFTER_ the NOHZ idle
    functionality was available. I charge myself guitly for not paying
    attention when that crap got merged with commit abb74cefa ("sched:
    Export ns irqtimes through /proc/stat")
    
    So instead of looping nr_ticks times just apply the whole thing at
    once.
    
    As a side note: The whole cputime_t vs. u64 business in that context
    wants to be cleaned up as well. There is no point in having all these
    back and forth conversions. Lets standardise on u64 nsec for all
    kernel internal accounting and be done with it. Everything else does
    not make sense at all for fine grained accounting. Frederic, can you
    please take care of that?
    
    Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Venkatesh Pallipadi <venki@google.com>
    Cc: Shaun Ruffell <sruffell@digium.com>
    Cc: stable@vger.kernel.org
    Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24
Author: Yan, Zheng <zheng.z.yan@intel.com>
Date:   Tue Apr 29 15:04:41 2014 +0800

    perf/x86/intel: Fix Silvermont's event constraints
    
    Event 0x013c is not the same as fixed counter2, remove it from
    Silvermont's event constraints.
    
    Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Stephane Eranian <eranian@google.com>
    Link: http://lkml.kernel.org/r/1398755081-12471-1-git-send-email-zheng.z.yan@intel.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit ffb4ef21ac4308c2e738e6f83b6741bbc9b4fa3b
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon May 5 19:12:20 2014 +0200

    perf: Fix perf_event_init_context()
    
    perf_pin_task_context() can return NULL but perf_event_init_context()
    assumes it will not, correct this.
    
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Link: http://lkml.kernel.org/r/20140505171428.GU26782@laptop.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 46ce0fe97a6be7532ce6126bb26ce89fed81528c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri May 2 16:56:01 2014 +0200

    perf: Fix race in removing an event
    
    When removing a (sibling) event we do:
    
    	raw_spin_lock_irq(&ctx->lock);
    	perf_group_detach(event);
    	raw_spin_unlock_irq(&ctx->lock);
    
    	<hole>
    
    	perf_remove_from_context(event);
    		raw_spin_lock_irq(&ctx->lock);
    		...
    		raw_spin_unlock_irq(&ctx->lock);
    
    Now, assuming the event is a sibling, it will be 'unreachable' for
    things like ctx_sched_out() because that iterates the
    groups->siblings, and we just unhooked the sibling.
    
    So, if during <hole> we get ctx_sched_out(), it will miss the event
    and not call event_sched_out() on it, leaving it programmed on the
    PMU.
    
    The subsequent perf_remove_from_context() call will find the ctx is
    inactive and only call list_del_event() to remove the event from all
    other lists.
    
    Hereafter we can proceed to free the event; while still programmed!
    
    Close this hole by moving perf_group_detach() inside the same
    ctx->lock region(s) perf_remove_from_context() has.
    
    The condition on inherited events only in __perf_event_exit_task() is
    likely complete crap because non-inherited events are part of groups
    too and we're tearing down just the same. But leave that for another
    patch.
    
    Most-likely-Fixes: e03a9a55b4e ("perf: Change close() semantics for group events")
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Tested-by: Vince Weaver <vincent.weaver@maine.edu>
    Much-staring-at-traces-by: Vince Weaver <vincent.weaver@maine.edu>
    Much-staring-at-traces-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/20140505093124.GN17778@laptop.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 2b39aab18a84b2fa348d42d894ef986b290d67a0
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:28 2014 +0100

    ASoC: Intel: Fix block offset calculations.
    
    Block offset calculations are done in the contiguous allocator so
    are not required here.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit e5c460f46ae7ee94831cb55cb980f942aa9e5a85
Author: David S. Miller <davem@davemloft.net>
Date:   Tue May 6 21:27:37 2014 -0700

    sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.
    
    This was found using Dave Jone's trinity tool.
    
    When a user process which is 32-bit performs a load or a store, the
    cpu chops off the top 32-bits of the effective address before
    translating it.
    
    This is because we run 32-bit tasks with the PSTATE_AM (address
    masking) bit set.
    
    We can't run the kernel with that bit set, so when the kernel accesses
    userspace no address masking occurs.
    
    Since a 32-bit process will have no mappings in that region we will
    properly fault, so we don't try to handle this using access_ok(),
    which can safely just be a NOP on sparc64.
    
    Real faults from 32-bit processes should never generate such addresses
    so a bug check was added long ago, and it barks in the logs if this
    happens.
    
    But it also barks when a kernel user access causes this condition, and
    that _can_ happen.  For example, if a pointer passed into a system call
    is "0xfffffffc" and the kernel access 4 bytes offset from that pointer.
    
    Just handle such faults normally via the exception entries.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Apr 23 14:49:17 2014 +0200

    genirq: Provide irq_force_affinity fallback for non-SMP
    
    Patch 01f8fa4f01d "genirq: Allow forcing cpu affinity of interrupts" added
    an irq_force_affinity() function, and 30ccf03b4a6 "clocksource: Exynos_mct:
    Use irq_force_affinity() in cpu bringup" subsequently uses it. However, the
    driver can be used with CONFIG_SMP disabled, but the function declaration
    is only available for CONFIG_SMP, leading to this build error:
    
    drivers/clocksource/exynos_mct.c:431:3: error: implicit declaration of function 'irq_force_affinity' [-Werror=implicit-function-declaration]
       irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
    
    This patch introduces a dummy helper function for the non-SMP case
    that always returns success, to get rid of the build error.
    Since the patches causing the problem are marked for stable backports,
    this one should be as well.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Cc: stable@vger.kernel.org
    Link: http://lkml.kernel.org/r/5619084.0zmrrIUZLV@wuerfel
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

commit bd5e4744a6ca64299b57a2682c720d00a475a734
Author: David Spinadel <david.spinadel@intel.com>
Date:   Thu Apr 24 13:15:29 2014 +0300

    iwlwifi: mvm: do no sched scan while associated
    
    Currently the FW doesn't support sched scan while associated,
    Prevent it.
    
    Signed-off-by: David Spinadel <david.spinadel@intel.com>
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>
    Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit cabae81103584a8265114a543555781b7b0c88bd
Merge: 3234f5b e669ba2
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue May 6 14:05:51 2014 -0400

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211

commit 8e96440e8d42da0dab02cae125ea59e2b64c77fe
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue May 6 20:35:10 2014 +0300

    iwlwifi: mvm: rs - s/CPTCFG/CONFIG
    
    My bad - I forgot to update this when sending the patch
    upstream.
    
    Fixes: 87d5e4155c00 ("iwlwifi: mvm: rs: reinit rs if no tx for a long time")
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 0fed2bcf17d2a049c079ffd2b7bc4caca4b7f906
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Apr 13 22:55:27 2014 +0300

    iwlwifi: mvm: BT Coex - fix validity flags during init
    
    The commit below introduced a bug in the validity bits in
    init. Due to that, all the Coex mechanism stopped sending
    kills to the BT side. Fix that.
    
    Fixes: b9fae2d54c9f ("iwlwifi: mvm: BT Coex add support for Co-running block")
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 4cb57e3032d4e4bf5e97780e9907da7282b02b0c
Author: Trond Myklebust <trond.myklebust@primarydata.com>
Date:   Fri Apr 18 14:43:57 2014 -0400

    NFSd: call rpc_destroy_wait_queue() from free_client()
    
    Mainly to ensure that we don't leave any hanging timers.
    
    Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit 5694c93e6c4954fa9424c215f75eeb919bddad64
Author: Trond Myklebust <trond.myklebust@primarydata.com>
Date:   Fri Apr 18 14:43:56 2014 -0400

    NFSd: Move default initialisers from create_client() to alloc_client()
    
    Aside from making it clearer what is non-trivial in create_client(), it
    also fixes a bug whereby we can call free_client() before idr_init()
    has been called.
    
    Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

commit 3519acb3b0c294ef57cc015302b061b4fe85a208
Merge: 8628196 a3fe964
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue May 6 06:25:10 2014 -0700

    Merge branch 'imx-drm-fixes-urgent' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-linus
    
    imx drm fixes from Russell

commit edb666f07e539d92f63284213d72083ed8ac05ea
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Tue Apr 29 08:23:03 2014 +0200

    xfrm6: Properly handle unsupported protocols
    
    We don't catch the case if an unsupported protocol is submitted
    to the xfrm6 protocol handlers, this can lead to NULL pointer
    dereferences. Fix this by adding the appropriate checks.
    
    Fixes: 7e14ea15 ("xfrm6: Add IPsec protocol multiplexer")
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

commit 43d9490244254d2d6adb0f3c6275c7b8d032a2dd
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Mon May 5 11:38:08 2014 +0200

    ACPI / video: Add use_native_backlight quirks for more systems
    
    ThinkPad T430: extend the T430s entry to also cover the T430 (note we also
    have another entry for T430's with a different DMI_PRODUCT_VERSION).
    
    ThinkPad T430
    Reported-and-tested-by: edm <fuffi.il.fuffo@gmail.com>
    References: https://bugzilla.kernel.org/show_bug.cgi?id=51231
    
    Thinkpad T530
    Reported-and-tested-by: Balint Szigeti <balint.szgt@gmail.com>
    References: https://bugzilla.redhat.com/show_bug.cgi?id=1089545
    
    Acer Aspire 5742G
    Reported-and-tested-by: AnAkkk <anakin.cs@gmail.com>
    References: https://bugzilla.kernel.org/show_bug.cgi?id=35622
    
    Cc: All applicable <stable@vger.kernel.org>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 3a670cc79342c36d308decd5f90351830ed1685c
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Sun May 4 11:07:25 2014 +0800

    ACPI: Revert "ACPI / Battery: Remove battery's proc directory"
    
    The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
    directory and breaks some old userspace tools. This patch
    is to revert commit 1e2d9cd.
    
    Fixes: 1e2d9cdfb449 (ACPI / Battery: Remove battery's proc directory)
    Cc: 3.13+ <stable@vger.kernel.org> # 3.13+
    Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e2a7c3d7812369daae56f069eab2e8f3e548d231
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Sun May 4 11:07:24 2014 +0800

    ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
    
    The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
    directory and breaks some old userspace tools. This patch
    is to revert 7d7ee95.
    
    Fixes: 7d7ee958867a (ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c)
    Cc: 3.13+ <stable@vger.kernel.org> # 3.13+
    Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21
Author: NeilBrown <neilb@suse.de>
Date:   Tue May 6 09:36:08 2014 +1000

    md: avoid possible spinning md thread at shutdown.
    
    If an md array with externally managed metadata (e.g. DDF or IMSM)
    is in use, then we should not set safemode==2 at shutdown because:
    
    1/ this is ineffective: user-space need to be involved in any 'safemode' handling,
    2/ The safemode management code doesn't cope with safemode==2 on external metadata
       and md_check_recover enters an infinite loop.
    
    Even at shutdown, an infinite-looping process can be problematic, so this
    could cause shutdown to hang.
    
    Cc: stable@vger.kernel.org (any kernel)
    Signed-off-by: NeilBrown <neilb@suse.de>

commit cc13b1d1500656a20e41960668f3392dda9fa6e2
Author: NeilBrown <neilb@suse.de>
Date:   Mon May 5 13:34:37 2014 +1000

    md/raid10: call wait_barrier() for each request submitted.
    
    wait_barrier() includes a counter, so we must call it precisely once
    (unless balanced by allow_barrier()) for each request submitted.
    
    Since
    commit 20d0189b1012a37d2533a87fb451f7852f2418d1
        block: Introduce new bio_split()
    in 3.14-rc1, we don't call it for the extra requests generated when
    we need to split a bio.
    
    When this happens the counter goes negative, any resync/recovery will
    never start, and  "mdadm --stop" will hang.
    
    Reported-by: Chris Murphy <lists@colorremedies.com>
    Fixes: 20d0189b1012a37d2533a87fb451f7852f2418d1
    Cc: stable@vger.kernel.org (3.14+)
    Cc: Kent Overstreet <kmo@daterainc.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

commit d48dc067450d84324067f4472dc0b169e9af4454
Author: Lv Zheng <lv.zheng@intel.com>
Date:   Wed Apr 30 10:05:40 2014 +0800

    ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
    
    Linux XSDT validation mechanism backport has introduced a regreession:
      Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
      Subject: ACPICA: Back port and refine validation of the XSDT root table.
    There is a pointer still accessed after unmapping.
    
    This patch fixes this issue.  Lv Zheng.
    
    Fixes: 671cc68dc61f (ACPICA: Back port and refine validation of the XSDT root table.)
    References: https://bugzilla.kernel.org/show_bug.cgi?id=73911
    References: https://bugs.archlinux.org/task/39811
    Signed-off-by: Lv Zheng <lv.zheng@intel.com>
    Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
    Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e9024f0ba38a994c805743bc523693c5c7d7ccbc
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Mon May 5 13:20:23 2014 +0100

    ASoC: Intel: Fix check for pdata usage before dereference.
    
    This patch fixes the following dereference check ordering.
    
     sound/soc/intel/sst-haswell-pcm.c:749 hsw_pcm_probe() warn: variable dereferenced before check 'pdata' (see line 746)
    
     git remote add asoc git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
     git remote update asoc
     git checkout 0b708c87f66a15190fb43661c2320fd48c4dc6c8
     vim +/pdata +749 sound/soc/intel/sst-haswell-pcm.c
    
     a4b12990 Mark Brown    2014-03-12  740  };
     a4b12990 Mark Brown    2014-03-12  741
     a4b12990 Mark Brown    2014-03-12  742  static int hsw_pcm_probe(struct snd_soc_platform *platform)
     a4b12990 Mark Brown    2014-03-12  743  {
     a4b12990 Mark Brown    2014-03-12  744  	struct sst_pdata *pdata = dev_get_platdata(platform->dev);
     a4b12990 Mark Brown    2014-03-12  745  	struct hsw_priv_data *priv_data;
     0b708c87 Liam Girdwood 2014-05-02 @746  	struct device *dma_dev = pdata->dma_dev;
     0b708c87 Liam Girdwood 2014-05-02  747  	int i, ret = 0;
     a4b12990 Mark Brown    2014-03-12  748
     a4b12990 Mark Brown    2014-03-12 @749  	if (!pdata)
     a4b12990 Mark Brown    2014-03-12  750  		return -ENODEV;
     a4b12990 Mark Brown    2014-03-12  751
     a4b12990 Mark Brown    2014-03-12  752  	priv_data = devm_kzalloc(platform->dev, sizeof(*priv_data), GFP_KERNEL);
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 36c38fb7144aa941dc072ba8f58b2dbe509c0345
Author: Tejun Heo <tj@kernel.org>
Date:   Mon May 5 12:37:30 2014 -0400

    blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats()
    
    During the recent conversion of cgroup to kernfs, cgroup_tree_mutex
    which nests above both the kernfs s_active protection and cgroup_mutex
    is added to synchronize cgroup file type operations as cgroup_mutex
    needed to be grabbed from some file operations and thus can't be put
    above s_active protection.
    
    While this arrangement mostly worked for cgroup, this triggered the
    following lockdep warning.
    
      ======================================================
      [ INFO: possible circular locking dependency detected ]
      3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429 Tainted: G        W
      -------------------------------------------------------
      trinity-c173/9024 is trying to acquire lock:
      (blkcg_pol_mutex){+.+.+.}, at: blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
    
      but task is already holding lock:
      (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)
    
      which lock already depends on the new lock.
    
      the existing dependency chain (in reverse order) is:
    
      -> #2 (s_active#89){++++.+}:
      lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
      __kernfs_remove (arch/x86/include/asm/atomic.h:27 fs/kernfs/dir.c:352 fs/kernfs/dir.c:1024)
      kernfs_remove_by_name_ns (fs/kernfs/dir.c:1219)
      cgroup_addrm_files (include/linux/kernfs.h:427 kernel/cgroup.c:1074 kernel/cgroup.c:2899)
      cgroup_clear_dir (kernel/cgroup.c:1092 (discriminator 2))
      rebind_subsystems (kernel/cgroup.c:1144)
      cgroup_setup_root (kernel/cgroup.c:1568)
      cgroup_mount (kernel/cgroup.c:1716)
      mount_fs (fs/super.c:1094)
      vfs_kern_mount (fs/namespace.c:899)
      do_mount (fs/namespace.c:2238 fs/namespace.c:2561)
      SyS_mount (fs/namespace.c:2758 fs/namespace.c:2729)
      tracesys (arch/x86/kernel/entry_64.S:746)
    
      -> #1 (cgroup_tree_mutex){+.+.+.}:
      lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
      mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
      cgroup_add_cftypes (include/linux/list.h:76 kernel/cgroup.c:3040)
      blkcg_policy_register (block/blk-cgroup.c:1106)
      throtl_init (block/blk-throttle.c:1694)
      do_one_initcall (init/main.c:789)
      kernel_init_freeable (init/main.c:854 init/main.c:863 init/main.c:882 init/main.c:1003)
      kernel_init (init/main.c:935)
      ret_from_fork (arch/x86/kernel/entry_64.S:552)
    
      -> #0 (blkcg_pol_mutex){+.+.+.}:
      __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
      lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
      mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
      blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
      cgroup_file_write (kernel/cgroup.c:2714)
      kernfs_fop_write (fs/kernfs/file.c:295)
      vfs_write (fs/read_write.c:532)
      SyS_write (fs/read_write.c:584 fs/read_write.c:576)
      tracesys (arch/x86/kernel/entry_64.S:746)
    
      other info that might help us debug this:
    
      Chain exists of:
      blkcg_pol_mutex --> cgroup_tree_mutex --> s_active#89
    
       Possible unsafe locking scenario:
    
    	 CPU0                    CPU1
    	 ----                    ----
        lock(s_active#89);
    				 lock(cgroup_tree_mutex);
    				 lock(s_active#89);
        lock(blkcg_pol_mutex);
    
       *** DEADLOCK ***
    
      4 locks held by trinity-c173/9024:
      #0: (&f->f_pos_lock){+.+.+.}, at: __fdget_pos (fs/file.c:714)
      #1: (sb_writers#18){.+.+.+}, at: vfs_write (include/linux/fs.h:2255 fs/read_write.c:530)
      #2: (&of->mutex){+.+.+.}, at: kernfs_fop_write (fs/kernfs/file.c:283)
      #3: (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)
    
      stack backtrace:
      CPU: 3 PID: 9024 Comm: trinity-c173 Tainted: G        W     3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429
       ffffffff919687b0 ffff8805f6373bb8 ffffffff8e52cdbb 0000000000000002
       ffffffff919d8400 ffff8805f6373c08 ffffffff8e51fb88 0000000000000004
       ffff8805f6373c98 ffff8805f6373c08 ffff88061be70d98 ffff88061be70dd0
      Call Trace:
      dump_stack (lib/dump_stack.c:52)
      print_circular_bug (kernel/locking/lockdep.c:1216)
      __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
      lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
      mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
      blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
      cgroup_file_write (kernel/cgroup.c:2714)
      kernfs_fop_write (fs/kernfs/file.c:295)
      vfs_write (fs/read_write.c:532)
      SyS_write (fs/read_write.c:584 fs/read_write.c:576)
    
    This is a highly unlikely but valid circular dependency between "echo
    1 > blkcg.reset_stats" and cfq module [un]loading.  cgroup is going
    through further locking update which will remove this complication but
    for now let's use trylock on blkcg_pol_mutex and retry the file
    operation if the trylock fails.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Sasha Levin <sasha.levin@oracle.com>
    References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com

commit d2c2b11cfa134f4fbdcc34088824da26a084d8de
Author: Aristeu Rozanski <aris@redhat.com>
Date:   Mon May 5 11:18:59 2014 -0400

    device_cgroup: check if exception removal is allowed
    
    [PATCH v3 1/2] device_cgroup: check if exception removal is allowed
    
    When the device cgroup hierarchy was introduced in
    	bd2953ebbb53 - devcg: propagate local changes down the hierarchy
    
    a specific case was overlooked. Consider the hierarchy bellow:
    
    	A	default policy: ALLOW, exceptions will deny access
    	 \
    	  B	default policy: ALLOW, exceptions will deny access
    
    There's no need to verify when an new exception is added to B because
    in this case exceptions will deny access to further devices, which is
    always fine. Hierarchy in device cgroup only makes sure B won't have
    more access than A.
    
    But when an exception is removed (by writing devices.allow), it isn't
    checked if the user is in fact removing an inherited exception from A,
    thus giving more access to B.
    
    Example:
    
    	# echo 'a' >A/devices.allow
    	# echo 'c 1:3 rw' >A/devices.deny
    	# echo $$ >A/B/tasks
    	# echo >/dev/null
    	-bash: /dev/null: Operation not permitted
    	# echo 'c 1:3 w' >A/B/devices.allow
    	# echo >/dev/null
    	#
    
    This shouldn't be allowed and this patch fixes it by making sure to never allow
    exceptions in this case to be removed if the exception is partially or fully
    present on the parent.
    
    v3: missing '*' in function description
    v2: improved log message and formatting fixes
    
    Cc: cgroups@vger.kernel.org
    Cc: Li Zefan <lizefan@huawei.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
    Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit aff09ce303f83bd370772349238482ae422a2341
Author: Vasily Averin <vvs@parallels.com>
Date:   Mon May 5 00:17:48 2014 +0400

    bridge: superfluous skb->nfct check in br_nf_dev_queue_xmit
    
    Currently bridge can silently drop ipv4 fragments.
    If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
    br_nf_pre_routing defragments incoming ipv4 fragments
    but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined
    packet back, and therefore it is dropped in br_dev_queue_push_xmit without
    incrementing of any failcounters
    
    It seems the only way to hit the ip_fragment code in the bridge xmit
    path is to have a fragment list whose reassembled fragments go over
    the mtu. This only happens if nf_defrag is enabled. Thanks to
    Florian Westphal for providing feedback to clarify this.
    
    Defragmentation ipv4 is required not only in conntracks but at least in
    TPROXY target and socket match, therefore #ifdef is changed from
    NF_CONNTRACK_IPV4 to NF_DEFRAG_IPV4
    
    Signed-off-by: Vasily Averin <vvs@openvz.org>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7c3d5ab1f35f5475b1a1fbe74143683cfc092d33
Author: Vasily Averin <vvs@parallels.com>
Date:   Sat May 3 03:14:04 2014 +0400

    ipv4: fix "conntrack zones" support for defrag user check in ip_expire
    
    Defrag user check in ip_expire was not updated after adding support for
    "conntrack zones".
    
    This bug manifests as a RFC violation, since the router will send
    the icmp time exceeeded message when using conntrack zones.
    
    Signed-off-by: Vasily Averin <vvs@openvz.org>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit e669ba2d06c6195662601956454ac959892f0762
Author: Eliad Peller <eliad@wizery.com>
Date:   Wed Apr 30 16:14:24 2014 +0300

    mac80211: fix nested rtnl locking on ieee80211_reconfig
    
    ieee80211_reconfig already holds rtnl, so calling
    cfg80211_sched_scan_stopped results in deadlock.
    
    Use the rtnl-version of this function instead.
    
    Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
    Cc: stable@vger.kernel.org (3.14+)
    Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 792e6aa7a15ea0fb16f8687e93caede1ea9118c7
Author: Eliad Peller <eliad@wizery.com>
Date:   Wed Apr 30 16:14:23 2014 +0300

    cfg80211: add cfg80211_sched_scan_stopped_rtnl
    
    Add locked-version for cfg80211_sched_scan_stopped.
    This is used for some users that might want to
    call it when rtnl is already locked.
    
    Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
    Cc: stable@vger.kernel.org (3.14+)
    Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit c1fbb258846dfc425507a093922d2d001e54c3ea
Author: Eliad Peller <eliad@wizery.com>
Date:   Wed Apr 30 15:58:13 2014 +0300

    cfg80211: free sme on connection failures
    
    cfg80211 is notified about connection failures by
    __cfg80211_connect_result() call. However, this
    function currently does not free cfg80211 sme.
    
    This results in hanging connection attempts in some cases
    
    e.g. when mac80211 authentication attempt is denied,
    we have this function call:
    ieee80211_rx_mgmt_auth() -> cfg80211_rx_mlme_mgmt() ->
    cfg80211_process_auth() -> cfg80211_sme_rx_auth() ->
    __cfg80211_connect_result()
    
    but cfg80211_sme_free() is never get called.
    
    Fixes: ceca7b712 ("cfg80211: separate internal SME implementation")
    Cc: stable@vger.kernel.org (3.10+)
    Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit f4ebddf9abb1fb0add1ce8e9c0bc414f1c17d81d
Author: Henning Rogge <hrogge@gmail.com>
Date:   Thu May 1 10:03:46 2014 +0200

    mac80211: Fix mac80211 station info rx bitrate for IBSS mode
    
    Filter out incoming multicast packages before applying their bitrate
    to the rx bitrate station info field to prevent them from setting the
    rx bitrate to the basic multicast rate.
    
    Signed-off-by: Henning Rogge <hrogge@gmail.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 1a7adf2e2334cccb664fcacafa17898e142085c8
Merge: a2af978 398f5d5
Author: Olof Johansson <olof@lixom.net>
Date:   Sun May 4 22:39:04 2014 -0700

    Merge tag 'mvebu-mbus_pci-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
    
    From Jason Cooper:
    mvebu drivers (mbus and pci) fixes for v3.15
    
     - pci
        - fix off-by-one for mbus window size
        - split BARs into multiple mbus windows when needed
     - mbus
        - avoid setting undefined window size
        - allow several windows with the same target/attr
    
    * tag 'mvebu-mbus_pci-fixes-3.15' of git://git.infradead.org/linux-mvebu:
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      bus: mvebu-mbus: allow several windows with the same target/attribute
      bus: mvebu-mbus: Avoid setting an undefined window size
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit a2af978986706148397264ae7186ed48cd7ee71a
Merge: 1270f06 e247686
Author: Olof Johansson <olof@lixom.net>
Date:   Sun May 4 22:35:15 2014 -0700

    Merge tag 'mvebu-dt-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
    
    From Jason Cooper:
    mvebu DT fixes for v3.15
    
     - mvebu
        - fix NOR bus width on Armada XP boards
        - use qsgmii on Armada XP GP board
        - add i2c bus freq for Armada 370 DB board
        - add SATA interface for Armada 375 DB
    
     - kirkwood
        - fix double probe of audio codec for T5325
    
    * tag 'mvebu-dt-fixes-3.15' of git://git.infradead.org/linux-mvebu:
      ARM: Kirkwood: T5325: Fix double probe of Codec
      ARM: mvebu: enable the SATA interface on Armada 375 DB
      ARM: mvebu: specify I2C bus frequency on Armada 370 DB
      ARM: mvebu: use qsgmii phy-mode for Armada XP GP interfaces
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 1270f063f95c9c57c59b60c7122603e633c6e276
Merge: 9a2044fc 1cc9d48
Author: Olof Johansson <olof@lixom.net>
Date:   Sun May 4 22:27:30 2014 -0700

    Merge tag 'mvebu-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
    
    From Jason Cooper:
    mvebu fixes for v3.15
    
     - devbus: fix bus-width conversion
    
     - orion5x: fix target ID for crypto SRAM window
    
    * tag 'mvebu-fixes-3.15' of git://git.infradead.org/linux-mvebu:
      ARM: orion5x: fix target ID for crypto SRAM window
      memory: mvebu-devbus: fix the conversion of the bus width
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 9a2044fce2021358e082d344b8c248e83b1c499b
Merge: 12e8e59 4c05160
Author: Olof Johansson <olof@lixom.net>
Date:   Sun May 4 22:20:30 2014 -0700

    Merge tag 'omap-for-v3.15/fixes-gpmc' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes
    
    Merge fixes from Tony Lindgren:
    
    Mostly fixes for occasional memory corruption caused by bad
    timings for smc911x LAN9220 (and potentially LAN9221) devices
    that were noted on a cm-t3730 system. Also fix THUMB mode
    for SMP, and mailbox related warnings when booted with device
    tree.
    
    * tag 'omap-for-v3.15/fixes-gpmc' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap:
      ARM: dts: AM3517: Disable absent IPs inherited from OMAP3
      ARM: dts: OMAP2: Fix interrupts for OMAP2420 mailbox
      ARM: dts: OMAP5: Add mailbox dt node to fix boot warning
      ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU
      ARM: dts: am437x-gp-evm: Do not reset gpio5
      ARM: dts: omap3-igep0020: use SMSC9221 timings
      ARM: dts: Fix GPMC timings for LAN9220
      ARM: dts: Fix GPMC Ethernet timings for omap cm-t sbc-t boards for device tree
      ARM: dts: Fix bad OTG muxing for cm-t boards
    
    Signed-off-by: Olof Johansson <olof@lixom.net>

commit 788296b2d19d16ec33aba0a5ad1544d50bb58601
Author: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date:   Wed Apr 30 14:56:28 2014 +0200

    ARM: dts: kirkwood: fix mislocated pcie-controller nodes
    
    Commit 54397d85349f
     ("ARM: kirkwood: Relocate PCIe device tree nodes")
    
    moved the pcie-controller nodes for the Kirkwood SoCs to the mbus
    bus node. For some reason, two boards were not properly converted
    and have their pci-controller nodes still in the ocp bus node.
    
    As the corresponding SoC pcie-controller does not exist anymore,
    it is likely that pcie is broken on those boards since above commit.
    Fix it by moving the pcie related nodes to the correct location.
    
    Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Fixes: 54397d85349f ("ARM: kirkwood: Relocate PCIe device tree nodes")
    Cc: <stable@vger.kernel.org> # v3.12+
    Acked-by: Andrew Lunn <andrew@lunn.ch>
    Link: https://lkml.kernel.org/r/1398862602-29595-2-git-send-email-sebastian.hesselbarth@gmail.com
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit f5f3cf6f7e49b9529fc00a2c4629fa92cf2755fe
Author: Aristeu Rozanski <aris@redhat.com>
Date:   Thu Apr 24 15:33:21 2014 -0400

    device_cgroup: fix the comment format for recently added functions
    
    Moving more extensive explanations to the end of the comment.
    
    Cc: Li Zefan <lizefan@huawei.com>
    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
    Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit e783c51cce94521c10e599e991acdcfd9a996c4a
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Sun May 4 21:48:06 2014 +0800

    ahci: imx: software workaround for phy reset issue in resume
    
    When suspending imx6q systems which have rootfs on SATA, the following
    error will likely be seen in resume.  The SATA link will fail to come
    up, and it results in an unusable system across the suspend/resume
    cycle.
    
    $ echo mem > /sys/power/state
    PM: Syncing filesystems ... done.
    PM: Preparing system for mem sleep
    Freezing user space processes ... (elapsed 0.002 seconds) done.
    Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
    PM: Entering mem sleep
    sd 0:0:0:0: [sda] Synchronizing SCSI cache
    sd 0:0:0:0: [sda] Stopping disk
    PM: suspend of devices complete after 61.914 msecs
    PM: suspend devices took 0.070 seconds
    PM: late suspend of devices complete after 4.906 msecs
    PM: noirq suspend of devices complete after 4.521 msecs
    Disabling non-boot CPUs ...
    CPU1: shutdown
    CPU2: shutdown
    CPU3: shutdown
    Enabling non-boot CPUs ...
    CPU1: Booted secondary processor
    CPU1 is up
    CPU2: Booted secondary processor
    CPU2 is up
    CPU3: Booted secondary processor
    CPU3 is up
    PM: noirq resume of devices complete after 10.486 msecs
    PM: early resume of devices complete after 4.679 msecs
    sd 0:0:0:0: [sda] Starting disk
    PM: resume of devices complete after 22.674 msecs
    PM: resume devices took 0.030 seconds
    PM: Finishing wakeup.
    Restarting tasks ... done.
    $ ata1: SATA link down (SStatus 1 SControl 300)
    ata1: SATA link down (SStatus 1 SControl 300)
    ata1: limiting SATA link speed to 1.5 Gbps
    ata1: SATA link down (SStatus 1 SControl 310)
    ata1.00: disabled
    ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen t4
    ata1: irq_stat 0x00000040, connection status changed
    ata1: SError: { CommWake DevExch }
    ata1: hard resetting link
    sd 0:0:0:0: rejecting I/O to offline device
    sd 0:0:0:0: killing request
    sd 0:0:0:0: rejecting I/O to offline device
    Aborting journal on device sda2-8.
    sd 0:0:0:0: rejecting I/O to offline device
    EXT4-fs warning (device sda2): ext4_end_bio:317: I/O error writing to inode 132577 (offset 0 size 0 starting block 26235)
    Buffer I/O error on device sda2, logical block 10169
    ...
    
    It's caused by a silicon issue that SATA phy does not get reset by
    controller when coming back from LPM.  The patch adds a software
    workaround for this issue.  It enforces a software reset on SATA phy
    in imx_sata_enable() function, so that we can ensure SATA link will
    come up properly in both power-on and resume.
    
    The software reset is implemented by writing phy reset register through
    the phy control register bus interface.  Functions
    imx_phy_reg_[addressing|write|read]() implement this bus interface, while
    imx_sata_phy_reset() performs the actually reset operation.
    
    Signed-off-by: Richard Zhu <r65037@freescale.com>
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit 24a9ad5b82929cdeaff70018d82263de0c34c45d
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Sun May 4 21:48:05 2014 +0800

    ahci: imx: add namespace for register enums
    
    Update register enums a little bit to add proper namespace prefix, and
    have the names match i.MX reference manual.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit ecd15dd7e45f3683fa8142b9f2c015dfaa0c243d
Author: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date:   Sun May 4 13:35:37 2014 +0200

    netfilter: nfnetlink: Fix use after free when it fails to process batch
    
    This bug manifests when calling the nft command line tool without
    nf_tables kernel support.
    
    kernel message:
    [   44.071555] Netfilter messages via NETLINK v0.30.
    [   44.072253] BUG: unable to handle kernel NULL pointer dereference at 0000000000000119
    [   44.072264] IP: [<ffffffff8171db1f>] netlink_getsockbyportid+0xf/0x70
    [   44.072272] PGD 7f2b74067 PUD 7f2b73067 PMD 0
    [   44.072277] Oops: 0000 [#1] SMP
    [...]
    [   44.072369] Call Trace:
    [   44.072373]  [<ffffffff8171fd81>] netlink_unicast+0x91/0x200
    [   44.072377]  [<ffffffff817206c9>] netlink_ack+0x99/0x110
    [   44.072381]  [<ffffffffa004b951>] nfnetlink_rcv+0x3c1/0x408 [nfnetlink]
    [   44.072385]  [<ffffffff8171fde3>] netlink_unicast+0xf3/0x200
    [   44.072389]  [<ffffffff817201ef>] netlink_sendmsg+0x2ff/0x740
    [   44.072394]  [<ffffffff81044752>] ? __mmdrop+0x62/0x90
    [   44.072398]  [<ffffffff816dafdb>] sock_sendmsg+0x8b/0xc0
    [   44.072403]  [<ffffffff812f1af5>] ? copy_user_enhanced_fast_string+0x5/0x10
    [   44.072406]  [<ffffffff816dbb6c>] ? move_addr_to_kernel+0x2c/0x50
    [   44.072410]  [<ffffffff816db423>] ___sys_sendmsg+0x3c3/0x3d0
    [   44.072415]  [<ffffffff811301ba>] ? handle_mm_fault+0xa9a/0xc60
    [   44.072420]  [<ffffffff811362d6>] ? mmap_region+0x166/0x5a0
    [   44.072424]  [<ffffffff817da84c>] ? __do_page_fault+0x1dc/0x510
    [   44.072428]  [<ffffffff812b8b2c>] ? apparmor_capable+0x1c/0x60
    [   44.072435]  [<ffffffff817d6e9a>] ? _raw_spin_unlock_bh+0x1a/0x20
    [   44.072439]  [<ffffffff816dfc86>] ? release_sock+0x106/0x150
    [   44.072443]  [<ffffffff816dc212>] __sys_sendmsg+0x42/0x80
    [   44.072446]  [<ffffffff816dc262>] SyS_sendmsg+0x12/0x20
    [   44.072450]  [<ffffffff817df616>] system_call_fastpath+0x1a/0x1f
    
    Signed-off-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit 895162b1101b3ea5db08ca6822ae9672717efec0
Author: Florian Westphal <fw@strlen.de>
Date:   Fri May 2 15:32:16 2014 +0200

    netfilter: ipv4: defrag: set local_df flag on defragmented skb
    
    else we may fail to forward skb even if original fragments do fit
    outgoing link mtu:
    
    1. remote sends 2k packets in two 1000 byte frags, DF set
    2. we want to forward but only see '2k > mtu and DF set'
    3. we then send icmp error saying that outgoing link is 1500
    
    But original sender never sent a packet that would not fit
    the outgoing link.
    
    Setting local_df makes outgoing path test size vs.
    IPCB(skb)->frag_max_size, so we will still send the correct
    error in case the largest original size did not fit
    outgoing link mtu.
    
    Reported-by: Maxime Bizon <mbizon@freebox.fr>
    Suggested-by: Maxime Bizon <mbizon@freebox.fr>
    Fixes: 5f2d04f1f9 (ipv4: fix path MTU discovery with connection tracking)
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit c3676d5ceff213cba35af5ee5f320d2e8dc48cdf
Author: Mark Brown <broonie@linaro.org>
Date:   Thu May 1 10:47:52 2014 -0700

    spi: core: Don't destroy master queue if we fail to create it
    
    If we fail to create the master queue for some reason we should not attempt
    to clean it up since attempting to stop a kthread that was not created will
    hang and it's just generally bad practice. Unfortunately at present we call
    spi_destroy_queue() even in cases where the creation fails.
    
    Fix this by fixing the error handling in spi_master_initialize_queue() so
    that we only flag the master as queued or destroy the queue if creation
    succeeded. The change to the flag is done since the general master
    cleanup uses this to destroy the queue.
    
    Reported-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>
    Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

commit 3d89e141bbf8619f3db97c38e33cb6d7a563614d
Author: Axel Lin <axel.lin@ingics.com>
Date:   Sat May 3 10:57:57 2014 +0800

    spi: qup: Fix return value checking for pm_runtime_get_sync()
    
    pm_runtime_get_sync() returns 1 if !CONFIG_PM_RUNTIME.
    
    Signed-off-by: Axel Lin <axel.lin@ingics.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 2de440f59ca9615c92820d165d5e59756e54026b
Author: Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri May 2 06:29:34 2014 +0200

    spi: core: Protect DMA code by #ifdef CONFIG_HAS_DMA
    
    If NO_DMA=y:
    
    drivers/built-in.o: In function `spi_map_buf':
    spi.c:(.text+0x21bc60): undefined reference to `dma_map_sg'
    drivers/built-in.o: In function `spi_unmap_buf.isra.33':
    spi.c:(.text+0x21c32e): undefined reference to `dma_unmap_sg'
    make[3]: *** [vmlinux] Error 1
    
    Protect the DMA code by #ifdef CONFIG_HAS_DMA to fix this:
      - Extract __spi_map_msg() from spi_map_msg(),
      - Provide dummy definitions of __spi_map_msg() and spi_unmap_msg() if
        !CONFIG_HAS_DMA.
    
    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 51b4e24f383c84ed927fef348072b6dc65b9816d
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:33 2014 +0100

    ASoC: Intel: Fix stream position pointer.
    
    Read the stream offset and presentation position from DSP memory rather
    than using the old estimated position. This fixes timing issues with
    pulseaudio.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 916152c48848290a8aba5cf4dd16c2a8a888e11c
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:32 2014 +0100

    ASoC: Intel: Fix allow hw_params to be called more than once.
    
    hw_params() can be called multiple times. Make sure we release the DSP
    stream that was allocated on previous hw_params() calls before allocating
    a new DSP stream.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 10df350977b15d44dba0b3b44e3da7989711cb8d
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:31 2014 +0100

    ASoC: Intel: Fix Audio DSP usage when IOMMU is enabled.
    
    The Intel IOMMU requires that the ACPI device is used to allocate all
    DMA memory buffers. This means we need to pass the DMA device pointer into child
    component devices that allocate DMA memory.
    
    We also only set the DMA mask for the ACPI device now instead of for each
    component device.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 0b708c87f66a15190fb43661c2320fd48c4dc6c8
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:30 2014 +0100

    ASoC: Intel: Fix Haswell/Broadwell DSP page table creation.
    
    Fix page table creation on Haswell and Broadwell to remove unsafe
    virt_to_phys mappings and use more portable SG buffer. Use audio buffer
    APIs to allocate DMA buffers.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 84fbdd58614e35108ece5c79ada33443dbcdaf37
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:29 2014 +0100

    ASoC: Intel: Fix allocated block list usage when adding blocks.
    
    Make sure we add the allocated blocks to the modules list of blocks.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 48695f3d4e7abbfb8fbba45397dce4d5fc0ccfed
Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Date:   Fri May 2 16:56:27 2014 +0100

    ASoC: Intel: Fix block allocation so we only allocate blocks once.
    
    Make sure we dont alloc blocks twice with requests spanning more
    than one block.
    
    Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 34f51147d2e64da842679a97ffcfd17c8a0e6943
Author: Dave Young <dyoung@redhat.com>
Date:   Thu May 1 21:15:48 2014 +0800

    x86/efi: earlyprintk=efi,keep fix
    
    earlyprintk=efi,keep will cause kernel hangs while freeing initmem like
    below:
    
      VFS: Mounted root (ext4 filesystem) readonly on device 254:2.
      devtmpfs: mounted
      Freeing unused kernel memory: 880K (ffffffff817d4000 - ffffffff818b0000)
    
    It is caused by efi earlyprintk use __init function which will be freed
    later.  Such as early_efi_write is marked as __init, also it will use
    early_ioremap which is init function as well.
    
    To fix this issue, I added early initcall early_efi_map_fb which maps
    the whole efi fb for later use. OTOH, adding a wrapper function
    early_efi_map which calls early_ioremap before ioremap is available.
    
    With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
    
    Signed-off-by: Dave Young <dyoung@redhat.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

commit 84e108fc7b23310fb6d93a657e47181d64ab6e93
Author: Maxime Ripard <maxime.ripard@free-electrons.com>
Date:   Mon Apr 28 11:44:36 2014 -0700

    ARM: sunxi: Enable GMAC in sunxi_defconfig
    
    Since the support of the GMAC has been merged, we're using it as the ethernet
    controller on the A20 devices.
    
    However, sunxi_defconfig wasn't selecting it hence breaking the NFS boot.
    
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8
Author: Salva Peiró <speiro@ai2.upv.es>
Date:   Wed Apr 30 19:48:02 2014 +0200

    [media] media-device: fix infoleak in ioctl media_enum_entities()
    
    This fixes CVE-2014-1739.
    
    Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 874f224cc52d64c912087e68e3724be95ad80ee7
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Fri Apr 18 16:29:43 2014 -0700

    clk: Fix slab corruption in clk_unregister()
    
    When a clock is unregsitered, we iterate over the list of
    children and reparent them to NULL (i.e. orphan list). While
    iterating the list, we should use the safe iterators because the
    children list for this clock is changing when we reparent the
    children to NULL. Failure to iterate safely can lead to slab
    corruption like this:
    
    =============================================================================
    BUG kmalloc-128 (Not tainted): Poison overwritten
    -----------------------------------------------------------------------------
    
    Disabling lock debugging due to kernel taint
    INFO: 0xed0c4900-0xed0c4903. First byte 0x0 instead of 0x6b
    INFO: Allocated in clk_register+0x20/0x1bc age=297 cpu=2 pid=70
     __slab_alloc.isra.39.constprop.42+0x410/0x454
     kmem_cache_alloc_trace+0x200/0x24c
     clk_register+0x20/0x1bc
     devm_clk_register+0x34/0x68
     0xbf0000f0
     platform_drv_probe+0x18/0x48
     driver_probe_device+0x94/0x360
     __driver_attach+0x94/0x98
     bus_for_each_dev+0x54/0x88
     bus_add_driver+0xe8/0x204
     driver_register+0x78/0xf4
     do_one_initcall+0xc4/0x17c
     load_module+0x19ac/0x2294
     SyS_init_module+0xa4/0x110
     ret_fast_syscall+0x0/0x48
    INFO: Freed in clk_unregister+0xd4/0x140 age=23 cpu=2 pid=73
     __slab_free+0x38/0x41c
     clk_unregister+0xd4/0x140
     release_nodes+0x164/0x1d8
     __device_release_driver+0x60/0xb0
     driver_detach+0xb4/0xb8
     bus_remove_driver+0x5c/0xc4
     SyS_delete_module+0x148/0x1d8
     ret_fast_syscall+0x0/0x48
    INFO: Slab 0xeec50b90 objects=25 used=0 fp=0xed0c5400 flags=0x4080
    INFO: Object 0xed0c48c0 @offset=2240 fp=0xed0c4a00
    
    Bytes b4 ed0c48b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
    Object ed0c48c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c48d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c48e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c48f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c4900: 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ....kkkkkkkkkkkk
    Object ed0c4910: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c4920: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    Object ed0c4930: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
    Redzone ed0c4940: bb bb bb bb                                      ....
    Padding ed0c49e8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
    Padding ed0c49f8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
    CPU: 3 PID: 75 Comm: mdev Tainted: G    B         3.14.0-11033-g2054ba5ca781 #35
    [<c0014be0>] (unwind_backtrace) from [<c0012240>] (show_stack+0x10/0x14)
    [<c0012240>] (show_stack) from [<c04b74a0>] (dump_stack+0x70/0xbc)
    [<c04b74a0>] (dump_stack) from [<c00f7a78>] (check_bytes_and_report+0xbc/0x100)
    [<c00f7a78>] (check_bytes_and_report) from [<c00f7c48>] (check_object+0x18c/0x218)
    [<c00f7c48>] (check_object) from [<c00f7efc>] (__free_slab+0x104/0x144)
    [<c00f7efc>] (__free_slab) from [<c04b6668>] (__slab_free+0x3dc/0x41c)
    [<c04b6668>] (__slab_free) from [<c014c008>] (load_elf_binary+0x88/0x12b4)
    [<c014c008>] (load_elf_binary) from [<c0105a44>] (search_binary_handler+0x78/0x18c)
    [<c0105a44>] (search_binary_handler) from [<c0106fc0>] (do_execve+0x490/0x5dc)
    [<c0106fc0>] (do_execve) from [<c0036b8c>] (____call_usermodehelper+0x134/0x168)
    [<c0036b8c>] (____call_usermodehelper) from [<c000f048>] (ret_from_fork+0x14/0x2c)
    FIX kmalloc-128: Restoring 0xed0c4900-0xed0c4903=0x6b
    
    Fixes: fcb0ee6a3d33 (clk: Implement clk_unregister)
    Cc: Jiada Wang <jiada_wang@mentor.com>
    Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Cc: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>
    Cc: stable@vger.kernel.org

commit 293ba3b4a4fd54891b900f2911d1a57e1ed4a843
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Fri Apr 18 16:29:42 2014 -0700

    clk: Fix double free due to devm_clk_register()
    
    Now that clk_unregister() frees the struct clk we're
    unregistering we'll free memory twice: first we'll call kfree()
    in __clk_release() with an address kmalloc doesn't know about and
    second we'll call kfree() in the devres layer. Remove the
    allocation of struct clk in devm_clk_register() and let
    clk_release() handle it. This fixes slab errors like:
    
    =============================================================================
    BUG kmalloc-128 (Not tainted): Invalid object pointer 0xed08e8d0
    -----------------------------------------------------------------------------
    
    Disabling lock debugging due to kernel taint
    INFO: Slab 0xeec503f8 objects=25 used=15 fp=0xed08ea00 flags=0x4081
    CPU: 2 PID: 73 Comm: rmmod Tainted: G    B         3.14.0-11032-g526e9c764381 #34
    [<c0014be0>] (unwind_backtrace) from [<c0012240>] (show_stack+0x10/0x14)
    [<c0012240>] (show_stack) from [<c04b74dc>] (dump_stack+0x70/0xbc)
    [<c04b74dc>] (dump_stack) from [<c00f6778>] (slab_err+0x74/0x84)
    [<c00f6778>] (slab_err) from [<c04b6278>] (free_debug_processing+0x2cc/0x31c)
    [<c04b6278>] (free_debug_processing) from [<c04b6300>] (__slab_free+0x38/0x41c)
    [<c04b6300>] (__slab_free) from [<c03931bc>] (clk_unregister+0xd4/0x140)
    [<c03931bc>] (clk_unregister) from [<c02fb774>] (release_nodes+0x164/0x1d8)
    [<c02fb774>] (release_nodes) from [<c02f8698>] (__device_release_driver+0x60/0xb0)
    [<c02f8698>] (__device_release_driver) from [<c02f9080>] (driver_detach+0xb4/0xb8)
    [<c02f9080>] (driver_detach) from [<c02f8480>] (bus_remove_driver+0x5c/0xc4)
    [<c02f8480>] (bus_remove_driver) from [<c008c9b8>] (SyS_delete_module+0x148/0x1d8)
    [<c008c9b8>] (SyS_delete_module) from [<c000ef80>] (ret_fast_syscall+0x0/0x48)
    FIX kmalloc-128: Object at 0xed08e8d0 not freed
    
    Fixes: fcb0ee6a3d33 (clk: Implement clk_unregister)
    Cc: Jiada Wang <jiada_wang@mentor.com>
    Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Cc: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>
    Cc: stable@vger.kernel.org

commit 2aa6dd07bd86daf4dd7ddb3118dd2d0941fbda2e
Merge: dd23c2c a30d27e
Author: Mike Turquette <mturquette@linaro.org>
Date:   Fri Apr 25 08:33:28 2014 -0700

    Merge tag 'socfpga-clk-fix-for-3.15' of git://git.rocketboards.org/linux-socfpga-next into clk-fixes-socfpga
    
    clk: socfpga: clock fix for v3.15
    
    Currently on 3.15-rc1, the SOCFPGA platform is unable to boot. This patch
    fixes the issue and allows the platform to boot.

commit a30d27ed739b2c6662f07c76e5deea7bc916bd12
Author: Dinh Nguyen <dinguyen@altera.com>
Date:   Mon Apr 14 07:59:32 2014 -0500

    clk: socfpga: fix clock driver for 3.15
    
    commit [1771b10d6 clk: respect the clock dependencies in of_clk_init]
    exposed a flaw in the socfpga clock driver and prevents the platform
    from booting on 3.15-rc1.
    
    Because the "altr,clk-mgr" is not really a clock, it should not be using
    CLK_OF_DECLARE, instead we should be mapping the clk-mgr's base address
    one of the functional clock init function. Use the socfpga_pll_init function
    to map the clk_mgr_base_addr as this clock should always be initialized first.
    
    Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
    Tested-by: Pavel Machek <pavel@denx.de>

commit dd23c2cd38da2c64af381b19795d2c4f115e8ecb
Author: Maxime COQUELIN <maxime.coquelin@st.com>
Date:   Wed Jan 29 17:24:06 2014 +0100

    clk: divider: Fix best div calculation for power-of-two and table dividers
    
    The divider returned by clk_divider_bestdiv() is likely to be invalid in case
    of power-of-two and table dividers when CLK_SET_RATE_PARENT flag isn't set.
    
    Fixes boot on STiH416 platform.
    
    Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>
    [mturquette@linaro.org: trivial merge conflict & updated changelog]

commit e813d49d2a477e3b64a9ff32ca7db5737d36cd91
Author: Alex Elder <elder@linaro.org>
Date:   Mon Apr 7 08:22:12 2014 -0500

    clk: bcm281xx: don't use unnamed structs or unions
    
    The Broadcom Kona clock code, as originally written, made use of
    unnamed union and struct fields.  This is a feature present in C11,
    and is a GNU extension otherwise.  It worked very well for me.
    
    Unfortunately, Russell King reported that this feature was not
    supported in a build environment he used, which meant attempting
    to build this code failed spectacularly.
    
    Add names to these unnamed fields, and update the code accordingly.
    
    Reported-by: Russell King <linux@arm.linux.org.uk>
    Tested-by: Markus Mayer <markus.mayer@linaro.org>
    Signed-off-by: Alex Elder <elder@linaro.org>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>

commit fe337ac2839521b360f828b3ebd992d597b1ad16
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Apr 28 21:07:31 2014 +0200

    netfilter: ctnetlink: don't add null bindings if no nat requested
    
    commit 0eba801b64cc8284d9024c7ece30415a2b981a72 tried to fix a race
    where nat initialisation can happen after ctnetlink-created conntrack
    has been created.
    
    However, it causes the nat module(s) to be loaded needlessly on
    systems that are not using NAT.
    
    Fortunately, we do not have to create null bindings in that case.
    
    conntracks injected via ctnetlink always have the CONFIRMED bit set,
    which prevents addition of the nat extension in nf_nat_ipv4/6_fn().
    
    We only need to make sure that either no nat extension is added
    or that we've created both src and dst manips.
    
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

commit cf7eb979116c2568e8bc3b6a7269c7a359864ace
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Apr 13 20:44:46 2014 +0200

    ARM: common: edma: Fix xbar mapping
    
    This is another great example of trainwreck engineering:
    
    commit 2646a0e529 (ARM: edma: Add EDMA crossbar event mux support)
    added support for using EDMA on peripherals which have no direct EDMA
    event mapping.
    
    The code compiles and does not explode in your face, but that's it.
    
    1) Reading an u16 array from an u32 device tree array simply does not
       work. Even if the function is named "edma_of_read_u32_to_s16_array".
    
       It merily calls of_property_read_u16_array. So the resulting 16bit
       array will have every other entry = 0.
    
    2) The DT entry for the xbar registers related to xbar has length 0x10
       instead of the real length: 0xfd0 - 0xf90 = 0x40.
    
       Not a real problem as it does not cross a page boundary, but
       wrong nevertheless.
    
    3) But none of this matters as the mapping never happens:
    
       After reading nonsense edma_of_read_u32_to_s16_array() invalidates
       the first array entry pair, so nobody can ever notice the
       braindamage by immediate explosion.
    
    Seems the QA criteria for this code was solely not to explode when
    someone adds edma-xbar-event-map entries to the DT. Goal achieved,
    congratulations!
    
    Not really helpful if someone wants to use edma on a device which
    requires a xbar mapping.
    
    Fix the issues by:
    
    - annotating the device tree entry with "/bits/ 16" as documented in
      the of_property_read_u16_array kernel doc
    
    - make the size of the xbar register mapping correct
    
    - invalidating the end of the array and not the start
    
    This convoluted mess wants to be completely rewritten as there is no
    point to keep the xbar_chan array memory and the iomapping of the xbar
    regs around forever. Marking the xbar mapped channels as used should
    be done right there.
    
    But that's a different issue and this patch is small enough to make it
    work and allows a simple backport for stable.
    
    Cc: stable@vger.kernel.org # v3.12+
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Sekhar Nori <nsekhar@ti.com>

commit b18db0b80867931f4e3a844400a3c22a4fd2ff57
Author: Alexander Graf <agraf@suse.de>
Date:   Tue Apr 29 12:17:26 2014 +0200

    KVM guest: Make pv trampoline code executable
    
    Our PV guest patching code assembles chunks of instructions on the fly when it
    encounters more complicated instructions to hijack. These instructions need
    to live in a section that we don't mark as non-executable, as otherwise we
    fault when jumping there.
    
    Right now we put it into the .bss section where it automatically gets marked
    as non-executable. Add a check to the NX setting function to ensure that we
    leave these particular pages executable.
    
    Signed-off-by: Alexander Graf <agraf@suse.de>

commit 61622cc6f29034d0479f7ac16f3d48f1eeabf3a1
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Tue Apr 29 07:50:44 2014 +0200

    xfrm4: Properly handle unsupported protocols
    
    We don't catch the case if an unsupported protocol is submitted
    to the xfrm4 protocol handlers, this can lead to NULL pointer
    dereferences. Fix this by adding the appropriate checks.
    
    Fixes: 3328715e ("xfrm4: Add IPsec protocol multiplexer")
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

commit 98d7e1aee6dd534f468993f8c6a1bc730d4cfa81
Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date:   Mon Apr 21 15:06:23 2014 +0200

    ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
    
    Commit 7b2e1277598e4187c9be3e61fd9b0f0423f97986 ("ARM: OMAP3: clock:
    Back-propagate rate change from cam_mclk to dpll4_m5") enabled clock
    rate back-propagation from cam_mclk do dpll4_m5 on OMAP3630 only.
    Perform back-propagation on other OMAP3 platforms as well.
    
    Reported-by: Jean-Philippe François <jp.francois@cynove.com>
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Paul Walmsley <paul@pwsan.com>

commit a38670459d6883582bc360ee480f9fcec4900162
Author: Maxime Ripard <maxime.ripard@free-electrons.com>
Date:   Fri Apr 18 21:13:08 2014 +0200

    ARM: sun7i: Fix i2c4 base address
    
    For some reason, the base address of the fifth I2C adapter in the A20 was
    incorrect. Change this to the actual base address.
    
    Reported-by: Marcus Cooper <codekipper@gmail.com>
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
    Acked-by: Hans de Goede <hdegoede@redhat.com>

commit ab78475c76bd8c54375d8a778200c59314973d30
Author: Alexander Graf <agraf@suse.de>
Date:   Sun Apr 6 23:31:48 2014 +0200

    KVM: PPC: Book3S: ifdef on CONFIG_KVM_BOOK3S_32_HANDLER for 32bit
    
    The book3s_32 target can get built as module which means we don't see the
    config define for it in code. Instead, check on the bool define
    CONFIG_KVM_BOOK3S_32_HANDLER whenever we want to know whether we're building
    for a book3s_32 host.
    
    This fixes running book3s_32 kvm as a module for me.
    
    Signed-off-by: Alexander Graf <agraf@suse.de>
    Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 0a8eccefcb3423b45dc0a5a527b4799520e2bc94
Author: Paul Mackerras <paulus@au1.ibm.com>
Date:   Mon Apr 14 08:56:26 2014 +1000

    KVM: PPC: Book3S HV: Add missing code for transaction reclaim on guest exit
    
    Testing by Michael Neuling revealed that commit e4e38121507a ("KVM:
    PPC: Book3S HV: Add transactional memory support") is missing the code
    that saves away the checkpointed state of the guest when switching to
    the host.  This adds that code, which was in earlier versions of the
    patch but went missing somehow.
    
    Reported-by: Michael Neuling <mikey@neuling.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Alexander Graf <agraf@suse.de>

commit 1ad9f23873a4ee837643be5a29c05e405ec54e18
Author: pingfank@linux.vnet.ibm.com <pingfank@linux.vnet.ibm.com>
Date:   Tue Apr 15 16:33:40 2014 +0800

    KVM: PPC: Book3S: HV: make _PAGE_NUMA take effect
    
    Numa fault is a method which help to achieve auto numa balancing.
    When such a page fault takes place, the page fault handler will check
    whether the page is placed correctly. If not, migration should be
    involved to cut down the distance between the cpu and pages.
    
    A pte with _PAGE_NUMA help to implement numa fault. It means not to
    allow the MMU to access the page directly. So a page fault is triggered
    and numa fault handler gets the opportunity to run checker.
    
    As for the access of MMU, we need special handling for the powernv's guest.
    When we mark a pte with _PAGE_NUMA, we already call mmu_notifier to
    invalidate it in guest's htab, but when we tried to re-insert them,
    we firstly try to map it in real-mode. Only after this fails, we fallback
    to virt mode, and most of important, we run numa fault handler in virt
    mode.  This patch guards the way of real-mode to ensure that if a pte is
    marked with _PAGE_NUMA, it will NOT be mapped in real mode, instead, it will
    be mapped in virt mode and have the opportunity to be checked with placement.
    
    Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
    Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Alexander Graf <agraf@suse.de>

commit 27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04
Author: Horia Geanta <horia.geanta@freescale.com>
Date:   Fri Apr 18 13:01:42 2014 +0300

    crypto: caam - add allocation failure handling in SPRINTFCAT macro
    
    GFP_ATOMIC memory allocation could fail.
    In this case, avoid NULL pointer dereference and notify user.
    
    Cc: <stable@vger.kernel.org> # 3.2+
    Cc: Kim Phillips <kim.phillips@freescale.com>
    Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

commit 05a812ac474d0d6aef6d54b66bb08b81abde79c6
Author: Vladimir Murzin <murzin.v@gmail.com>
Date:   Sun Apr 27 10:09:12 2014 +0100

    xen/events/fifo: correctly align bitops
    
    FIFO event channels require bitops on 32-bit aligned values (the event
    words).  Linux's bitops require unsigned long alignment which may be
    64-bits.
    
    On arm64 an incorrectly unaligned access will fault.
    
    Fix this by aligning the bitops along with an adjustment for bit
    position and using an unsigned long for the local copy of the ready
    word.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
    Tested-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
    Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
    Signed-off-by: David Vrabel <david.vrabel@citrix.com>

commit 063aa8e68e53cc0d0961ea90c12cea40c6b94828
Author: Julien Grall <julien.grall@linaro.org>
Date:   Fri Apr 18 16:54:34 2014 +0100

    arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h
    
    virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 "ARM: Better
    virt_to_page() handling"
    
    This will result of a compilation warning when CONFIG_XEN is enabled.
    
    arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefined [enabled by default]
     #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
     ^
    In file included from arch/arm/include/asm/page.h:163:0,
                     from arch/arm/include/asm/xen/page.h:4,
                     from include/xen/page.h:4,
                     from arch/arm/xen/grant-table.c:33:
    
    The definition in memory.h is nearly the same (it directly expand PFN_DOWN),
    so we can safely drop virt_to_pfn in xen include.
    
    Signed-off-by: Julien Grall <julien.grall@linaro.org>
    Signed-off-by: David Vrabel <david.vrabel@citrix.com>

commit 67dadcb324c2fe059cb2c35f8b80df42bb23f7c4
Merge: eb47f71 e26a9e0
Author: David Vrabel <david.vrabel@citrix.com>
Date:   Mon Apr 28 10:31:04 2014 +0100

    Merge commit 'e26a9e0' into stable/for-linus-3.15

commit a3fe964135d0e4b925eaf4a5891c84daa7885c86
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Apr 10 14:19:05 2014 +0800

    imx-drm: imx-tve: correct DDC property name to 'ddc-i2c-bus'
    
    Commit 62e3879 (imx-drm: imx-tve: Fix DDC I2C bus property) was trying
    to use 'ddc-i2c-bus' as the DDC property name (we can see that from the
    commit log), but unfortunately 'i2c-ddc-bus' which is a typo was
    actually used in the code.  This results in some unnecessary
    inconsistency and confusions, because all the documented DDC property
    in device tree bindings use 'ddc-i2c-bus'.
    
      Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
      Documentation/devicetree/bindings/panel/simple-panel.txt
      Documentation/devicetree/bindings/video/dvi-connector.txt
    
    Let's fix it before the error spreads.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit 12e8e5952598714faa6f202ab028bcd291337cce
Merge: 76e7745 35d35aa
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Apr 26 11:29:30 2014 +0200

    Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
    
    3.15 fixes for AT91
    - one little DT fix
    - the use of proper directory for clock in include/dt-bindings
      it allows to remove the now empty include/dt-bindings/clk
    
    * tag 'at91-fixes' of git://github.com/at91linux/linux-at91:
      dt-bindings: clock: Move at91.h to dt-bindigs/clock
      ARM: at91: fix spi cs on sama5d3 Xplained board
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit e247686085f71e9c25e3488ce83d5d0f77023438
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Tue Apr 15 14:40:08 2014 +0200

    ARM: Kirkwood: T5325: Fix double probe of Codec
    
    The codec is defined both in DT and the board file. The board file
    however contains platform data which is required in order that the
    codec works. When the DT instantiates the codec before the board files
    does, it is missing the platform data and so fails. Remove the DT node
    until we have a binding which can pass the additional data.
    
    Signed-off-by: Andrew Lunn <andrew@lunn.ch>
    Link: https://lkml.kernel.org/r/1397565608-1830-1-git-send-email-andrew@lunn.ch
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit d685058f5b878a71f99c8e2fd9707b3f49510b94
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Fri Apr 18 09:41:45 2014 +0200

    ARM: mvebu: enable the SATA interface on Armada 375 DB
    
    The Armada 375 SoC has a dual-port SATA interface, which is exposed on
    the Armada 375 DB board. This commit therefore enables this interface
    on the Armada 375 DB board.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397806908-7550-3-git-send-email-thomas.petazzoni@free-electrons.com
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit ac164d1144f1a699d307bb05095e352ed6de236f
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Fri Apr 18 09:41:44 2014 +0200

    ARM: mvebu: specify I2C bus frequency on Armada 370 DB
    
    In commit 249f3822509b74f8c8d0731aeb7ccea065376c9b ('ARM: mvebu: add
    audio support to Armada 370 DB'), the I2C bus 0 was enabled on the
    Armada 370 DB board, and an I2C codec was described as being connected
    on this bus.
    
    However, this commit forgot to define the I2C bus frequency, which
    leads the i2c-mv64xxx to fail probing, as it cannot calculate the baud
    rate multiplier/divisor to derive the I2C bus frequency from the core
    SoC frequency. It makes audio completely unusable, as the I2C bus is
    not probed, and therefore the audio codec is not probed either.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397806908-7550-2-git-send-email-thomas.petazzoni@free-electrons.com
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 80fa10f4e9278c4df1636a26025b12588078ad61
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Tue Apr 15 15:50:21 2014 +0200

    ARM: mvebu: use qsgmii phy-mode for Armada XP GP interfaces
    
    The Armada XP GP isn't using rgmii-id connections between the MAC and
    PHY, but instead a single QSGMII connection, which is a quad-SGMII
    connection: a double pair of differential lines that are multiplexed
    to convey the traffic of four network interfaces between a MAC and a
    PHY.
    
    Until now, the Armada XP GP was relying on the bootloader setting the
    correct values in various configuration registers. With this change,
    the mvneta driver can be used as a module on this platform.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397569821-5530-4-git-send-email-thomas.petazzoni@free-electrons.com
    Tested-by: Arnaud Ebalard <arno@natisbad.org>
    Tested-by: Willy Tarreau <w@1wt.eu>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 6e20bae8a39c40d4e03698e4160bad2d2629062b
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon Apr 14 17:29:21 2014 +0200

    ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
    
    The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
    width declared in the Device Tree being considered as a 16 bits bus
    width when configuring the hardware.
    
    This bug in mvebu-devbus driver was compensated by a symetric mistake
    in the Armada XP OpenBlocks AX3 Device Tree: a 8 bits bus width was
    declared, even though the hardware actually has a 16 bits bus width
    connection with the NOR flash.
    
    Now that we have fixed the mvebu-devbus driver to behave according to
    its Device Tree binding, this commit fixes the problematic Device Tree
    files as well.
    
    This bug was introduced in commit
    a7d4f81821f7eec3175f8e23dd6949c71ab2da43 ('ARM: mvebu: Add support for
    NOR flash device on Openblocks AX3 board') which was merged in v3.10.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397489361-5833-5-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: a7d4f81821f7 ('ARM: mvebu: Add support for NOR flash device on Openblocks AX3 board')
    Cc: stable@vger.kernel.org # v3.10+
    Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit f3aec8f3f05025e7b450102dae0759375346706e
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon Apr 14 17:29:20 2014 +0200

    ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
    
    The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
    width declared in the Device Tree being considered as a 16 bits bus
    width when configuring the hardware.
    
    This bug in mvebu-devbus driver was compensated by a symetric mistake
    in the Armada XP DB Device Tree: a 8 bits bus width was declared, even
    though the hardware actually has a 16 bits bus width connection with
    the NOR flash.
    
    Now that we have fixed the mvebu-devbus driver to behave according to
    its Device Tree binding, this commit fixes the problematic Device Tree
    files as well.
    
    This bug was introduced in commit
    b484ff42df475c5087d614c4d477273e1906bcb9 ('ARM: mvebu: Add support for
    NOR flash device on Armada XP-DB board') which was merged in v3.11.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397489361-5833-4-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: b484ff42df47 ('ARM: mvebu: Add support for NOR flash device on Armada XP-DB board')
    Cc: stable@vger.kernel.org # v3.11+
    Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 1a88f809ccb5db1509a7514b187c00b3a995fc82
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon Apr 14 17:29:19 2014 +0200

    ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
    
    The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
    width declared in the Device Tree being considered as a 16 bits bus
    width when configuring the hardware.
    
    This bug in mvebu-devbus driver was compensated by a symetric mistake
    in the Armada XP GP Device Tree: a 8 bits bus width was declared, even
    though the hardware actually has a 16 bits bus width connection with
    the NOR flash.
    
    Now that we have fixed the mvebu-devbus driver to behave according to
    its Device Tree binding, this commit fixes the problematic Device Tree
    files as well.
    
    This bug was introduced in commit
    da8d1b38356853c37116f9afa29f15648d7fb159 ('ARM: mvebu: Add support for
    NOR flash device on Armada XP-GP board') which was merged in v3.10.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397489361-5833-3-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: da8d1b383568 ('ARM: mvebu: Add support for NOR flash device on Armada XP-GP board')
    Cc: stable@vger.kernel.org # v3.10+
    Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 05d8f6593d1d0b4677822136b61d48d7581c5d16
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Fri Apr 25 12:25:42 2014 -0600

    PCI: Update my email address
    
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

commit 4c05160342f16361fc37ae34dcae9210306a83e9
Author: Suman Anna <s-anna@ti.com>
Date:   Tue Apr 22 17:23:37 2014 -0500

    ARM: dts: AM3517: Disable absent IPs inherited from OMAP3
    
    AM3517 inherits OMAP3 dts file, but does not have all the IPs
    that are present on OMAP3. This patch disables the following
    absent IPs for AM3517: Mailbox, IVA, MMU_ISP, MPU_IVA SmartReflex.
    
    A label had to be added for IVA node in omap3.dtsi to be able to
    get a reference to the node for disabling.
    
    Otherwise we get the following warnings during booting:
    platform iva.2: Cannot lookup hwmod 'iva'
    platform 48094000.mailbox: Cannot lookup hwmod 'mailbox'
    platform 480bd400.mmu: Cannot lookup hwmod 'mmu_isp'
    platform 480c9000.smartreflex: Cannot lookup hwmod 'smartreflex_mpu_iva'
    
    Signed-off-by: Suman Anna <s-anna@ti.com>
    [tony@atomide.com: updated description for the warnings]
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 4fe5bd5da2ea7b1b8c9455246ddcdb39ab734487
Author: Suman Anna <s-anna@ti.com>
Date:   Tue Apr 22 17:23:36 2014 -0500

    ARM: dts: OMAP2: Fix interrupts for OMAP2420 mailbox
    
    The mailbox module is capable of generating two interrupts
    to MPU in OMAP2420, compared to one in OMAP2430. The second
    interrupt is to handle interrupts from the additional IVA
    processor present only on OMAP2420.
    
    Move the current common mailbox DT node into the SoC
    specific files to allow the above differentiation. Also,
    added back the interrupt-names on OMAP2420, that were
    previously defined in hwmod data.
    
    This fixes regression caused by the recent dropping of
    hwmod data in favor for defining it in the .dts files.
    
    Signed-off-by: Suman Anna <s-anna@ti.com>
    [tony@atomide.com: updated description]
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 84d89c3123bf4c3145f7b19fca36dba612a69807
Author: Suman Anna <s-anna@ti.com>
Date:   Tue Apr 22 17:23:35 2014 -0500

    ARM: dts: OMAP5: Add mailbox dt node to fix boot warning
    
    Add the mailbox device DT node for OMAP5 SoC. The OMAP5 mailbox
    IP is identical to that used in OMAP4.
    
    The OMAP5 hwmod data no longer publishes the module address space,
    so this patch fixes the WARN_ON backtrace associated with the
    following trace during the kernel boot:
    "omap_hwmod: mailbox: doesn't have mpu register target base".
    
    Otherwise we get a warning like this:
    
    WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2538 _init+0x1c0/0x3dc()
    omap_hwmod: mailbox: doesn't have mpu register target base
    Modules linked in:
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc2-00001-gb5e85a0 #45
    [<c0015724>] (unwind_backtrace) from [<c00120f4>] (show_stack+0x10/0x14)
    [<c00120f4>] (show_stack) from [<c05a1ccc>] (dump_stack+0x78/0x94)
    [<c05a1ccc>] (dump_stack) from [<c0042a74>] (warn_slowpath_common+0x6c/0x8c)
    [<c0042a74>] (warn_slowpath_common) from [<c0042b28>] (warn_slowpath_fmt+0x30/0x40)
    [<c0042b28>] (warn_slowpath_fmt) from [<c0803b40>] (_init+0x1c0/0x3dc)
    [<c0803b40>] (_init) from [<c0029c8c>] (omap_hwmod_for_each+0x34/0x5c)
    [<c0029c8c>] (omap_hwmod_for_each) from [<c08042b0>] (__omap_hwmod_setup_all+0x24/0x40)
    [<c08042b0>] (__omap_hwmod_setup_all) from [<c00088b8>] (do_one_initcall+0x34/0x160)
    [<c00088b8>] (do_one_initcall) from [<c07f7bf4>] (kernel_init_freeable+0xfc/0x1c8)
    [<c07f7bf4>] (kernel_init_freeable) from [<c059c4f4>] (kernel_init+0x8/0xe4)
    [<c059c4f4>] (kernel_init) from [<c000eaa8>] (ret_from_fork+0x14/0x2c)
    
    Signed-off-by: Suman Anna <s-anna@ti.com>
    [tony@atomide.com: updated description to for the warning]
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit da0159fdb57d6fab54ce3179659a1f9e5b593752
Author: Joel Fernandes <joelf@ti.com>
Date:   Tue Apr 22 14:40:39 2014 -0500

    ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU
    
    On my DRA7 system, when the kernel is built in Thumb-2 mode, the secondary CPU
    (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
    seems to be because the CPU is in ARM mode once the ROM hands over control to
    the kernel.  Switch to Thumb-2 mode if required once the kernel is control of
    secondary CPU. On OMAP4 on the other hand, it appears to be in Thumb-2 mode on
    entry so this is not required and SMP boot works as is.
    
    Also corrected a spurious '+' and updated copyright information.
    
    Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Nishanth Menon <nm@ti.com>
    Tested-by: Nishanth Menon <nm@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Joel Fernandes <joelf@ti.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 1ff3859e7ea134c09512498aa2251fd3a57d250d
Author: Dave Gerlach <d-gerlach@ti.com>
Date:   Fri Mar 21 10:50:13 2014 +0530

    ARM: dts: am437x-gp-evm: Do not reset gpio5
    
    Do not reset GPIO5 at boot-up because GPIO5_7 is used
    on AM437x GP-EVM to control VTT regulators on DDR3.
    Without this some GP-EVM boards will fail to boot because
    of DDR3 corruption.
    
    Reported-by: Nishanth Menon <nm@ti.com>
    Tested-by: Nishanth Menon <nm@ti.com>
    Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
    Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit ef139e130c8a18cc6cdaa2d98899f74e14389bd4
Author: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date:   Thu Apr 24 18:53:50 2014 +0200

    ARM: dts: omap3-igep0020: use SMSC9221 timings
    
    The IGEPv2 board has a SMSC LAN9221i ethernet chip and not a
    SMSC LAN911x connected to the GPMC. Each chip needs different
    timings in order to operate correctly so is wrong to include
    omap-gpmc-smsc911x.dtsi instead of omap-gpmc-smsc9221.dtsi.
    
    Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
    [tony@atomide.com: this is needed to avoid potential memory corruption]
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 2a1c23e3396d5a77d6c8e379d18cc657b6225779
Author: Joe Perches <joe@perches.com>
Date:   Thu Apr 24 18:51:03 2014 -0700

    ASoC: tlv320aic31xx: Convert /n to \n
    
    Use a newline character appropriately.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit a87c9ad956676d84d459739fc14ec5a3c3565717
Author: Jeff Layton <jlayton@redhat.com>
Date:   Wed Mar 26 07:24:23 2014 -0700

    cifs: fix actimeo=0 corner case when cifs_i->time == jiffies
    
    actimeo=0 is supposed to be a special case that ensures that inode
    attributes are always refetched from the server instead of trusting the
    cache. The cifs code however uses time_in_range() to determine whether
    the attributes have timed out. In the case where cifs_i->time equals
    jiffies, this leads to the cifs code not refetching the inode attributes
    when it should.
    
    Fix this by explicitly testing for actimeo=0, and handling it as a
    special case.
    
    Reported-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <smfrench@gmail.com>

commit 0cf4a7d6cf23715276fcd0f1cd1cabc6a9b46942
Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
Date:   Tue Apr 15 22:27:11 2014 -0700

    ahci: disable DEVSLP for Intel Valleyview
    
    On Intel Valleyview SoC, SATA device sleep is not reliable. When
    DEVSLP is attempted on certain SSDs, port_devslp write would fail
    and result in malfunction of AHCI controller. AHCI controller may
    be not shown in PCI enumeration after reset. Complete power source
    removal may be required to recover from this failure. So we blacklist
    this device and override host device reported capabilities such that
    device LPM will only attempt slumber but not DEVSLP.
    
    Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
    Acked-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit de30a2ccb20d9baf5dac8a9c8ba8f0d9d5f4361e
Author: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Date:   Thu Apr 24 10:34:36 2014 +0300

    ASoC: Intel: Cancel hsw_notification_work before freeing the stream
    
    I suppose there is a possibility that hsw_notification_work() may run after
    sst_hsw_stream_free() which can lead to a kernel crash since struct
    sst_hsw_stream is freed at that point and
    stream = container_of(work, struct sst_hsw_stream, notify_work) is not valid
    when hsw_notification_work() is run.
    
    Reported-by: Derek Basehore <dbasehore@chromium.org>
    Reported-by: Wenkai Du <wenkai.du@intel.com>
    Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit b8909783a22b4f169ade830e0aa6dafe313426f1
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Thu Apr 24 08:25:56 2014 +0200

    ASoC: imx-audmux: Fix section mismatch
    
    audmux_debugfs_init() is marked as __init, but is called from imx_audmux_probe()
    which is not marked as __init. This creates a section mismatch and a potential
    runtime crash (if imx_audmux_probe() is called after the .init section was
    dropped). This patch removes the __init annotation from audmux_debugfs_init(),
    which fixes the following warning:
    	WARNING: sound/soc/built-in.o(.text+0x86960): Section mismatch in reference
    	from the function imx_audmux_probe() to the function
    	.init.text:audmux_debugfs_init()
    
    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit db66d756c74acb886c51f11b501c2fe622018a0a
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Fri Apr 18 01:59:15 2014 +0900

    sched/docbook: Fix 'make htmldocs' warnings caused by missing description
    
    When 'flags' argument to sched_{set,get}attr() syscalls were
    added in:
    
      6d35ab48090b ("sched: Add 'flags' argument to sched_{set,get}attr() syscalls")
    
    no description for 'flags' was added. It causes the following warnings on "make htmldocs":
    
      Warning(/kernel/sched/core.c:3645): No description found for parameter 'flags'
      Warning(/kernel/sched/core.c:3789): No description found for parameter 'flags'
    
    Signed-off-by: Masanari Iida <standby24x7@gmail.com>
    Cc: peterz@infradead.org
    Link: http://lkml.kernel.org/r/1397753955-2914-1-git-send-email-standby24x7@gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 398f5d5e10b6b917cd9d35ef21d545b0afbada22
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Fri Apr 18 14:19:53 2014 +0200

    PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
    
    MBus windows are used on Marvell platforms to map certain peripherals
    in the physical address space. In the PCIe context, MBus windows are
    needed to map PCIe I/O and memory regions in the physical address.
    
    However, those MBus windows can only have power of two sizes, while
    PCIe BAR do not necessarily guarantee this. For this reason, the
    current pci-mvebu breaks on platforms where PCIe devices have BARs
    that don't sum up to a power of two size at the emulated bridge level.
    
    This commit fixes this by allowing the pci-mvebu driver to create
    multiple contiguous MBus windows (each having a power of two size) to
    cover a given PCIe BAR.
    
    To achieve this, two functions are added: mvebu_pcie_add_windows() and
    mvebu_pcie_del_windows() to respectively add and remove all the MBus
    windows that are needed to map the provided PCIe region base and
    size. The emulated PCI bridge code now calls those functions, instead
    of directly calling the mvebu-mbus driver functions.
    
    Fixes: 45361a4fe446 ('pci: PCIe driver for Marvell Armada 370/XP systems')
    Cc: <stable@vger.kernel.org> # v3.11+
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397823593-1932-8-git-send-email-thomas.petazzoni@free-electrons.com
    Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
    Acked-by: Bjorn Helgaas <bhelgaas@google.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit b566e782be32145664d96ada3e389f17d32742e5
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Fri Apr 18 14:19:52 2014 +0200

    bus: mvebu-mbus: allow several windows with the same target/attribute
    
    Having multiple windows with the same target and attribute is actually
    legal, and can be useful for PCIe windows, when PCIe BARs have a size
    that isn't a power of two, and we therefore need to create several
    MBus windows to cover the PCIe BAR for a given PCIe interface.
    
    Fixes: fddddb52a6c4 ('bus: introduce an Marvell EBU MBus driver')
    Cc: <stable@vger.kernel.org> # v3.10+
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397823593-1932-7-git-send-email-thomas.petazzoni@free-electrons.com
    Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 09752a12f430f58523fb6f435f5e30e4048fcfb2
Author: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date:   Fri Apr 18 14:19:51 2014 +0200

    bus: mvebu-mbus: Avoid setting an undefined window size
    
    The mbus hardware requires a power of two size, and size aligned base.
    Currently, if a non-power of two is passed in to the low level routines
    they configure the register in a way that results in undefined behaviour.
    
    Call WARN and return EINVAL instead.
    
    Also, update the debugfs routines to show a message if there is an
    invalid register setting.
    
    All together this makes the recent problems with silent failure
    of PCI very obvious, noisy and debuggable.
    
    Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397823593-1932-6-git-send-email-thomas.petazzoni@free-electrons.com
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit b6d07e0273d3296cfbdc88145b8a00ddbefb310a
Author: Willy Tarreau <w@1wt.eu>
Date:   Fri Apr 18 14:19:50 2014 +0200

    PCI: mvebu: fix off-by-one in the computed size of the mbus windows
    
    mvebu_pcie_handle_membase_change() and
    mvebu_pcie_handle_iobase_change() do not correctly compute the window
    size. PCI uses an inclusive start/end address pair, which requires a
    +1 when converting to size.
    
    This only worked because a bug in the mbus driver allowed it to
    silently accept and round up bogus sizes.
    
    Fix this by adding one to the computed size.
    
    Fixes: 45361a4fe446 ('PCIe driver for Marvell Armada 370/XP systems')
    Cc: <stable@vger.kernel.org> # v3.11+
    Signed-off-by: Willy Tarreau <w@1wt.eu>
    Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397823593-1932-5-git-send-email-thomas.petazzoni@free-electrons.com
    Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
    Acked-by: Bjorn Helgaas <bhelgaas@google.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit dcf2191933c4d3b3d1fcd8b6f5818cc913baa8b2
Author: Tony Lindgren <tony@atomide.com>
Date:   Wed Apr 23 11:04:42 2014 -0700

    ARM: dts: Fix GPMC timings for LAN9220
    
    I've noticed occasional random oopsing on my gateway
    machine since I upgraded it to use device tree based
    booting. As this machine has worked reliably before
    that for a few years, pretty much the only difference
    was narrowed down to the GPMC timings. Turns out that
    for legacy based booting we are using bootloader timings
    for GPMC for smsc911x. With device tree we are passing
    the timings in the .dts file, and the device tree
    timings are not quite suitable for LAN9920.
    
    Enabling DEBUG in gpmc.c I noticed that the device tree
    configured timings are different from the the known
    working bootloader timings. So let's fix the timings to
    match the bootloader timings when looked at the gpmc
    dmesg output with DEBUG enabled.
    
    The changes were done by multiplying the bootloader
    tick values by six to get the nanosecond value for
    device tree. This is not generic from the device point
    of view as the calculations should be based on the device
    timings. Anyways, further improvments can be done based
    on the timings documentation for LAN9220. But let's first
    get things to a known good working state.
    
    Note that we still need to change the timings also for
    sb-t35 also as it has two LAN9220 instances on GPMC and
    we can currently include the generic timings only once.
    
    Also note that any boards that have LAN9221 instead of
    LAN9220 should be updated to use omap-gpmc-smsc9221.dtsi
    instead of omap-gpmc-smsc911x.dtsi. The LAN9221 timings
    are different from LAN9220 timings.
    
    Cc: Christoph Fritz <chf.fritz@googlemail.com>
    Cc: Dmitry Lifshitz <lifshitz@compulab.co.il>
    Cc: Javier Martinez Canillas <javier@dowhile0.org>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit de9949a45ec05a9cd5b98eb0a5b5a65db252f1f3
Author: Tony Lindgren <tony@atomide.com>
Date:   Wed Apr 23 11:04:30 2014 -0700

    ARM: dts: Fix GPMC Ethernet timings for omap cm-t sbc-t boards for device tree
    
    Looks like we have wrong GPMC timings we have for the cm-t and
    sbc-t boards. This can cause occasional strange errors with at
    least doing an rsync of large files or doing apt-get dist-upgrade.
    
    Let's fix the issue in two phases. First let's simplify cm-t and
    sbc-t to use the shared omap-gpmc-smsc911x.dtsi to avoid fixing
    the issue in multiple places. Then we can fix the timings in
    a single place with a follow-up patch.
    
    Cc: Dmitry Lifshitz <lifshitz@compulab.co.il>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 20f670dcc08682e478770b48bd5fe09f19351674
Author: Tony Lindgren <tony@atomide.com>
Date:   Wed Apr 23 11:04:29 2014 -0700

    ARM: dts: Fix bad OTG muxing for cm-t boards
    
    Looks like the OTG pins are off by 2 and we get this:
    
    pinctrl-single 48002030.pinmux: pin 480021a0.0 already requested by 49020000.serial; cannot claim for 480ab000.usb_otg_hs
    pinctrl-single 48002030.pinmux: pin-184 (480ab000.usb_otg_hs) status -22
    pinctrl-single 48002030.pinmux: could not request pin 184 (480021a0.0) from group pinmux_hsusb0_pins  on device pinctrl-single
    musb-omap2430 480ab000.usb_otg_hs: Error applying setting, reverse things back
    
    That's probably because the TRM lists the values as
    32-bit registers so every second needs 2 added to the
    address. The OTG pin start range must start from
    0x21a2, not 0x21a0.
    
    Cc: Dmitry Lifshitz <lifshitz@compulab.co.il>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

commit 836b31fe1a9791d84ed95783ed42ebd5719f7918
Author: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Date:   Wed Apr 23 14:59:12 2014 +0900

    ASoC: rsnd: call rsnd_dai_pointer_update() from outside of lock
    
    rsnd_soc_dai_trigger() will be called
    after rsnd_dai_pointer_update() function
    which is using rsnd_lock().
    Thus, it should be called from outside of rsnd_lock().
    Kernel will be hangup without this patch.
    Special thanks to Kataoka-san
    
    Reported-by: Ryo Kataoka <ryo.kataoka.wt@renesas.com>
    Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit d132cb0a162fa55c82e06b771fcaa871d30c9398
Author: Wenkai Du <wenkai.du@intel.com>
Date:   Wed Apr 23 13:29:30 2014 +0300

    ASoC: Intel: Fix audio crash due to race condition in stream deletion
    
    There is a race between sst_byt_stream_free() and sst_byt_get_stream()
    if sst_byt_get_stream() called from sst_byt_irq_thread() context is
    accessing the byt->stream_list while a stream is deleted from the list.
    
    A stream is added to byt->stream_list in sst_byt_stream_new() and deleted in
    sst_byt_stream_free(). sst_byt_get_stream() is always protected by
    sst->spinlock, but the stream addition and deletion are not protected.
    
    The patch adds spinlock to both stream addition and deletion.
    
    [Jarkko: Same fix added to sst-haswell-ipc.c too]
    
    Signed-off-by: Wenkai Du <wenkai.du@intel.com>
    Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
    Signed-off-by: Mark Brown <broonie@linaro.org>

commit 311ab8e1c28659e16a6fe14a68929c3ced4a5757
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Apr 16 08:32:41 2014 -0400

    mac80211: fixup radiotap tx flags for RTS/CTS
    
    When using RTS/CTS, the CTS-to-Self bit in radiotap TX flags is
    getting set instead of the RTS bit.  Set the correct one.
    
    Reported-by: Larry Maxwell <larrymaxwell@agilemesh.com>
    Signed-off-by: Bob Copeland <bob@cozybit.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 062f1d6de01df545ca0df366c6133f0fa164bff6
Author: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date:   Tue Apr 22 18:19:25 2014 +0800

    mac80211: avoid handling of SMPS for mesh
    
    The patch "mac80211: implement SMPS for AP" has caused kernel
    oops at mesh STA if the peer mesh STA operates in sleep mode
    and then becomes active mode. It can be easily reproduced by
    setting the following commands at peer mesh STA:
    
    iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode deep
    iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode active
    
    Kernel oops will happen at mesh STA aa:bb:cc:dd:ee:ff.
    
    Fix this by avoiding SMPS for mesh mode.
    
    Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

commit 79d719749d23234e9b725098aa49133f3ef7299d
Author: Aristeu Rozanski <aris@redhat.com>
Date:   Mon Apr 21 12:13:03 2014 -0400

    device_cgroup: rework device access check and exception checking
    
    Whenever a device file is opened and checked against current device
    cgroup rules, it uses the same function (may_access()) as when a new
    exception rule is added by writing devices.{allow,deny}. And in both
    cases, the algorithm is the same, doesn't matter the behavior.
    
    First problem is having device access to be considered the same as rule
    checking. Consider the following structure:
    
    	A	(default behavior: allow, exceptions disallow access)
    	 \
    	  B	(default behavior: allow, exceptions disallow access)
    
    A new exception is added to B by writing devices.deny:
    
    	c 12:34 rw
    
    When checking if that exception is allowed in may_access():
    
    	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
    		if (behavior == DEVCG_DEFAULT_ALLOW) {
    			/* the exception will deny access to certain devices */
    			return true;
    
    Which is ok, since B is not getting more privileges than A, it doesn't
    matter and the rule is accepted
    
    Now, consider it's a device file open check and the process belongs to
    cgroup B. The access will be generated as:
    
    	behavior: allow
    	exception: c 12:34 rw
    
    The very same chunk of code will allow it, even if there's an explicit
    exception telling to do otherwise.
    
    A simple test case:
    
    	# mkdir new_group
    	# cd new_group
    	# echo $$ >tasks
    	# echo "c 1:3 w" >devices.deny
    	# echo >/dev/null
    	# echo $?
    	0
    
    This is a serious bug and was introduced on
    
    	c39a2a3018f8 devcg: prepare may_access() for hierarchy support
    
    To solve this problem, the device file open function was split from the
    new exception check.
    
    Second problem is how exceptions are processed by may_access(). The
    first part of the said function tries to match fully with an existing
    exception:
    
    	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
    		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
    			continue;
    		if ((refex->type & DEV_CHAR) && !(ex->type & DEV_CHAR))
    			continue;
    		if (ex->major != ~0 && ex->major != refex->major)
    			continue;
    		if (ex->minor != ~0 && ex->minor != refex->minor)
    			continue;
    		if (refex->access & (~ex->access))
    			continue;
    		match = true;
    		break;
    	}
    
    That means the new exception should be contained into an existing one to
    be considered a match:
    
    	New exception		Existing	match?	notes
    	b 12:34 rwm		b 12:34 rwm	yes
    	b 12:34 r		b *:34 rw	yes
    	b 12:34 rw		b 12:34 w	no	extra "r"
    	b *:34 rw		b 12:34 rw	no	too broad "*"
    	b *:34 rw		b *:34 rwm	yes
    
    Which is fine in some cases. Consider:
    
    	A	(default behavior: deny, exceptions allow access)
    	 \
    	  B	(default behavior: deny, exceptions allow access)
    
    In this case the full match makes sense, the new exception cannot add
    more access than the parent allows
    
    But this doesn't always work, consider:
    
    	A	(default behavior: allow, exceptions disallow access)
    	 \
    	  B	(default behavior: deny, exceptions allow access)
    
    In this case, a new exception in B shouldn't match any of the exceptions
    in A, after all you can't allow something that was forbidden by A. But
    consider this scenario:
    
    	New exception	Existing in A	match?	outcome
    	b 12:34 rw	b 12:34 r	no	exception is accepted
    
    Because the new exception has "w" as extra, it doesn't match, so it'll
    be added to B's exception list.
    
    The same problem can happen during a file access check. Consider a
    cgroup with allow as default behavior:
    
    	Access		Exception	match?
    	b 12:34 rw	b 12:34 r	no
    
    In this case, the access didn't match any of the exceptions in the
    cgroup, which is required since exceptions will disallow access.
    
    To solve this problem, two new functions were created to match an
    exception either fully or partially. In the example above, a partial
    check will be performed and it'll produce a match since at least
    "b 12:34 r" from "b 12:34 rw" access matches.
    
    Cc: cgroups@vger.kernel.org
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Serge Hallyn <serge.hallyn@canonical.com>
    Cc: Li Zefan <lizefan@huawei.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit 1c2366298b105824e68e790bff1106e2d4ee2a30
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Mon Apr 14 10:02:26 2014 +0800

    imx-drm: imx-drm-core: skip components whose parent device is disabled
    
    In a board setup which disables LDB device node completely by changing
    status to 'disabled', and only enables HDMI device, we're running into
    the problem that imx-drm master never succeeds in binding, and hence
    HDMI does not come up either.
    
    &ldb {
    	status = "disabled";
    
    	lvds-channel@1 {
    		...
    		status = "okay";
    	};
    };
    
    The imx-drm-core should really skip the LVDS channels no matter what
    lvds-channel's status is, if LDB device is disabled.  Let's consider
    such setup a misconfiguration, give a warning in there and not add the
    component.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit c509bdc20dd255842d4e9302aad12baa7d166911
Author: Philipp Zabel <p.zabel@pengutronix.de>
Date:   Mon Apr 7 10:22:36 2014 +0200

    imx-drm: imx-drm-core: fix imx_drm_encoder_get_mux_id
    
    The decoder mux id is equal to the port id of the encoder's input port
    that is connected to the given crtc, not to the endpoint id (which is
    arbitrary and usually zero).
    
    Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
    Tested-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

commit 35d35aae817706800a4913711d563a99e1dc380a
Author: Tushar Behera <tushar.behera@linaro.org>
Date:   Thu Mar 6 11:34:43 2014 +0530

    dt-bindings: clock: Move at91.h to dt-bindigs/clock
    
    Most of the clock related dt-binding header files are located in
    dt-bindings/clock folder. It would be good to keep all the similar
    header files at a single location.
    
    Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
    CC: Rob Landley <rob@landley.net>
    CC: Andrew Victor <linux@maxim.org.za>
    CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
    Acked-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
    [nicolas.ferre@atmel.com: add new at91sam9261 & at91sam9rl]
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

commit d44db494a8d5aa2060240e7a770bbb8fefa2d2b1
Author: Bo Shen <voice.shen@atmel.com>
Date:   Tue Apr 1 15:12:43 2014 +0800

    ARM: at91: fix spi cs on sama5d3 Xplained board
    
    The PD16 is the CS3 for SPI0 while not SPI1.
    
    Signed-off-by: Bo Shen <voice.shen@atmel.com>
    Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 83596fbeb5d28e8cb8878786133945d4dc7c0090
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Mon Apr 14 19:39:53 2014 +0200

    spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
    
    The availability of SPI Dual or Quad Transfer Mode as indicated by the
    "spi-tx-bus-width" and "spi-rx-bus-width" properties in the device tree is
    a hardware property of the SPI master, SPI slave, and board wiring.  Hence
    the SPI core should not reject an SPI slave because an SPI master driver
    doesn't (yet) support Dual or Quad Transfer Mode.
    
    Change the lack of Dual or Quad Transfer Mode support in the SPI master
    driver from an error condition to a warning condition, and ignore the
    unsupported mode bits, falling back to Single Transfer Mode, to avoid
    breakages when running old kernels with new device trees.
    
    Fixes: f477b7fb13df (spi: DUAL and QUAD support)
    Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Signed-off-by: Mark Brown <broonie@linaro.org>
    Cc: stable@vger.kernel.org

commit 77668c8b559e4fe2acf2a0749c7c83cde49a5025
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri Apr 18 11:04:16 2014 -0400

    workqueue: fix a possible race condition between rescuer and pwq-release
    
    There is a race condition between rescuer_thread() and
    pwq_unbound_release_workfn().
    
    Even after a pwq is scheduled for rescue, the associated work items
    may be consumed by any worker.  If all of them are consumed before the
    rescuer gets to them and the pwq's base ref was put due to attribute
    change, the pwq may be released while still being linked on
    @wq->maydays list making the rescuer dereference already freed pwq
    later.
    
    Make send_mayday() pin the target pwq until the rescuer is done with
    it.
    
    tj: Updated comment and patch description.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org # v3.10+

commit 4d595b866d2c653dc90a492b9973a834eabfa354
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri Apr 18 11:04:16 2014 -0400

    workqueue: make rescuer_thread() empty wq->maydays list before exiting
    
    After a @pwq is scheduled for emergency execution, other workers may
    consume the affectd work items before the rescuer gets to them.  This
    means that a workqueue many have pwqs queued on @wq->maydays list
    while not having any work item pending or in-flight.  If
    destroy_workqueue() executes in such condition, the rescuer may exit
    without emptying @wq->maydays.
    
    This currently doesn't cause any actual harm.  destroy_workqueue() can
    safely destroy all the involved data structures whether @wq->maydays
    is populated or not as nobody access the list once the rescuer exits.
    
    However, this is nasty and makes future development difficult.  Let's
    update rescuer_thread() so that it empties @wq->maydays after seeing
    should_stop to guarantee that the list is empty on rescuer exit.
    
    tj: Updated comment and patch description.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org # v3.10+

commit e37a06f10994c2ba86f54d8f96734f2483a869b8
Author: Li Zefan <lizefan@huawei.com>
Date:   Thu Apr 17 13:53:08 2014 +0800

    cgroup: fix the retry path of cgroup_mount()
    
    If we hit the retry path, we'll call parse_cgroupfs_options() again,
    but the string we pass to it has been modified by the previous call
    to this function.
    
    This bug can be observed by:
    
      # mount -t cgroup -o name=foo,cpuset xxx /mnt && umount /mnt && \
        mount -t cgroup -o name=foo,cpuset xxx /mnt
      mount: wrong fs type, bad option, bad superblock on xxx,
             missing codepage or helper program, or other error
      ...
    
    The second mount passed "name=foo,cpuset" to the parser, and then it
    hit the retry path and call the parser again, but this time the string
    passed to the parser is "name=foo".
    
    To fix this, we avoid calling parse_cgroupfs_options() again in this
    case.
    
    Signed-off-by: Li Zefan <lizefan@huawei.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

commit 4ccc402ece35695dd2884ec0b652d52ae0230f13
Author: Thierry Reding <treding@nvidia.com>
Date:   Fri Apr 4 15:55:15 2014 +0200

    clk: tegra: Fix enabling of PLLE
    
    When enabling the PLLE as its final step, clk_plle_enable() would
    accidentally OR in the value previously written to the PLLE_SS_CTRL
    register.
    
    Signed-off-by: Thierry Reding <treding@nvidia.com>

commit c61e4e75b95bda4c6fec134aa9f08b5629b532e6
Author: Thierry Reding <treding@nvidia.com>
Date:   Fri Apr 4 15:55:14 2014 +0200

    clk: tegra: Introduce divider mask and shift helpers
    
    Add div{m,n,p}_shift() and div{m,n,p}_mask_shifted() helpers to make the
    code that modifies the m-, n- and p-divider fields of PLLs shorter and
    easier to read.
    
    Signed-off-by: Thierry Reding <treding@nvidia.com>

commit d0f02ce3b1685ef6ffe43692034599790f83e7ab
Author: Thierry Reding <treding@nvidia.com>
Date:   Fri Apr 4 15:55:13 2014 +0200

    clk: tegra: Fix PLLE programming
    
    PLLE has M, N and P divider shift and width parameters that differ from
    the defaults. Furthermore, when clearing the M, N and P divider fields
    the corresponding masks were never shifted, thereby clearing only the
    lowest bits of the register. This lead to a situation where the PLLE
    programming would only work if the register hadn't been touched before.
    
    Signed-off-by: Thierry Reding <treding@nvidia.com>
    Acked-by: Stephen Warren <swarren@nvidia.com>

commit 1cc9d48145b81e307fab94a5cf6ee66ec2f0de60
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Sun Apr 13 16:39:38 2014 +0200

    ARM: orion5x: fix target ID for crypto SRAM window
    
    In commit 4ca2c04085a1caa903e92a5fc0da25362150aac2 ('ARM: orion5x:
    Move to ID based window creation'), the mach-orion5x code was changed
    to use the new mvebu-mbus API. However, in the process, a mistake was
    made on the crypto SRAM window target ID: it should have been 0x9
    (verified in the datasheet) and not 0x0.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Link: https://lkml.kernel.org/r/1397400006-4315-2-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: 4ca2c04085a1 ('ARM: orion5x: Move to ID based window creation')
    Cc: stable@vger.kernel.org # v3.12+
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit ce965c3d2e68c5325dd5624eb101d70423022fef
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Mon Apr 14 17:29:18 2014 +0200

    memory: mvebu-devbus: fix the conversion of the bus width
    
    According to the Armada 370 and Armada XP datasheets, the part of the
    Device Bus register that configure the bus width should contain 0 for
    a 8 bits bus width, and 1 for a 16 bits bus width (other values are
    unsupported/reserved).
    
    However, the current conversion done in the driver to convert from a
    bus width in bits to the value expected by the register leads to
    setting the register to 1 for a 8 bits bus, and 2 for a 16 bits bus.
    
    This mistake was compensated by a mistake in the existing Device Tree
    files for Armada 370/XP platforms: they were declaring a 8 bits bus
    width, while the hardware in fact uses a 16 bits bus width.
    
    This commit fixes that by adjusting the conversion logic.
    
    This patch fixes a bug that was introduced in
    3edad321b1bd2e6c8b5f38146c115c8982438f06 ('drivers: memory: Introduce
    Marvell EBU Device Bus driver'), which was merged in v3.11.
    
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Link: https://lkml.kernel.org/r/1397489361-5833-2-git-send-email-thomas.petazzoni@free-electrons.com
    Fixes: 3edad321b1bd ('drivers: memory: Introduce Marvell EBU Device Bus driver')
    Cc: stable@vger.kernel.org # v3.11+
    Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

commit 8845cc6415ec28ef8d57b3fb81c75ef9bce69c5f
Author: Antti Palosaari <crope@iki.fi>
Date:   Thu Apr 10 21:18:16 2014 -0300

    [media] fc2580: fix tuning failure on 32-bit arch
    
    There was some frequency calculation overflows which caused tuning
    failure on 32-bit architecture. Use 64-bit numbers where needed in
    order to avoid calculation overflows.
    
    Thanks for the Finnish person, who asked remain anonymous, reporting,
    testing and suggesting the fix.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 77f300b198f93328c26191b52655ce1b62e202cf
Author: Daeseok Youn <daeseok.youn@gmail.com>
Date:   Wed Apr 16 14:32:29 2014 +0900

    workqueue: fix bugs in wq_update_unbound_numa() failure path
    
    wq_update_unbound_numa() failure path has the following two bugs.
    
    - alloc_unbound_pwq() is called without holding wq->mutex; however, if
      the allocation fails, it jumps to out_unlock which tries to unlock
      wq->mutex.
    
    - The function should switch to dfl_pwq on failure but didn't do so
      after alloc_unbound_pwq() failure.
    
    Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
    alloc_unbound_pwq() failure.
    
    Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
    Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org
    Fixes: 4c16bd327c74 ("workqueue: implement NUMA affinity for unbound workqueues")

commit a32452366b7250c42e96a18ffc3ad8db9e0ca3c2
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Wed Apr 16 09:01:03 2014 +0200

    vti4: Don't count header length twice.
    
    We currently count the size of LL_MAX_HEADER and struct iphdr
    twice for vti4 devices, this leads to a wrong device mtu.
    The size of LL_MAX_HEADER and struct iphdr is already counted in
    ip_tunnel_bind_dev(), so don't do it again in vti_tunnel_init().
    
    Fixes: b9959fd3 ("vti: switch to new ip tunnel code")
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

commit 877ed143065c3b823cfe54b5a695c6be3659e445
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Apr 11 04:15:32 2014 -0300

    [media] Prefer gspca_sonixb over sn9c102 for all devices
    
    The sn9c102 driver is deprecated. It was moved to staging in
    anticipation of its removal in a future kernel version. However, USB
    devices 0C45:6024 and 0C45:6025 are still handled by sn9c102 when
    both sn9c102 and gspca_sonixb are enabled.
    
    We must migrate all the users of these devices to the gspca_sonixb
    driver now, so that it gets sufficient testing before the sn9c102
    driver is finally phased out.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Acked-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit c1d1e40b8bbd712d6a8c74d8278178c8448b7abc
Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Sun Mar 23 02:44:11 2014 -0300

    [media] media: davinci: vpfe: make sure all the buffers unmapped and released
    
    this patch makes sure that it terminates if any IO in
    progress and also makes sure that all the buffers are unmapped.
    It was observed that with several runs of application the application
    sometimes failed to allocate memory, This patch makes sure it
    all the buffers are released.
    
    Using kmemleak it was found that buffer were not released, this patch
    fixes following issue,
    
     echo scan > /sys/kernel/debug/kmemleak
      Kernel message reads:
          memleak: 3 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
    
    Then,
         cat /sys/kernel/debug/kmemleak
    
      unreferenced object 0xc564a480 (size 192):
      comm "mttest", pid 764, jiffies 4294945878 (age 487.160s)
      hex dump (first 32 bytes):
        00 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
        00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
      backtrace:
        [<c00a98dc>] create_object+0x10c/0x28c
        [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
        [<c00a67c0>] __kmalloc+0x11c/0x1d4
        [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
        [<c02b6194>] videobuf_alloc_vb+0x38/0x80
        [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
        [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
        [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
        [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
        [<c02aae90>] v4l_reqbufs+0x50/0x54
        [<c02aab54>] __video_do_ioctl+0x260/0x2c4
        [<c02a9dd4>] video_usercopy+0xf0/0x310
        [<c02aa008>] video_ioctl2+0x14/0x1c
        [<c02a562c>] v4l2_ioctl+0x104/0x14c
        [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
        [<c00bd5b4>] SyS_ioctl+0x44/0x64
    unreferenced object 0xc564ac00 (size 192):
      comm "mttest", pid 764, jiffies 4294945878 (age 487.160s)
      hex dump (first 32 bytes):
        01 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
        00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
      backtrace:
        [<c00a98dc>] create_object+0x10c/0x28c
        [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
        [<c00a67c0>] __kmalloc+0x11c/0x1d4
        [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
        [<c02b6194>] videobuf_alloc_vb+0x38/0x80
        [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
        [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
        [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
        [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
        [<c02aae90>] v4l_reqbufs+0x50/0x54
        [<c02aab54>] __video_do_ioctl+0x260/0x2c4
        [<c02a9dd4>] video_usercopy+0xf0/0x310
        [<c02aa008>] video_ioctl2+0x14/0x1c
        [<c02a562c>] v4l2_ioctl+0x104/0x14c
        [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
        [<c00bd5b4>] SyS_ioctl+0x44/0x64
    unreferenced object 0xc564a180 (size 192):
      comm "mttest", pid 764, jiffies 4294945880 (age 487.140s)
      hex dump (first 32 bytes):
        02 00 00 00 28 07 07 20 d0 02 00 00 e0 01 00 00  ....(.. ........
        00 00 00 00 00 64 05 00 01 00 00 00 01 00 00 00  .....d..........
      backtrace:
        [<c00a98dc>] create_object+0x10c/0x28c
        [<c03ba8ec>] kmemleak_alloc+0x3c/0x70
        [<c00a67c0>] __kmalloc+0x11c/0x1d4
        [<c02b6f48>] __videobuf_alloc+0x1c/0x3c
        [<c02b6194>] videobuf_alloc_vb+0x38/0x80
        [<c02b6638>] __videobuf_mmap_setup+0x9c/0x108
        [<c02b6da0>] videobuf_reqbufs.part.10+0x12c/0x1bc
        [<c02b6e9c>] videobuf_reqbufs+0x6c/0x8c
        [<c02be2c4>] vpfe_reqbufs+0xcc/0x130
        [<c02aae90>] v4l_reqbufs+0x50/0x54
        [<c02aab54>] __video_do_ioctl+0x260/0x2c4
        [<c02a9dd4>] video_usercopy+0xf0/0x310
        [<c02aa008>] video_ioctl2+0x14/0x1c
        [<c02a562c>] v4l2_ioctl+0x104/0x14c
        [<c00bd320>] do_vfs_ioctl+0x80/0x2d0
        [<c00bd5b4>] SyS_ioctl+0x44/0x64
    
    Reported-by: Jimmy Ho <jimmygge@gmail.com>
    Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit d891ae5ef1efda590569b4483664c64b4aca4a4d
Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Sun Mar 23 02:16:46 2014 -0300

    [media] staging: media: davinci: vpfe: make sure all the buffers are released
    
    from commit-id: b3379c6201bb3555298cdbf0aa004af260f2a6a4
    "vb2: only call start_streaming if sufficient buffers are queued"
    the vb2 framework warns on (WARN_ON()) if all the active buffers
    are not released when streaming is stopped, initially the vb2 silently
    released the buffer internally if the buffer was not released by
    the driver.
    
    This patch fixes following issue:
    
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpfe_video Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
    [<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpfe_release+0x60/0x230)
    [<c025a65c>] (vpfe_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a1 ]---
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x1e0/0x224()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpfe_video Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
    [<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
    [<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpfe_release+0x60/0x230)
    [<c025a65c>] (vpfe_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a2 ]---
    
    Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit b699f09d0d003cc1622aec30d81f3158da6790aa
Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Sat Mar 22 08:03:09 2014 -0300

    [media] media: davinci: vpbe_display: fix releasing of active buffers
    
    from commit-id: b3379c6201bb3555298cdbf0aa004af260f2a6a4
    "vb2: only call start_streaming if sufficient buffers are queued"
    the vb2 framework warns on (WARN_ON()) if all the active buffers
    are not released when streaming is stopped, initially the vb2 silently
    released the buffer internally if the buffer was not released by
    the driver.
    This patch fixes following issue:
    
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpbe_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
    [<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpbe_display_release+0x60/0x230)
    [<c025a65c>] (vpbe_display_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a1 ]---
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x1e0/0x224()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpbe_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
    [<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
    [<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpbe_display_release+0x60/0x230)
    [<c025a65c>] (vpbe_display_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a2 ]---
    
    Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 18c7adcf2c1abf7f554a52f57bee126995791748
Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Sat Mar 22 08:03:08 2014 -0300

    [media] media: davinci: vpif_display: fix releasing of active buffers
    
    from commit-id: b3379c6201bb3555298cdbf0aa004af260f2a6a4
    "vb2: only call start_streaming if sufficient buffers are queued"
    the vb2 framework warns on (WARN_ON()) if all the active buffers
    are not released when streaming is stopped, initially the vb2 silently
    released the buffer internally if the buffer was not released by
    the driver.
    Also this patch moves the disabling of interrupts from relase() callback
    to stop_streaming() callback as which needs to be done ideally.
    
    This patch fixes following issue:
    
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpif_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
    [<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
    [<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a1 ]---
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x1e0/0x224()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpif_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
    [<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
    [<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
    [<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a2 ]---
    
    Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit e6ba3db1049548df10f90234328441b2873a4bd3
Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Sat Mar 22 08:03:07 2014 -0300

    [media] media: davinci: vpif_capture: fix releasing of active buffers
    
    from commit-id: b3379c6201bb3555298cdbf0aa004af260f2a6a4
    "vb2: only call start_streaming if sufficient buffers are queued"
    the vb2 framework warns on (WARN_ON()) if all the active buffers
    are not released when streaming is stopped, initially the vb2 silently
    released the buffer internally if the buffer was not released by
    the driver.
    Also this patch moves the disabling of interrupts from relase() callback
    to stop_streaming() callback as which needs to be done ideally.
    
    This patch fixes following issue:
    
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpif_capture Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
    [<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
    [<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a1 ]---
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x1e0/0x224()
    Modules linked in:
    CPU: 0 PID: 2049 Comm: vpif_capture Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
    [<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
    [<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
    [<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
    [<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
    [<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
    [<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
    [<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
    [<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
    [<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
    [<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
    [<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
    [<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
    [<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
    [<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
    [<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
    [<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
    ---[ end trace 5faa75e8c2f8a6a2 ]---
    
    Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit e3fadbdf1cbac7164aaefae5fb331cba86255c46
Author: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date:   Tue Mar 25 17:50:11 2014 -0300

    [media] s5p-fimc: Fix YUV422P depth
    
    All YUV 422 has 16bit per pixels.
    
    Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 41f484d12c0105ce01ea79acdc094fff9124491b
Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date:   Tue Apr 8 10:05:03 2014 -0300

    [media] s5c73m3: Add missing rename of v4l2_of_get_next_endpoint() function
    
    This fixes following build error:
    
      CC      drivers/media/i2c/s5c73m3/s5c73m3-core.o
      CC      drivers/md/dm-ioctl.o
      CC      net/ipv4/inet_lro.o
    drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_get_platform_data’:
    drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function ‘v4l2_of_get_next_endpoint’ [-Werror=implicit-function-declaration]
    drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]
    
    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit beab1b530efa46164fbec3dc9b779cc7739b4f2c
Author: Antti Palosaari <crope@iki.fi>
Date:   Wed Apr 9 18:08:37 2014 -0300

    [media] rtl28xxu: silence error log about disabled rtl2832_sdr module
    
    It printed a little bit too heavy looking error log "DVB: Unable to
    find symbol rtl2832_sdr_attach()" when staging module was disabled.
    Silence that error by introducing own version of dvb_attach() macro
    without the error logging.
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 1fd10f98d9abcde090b77cfa82c3f32f159e2d94
Author: Antti Palosaari <crope@iki.fi>
Date:   Wed Apr 9 12:42:35 2014 -0300

    [media] rtl28xxu: do not hard depend on staging SDR module
    
    RTL2832 SDR extension module is currently on staging. SDR module
    headers were included from staging causing direct dependency staging
    directory. As a solution, add needed headers to main driver.
    Motivation of that change comes from Luis / driver backports project.
    
    Reported-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
    Cc: backports@vger.kernel.org
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da
Author: Jianyu Zhan <nasa4836@gmail.com>
Date:   Mon Apr 14 13:47:40 2014 +0800

    percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
    
    pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
    	BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long)
    
    It hardly could be ever bigger than PAGE_SIZE even for large-scale machine,
    but for consistency with its couterpart pcpu_mem_zalloc(),
    use pcpu_mem_free() instead.
    
    Commit b4916cb17c26 ("percpu: make pcpu_free_chunk() use
    pcpu_mem_free() instead of kfree()") addressed this problem, but
    missed this one.
    
    tj: commit message updated
    
    Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Fixes: 099a19d91ca4 ("percpu: allow limited allocation before slab is online)
    Cc: stable@vger.kernel.org

commit 277a163c83d7ba93fba1e8980d29a9f8bfcfba6c
Merge: a83b93a c9eaa44
Author: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date:   Mon Apr 14 12:00:36 2014 -0300

    Merge tag 'v3.15-rc1' into patchwork
    
    Linux 3.15-rc1
    
    * tag 'v3.15-rc1': (12180 commits)
      Linux 3.15-rc1
      mm: Initialize error in shmem_file_aio_read()
      cifs: Use min_t() when comparing "size_t" and "unsigned long"
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue
      powerpc: Don't try to set LPCR unless we're in hypervisor mode
      futex: update documentation for ordering guarantees
      ceph: fix pr_fmt() redefinition
      vti: don't allow to add the same tunnel twice
      gre: don't allow to add the same tunnel twice
      drivers: net: xen-netfront: fix array initialization bug
      missing bits of "splice: fix racy pipe->buffers uses"
      cifs: fix the race in cifs_writev()
      ceph_sync_{,direct_}write: fix an oops on ceph_osdc_new_request() failure
      pktgen: be friendly to LLTX devices
      r8152: check RTL8152_UNPLUG
      net: sun4i-emac: add promiscuous support
      net/apne: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
      blackfin: cleanup board files
      bf609: clock: drop unused clock bit set/clear functions
      Blackfin: bf537: rename "CONFIG_ADT75"
      ...

commit 04ebcb5405105d9b9bd9633d74e87e0979bddc55
Author: Emilio López <emilio@elopez.com.ar>
Date:   Wed Mar 19 15:19:31 2014 -0300

    ARM: sun7i: fix PLL4 clock and add PLL8
    
    Allwinner reworked the PLL4 clock in sun7i; so we need to change the
    compatible. Additionally, PLL8 is compatible with this new PLL4
    implementation, so let's add a node for it as well.
    
    Signed-off-by: Emilio López <emilio@elopez.com.ar>
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

commit ef67f18dece707eb2fb1ef25ccca47062842dc4a
Author: Alexander Bondar <alexander.bondar@intel.com>
Date:   Sun Mar 30 10:47:08 2014 +0300

    iwlwifi: mvm: several fixes in scan
    
    The firmware doesn't handle properly the fragmented scan.
    Stop using it.
    While at it change max_out_time and suspend_time units from
    usec to TUs as expected by firmware API.
    
    Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5596732fa8c14139018ecda8356eabbfb599d830
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Mon Apr 7 08:08:52 2014 +0200

    xfrm: Fix crash with ipv6 IPsec tunnel and NAT.
    
    The ipv6 xfrm output path is not aware that packets can be
    rerouted by NAT to not use IPsec. We crash in this case
    because we expect to have a xfrm state at the dst_entry.
    This crash happens if the ipv6 layer does IPsec and NAT
    or if we have an interfamily IPsec tunnel with ipv4 NAT.
    
    We fix this by checking for a NAT rerouted packet in each
    address family and dst_output() to the new destination
    in this case.
    
    Reported-by: Martin Pelikan <martin.pelikan@gmail.com>
    Tested-by: Martin Pelikan <martin.pelikan@gmail.com>
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree


--===============2465098445983478595==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2465098445983478595==--
