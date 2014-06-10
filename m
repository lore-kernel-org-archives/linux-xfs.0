Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E0507F66
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 00:53:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 566888F8087
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 22:53:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7sUzeMy1RrzLJJgr for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 22:52:58 -0700 (PDT)
Date: Tue, 10 Jun 2014 15:52:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair issue with ACLs on v5 XFS when beyond v4 limits
Message-ID: <20140610055254.GF9508@dastard>
References: <5396799F.3050801@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5396799F.3050801@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 09, 2014 at 11:21:03PM -0400, Michael L. Semon wrote:
> Hi!  I've been running around in circles trying to work with too many 
> ACLs, even losing my ability to count for a while.  Along the way, 
> xfs_repair from git xfsprogs (last commit around May 27) is showing 
> the following symptoms:
> 
> On v5-superblock XFS...
> 
> 1) When the ACL count is just above the limit from v4-superblock XFS--
> 96 is a good test figure--`xfs_repair -n` and `xfs_repair` will both 
> end in a segmentation fault.

I couldn't reproduce this - I suspect that this is a problem with
the ACL struct having a hardcoded array size or userspace not
having the correct padding in the on-disk structure definition and
you are on a 32bit system. I think I've fixed that in the patch
below.

> 
> 2) When the ACL count is in a higher range--as low as 250, IIRC--
> xfs_repair will complain about "Too many ACL entries" and proceed to 
> remove them.  Below is a full session:

Yup, never been taught about the expanded ACL count. I didn't even
realised that repair validated acls directly...

> 
> root@oldsvrhw:~# mkfs.xfs -f -m crc=1 $SCRATCH_DEV
> meta-data=/dev/sdb5              isize=512    agcount=4, agsize=786432 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=0
> data     =                       bsize=4096   blocks=3145728, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> root@oldsvrhw:~# mount $SCRATCH_DEV $SCRATCH_MNT
> 
> root@oldsvrhw:~# mkdir $SCRATCH_MNT/acl-dir
> 
> root@oldsvrhw:~# for a in `seq 1000 1325`; do setfacl -d -m u:$a:r-- $SCRATCH_MNT/acl-dir; done
.....

Ok, I can reproduce that, and I've fixed it in the patch below.

> 3) When the ACL count is at the max for v5-superblock XFS--at least 
> with both regular and default ACL slots filled--xfs_repair will 
> complain of corrupt remote attributes.  AFAIK, xfs_repair doesn't 
> bother with the "Too many ACL entries" line.  Those ACLs will be 
> cleansed, too.

Ok, I see that, too:

        - agno = 0
Metadata corruption detected at block 0x190/0x1000
Corrupt remote block for attributes of inode 67

Ah, of course - there was an off-by-one in the remote attr max size
validation that we fixed in the kernel. The kernel code hasn't been
siynced to userspace yet. Ok, the patch below fixes that as well.

Can you turn this into a new fstest so we
don't break this accidentally again?

Can you try the patch below? It should fix the problem you are
seeing.

> Sorry I missed this one in all of my limits testing.  This was 
> discovered when I saw a bug in my ACL population script and hit 
> Ctrl-c so I could stop and edit the script.  Donations of brown paper 
> bags are welcome...the plastic bags I'm using make it hard to breathe 
> and don't hide my face very well...

We've all missed it, so pass the paper bags all around. To prevent
this from happening again in future, can you wrap this all up in a
new generic fstest that creates several different numbers of ACLs
on a file and runs repair on the filesystem after each incremental
increase in the number of ACLs?

Thanks for the testing and the bug report, Michael!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

repair: support more than 25 ACLs

From: Dave Chinner <dchinner@redhat.com>

