Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:58834 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755179AbeEHQPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:15:17 -0400
Date: Tue, 8 May 2018 11:13:53 -0500
From: hal@deer-run.com
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180508161353.GA18224@deer-run.com>
References: <20180504140244.GA32161@deer-run.com>
 <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

> Hm, so this probably makes it possible that blockget will wander off
> into inconsistencies and fail; there's a /reason/ for the check.  So
> if anything this is probably best-effort.  I doubt you can rely on
> blockget even completing without error, let alone being correct.  In
> that case, is it still useful to you?

I've been testing a modified version of xfs_db on live file systems
and dirty image files, and I have yet to have blockget fail. I agree
that it's certainly possible for blockget to blow up under these
circumstances, but it's working often enough to be useful.

> What sort of information do you hope to gather after running
> blockget without a replay?

Suppose I can match a string or magic number for a file of interest
at a specific byte offset in the file system image. A little arithmetic
and I have a daddr value. xfs_db let's me convert that to an fsblock
and then call blockuse -n to get the inode and file path. I've tried
it, and it works with my modifed xfs_db.

Until we get XFS support into libsleuthkit (which I'm working towards,
but it's going to be a while), having this functionality lets me
use xfs_db as a forensic tool. And it also lets me use xfs_db to
validate other forensic tools.

> Given that xfs_db is a command for experts, and forensics analysis on an
> unreplayed filesystem even more so, what about modifying the logformat
> command to allow zeroing of a dirty log with some type of force option,
> which would then allow blkget to proceed?  (assuming you were working on
> a copy, of course.)  That would make things pretty explicit.
> 
> Is that too convoluted?

This is not something you'd want to do on a live file system, and 
unfortunately I sometimes have to forensicate live file systems.
And I'd rather not have to modify my working copy of a forensic
image by zeroing the log if I could avoid it.

> Otherwise I might suggest adding a switch specific to the blockget_f
> function, which would just skip the sb_logcheck() altogether.  That would
> be more targeted, and wouldn't be some global switch which affects
> every current and future caller of sb_logcheck.  A warning about how
> the log is being ignored and results may be inconsistent could then
> be added specifically to blockget_f.

Which sort of brings us back to the conversation that Darrick and I
have been having. Adding a command-line switch seems wrong-- I'm fully
convinced of that. But I'd still like to be able to blockget to try
to work if the file system is dirty but "-r" is used.

Darrick came up with one fix, which is the first patch option below.
After staring at Darrick's suggestion a while, I came up with a
different fix (second patch) that requires more code changes but I
think more accurately addresses the problem statement. See previous
messages in this thread for more detail.

Let me know which you prefer and I'll submit the patch in the proper
format to the list.

Cheers!

--Hal


[PATCH OPTION #1]
---
 db/sb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/db/sb.c b/db/sb.c
index c7fbfd6..fca048c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -259,7 +259,10 @@ sb_logcheck(void)
 "the xfs_repair -L option to destroy the log and attempt a repair.\n"
 "Note that destroying the log may cause corruption -- please attempt a mount\n"
 "of the filesystem before doing this.\n"), progname);
-		return 0;
+		/* Dirty log would normally result in "return 0".
+		   Return 1 if "-r" (read-only) option is used so
+		   blockget can proceed. */
+		return (x.isreadonly & LIBXFS_ISREADONLY) ? 1 : 0;
 	}
 	/* Log is clean */
 	return 1;
-- 
1.8.3.1




[PATCH OPTION #2]
---
 db/check.c | 5 ++++-
 db/sb.c    | 8 ++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/db/check.c b/db/check.c
index 2f8dee5..885e84a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1849,6 +1849,7 @@ init(
 	xfs_fsblock_t	bno;
 	int		c;
 	xfs_ino_t	ino;
+	int		lc;
 	int		rt;
 
 	serious_error = 0;
@@ -1858,7 +1859,9 @@ init(
 		serious_error = 1;
 		return 0;
 	}
-	if (!sb_logcheck())
+	lc = sb_logcheck();
+	/* abort on error or if log is dirty and "-r" flag not used */
+	if (lc < 0 || (lc == 0 && !(x.isreadonly & LIBXFS_ISREADONLY)))
 		return 0;
 	rt = mp->m_sb.sb_rextents != 0;
 	dbmap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*dbmap));
diff --git a/db/sb.c b/db/sb.c
index c7fbfd6..88e5a94 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -235,13 +235,13 @@ sb_logcheck(void)
 		if (x.logdev && x.logdev != x.ddev) {
 			dbprintf(_("aborting - external log specified for FS "
 				 "with an internal log\n"));
-			return 0;
+			return -1;
 		}
 	} else {
 		if (!x.logdev || (x.logdev == x.ddev)) {
 			dbprintf(_("aborting - no external log specified for FS "
 				 "with an external log\n"));
-			return 0;
+			return -1;
 		}
 	}
 
@@ -250,7 +250,7 @@ sb_logcheck(void)
 	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
-		return 0;
+		return -1;
 	} else if (dirty == 1) {
 		dbprintf(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
@@ -271,7 +271,7 @@ sb_logzero(uuid_t *uuidp)
 	int	cycle = XLOG_INIT_CYCLE;
 	int	error;
 
-	if (!sb_logcheck())
+	if (sb_logcheck() < 1)
 		return 0;
 
 	/*
-- 
1.8.3.1

