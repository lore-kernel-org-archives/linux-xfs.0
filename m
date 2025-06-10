Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80F25E801;
	Tue, 10 Jun 2025 02:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749523980; cv=pass; b=L0EljM+1nkIWA/P+diFu9osK2cZkwM1YI9NdroI8msEgntjc+GF18Aoiq5deWJeVO5+pMQnxZ8SBhrJl2rUbkjeUrORX7Vnr7XNMHl1UPtI6QSsMC7KnUAjPF/vcvoOndPIdQgFKlfEUgjdth1AhgO0c897F9F/XMieQcNyQBhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749523980; c=relaxed/simple;
	bh=6j7s3IcAgI80HNsAl3QJbZkK8tBn68/ct1mjmxcPD3Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ANge0IeFFfkUxyTIrLGNuzFnh5/WIAwM0fhhHhm7n18ynI+02fosh6bHyc0VcFWj/FiW9MeNmJsygOc58ZkRrxAiQW5anFutq/cGz5KrUycez+qHkNOA/nmdSwbquo0MBxwcLIIpE4FlMyzcV/WJEDZEPYZPtDFL23arJGfEFOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=kXmSkmZ+; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="kXmSkmZ+"
ARC-Seal: i=1; a=rsa-sha256; t=1749523969; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Zw995U7Cgy5FNalCAfUuS467i83+FWCw1aoNgSxNfjbe28OdyPFk8eSTo/FpfPpV9kWLh58s1wRCyUEmrdgAm7rEGEeZ0yITUOrDQNW5YRIesM6PC5FCOzstKh6rcCMHwzvupTA5ii2tqHSpn/xCpy4FbALT21JwpEefx1VdxAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1749523969; h=Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=5YFS9keRzq2B3hHRO6FQiFS8FqNmeF7xgri3BeLoeuc=; 
	b=Ozi3vYbKq9YaM6OUShZOwZQsrru6uwKgkUCVMeimmQvWcLE+Imv262Y12800cko4u6x020DTIYg8E8dFgdXlaEn4THpuTVbAnHxltzPQ2v9wYpRETBsBusYDl3v1Ms3Xyl14SXvD9hbp6iN/8jlQVuD6dw5CUShVGDATVEt/HlI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1749523969;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=5YFS9keRzq2B3hHRO6FQiFS8FqNmeF7xgri3BeLoeuc=;
	b=kXmSkmZ+KunT/8ztuPX3fYZgpSdDCeBhuuQKj7b5ZlM3iqh/5Qr7quTe+OHihIG1
	HTUHoXBFQ333k1PdGNTL4C90DH2DewDhwhGVS3mNwNHM8YaAG+wOJabOL4qusud9FT9
	ucl+KGjtjxXBRqc0s2fyosm2ZyoOym6BLCTUa0Ns=
Received: by mx.zohomail.com with SMTPS id 1749523966637227.93282781336768;
	Mon, 9 Jun 2025 19:52:46 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: "Darrick J. Wong" <djwong@kernel.org>,
	"Zorro Lang" <zlang@redhat.com>,
	"fstests" <fstests@vger.kernel.org>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Subject: [PATCH V2] generic/738 : add missing _fixed_by_git_commit line to the test
Date: Tue, 10 Jun 2025 10:52:42 +0800
Message-ID: <20250610025242.11403-1-me@linux.beauty>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

Add the usual  _fixed_by_kernel_commit  line so the user can find
that the hang is cured by

    ab23a7768739  ("xfs: per-cpu deferred inode inactivation queues")

The hung task call trace would be as below:
[   20.535519]       Not tainted 5.14.0-rc4+ #27
[   20.537855] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   20.539420] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
[   20.540892] Call Trace:
[   20.541424]  __schedule+0x22d/0x6c0
[   20.542128]  schedule+0x3f/0xa0
[   20.542751]  percpu_rwsem_wait+0x100/0x130
[   20.543516]  ? percpu_free_rwsem+0x30/0x30
[   20.544259]  __percpu_down_read+0x44/0x50
[   20.545002]  xfs_trans_alloc+0x19a/0x1f0
[   20.545747]  xfs_free_eofblocks+0x47/0x100
[   20.546519]  xfs_inode_mark_reclaimable+0x115/0x160
[   20.547398]  destroy_inode+0x36/0x70
[   20.548077]  prune_icache_sb+0x79/0xb0
[   20.548789]  super_cache_scan+0x159/0x1e0
[   20.549536]  shrink_slab.constprop.0+0x1b1/0x370
[   20.550363]  drop_slab_node+0x1d/0x40
[   20.551041]  drop_slab+0x30/0x70
[   20.551600]  drop_caches_sysctl_handler+0x6b/0x80
[   20.552311]  proc_sys_call_handler+0x12b/0x250
[   20.552931]  new_sync_write+0x117/0x1b0
[   20.553462]  vfs_write+0x1bd/0x250
[   20.553914]  ksys_write+0x5a/0xd0
[   20.554381]  do_syscall_64+0x3b/0x90
[   20.554854]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   20.555481] RIP: 0033:0x7f90928d3300
[   20.555946] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   20.556853] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
[   20.557686] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
[   20.558524] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
[   20.559335] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[   20.560154] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0

