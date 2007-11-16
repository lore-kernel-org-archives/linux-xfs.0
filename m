Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 20:36:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAG4aH3n003812
	for <xfs@oss.sgi.com>; Thu, 15 Nov 2007 20:36:19 -0800
Message-ID: <473D1DE0.1090106@sgi.com>
Date: Fri, 16 Nov 2007 15:34:40 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] bulkstat fixups
References: <4733EEF2.9010504@sgi.com> <20071111214759.GS995458@sgi.com> <4737C11D.8030007@sgi.com> <20071112041121.GT66820511@sgi.com>
In-Reply-To: <20071112041121.GT66820511@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------050609080409070302010801"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------050609080409070302010801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updated patch - I added cond_resched() calls into each loop - for loops that
have a 'continue' somewhere in them I added the cond_resched() at the start,
otherwise I put it at the end.

David Chinner wrote:
> On Mon, Nov 12, 2007 at 01:57:33PM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> [Lachlan, can you wrap your email text at 72 columns for ease of quoting?]
>>>
>>> On Fri, Nov 09, 2007 at 04:24:02PM +1100, Lachlan McIlroy wrote:
>>>> Here's a collection of fixups for bulkstat for all the remaining issues.
>>>>
>>>> - sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()
>>> OK.
>>>
>>>> - remove the special case for XFS_IOC_FSBULKSTAT with count == 1.  This 
>>>> special
>>>>  case causes bulkstat to fail because the special case uses 
>>>>  xfs_bulkstat_single()
>>>>  instead of xfs_bulkstat() and the two functions have different 
>>>>  semantics.
>>>>  xfs_bulkstat() will return the next inode after the one supplied while 
>>>>  skipping
>>>>  internal inodes (ie quota inodes).  xfs_bulkstate_single() will only 
>>>>  lookup the
>>>>  inode supplied and return an error if it is an internal inode.
>>> Userspace visile change. What applications do we have that rely on this
>>> behaviour that will be broken by this change?
>> Any apps that rely on the existing behaviour are probably broken.  If an app
>> wants to call xfs_bulkstat_single() it should use XFS_IOC_FSBULKSTAT_SINGLE.
> 
> Perhaps, but we can't arbitrarily decide that those apps will now break on
> a new kernel with this change. At minimum we need to audit all of the code
> we have that uses bulkstat for such breakage (including DMF!) before we make a
> change like this.

I've looked through everything we have in xfs-cmds and nothing relies on
this bug being present.  Vlad helped me with the DMF side - DMF does not
use the XFS_IOC_FSBULKSTAT ioctl, it has it's own interface into the kernel
which calls xfs_bulkstat() directly so it wont be affected by this change.

