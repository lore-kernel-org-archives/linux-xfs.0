Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 15:12:58 -0800 (PST)
Received: from coraid.com (ns1.coraid.com [65.14.39.133])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBENCkqw026804
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 15:12:48 -0800
Date: Thu, 14 Dec 2006 17:48:26 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: Fw: [Bugme-new] [Bug 7662] New: AOE filesystem corruption on Alpha
Message-ID: <20061214224826.GI10048@coraid.com>
Reply-To: support@coraid.com
References: <20061209234305.c65b4e14.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <20061209234305.c65b4e14.akpm@osdl.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: support@coraid.com, Greg KH <greg@kroah.com>, boddingt@optusnet.com.au, xfs@oss.sgi.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 09, 2006 at 11:43:05PM -0800, Andrew Morton wrote:
> 
> hm, AOE on alpha - who'd have imagined?
> 
> James, are you able to get us a copy of the oops trace?

It turns out the aoe driver wasn't setting up the linear part of the
skb correctly and so the data was being offset when the skb was
linearized for cards that didn't do scatter gather.

James Boddington reports that everything's fine with a RealTek 8139
card he has but not fine with several other cards:

    I just tried a cheap RealTek card. A rtl8139 pci 100MBit. AoE in
    2.6.19 works with the realtek card. Did your test again with the
    realtek. The results look like the results I got with AoE
    v23. Correct offset and the data not truncated.
    
    Which leaves me with both ne2k-pci and 3com, AoE not
    working. Rtl8139 and AoE does work.

I haven't got confirmation, but we think that the other cards don't
perform scatter gather.  We can replicate JB's problem by turning off
the scatter gather feature in an Intel gigabit network card using
ethtool.

The attached patch fixes the offsets when scatter gather is not in use
by setting up the linear part of the skb correctly.  After applying
this patch to 2.6.19.1, everything looks great for writes like:

     echo AaAbAcAdAe > /dev/etherd/e0.2

... and when using ext3 on the device.  However, we see problems when
using XFS.  It appears that the XFS problem is unrelated, because the
kernel's new lock debugging sees some problems that appear in the
attached netconsole log.

XFS passes us a bio with a pointer to a page that has a reference
count of zero which causes problems when __pskb_pull_tail does a put
on the page.  With ext3, we only got pages with a reference count
greater than zero.

The problem doesn't appear when scatter gather is turned on,
although the same locking issues are logged.  (See third attachment.)

-- 
  Ed L Cashin <ecashin@coraid.com>

--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aoe-2.6.19-lenfix.diff"

diff -uprN linux-2.6.19.orig/drivers/block/aoe/aoecmd.c linux-2.6.19.mod/drivers/block/aoe/aoecmd.c
--- linux-2.6.19.orig/drivers/block/aoe/aoecmd.c	2006-12-11 18:15:42.322711000 -0500
+++ linux-2.6.19.mod/drivers/block/aoe/aoecmd.c	2006-12-12 17:12:59.307200500 -0500
@@ -30,8 +30,6 @@ new_skb(ulong len)
 		skb->nh.raw = skb->mac.raw = skb->data;
 		skb->protocol = __constant_htons(ETH_P_AOE);
 		skb->priority = 0;
