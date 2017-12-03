Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33293 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbdLCVug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:50:36 -0500
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH] treewide: remove duplicate includes
Date: Mon,  4 Dec 2017 03:19:39 +0530
Message-Id: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: gregkh@linuxfoundation.org, davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: pravin.shedge4linux@gmail.com

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Unit Testing:

- build successful
- LTP testsuite passes.
- checkpatch.pl passes

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 arch/arm/crypto/aes-ce-glue.c                               | 1 -
 arch/arm/mach-sa1100/hackkit.c                              | 1 -
 arch/arm/mm/mmu.c                                           | 2 --
 arch/arm/xen/mm.c                                           | 1 -
 arch/arm64/kernel/armv8_deprecated.c                        | 1 -
 arch/arm64/kernel/fpsimd.c                                  | 1 -
 arch/blackfin/kernel/irqchip.c                              | 1 -
 arch/blackfin/mach-common/ints-priority.c                   | 1 -
 arch/mips/mm/init.c                                         | 2 --
 arch/nios2/mm/fault.c                                       | 1 -
 arch/parisc/kernel/unwind.c                                 | 1 -
 arch/parisc/lib/delay.c                                     | 2 --
 arch/powerpc/kernel/time.c                                  | 2 --
 arch/powerpc/lib/code-patching.c                            | 1 -
 arch/powerpc/mm/numa.c                                      | 1 -
 arch/powerpc/platforms/powernv/npu-dma.c                    | 1 -
 arch/powerpc/platforms/powernv/opal.c                       | 1 -
 arch/s390/kernel/kprobes.c                                  | 1 -
 arch/sh/boards/mach-dreamcast/irq.c                         | 1 -
 arch/sparc/kernel/uprobes.c                                 | 1 -
 arch/tile/kernel/single_step.c                              | 1 -
 arch/tile/kernel/unaligned.c                                | 1 -
 arch/x86/kernel/itmt.c                                      | 1 -
 arch/x86/kernel/process.c                                   | 1 -
 arch/x86/kernel/setup.c                                     | 1 -
 arch/x86/kernel/smpboot.c                                   | 1 -
 arch/x86/platform/efi/efi_64.c                              | 1 -
 arch/x86/xen/spinlock.c                                     | 2 --
 drivers/bus/qcom-ebi2.c                                     | 1 -
 drivers/crypto/bcm/cipher.c                                 | 1 -
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c                | 1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c                  | 1 -
 drivers/gpio/gpio-brcmstb.c                                 | 1 -
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                       | 1 -
 drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c                       | 1 -
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c                       | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c    | 1 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 3 ---
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c       | 1 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c   | 1 -
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c     | 1 -
 drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c            | 1 -
 drivers/gpu/drm/bridge/panel.c                              | 1 -
 drivers/gpu/drm/drm_drv.c                                   | 1 -
 drivers/gpu/drm/i915/intel_dsi_vbt.c                        | 1 -
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv04.c              | 2 --
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c       | 1 -
 drivers/hwtracing/coresight/coresight-etb10.c               | 1 -
 drivers/iio/gyro/bmg160_core.c                              | 1 -
 drivers/infiniband/core/mad.c                               | 1 -
 drivers/infiniband/core/netlink.c                           | 2 --
 drivers/infiniband/hw/mlx5/main.c                           | 4 +---
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c                | 1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c                | 1 -
 drivers/input/rmi4/rmi_f34.c                                | 1 -
 drivers/media/platform/pxa_camera.c                         | 1 -
 drivers/media/platform/ti-vpe/cal.c                         | 3 ---
 drivers/media/v4l2-core/v4l2-mc.c                           | 2 --
 drivers/mfd/intel_soc_pmic_core.c                           | 1 -
 drivers/mfd/max77843.c                                      | 1 -
 drivers/misc/genwqe/card_base.c                             | 1 -
 drivers/misc/genwqe/card_ddcb.c                             | 1 -
 drivers/misc/genwqe/card_utils.c                            | 2 --
 drivers/mmc/host/android-goldfish.c                         | 2 --
 drivers/net/dsa/bcm_sf2.c                                   | 1 -
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c           | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c             | 1 -
 drivers/net/ethernet/freescale/gianfar.c                    | 2 --
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                   | 1 -
 drivers/net/usb/lan78xx.c                                   | 1 -
 drivers/net/wireless/ath/ath10k/mac.c                       | 1 -
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                   | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c        | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c        | 1 -
 drivers/pnp/quirks.c                                        | 2 --
 drivers/rpmsg/qcom_glink_smem.c                             | 2 --
 drivers/s390/block/dasd_diag.c                              | 1 -
 drivers/s390/net/qeth_l2_main.c                             | 1 -
 drivers/scsi/qla2xxx/qla_nx2.c                              | 2 --
 drivers/staging/ccree/ssi_buffer_mgr.c                      | 1 -
 drivers/staging/ccree/ssi_driver.c                          | 1 -
 drivers/staging/irda/drivers/pxaficp_ir.c                   | 1 -
 drivers/thermal/of-thermal.c                                | 1 -
 drivers/usb/typec/fusb302/fusb302.c                         | 1 -
 fs/block_dev.c                                              | 1 -
 fs/btrfs/super.c                                            | 1 -
 fs/cachefiles/namei.c                                       | 1 -
 fs/xfs/scrub/scrub.c                                        | 1 -
 fs/xfs/scrub/trace.c                                        | 1 -
 fs/xfs/xfs_reflink.c                                        | 2 --
 fs/xfs/xfs_trace.c                                          | 1 -
 kernel/audit.c                                              | 1 -
 kernel/locking/locktorture.c                                | 1 -
 kernel/sysctl.c                                             | 1 -
 kernel/time/ntp.c                                           | 1 -
 mm/userfaultfd.c                                            | 1 -
 net/core/netprio_cgroup.c                                   | 1 -
 net/dsa/slave.c                                             | 1 -
 net/netfilter/nf_conntrack_netlink.c                        | 1 -
 net/sched/act_meta_mark.c                                   | 1 -
 net/sched/act_meta_skbtcindex.c                             | 1 -
 net/sched/cls_api.c                                         | 1 -
 net/sched/cls_u32.c                                         | 1 -
 samples/bpf/bpf_load.c                                      | 1 -
 samples/bpf/sampleip_user.c                                 | 1 -
 samples/bpf/test_current_task_under_cgroup_user.c           | 1 -
 samples/sockmap/sockmap_user.c                              | 1 -
 security/apparmor/apparmorfs.c                              | 1 -
 sound/soc/hisilicon/hi6210-i2s.c                            | 1 -
 sound/soc/zte/zx-i2s.c                                      | 3 ---
 tools/perf/bench/futex-hash.c                               | 1 -
 tools/perf/builtin-c2c.c                                    | 3 ---
 tools/perf/builtin-record.c                                 | 1 -
 tools/perf/builtin-stat.c                                   | 1 -
 tools/perf/tests/parse-events.c                             | 1 -
 tools/perf/util/auxtrace.c                                  | 3 ---
 tools/perf/util/header.c                                    | 2 --
 tools/perf/util/metricgroup.c                               | 2 --
 tools/perf/util/scripting-engines/trace-event-python.c      | 1 -
 tools/testing/selftests/gpio/gpio-mockup-chardev.c          | 1 -
 tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c | 1 -
 tools/testing/selftests/powerpc/tm/tm-vmx-unavail.c         | 1 -
 tools/testing/selftests/timers/skew_consistency.c           | 1 -
 tools/testing/selftests/x86/mpx-dig.c                       | 2 --
 tools/testing/selftests/x86/mpx-mini-test.c                 | 4 ----
 tools/testing/selftests/x86/unwind_vdso.c                   | 1 -
 127 files changed, 2 insertions(+), 161 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index d0a9cec..5affb84 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,7 +10,6 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/hwcap.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
