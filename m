Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B143C49C
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708357286; cv=none; b=Olma8ESpBRDsIvhQBUgYCuQe+23j3jV1iV3GP88pgHSgk0vG3ulXjtRPxMQWoxnxKEnJx/WYi5jD3ZDJit4onEFSIZMtyGkkAkwqQFtAEp4XFTi25oPDPdbkIkbuA03RxrbQ1HIKQ/mhT3cA3TMDSgAwkFVEr0ERjBwe2E2cHMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708357286; c=relaxed/simple;
	bh=sju9RgiyeehgwIC+oaHBYcGxqRlkTI2E4LBAlfxQiBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDa52fQqp1TSO4krgbZ11E9z9ChMHmWS/pzzoPA5wKgze3YO4HiOLUWFXuR7vUpkKZ1pojcTDsNtErzz2mkzRHZZ2Ci5ccdueOfjQPy2+99NwiIZuE3z8EkGVv8lrY62L5MPjZkz43etY9IQDj+bellS4oHrGUvdV1AZCcuLB+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q/ga0ex8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q/ga0ex8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=UtEZLuznB6GoA1lkgVgJwagIax79SHTr/2tUXSpHVpU=; b=q/ga0ex8hcDqI+zQdA6k6hRhgb
	VWDg0W4V1+Y20ifkAi2/AdIL5YucjkpUglEmXc/B3BQQD6c7TyE7KL67lafmCB7A6Kk0RKXOPP1xQ
	EeE+kzPUyFRvV+/Scgz/eo29ArQIAmWDaP6CcTOwZMfdhl4+vYCycuDXGuCYlfeJ7VwlwpZf31Bl7
	ABXuqUIi/agkzzOEzc4VorhyKbuIfQJY56GJoUQz5xbAmmDLoXLDOTqrZAAKzRu+K3OmRs3oIlSzd
	mVhj02GNFWQ1lpKlIE7eJ3n6hTz/fOGW7yfiKg66ZVfPl6nOqnitCddCl8uGExo8v4P0skHhgJJM7
	Dy2fo69A==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rc5lg-0000000DA40-3WfK;
	Mon, 19 Feb 2024 15:41:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-xfs@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v6 1/3] locking: Add rwsem_assert_held() and rwsem_assert_held_write()
Date: Mon, 19 Feb 2024 15:41:11 +0000
Message-ID: <20240219154115.3136901-2-willy@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219154115.3136901-1-willy@infradead.org>
References: <20240219154115.3136901-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modelled after lockdep_assert_held() and lockdep_assert_held_write(),
but are always active, even when lockdep is disabled.  Of course, they
don't test that _this_ thread is the owner, but it's sufficient to catch
many bugs and doesn't incur the same performance penalty as lockdep.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/rwbase_rt.h |  9 ++++++--
 include/linux/rwsem.h     | 46 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/rwbase_rt.h b/include/linux/rwbase_rt.h
index 1d264dd08625..29c4e4f243e4 100644
--- a/include/linux/rwbase_rt.h
+++ b/include/linux/rwbase_rt.h
@@ -26,12 +26,17 @@ struct rwbase_rt {
 	} while (0)
 
 
-static __always_inline bool rw_base_is_locked(struct rwbase_rt *rwb)
+static __always_inline bool rw_base_is_locked(const struct rwbase_rt *rwb)
 {
 	return atomic_read(&rwb->readers) != READER_BIAS;
 }
 
-static __always_inline bool rw_base_is_contended(struct rwbase_rt *rwb)
+static inline void rw_base_assert_held_write(const struct rwbase_rt *rwb)
+{
+	WARN_ON(atomic_read(&rwb->readers) != WRITER_BIAS);
+}
+
+static __always_inline bool rw_base_is_contended(const struct rwbase_rt *rwb)
 {
 	return atomic_read(&rwb->readers) > 0;
 }
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 9c29689ff505..4f1c18992f76 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -66,14 +66,24 @@ struct rw_semaphore {
 #endif
 };
 
-/* In all implementations count != 0 means locked */
+#define RWSEM_UNLOCKED_VALUE		0UL
+#define RWSEM_WRITER_LOCKED		(1UL << 0)
+#define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
+
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return atomic_long_read(&sem->count) != 0;
+	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
 }
 
-#define RWSEM_UNLOCKED_VALUE		0L
-#define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
+static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
+}
+
+static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
+}
 
 /* Common initializer macros and functions */
 
@@ -152,11 +162,21 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-static __always_inline int rwsem_is_locked(struct rw_semaphore *sem)
+static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 {
 	return rw_base_is_locked(&sem->rwbase);
 }
 
+static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(!rwsem_is_locked(sem));
+}
+
+static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+{
+	rw_base_assert_held_write(sem);
+}
+
 static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
 	return rw_base_is_contended(&sem->rwbase);
@@ -169,6 +189,22 @@ static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
  * the RT specific variant.
  */
 
+static inline void rwsem_assert_held(const struct rw_semaphore *sem)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lockdep_assert_held(sem);
+	else
+		rwsem_assert_held_nolockdep(sem);
+}
+
+static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lockdep_assert_held_write(sem);
+	else
+		rwsem_assert_held_write_nolockdep(sem);
+}
+
 /*
  * lock for reading
  */
-- 
2.43.0

