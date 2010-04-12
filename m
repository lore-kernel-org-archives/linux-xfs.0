Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1InuQ177997 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1235E2BA419
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	e1z3eTnP9ZMYBUv9 for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:12:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH] inode64 feature bit (was Re: [PATCH] enable inode64
	by default when possible)
Message-ID: <20100412061212.GE2493@dastard>
References: <4B7309D7.5090800@sandeen.net>
 <1270850499.7840.25.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270850499.7840.25.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 09, 2010 at 05:01:39PM -0500, Alex Elder wrote:
> On Wed, 2010-02-10 at 13:32 -0600, Eric Sandeen wrote:
> > Taking another swing at this.
> > 
> > As XFS continues to position itself as the choice for very
> > large Linux filesystems, we need to be mindful of the problems
> > that the 32-bit inode restriction can cause with allocations
> > and performance.
> > 
> > As such, this patch changes the default to inode64 whenever
> > XFS_BIG_INUMS is set, which in turn depends on either
> > CONFIG_LBDAF or 64-bit longs.
> > 
> > Going forward, we may wish to do this unconditionally for all
> > filesystems by choosing CONFIG_LBDAF by default when xfs is
> > chosen, but I'll leave that for later.
> > 
> > This patch adds a "noinode64" option for backwards compatibility.
> 
> OK, it's been about two months since Eric proposed this, and
> I'm finally getting around to writing up a response.
> 
> I discussed this with a few people within SGI, and there were
> two main concerns that were mentioned:
> - This may be a problem for some NFS clients
> - This may be a problem for some backup software
> We don't believe there are any direct issues with DMF or CXFS
> in making this change.

That's been the status quo since I've been involved with NFS and
XFS...

> I understand that the change is only in the default behavior,
> and that forcing 32-bit inodes will still be an available
> option.
> 
> On NFS, there is a "fileid" automatic variable in nfs_do_filldir()
> that holds the inode number, and that variable was not made to
> have an explicitly 64-bit type (it had been "unsigned long")
> until Linux 2.6.24.  Therefore, on 32-bit systems prior to that
> release there may be problems with 64-bit inodes.

NFS clients on other OS's will have issues, too, but I'd think they
are getting towards legacy status, now....

> On backup software, there was at one time a restriction with
> EMC Networker backup that required that only 32-bit inodes be
> used in a file system in order to work correctly.  This was
> reportedly a very difficult requirement to work around.  (I
> made a small effort to get confirmation that this either is
> still the case--or that it has since been resolved--but so
> far I don't know the answer.)

Yeah, well, legato/EMC had been asked repeatedly over a period of
7-8 years to support 64 bit inode numbers and refused every time, so
I'd say "screw 'em" if they still can't support 64 bit inode numbers
yet. i.e. I don't consider Networker as a valid excuse for not
enabling 64 bit inodes in XFS anymore...

> There could be other issues, but the point is that there do
> exist "reasonable" scenarios that still require that the
> file system enforce all inode numbers fit into 32 bits.

Sure, but this situation is rapidly becoming the domain of
interop with legacy systems, so having to speicify a non-default
option for this makes sense to me....

> There is no on-disk recording of whether any >32-bit
> inode numbers are already allocated in a given XFS file
> system (although a scan of inodes on large file systems
> could determine whether any is in use).  There is also
> no way for user space (or NFS for that matter) to query
> whether a particular file system has inodes that require
> >32 bits to represent.  So at this point it's not possible
> for scenarios that have 32-bit inode number requirements
> to defend themselves against a file system that doesn't
> satisfy the requirement.
> 
> I am in favor of changing the default as you propose.
> There's no reason we couldn't add the new "32-bit inodes"
> mount option first before changing which is used by default.
> 
> I would really like to develop a way to indicate
> whether a given file system uses large (>32 bit) inode
> numbers, and have an implementation in place before
> committing to the 64-bit default.  We could record
> a ">32 bit inode present" condition on the superblock
> somehow, or otherwise determine it at mount time,
> for example.  Applications may find it useful to
> expose this information to user space as well.
> 
> Beyond that, my only comment on your patch is that I
> think I'd prefer "inode32" rather than "noinode64" as
> the name of the new mount option, and choose an
> appropriate mechanism for selecting which or rejecting
> a mount if both are specified.
> 
> What do you think?

Well, patches speak louder than discussion. ;) See below for a patch
(untested) I think does what you outline above. Only difference is
that you need to set inode64 mount option until a new 64 bit inode
is created in an existing filesystem. I'll need to do followup
patches for mkfs, db, admin and repair to support the feature bit,
but this is at least enough for feature bit semantic discussions....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: record 64 bit inode filesytsems in the superblock

From: Dave Chinner <dchinner@redhat.com>

Add a feature bit to the the superblock to record whether 64 bit inodes have
been allocated on the filesystem or not. This allows us to reject mounting the
filesytem with inode32 if 64 bit inodes are present.

Once a 64 bitinode is allocated, the inode64 superblock feature bit will be set.
Once the superblock feature bit is set, the filesystem will default to 64 bit
inodes regardless of whether inode64 is specified as a mount option.

To ensure only 32 bit inodes are created, the inode32 mount option must be
used. If there are already 64 bit inodes as flagged by the superblock feature
bit, then the inode32 mount will be refused.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   14 +++++++++++++-
 fs/xfs/xfs_ialloc.c          |   13 +++++++++++++
 fs/xfs/xfs_sb.h              |   13 +++++++++++++
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index aa11204..679cd89 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -94,6 +94,7 @@ mempool_t *xfs_ioend_pool;
 					 * unwritten extent conversion */
 #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
 #define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
+#define MNTOPT_32BITINODE   "inode32"	/* inodes allowed in first 32 bits */
 #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
 #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
 #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
@@ -196,7 +197,8 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	if (!xfs_sb_version_hasinode64(&mp->m_sb))
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -309,6 +311,15 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
+			if (xfs_sb_version_hasinode64(&mp->m_sb)) {
+				cmn_err(CE_WARN,
+					"XFS: 64 bit inodes present. "
+					"%s option not allowed on this system",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_flags |= ~XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
@@ -534,6 +545,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 9d884c1..9f35e0e 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1013,6 +1013,19 @@ alloc_inode:
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 	xfs_perag_put(pag);
+
+	/* set the inode64 feature bit if necessary */
+	if (ino > XFS_MAXINUMBER_32 &&
+	    !xfs_sb_version_hasinode64(&mp->m_sb)) {
+		spin_lock(&mp->m_sb_lock);
+		if (!xfs_sb_version_hasinode64(&mp->m_sb)) {
+			xfs_sb_version_addinode64(&mp->m_sb);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
+		} else
+			spin_unlock(&mp->m_sb_lock);
+	}
+
 	*inop = ino;
 	return 0;
 error1:
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 1b017c6..5eb3e71 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -80,6 +80,7 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
+#define XFS_SB_VERSION2_INODE64		0x00000020	/* 64 bit inodes */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
@@ -495,6 +496,18 @@ static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
 
+static inline int xfs_sb_version_hasinode64(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_INODE64);
+}
+
+static inline void xfs_sb_version_addinode64(xfs_sb_t *sbp)
+{
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_INODE64;
+}
+
 /*
  * end of superblock version macros
  */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
