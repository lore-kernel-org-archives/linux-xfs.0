Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 518DE7F5E
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:25:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1518A8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:25:38 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:08 -0700
Message-Id: <1363213395-10988-7-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 07/14] xfs: Update ioctl(XFS_IOC_FREE_EOFBLOCKS) to handle
	callers in any userspace
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Modify the ioctl to convert from uids, gid, and projids in the
  current user namespace to kuids, kgids, and kprojids, and to report
  an error if the conversion fails.

- Create struct xfs_internal_eofblocks to hold the same information as
  struct xfs_eofblocks but with uids, gids, and projids stored as
  kuids, kgids, and kprojids preventing confusion.

- Pass struct xfs_interanl_eofblocks into xfs_icache_free_eofblocks
  and it's helpers ensuring there will not be confusing about which
  user namespace identifiers that need to be compared are in.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c |    8 ++++----
 fs/xfs/xfs_icache.h |   11 ++++++++++-
 fs/xfs/xfs_ioctl.c  |   22 +++++++++++++++++++++-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 03a4427..032c28c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1199,7 +1199,7 @@ xfs_reclaim_inodes_count(
 STATIC int
 xfs_inode_match_id(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_internal_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
 	    !uid_eq(ip->i_d.di_uid, eofb->eof_uid))
@@ -1210,7 +1210,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
-	    !projid_eq(ip->i_d.di_projid, eofb->eof_prid))
+	    !projid_eq(ip->i_d.di_projid, eofb->eof_projid))
 		return 0;
 
 	return 1;
@@ -1224,7 +1224,7 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
-	struct xfs_eofblocks *eofb = args;
+	struct xfs_internal_eofblocks *eofb = args;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1263,7 +1263,7 @@ xfs_inode_free_eofblocks(
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_internal_eofblocks	*eofb)
 {
 	int flags = SYNC_TRYLOCK;
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e0f138c..260dc27 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -35,9 +35,18 @@ void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+struct xfs_internal_eofblocks {
+	u32		eof_version;
+	u32		eof_flags;
+	kuid_t		eof_uid;
+	kgid_t		eof_gid;
+	kprojid_t	eof_projid;
+	u64		eof_min_file_size;
+};
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_internal_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9aeecfb..8c933e5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1615,6 +1615,7 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
 		struct xfs_eofblocks eofb;
+		struct xfs_internal_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
@@ -1629,7 +1630,26 @@ xfs_file_ioctl(
 		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
+		keofb.eof_version = eofb.eof_version;
+		keofb.eof_flags   = eofb.eof_flags;
+		if (eofb.eof_flags & XFS_EOF_FLAGS_UID) {
+			keofb.eof_uid = make_kuid(current_user_ns(), eofb.eof_uid);
+			if (!uid_valid(keofb.eof_uid))
+				return -XFS_ERROR(EINVAL);
+		}
+		if (eofb.eof_flags & XFS_EOF_FLAGS_GID) {
+			keofb.eof_gid = make_kgid(current_user_ns(), eofb.eof_gid);
+			if (!gid_valid(keofb.eof_gid))
+				return -XFS_ERROR(EINVAL);
+		}
+		if (eofb.eof_flags & XFS_EOF_FLAGS_PRID) {
+			keofb.eof_projid = make_kprojid(current_user_ns(), eofb.eof_prid);
+			if (!projid_valid(keofb.eof_projid))
+				return -XFS_ERROR(EINVAL);
+		}
+		keofb.eof_min_file_size = eofb.eof_min_file_size;
+
+		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
