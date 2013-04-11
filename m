Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EE887FE0
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 01:25:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45E468F8050
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 23:25:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jHX5hskbPQtSrzqO for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 23:25:20 -0700 (PDT)
Date: Thu, 11 Apr 2013 16:25:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair breaks with assertion
Message-ID: <20130411062515.GH10481@dastard>
References: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
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
To: Victor K <kvic45@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 11, 2013 at 01:25:24PM +0800, Victor K wrote:
> Hello,
> 
> I'm trying to repair an XFS file system on our mdadm raid6 array after
> sudden system failure.
> Running xfs_repair /dev/md1 the first time resulted in suggestion to
> mount/unmount to replay log, but mounting would not work. After running
> xfs_repair -v -L -P /dev/md1 this happens:
> (lots of output on stderr, moving to Phase 3, then more output - not sure
> if it is relevant, the log file is ~170Mb in size), then stops and prints
> the only line on stdout:

Oh dear. A log file that big indicates that something *bad* has
happened to the array. i.e that it has most likely been put back
together wrong.

Before going any further with xfs_repair, please verify that the
array has been put back together correctly....

> xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i <
> *numrecs' failed.
> Aborted
> 
> After inserting a printf before the assert, I get the following:
> 
> i = 0, *numrecs = -570425343  for printf( "%d, %d")
> or
> i= 0, *numrecs = 3724541953  for printf("%ld, %ld) - makes me wonder if
> it's signed/unsigned int related

numrecs is way out of the normal range, so that's probably what is
triggering it.

i.e this in process_exinode():

	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);

is where the bad number is coming from, and that implies a corrupted
inode. it's a __be32 on disk, the kernel considers it a xfs_extnum_t
in memory which is a int32_t because:

#define NULLEXTNUM      ((xfs_extnum_t)-1)

So, negative numbers on disk are invalid.
....

The patch below should fix the assert failure.

> If I try now (after running xfs_repair -L) to mount the fs read-only, it
> mounts but says some directories have structures that need cleaning, so the
> dirs are inaccessible.
> 
> Any suggestion on how to possibly fix this?

I suspect you've damaged it beyond repair now.

If the array was put back together incorrectly in the first place
(which is likely given the damage being reported), then
you've made the problem a whole lot worse by writing to it in an
attempt to repair it.

I'd suggest that you make sure the array is correctly
repaired/ordered/reocvered before doing anything else, then
running xfs_repair on what is left and hoping for the best. Even after
repair is finished, you'll need to go through all the data with a
fine toothed comb to work out what has been lost, corrupted or
overwritten with zeros or other stuff.

I suspect you'll be reaching for the backup tapes long before you
get that far, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs_repair: validate on-disk extent count better

From: Dave Chinner <dchinner@redhat.com>

When scanning a btree format inode, we trust the extent count to be
in range.  However, values of the range 2^31 <= cnt < 2^32 are
invalid and can cause problems with signed range checks. This
results in assert failures which validating the extent count such
as:

xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i < *numrecs' failed.

Validate the extent count is at least within the positive range of a
singed 32 bit integer before using it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 5a2da39..239bb7b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1293,7 +1293,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_dfiloff_t		first_key;
 	xfs_dfiloff_t		last_key;
-	int			numrecs;
+	int32_t			numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1302,6 +1302,15 @@ process_exinode(
 	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
 
 	/*
+	 * We've already decided on the maximum number of extents on the inode,
+	 * and numrecs may be corrupt. Hence make sure we only allow numrecs to
+	 * be in the range of valid on-disk numbers, which is:
+	 *	0 < numrecs < 2^31 - 1
+	 */
+	if (numrecs < 0)
+		numrecs = *nex;
+
+	/*
 	 * XXX - if we were going to fix up the btree record,
 	 * we'd do it right here.  For now, if there's a problem,
 	 * we'll bail out and presumably clear the inode.
@@ -2038,11 +2047,23 @@ process_inode_data_fork(
 {
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int		err = 0;
+	int		nex;
+
+	/*
+	 * extent count on disk is only valid for positive values. The kernel
+	 * uses negative values in memory. hence if we see negative numbers
+	 * here, trash it!
+	 */
+	nex = be32_to_cpu(dino->di_nextents);
+	if (nex < 0)
+		*nextents = 1;
+	else
+		*nextents = nex;
 
-	*nextents = be32_to_cpu(dino->di_nextents);
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
+
 	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
