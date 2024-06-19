Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB9F13F426;
	Wed, 19 Jun 2024 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802553; cv=none; b=lx9mPLzb6H1mKqNUM0xQbwfPATmRNdktxM/DoeAEOVmo+7jDs2dFZ+zDK3f3e8PRCgLa34CNfaX8XRdplCr6t+9DzuRn2zovLP5/P4PiAF39ETxC8L756XLcFGcck5b48r/LoHBRY4GBCEYSgFx+3MAqGLzYnR9JXr1/9sMe7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802553; c=relaxed/simple;
	bh=ns9a4Bk17N1wCRRvvsiyJMeBaBVJcLWOHgiWFRWp+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwLnXV5aOpgqFEix+SwDsmnFIxk7qxUnOszvzZT20BubSl6BXtcxN/BTPaBEGYsJ3SG7r3W8GbBM+QrrpKztxqh+joqccCq/c821Ki21pY5CAi14dMNpyuC0DCnGO0m9pQRoaSC54Yh/BGqsj8f1eVlTi9ZzlNK6Ip8bP3/LQgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9D45IZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9D45IZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BE5C2BBFC;
	Wed, 19 Jun 2024 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802553;
	bh=ns9a4Bk17N1wCRRvvsiyJMeBaBVJcLWOHgiWFRWp+1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9D45IZPvLi3BSzpMXBIuouu2qKayiapGOxqzPEGakOpvTa6l2N1fHD176s16Z1s9
	 qgTxMuEMY9ugdHzqX2fntcWem5gxPKP2kUQ6u5V8mNtgsTX/vnVo4WWwzydwqeEGRj
	 TSYZsBA4+1ZeGAApa//0rrU5rLq0GWNK5c96LWGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 236/267] xfs: dont use current->journal_info
Date: Wed, 19 Jun 2024 14:56:27 +0200
Message-ID: <20240619125615.380778326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit f2e812c1522dab847912309b00abcc762dd696da upstream.

syzbot reported an ext4 panic during a page fault where found a
journal handle when it didn't expect to find one. The structure
it tripped over had a value of 'TRAN' in the first entry in the
structure, and that indicates it tripped over a struct xfs_trans
instead of a jbd2 handle.

The reason for this is that the page fault was taken during a
copy-out to a user buffer from an xfs bulkstat operation. XFS uses
an "empty" transaction context for bulkstat to do automated metadata
buffer cleanup, and so the transaction context is valid across the
copyout of the bulkstat info into the user buffer.

We are using empty transaction contexts like this in XFS to reduce
the risk of failing to release objects we reference during the
operation, especially during error handling. Hence we really need to
ensure that we can take page faults from these contexts without
leaving landmines for the code processing the page fault to trip
over.

However, this same behaviour could happen from any other filesystem
that triggers a page fault or any other exception that is handled
on-stack from within a task context that has current->journal_info
set.  Having a page fault from some other filesystem bounce into XFS
where we have to run a transaction isn't a bug at all, but the usage
of current->journal_info means that this could result corruption of
the outer task's journal_info structure.

The problem is purely that we now have two different contexts that
now think they own current->journal_info. IOWs, no filesystem can
allow page faults or on-stack exceptions while current->journal_info
is set by the filesystem because the exception processing might use
current->journal_info itself.

If we end up with nested XFS transactions whilst holding an empty
transaction, then it isn't an issue as the outer transaction does
not hold a log reservation. If we ignore the current->journal_info
usage, then the only problem that might occur is a deadlock if the
exception tries to take the same locks the upper context holds.
That, however, is not a problem that setting current->journal_info
would solve, so it's largely an irrelevant concern here.

IOWs, we really only use current->journal_info for a warning check
in xfs_vm_writepages() to ensure we aren't doing writeback from a
transaction context. Writeback might need to do allocation, so it
can need to run transactions itself. Hence it's a debug check to
warn us that we've done something silly, and largely it is not all
that useful.

So let's just remove all the use of current->journal_info in XFS and
get rid of all the potential issues from nested contexts where
current->journal_info might get misused by another filesystem
context.

Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.c |    4 +---
 fs/xfs/xfs_aops.c     |    7 -------
 fs/xfs/xfs_icache.c   |    8 +++++---
 fs/xfs/xfs_trans.h    |    9 +--------
 4 files changed, 7 insertions(+), 21 deletions(-)

--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -978,9 +978,7 @@ xchk_irele(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	if (current->journal_info != NULL) {
-		ASSERT(current->journal_info == sc->tp);
-
+	if (sc->tp) {
 		/*
 		 * If we are in a transaction, we /cannot/ drop the inode
 		 * ourselves, because the VFS will trigger writeback, which
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -502,13 +502,6 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
-	/*
-	 * Writing back data in a transaction context can result in recursive
-	 * transactions. This is bad, so issue a warning and get out of here.
-	 */
-	if (WARN_ON_ONCE(current->journal_info))
-		return 0;
-
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2031,8 +2031,10 @@ xfs_inodegc_want_queue_work(
  *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
  *  - The queue depth exceeds the maximum allowable percpu backlog.
  *
- * Note: If the current thread is running a transaction, we don't ever want to
- * wait for other transactions because that could introduce a deadlock.
+ * Note: If we are in a NOFS context here (e.g. current thread is running a
+ * transaction) the we don't want to block here as inodegc progress may require
+ * filesystem resources we hold to make progress and that could result in a
+ * deadlock. Hence we skip out of here if we are in a scoped NOFS context.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
@@ -2040,7 +2042,7 @@ xfs_inodegc_want_flush_work(
 	unsigned int		items,
 	unsigned int		shrinker_hits)
 {
-	if (current->journal_info)
+	if (current->flags & PF_MEMALLOC_NOFS)
 		return false;
 
 	if (shrinker_hits > 0)
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -277,19 +277,14 @@ static inline void
 xfs_trans_set_context(
 	struct xfs_trans	*tp)
 {
-	ASSERT(current->journal_info == NULL);
 	tp->t_pflags = memalloc_nofs_save();
-	current->journal_info = tp;
 }
 
 static inline void
 xfs_trans_clear_context(
 	struct xfs_trans	*tp)
 {
-	if (current->journal_info == tp) {
-		memalloc_nofs_restore(tp->t_pflags);
-		current->journal_info = NULL;
-	}
+	memalloc_nofs_restore(tp->t_pflags);
 }
 
 static inline void
@@ -297,10 +292,8 @@ xfs_trans_switch_context(
 	struct xfs_trans	*old_tp,
 	struct xfs_trans	*new_tp)
 {
-	ASSERT(current->journal_info == old_tp);
 	new_tp->t_pflags = old_tp->t_pflags;
 	old_tp->t_pflags = 0;
-	current->journal_info = new_tp;
 }
 
 #endif	/* __XFS_TRANS_H__ */