diff --git a/arch/arm/mach-sa1100/hackkit.c b/arch/arm/mach-sa1100/hackkit.c
index 643d5f2..0016d25 100644
--- a/arch/arm/mach-sa1100/hackkit.c
+++ b/arch/arm/mach-sa1100/hackkit.c
@@ -22,7 +22,6 @@
 #include <linux/serial_core.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
-#include <linux/tty.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e46a6a4..56d265e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -23,7 +23,6 @@
 #include <asm/sections.h>
 #include <asm/cachetype.h>
 #include <asm/fixmap.h>
-#include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
 #include <asm/tlb.h>
@@ -36,7 +35,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/pci.h>
-#include <asm/fixmap.h>
 
 #include "fault.h"
 #include "mm.h"
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index 785d2a5..8ba803b 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -8,7 +8,6 @@
 #include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/swiotlb.h>
 
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index c33b5e4..6c25b8a 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -21,7 +21,6 @@
 #include <asm/traps.h>
 #include <asm/kprobes.h>
 #include <linux/uaccess.h>
-#include <asm/cpufeature.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace-events-emulation.h"
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5084e69..2f822dc2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -31,7 +31,6 @@
 #include <linux/percpu.h>
 #include <linux/prctl.h>
 #include <linux/preempt.h>
-#include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 052cde5..39a5a7d 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -11,7 +11,6 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/seq_file.h>
 #include <asm/irq_handler.h>
 #include <asm/trace.h>
 #include <asm/pda.h>
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index e81a5b7..50cc3ef 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -26,7 +26,6 @@
 #include <asm/blackfin.h>
 #include <asm/irq_handler.h>
 #include <asm/dpmc.h>
-#include <asm/traps.h>
 #include <asm/gpio.h>
 
 /*
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 84b7b59..400676c 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -30,7 +30,6 @@
 #include <linux/hardirq.h>
 #include <linux/gfp.h>
 #include <linux/kcore.h>
-#include <linux/export.h>
 #include <linux/initrd.h>
 
 #include <asm/asm-offsets.h>
@@ -46,7 +45,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
-#include <asm/maar.h>
 
 /*
  * We have up to 8 empty zeroed pages so we can map one of the right colour
diff --git a/arch/nios2/mm/fault.c b/arch/nios2/mm/fault.c
index b804dd0..e32e3e9 100644
--- a/arch/nios2/mm/fault.c
+++ b/arch/nios2/mm/fault.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/extable.h>
 #include <linux/uaccess.h>
-#include <linux/ptrace.h>
 
 #include <asm/mmu_context.h>
 #include <asm/traps.h>
diff --git a/arch/parisc/kernel/unwind.c b/arch/parisc/kernel/unwind.c
index 5a65798..143f90e 100644
--- a/arch/parisc/kernel/unwind.c
+++ b/arch/parisc/kernel/unwind.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/kallsyms.h>
 #include <linux/sort.h>
-#include <linux/sched.h>
 
 #include <linux/uaccess.h>
 #include <asm/assembly.h>
diff --git a/arch/parisc/lib/delay.c b/arch/parisc/lib/delay.c
index 7eab4bb..66e5065 100644
--- a/arch/parisc/lib/delay.c
+++ b/arch/parisc/lib/delay.c
@@ -16,9 +16,7 @@
 #include <linux/preempt.h>
 #include <linux/init.h>
 
-#include <asm/processor.h>
 #include <asm/delay.h>
-
 #include <asm/special_insns.h>    /* for mfctl() */
 #include <asm/processor.h> /* for boot_cpu_data */
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index fe6f3a2..64d0b80 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -57,7 +57,6 @@
 #include <linux/irq_work.h>
 #include <linux/clk-provider.h>
 #include <linux/suspend.h>
