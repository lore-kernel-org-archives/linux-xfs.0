Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484C33054FE
	for <linux-xfs@vger.kernel.org>; Mon,  8 Sep 2025 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757344380; cv=none; b=thIL+uLOIEM55PTymxN6wiwUPTEfVQLHyoTS8AO8YJYRvLGJsFi8CSwK1c5i8vAWODybjuqQPOe/9qL2lmu9TOD1wN2+9XIwib7S6UXJWHWS2qjHPBd6zdk7SjgSvCKxXMavr2AabG+g6jM+uuRwIMozYsPKVDmOuox+dKBv5Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757344380; c=relaxed/simple;
	bh=6fLWqJuVrGndtYHKazSGXosPm+LTZyw2q1GqYDw0NJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lbJl3yQv5T7ezsGtLljP8f16P3qFMuTg/KBpElJb7R7fy4k9u+Cfd2ZtAIsCGIQ0HlNSHQnx5hzEgU56jE+FWdDxnd9iNJtYq4i9U2Hnt1/Cco7EnJi/KwMUUUIwir/VghWc6I9R8Usr3IWbdAK5NnPxo5ZTI0H1xW+lfn15CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oX8DCP0S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H9RXNrgE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oX8DCP0S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H9RXNrgE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oX8DCP0S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H9RXNrgE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oX8DCP0S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H9RXNrgE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 061EC22517;
	Mon,  8 Sep 2025 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757344376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qbs3dYpZ3FGLuYXfP4W0F5Kl1ooU89l/HfB0yE8HyiE=;
	b=oX8DCP0S1q3nS/G/jlRwVAd6GV8gnm0X5XGcYNBzBKKg2ZQkhadnf80MgdkaFdE/nFZHOc
	NK1yhQlVfXQ5ud6tTKPBS+5n2ewEoWfdSxv8Hh2CkBI+aAFoCsadQiZZpHA3rhbwx/T606
	2CG8zZqzBqiY+WYyMJS2U9KpbWh7vas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757344376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qbs3dYpZ3FGLuYXfP4W0F5Kl1ooU89l/HfB0yE8HyiE=;
	b=H9RXNrgESwZbopErFinaIIA9cE5jBeeI2C21lhuZSlQTyKITf+w+TZ+JxHNxcATyL1ck7a
	rFVsVN3H/ZGwYzBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oX8DCP0S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H9RXNrgE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757344376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qbs3dYpZ3FGLuYXfP4W0F5Kl1ooU89l/HfB0yE8HyiE=;
	b=oX8DCP0S1q3nS/G/jlRwVAd6GV8gnm0X5XGcYNBzBKKg2ZQkhadnf80MgdkaFdE/nFZHOc
	NK1yhQlVfXQ5ud6tTKPBS+5n2ewEoWfdSxv8Hh2CkBI+aAFoCsadQiZZpHA3rhbwx/T606
	2CG8zZqzBqiY+WYyMJS2U9KpbWh7vas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757344376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qbs3dYpZ3FGLuYXfP4W0F5Kl1ooU89l/HfB0yE8HyiE=;
	b=H9RXNrgESwZbopErFinaIIA9cE5jBeeI2C21lhuZSlQTyKITf+w+TZ+JxHNxcATyL1ck7a
	rFVsVN3H/ZGwYzBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E267113946;
	Mon,  8 Sep 2025 15:12:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lZ3ZNnfyvmiGWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Sep 2025 15:12:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5DFE9A0A2D; Mon,  8 Sep 2025 17:12:55 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-xfs@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force during fsync
Date: Mon,  8 Sep 2025 17:12:49 +0200
Message-ID: <20250908151248.1290-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5306; i=jack@suse.cz; h=from:subject; bh=6fLWqJuVrGndtYHKazSGXosPm+LTZyw2q1GqYDw0NJA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBovvJwABtKVQmiQe86PZDI85xZ0Umz7Giyirrxn V+4GGCD6zaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaL7ycAAKCRCcnaoHP2RA 2U9IB/9ZWtNy2dBw8POB+R6CJ7Prq5/1FYg4E+MvfJKEqZBQBedQA0+hG/JZcxQ2jwwiQYmCBEN yTXP8fKUpm/G3YReHr5AaNQhxvxzcC92REJxix+6aSzRhw3PrNUDY+q53z9bsCNAISRXEWX4m32 iyGNb2auigWni3kJI6plF00vDTupde/nMKBpIBf3lIvP5xckpqxCRQlfrwr3m4UEcjv+71Plzkg 1oMosjcNWjSJQ39zn6RTJ58zmkQrWsB2jq4OliaXOeHhjadLhKtz1Bt5LQxosVIFjbZkolLj1+c lWU8hHYSho2BTuZSY2hDLyPH0OtXuFZ93T8MwG9xp91fbmdv
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 061EC22517
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

