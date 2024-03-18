Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709835A0FB
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710801395; cv=none; b=GrnKJLsaopZIgiF644lCSDRmqVgDfyeb1d/ITJwe8U4jzYWHpp/feKh0rmxCmCDaKXpUUKDbL2RRYGVXi/rl7h0sFlOpNr2wiu0eLotrNcGg9ZdjkA6aToO1c9L6Xk1jhl3gZFYAMwcgpNschC/pZx/E1Ed466tKeCqhpnvQ678=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710801395; c=relaxed/simple;
	bh=bQCrGzKZCqg5M0vRpvy8jQygjhKLn6tXIA+qGQMy1fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SsdWC9/Ll9/LsxLujmSRUwBFyaaeK3rZ/49i+LoM6gZqR8N/PHVnV2imAyfFSrjSQEMyj/lliXRV/4TYc6Z1gxS0PkZ31aRnJMKERWnuXdYQoG6GWj1qlHy4upN5nJz37d4x7SsTluD/7TtMHDeMuWS2GZf6/Q0p5yBh9/4/FJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2KMJOzOG; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2KMJOzOG"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c1a2f7e302so2858029b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710801392; x=1711406192; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XU2L8iBspbdUrjM2zASyd5tCugjaI3GspRUuX57FcPQ=;
        b=2KMJOzOGDsVFuoKD39rsOSPfJTIAyrHg5zA3luEujdPmPNFsHJnwPj2SA8nLmNaPiD
         Nz+pNwEY6RaY2sGtH3g7JyubTYW0DPIgUj7xS7z9wzlj6DTZ4DsIKXsrBZLOLfoj5Z82
         jN6uLzen16y1TM6PglDYIKktCEyVBJqA3jRk0fgJdI/G0EykvIj/V1L3yzYab2qSXv+a
         Nd1qc5K01l1oJbEuHDnc57Tw8mbjdKGSDu8X/nwlyaNKR8+HkssYES25eGmazRSrVRSE
         5S5xdzi+UHceb/Dw7jfECsWduVSEMkabr6g6e0rUsp+s0vTrYuxrYIWdB+rxFcDju/Zy
         pedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710801392; x=1711406192;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XU2L8iBspbdUrjM2zASyd5tCugjaI3GspRUuX57FcPQ=;
        b=BNBapLEFTDcNl2zPIac7qApeoZkqZVBowexifh0Dr6NWzOopdjWo03c0Izr5ZFJ6P2
         e7sn9Z/79d8vCmaPdqnm7mw+gp8kF/EU/+jIiYmuziBKt4DZX1fPUJdZVxHTMdjVKfvR
         +0blHnZwhLTaBCDBgwPk5MdQi6BJdZnKcTmDi/h0nqX6RTSCI46qBHz/K1DvFd2Dc1G0
         QlLVd7njOyfUnKAEELljfDerO/hEs10D2WxUbOwvDgvnJocYGmimLNzaHEHOzUnXdINm
         dKUoGqgfOwogiKymdOSTGBZRelJeeSsA+R/UT1h5gaKm+58D5gvQw3rpj1Eg0/Y4sMLQ
         jz6w==
X-Gm-Message-State: AOJu0YyiGvdEir//JoUKJypV3sDeNIIe0hRFcDbNQhp+yAOxenPcpZ14
	MiLuIOBJi+r8ZcpKlSjhB4zzfixHph3g+dwn0YIBb4v4zWzrhytyeAeIAwPywEMo9SKUGupj7+f
	4
X-Google-Smtp-Source: AGHT+IHZJynZ7/SxSjAmXyzEsWEiDSHwKQLJXYYhf7vQsj0y0RVWu7NjYkIKvrPZ+5bUp+Jk4A3YTQ==
X-Received: by 2002:a05:6870:218a:b0:221:3ba2:fff0 with SMTP id l10-20020a056870218a00b002213ba2fff0mr15102307oae.45.1710801392267;
        Mon, 18 Mar 2024 15:36:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id r11-20020aa7844b000000b006e65d676d3dsm8751897pfn.18.2024.03.18.15.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:36:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rmLam-003nsV-1T;
	Tue, 19 Mar 2024 09:36:28 +1100
Date: Tue, 19 Mar 2024 09:36:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH v2] xfs: don't use current->journal_info
Message-ID: <ZfjB7DlQW93C90zs@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


From: Dave Chinner <dchinner@redhat.com>

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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Version 2:
- updated commit message as per Darrick's request.

 fs/xfs/scrub/common.c | 4 +---
 fs/xfs/xfs_aops.c     | 7 -------
 fs/xfs/xfs_icache.c   | 8 +++++---
 fs/xfs/xfs_trans.h    | 9 +--------
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index abff79a77c72..47a20cf5205f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1044,9 +1044,7 @@ xchk_irele(
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
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1698507d1ac7..3f428620ebf2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -503,13 +503,6 @@ xfs_vm_writepages(
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
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e64265bc0b33..74f1812b03cb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2039,8 +2039,10 @@ xfs_inodegc_want_queue_work(
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
@@ -2048,7 +2050,7 @@ xfs_inodegc_want_flush_work(
 	unsigned int		items,
 	unsigned int		shrinker_hits)
 {
-	if (current->journal_info)
+	if (current->flags & PF_MEMALLOC_NOFS)
 		return false;
 
 	if (shrinker_hits > 0)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3f7e3a09a49f..1636663707dc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,19 +268,14 @@ static inline void
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
@@ -288,10 +283,8 @@ xfs_trans_switch_context(
 	struct xfs_trans	*old_tp,
 	struct xfs_trans	*new_tp)
 {
-	ASSERT(current->journal_info == old_tp);
 	new_tp->t_pflags = old_tp->t_pflags;
 	old_tp->t_pflags = 0;
-	current->journal_info = new_tp;
 }
 
 #endif	/* __XFS_TRANS_H__ */
-- 
Dave Chinner
david@fromorbit.com