-#include <linux/rtc.h>
 #include <linux/sched/cputime.h>
 #include <linux/processor.h>
 #include <asm/trace.h>
@@ -78,7 +77,6 @@
 
 /* powerpc clocksource/clockevent code */
 
-#include <linux/clockchips.h>
 #include <linux/timekeeper_internal.h>
 
 static u64 rtc_read(struct clocksource *);
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index d469224..5f7e5ed 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -15,7 +15,6 @@
 #include <linux/cpuhotplug.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
-#include <linux/kprobes.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index adb6364f..fa4b3af 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -33,7 +33,6 @@
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
-#include <asm/cputhreads.h>
 #include <asm/topology.h>
 #include <asm/firmware.h>
 #include <asm/paca.h>
diff --git a/arch/powerpc/platforms/powernv/npu-dma.c b/arch/powerpc/platforms/powernv/npu-dma.c
index f6cbc1a..e35b4fc 100644
--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -26,7 +26,6 @@
 #include <asm/iommu.h>
 #include <asm/pnv-pci.h>
 #include <asm/msi_bitmap.h>
-#include <asm/opal.h>
 
 #include "powernv.h"
 #include "pci.h"
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 041ddbd..e00c1c6 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -26,7 +26,6 @@
 #include <linux/memblock.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <linux/printk.h>
 #include <linux/kmsg_dump.h>
 #include <linux/console.h>
 #include <linux/sched/debug.h>
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index af3722c..943d13e 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -20,7 +20,6 @@
 #include <linux/ftrace.h>
 #include <asm/set_memory.h>
 #include <asm/sections.h>
-#include <linux/uaccess.h>
 #include <asm/dis.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe);
diff --git a/arch/sh/boards/mach-dreamcast/irq.c b/arch/sh/boards/mach-dreamcast/irq.c
index 2789647..69fa91c 100644
--- a/arch/sh/boards/mach-dreamcast/irq.c
+++ b/arch/sh/boards/mach-dreamcast/irq.c
@@ -10,7 +10,6 @@
  */
 #include <linux/irq.h>
 #include <linux/io.h>
-#include <linux/irq.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <mach/sysasic.h>
diff --git a/arch/sparc/kernel/uprobes.c b/arch/sparc/kernel/uprobes.c
index d852ae5..c44bf5b 100644
--- a/arch/sparc/kernel/uprobes.c
+++ b/arch/sparc/kernel/uprobes.c
@@ -29,7 +29,6 @@
 #include <linux/kdebug.h>
 
 #include <asm/cacheflush.h>
-#include <linux/uaccess.h>
 
 /* Compute the address of the breakpoint instruction and return it.
  *
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index de3eae8..93579c5 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -25,7 +25,6 @@
 #include <linux/prctl.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
-#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 #include <arch/abi.h>
 #include <arch/spr_def.h>
diff --git a/arch/tile/kernel/unaligned.c b/arch/tile/kernel/unaligned.c
index 8149c38..dc4b242 100644
--- a/arch/tile/kernel/unaligned.c
+++ b/arch/tile/kernel/unaligned.c
@@ -29,7 +29,6 @@
 #include <linux/prctl.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
-#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 #include <arch/abi.h>
 #include <arch/spr_def.h>
diff --git a/arch/x86/kernel/itmt.c b/arch/x86/kernel/itmt.c
index f73f475..d177940 100644
--- a/arch/x86/kernel/itmt.c
+++ b/arch/x86/kernel/itmt.c
@@ -24,7 +24,6 @@
 #include <linux/cpumask.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/sysctl.h>
 #include <linux/nodemask.h>
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 97fb3e5..9824553 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -21,7 +21,6 @@
 #include <linux/dmi.h>
 #include <linux/utsname.h>
 #include <linux/stackprotector.h>
-#include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8af2e8d..c8e0447 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -114,7 +114,6 @@
 #include <asm/alternative.h>
 #include <asm/prom.h>
 #include <asm/microcode.h>
-#include <asm/mmu_context.h>
 #include <asm/kaslr.h>
 #include <asm/unwind.h>
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3d01df7..8dd0f51 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -75,7 +75,6 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 #include <asm/i8259.h>
-#include <asm/realmode.h>
 #include <asm/misc.h>
 #include <asm/qspinlock.h>
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6a151ce..1e5184d 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/mc146818rtc.h>
 #include <linux/efi.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 02f3445..cd97a62 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -23,8 +23,6 @@ static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(char *, irq_name);
 static bool xen_pvspin = true;
 
-#include <asm/qspinlock.h>
-
 static void xen_qlock_kick(int cpu)
 {
 	int irq = per_cpu(lock_kicker_irq, cpu);
diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index a644424..56b01e4 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -21,7 +21,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/init.h>
-#include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/bitops.h>
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index ce70b44..2b75f95 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -42,7 +42,6 @@
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
 #include <crypto/hash.h>
-#include <crypto/aes.h>
 #include <crypto/sha3.h>
 
 #include "util.h"
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 4addc23..deaefd5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -6,7 +6,6 @@
 #include "nitrox_dev.h"
 #include "nitrox_req.h"
 #include "nitrox_csr.h"
-#include "nitrox_req.h"
 
 /* SLC_STORE_INFO */
 #define MIN_UDD_LEN 16
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index ff02b71..ca1f0d7 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -21,7 +21,6 @@
 #include <crypto/ctr.h>
 #include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
