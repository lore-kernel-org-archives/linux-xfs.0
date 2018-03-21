Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:54405 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753744AbeCUWSQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 18:18:16 -0400
From: Joe Perches <joe@perches.com>
Subject: [trivial PATCH V2] treewide: Align function definition open/close braces
Date: Wed, 21 Mar 2018 15:09:32 -0700
Message-Id: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Manish Chopra <manish.chopra@cavium.com>, Rahul Verma <rahul.verma@cavium.com>, Dept-GELinuxNICDev@cavium.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Timur Tabi <timur@tabi.org>, Nicolin Chen <nicoleotsuka@gmail.com>, Xiubo Li <Xiubo.Lee@gmail.com>, Fabio Estevam <fabio.estevam@nxp.com>, Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, David Airlie <airlied@linux.ie>, Mauro Carvalho Chehab <mchehab@kernel.org>, Kalle Valo <kvalo@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-audit@redhat.com, alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org

Some functions definitions have either the initial open brace and/or
the closing brace outside of column 1.

Move those braces to column 1.

This allows various function analyzers like gnu complexity to work
properly for these modified functions.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

git diff -w still shows no difference.

This patch was sent but December and not applied.

As the trivial maintainer seems not active, it'd be nice if
Andrew Morton picks this up.

V2: Remove fs/xfs/libxfs/xfs_alloc.c as it's updated and remerge the rest

 arch/x86/include/asm/atomic64_32.h                   |  2 +-
 drivers/acpi/custom_method.c                         |  2 +-
 drivers/acpi/fan.c                                   |  2 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c             |  2 +-
 drivers/media/i2c/msp3400-kthreads.c                 |  2 +-
 drivers/message/fusion/mptsas.c                      |  2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c                |  2 +-
 drivers/platform/x86/eeepc-laptop.c                  |  2 +-
 drivers/rtc/rtc-ab-b5ze-s3.c                         |  2 +-
 drivers/scsi/dpt_i2o.c                               |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                  |  2 +-
 fs/locks.c                                           |  2 +-
 fs/ocfs2/stack_user.c                                |  2 +-
 fs/xfs/xfs_export.c                                  |  2 +-
 kernel/audit.c                                       |  6 +++---
 kernel/trace/trace_printk.c                          |  4 ++--
 lib/raid6/sse2.c                                     | 14 +++++++-------
 sound/soc/fsl/fsl_dma.c                              |  2 +-
 19 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 46e1ef17d92d..92212bf0484f 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -123,7 +123,7 @@ static inline long long arch_atomic64_read(const atomic64_t *v)
 	long long r;
 	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
 	return r;
- }
+}
 
 /**
  * arch_atomic64_add_return - add and return
diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index b33fba70ec51..a07fbe999eb6 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -97,7 +97,7 @@ static void __exit acpi_custom_method_exit(void)
 {
 	if (cm_dentry)
 		debugfs_remove(cm_dentry);
- }
+}
 
 module_init(acpi_custom_method_init);
 module_exit(acpi_custom_method_exit);
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 6cf4988206f2..3563103590c6 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -219,7 +219,7 @@ fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
 		return fan_set_state_acpi4(device, state);
 	else
 		return fan_set_state(device, state);
- }
+}
 
 static const struct thermal_cooling_device_ops fan_cooling_ops = {
 	.get_max_state = fan_get_max_state,
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 8394d69b963f..e934326a95d3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -588,7 +588,7 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
  ******************************************************************************/
 
 struct dc *dc_create(const struct dc_init_data *init_params)
