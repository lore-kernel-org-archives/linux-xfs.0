Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 18:47:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m451kRpV001679
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 18:46:28 -0700
Received: from ozlabs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 980F5123B9E
	for <xfs@oss.sgi.com>; Sun,  4 May 2008 18:46:47 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45]) by cuda.sgi.com with ESMTP id ccs2LUvdFgROePy4 for <xfs@oss.sgi.com>; Sun, 04 May 2008 18:46:47 -0700 (PDT)
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 5 May 2008 01:46:36 +0000
Subject: [PATCH] Replace down_trylock() with down_try(), reverse return values.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805051146.38563.rusty@rustcorp.com.au>
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kaos@sgi.com, Stephen Rothwell <sfr@au1.ibm.com>, rolandd@cisco.com, "Brian S. Julin" <bri@calyx.com>, Martin Diehl <info@mdiehl.de>, mokuno@sm.sony.co.jp, aacraid@adaptec.com, mfasheh@suse.com, wim@iguana.be, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>kaos@sgi.comStephen Rothwell <sfr@au1.ibm.com>rolandd@cisco.com"Brian S. Julin" <bri@calyx.com>Martin Diehl <info@mdiehl.de>mokuno@sm.sony.co.jpaacraid@adaptec.commfasheh@suse.comwim@iguana.bexfs@oss.sgi.comreiserfs-devel@vger.kernel.orgMatthew Wilcox <willy@linux.intel.com>kaos@sgi.comStephen Rothwell <sfr@au1.ibm.com>rolandd@cisco.com"Brian S. Julin" <bri@calyx.com>Martin Diehl <info@mdiehl.de>mokuno@sm.sony.co.jpaacraid@adaptec.commfasheh@suse.comwim@iguana.bexfs@oss.sgi.comreiserfs-devel@vger.kernel.orgMatthew Wilcox <willy@linux.intel.com>

down_trylock() returns 1 on failure, 0 on success.  This differs from
spin_trylock(), mutex_trylock() and common sense.  Or as ocfs2 put it
"kernel 1, world 0".

Rename it to down_try() (which makes more sense anyway), and reverse
it.  Fortunately there aren't a huge number of callers left.

I took the liberty of reversing the sense of usb_trylock_device()
without renaming it: it's only used in one place anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: gregkh@suse.de
Cc: kaos@sgi.com
Cc: Stephen Rothwell <sfr@au1.ibm.com>
Cc: rolandd@cisco.com
Cc: "Brian S. Julin" <bri@calyx.com>
Cc: Martin Diehl <info@mdiehl.de>
Cc: mokuno@sm.sony.co.jp
Cc: aacraid@adaptec.com
Cc: mfasheh@suse.com
Cc: wim@iguana.be
Cc: xfs@oss.sgi.com
Cc: reiserfs-devel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>

diff -r c4dfb28595bc Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl	Mon May 05 10:27:58 2008 +1000
+++ b/Documentation/DocBook/kernel-locking.tmpl	Mon May 05 10:32:35 2008 +1000
@@ -1906,7 +1906,7 @@ machines due to caching.
       <function>down()</function>
       </para>
       <para>
-       There is a <function>down_trylock()</function> which can be
+       There is a <function>down_try()</function> which can be
        used inside interrupt context, as it will not sleep.
        <function>up()</function> will also never sleep.
       </para>
diff -r c4dfb28595bc arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c	Mon May 05 10:27:58 2008 +1000
+++ b/arch/ia64/kernel/salinfo.c	Mon May 05 10:32:35 2008 +1000
@@ -192,7 +192,7 @@ static void
 static void
 salinfo_work_to_do(struct salinfo_data *data)
 {
-	down_trylock(&data->mutex);
+	down_try(&data->mutex);
 	up(&data->mutex);
 }
 
