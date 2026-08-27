Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ECF3C1991
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112175; cv=none; b=cRp5emTNBKwxhFyW6UCbnBlQl6NCYB8Ig6DTffEomFHARXYwFK3Lqyg40mZlkkLeEIc/hcKRnGVEAt+SJgetl305f2jlHMm4qw7nCr7rRBTbqvvGpceh/f4/Xs0WZWb6T2YdNel/6XH2I5nKSm8EPJoPPwuosX0tIqPcCwuLPb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112175; c=relaxed/simple;
	bh=rj/9EiyJ60emnPMI0wfjMJsMPT8fqdVkjTMWSeTOHjw=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=QautejSQicjd1fNId8m3pP2EKDl1yDr+kgbTzDi9j9YJCZuAlcGvpqY8mG8894hOlMg1QKYlkxro0EYv+vP+I3k0u4VTDCB2DoZej0tcrpFSTBMKFKyly4EmjBelisGoeQHjtHl0JkvWUv9oD4ZWT5qu8tBeV7yDKw9ePERsyS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=NEDo7UXi; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="NEDo7UXi"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04Y5jBBzK8
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112173; bh=P5AR2zywcXIaFNSCKp+MiSrv+Q+Y8JrChVBps4JDrKk=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=NEDo7UXie+C2ID8aoesLVKDwdc2Ep2FNTnGR34LQxNt6KYhKrm2aJX7wfB7Ujnysm
	 zKWxvVCg/qUkn8IxAtBm3NzMvKRAeMh06CYDT2mwEwVEnhFxB1HRAMkIFSj95W6DqW
	 IcKinpNNG/C2caa4tUL0dcAyDSCS1GrIcxn0tui4vuTxB5l6SbOdZVpcdF5BYlMheP
	 28SL3aN2JLZdvFJrAXegZ7xxK+KF1oe2SOa19xNouUfUYmvWzFMAC/0Xy4oyI2HPKL
	 Lvua0BcjfMIFsbYpk4KKH2maL10MIvsh5iscZKQOMpmXKkt1BU8DaJKXuBLOhNEhEE
	 fWn9h2tz1ulig==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04X2Dvdz9KQbD
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:32 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:32 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <ac7ec2c4f9f0a64d2994dd21fd4d620942b2c745.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:25:44 -0700
Subject: [PATCH 8/9] xfs_repair: add -R to replay a dirty log before repairing
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfs_repair refuses to run on a filesystem with a dirty log, and the only
way past that has been -L, which destroys the log and every metadata
update it describes.  The advice is to mount and unmount the filesystem
first, which is not available when the filesystem cannot be mounted, or
when the machine that crashed is gone.

-R replays the log first, using the kernel's own recovery code, and then
repairs the result.  It is defined to be equivalent to mounting the
filesystem, unmounting it cleanly, and repairing that - so it retires the
log afterwards, and refuses to run alongside -L or -n.

Replay is validated against the kernel: for each image in a corpus of
crashed filesystems, the result is compared with the same image recovered
by Linux and unmounted cleanly.