-#include <linux/delay.h>
 
 #include "ccp-crypto.h"
 
diff --git a/drivers/gpio/gpio-brcmstb.c b/drivers/gpio/gpio-brcmstb.c
index 545d43a..f40ec39 100644
--- a/drivers/gpio/gpio-brcmstb.c
+++ b/drivers/gpio/gpio-brcmstb.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/bitops.h>
 #include <linux/gpio/driver.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 9ecdf62..7fd0599 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -44,7 +44,6 @@
 #include "gca/gfx_8_0_d.h"
 #include "gca/gfx_8_0_enum.h"
 #include "gca/gfx_8_0_sh_mask.h"
-#include "gca/gfx_8_0_enum.h"
 
 #include "dce/dce_10_0_d.h"
 #include "dce/dce_10_0_sh_mask.h"
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
index c25a831..aad4134 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c
@@ -37,7 +37,6 @@
 #include "gmc/gmc_8_2_sh_mask.h"
 #include "oss/oss_3_0_d.h"
 #include "oss/oss_3_0_sh_mask.h"
-#include "gca/gfx_8_0_sh_mask.h"
 #include "dce/dce_10_0_d.h"
 #include "dce/dce_10_0_sh_mask.h"
 #include "smu/smu_7_1_3_d.h"
diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index cf81065..b526623 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -34,7 +34,6 @@
 #include "vce/vce_3_0_sh_mask.h"
 #include "oss/oss_3_0_d.h"
 #include "oss/oss_3_0_sh_mask.h"
-#include "gca/gfx_8_0_d.h"
 #include "smu/smu_7_1_2_d.h"
 #include "smu/smu_7_1_2_sh_mask.h"
 #include "gca/gfx_8_0_d.h"
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
index 2fbce57..8266a3f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
@@ -24,7 +24,6 @@
 #include "kfd_device_queue_manager.h"
 #include "gca/gfx_8_0_enum.h"
 #include "gca/gfx_8_0_sh_mask.h"
