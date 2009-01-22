Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M4iAJ4040341 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 22:44:11 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1218AAAF7
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 20:43:24 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	LqMx0yYP8muB7MPF for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2009 20:43:24 -0800 (PST)
Date: Thu, 22 Jan 2009 15:37:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122043747.GU10158@disturbed>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200901211503.07308.nickpiggin@yahoo.com.au>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

On Wed, Jan 21, 2009 at 03:03:06PM +1100, Nick Piggin wrote:
> On Wednesday 21 January 2009 14:57:03 Dave Chinner wrote:
> > > [  235.250167] ------------[ cut here ]------------
> > > [  235.250354] kernel BUG at mm/vmalloc.c:164!
> > > [  235.250478] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> > > [  235.250869] last sysfs file: /sys/block/ram9/range
> > > [  235.250998] Modules linked in:
......
> > > [  235.251037] Call Trace:
> > > [  235.251037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
> > > [  235.251037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
> > > [  235.251037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
> > > [  235.251037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
> > > [  235.251037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
> > > [  235.251037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
> > > [  235.251037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
> > > [  235.251037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
> >
> > .....
> >
> > Ok, that's crashing in the new vmap code. It might take a couple
> > of days before I get a chance to look at this, but I've cc'd Nick Piggin
> > in case he has a chance to look at it before that. It's probably
> > an XFS bug, anyway.
> 
> Hmm, it is crashing in BUG_ON(addr >= end); where this could happen
> if XFS asks to map a really huge (or -ve) number of pages and wraps
> the range, or if vmap subsystem returns an address right near the
> end of the address range and addr+size wraps (which would be a bug
> in vmap of course, but I think maybe less likely).

It's a zero length range, not a negative value. A debug XFS would
have assert failed on it, but it was completely unchecked on
production builds. The following patch checks the length of blocks
to build/read/write for being valid. Instead of an oops, we get:

[ 1572.665001] XFS mounting filesystem loop0
[ 1572.666942] XFS: Invalid block length (0x0) given for buffer
[ 1572.667141] XFS: Log inconsistent (didn't find previous header)
[ 1572.667141] XFS: empty log check failed
[ 1572.667141] XFS: log mount/recovery failed: error 5
[ 1572.671487] XFS: log mount failed

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

[XFS] Check buffer lengths in log recovery

Before trying to obtain, read or write a buffer,
check that the buffer length is actually valid. If
it is not valid, then something read in the recovery
process has been corrupted and we should abort
recovery. 

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
---
 fs/xfs/xfs_log_recover.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 35cca98..b1047de 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -70,16 +70,21 @@ STATIC void	xlog_recover_check_summary(xlog_t *);
 xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
-	int		num_bblks)
+	int		nbblks)
 {
-	ASSERT(num_bblks > 0);
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
+		XFS_ERROR_REPORT("xlog_get_bp(1)",
+				 XFS_ERRLEVEL_HIGH, log->l_mp);
+		return NULL;
+	}
 
 	if (log->l_sectbb_log) {
-		if (num_bblks > 1)
-			num_bblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
-		num_bblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, num_bblks);
+		if (nbblks > 1)
+			nbblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
+		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
 	}
-	return xfs_buf_get_noaddr(BBTOB(num_bblks), log->l_mp->m_logdev_targp);
+	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
 
 void
@@ -102,6 +107,13 @@ xlog_bread(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
+		XFS_ERROR_REPORT("xlog_bread(1)",
+				 XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
 	if (log->l_sectbb_log) {
 		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
 		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
@@ -139,6 +151,13 @@ xlog_bwrite(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
+		XFS_ERROR_REPORT("xlog_bwrite(1)",
+				 XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
 	if (log->l_sectbb_log) {
 		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
 		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
