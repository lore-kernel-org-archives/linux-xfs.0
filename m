Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0N042cL124476 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 18:04:02 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B22AAE7B6
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:03:17 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	91i0hF7yaSeuPjsG for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 16:03:17 -0800 (PST)
Date: Fri, 23 Jan 2009 11:02:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090123000203.GC32390@disturbed>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

On Thu, Jan 22, 2009 at 01:11:58AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.
> 
> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)

And now with line breaks.

------

[XFS] Check buffer lengths in log recovery

Before trying to obtain, read or write a buffer,
check that the buffer length is actually valid. If
it is not valid, then something read in the recovery
process has been corrupted and we should abort
recovery.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
---
 fs/xfs/xfs_log_recover.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 35cca98..a37e4aa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -70,16 +70,22 @@ STATIC void	xlog_recover_check_summary(xlog_t *);
 xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
-	int		num_bblks)
+	int		nbblks)
 {
-	ASSERT(num_bblks > 0);
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_get_bp(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
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
@@ -102,6 +108,14 @@ xlog_bread(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_bread(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
 	if (log->l_sectbb_log) {
 		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
 		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
@@ -139,6 +153,14 @@ xlog_bwrite(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_bwrite(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
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
