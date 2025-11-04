Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3128311C05;
	Tue,  4 Nov 2025 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762262854; cv=none; b=poD1uYaFaN18Hulzd7X43458gpyWgsqTqK3KI1DM0WMOwL+OPTsNMFUYOXq1K03ADlUFdH0pp7QJK70TWeYoa8DMemqmZpBjWfsuFkmvyh0Fw7BlC7ainVMQmNkX/GITVRZbzoCcXvpff6LJ+rDJMXIgZ15766Ukqt0ONfJ9Iyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762262854; c=relaxed/simple;
	bh=Pwph7qlJ6RP61lhf+JcGyvDbp3/fDLjiE69bRj4HhRU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WO6grk1lK55o4Lc4ZlwglU6wEElaFUljqvawlwzjF1r/4M5K5ZwvvLpKkaF4i/roUtMxMJnbGqnB90jfCh7lk8EqMb25kKFeUuF4eN0Cqf1J+m8A4EJfHbwELJFKlF6aMSuxVAMP2sGJ6Wr2KU2Mmi2VQbhJvWlPUh0vj4bzWLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PssDq1/Z; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PssDq1/Z"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hMhoA52Ynil/YcSuaC3sa8QaekhkiW6M0OaFUF7625c=;
	b=PssDq1/ZwnbcUe69WkXuEKFR6PwzyAV+YiE3EwmZEFcsIAHU6X4yG0WjgRl1MkmDb1f/XGSjC
	i4HtMVmWSWTCbwRasKj9UbJQMJAjkVYWRWCnfCM6r0pkvT17otkzT4lKSS+MbUqRzqmxITvjC2/
	A2lnAUorgcnKKMMgLkilRbQ=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4d18Nf6C1cz1T4HG;
	Tue,  4 Nov 2025 21:26:10 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4ABF71402F2;
	Tue,  4 Nov 2025 21:27:23 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 21:27:23 +0800
Received: from syn-076-053-033-115.biz.spectrum.com (10.50.87.129) by
 kwepemn100013.china.huawei.com (7.202.194.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 21:27:22 +0800
From: Long Li <leo.lilong@huawei.com>
To: <xfs-stable@lists.linux.dev>
CC: <catherine.hoang@oracle.com>, <leah.rumancik@gmail.com>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<kent.overstreet@linux.dev>, <gregkh@linuxfoundation.org>,
	<yangerkun@huawei.com>
Subject: [PATCH RFC 6.1/6.6 CANDIDATE] mm: introduce memalloc_flags_{save,restore}
Date: Tue, 4 Nov 2025 21:18:57 +0800
Message-ID: <20251104131857.1587584-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn100013.china.huawei.com (7.202.194.116)

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 3f6d5e6a468d02676244b868b210433831846127 upstream.

Our proliferation of memalloc_*_{save,restore} APIs is getting a bit
silly, this adds a generic version and converts the existing
save/restore functions to wrappers.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: linux-mm@kvack.org
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
We encountered a deadlock issue in our internal version caused by
PF_MEMALLOC_NOFS being unexpectedly cleared during inode inactive
transaction. This issue appears to still exist in 6.1/6.6 lts version.

In the mainline kernel, before commit [2] f2e812c1522d ("xfs: don't use
current->journal_info") was merged, we relied on current->journal_info to
check for transaction recursion. During transaction rollback/commit, only
the last transaction commit would call xfs_trans_clear_context(tp) to
restore the nofs flag, which worked correctly.

After this patch was merged, we no longer check for transaction recursion,
so each transaction rollback/commit calls xfs_trans_clear_context(tp) to
restore the nofs flag. At this point, tp->t_pflags is set to 0 (except for
the last one tp), and memalloc_nofs_restore(0) will not clear the
PF_MEMALLOC_NOFS flag during transaction rollback, this is also correct.

However, this also implies that the above patch depends on commit [1]
3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}"), because that
patch modified the semantics of the memalloc_nofs_{save,restore} interface,
and only after this modification can it ensure that memalloc_nofs_restore(0)
won't clear the PF_MEMALLOC_NOFS flag.

In our 6.1/6.6 LTS versions, we directly backported commit [2] without
backporting commit [1], which leads to confusion with the PF_MEMALLOC_NOFS
flag during transaction rollback, for example as follows:

xfs_inodegc_worker
    nofs_flag = memalloc_nofs_save();
        //set PF_MEMALLOC_NOFS in current->flags 
        xfs_inactive
            xfs_attr_inactive(ip)
                xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans)
                    xfs_trans_set_context(tp)
                    //tp->t_pflags ==> 1
                xfs_trans_commit(trans)
                    __xfs_trans_commit(tp)
                        xfs_defer_trans_roll
                            xfs_trans_roll
                                *tpp = xfs_trans_dup(trans)
                                    xfs_trans_switch_context(tp, ntp)
                                        new_tp->t_pflags = old_tp->t_pflags;
                                        //new_tp->t_pflags ==> 1
                                        old_tp->t_pflags = 0; 
                                        //old_tp->t_pflags ==> 0
                                __xfs_trans_commit(trans)  //commit old_tp
                                    xfs_trans_free(tp); //free old_tp 
                                        xfs_trans_clear_context(tp) 
                                            memalloc_nofs_restore(0)
                                                //clear PF_MEMALLOC_NOFS in current->flags
                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        < commit new_tp >
                        xfs_trans_free(tp)  //free new_tp
                            memalloc_nofs_restore(1)  
                                //set PF_MEMALLOC_NOFS in current->flags
    memalloc_nofs_restore(nofs_flag);
        //clear PF_MEMALLOC_NOFS in current->flags