Inodes left on the unlinked list are not yet dealt with here; a later
patch finishes those deletions, and until then repair moves them to
lost+found.  Replay is refused on zoned filesystems, where freeing a
realtime extent needs the zone allocator rather than a metadata update.
---
 man/man8/xfs_repair.8 |  79 +++++++++++++--
 repair/globals.c      |   1 +
 repair/globals.h      |   1 +
 repair/phase2.c       | 225 +++++++++++++++++++++++++++++++++++++++++-
 repair/xfs_repair.c   |  22 ++++-
 5 files changed, 315 insertions(+), 13 deletions(-)

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 6625b47a..c2888277 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -8,6 +8,8 @@ xfs_repair \- repair an XFS filesystem
 ] [
 .BR \-n " | " -e
 ] [
+.B \-R
+] [
 .B \-m
 .I maxmem
 ] [
@@ -71,6 +73,29 @@ and can cause the loss of user files and/or data.  See the
 .B "DIRTY LOGS"
 section for more information.
 .TP
+.B \-R
+Replay the log.
+Instructs
+.B xfs_repair
+to replay a dirty log before it starts repairing, rather than refusing to
+run.  This performs the same recovery the kernel performs when it mounts a
+filesystem that was not unmounted cleanly, so the metadata updates that were
+in progress at the time of the crash are preserved instead of discarded.
+.IP
+Replay requires the same CPU architecture as the machine that wrote the log,
+and it writes to the filesystem, so
+.B \-R
+cannot be combined with
+.B \-n
+or
+.BR \-L .
+If replay fails,
+.B xfs_repair
+exits without repairing anything and leaves the log dirty.  Whether it is then
+safe to replay again depends on how far replay got; see the
+.B "DIRTY LOGS"
+section.
+.TP
 .BI \-l " logdev"
 Specifies the device special file where the filesystem's external
 log resides. Only for those filesystems which use an external log.
@@ -543,15 +568,55 @@ Due to the design of the XFS log, a dirty log can only be replayed
 by the kernel, on a machine having the same CPU architecture as the
 machine which was writing to the log.
 .B xfs_repair
-cannot replay a dirty log and will exit with a status code of 2
-when it detects a dirty log.
+will by default exit with a status code of 2 when it detects a dirty log,
+because replaying it is not part of repair.
+.PP
+There are three ways to deal with this, in decreasing order of preference.
+.PP
+The log can be replayed by mounting and immediately unmounting the
+filesystem on the same class of machine that crashed.  Please make sure that
+the machine's hardware is reliable before replaying to avoid compounding the
+problems.  This is the best option because the kernel is the reference
+implementation of log recovery.
+.PP
+If the filesystem cannot be mounted, but the log itself is intact,
+.B xfs_repair \-R
+will replay it in userspace and then repair the result.  This preserves the
+metadata updates recorded in the log.
+.PP
+Replay can still fail on a log that is itself damaged.  Replaying a log is not
+an atomic operation, so metadata that replay had already written stays written.
+.B xfs_repair
+does not go on to repair a filesystem it could not replay, and it does not
+retire the log, so nothing is discarded.
+.PP
+Whether it is safe to try again depends on how far replay got, and
+.B xfs_repair
+says which case it hit.  Replaying buffers is idempotent, so a failure reported
+as
+.B "Log replay failed"
+can be retried.  Completing intents is not idempotent - unlike the kernel,
+userspace records no done items - so after a failure reported as
+.B "Log recovery completion failed"
+the log still describes intents that have already been applied, and replaying
+it again, by mount or by
+.BR \-R ,
+would apply them twice.  In that case use
+.B \-L
+to discard the log and repair without it.
 .PP
-In this situation, the log can be replayed by mounting and immediately
-unmounting the filesystem on the same class of machine that crashed.
-Please make sure that the machine's hardware is reliable before
-replaying to avoid compounding the problems.
+There is a difference between
+.B \-R
+and kernel recovery.  A file that was deleted, but whose deletion had not
+finished when the system crashed, is left on the filesystem's unlinked list.
+The kernel finishes the deletion; replay in userspace does not, so repair
+finds the file unreferenced and moves it to
+.IR lost+found .
+The filesystem is consistent either way, but a
+.B \-R
+run can leave files there that a mount and unmount would have removed.
 .PP
-If mounting fails, the log can be erased by running
+As a last resort the log can be erased by running
 .B xfs_repair
 with the -L option.
 All metadata updates in progress at the time of the crash will be lost,
diff --git a/repair/globals.c b/repair/globals.c
index 143b4a8b..ab3b9424 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -39,6 +39,7 @@ int	no_modify;
 int	dangerously;		/* live dangerously ... fix ro mount */
 int	isa_file;
 int	zap_log;
+int	replay_log;
 int	dumpcore;		/* abort, not exit on fatal errs */
 int	force_geo;		/* can set geo on low confidence info */
 int	assume_xfs;		/* assume we have an xfs fs */
diff --git a/repair/globals.h b/repair/globals.h
index 8bb9bbae..4379b196 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -80,6 +80,7 @@ extern int	no_modify;
 extern int	dangerously;		/* live dangerously ... fix ro mount */
 extern int	isa_file;
 extern int	zap_log;
+extern int	replay_log;
 extern int	dumpcore;		/* abort, not exit on fatal errs */
 extern int	force_geo;		/* can set geo on low confidence info */
 extern int	assume_xfs;		/* assume we have an xfs fs */
diff --git a/repair/phase2.c b/repair/phase2.c
index e66ff316..49928f78 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "libxlog.h"
+#include "xfs_trans_priv.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -23,6 +24,213 @@ int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
 	return 0;
 }
 