localhost login: [   30.773559] INFO: task 738:7124 blocked for more than 20 seconds.
[   30.775236]       Not tainted 5.14.0-rc4+ #27
[   30.777449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   30.779729] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
[   30.781267] Call Trace:
[   30.781850]  __schedule+0x22d/0x6c0
[   30.782618]  schedule+0x3f/0xa0
[   30.783297]  percpu_rwsem_wait+0x100/0x130
[   30.784110]  ? percpu_free_rwsem+0x30/0x30
[   30.785085]  __percpu_down_read+0x44/0x50
[   30.786071]  xfs_trans_alloc+0x19a/0x1f0
[   30.786877]  xfs_free_eofblocks+0x47/0x100
[   30.787727]  xfs_inode_mark_reclaimable+0x115/0x160
[   30.788708]  destroy_inode+0x36/0x70
[   30.789395]  prune_icache_sb+0x79/0xb0
[   30.790056]  super_cache_scan+0x159/0x1e0
[   30.790712]  shrink_slab.constprop.0+0x1b1/0x370
[   30.791381]  drop_slab_node+0x1d/0x40
[   30.791924]  drop_slab+0x30/0x70
[   30.792469]  drop_caches_sysctl_handler+0x6b/0x80
[   30.793328]  proc_sys_call_handler+0x12b/0x250
[   30.793948]  new_sync_write+0x117/0x1b0
[   30.794471]  vfs_write+0x1bd/0x250
[   30.794941]  ksys_write+0x5a/0xd0
[   30.795414]  do_syscall_64+0x3b/0x90
[   30.795928]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   30.796595] RIP: 0033:0x7f90928d3300
[   30.797090] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   30.798033] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
[   30.798852] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
[   30.799703] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
[   30.800833] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[   30.801764] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
[   30.802628] INFO: task xfs_io:7130 blocked for more than 10 seconds.
[   30.803421]       Not tainted 5.14.0-rc4+ #27
[   30.803985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   30.804979] task:xfs_io          state:D stack:13712 pid: 7130 ppid:  7127 flags:0x00000002
[   30.806013] Call Trace:
[   30.806399]  __schedule+0x22d/0x6c0
[   30.806867]  schedule+0x3f/0xa0
[   30.807334]  rwsem_down_write_slowpath+0x1d8/0x510
[   30.808018]  thaw_super+0xd/0x20
[   30.808748]  __x64_sys_ioctl+0x5d/0xb0
[   30.809292]  do_syscall_64+0x3b/0x90
[   30.809797]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   30.810454] RIP: 0033:0x7ff1b48c5d1b
[   30.810943] RSP: 002b:00007fff0bf88ac0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   30.811874] RAX: ffffffffffffffda RBX: 000055b93ae5fc40 RCX: 00007ff1b48c5d1b
[   30.812743] RDX: 00007fff0bf88b2c RSI: ffffffffc0045878 RDI: 0000000000000003
[   30.813583] RBP: 000055b93ae60fe0 R08: 0000000000000000 R09: 0000000000000000
[   30.814497] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[   30.815413] R13: 000055b93a3a94e9 R14: 0000000000000000 R15: 000055b93ae61150

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes since v1: use _fixed_by_kernel_commit helper as suggested by
Zorro

 tests/generic/738 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/738 b/tests/generic/738
index 6f1ea7f8..b0503025 100755
--- a/tests/generic/738
+++ b/tests/generic/738
@@ -9,6 +9,9 @@
 . ./common/preamble
 _begin_fstest auto quick freeze
 
+[ "$FSTYP" = "xfs" ] && _fixed_by_kernel_commit ab23a7768739 \
+	"xfs: per-cpu deferred inode inactivation queues"
+
 _cleanup()
 {
 	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
-- 
2.49.0