So backport commit [1] 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}")
to 6.1/6.6 lts.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3f6d5e6a468d02676244b868b210433831846127
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f2e812c1522dab847912309b00abcc762dd696da

 include/linux/sched/mm.h | 43 ++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 8d89c8c4fac1..10792d374785 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -306,6 +306,24 @@ static inline void might_alloc(gfp_t gfp_mask)
 	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 }
 
+/**
+ * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ *
+ * This allows PF_* flags to be conveniently added, irrespective of current
+ * value, and then the old version restored with memalloc_flags_restore().
+ */
+static inline unsigned memalloc_flags_save(unsigned flags)
+{
+	unsigned oldflags = ~current->flags & flags;
+	current->flags |= flags;
+	return oldflags;
+}
+
+static inline void memalloc_flags_restore(unsigned flags)
+{
+	current->flags &= ~flags;
+}
+
 /**
  * memalloc_noio_save - Marks implicit GFP_NOIO allocation scope.
  *
@@ -319,9 +337,7 @@ static inline void might_alloc(gfp_t gfp_mask)
  */
 static inline unsigned int memalloc_noio_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOIO;
-	current->flags |= PF_MEMALLOC_NOIO;
-	return flags;
+	return memalloc_flags_save(PF_MEMALLOC_NOIO);
 }
 
 /**
@@ -334,7 +350,7 @@ static inline unsigned int memalloc_noio_save(void)
  */
 static inline void memalloc_noio_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
+	memalloc_flags_restore(flags);
 }
 
 /**
@@ -350,9 +366,7 @@ static inline void memalloc_noio_restore(unsigned int flags)
  */
 static inline unsigned int memalloc_nofs_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOFS;
-	current->flags |= PF_MEMALLOC_NOFS;
-	return flags;
+	return memalloc_flags_save(PF_MEMALLOC_NOFS);
 }
 
 /**
@@ -365,32 +379,27 @@ static inline unsigned int memalloc_nofs_save(void)
  */
 static inline void memalloc_nofs_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
+	memalloc_flags_restore(flags);
 }
 
 static inline unsigned int memalloc_noreclaim_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC;
-	current->flags |= PF_MEMALLOC;
-	return flags;
+	return memalloc_flags_save(PF_MEMALLOC);
 }
 
 static inline void memalloc_noreclaim_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC) | flags;
+	memalloc_flags_restore(flags);
 }
 
 static inline unsigned int memalloc_pin_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_PIN;
-
-	current->flags |= PF_MEMALLOC_PIN;
-	return flags;
+	return memalloc_flags_save(PF_MEMALLOC_PIN);
 }
 
 static inline void memalloc_pin_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_PIN) | flags;
+	memalloc_flags_restore(flags);
 }
 
 #ifdef CONFIG_MEMCG
-- 
2.39.2