-#include "gca/gfx_8_0_enum.h"
 #include "oss/oss_3_0_sh_mask.h"
 
 static bool set_cache_memory_policy_vi(struct device_queue_manager *dqm,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f71fe6d..b825dcb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -23,7 +23,6 @@
  *
  */
 
-#include "dm_services_types.h"
 #include "dc.h"
 #include "dc/inc/core_types.h"
 
@@ -66,8 +65,6 @@
 #include "soc15_common.h"
 #endif
 
-#include "modules/inc/mod_freesync.h"
-
 #include "i2caux_interface.h"
 
 /* basic init/fini API */
diff --git a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
index 9c18efd..3f55dbc 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
@@ -40,7 +40,6 @@
 #include "dce/dce_mem_input.h"
 #include "dce/dce_link_encoder.h"
 #include "dce/dce_stream_encoder.h"
-#include "dce/dce_mem_input.h"
 #include "dce/dce_ipp.h"
 #include "dce/dce_transform.h"
 #include "dce/dce_opp.h"
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 961ad5c..8d5d4c2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -39,7 +39,6 @@
 #include "ipp.h"
 #include "mpc.h"
 #include "reg_helper.h"
-#include "custom_float.h"
 #include "dcn10_hubp.h"
 
 #define CTX \
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
index bd6be77..ebbe8a1 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smumgr.c
@@ -44,7 +44,6 @@
 
 #include "smu7_hwmgr.h"
 #include "hardwaremanager.h"
-#include "ppatomctrl.h"
 #include "atombios.h"
 #include "pppcielanes.h"
 
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c
index b98ade6..cd9c9b9 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/rv_smumgr.c
@@ -29,7 +29,6 @@
 #include "rv_ppsmc.h"
 #include "smu10_driver_if.h"
 #include "smu10.h"
-#include "ppatomctrl.h"
 #include "pp_debug.h"
 #include "smu_ucode_xfer_vi.h"
 #include "smu7_smumgr.h"
diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 6d99d4a..89e8d68 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -15,7 +15,6 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_encoder.h>
 #include <drm/drm_modeset_helper_vtables.h>
-#include <drm/drm_panel.h>
 
 struct panel_bridge {
 	struct drm_bridge bridge;
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index a934fd5..11f2461 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -39,7 +39,6 @@
 #include "drm_crtc_internal.h"
 #include "drm_legacy.h"
 #include "drm_internal.h"
-#include "drm_crtc_internal.h"
 
 /*
  * drm_debug: Enable debug output.
diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
index 91c07b0..0d6e999 100644
--- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <video/mipi_display.h>
 #include <asm/intel-mid.h>
-#include <video/mipi_display.h>
 #include "i915_drv.h"
 #include "intel_drv.h"
 #include "intel_dsi.h"
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv04.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv04.c
index c80b967..2b44ba5 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv04.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv04.c
@@ -26,8 +26,6 @@
 
 #include <subdev/gpio.h>
 
-#include <subdev/gpio.h>
-
 static void
 nv04_bus_intr(struct nvkm_bus *bus)
 {
diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 890fd6f..b9afb13 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -57,7 +57,6 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 #include <drm/drm_mipi_dsi.h>
-#include <drm/drm_panel.h>
 
 #define RPI_DSI_DRIVER_NAME "rpi-ts-dsi"
 
diff --git a/drivers/hwtracing/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
index e03e589..580cd38 100644
--- a/drivers/hwtracing/coresight/coresight-etb10.c
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -33,7 +33,6 @@
 #include <linux/mm.h>
 #include <linux/perf_event.h>
 
-#include <asm/local.h>
 
 #include "coresight-priv.h"
 
diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
index 1504617..63ca316 100644
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -27,7 +27,6 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 #include <linux/regmap.h>
-#include <linux/delay.h>
 #include "bmg160.h"
 
 #define BMG160_IRQ_NAME		"bmg160_event"
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index cb91245..c50596f 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -49,7 +49,6 @@
 #include "smi.h"
 #include "opa_smi.h"
 #include "agent.h"
-#include "core_priv.h"
 
 static int mad_sendq_size = IB_MAD_QP_SEND_SIZE;
 static int mad_recvq_size = IB_MAD_QP_RECV_SIZE;
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 1fb72c3..0c7db94 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -41,8 +41,6 @@
 #include <linux/module.h>
 #include "core_priv.h"
 
-#include "core_priv.h"
-
 static DEFINE_MUTEX(rdma_nl_mutex);
 static struct sock *nls;
 static struct {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 543d0a4..fe435ed 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -50,16 +50,14 @@
 #include <rdma/ib_cache.h>
 #include <linux/mlx5/port.h>
 #include <linux/mlx5/vport.h>
+#include <linux/mlx5/fs.h>
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <linux/in.h>
 #include <linux/etherdevice.h>
-#include <linux/mlx5/fs.h>
-#include <linux/mlx5/vport.h>
 #include "mlx5_ib.h"
 #include "cmd.h"
-#include <linux/mlx5/vport.h>
 
 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "5.0-0"
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index 685ef22..4210ca1 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -45,7 +45,6 @@
 #include "usnic_ib_verbs.h"
 #include "usnic_ib_sysfs.h"
 #include "usnic_log.h"
-#include "usnic_ib_sysfs.h"
 
 static ssize_t usnic_ib_show_board(struct device *device,
 					struct device_attribute *attr,
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index aa2456a..a688a56 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -47,7 +47,6 @@
 #include "usnic_log.h"
 #include "usnic_uiom.h"
 #include "usnic_transport.h"
-#include "usnic_ib_verbs.h"
 
 #define USNIC_DEFAULT_TRANSPORT USNIC_TRANSPORT_ROCE_CUSTOM
 
diff --git a/drivers/input/rmi4/rmi_f34.c b/drivers/input/rmi4/rmi_f34.c
index 4cfe970..f1f5ac5 100644
--- a/drivers/input/rmi4/rmi_f34.c
+++ b/drivers/input/rmi4/rmi_f34.c
@@ -11,7 +11,6 @@
 #include <linux/rmi.h>
 #include <linux/firmware.h>
 #include <asm/unaligned.h>
-#include <asm/unaligned.h>
 #include <linux/bitops.h>
 
 #include "rmi_driver.h"
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 9d3f0cb..2a9f02e 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -32,7 +32,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
-#include <linux/dma-mapping.h>
 #include <linux/dma/pxa-dma.h>
 
 #include <media/v4l2-async.h>
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 8b586c8..719ed1d 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -28,10 +28,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-common.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include "cal_regs.h"
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 303980b..1d550af 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -25,8 +25,6 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mc.h>
 #include <media/v4l2-subdev.h>
-#include <media/media-device.h>
-#include <media/v4l2-mc.h>
 #include <media/videobuf2-core.h>
 
 int v4l2_mc_create_media_graph(struct media_device *mdev)
diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index 36adf9e..274306d 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -16,7 +16,6 @@
  * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
  */
 
-#include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/mfd/core.h>
 #include <linux/i2c.h>
diff --git a/drivers/mfd/max77843.c b/drivers/mfd/max77843.c
index dc5caea..da9612d 100644
--- a/drivers/mfd/max77843.c
+++ b/drivers/mfd/max77843.c
@@ -15,7 +15,6 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max77693-common.h>
 #include <linux/mfd/max77843-private.h>
diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index 4fd21e8..42bad26 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -34,7 +34,6 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
-#include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/log2.h>
diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index ddfeefe..332a0d1 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -34,7 +34,6 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/crc-itu-t.h>
 
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 5c0d917..8fec04d 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -32,11 +32,9 @@
 #include <linux/iommu.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <linux/dma-mapping.h>
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/delay.h>
 #include <asm/pgtable.h>
 
 #include "genwqe_driver.h"
diff --git a/drivers/mmc/host/android-goldfish.c b/drivers/mmc/host/android-goldfish.c
index 63fe509..63d2758 100644
--- a/drivers/mmc/host/android-goldfish.c
+++ b/drivers/mmc/host/android-goldfish.c
@@ -42,13 +42,11 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/clk.h>
-#include <linux/scatterlist.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
 
 #include <asm/types.h>
-#include <asm/io.h>
 #include <linux/uaccess.h>
 
 #define DRIVER_NAME "goldfish_mmc"
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index ea01f24..b62d472 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -14,7 +14,6 @@
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/mii.h>
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index 2adafa3..fde2415 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -17,6 +17,7 @@
  ***********************************************************************/
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
+#include <net/switchdev.h>
 #include "liquidio_common.h"
 #include "octeon_droq.h"
 #include "octeon_iq.h"
@@ -25,9 +26,7 @@
 #include "octeon_nic.h"
 #include "octeon_main.h"
 #include "octeon_network.h"
-#include <net/switchdev.h>
 #include "lio_vf_rep.h"
-#include "octeon_network.h"
 
 static int lio_vf_rep_open(struct net_device *ndev);
 static int lio_vf_rep_stop(struct net_device *ndev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 6f900ff..e90ab67 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -62,7 +62,6 @@
 #include <net/netevent.h>
 #include <net/addrconf.h>
 #include <net/bonding.h>
-#include <net/addrconf.h>
 #include <linux/uaccess.h>
 #include <linux/crash_dump.h>
 
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 5be52d8..c3e687c 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -102,8 +102,6 @@
 #include <linux/phy_fixed.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 
 #include "gianfar.h"
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index afd07ad..62e42ae 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 94c7804..609cc3a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -36,7 +36,6 @@
 #include <linux/irq.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/microchipphy.h>
-#include <linux/phy.h>
 #include "lan78xx.h"
 
 #define DRIVER_AUTHOR	"WOOJUNG HUH <woojung.huh@microchip.com>"
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a947ee..351de70 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -24,7 +24,6 @@
 #include "hif.h"
 #include "core.h"
 #include "debug.h"
-#include "wmi.h"
 #include "htt.h"
 #include "txrx.h"
 #include "testmode.h"
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7616c1c..71314b97ab 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -18,7 +18,6 @@
 #include "debug.h"
 #include "mac.h"
 #include "hw.h"
-#include "mac.h"
 #include "wmi.h"
 #include "wmi-ops.h"
 #include "wmi-tlv.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 7078b7e..4cd1bed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -85,7 +85,6 @@
 #include "fw/api/scan.h"
 #include "time-event.h"
 #include "fw-api.h"
-#include "fw/api/scan.h"
 #include "fw/acpi.h"
 
 #define DRV_DESCRIPTION	"The new Intel(R) wireless AGN driver for Linux"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 9670732..2b4e1cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -33,7 +33,6 @@
 #include "trx.h"
 #include "led.h"
 #include "dm.h"
-#include "phy.h"
 
 static u8 _rtl88ee_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 1e1bacf..f1540e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -33,7 +33,6 @@
 #include "trx.h"
 #include "led.h"
 #include "dm.h"
-#include "phy.h"
 #include "fw.h"
 
 static u8 _rtl8821ae_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index f054cdd..a0f9a91 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -227,8 +227,6 @@ static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
 	dev_info(&dev->dev, "made independent IRQ optional\n");
 }
 
-#include <linux/pci.h>
-
 static void quirk_system_pci_resources(struct pnp_dev *dev)
 {
 	struct pci_dev *pdev = NULL;
diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index 5cdaa5f..057528e 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -29,8 +29,6 @@
 #include <linux/workqueue.h>
 #include <linux/list.h>
 
-#include <linux/delay.h>
-#include <linux/rpmsg.h>
 #include <linux/rpmsg/qcom_glink.h>
 
 #include "qcom_glink_native.h"
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index f035c2f..131f198 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -27,7 +27,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/vtoc.h>
-#include <asm/diag.h>
 
 #include "dasd_int.h"
 #include "dasd_diag.h"
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 93d7e34..1467858 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/hashtable.h>
-#include <linux/string.h>
 #include <asm/setup.h>
 #include "qeth_core.h"
 #include "qeth_l2.h"
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 0aa9c38..525ac35 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -11,8 +11,6 @@
 #include "qla_def.h"
 #include "qla_gbl.h"
 
-#include <linux/delay.h>
-
 #define TIMEOUT_100_MS 100
 
 static const uint32_t qla8044_reg_tbl[] = {
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 1f8a225..834bddd 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -23,7 +23,6 @@
 #include <crypto/scatterwalk.h>
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
-#include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1a3c481..2cec0e1 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -55,7 +55,6 @@
 #include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/sched.h>
-#include <linux/random.h>
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/of_address.h>
diff --git a/drivers/staging/irda/drivers/pxaficp_ir.c b/drivers/staging/irda/drivers/pxaficp_ir.c
index 1dba16b..2ea00a6 100644
--- a/drivers/staging/irda/drivers/pxaficp_ir.c
+++ b/drivers/staging/irda/drivers/pxaficp_ir.c
@@ -12,7 +12,6 @@
  * Infra-red driver (SIR/FIR) for the PXA2xx embedded microprocessor
  *
  */
-#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index d04ec3b..e09f035 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -30,7 +30,6 @@
 #include <linux/err.h>
 #include <linux/export.h>
 #include <linux/string.h>
-#include <linux/thermal.h>
 
 #include "thermal_core.h"
 
diff --git a/drivers/usb/typec/fusb302/fusb302.c b/drivers/usb/typec/fusb302/fusb302.c
index 72cb060..a3e4cc9 100644
--- a/drivers/usb/typec/fusb302/fusb302.c
+++ b/drivers/usb/typec/fusb302/fusb302.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
-#include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/power_supply.h>
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4a181fc..f70073f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,7 +29,6 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
-#include <linux/dax.h>
 #include <linux/badblocks.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/falloc.h>
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3a4dce1..b34fe15 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -61,7 +61,6 @@
 #include "tests/btrfs-tests.h"
 
 #include "qgroup.h"
-#include "backref.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 3978b32..6eca9d3 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -20,7 +20,6 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/slab.h>
-#include <linux/xattr.h>
 #include "internal.h"
 
 #define CACHEFILES_KEYBUF_SIZE 512
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9c42c4e..ab3aef2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -46,7 +46,6 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-#include "scrub/scrub.h"
 #include "scrub/btree.h"
 
 /*
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 472080e..86daed0 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -26,7 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cc041a2..cf7c8f8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -49,8 +49,6 @@
 #include "xfs_alloc.h"
 #include "xfs_quota_defs.h"
 #include "xfs_quota.h"
-#include "xfs_btree.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
 #include "xfs_rmap_btree.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 5d95fe3..35f3546 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -24,7 +24,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
diff --git a/kernel/audit.c b/kernel/audit.c
index 227db99..06e3677 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -59,7 +59,6 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/pid.h>
-#include <linux/slab.h>
 
 #include <linux/audit.h>
 
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index f24582d..ce46316 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -596,7 +596,6 @@ static struct lock_torture_ops rwsem_lock_ops = {
 	.name		= "rwsem_lock"
 };
 
-#include <linux/percpu-rwsem.h>
 static struct percpu_rw_semaphore pcpu_rwsem;
 
 void torture_percpu_rwsem_init(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 557d467..24bc2da 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -66,7 +66,6 @@
 #include <linux/kexec.h>
 #include <linux/bpf.h>
 #include <linux/mount.h>
-#include <linux/pipe_fs_i.h>
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8d70da1b..5ff0c11 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
-#include <linux/math64.h>
 
 #include "ntp_internal.h"
 #include "timekeeping_internal.h"
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8119270..39791b8 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -16,7 +16,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
-#include <linux/pagemap.h>
 #include <linux/shmem_fs.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 1c48109..b905747 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d6e7a64..a95a55f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -16,7 +16,6 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/mdio.h>
-#include <linux/list.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mirred.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59c0899..332b518 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -45,7 +45,6 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <net/netfilter/nf_conntrack_labels.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
diff --git a/net/sched/act_meta_mark.c b/net/sched/act_meta_mark.c
index 1e3f10e..6445184 100644
--- a/net/sched/act_meta_mark.c
+++ b/net/sched/act_meta_mark.c
@@ -22,7 +22,6 @@
 #include <net/pkt_sched.h>
 #include <uapi/linux/tc_act/tc_ife.h>
 #include <net/tc_act/tc_ife.h>
-#include <linux/rtnetlink.h>
 
 static int skbmark_encode(struct sk_buff *skb, void *skbdata,
 			  struct tcf_meta_info *e)
diff --git a/net/sched/act_meta_skbtcindex.c b/net/sched/act_meta_skbtcindex.c
index 2ea1f26..7221437 100644
--- a/net/sched/act_meta_skbtcindex.c
+++ b/net/sched/act_meta_skbtcindex.c
@@ -22,7 +22,6 @@
 #include <net/pkt_sched.h>
 #include <uapi/linux/tc_act/tc_ife.h>
 #include <net/tc_act/tc_ife.h>
-#include <linux/rtnetlink.h>
 
 static int skbtcindex_encode(struct sk_buff *skb, void *skbdata,
 			     struct tcf_meta_info *e)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ddcf04b..f40256a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <linux/init.h>
 #include <linux/kmod.h>
-#include <linux/err.h>
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index ac152b4..507859c 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -45,7 +45,6 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
-#include <linux/netdevice.h>
 #include <linux/idr.h>
 
 struct tc_u_knode {
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 522ca92..2a1ae26 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <libelf.h>
diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
index 4ed690b..0e1f250 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -9,7 +9,6 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
 #include <signal.h>
diff --git a/samples/bpf/test_current_task_under_cgroup_user.c b/samples/bpf/test_current_task_under_cgroup_user.c
index 65b5fb5..0643b2d 100644
--- a/samples/bpf/test_current_task_under_cgroup_user.c
+++ b/samples/bpf/test_current_task_under_cgroup_user.c
@@ -11,7 +11,6 @@
 #include <unistd.h>
 #include "libbpf.h"
 #include "bpf_load.h"
-#include <linux/bpf.h>
 #include "cgroup_helpers.h"
 
 #define CGROUP_PATH		"/my-cgroup"
diff --git a/samples/sockmap/sockmap_user.c b/samples/sockmap/sockmap_user.c
index 7cc9d22..7c8ccd6 100644
--- a/samples/sockmap/sockmap_user.c
+++ b/samples/sockmap/sockmap_user.c
@@ -19,7 +19,6 @@
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
-#include <sys/ioctl.h>
 #include <stdbool.h>
 #include <signal.h>
 #include <fcntl.h>
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index d4fa04d..657b294 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -33,7 +33,6 @@
 #include "include/context.h"
 #include "include/crypto.h"
 #include "include/ipc.h"
-#include "include/policy_ns.h"
 #include "include/label.h"
 #include "include/policy.h"
 #include "include/policy_ns.h"
diff --git a/sound/soc/hisilicon/hi6210-i2s.c b/sound/soc/hisilicon/hi6210-i2s.c
index 0c8f86d..07a5720 100644
--- a/sound/soc/hisilicon/hi6210-i2s.c
+++ b/sound/soc/hisilicon/hi6210-i2s.c
@@ -36,7 +36,6 @@
 #include <linux/of_irq.h>
 #include <linux/mfd/syscon.h>
 #include <linux/reset-controller.h>
-#include <linux/clk.h>
 
 #include "hi6210-i2s.h"
 
diff --git a/sound/soc/zte/zx-i2s.c b/sound/soc/zte/zx-i2s.c
index 9a05659..93428e1 100644
--- a/sound/soc/zte/zx-i2s.c
+++ b/sound/soc/zte/zx-i2s.c
@@ -20,9 +20,6 @@
 #include <sound/core.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/initval.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
 
 #define ZX_I2S_PROCESS_CTRL	0x04
 #define ZX_I2S_TIMING_CTRL	0x08
diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
index 58ae6ed..4a3c1df 100644
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -26,7 +26,6 @@
 #include "futex.h"
 
 #include <err.h>
-#include <sys/time.h>
 
 static unsigned int nthreads = 0;
 static unsigned int nsecs    = 10;
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 17855c4..54d2cec 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -27,13 +27,10 @@
 #include "sort.h"
 #include "tool.h"
 #include "data.h"
-#include "sort.h"
 #include "event.h"
 #include "evlist.h"
 #include "evsel.h"
-#include <asm/bug.h>
 #include "ui/browsers/hists.h"
-#include "evlist.h"
 #include "thread.h"
 
 struct c2c_hists {
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3d7f33e..93ef455 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -51,7 +51,6 @@
 #include <signal.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
-#include <asm/bug.h>
 #include <linux/time64.h>
 
 struct switch_output {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 59af5a8..1d9af8a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -63,7 +63,6 @@
 #include "util/group.h"
 #include "util/session.h"
 #include "util/tool.h"
-#include "util/group.h"
 #include "util/string2.h"
 #include "util/metricgroup.h"
 #include "asm/bug.h"
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index f067961..18b0644 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 #include <linux/kernel.h>
 #include <linux/hw_breakpoint.h>
-#include <api/fs/fs.h>
 #include <api/fs/tracing_path.h>
 
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index a3349141..c76687e 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -31,9 +31,6 @@
 #include <sys/param.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <string.h>
-#include <limits.h>
-#include <errno.h>
 #include <linux/list.h>
 
 #include "../perf.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7c0e9d5..3e283b0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -15,9 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/stringify.h>
 #include <sys/stat.h>
-#include <sys/types.h>
 #include <sys/utsname.h>
-#include <unistd.h>
 
 #include "evlist.h"
 #include "evsel.h"
diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 0ddd9c1..699311d 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -20,12 +20,10 @@
 #include "pmu.h"
 #include "expr.h"
 #include "rblist.h"
-#include "pmu.h"
 #include <string.h>
 #include <stdbool.h>
 #include <errno.h>
 #include "pmu-events/pmu-events.h"
-#include "strbuf.h"
 #include "strlist.h"
 #include <assert.h>
 #include <ctype.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c7187f0..c1848b5 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -43,7 +43,6 @@
 #include "../db-export.h"
 #include "../thread-stack.h"
 #include "../trace-event.h"
-#include "../machine.h"
 #include "../call-path.h"
 #include "thread_map.h"
 #include "cpumap.h"
diff --git a/tools/testing/selftests/gpio/gpio-mockup-chardev.c b/tools/testing/selftests/gpio/gpio-mockup-chardev.c
index 667e916..0424aaa 100644
--- a/tools/testing/selftests/gpio/gpio-mockup-chardev.c
+++ b/tools/testing/selftests/gpio/gpio-mockup-chardev.c
@@ -12,7 +12,6 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <stdio.h>
 #include <errno.h>
 #include <string.h>
 #include <fcntl.h>
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c b/tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c
index 167135b..bf599d4 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/fork_cleanup_test.c
@@ -3,7 +3,6 @@
  * Licensed under GPLv2.
  */
 
-#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdbool.h>
diff --git a/tools/testing/selftests/powerpc/tm/tm-vmx-unavail.c b/tools/testing/selftests/powerpc/tm/tm-vmx-unavail.c
index 137185b..be05b2c 100644
--- a/tools/testing/selftests/powerpc/tm/tm-vmx-unavail.c
+++ b/tools/testing/selftests/powerpc/tm/tm-vmx-unavail.c
@@ -14,7 +14,6 @@
 #include <string.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <pthread.h>
 #include <sys/mman.h>
 #include <unistd.h>
 #include <pthread.h>
diff --git a/tools/testing/selftests/timers/skew_consistency.c b/tools/testing/selftests/timers/skew_consistency.c
index 022b711..8066be9 100644
--- a/tools/testing/selftests/timers/skew_consistency.c
+++ b/tools/testing/selftests/timers/skew_consistency.c
@@ -32,7 +32,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <stdlib.h>
 #include <string.h>
 #include <sys/wait.h>
 #include "../kselftest.h"
diff --git a/tools/testing/selftests/x86/mpx-dig.c b/tools/testing/selftests/x86/mpx-dig.c
index c13607e..880fbf6 100644
--- a/tools/testing/selftests/x86/mpx-dig.c
+++ b/tools/testing/selftests/x86/mpx-dig.c
@@ -8,9 +8,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <errno.h>
-#include <sys/types.h>
 #include <sys/stat.h>
-#include <unistd.h>
 #include <sys/mman.h>
 #include <string.h>
 #include <fcntl.h>
diff --git a/tools/testing/selftests/x86/mpx-mini-test.c b/tools/testing/selftests/x86/mpx-mini-test.c
index ec0f6b4..f17e0a1 100644
--- a/tools/testing/selftests/x86/mpx-mini-test.c
+++ b/tools/testing/selftests/x86/mpx-mini-test.c
@@ -722,10 +722,6 @@ void mpx_cleanup(void)
 }
 
 /*-------------- the following is test case ---------------*/
-#include <stdint.h>
-#include <stdbool.h>
-#include <stdlib.h>
-#include <stdio.h>
 #include <time.h>
 
 uint64_t num_lower_brs;
diff --git a/tools/testing/selftests/x86/unwind_vdso.c b/tools/testing/selftests/x86/unwind_vdso.c
index 00a26a8..9731133 100644
--- a/tools/testing/selftests/x86/unwind_vdso.c
+++ b/tools/testing/selftests/x86/unwind_vdso.c
@@ -44,7 +44,6 @@ int main()
 #include <stdbool.h>
 #include <sys/ptrace.h>
 #include <sys/user.h>
-#include <sys/ucontext.h>
 #include <link.h>
 #include <sys/auxv.h>
 #include <dlfcn.h>
-- 
2.7.4