+
+/*
+ * Replay a dirty log, the way mounting the filesystem would.
+ *
+ * -R is defined to be equivalent to mounting the filesystem, unmounting it
+ * cleanly and then repairing it, so this does both halves: recovery applies
+ * the journal, and the log is then retired.  Without the second half the
+ * journal would still describe changes that have already been applied, and
+ * the next mount would replay them again.  Buffer replay is idempotent but
+ * intent replay is not - userspace writes no done items - so every intent
+ * completed here would be recovered a second time.
+ */
+static void
+replay_dirty_log(
+	struct xfs_mount	*mp,
+	struct xlog		*log,
+	uuid_t			*sb_uuid,
+	xfs_daddr_t		*head_blk,
+	xfs_daddr_t		*tail_blk)
+{
+	int			error;
+	uint32_t		new_cycle;
+
+	/*
+	 * libxlog's header_check_uuid() does not refuse a log whose UUID does
+	 * not match the superblock: it prints a message and then overwrites
+	 * the in-core superblock UUID with the log's, so the identical check
+	 * inside recovery cannot fire afterwards.  Replaying a journal that
+	 * belongs to a different filesystem is never what the user wants, so
+	 * compare against the value the superblock had on entry and refuse.
+	 */
+	if (platform_uuid_compare(sb_uuid, &mp->m_sb.sb_uuid) != 0)
+		do_error(_(
+"The log belongs to a different filesystem than the superblock does.\n"
+"Refusing to replay it.  If this is a snapshot or a copy, mount it with the\n"
+"nouuid option to replay the log, or use -L to destroy it.\n"));
+
+	/*
+	 * Recovery tracks unfinished intents in the AIL libxfs_mount() built.
+	 * The kernel builds the AIL in xfs_log_mount(), once the log exists, so
+	 * it can point the two at each other there; libxfs_mount() runs before
+	 * there is a log at all, so make the connection here instead.
+	 */
+	log->l_ailp = mp->m_ail;
+	mp->m_ail->ail_log = log;
+
+	/*
+	 * Recovery skips dquot items when no quota is enabled, and libxfs
+	 * never sets m_qflags, so take it from the superblock the way
+	 * xfs_qm_mount_quotas() does.  Without this a filesystem with quota
+	 * loses its dquot updates silently.
+	 */
+	mp->m_qflags = mp->m_sb.sb_qflags;
+
+	/*
+	 * Derive the log buffer size the way a default mount does
+	 * (xfs_finish_flags() followed by xlog_alloc_log()):
+	 * XLOG_BIG_RECORD_BSIZE unless a v2 log has a larger stripe unit.
+	 * Recovery uses this as the upper bound when validating a record's
+	 * h_size, so hard coding 32K would reject valid records on a
+	 * filesystem with a large log stripe unit.
+	 */
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)
+		mp->m_logbsize = mp->m_sb.sb_logsunit;
+	else
+		mp->m_logbsize = XLOG_BIG_RECORD_BSIZE;
+
+	/*
+	 * Recovery re-reads and reverifies the primary superblock, taking the
+	 * buffer lock itself.  libxfs_getsb() hands back a locked buffer and
+	 * the userspace buffer lock is a plain non-recursive mutex, so hold an
+	 * unlocked reference instead or recovery deadlocks against itself.
+	 */
+	/*
+	 * Freeing a realtime extent on a zoned filesystem is not implemented in
+	 * userspace, and that only becomes apparent partway through completing
+	 * intents, once earlier ones have already been applied.  Refuse before
+	 * replay changes anything rather than stopping halfway.
+	 */
+	if (xfs_has_zoned(mp))
+		do_error(
+	_("Log replay is not supported on zoned filesystems.  Mount and unmount\n"
+	  "the filesystem to replay the log, or use -L to destroy it.\n"));
+
+	mp->m_sb_bp = libxfs_getsb(mp);
+	if (!mp->m_sb_bp)
+		do_error(_("couldn't get superblock for log replay\n"));
+	libxfs_buf_unlock(mp->m_sb_bp);
+
+	/*
+	 * Replaying the primary superblock also mirrors it into the realtime
+	 * superblock, but only if that buffer is attached.  Give it the same
+	 * lifetime, or those updates are silently skipped and the two
+	 * superblocks disagree once the log is declared clean.
+	 */
+	if (xfs_has_rtsb(mp)) {
+		mp->m_rtsb_bp = libxfs_getrtsb(mp);
+		if (!mp->m_rtsb_bp)
+			do_error(
+	_("couldn't get realtime superblock for log replay\n"));
+		libxfs_buf_unlock(mp->m_rtsb_bp);
+	}
+
+	/*
+	 * Mark the whole replay window, not just the part after xlog_recover()
+	 * sets this itself.  Two guards keyed off it - the stale-buffer write
+	 * exception in libxfs_bwrite() and the dirty-cancel shutdown in
+	 * libxfs_trans_cancel() - have to cover the replay passes, which is
+	 * where the writes and the cancels actually happen.
+	 */
+	set_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+
+	error = -xlog_recover(log);
+	if (error)
+		do_error(_("Log replay failed: %s\n"), strerror(error));
+
+	/*
+	 * From here on intents are being completed for real.  Userspace writes
+	 * no done items, so an intent finished before a failure is still
+	 * described by the log we did not retire, and replaying that log again
+	 * - here or by a kernel mount - would apply it a second time.  Say so,
+	 * because the obvious response to a failure is to try again.
+	 */
+	error = -xlog_recover_finish(log);
+	if (error)
+		do_error(
+	_("Log recovery completion failed: %s\n"
+	  "Some intents may already have been applied.  Do not replay this log\n"
+	  "again, by mount or by -R, as that would apply them twice.  Use -L to\n"
+	  "discard the log and repair instead.\n"),
+			 strerror(error));
+
+	/*
+	 * Recovery reports a failed item pass by shutting the log down as
+	 * well as by returning an error, so check both before believing the
+	 * log was fully replayed.
+	 */
+	if (xlog_is_shutdown(log))
+		do_error(
+	_("Log recovery failed and the log was shut down.\n"));
+
+	libxfs_buf_lock(mp->m_sb_bp);
+	libxfs_buf_relse(mp->m_sb_bp);
+	mp->m_sb_bp = NULL;
+
+	if (mp->m_rtsb_bp) {
+		libxfs_buf_lock(mp->m_rtsb_bp);
+		libxfs_buf_relse(mp->m_rtsb_bp);
+		mp->m_rtsb_bp = NULL;
+	}
+
+	/*
+	 * Replay is over.  End the recovery state, as xfs_log_mount_finish()
+	 * does, so that the rest of xfs_repair runs as it always has: while
+	 * XLOG_RECOVERY_NEEDED is set, a dirty transaction cancel is treated
+	 * as recovery hitting a corrupt log item rather than as the repair
+	 * bug it would be from here on.
+	 */
+	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+
+	/*
+	 * Get the replayed metadata onto stable storage before retiring the
+	 * log, and check that it got there.  A clean log describing changes
+	 * that never reached disk is worse than the dirty log we started
+	 * with, so a write error here must stop us rather than be discarded
+	 * by the cache flush.
+	 */
+	error = -libxfs_flush_mount(mp);
+	if (error)
+		do_error(
+	_("Failed to flush replayed metadata to disk: %s\n"),
+			 strerror(error));
+
+	/*
+	 * Start the new log a cycle beyond everything just replayed, so that
+	 * on a v5 filesystem the recovered metadata LSNs stay behind the log
+	 * head - the same ordering invariant format_log_max_lsn() enforces
+	 * later.  Skip the reserved value, as the kernel does when it rolls
+	 * the cycle over, because a cycle stamp that reads back as a record
+	 * header magic confuses head and tail discovery.  Skip its successor
+	 * too: libxfs_log_clear() derives the tail from cycle - 1, so landing
+	 * one past the reserved value would put it back in the tail LSN.
+	 */
+	new_cycle = log->l_curr_cycle + 1;
+	if (new_cycle == XLOG_HEADER_MAGIC_NUM ||
+	    new_cycle - 1 == XLOG_HEADER_MAGIC_NUM)
+		new_cycle = XLOG_HEADER_MAGIC_NUM + 2;
+
+	libxfs_log_clear(log->l_targ, NULL,
+		XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
+		&mp->m_sb.sb_uuid, xfs_has_logv2(mp) ? 2 : 1,
+		mp->m_sb.sb_logsunit, XLOG_FMT, new_cycle, true);
+
+	/* And make the clean log durable before repair starts writing. */
+	error = -libxfs_flush_mount(mp);
+	if (error)
+		do_error(_("Failed to flush the new log to disk: %s\n"),
+			 strerror(error));
+
+	error = xlog_find_tail(log, head_blk, tail_blk);
+	if (error || *head_blk != *tail_blk)
+		do_error(_("failed to retire the log after replay\n"));
+
+	do_log(_("        - replayed log, log is now clean\n"));
+}
+
 static void
 zero_log(
 	struct xfs_mount	*mp)
