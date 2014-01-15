Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AB6329E1A
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:52 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40534304032
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UrcL003620
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.652857621@sgi.com>
Date: Wed, 15 Jan 2014 16:00:18 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 06/17] xfs: (parent ptr) add parent pointer support to inode v5
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=06-pptr-add-inode-incore.patch
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
To: xfs@oss.sgi.com

Add the fields to inode v5 to track the parent inode number
and this entry's offset in the parent inode leaving the entries
in disk format.

---
 fs/xfs/xfs_dinode.h     |    4 +++-
 fs/xfs/xfs_inode_buf.c  |    6 ++++++
 fs/xfs/xfs_log_format.h |    4 +++-
 3 files changed, 12 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_dinode.h
===================================================================
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -79,7 +79,9 @@ typedef struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
+	__be64		di_parent;	/* inode of parent directory */
+	__be32		di_poffset;	/* offset into parent directory */
+	__u8		di_pad2[4];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
Index: b/fs/xfs/xfs_inode_buf.c
===================================================================
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -238,6 +238,9 @@ xfs_dinode_from_disk(
 		to->di_lsn = be64_to_cpu(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
+ 		/* parent pointer information is left in disk order */
+		to->di_parent = from->di_parent;
+		to->di_poffset = from->di_poffset;
 	}
 }
 
@@ -285,6 +288,9 @@ xfs_dinode_to_disk(
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
 		to->di_flushiter = 0;
+ 		/* parent pointer information is in disk order */
+		to->di_parent = from->di_parent;
+		to->di_poffset = from->di_poffset;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
Index: b/fs/xfs/xfs_log_format.h
===================================================================
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -399,7 +399,9 @@ typedef struct xfs_icdinode {
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+	__uint64_t	di_parent;	/* inode of parent directory */
+	__uint32_t	di_poffset;	/* offset into parent directory */
+	__uint8_t	di_pad2[4];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
