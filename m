Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B39367F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BD1D8F8054
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:24 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OZ4FLD589wKGqq6O (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:23 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 13/19] MM: set PF_FSTRANS while allocating per-cpu memory to
	avoid deadlock.
Message-ID: <20140416040336.10604.67456.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

lockdep reports a locking chain

  sk_lock-AF_INET --> rtnl_mutex --> pcpu_alloc_mutex

As sk_lock may be needed to reclaim memory, allowing that
reclaim while pcu_alloc_mutex is held can lead to deadlock.
So set PF_FSTRANS while it is help to avoid the FS reclaim.

pcpu_alloc_mutex can be taken when rtnl_mutex is held:

    [<ffffffff8117f979>] pcpu_alloc+0x49/0x960
    [<ffffffff8118029b>] __alloc_percpu+0xb/0x10
    [<ffffffff8193b9f7>] loopback_dev_init+0x17/0x60
    [<ffffffff81aaf30c>] register_netdevice+0xec/0x550
    [<ffffffff81aaf785>] register_netdev+0x15/0x30

Signed-off-by: NeilBrown <neilb@suse.de>
---
 mm/percpu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 036cfe07050f..77dd24032f41 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -712,6 +712,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	int slot, off, new_alloc;
 	unsigned long flags;
 	void __percpu *ptr;
+	unsigned int pflags;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
@@ -720,6 +721,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	}
 
 	mutex_lock(&pcpu_alloc_mutex);
+	current_set_flags_nested(&pflags, PF_FSTRANS);
 	spin_lock_irqsave(&pcpu_lock, flags);
 
 	/* serve reserved allocations from the reserved chunk if available */
@@ -801,6 +803,7 @@ area_found:
 		goto fail_unlock;
 	}
 
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
 	mutex_unlock(&pcpu_alloc_mutex);
 
 	/* return address relative to base address */
@@ -811,6 +814,7 @@ area_found:
 fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 fail_unlock_mutex:
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
 	mutex_unlock(&pcpu_alloc_mutex);
 	if (warn_limit) {
 		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