@@ -31,6 +239,9 @@ zero_log(
 	xfs_daddr_t		head_blk;
 	xfs_daddr_t		tail_blk;
 	struct xlog		*log = mp->m_log;
+	uuid_t			sb_uuid;
+
+	platform_uuid_copy(&sb_uuid, &mp->m_sb.sb_uuid);
 
 	xlog_init(mp, mp->m_log);
 
@@ -68,15 +279,19 @@ zero_log(
 "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
 "ignored because the -n option was used.  Expect spurious inconsistencies\n"
 "which may be resolved by first mounting the filesystem to replay the log.\n"));
+			} else if (replay_log) {
+				replay_dirty_log(mp, log, &sb_uuid, &head_blk,
+						&tail_blk);
 			} else {
 				do_warn(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
 "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
-"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
-"filesystem, you may need to give mount the nouuid option. If you are unable\n"
-"to mount the filesystem, then use the -L option to destroy the log and\n"
-"attempt a repair.  Note that destroying the log may cause corruption --\n"
-"please attempt a mount of the filesystem before doing this.\n"));
+"re-running xfs_repair, or use the -R option to replay it here.  If the\n"
+"filesystem is a snapshot of a mounted filesystem, you may need to give mount\n"
+"the nouuid option. If you are unable to mount the filesystem, then use the\n"
+"-L option to destroy the log and attempt a repair.  Note that destroying the\n"
+"log may cause corruption -- please attempt a mount of the filesystem before\n"
+"doing this.\n"));
 				exit(2);
 			}
 		}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 016795ee..1e778ba2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -99,6 +99,8 @@ usage(void)
 "Options:\n"
 "  -f           The device is a file\n"
 "  -L           Force log zeroing. Do this as a last resort.\n"
