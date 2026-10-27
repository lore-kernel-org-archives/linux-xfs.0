Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.155.198.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793100454;
	b=IfrZJ7zxpKShgsNGHUz6/BL7ZNAQ7Z8YmN6Ga4V0STkCiRCBikFJTPJW4ZD/1GxHfd5w
	 BMf2wi73wGbgNf60OOFlhEpwpyFCNbbEF1YAdkUZfo1vIJqSdL27xK5NnVkuemW/ui995
	 WacGWEMgdEUGQfo5thAd6im0VJ4jyspqf6AAqiX2NNUnVA8LWP/uBMORlHCfXaSeVeYva
	 wsjifPYFA/Nm0v/ID/9S63PfvQDqSxFgoW/aj2CSuEB6GFd6GII9qIe05bKykzpB5vdyl
	 yz4VlT7x833X775T+PmiMi3UjXzxE+o+TVamQ0VUHgp2Cin2emolRJengXr2DLQXC5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793100454;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=2HsKdK9P6x+a2bQCUw3wOJJDVhpLfIWOP/r/ePtVHGk=;
	b=VQLdJXFP4WLqj/eV22XUF98J7NRNBHl3Z0+2pJswuwx4zRpn6Ls1Pr0q1vqCGj7BkwdZ
	 7jfTVr/Au7ZDUet9zMYWYDYNwZHD+giaCdoVGpPEce1yxg0I5mW9BOmW5RaUUzvUMtBIp
	 9+oZsTJqeBosDpx/eOp53BKjqtsAqZ4ALToDhXPqU8d9FmgCdHsQ9MHPBs2gsMpZ8TFSs
	 ix/H6V0iaUi0yyk4P+27lrnTwr/mn3RIkYFQRlfPs3RtrAB72n98Nl7PidaPzGROP54BW
	 Sfb9BjZRxcngk6ARlsneYdILaPwrpyfk+f/SEcvap3sxXMsl/gwRAwkXW02a1F5fduw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.it;
	spf=pass smtp.mailfrom=amazon.it;
	dkim=pass header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=HzerxRDq;
	arc=none smtp.remote-ip=35.155.198.111
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF27606A339;
	Tue, 27 Oct 2026 11:27:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AF27606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=HzerxRDq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793100454; x=1824636454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2HsKdK9P6x+a2bQCUw3wOJJDVhpLfIWOP/r/ePtVHGk=;
  b=HzerxRDqQLBB/gAd+f9/iLi9mrLeBGOvCtFCecRUfpkxyTn1WSlmjw1q
   UWhP6E0F9z5g3FAATO0RPQdKpHBvjkPElyCGLwLRbbNrzJBTUFlxBcBba
   QsIOnbZLutEraaqccDX4K6dwXFpQ5Ev6fJB8O8cEBFzaWFzjmHWQ4uD6F
   GTvjE/qz86VHSxRA4J9BQqBrGfWfo3tM4TLK2gBUznBGDcFKTgH3y/x88
   8Nlj270kjUsCBPmpD+d0UZ28oOKcAlmFDMit8L3q3N+7IuVXRb5oD/LOk
   3nrKoDR5yGjYuIOpzVw/SN0ydq7G0GGM9iNe6BGlVgrqGjkAWSX6uuLyB
   w==;
X-CSE-ConnectionGUID: 385GSDEWQP6GfoP9TG5oPQ==
X-CSE-MsgGUID: wuJCmHMiTHui2Zvf77Ci4g==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32251280"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:27:31 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:23464]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.230:2525] with esmtp (Farcaster)
 id c8175336-d6c7-4fea-bc92-125eeab3bbca; Tue, 27 Oct 2026 11:27:30 +0000 (UTC)
X-Farcaster-Flow-ID: c8175336-d6c7-4fea-bc92-125eeab3bbca
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 11:27:30 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 11:27:24 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <ryan.roberts@arm.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <dipietro.salvatore@gmail.com>, <rvvandan@amazon.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linkinjeon@kernel.org>, <sj1557.seo@samsung.com>, <yuezhang.mo@sony.com>,
	<miklos@szeredi.hu>, <agruenba@redhat.com>, <djwong@kernel.org>,
	<hyc.lee@gmail.com>, <almaz.alexandrovich@paragon-software.com>,
	<cem@kernel.org>, <dlemoal@kernel.org>, <naohiro.aota@wdc.com>,
	<jth@kernel.org>, <willy@infradead.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <ritesh.list@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <linux-xfs@vger.kernel.org>, <ntfs@lists.linux.dev>,
	<ntfs3@lists.linux.dev>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] mm: add infrastructure for per-dirty-page accounting
