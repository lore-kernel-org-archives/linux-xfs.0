Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIQCrZ121469 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:26:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76C1319A8AB1
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 11:26:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hoVo6TN2rMYkvkmS for <xfs@oss.sgi.com>;
	Sat, 10 Sep 2011 11:26:10 -0700 (PDT)
Date: Sat, 10 Sep 2011 14:26:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Performance regression between 2.6.32 and 2.6.38
Message-ID: <20110910182607.GA20143@infradead.org>
References: <20110910060522.GA26968@infradead.org> <CA90F616.8E617%ps@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CA90F616.8E617%ps@fb.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Saab <ps@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Joshua Aune <luken@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 10, 2011 at 06:10:50PM +0000, Paul Saab wrote:
> On 9/9/11 11:05 PM, "Christoph Hellwig" <hch@infradead.org> wrote:
> 
> >On Fri, Sep 09, 2011 at 06:23:54PM -0600, Joshua Aune wrote:
> >> Are there any mount options or other tests that can be run in the
> >>failing configuration that would be helpful to isolate this further?
> >
> >The best thing would be to bisect it down to at least a kernel release,
> >and if possible to a -rc or individual change (the latter might start
> >to get hard due to various instabilities in early -rc kernels)
> 
> 487f84f3 is where the regression was introduced.

The patch below which is in the queue for Linux 3.2 should fix this
issue, and in fact improve behaviour even further.



--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-dio-read-fix.diff"

commit 37b652ec6445be99d0193047d1eda129a1a315d3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Aug 25 07:17:01 2011 +0000

    xfs: don't serialise direct IO reads on page cache checks
    
    There is no need to grab the i_mutex of the IO lock in exclusive
    mode if we don't need to invalidate the page cache. Taking these
    locks on every direct IO effective serialises them as taking the IO
    lock in exclusive mode has to wait for all shared holders to drop
    the lock. That only happens when IO is complete, so effective it
    prevents dispatch of concurrent direct IO reads to the same inode.
    
    Fix this by taking the IO lock shared to check the page cache state,
    and only then drop it and take the IO lock exclusively if there is
    work to be done. Hence for the normal direct IO case, no exclusive
    locking will occur.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Joern Engel <joern@logfs.org>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7f7b424..8fd4a07 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -317,7 +317,19 @@ xfs_file_aio_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (unlikely(ioflags & IO_ISDIRECT)) {
+	/*
+	 * Locking is a bit tricky here. If we take an exclusive lock
+	 * for direct IO, we effectively serialise all new concurrent
+	 * read IO to this file and block it behind IO that is currently in
+	 * progress because IO in progress holds the IO lock shared. We only
+	 * need to hold the lock exclusive to blow away the page cache, so
+	 * only take lock exclusively if the page cache needs invalidation.
+	 * This allows the normal direct IO case of no page cache pages to
+	 * proceeed concurrently without serialisation.
+	 */
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
+		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
 		if (inode->i_mapping->nrpages) {
@@ -330,8 +342,7 @@ xfs_file_aio_read(
 			}
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-	} else
-		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--ZPt4rx8FFjLCG7dd--