> 
>>>> - checks against 'ubleft' (the space left in the user's buffer) should be 
>>>> against
>>>>  'statstruct_size' which is the supplied minimum object size.  The 
>>>>  mixture of
>>>>  checks against statstruct_size and 0 was one of the reasons we were 
>>>>  skipping
>>>>  inodes.
>>> Can you wrap these checks in a static inline function so that it is obvious
>>> what the correct way to check is and we don't reintroduce this porblem? 
>>> i.e.
>>>
>>> static inline int
>>> xfs_bulkstat_ubuffer_large_enough(ssize_t space)
>>> {
>>> 	return (space > sizeof(struct blah));
>>> }
>>>
>>> That will also remove a stack variable....
>> That won't work - statstruct_size is passed into xfs_bulkstat() so we don't
>> know what 'blah' is.  Maybe a macro would be easier.
>>
>> #define XFS_BULKSTAT_UBLEFT	(ubleft >= statstruct_size)
> 
> Yeah, something like that, but I don't like macros with no parameters used
> like that....
> 
>>> FWIW - missing from this set of patches - cpu_relax() in the loops. In the 
>>> case
>>> where no I/O is required to do the scan, we can hold the cpu for a long 
>>> time
>>> and that will hold off I/O completion, etc for the cpu bulkstat is running 
>>> on.
>>> Hence after every cluster we scan we should cpu_relax() to allow other
>>> processes cpu time on that cpu.
>>>
>> I don't get how cpu_relax() works.  I see that it is called at times with a
>> spinlock held so it wont trigger a context switch.  Does it give interrupts 
>> a chance to run?
> 
> Sorry, my mistake - confused cpu_relax() with cond_resched(). take the above
> paragraph and s/cpu_relax/cond_resched/g
> 
>> It appears to be used where a minor delay is needed - I don't think we have 
>> any
>> cases in xfs_bulkstat() where we need to wait for an event that isn't I/O.
> 
> The issue is when we're hitting cached buffers and we never end up waiting
> for I/O - we will then monopolise the cpu we are running on and hold off
> all other processing. It's antisocial and leads to high latencies for other
> code.
> 
> Cheers,
> 
> Dave.

--------------050609080409070302010801
Content-Type: text/x-patch;
 name="bulkstat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bulkstat.diff"

--- fs/xfs/xfs_itable.c_1.157	2007-10-25 17:22:09.000000000 +1000
+++ fs/xfs/xfs_itable.c	2007-11-16 14:52:31.000000000 +1100
@@ -316,6 +316,8 @@ xfs_bulkstat_use_dinode(
 	return 1;
 }
 
+#define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
+
 /*
  * Return stat information in bulk (by-inode) for the filesystem.
  */
@@ -353,7 +355,7 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
-	xfs_ino_t		lastino=0; /* last inode number returned */
+	xfs_ino_t		lastino; /* last inode number returned */
 	int			nbcluster; /* # of blocks in a cluster */
 	int			nicluster; /* # of inodes in a cluster */
 	int			nimask;	/* mask for inode clusters */
@@ -373,6 +375,7 @@ xfs_bulkstat(
 	 * Get the last inode value, see if there's nothing to do.
 	 */
 	ino = (xfs_ino_t)*lastinop;
+	lastino = ino;
 	dip = NULL;
 	agno = XFS_INO_TO_AGNO(mp, ino);
 	agino = XFS_INO_TO_AGINO(mp, ino);
@@ -382,6 +385,9 @@ xfs_bulkstat(
 		*ubcountp = 0;
 		return 0;
 	}
+	if (!ubcountp || *ubcountp <= 0) {
+		return EINVAL;
+	}
 	ubcount = *ubcountp; /* statstruct's */
 	ubleft = ubcount * statstruct_size; /* bytes */
 	*ubcountp = ubelem = 0;
@@ -402,7 +408,8 @@ xfs_bulkstat(
 	 * inode returned; 0 means start of the allocation group.
 	 */
 	rval = 0;
-	while (ubleft >= statstruct_size && agno < mp->m_sb.sb_agcount) {
+	while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
+		cond_resched();
 		bp = NULL;
 		down_read(&mp->m_peraglock);
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
@@ -499,6 +506,7 @@ xfs_bulkstat(
 					break;
 				error = xfs_inobt_lookup_ge(cur, agino, 0, 0,
 							    &tmp);
+				cond_resched();
 			}
 			/*
 			 * If ran off the end of the ag either with an error,
@@ -542,6 +550,7 @@ xfs_bulkstat(
 			 */
 			agino = gino + XFS_INODES_PER_CHUNK;
 			error = xfs_inobt_increment(cur, 0, &tmp);
+			cond_resched();
 		}
 		/*
 		 * Drop the btree buffers and the agi buffer.
@@ -555,15 +564,16 @@ xfs_bulkstat(
 		 */
 		irbufend = irbp;
 		for (irbp = irbuf;
-		     irbp < irbufend && ubleft >= statstruct_size; irbp++) {
+		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ubleft); irbp++) {
 			/*
 			 * Now process this chunk of inodes.
 			 */
 			for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
-			     ubleft > 0 &&
+			     XFS_BULKSTAT_UBLEFT(ubleft) &&
 				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
 			     chunkidx++, clustidx++, agino++) {
 				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
+				cond_resched();
 				/*
 				 * Recompute agbno if this is the
 				 * first inode of the cluster.
@@ -663,15 +673,13 @@ xfs_bulkstat(
 						ubleft, private_data,
 						bno, &ubused, dip, &fmterror);
 				if (fmterror == BULKSTAT_RV_NOTHING) {
-                                        if (error == EFAULT) {
-                                                ubleft = 0;
-                                                rval = error;
-                                                break;
-                                        }
-					else if (error == ENOMEM)
+					if (error && error != ENOENT &&
+						error != EINVAL) {
 						ubleft = 0;
-					else
-						lastino = ino;
+						rval = error;
+						break;
+					}
+					lastino = ino;
 					continue;
 				}
 				if (fmterror == BULKSTAT_RV_GIVEUP) {
@@ -686,6 +694,8 @@ xfs_bulkstat(
 				ubelem++;
 				lastino = ino;
 			}
+
+			cond_resched();
 		}
 
 		if (bp)
@@ -694,11 +704,12 @@ xfs_bulkstat(
 		/*
 		 * Set up for the next loop iteration.
 		 */
-		if (ubleft > 0) {
+		if (XFS_BULKSTAT_UBLEFT(ubleft)) {
 			if (end_of_ag) {
 				agno++;
 				agino = 0;
-			}
+			} else
+				agino = XFS_INO_TO_AGINO(mp, lastino);
 		} else
 			break;
 	}
@@ -707,6 +718,11 @@ xfs_bulkstat(
 	 */
 	kmem_free(irbuf, irbsize);
 	*ubcountp = ubelem;
+	/*
+	 * Found some inodes, return them now and return the error next time.
+	 */
+	if (ubelem)
+		rval = 0;
 	if (agno >= mp->m_sb.sb_agcount) {
 		/*
 		 * If we ran out of filesystem, mark lastino as off

--------------050609080409070302010801--