@@ -309,7 +309,7 @@ salinfo_event_read(struct file *file, ch
 	int i, n, cpu = -1;
 
 retry:
-	if (cpus_empty(data->cpu_event) && down_trylock(&data->mutex)) {
+	if (cpus_empty(data->cpu_event) && !down_try(&data->mutex)) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 		if (down_interruptible(&data->mutex))
diff -r c4dfb28595bc drivers/char/snsc.c
--- a/drivers/char/snsc.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/char/snsc.c	Mon May 05 10:32:35 2008 +1000
@@ -161,7 +161,7 @@ scdrv_read(struct file *file, char __use
 	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
 
 	/* try to get control of the read buffer */
-	if (down_trylock(&sd->sd_rbs)) {
+	if (!down_try(&sd->sd_rbs)) {
 		/* somebody else has it now;
 		 * if we're non-blocking, then exit...
 		 */
@@ -253,7 +253,7 @@ scdrv_write(struct file *file, const cha
 	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
 
 	/* try to get control of the write buffer */
-	if (down_trylock(&sd->sd_wbs)) {
+	if (!down_try(&sd->sd_wbs)) {
 		/* somebody else has it now;
 		 * if we're non-blocking, then exit...
 		 */
diff -r c4dfb28595bc drivers/char/viotape.c
--- a/drivers/char/viotape.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/char/viotape.c	Mon May 05 10:32:35 2008 +1000
@@ -361,7 +361,7 @@ static ssize_t viotap_write(struct file 
 	 * semaphore
 	 */
 	if (noblock) {
-		if (down_trylock(&reqSem)) {
+		if (!down_try(&reqSem)) {
 			ret = -EWOULDBLOCK;
 			goto free_op;
 		}
@@ -451,7 +451,7 @@ static ssize_t viotap_read(struct file *
 	 * semaphore
 	 */
 	if (noblock) {
-		if (down_trylock(&reqSem)) {
+		if (!down_try(&reqSem)) {
 			ret = -EWOULDBLOCK;
 			goto free_op;
 		}
diff -r c4dfb28595bc drivers/infiniband/core/user_mad.c
--- a/drivers/infiniband/core/user_mad.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/infiniband/core/user_mad.c	Mon May 05 10:32:35 2008 +1000
@@ -890,7 +890,7 @@ static int ib_umad_sm_open(struct inode 
 		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
-		if (down_trylock(&port->sm_sem)) {
+		if (!down_try(&port->sm_sem)) {
 			ret = -EAGAIN;
 			goto fail;
 		}
diff -r c4dfb28595bc drivers/input/serio/hil_mlc.c
--- a/drivers/input/serio/hil_mlc.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/input/serio/hil_mlc.c	Mon May 05 10:32:35 2008 +1000
@@ -607,7 +607,7 @@ static inline void hilse_setup_input(hil
 	do_gettimeofday(&(mlc->instart));
 	mlc->icount = 15;
 	memset(mlc->ipacket, 0, 16 * sizeof(hil_packet));
-	BUG_ON(down_trylock(&mlc->isem));
+	BUG_ON(!down_try(&mlc->isem));
 }
 
 #ifdef HIL_MLC_DEBUG
@@ -694,7 +694,7 @@ static int hilse_donode(hil_mlc *mlc)
 	out2:
 		write_unlock_irqrestore(&mlc->lock, flags);
 
-		if (down_trylock(&mlc->osem)) {
+		if (!down_try(&mlc->osem)) {
 			nextidx = HILSEN_DOZE;
 			break;
 		}
diff -r c4dfb28595bc drivers/input/serio/hp_sdc_mlc.c
--- a/drivers/input/serio/hp_sdc_mlc.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/input/serio/hp_sdc_mlc.c	Mon May 05 10:32:35 2008 +1000
@@ -148,7 +148,7 @@ static int hp_sdc_mlc_in(hil_mlc *mlc, s
 	priv = mlc->priv;
 
 	/* Try to down the semaphore */
-	if (down_trylock(&mlc->isem)) {
+	if (!down_try(&mlc->isem)) {
 		struct timeval tv;
 		if (priv->emtestmode) {
 			mlc->ipacket[0] =
@@ -186,13 +186,13 @@ static int hp_sdc_mlc_cts(hil_mlc *mlc)
 	priv = mlc->priv;
 
 	/* Try to down the semaphores -- they should be up. */
-	BUG_ON(down_trylock(&mlc->isem));
-	BUG_ON(down_trylock(&mlc->osem));
+	BUG_ON(!down_try(&mlc->isem));
+	BUG_ON(!down_try(&mlc->osem));
 
 	up(&mlc->isem);
 	up(&mlc->osem);
 
-	if (down_trylock(&mlc->csem)) {
+	if (!down_try(&mlc->csem)) {
 		if (priv->trans.act.semaphore != &mlc->csem)
 			goto poll;
 		else
@@ -229,7 +229,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 	priv = mlc->priv;
 
 	/* Try to down the semaphore -- it should be up. */
-	BUG_ON(down_trylock(&mlc->osem));
+	BUG_ON(!down_try(&mlc->osem));
 
 	if (mlc->opacket & HIL_DO_ALTER_CTRL)
 		goto do_control;
@@ -240,7 +240,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 		return;
 	}
 	/* Shouldn't be sending commands when loop may be busy */
-	BUG_ON(down_trylock(&mlc->csem));
+	BUG_ON(!down_try(&mlc->csem));
 	up(&mlc->csem);
 
 	priv->trans.actidx = 0;
@@ -296,7 +296,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 	priv->tseq[3] = 0;
 	if (mlc->opacket & HIL_CTRL_APE) {
 		priv->tseq[3] |= HP_SDC_LPC_APE_IPF;
-		down_trylock(&mlc->csem);
+		down_try(&mlc->csem);
 	}
  enqueue:
 	hp_sdc_enqueue_transaction(&priv->trans);
diff -r c4dfb28595bc drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/md/dm-raid1.c	Mon May 05 10:32:35 2008 +1000
@@ -587,7 +587,7 @@ static void rh_recovery_prepare(struct r
 	/* Extra reference to avoid race with rh_stop_recovery */
 	atomic_inc(&rh->recovery_in_flight);
 
-	while (!down_trylock(&rh->recovery_count)) {
+	while (down_try(&rh->recovery_count)) {
 		atomic_inc(&rh->recovery_in_flight);
 		if (__rh_recovery_prepare(rh) <= 0) {
 			atomic_dec(&rh->recovery_in_flight);
diff -r c4dfb28595bc drivers/net/3c527.c
--- a/drivers/net/3c527.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/net/3c527.c	Mon May 05 10:32:35 2008 +1000
@@ -577,7 +577,7 @@ static int mc32_command_nowait(struct ne
 	int ioaddr = dev->base_addr;
 	int ret = -1;
 
-	if (down_trylock(&lp->cmd_mutex) == 0)
+	if (down_try(&lp->cmd_mutex))
 	{
 		lp->cmd_nonblocking=1;
 		lp->exec_box->mbox=0;
diff -r c4dfb28595bc drivers/net/irda/sir_dev.c
--- a/drivers/net/irda/sir_dev.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/net/irda/sir_dev.c	Mon May 05 10:32:35 2008 +1000
@@ -286,7 +286,7 @@ int sirdev_schedule_request(struct sir_d
 
 	IRDA_DEBUG(2, "%s - state=0x%04x / param=%u\n", __FUNCTION__, initial_state, 
param);
 
-	if (down_trylock(&fsm->sem)) {
+	if (!down_try(&fsm->sem)) {
 		if (in_interrupt()  ||  in_atomic()  ||  irqs_disabled()) {
 			IRDA_DEBUG(1, "%s(), state machine busy!\n", __FUNCTION__);
 			return -EWOULDBLOCK;
diff -r c4dfb28595bc drivers/net/ps3_gelic_wireless.c
--- a/drivers/net/ps3_gelic_wireless.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/net/ps3_gelic_wireless.c	Mon May 05 10:32:35 2008 +1000
@@ -2151,7 +2151,7 @@ static void gelic_wl_disconnect_event(st
 	 * As it waits with timeout, just leave assoc_done
 	 * uncompleted, then it terminates with timeout
 	 */
-	if (down_trylock(&wl->assoc_stat_lock)) {
+	if (!down_try(&wl->assoc_stat_lock)) {
 		pr_debug("%s: already locked\n", __func__);
 		lock = 0;
 	} else {
diff -r c4dfb28595bc drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/net/wireless/airo.c	Mon May 05 10:32:35 2008 +1000
@@ -2138,7 +2138,7 @@ static int airo_start_xmit(struct sk_buf
 	fids[i] |= (len << 16);
 	priv->xmit.skb = skb;
 	priv->xmit.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (!down_try(&priv->sem)) {
 		set_bit(FLAG_PENDING_XMIT, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT, &priv->jobs);
@@ -2209,7 +2209,7 @@ static int airo_start_xmit11(struct sk_b
 	fids[i] |= (len << 16);
 	priv->xmit11.skb = skb;
 	priv->xmit11.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (!down_try(&priv->sem)) {
 		set_bit(FLAG_PENDING_XMIT11, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT11, &priv->jobs);
@@ -2257,7 +2257,7 @@ static struct net_device_stats *airo_get
 
 	if (!test_bit(JOB_STATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (!down_try(&local->sem)) {
 			set_bit(JOB_STATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
@@ -2284,7 +2284,7 @@ static void airo_set_multicast_list(stru
 
 	if ((dev->flags ^ ai->flags) & IFF_PROMISC) {
 		change_bit(FLAG_PROMISC, &ai->flags);
-		if (down_trylock(&ai->sem) != 0) {
+		if (!down_try(&ai->sem)) {
 			set_bit(JOB_PROMISC, &ai->jobs);
 			wake_up_interruptible(&ai->thr_wait);
 		} else
@@ -3211,7 +3211,7 @@ static irqreturn_t airo_interrupt(int ir
 				set_bit(FLAG_UPDATE_UNI, &apriv->flags);
 				set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
 
-				if (down_trylock(&apriv->sem) != 0) {
+				if (!down_try(&apriv->sem)) {
 					set_bit(JOB_EVENT, &apriv->jobs);
 					wake_up_interruptible(&apriv->thr_wait);
 				} else
@@ -7658,7 +7658,7 @@ static struct iw_statistics *airo_get_wi
 
 	if (!test_bit(JOB_WSTATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (!down_try(&local->sem)) {
 			set_bit(JOB_WSTATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
diff -r c4dfb28595bc drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/scsi/aacraid/commsup.c	Mon May 05 10:32:35 2008 +1000
@@ -490,7 +490,7 @@ int aac_fib_send(u16 command, struct fib
 			 * hardware failure has occurred.
 			 */
 			unsigned long count = 36000000L; /* 3 minutes */
-			while (down_trylock(&fibptr->event_wait)) {
+			while (!down_try(&fibptr->event_wait)) {
 				int blink;
 				if (--count == 0) {
 					struct aac_queue * q = &dev->queues->queue[AdapNormCmdQueue];
diff -r c4dfb28595bc drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/usb/core/usb.c	Mon May 05 10:32:35 2008 +1000
@@ -477,7 +477,7 @@ int usb_lock_device_for_reset(struct usb
 		}
 	}
 
-	while (usb_trylock_device(udev) != 0) {
+	while (!usb_trylock_device(udev)) {
 
 		/* If we can't acquire the lock after waiting one second,
 		 * we're probably deadlocked */
diff -r c4dfb28595bc drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/usb/gadget/inode.c	Mon May 05 10:32:35 2008 +1000
@@ -298,7 +298,7 @@ get_ready_ep (unsigned f_flags, struct e
 	int	val;
 
 	if (f_flags & O_NONBLOCK) {
-		if (down_trylock (&epdata->lock) != 0)
+		if (!down_try (&epdata->lock))
 			goto nonblock;
 		if (epdata->state != STATE_EP_ENABLED) {
 			up (&epdata->lock);
diff -r c4dfb28595bc drivers/watchdog/ar7_wdt.c
--- a/drivers/watchdog/ar7_wdt.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/ar7_wdt.c	Mon May 05 10:32:35 2008 +1000
@@ -179,7 +179,7 @@ static int ar7_wdt_open(struct inode *in
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (!down_try(&open_semaphore))
 		return -EBUSY;
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
diff -r c4dfb28595bc drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/it8712f_wdt.c	Mon May 05 10:32:35 2008 +1000
@@ -306,7 +306,7 @@ it8712f_wdt_open(struct inode *inode, st
 it8712f_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&it8712f_wdt_sem))
+	if (!down_try(&it8712f_wdt_sem))
 		return -EBUSY;
 	it8712f_wdt_enable();
 
diff -r c4dfb28595bc drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/s3c2410_wdt.c	Mon May 05 10:32:35 2008 +1000
@@ -211,7 +211,7 @@ static int s3c2410wdt_set_heartbeat(int 
 
 static int s3c2410wdt_open(struct inode *inode, struct file *file)
 {
-	if(down_trylock(&open_lock))
+	if(!down_try(&open_lock))
 		return -EBUSY;
 
 	if (nowayout)
diff -r c4dfb28595bc drivers/watchdog/sc1200wdt.c
--- a/drivers/watchdog/sc1200wdt.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/sc1200wdt.c	Mon May 05 10:32:35 2008 +1000
@@ -151,7 +151,7 @@ static int sc1200wdt_open(struct inode *
 static int sc1200wdt_open(struct inode *inode, struct file *file)
 {
 	/* allow one at a time */
-	if (down_trylock(&open_sem))
+	if (!down_try(&open_sem))
 		return -EBUSY;
 
 	if (timeout > MAX_TIMEOUT)
diff -r c4dfb28595bc drivers/watchdog/scx200_wdt.c
--- a/drivers/watchdog/scx200_wdt.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/scx200_wdt.c	Mon May 05 10:32:35 2008 +1000
@@ -92,7 +92,7 @@ static int scx200_wdt_open(struct inode 
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (!down_try(&open_semaphore))
 		return -EBUSY;
 	scx200_wdt_enable();
 
diff -r c4dfb28595bc drivers/watchdog/wdt_pci.c
--- a/drivers/watchdog/wdt_pci.c	Mon May 05 10:27:58 2008 +1000
+++ b/drivers/watchdog/wdt_pci.c	Mon May 05 10:32:35 2008 +1000
@@ -426,7 +426,7 @@ static int wdtpci_ioctl(struct inode *in
 
 static int wdtpci_open(struct inode *inode, struct file *file)
 {
-	if (down_trylock(&open_sem))
+	if (!down_try(&open_sem))
 		return -EBUSY;
 
 	if (nowayout) {
diff -r c4dfb28595bc fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c	Mon May 05 10:27:58 2008 +1000
+++ b/fs/ocfs2/inode.c	Mon May 05 10:32:35 2008 +1000
@@ -1062,10 +1062,6 @@ void ocfs2_clear_inode(struct inode *ino
 			(unsigned long long)oi->ip_blkno);
 	mutex_unlock(&oi->ip_io_mutex);
 
-	/*
-	 * down_trylock() returns 0, down_write_trylock() returns 1
-	 * kernel 1, world 0
-	 */
 	mlog_bug_on_msg(!down_write_trylock(&oi->ip_alloc_sem),
 			"Clear inode of %llu, alloc_sem is locked\n",
 			(unsigned long long)oi->ip_blkno);
diff -r c4dfb28595bc fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c	Mon May 05 10:27:58 2008 +1000
+++ b/fs/reiserfs/journal.c	Mon May 05 10:32:35 2008 +1000
@@ -1412,7 +1412,7 @@ static int flush_journal_list(struct sup
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
 		down(&journal->j_flush_sem);
-	} else if (!down_trylock(&journal->j_flush_sem)) {
+	} else if (down_try(&journal->j_flush_sem)) {
 		BUG();
 	}
 
diff -r c4dfb28595bc fs/xfs/linux-2.6/sema.h
--- a/fs/xfs/linux-2.6/sema.h	Mon May 05 10:27:58 2008 +1000
+++ b/fs/xfs/linux-2.6/sema.h	Mon May 05 10:32:36 2008 +1000
@@ -36,17 +36,15 @@ typedef struct semaphore sema_t;
 
 static inline int issemalocked(sema_t *sp)
 {
-	return down_trylock(sp) || (up(sp), 0);
+	return !down_try(sp) || (up(sp), 0);
 }
 
 /*
- * Map cpsema (try to get the sema) to down_trylock. We need to switch
- * the return values since cpsema returns 1 (acquired) 0 (failed) and
- * down_trylock returns the reverse 0 (acquired) 1 (failed).
+ * Map cpsema (try to get the sema) to down_try.
  */
 static inline int cpsema(sema_t *sp)
 {
-	return down_trylock(sp) ? 0 : 1;
+	return down_try(sp);
 }
 
 #endif /* __XFS_SUPPORT_SEMA_H__ */
diff -r c4dfb28595bc fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c	Mon May 05 10:27:58 2008 +1000
+++ b/fs/xfs/linux-2.6/xfs_buf.c	Mon May 05 10:32:36 2008 +1000
@@ -530,7 +530,7 @@ found:
 	 * if this does not work then we need to drop the
 	 * spinlock and do a hard attempt on the semaphore.
 	 */
-	if (down_trylock(&bp->b_sema)) {
+	if (!down_try(&bp->b_sema)) {
 		if (!(flags & XBF_TRYLOCK)) {
 			/* wait for buffer ownership */
 			XB_TRACE(bp, "get_lock", 0);
@@ -873,7 +873,7 @@ xfs_buf_cond_lock(
 {
 	int			locked;
 
-	locked = down_trylock(&bp->b_sema) == 0;
+	locked = down_try(&bp->b_sema);
 	if (locked) {
 		XB_SET_OWNER(bp);
 	}
diff -r c4dfb28595bc include/linux/mutex.h
--- a/include/linux/mutex.h	Mon May 05 10:27:58 2008 +1000
+++ b/include/linux/mutex.h	Mon May 05 10:32:36 2008 +1000
@@ -141,10 +141,6 @@ extern int __must_check mutex_lock_killa
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 #endif
 
-/*
- * NOTE: mutex_trylock() follows the spin_trylock() convention,
- *       not the down_trylock() convention!
- */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 
diff -r c4dfb28595bc include/linux/semaphore.h
--- a/include/linux/semaphore.h	Mon May 05 10:27:58 2008 +1000
+++ b/include/linux/semaphore.h	Mon May 05 10:32:36 2008 +1000
@@ -44,7 +44,7 @@ extern void down(struct semaphore *sem);
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
-extern int __must_check down_trylock(struct semaphore *sem);
+extern int __must_check down_try(struct semaphore *sem);
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
diff -r c4dfb28595bc include/linux/usb.h
--- a/include/linux/usb.h	Mon May 05 10:27:58 2008 +1000
+++ b/include/linux/usb.h	Mon May 05 10:32:36 2008 +1000
@@ -491,7 +491,7 @@ extern void usb_put_dev(struct usb_devic
 /* USB device locking */
 #define usb_lock_device(udev)		down(&(udev)->dev.sem)
 #define usb_unlock_device(udev)		up(&(udev)->dev.sem)
-#define usb_trylock_device(udev)	down_trylock(&(udev)->dev.sem)
+#define usb_trylock_device(udev)	down_try(&(udev)->dev.sem)
 extern int usb_lock_device_for_reset(struct usb_device *udev,
 				     const struct usb_interface *iface);
 
diff -r c4dfb28595bc kernel/mutex.c
--- a/kernel/mutex.c	Mon May 05 10:27:58 2008 +1000
+++ b/kernel/mutex.c	Mon May 05 10:32:36 2008 +1000
@@ -373,8 +373,8 @@ static inline int __mutex_trylock_slowpa
  * Try to acquire the mutex atomically. Returns 1 if the mutex
  * has been acquired successfully, and 0 on contention.
  *
- * NOTE: this function follows the spin_trylock() convention, so
- * it is negated to the down_trylock() return values! Be careful
+ * NOTE: this function follows the spin_trylock()/down_try() convention,
+ * so it is negated to the old down_trylock() return values! Be careful
  * about this when converting semaphore users to mutexes.
  *
  * This function must not be used in interrupt context. The
diff -r c4dfb28595bc kernel/printk.c
--- a/kernel/printk.c	Mon May 05 10:27:58 2008 +1000
+++ b/kernel/printk.c	Mon May 05 10:32:36 2008 +1000
@@ -986,7 +986,7 @@ EXPORT_SYMBOL(acquire_console_sem);
 
 int try_acquire_console_sem(void)
 {
-	if (down_trylock(&console_sem))
+	if (!down_try(&console_sem))
 		return -1;
 	console_locked = 1;
 	console_may_schedule = 0;
@@ -1083,7 +1083,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (!down_try(&console_sem))
 			return;
 	} else
 		acquire_console_sem();
diff -r c4dfb28595bc kernel/semaphore.c
--- a/kernel/semaphore.c	Mon May 05 10:27:58 2008 +1000
+++ b/kernel/semaphore.c	Mon May 05 10:32:36 2008 +1000
@@ -14,7 +14,7 @@
  * Some notes on the implementation:
  *
  * The spinlock controls access to the other members of the semaphore.
- * down_trylock() and up() can be called from interrupt context, so we
+ * down_try() and up() can be called from interrupt context, so we
  * have to disable interrupts when taking the lock.  It turns out various
  * parts of the kernel expect to be able to use down() on a semaphore in
  * interrupt context when they know it will succeed, so we have to use
@@ -114,19 +114,18 @@ EXPORT_SYMBOL(down_killable);
 EXPORT_SYMBOL(down_killable);
 
 /**
- * down_trylock - try to acquire the semaphore, without waiting
+ * down_try - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
  *
- * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
- * been acquired successfully or 1 if it it cannot be acquired.
+ * Try to acquire the semaphore atomically.  Returns true if the mutex has
+ * been acquired successfully or 0 if it it cannot be acquired.
  *
- * NOTE: This return value is inverted from both spin_trylock and
- * mutex_trylock!  Be careful about this when converting code.
+ * NOTE: This replaces down_trylock() which returned the reverse.
  *
  * Unlike mutex_trylock, this function can be used from interrupt context,
  * and the semaphore can be released by any task or interrupt.
  */
-int down_trylock(struct semaphore *sem)
+int down_try(struct semaphore *sem)
 {
 	unsigned long flags;
 	int count;
@@ -137,9 +136,9 @@ int down_trylock(struct semaphore *sem)
 		sem->count = count;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
-	return (count < 0);
+	return (count >= 0);
 }
-EXPORT_SYMBOL(down_trylock);
+EXPORT_SYMBOL(down_try);
 
 /**
  * down_timeout - acquire the semaphore within a specified time