+"  -R           Replay the log before repairing, as mounting and\n"
+"               unmounting the filesystem would.\n"
 "  -l logdev    Specifies the device where the external log resides.\n"
 "  -m maxmem    Maximum amount of memory to be used in megabytes.\n"
 "  -n           No modify mode, just checks the filesystem for damage.\n"
@@ -211,6 +213,7 @@ process_args(int argc, char **argv)
 	dangerously = 0;
 	isa_file = 0;
 	zap_log = 0;
+	replay_log = 0;
 	dumpcore = 0;
 	full_ino_ex_data = 0;
 	force_geo = 0;
@@ -228,7 +231,7 @@ process_args(int argc, char **argv)
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPet:")) != EOF)  {
+	while ((c = getopt(argc, argv, "c:o:fl:m:r:LRnDvVdPet:")) != EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore = 1;
@@ -403,6 +406,9 @@ process_args(int argc, char **argv)
 		case 'L':
 			zap_log = 1;
 			break;
+		case 'R':
+			replay_log = 1;
+			break;
 		case 'n':
 			no_modify = 1;
 			break;
@@ -442,6 +448,20 @@ process_args(int argc, char **argv)
 	if (report_corrected && no_modify)
 		usage();
 
+	/*
+	 * -L destroys the log and -R replays it.  Asking for both is a
+	 * contradiction, and silently picking the destructive one is the worst
+	 * possible answer.  -n cannot replay either, since replay writes.
+	 */
+	if (replay_log && zap_log) {
+		do_warn(_("%s: -L and -R are mutually exclusive.\n"), progname);
+		usage();
+	}
+	if (replay_log && no_modify) {
+		do_warn(_("%s: -R cannot be used with -n.\n"), progname);
+		usage();
+	}
+
 	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
 	if (p) {
 		errno = 0;
-- 
2.47.3

