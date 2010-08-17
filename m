Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7HBjQNn046851 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 06:45:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 747F915D4848
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 04:55:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	2uwTSVHeJsO17zmU for <xfs@oss.sgi.com>;
	Tue, 17 Aug 2010 04:55:07 -0700 (PDT)
Date: Tue, 17 Aug 2010 21:45:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100817114550.GQ10429@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817090534.GP10429@dastard>
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
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Cc: xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 07:05:34PM +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2010 at 09:53:40AM +0200, Mario Bachmann wrote:
> > Am Tue, 17 Aug 2010 17:13:37 +1000 > schrieb Dave Chinner <david@fromorbit.com>:
> > > > Compiler: I use "gcc (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) 4.4.4". 
> > > > 
> > > > Testing List (on one machine only):
> > > > works:   x86_64, 2.6.34.4, xfsdump-3.0.1
> > > > works:   x86_64, 2.6.34.4, xfsdump-3.0.4
> > > > failure: x86_64, 2.6.35.2, xfsdump-3.0.1 (worked only one time)
> > > > failure: x86_64, 2.6.35.2, xfsdump-3.0.4
> > > 
> > > Ok, that makes more sense - we changed the way bulkstat works in
> > > from 2.6.34 to 2.6.35 to correctly validate inode numbers being
> > > passed in via bulkstat, and hence files unlinked during the dump run
> > > could return EINVAL when validating the directory structure (as they
> > > no longer exist). Is you system completely idle while the dump
> > > is running, or are files being removed while the dump is running?
> > 
> > I would call my system idle, when I use xfsdump. No rm or mv operations 
> > are running while the dump. The first machine has a dual core 2.9 GHz and
> > 8 GB of RAM and the filesystems are not really big (~10GB used). The second 
> > machine has a dual core 2 GHz and 2 GB of RAM. 
> 
> Yup, I have reproduced it here. What is strange is that xfs_fsr uses
> XFS_IOC_BULKSTAT_SINGLE, and that works fine on 2.6.35.2. The same
> ioctl calls from xfsdump are failing, though, so something funny is
> going on there.
> 
> I'll look into it further.

Ok, there is nothing wrong with the changes to the bulkstat code;
when all the inodes in the filesystem are hot in the inode cache
xfsdump succeeds.

When I run xfs_fsr per file to exercise the XFS_IOC_BULKSTAT_SINGLE
path like so:

$ sudo find /mnt/test -type f -exec xfs_fsr -d -v {} \;

It succeeds without any bulkstat failures. A subsequent xfsdump
invocation then succeeds without failure, either. Clearly the find
is populating the inode cache for the subsequent bulkstat calls,

Ok, so the reason this wasn't picked up is that xfs_fsr silently
ignores inodes that it gets an error from bulkstat on.

and it looks like
Dropping caches then running xfsdump:

$ sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
$ sudo xfsdump -l0 -L "Test" - /dev/vda 2> t.t |gzip - > ~/dump_test.gz

Results in failures.

/me sighs

My fault. I screwed up the btree lookup for the inode validation.
Can you test the patch below?

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

xfs: fix untrusted inode number lookup

From: Dave Chinner <dchinner@redhat.com>

Commit 7124fe0a5b619d65b739477b3b55a20bf805b06d ("xfs: validate untrusted inode
numbers during lookup") changes the inode lookup code to do btree lookups for
untrusted inode numbers. This change made an invalid assumption about the
alignment of inodes and hence incorrectly calculated the first inode in the
cluster. As a result, some inode numbers were being incorrectly considered
invalid when they were actually valid.

The issue was not picked up by the xfstests suite because it always runs fsr
and dump (the two utilities that utilise the bulkstat interface) on cache hot
inodes and hence the lookup code in the cold cache path was not sufficiently
exercised to uncover this intermittent problem.

Fix the issue by relaxing the btree lookup criteria and then checking if the
record returned contains the inode number we are lookup for. If it we get an
incorrect record, then the inode number is invalid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index abf80ae..5371d2d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1213,7 +1213,6 @@ xfs_imap_lookup(
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
-	xfs_agino_t		startino;
 	int			error;
 	int			i;
 
@@ -1227,13 +1226,13 @@ xfs_imap_lookup(
 	}
 
 	/*
-	 * derive and lookup the exact inode record for the given agino. If the
-	 * record cannot be found, then it's an invalid inode number and we
-	 * should abort.
+	 * Lookup the inode record for the given agino. If the record cannot be
+	 * found, then it's an invalid inode number and we should abort. Once
+	 * we have a record, we need to ensure it contains the inode number
+	 * we are looking up.
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-	startino = agino & ~(XFS_IALLOC_INODES(mp) - 1);
-	error = xfs_inobt_lookup(cur, startino, XFS_LOOKUP_EQ, &i);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
 			error = xfs_inobt_get_rec(cur, &rec, &i);
@@ -1246,6 +1245,11 @@ xfs_imap_lookup(
 	if (error)
 		return error;
 
+	/* check that the returned record contains the required inode */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+		return EINVAL;
+
 	/* for untrusted inodes check it is allocated first */
 	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