- {
+{
 	struct dc *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 	unsigned int full_pipe_count;
 
diff --git a/drivers/media/i2c/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
index 4dd01e9f553b..dc6cb8d475b3 100644
--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -885,7 +885,7 @@ static int msp34xxg_modus(struct i2c_client *client)
 }
 
 static void msp34xxg_set_source(struct i2c_client *client, u16 reg, int in)
- {
+{
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
 	int source, matrix;
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 439ee9c5f535..231f3a1e27bf 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2967,7 +2967,7 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 	mutex_unlock(&ioc->sas_mgmt.mutex);
 out:
 	return ret;
- }
+}
 
 static void
 mptsas_parse_device_info(struct sas_identify *identify,
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 3dd973475125..0ea141ece19e 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -603,7 +603,7 @@ static struct uni_table_desc *nx_get_table_desc(const u8 *unirom, int section)
 
 static int
 netxen_nic_validate_header(struct netxen_adapter *adapter)
- {
+{
 	const u8 *unirom = adapter->fw->data;
 	struct uni_table_desc *directory = (struct uni_table_desc *) &unirom[0];
 	u32 fw_file_size = adapter->fw->size;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 396bf05c6bf6..88be55ed5b4d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -252,7 +252,7 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	}
 
 	return skb;
- }
+}
 
 
 static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 5a681962899c..4c38904a8a32 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -492,7 +492,7 @@ static void eeepc_platform_exit(struct eeepc_laptop *eeepc)
  * potentially bad time, such as a timer interrupt.
  */
 static void tpd_led_update(struct work_struct *work)
- {
+{
 	struct eeepc_laptop *eeepc;
 
 	eeepc = container_of(work, struct eeepc_laptop, tpd_led_work);
diff --git a/drivers/rtc/rtc-ab-b5ze-s3.c b/drivers/rtc/rtc-ab-b5ze-s3.c
index e55f35fa0b58..8dc451932446 100644
--- a/drivers/rtc/rtc-ab-b5ze-s3.c
+++ b/drivers/rtc/rtc-ab-b5ze-s3.c
@@ -646,7 +646,7 @@ static int abb5zes3_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 			ret);
 
 	return ret;
- }
+}
 
 /* Enable or disable battery low irq generation */
 static inline int _abb5zes3_rtc_battery_low_irq_enable(struct regmap *regmap,
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0f30792d74c4..cc5fa99a6530 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3521,7 +3521,7 @@ static int adpt_i2o_systab_send(adpt_hba* pHba)
 #endif
 
 	return ret;	
- }
+}
 
 
 /*============================================================================
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 791a2182de53..7320d5fe4cbc 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1393,7 +1393,7 @@ static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt, int unit,
 		scsi_host_put(shost);
 
 	return NULL;
- }
+}
 
 
 /*
diff --git a/fs/locks.c b/fs/locks.c
index d56a14894fb2..0feaed9f589b 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -559,7 +559,7 @@ static const struct lock_manager_operations lease_manager_ops = {
  * Initialize a lease, use the default lock manager operations
  */
 static int lease_init(struct file *filp, long type, struct file_lock *fl)
- {
+{
 	if (assign_type(fl, type) != 0)
 		return -EINVAL;
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index dae9eb7c441e..d2fb97b173da 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -398,7 +398,7 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
 
 static int ocfs2_control_do_setversion_msg(struct file *file,
 					   struct ocfs2_control_message_setv *msg)
- {
+{
 	long major, minor;
 	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 761f3189eff2..eed698aa9f16 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -122,7 +122,7 @@ xfs_nfs_get_inode(
 	struct super_block	*sb,
 	u64			ino,
 	u32			generation)
- {
+{
  	xfs_mount_t		*mp = XFS_M(sb);
 	xfs_inode_t		*ip;
 	int			error;
diff --git a/kernel/audit.c b/kernel/audit.c
index 8fe6dfb67a94..a97d004375e3 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -486,15 +486,15 @@ static int audit_set_failure(u32 state)
  * Drop any references inside the auditd connection tracking struct and free
  * the memory.
  */
- static void auditd_conn_free(struct rcu_head *rcu)
- {
+static void auditd_conn_free(struct rcu_head *rcu)
+{
 	struct auditd_connection *ac;
 
 	ac = container_of(rcu, struct auditd_connection, rcu);
 	put_pid(ac->pid);
 	put_net(ac->net);
 	kfree(ac);
- }
+}
 
 /**
  * auditd_set - Set/Reset the auditd connection state
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index ad1d6164e946..50f44b7b2b32 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -196,7 +196,7 @@ struct notifier_block module_trace_bprintk_format_nb = {
 };
 
 int __trace_bprintk(unsigned long ip, const char *fmt, ...)
- {
+{
 	int ret;
 	va_list ap;
 
@@ -214,7 +214,7 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 EXPORT_SYMBOL_GPL(__trace_bprintk);
 
 int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
- {
+{
 	if (unlikely(!fmt))
 		return 0;
 
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 1d2276b007ee..8191e1d0d2fb 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -91,7 +91,7 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
- {
+{
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
@@ -200,9 +200,9 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
- static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
+static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
- {
+{
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
@@ -265,7 +265,7 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
- }
+}
 
 const struct raid6_calls raid6_sse2x2 = {
 	raid6_sse22_gen_syndrome,
@@ -366,9 +366,9 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
- static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
+static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
- {
+{
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
@@ -471,7 +471,7 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
- }
+}
 
 
 const struct raid6_calls raid6_sse2x4 = {
diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index fce2010d3c53..78871de35086 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -886,7 +886,7 @@ static const struct snd_pcm_ops fsl_dma_ops = {
 };
 
 static int fsl_soc_dma_probe(struct platform_device *pdev)
- {
+{
 	struct dma_object *dma;
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *ssi_np;
-- 
2.15.0

