Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 098E57F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 19:21:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A50FAC001
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 17:21:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mzfPSrtjo3RQylon for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 17:21:09 -0700 (PDT)
Date: Fri, 31 Oct 2014 11:09:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141031000954.GL13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141030230457.GK13323@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Fri, Oct 31, 2014 at 10:04:57AM +1100, Dave Chinner wrote:
> On Thu, Oct 30, 2014 at 04:39:01PM +0800, Tommy Wu wrote:
> > I'm confusing now...
> > 
> > in the test VM and one of my machine, rebuild xfsdump/xfsprogs will make
> > the test work.
> 
> I know why, too.
> 
> > the xfsdump command I use:
> > xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump
> > /mnt/backup > xfsdump.log
> > the log:
> > https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ
> 
> This indicates the bulkstat on the dump side was terminated
> prematurely.
> 
> > the xfsrestore command I use:
> > xfsrestore -v debug,tree=nitty -p 300 -J -f test.xfsdump /vol/backup/x/ >
> > xfsrestore.log
> > the log:
> > https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI
> 
> And the errors in the restore side are because there are missing
> directory inodes in the dump, hence orphaning occurs.
> 
> It might take me a little while to come up with a fix - I've noticed
> a few things that I need to check out in more detail in tracking
> this down....

Can you try this patch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: handle munged bulkstat cookies correctly

From: Dave Chinner <dchinner@redhat.com>

xfsdump munges the last inode cookie that bulkstat passes to
userspace so subsequent calls can restart at the last inode that
bulkstat parsed. xfsdump thinks that it needs to decrement the
cookie so that it catches the last inode, and this affects the
tree search initialisation code.

By decrementing the lastino cookie, the restart inode number can
point to non-existent inode number. In 3.16, bulkstat would simply
increment the cookie until it either found the next valid inode or
the end of the AG, at which point it would just continue on as
though nothing had happened. This is a relatively difficult
situation to contrive so is extremely hard to test for, but is
likely to occur fairly frequently in the real world.

The current code, however, treats a cookie that points off into the
weeds as invalid and returns a error. This has the effect of causing
xfsdump to think it has reached the end of the bulkstat scan, and so
if it's cookie munging happens just wrong it will cause incomplete
dumps to occur. These dumps still have all the file data in them,
just he directory structure is broken and so restore will end up
with lots and lots of files in the orphanage (i.e. lost+found).

IOWs, we broke xfsdump in a nasty, subtle way that users don't
notice until they restore a dump.

To fix this, restore the old behaviour of incrementing the inode
number derived from the cookie when we fail to find a matching inode
record.

cc: stable@vger.kernel.org
Reported-by: Tommy Wu <wu.tommy@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_itable.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7765ff7..dcc0c99 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -208,6 +208,15 @@ xfs_bulkstat_ichunk_ra(
  * if we found the chunk.  If the inode was not the last in the chunk and there
  * are some left allocated, update the data for the pointed-to record as well as
  * return the count of grabbed inodes.
+ *
+ * If this is the first lookup in a bulkstat call, we have to be careful about
+ * the agino that is passed - it may not point to a valid inode record. xfsdump,
+ * in particular, screws with the lastino cookie between bulkstat calls and so
+ * can point it off into the weeds. Hence we can't return an error here if
+ * the agino doesn't point to the correct inode chunk. The previous code simply
+ * incremented agino and tried again. This will work for xfsdump as the next
+ * lookup will either find the correct chunk or the end of the AG, so let's just
+ * keep doing that.
  */
 STATIC int
 xfs_bulkstat_grab_ichunk(
@@ -226,7 +235,7 @@ xfs_bulkstat_grab_ichunk(
 		return error;
 	if (!stat) {
 		*icount = 0;
-		return error;
+		return 0;
 	}
 
 	/* Get the record, should always work */
@@ -236,8 +245,11 @@ xfs_bulkstat_grab_ichunk(
 	XFS_WANT_CORRUPTED_RETURN(stat == 1);
 
 	/* Check if the record contains the inode in request */
-	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
-		return -EINVAL;
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
+		/* oops, someone is feeding us garbage! */
+		*icount = -1;
+		return 0;
+	}
 
 	idx = agino - irec->ir_startino + 1;
 	if (idx < XFS_INODES_PER_CHUNK &&
@@ -428,6 +440,17 @@ xfs_bulkstat(
 			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
 			if (error)
 				goto del_cursor;
+			if (icount < 0) {
+				/*
+				 * A pox be cast over xfsdump!
+				 *
+				 * No record containing agino was found.  Bump
+				 * it, try again until we find a chunk or fall
+				 * off the end of the AG.
+				 */
+				agino++;
+				goto del_cursor;
+			}
 			if (icount) {
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
@@ -435,14 +458,17 @@ xfs_bulkstat(
 				irbp++;
 				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			}
+
 			/* Increment to the next record */
 			error = xfs_btree_increment(cur, 0, &tmp);
 		} else {
 			/* Start of ag.  Lookup the first inode chunk */
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
 		}
-		if (error)
+		if (error || tmp == 0) {
+			end_of_ag = 1;
 			goto del_cursor;
+		}
 
 		/*
 		 * Loop through inode btree records in this ag,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