Holding XFS_ILOCK_SHARED over log force in xfs_fsync_flush_log()
significantly increases contention on ILOCK for O_DSYNC | O_DIRECT
writes to file preallocated with fallocate (thus DIO happens to
unwritten extents and we need ILOCK in exclusive mode for timestamp
modifications and extent conversions). But holding ILOCK over the log
force doesn't seem strictly necessary for correctness. We are just using
it for a mechanism to make sure parallel fsyncs all wait for log force
to complete but that can be also achieved without holding ILOCK.

With this patch DB2 database restore operation speeds up by a factor of
about 2.5x in a VM with 4 CPUs, 16GB of RAM and NVME SSD as a backing
store.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c       | 33 ++++++++++++++++++++++-----------
 fs/xfs/xfs_inode_item.c |  1 +
 fs/xfs/xfs_inode_item.h |  1 +
 3 files changed, 24 insertions(+), 11 deletions(-)

I've chosen adding ili_fsync_flushing_fields to xfs_inode_log_item since that
seemed in line with how the code is structured. Arguably that is unnecessarily
wasteful since in practice we use just one bit of information from
ili_fsync_fields and one bit from ili_fsync_flushing_fields. If people prefer
more space efficient solution, I can certainly do that.

This is marked as RFC because I'm not quite sure I didn't miss some subtlety
in XFS logging mechanisms and this will crash & burn badly in some corner
case (but fstests seem to be passing fine for me).

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b04c59d87378..2bb793c8c179 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,9 +80,13 @@ xfs_fsync_seq(
 	struct xfs_inode	*ip,
 	bool			datasync)
 {
+	unsigned int sync_fields;
+
 	if (!xfs_ipincount(ip))
 		return 0;
-	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+	sync_fields = ip->i_itemp->ili_fsync_fields |
+		      ip->i_itemp->ili_fsync_flushing_fields;
+	if (datasync && !(sync_fields & ~XFS_ILOG_TIMESTAMP))
 		return 0;
 	return ip->i_itemp->ili_commit_seq;
 }
@@ -92,13 +96,14 @@ xfs_fsync_seq(
  * log up to the latest LSN that touched the inode.
  *
  * If we have concurrent fsync/fdatasync() calls, we need them to all block on
- * the log force before we clear the ili_fsync_fields field. This ensures that
- * we don't get a racing sync operation that does not wait for the metadata to
- * hit the journal before returning.  If we race with clearing ili_fsync_fields,
- * then all that will happen is the log force will do nothing as the lsn will
- * already be on disk.  We can't race with setting ili_fsync_fields because that
- * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
- * shared until after the ili_fsync_fields is cleared.
+ * the log force until it is finished. Thus we clear ili_fsync_fields so that
+ * new modifications since starting log force can accumulate there and just
+ * save old ili_fsync_fields value to ili_fsync_flushing_fields so that
+ * concurrent fsyncs can use that to determine whether they need to wait for
+ * running log force or not. This ensures that we don't get a racing sync
+ * operation that does not wait for the metadata to hit the journal before
+ * returning.  If we race with clearing ili_fsync_fields, then all that will
+ * happen is the log force will do nothing as the lsn will already be on disk.
  */
 static  int
 xfs_fsync_flush_log(
@@ -112,14 +117,20 @@ xfs_fsync_flush_log(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	seq = xfs_fsync_seq(ip, datasync);
 	if (seq) {
+		spin_lock(&ip->i_itemp->ili_lock);
+		ip->i_itemp->ili_fsync_flushing_fields =
+						ip->i_itemp->ili_fsync_fields;
+		ip->i_itemp->ili_fsync_fields = 0;
+		spin_unlock(&ip->i_itemp->ili_lock);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
 					  log_flushed);
-
 		spin_lock(&ip->i_itemp->ili_lock);
-		ip->i_itemp->ili_fsync_fields = 0;
+		ip->i_itemp->ili_fsync_flushing_fields = 0;
 		spin_unlock(&ip->i_itemp->ili_lock);
+	} else {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 829675700fcd..39d15eb9311d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1056,6 +1056,7 @@ xfs_iflush_abort_clean(
 	iip->ili_last_fields = 0;
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
+	iip->ili_fsync_flushing_fields = 0;
 	iip->ili_flush_lsn = 0;
 	iip->ili_item.li_buf = NULL;
 	list_del_init(&iip->ili_item.li_bio_list);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index ba92ce11a011..018ba4cd3fab 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -33,6 +33,7 @@ struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
+	unsigned int		ili_fsync_flushing_fields;  /* fields currently being committed by fsync */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
 };
-- 
2.51.0