v5 superblock supports many more than 25 ACLs on an inode, but
xfs_repair still thinks that the maximum is 25. Fix it and update
the ACL definitions to match the kernel definitions. Also fix the
remote attr maximum size off-by-one that the maximum number of v5
ACLs tickles.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_attr_remote.c |  2 +-
 repair/attr_repair.c     | 68 ++++++++++++++++++++++++++++++++----------------
 repair/attr_repair.h     | 46 +++++++++++++++++++++++---------
 3 files changed, 79 insertions(+), 37 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5cf5c73..08b983b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -85,7 +85,7 @@ xfs_attr3_rmt_verify(
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
+				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 5dd7e5f..5ff1647 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -25,7 +25,7 @@
 #include "protos.h"
 #include "dir2.h"
 
-static int xfs_acl_valid(xfs_acl_disk_t *daclp);
+static int xfs_acl_valid(struct xfs_mount *mp, struct xfs_acl *daclp);
 static int xfs_mac_valid(xfs_mac_label_t *lp);
 
 /*
@@ -734,11 +734,16 @@ verify_da_path(xfs_mount_t	*mp,
  * If value is non-zero, then a remote attribute is being passed in
  */
 static int
-valuecheck(char *namevalue, char *value, int namelen, int valuelen)
+valuecheck(
+	struct xfs_mount *mp,
+	char		*namevalue,
+	char		*value,
+	int		namelen,
+	int		valuelen)
 {
 	/* for proper alignment issues, get the structs and memmove the values */
 	xfs_mac_label_t macl;
-	xfs_acl_t thisacl;
+	struct xfs_acl thisacl;
 	void *valuep;
 	int clearit = 0;
 
@@ -746,13 +751,13 @@ valuecheck(char *namevalue, char *value, int namelen, int valuelen)
 			(strncmp(namevalue, SGI_ACL_DEFAULT,
 				SGI_ACL_DEFAULT_SIZE) == 0)) {
 		if (value == NULL) {
-			memset(&thisacl, 0, sizeof(xfs_acl_t));
-			memmove(&thisacl, namevalue+namelen, valuelen);
+			memset(&thisacl, 0, sizeof(struct xfs_acl));
+			memmove(&thisacl, namevalue + namelen, valuelen);
 			valuep = &thisacl;
 		} else
 			valuep = value;
 
-		if (xfs_acl_valid((xfs_acl_disk_t *)valuep) != 0) {
+		if (xfs_acl_valid(mp, valuep) != 0) {
 			clearit = 1;
 			do_warn(
 	_("entry contains illegal value in attribute named SGI_ACL_FILE "
@@ -800,6 +805,7 @@ valuecheck(char *namevalue, char *value, int namelen, int valuelen)
  */
 static int
 process_shortform_attr(
+	struct xfs_mount *mp,
 	xfs_ino_t	ino,
 	xfs_dinode_t	*dip,
 	int		*repair)
@@ -904,7 +910,7 @@ process_shortform_attr(
 
 		/* Only check values for root security attributes */
 		if (currententry->flags & XFS_ATTR_ROOT)
-		       junkit = valuecheck((char *)&currententry->nameval[0],
+		       junkit = valuecheck(mp, (char *)&currententry->nameval[0],
 					NULL, currententry->namelen, 
 					currententry->valuelen);
 
@@ -1039,6 +1045,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 
 static int
 process_leaf_attr_local(
+	struct xfs_mount	*mp,
 	xfs_attr_leafblock_t	*leaf,
 	int			i,
 	xfs_attr_leaf_entry_t	*entry,
@@ -1076,7 +1083,7 @@ process_leaf_attr_local(
 
 	/* Only check values for root security attributes */
 	if (entry->flags & XFS_ATTR_ROOT) {
-		if (valuecheck((char *)&local->nameval[0], NULL, 
+		if (valuecheck(mp, (char *)&local->nameval[0], NULL, 
 				local->namelen, be16_to_cpu(local->valuelen))) {
 			do_warn(
 	_("bad security value for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
@@ -1134,7 +1141,7 @@ process_leaf_attr_remote(
 			i, ino);
 		goto bad_free_out;
 	}
-	if (valuecheck((char *)&remotep->name[0], value, remotep->namelen,
+	if (valuecheck(mp, (char *)&remotep->name[0], value, remotep->namelen,
 				be32_to_cpu(remotep->valuelen))) {
 		do_warn(
 	_("remote attribute value check failed for entry %d, inode %" PRIu64 "\n"),
@@ -1216,15 +1223,15 @@ process_leaf_attr_block(
 			break;	/* got an overlap */
 		}
 
-		if (entry->flags & XFS_ATTR_LOCAL) 
-			thissize = process_leaf_attr_local(leaf, i, entry,
+		if (entry->flags & XFS_ATTR_LOCAL)
+			thissize = process_leaf_attr_local(mp, leaf, i, entry,
 						last_hashval, da_bno, ino);
 		else
 			thissize = process_leaf_attr_remote(leaf, i, entry,
 						last_hashval, da_bno, ino,
 						mp, blkmap);
 		if (thissize < 0) {
-			clearit = 1;				
+			clearit = 1;
 			break;
 		}
 
@@ -1608,15 +1615,19 @@ process_longform_attr(
 
 
 static int
-xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
+xfs_acl_from_disk(
+	struct xfs_mount	*mp,
+	struct xfs_icacl	**aclp,
+	struct xfs_acl		*dacl)
 {
 	int			count;
-	xfs_acl_t		*acl;
-	xfs_acl_entry_t 	*ace;
-	xfs_acl_entry_disk_t	*dace, *end;
+	int			size;
+	struct xfs_icacl	*acl;
+	struct xfs_icacl_entry	*ace;
+	struct xfs_acl_entry	*dace, *end;
 
 	count = be32_to_cpu(dacl->acl_cnt);
-	if (count > XFS_ACL_MAX_ENTRIES) {
+	if (count > XFS_ACL_MAX_ENTRIES(mp)) {
 		do_warn(_("Too many ACL entries, count %d\n"), count);
 		*aclp = NULL;
 		return EINVAL;
@@ -1624,7 +1635,16 @@ xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
 
 
 	end = &dacl->acl_entry[0] + count;
-	acl = malloc((int)((char *)end - (char *)dacl));
+	size = sizeof(dacl->acl_cnt) + (count * sizeof(struct xfs_acl_entry));
+	if (size != (int)((char *)end - (char *)dacl)) {
+		do_warn(_("ACL count (%d) does not match buffer size (%d/%d)\n"),
+			  count, size, (int)((char *)end - (char *)dacl));
+		*aclp = NULL;
+		return EINVAL;
+	}
+
+	acl = malloc(sizeof(struct xfs_icacl) +
+		     count * sizeof(struct xfs_icacl_entry));
 	if (!acl) {
 		do_warn(_("cannot malloc enough for ACL attribute\n"));
 		do_warn(_("SKIPPING this ACL\n"));
@@ -1667,7 +1687,7 @@ process_attributes(
 	if (aformat == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(be16_to_cpu(asf->hdr.totsize) <=
 			XFS_DFORK_ASIZE(dip, mp));
-		err = process_shortform_attr(ino, dip, repair);
+		err = process_shortform_attr(mp, ino, dip, repair);
 	} else if (aformat == XFS_DINODE_FMT_EXTENTS ||
 					aformat == XFS_DINODE_FMT_BTREE)  {
 			err = process_longform_attr(mp, ino, dip, blkmap,
@@ -1686,17 +1706,19 @@ process_attributes(
  * Validate an ACL
  */
 static int
-xfs_acl_valid(xfs_acl_disk_t *daclp)
+xfs_acl_valid(
+	struct xfs_mount *mp,
+	struct xfs_acl	*daclp)
 {
-	xfs_acl_t	*aclp = NULL;
-	xfs_acl_entry_t *entry, *e;
+	struct xfs_icacl	*aclp = NULL;
+	struct xfs_icacl_entry	*entry, *e;
 	int user = 0, group = 0, other = 0, mask = 0, mask_required = 0;
 	int i, j;
 
 	if (daclp == NULL)
 		goto acl_invalid;
 
-	switch (xfs_acl_from_disk(&aclp, daclp)) {
+	switch (xfs_acl_from_disk(mp, &aclp, daclp)) {
 	case ENOMEM:
 		return 0;
 	case EINVAL:
diff --git a/repair/attr_repair.h b/repair/attr_repair.h
index f42536a..0d0c62c 100644
--- a/repair/attr_repair.h
+++ b/repair/attr_repair.h
@@ -37,29 +37,49 @@ typedef __int32_t	xfs_acl_type_t;
 typedef __int32_t	xfs_acl_tag_t;
 typedef __int32_t	xfs_acl_id_t;
 
-typedef struct xfs_acl_entry {
+/*
+ * "icacl" = in-core ACL. There is no equivalent in the XFS kernel code,
+ * so they are magic names just for repair. The "acl" types are what the kernel
+ * code uses for the on-disk format names, so use them here too for the on-disk
+ * ACL format definitions.
+ */
+struct xfs_icacl_entry {
 	xfs_acl_tag_t	ae_tag;
 	xfs_acl_id_t	ae_id;
 	xfs_acl_perm_t	ae_perm;
-} xfs_acl_entry_t;
+};
 
-#define XFS_ACL_MAX_ENTRIES	25
-typedef struct xfs_acl {
-	__int32_t	acl_cnt;
-	xfs_acl_entry_t	acl_entry[XFS_ACL_MAX_ENTRIES];
-} xfs_acl_t;
+struct xfs_icacl {
+	__int32_t		acl_cnt;
+	struct xfs_icacl_entry	acl_entry[0];
+};
 
-typedef struct xfs_acl_entry_disk {
+struct xfs_acl_entry {
 	__be32		ae_tag;
 	__be32		ae_id;
 	__be16		ae_perm;
-} xfs_acl_entry_disk_t;
+	__be16		ae_pad;
+};
 
-typedef struct xfs_acl_disk {
-	__be32		acl_cnt;
-	xfs_acl_entry_disk_t	acl_entry[XFS_ACL_MAX_ENTRIES];
-} xfs_acl_disk_t;
+struct xfs_acl {
+	__be32			acl_cnt;
+	struct xfs_acl_entry	acl_entry[0];
+};
 
+/*
+ * The number of ACL entries allowed is defined by the on-disk format.
+ * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
+ * limited only by the maximum size of the xattr that stores the information.
+ */
+#define XFS_ACL_MAX_ENTRIES(mp) \
+	(xfs_sb_version_hascrc(&mp->m_sb) \
+		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
+						sizeof(struct xfs_acl_entry) \
+		: 25)
+
+#define XFS_ACL_MAX_SIZE(mp) \
+	(sizeof(struct xfs_acl) + \
+		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
 
 #define SGI_ACL_FILE	"SGI_ACL_FILE"
 #define SGI_ACL_DEFAULT	"SGI_ACL_DEFAULT"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