Date: Tue, 27 Oct 2026 11:27:01 +0000
Message-ID: <20261027112702.3747009-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
References: <20261027112702.3747009-1-dipiets@amazon.it>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add the mm-side machinery that lets a filesystem charge the dirty
counters (NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE) per
dirty page instead of per whole folio, without yet enabling it for
any filesystem.

Add an AS_DIRTY_PER_BLOCK mapping flag with
mapping_set_dirty_per_block()/mapping_dirty_per_block() helpers, an
accounted_dirty_pages() address_space_operations callback, and an
@accounted argument to __folio_mark_dirty() (with filemap_dirty_folio()
split into __filemap_dirty_folio()) so the generic per-folio charge can
be suppressed for folios a filesystem has already accounted.

folio_accounted_dirty_pages() dispatches through the new a_ops callback,
falling back to folio_nr_pages() when no filesystem opts in, and
folio_account_cleaned() and folio migration use it in place of
folio_nr_pages().  folio_clear_dirty_for_io() leaves the charge of
per-block folios to the filesystem.  No filesystem sets the flag or
registers the callback yet, so this commit is a no-op on its own.

This is a prerequisite for the following iomap patch, which fixes the
over-accounting; both are needed for stable.

Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Reviewed-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
---
 fs/buffer.c             |  4 +-
 include/linux/fs.h      |  7 ++++
 include/linux/pagemap.h | 20 ++++++++-
 mm/internal.h           |  3 ++
 mm/migrate.c            | 17 ++++++--
 mm/page-writeback.c     | 91 ++++++++++++++++++++++++++++++++---------
 6 files changed, 115 insertions(+), 27 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ed966fa73b1b..7ed5250dda9d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -693,7 +693,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 	spin_unlock(&mapping->i_private_lock);
 
 	if (newly_dirty)