-		skb_put(skb, len);
-		memset(skb->head, 0, len);
 		skb->next = skb->prev = NULL;
 
 		/* tell the network layer not to perform IP checksums
@@ -122,8 +120,8 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb->mac.raw;
 	ah = (struct aoe_atahdr *) (h+1);
-	skb->len = sizeof *h + sizeof *ah;
-	memset(h, 0, ETH_ZLEN);
+	skb_put(skb, sizeof *h + sizeof *ah);
+	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, h);
 	f->waited = 0;
 	f->buf = buf;
@@ -149,7 +147,6 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 		skb->len += bcnt;
 		skb->data_len = bcnt;
 	} else {
-		skb->len = ETH_ZLEN;
 		writebit = 0;
 	}
 
@@ -206,6 +203,7 @@ aoecmd_cfg_pkts(ushort aoemajor, unsigne
 			printk(KERN_INFO "aoe: skb alloc failure\n");
 			continue;
 		}
+		skb_put(skb, sizeof *h + sizeof *ch);
 		skb->dev = ifp;
 		if (sl_tail == NULL)
 			sl_tail = skb;
@@ -243,6 +241,7 @@ freeframe(struct aoedev *d)
 			continue;
 		if (atomic_read(&skb_shinfo(f->skb)->dataref) == 1) {
 			skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
+			skb_trim(f->skb, 0);
 			return f;
 		}
 		n++;
@@ -698,8 +697,8 @@ aoecmd_ata_id(struct aoedev *d)
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb->mac.raw;
 	ah = (struct aoe_atahdr *) (h+1);
-	skb->len = ETH_ZLEN;
-	memset(h, 0, ETH_ZLEN);
+	skb_put(skb, sizeof *h + sizeof *ah);
+	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, h);
 	f->waited = 0;
 

--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfslocks.log"

[17288.149493] Filesystem "etherd/e0.2": Disabling barriers, not supported by the underlying device
[17288.162760] XFS mounting filesystem etherd/e0.2
[17296.743211] 
[17296.743214] =============================================
[17296.743236] [ INFO: possible recursive locking detected ]
[17296.743246] 2.6.19.1dbg #2
[17296.743256] ---------------------------------------------
[17296.743269] cp/8885 is trying to acquire lock:
[17296.743281]  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff8826143e>] xfs_ilock+0x6e/0xa0 [xfs]
[17296.743374] 
[17296.743376] but task is already holding lock:
[17296.743397]  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff8826143e>] xfs_ilock+0x6e/0xa0 [xfs]
[17296.743462] 
[17296.743464] other info that might help us debug this:
[17296.743486] 2 locks held by cp/8885:
[17296.743498]  #0:  (&inode->i_mutex/1){--..}, at: [<ffffffff8029d45f>] lookup_create+0x2f/0xa0
[17296.743594]  #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff8826143e>] xfs_ilock+0x6e/0xa0 [xfs]
[17296.743713] 
[17296.743714] stack backtrace:
[17296.743725] 
[17296.743726] Call Trace:
[17296.743744]  [<ffffffff8020b099>] dump_trace+0xa9/0x480
[17296.743756]  [<ffffffff8020b4b3>] show_trace+0x43/0x60
[17296.743773]  [<ffffffff8020b715>] dump_stack+0x15/0x20
[17296.743787]  [<ffffffff8024df67>] __lock_acquire+0x8b7/0xc80
[17296.743798]  [<ffffffff8024e6cd>] lock_acquire+0x8d/0xc0
[17296.743810]  [<ffffffff80249146>] down_write+0x36/0x50
[17296.743841]  [<ffffffff8826143e>] :xfs:xfs_ilock+0x6e/0xa0
[17296.743898]  [<ffffffff88261c72>] :xfs:xfs_iget+0x462/0x870
[17296.743956]  [<ffffffff8827959e>] :xfs:xfs_trans_iget+0xbe/0x140
[17296.744026]  [<ffffffff88265dbe>] :xfs:xfs_ialloc+0x9e/0x500
[17296.744083]  [<ffffffff8827a18c>] :xfs:xfs_dir_ialloc+0x7c/0x2b0
[17296.744148]  [<ffffffff8828176b>] :xfs:xfs_mkdir+0x35b/0x6c0
[17296.744216]  [<ffffffff8828b837>] :xfs:xfs_vn_mknod+0x217/0x440
[17296.744290]  [<ffffffff8828ba6e>] :xfs:xfs_vn_mkdir+0xe/0x10
[17296.744348]  [<ffffffff802a103c>] vfs_mkdir+0xfc/0x190
[17296.744359]  [<ffffffff802a1187>] sys_mkdirat+0xb7/0x110
[17296.744371]  [<ffffffff802a11f3>] sys_mkdir+0x13/0x20
[17296.744380]  [<ffffffff80209bc5>] tracesys+0xdc/0xe7
[17296.744403]  [<00000034db5bc617>]
[17296.744410] 
[17296.765295] Bad page state in process 'cp'
[17296.765298] page:ffff81003f1bf358 flags:0x0100000000000080 mapping:0000000000000000 mapcount:0 count:0
[17296.765300] Trying to fix it up, but a reboot is needed
[17296.765301] Backtrace:
[17296.765329] 
[17296.765330] Call Trace:
[17296.765367]  [<ffffffff8020b099>] dump_trace+0xa9/0x480
[17296.765381]  [<ffffffff8020b4b3>] show_trace+0x43/0x60
[17296.765392]  [<ffffffff8020b715>] dump_stack+0x15/0x20
[17296.765407]  [<ffffffff8026d621>] bad_page+0x61/0x90
[17296.765420]  [<ffffffff8026e7aa>] free_hot_cold_page+0x8a/0x180
[17296.765431]  [<ffffffff8026e90b>] free_hot_page+0xb/0x10
[17296.765446]  [<ffffffff80271468>] put_page+0xa8/0xc0
[17296.765458]  [<ffffffff80432711>] __pskb_pull_tail+0x211/0x2e0
[17296.765474]  [<ffffffff80438676>] dev_queue_xmit+0xa6/0x2c0
[17296.765494]  [<ffffffff88221af7>] :aoe:aoenet_xmit+0x27/0x40
[17296.765504] Bad page state in process 'swapper'
[17296.765509] page:ffff81003f1bf460 flags:0x010000000000008c mapping:0000000000000000 mapcount:0 count:0
[17296.765514] Trying to fix it up, but a reboot is needed
[17296.765517] Backtrace:
[17296.765521] 
[17296.765522] Call Trace:
[17296.765534]  [<ffffffff8020b099>] dump_trace+0xa9/0x480
[17296.765543]  [<ffffffff8020b4b3>] show_trace+0x43/0x60
[17296.765551]  [<ffffffff8020b715>] dump_stack+0x15/0x20
[17296.765557]  [<ffffffff8026d621>] bad_page+0x61/0x90
[17296.765564]  [<ffffffff8026e7aa>] free_hot_cold_page+0x8a/0x180
[17296.765569]  [<ffffffff8026e90b>] free_hot_page+0xb/0x10
[17296.765574]  [<ffffffff80271468>] put_page+0xa8/0xc0
[17296.765583]  [<ffffffff80432711>] __pskb_pull_tail+0x211/0x2e0
[17296.765590]  [<ffffffff80438676>] dev_queue_xmit+0xa6/0x2c0
[17296.765602]  [<ffffffff88221af7>] :aoe:aoenet_xmit+0x27/0x40
[17296.765680]  [<ffffffff88287934>] :xfs:xfs_buf_iorequest+0x424/0x4b0
[17296.765685]  [<ffffffff803af7b8>] e1000_clean_rx_irq+0x498/0x550
[17296.765692]  [<ffffffff803b36e8>] e1000_clean+0x98/0x130
[17296.765698]  [<ffffffff80436f73>] net_rx_action+0xc3/0x190
[17296.765707]  [<ffffffff80236320>] __do_softirq+0x80/0x100
[17296.765716]  [<ffffffff8020abcc>] call_softirq+0x1c/0x30
[17296.765726]  [<ffffffff8020c50d>] do_softirq+0x3d/0xb0
[17296.765734]  [<ffffffff8023600e>] irq_exit+0x4e/0x60
[17296.765740]  [<ffffffff8020c6dc>] do_IRQ+0x15c/0x190
[17296.765747]  [<ffffffff80209f86>] ret_from_intr+0x0/0xf
[17296.765753]  [<ffffffff8020858c>] mwait_idle_with_hints+0x4c/0x50
[17296.765763]  [<ffffffff802085a9>] mwait_idle+0x19/0x30
[17296.765768]  [<ffffffff8020851b>] cpu_idle+0x5b/0x80
[17296.765776]  [<ffffffff8070281b>] start_secondary+0x4eb/0x500
[17296.765781] 
[17296.765863]  [<ffffffff8826b6e1>] :xfs:xlog_bdstrat_cb+0x21/0x50
[17296.765619]  [<ffffffff8822115b>] :aoe:aoecmd_ata_rsp+0x66b/0x720
[17296.765627]  [<ffffffff8821f403>] :aoe:aoeblk_make_request+0x1d3/0x1f0
[17296.765635]  [<ffffffff8031db9e>] generic_make_request+0x17e/0x1a0
[17296.765643]  [<ffffffff8031f658>] submit_bio+0xd8/0xf0
[17296.765660]  [<ffffffff88221c4c>] :aoe:aoenet_rcv+0x13c/0x1a0
[17296.765673]  [<ffffffff80438bac>] netif_receive_skb+0x31c/0x350
[17296.765930]  [<ffffffff8826bd03>] :xfs:xlog_state_release_iclog+0x353/0x550
[17296.765994]  [<ffffffff8826e3f4>] :xfs:xlog_write+0x684/0x740
[17296.766055]  [<ffffffff8826e4e8>] :xfs:xfs_log_write+0x38/0x70
[17296.766116]  [<ffffffff882780ee>] :xfs:_xfs_trans_commit+0x54e/0x760
[17296.766181]  [<ffffffff88280996>] :xfs:xfs_create+0x4e6/0x6b0
[17296.766249]  [<ffffffff8828b80f>] :xfs:xfs_vn_mknod+0x1ef/0x440
[17296.766325]  [<ffffffff8828ba7b>] :xfs:xfs_vn_create+0xb/0x10
[17296.766385]  [<ffffffff802a03f9>] vfs_create+0x109/0x1a0
[17296.766398]  [<ffffffff802a065f>] open_namei+0x1cf/0x700
[17296.766409]  [<ffffffff8029421c>] do_filp_open+0x2c/0x50
[17296.766418]  [<ffffffff8029429a>] do_sys_open+0x5a/0xf0
[17296.766427]  [<ffffffff8029435b>] sys_open+0x1b/0x20
[17296.766437]  [<ffffffff80209bc5>] tracesys+0xdc/0xe7
[17296.766473]  [<00000034db5bc650>]
[17296.766480] 
[17296.766526] Bad page state in process 'cp'
[17296.766528] page:ffff81003f1bf3b0 flags:0x010000000000008c mapping:0000000000000000 mapcount:0 count:0
[17296.766530] Trying to fix it up, but a reboot is needed
[17296.766531] Backtrace:
[17296.766550] 
[17296.766551] Call Trace:
[17296.766565]  [<ffffffff8020b099>] dump_trace+0xa9/0x480
[17296.766576]  [<ffffffff8020b4b3>] show_trace+0x43/0x60
[17296.766586]  [<ffffffff8020b715>] dump_stack+0x15/0x20
[17296.766597]  [<ffffffff8026d621>] bad_page+0x61/0x90
[17296.766607]  [<ffffffff8026e7aa>] free_hot_cold_page+0x8a/0x180
[17296.766618]  [<ffffffff8026e90b>] free_hot_page+0xb/0x10
[17296.766629]  [<ffffffff80271468>] put_page+0xa8/0xc0
[17296.766640]  [<ffffffff80432711>] __pskb_pull_tail+0x211/0x2e0
[17296.766650]  [<ffffffff80438676>] dev_queue_xmit+0xa6/0x2c0
[17296.766663]  [<ffffffff88221af7>] :aoe:aoenet_xmit+0x27/0x40
[17296.766677]  [<ffffffff8821f403>] :aoe:aoeblk_make_request+0x1d3/0x1f0
[17296.766688]  [<ffffffff8031db9e>] generic_make_request+0x17e/0x1a0
[17296.766697]  [<ffffffff8031f658>] submit_bio+0xd8/0xf0
[17296.766731]  [<ffffffff88287934>] :xfs:xfs_buf_iorequest+0x424/0x4b0
[17296.766804]  [<ffffffff8826b6e1>] :xfs:xlog_bdstrat_cb+0x21/0x50
[17296.766864]  [<ffffffff8826bd03>] :xfs:xlog_state_release_iclog+0x353/0x550
[17296.766926]  [<ffffffff8826e3f4>] :xfs:xlog_write+0x684/0x740

--WplhKdTI2c8ulnbP--