-		__folio_mark_dirty(folio, mapping, 1);
+		__folio_mark_dirty(folio, mapping, 1, false);
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1011,7 +1011,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
 		if (!folio_test_set_dirty(folio)) {
 			mapping = folio->mapping;
 			if (mapping)
-				__folio_mark_dirty(folio, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0, false);
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index deb411e86661..5abd2af50b59 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -407,6 +407,13 @@ struct address_space_operations {
 	/* Mark a folio dirty.  Return true if this dirtied it */
 	bool (*dirty_folio)(struct address_space *, struct folio *);
 
+	/*
+	 * Pages of the folio currently charged to the dirty counters, for
+	 * filesystems that account dirty state at sub-folio (per-block)
+	 * granularity.
+	 */
+	long (*accounted_dirty_pages)(struct folio *folio);
+
 	void (*readahead)(struct readahead_control *);
 
 	int (*write_begin)(const struct kiocb *, struct address_space *mapping,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..5bbcd9da1a6b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_DIRTY_PER_BLOCK = 11, /* fs accounts dirty pages, not whole folios */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -304,6 +305,20 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
+/*
+ * Set by filesystems that charge the mm dirty counters per dirty page rather
+ * than per folio, so the generic paths must not also account whole folios.
+ */
+static inline void mapping_set_dirty_per_block(struct address_space *mapping)
+{
+	set_bit(AS_DIRTY_PER_BLOCK, &mapping->flags);
+}
+
+static inline bool mapping_dirty_per_block(const struct address_space *mapping)
+{
+	return test_bit(AS_DIRTY_PER_BLOCK, &mapping->flags);
+}
+
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
 	return test_bit(AS_STABLE_WRITES, &mapping->flags);
@@ -1311,7 +1326,10 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
-void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
+void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
+		int warn, bool accounted);
+bool __filemap_dirty_folio(struct address_space *mapping, struct folio *folio,
+		bool accounted);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..4647aca5fe8d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -40,6 +40,9 @@ void *workingset_eviction(struct folio *folio,
 void workingset_refault(struct folio *folio, void *shadow);
 void workingset_activation(struct folio *folio);
 
+/* mm/page-writeback.c */
+long folio_accounted_dirty_pages(struct folio *folio);
+
 /* mm/folio.c */
 void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..0e7b7834a9fd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -588,6 +588,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	long nr = folio_nr_pages(folio);
+	long nr_dirty = nr;
 
 	if (!mapping) {
 		/* Take off deferred split queue while frozen and memcg set */
@@ -614,6 +615,14 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	oldzone = folio_zone(folio);
 	newzone = folio_zone(newfolio);
 
+	/*
+	 * Only what was charged moves between the zones below, which may be less
+	 * than the whole folio.  Sample it outside the i_pages lock, as it walks
+	 * the per-block state, and while the folio is still dirty.
+	 */
+	if (folio_test_dirty(folio))
+		nr_dirty = folio_accounted_dirty_pages(folio);
+
 	if (folio_test_swapcache(folio))
 		ci = swap_cluster_get_and_lock_irq(folio);
 	else
@@ -708,10 +717,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		}
 #endif
 		if (dirty && mapping_can_writeback(mapping)) {
-			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
-			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
-			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
-			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
+			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr_dirty);
+			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr_dirty);
+			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr_dirty);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr_dirty);
 		}
 		rcu_read_unlock();
 	}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce36..6b4a8b6ad34c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2601,7 +2601,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
  * NOTE: This relies on being atomic wrt interrupts.
  */
 static void folio_account_dirtied(struct folio *folio,
-		struct address_space *mapping)
+		struct address_space *mapping, bool accounted)
 {
 	struct inode *inode = mapping->host;
 
@@ -2614,14 +2614,21 @@ static void folio_account_dirtied(struct folio *folio,
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
-		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
-		if (folio_test_dropbehind(folio))
-			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
-		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
-		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
-		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
-		wb_stat_mod(wb, WB_DIRTIED, nr);
-		task_io_account_write(nr * PAGE_SIZE);
+		/*
+		 * @accounted means the filesystem charged these per dirty page
+		 * already; the rate limiters below stay per-folio.  Keep in sync
+		 * with folio_account_cleaned() and folio_clear_dirty_for_io().
+		 */
+		if (!accounted) {
+			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
+			__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+			wb_stat_mod(wb, WB_RECLAIMABLE, nr);
+			__node_stat_mod_folio(folio, NR_DIRTIED, nr);
+			wb_stat_mod(wb, WB_DIRTIED, nr);
+			task_io_account_write(nr * PAGE_SIZE);
+		}
 		current->nr_dirtied += nr;
 		__this_cpu_add(bdp_ratelimits, nr);
 
@@ -2629,13 +2636,41 @@ static void folio_account_dirtied(struct folio *folio,
 	}
 }
 
+/**
+ * folio_accounted_dirty_pages - pages of @folio charged to the dirty counters
+ * @folio: folio to query
+ *
+ * Use this rather than folio_nr_pages() when moving or discharging a folio's dirty
+ * accounting, as a folio is not necessarily charged for all of its pages.  Walks
+ * per-block state that truncation frees, so the caller must hold the folio lock.
+ *
+ * Return: the whole folio for the usual per-folio accounting, otherwise only the
+ * pages holding a dirty block, and zero once those have been discharged.
+ */
+long folio_accounted_dirty_pages(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	if (mapping && mapping_dirty_per_block(mapping) && folio->private &&
+	    mapping->a_ops->accounted_dirty_pages)
+		return mapping->a_ops->accounted_dirty_pages(folio);
+	return folio_nr_pages(folio);
+}
+
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
  */
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
-	long nr = folio_nr_pages(folio);
+	/*
+	 * Discharge exactly what was charged; zero if the fs already did it.
+	 * Counters below mirror folio_account_dirtied().
+	 */
+	long nr = folio_accounted_dirty_pages(folio);
+
+	if (!nr)
+		return;
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
 	if (folio_test_dropbehind(folio))
@@ -2661,7 +2696,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn)
+			     int warn, bool accounted)
 {
 	unsigned long flags;
 
@@ -2674,7 +2709,7 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
-		folio_account_dirtied(folio, mapping);
+		folio_account_dirtied(folio, mapping, accounted);
 		__xa_set_mark(&mapping->i_pages, folio->index,
 			      PAGECACHE_TAG_DIRTY);
 	}
@@ -2700,12 +2735,13 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
  * simply hold the folio lock, but e.g. zap_pte_range() calls with the
  * folio mapped and the pte lock held, which also locks out truncation.
  */
-bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
+bool __filemap_dirty_folio(struct address_space *mapping, struct folio *folio,
+		bool accounted)
 {
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio), accounted);
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
@@ -2713,6 +2749,12 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	}
 	return true;
 }
+EXPORT_SYMBOL_GPL(__filemap_dirty_folio);
+
+bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
+{
+	return __filemap_dirty_folio(mapping, folio, false);
+}
 EXPORT_SYMBOL(filemap_dirty_folio);
 
 /**
@@ -2912,12 +2954,21 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
-			long nr = folio_nr_pages(folio);
-			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-			if (folio_test_dropbehind(folio))
-				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			/*
+			 * Per-block folios keep their dirty bits, and the charge,
+			 * until the fs writes them back.  Folios of such a mapping
+			 * that never got per-block state were charged whole, so
+			 * they discharge here as usual.
+			 */
+			if (!mapping_dirty_per_block(mapping) || !folio->private) {
+				long nr = folio_nr_pages(folio);
+
+				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+				if (folio_test_dropbehind(folio))
+					wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
+				zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			}
 			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



