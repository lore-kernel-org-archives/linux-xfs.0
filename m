Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 23:07:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4T674Xi029919
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 23:07:06 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA21313 for <xfs@oss.sgi.com>; Thu, 29 May 2008 16:07:56 +1000
Date: Thu, 29 May 2008 16:09:41 +1000
Subject: REVIEW: fix up xfs_repair I/O size for filesystems with >= 16KB filesystem blocksize
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------qdbq859JlvQAf3J6ERfKN9
MIME-Version: 1.0
Message-ID: <op.ubwjeftu3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------qdbq859JlvQAf3J6ERfKN9
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

For 4KB block size filesystems (the default), inode chunks are read and=20=
=20
written
in 8KB "clusters". With a 16KB block size (possible on ia64 boxes), the=20=
=20
inode
chunks are read/written in 16KB I/Os (matches the filesystem block size).

This patch fixes up the I/Os for filesystems with a blocksize greater than=
=20=20
8KB.

Barry.



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/prefetch.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/prefetch.c	2008-05-29 16:00:34.000000000 +1000
+++ b/xfsprogs/repair/prefetch.c	2008-05-29 15:52:00.405480826 +1000
@@ -600,7 +600,6 @@ pf_queuing_worker(
  	ino_tree_node_t		*irec;
  	ino_tree_node_t		*cur_irec;
  	int			blks_per_cluster;
-	int			inos_per_cluster;
  	xfs_agblock_t		bno;
  	int			i;
  	int			err;
@@ -608,7 +607,6 @@ pf_queuing_worker(
  	blks_per_cluster =3D  XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
  	if (blks_per_cluster =3D=3D 0)
  		blks_per_cluster =3D 1;
-	inos_per_cluster =3D blks_per_cluster * mp->m_sb.sb_inopblock;

  	for (i =3D 0; i < PF_THREAD_COUNT; i++) {
  		err =3D pthread_create(&args->io_threads[i], NULL,
@@ -661,7 +659,7 @@ pf_queuing_worker(
  					(cur_irec->ino_isa_dir !=3D 0) ?
  						B_DIR_INODE : B_INODE);
  			bno +=3D blks_per_cluster;
-			num_inos +=3D inos_per_cluster;
+			num_inos +=3D inodes_per_cluster;
  		} while (num_inos < XFS_IALLOC_INODES(mp));
  	}

@@ -738,6 +736,7 @@ start_inode_prefetch(
  	prefetch_args_t		*prev_args)
  {
  	prefetch_args_t		*args;
+	long			max_queue;

  	if (!do_prefetch || agno >=3D mp->m_sb.sb_agcount)
  		return NULL;
@@ -757,8 +756,12 @@ start_inode_prefetch(
  	 * and not any other associated metadata like directories
  	 */

-	sem_init(&args->ra_count, 0, libxfs_bcache->c_maxcount / thread_count /
-		(XFS_IALLOC_BLOCKS(mp) / (XFS_INODE_CLUSTER_SIZE(mp) >>=20=20
mp->m_sb.sb_blocklog)) / 8);
+	max_queue =3D libxfs_bcache->c_maxcount / thread_count / 8;
+	if (XFS_INODE_CLUSTER_SIZE(mp) > mp->m_sb.sb_blocksize)
+		max_queue =3D max_queue * (XFS_INODE_CLUSTER_SIZE(mp) >>
+				mp->m_sb.sb_blocklog) / XFS_IALLOC_BLOCKS(mp);
+
+	sem_init(&args->ra_count, 0, max_queue);

  	if (!prev_args) {
  		if (!pf_create_prefetch_thread(args))

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/xfs_repair.c	2008-05-29 16:00:34.000000000 +1000
+++ b/xfsprogs/repair/xfs_repair.c	2008-05-29 15:49:06.100019069 +1000
@@ -572,7 +572,8 @@ main(int argc, char **argv)

  	chunks_pblock =3D mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
  	max_symlink_blocks =3D howmany(MAXPATHLEN - 1, mp->m_sb.sb_blocksize);
-	inodes_per_cluster =3D XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	inodes_per_cluster =3D MAX(mp->m_sb.sb_inopblock,
+			XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);

  	if (ag_stride) {
  		thread_count =3D (glob_agcount + ag_stride - 1) / ag_stride;
------------qdbq859JlvQAf3J6ERfKN9
Content-Disposition: attachment; filename=fix_16k_fsb_repair.patch
Content-Type: text/x-patch; name=fix_16k_fsb_repair.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/prefetch.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/prefetch.c	2008-05-29 16:00:34.000000000 +1000
+++ b/xfsprogs/repair/prefetch.c	2008-05-29 15:52:00.405480826 +1000
@@ -600,7 +600,6 @@ pf_queuing_worker(
 	ino_tree_node_t		*irec;
 	ino_tree_node_t		*cur_irec;
 	int			blks_per_cluster;
-	int			inos_per_cluster;
 	xfs_agblock_t		bno;
 	int			i;
 	int			err;
@@ -608,7 +607,6 @@ pf_queuing_worker(
 	blks_per_cluster =3D  XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
 	if (blks_per_cluster =3D=3D 0)
 		blks_per_cluster =3D 1;
-	inos_per_cluster =3D blks_per_cluster * mp->m_sb.sb_inopblock;
=20
 	for (i =3D 0; i < PF_THREAD_COUNT; i++) {
 		err =3D pthread_create(&args->io_threads[i], NULL,
@@ -661,7 +659,7 @@ pf_queuing_worker(
 					(cur_irec->ino_isa_dir !=3D 0) ?
 						B_DIR_INODE : B_INODE);
 			bno +=3D blks_per_cluster;
-			num_inos +=3D inos_per_cluster;
+			num_inos +=3D inodes_per_cluster;
 		} while (num_inos < XFS_IALLOC_INODES(mp));
 	}
=20
@@ -738,6 +736,7 @@ start_inode_prefetch(
 	prefetch_args_t		*prev_args)
 {
 	prefetch_args_t		*args;
+	long			max_queue;
=20
 	if (!do_prefetch || agno >=3D mp->m_sb.sb_agcount)
 		return NULL;
@@ -757,8 +756,12 @@ start_inode_prefetch(
 	 * and not any other associated metadata like directories
 	 */
=20
-	sem_init(&args->ra_count, 0, libxfs_bcache->c_maxcount / thread_count /
-		(XFS_IALLOC_BLOCKS(mp) / (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_bloc=
klog)) / 8);
+	max_queue =3D libxfs_bcache->c_maxcount / thread_count / 8;
+	if (XFS_INODE_CLUSTER_SIZE(mp) > mp->m_sb.sb_blocksize)
+		max_queue =3D max_queue * (XFS_INODE_CLUSTER_SIZE(mp) >>
+				mp->m_sb.sb_blocklog) / XFS_IALLOC_BLOCKS(mp);
+
+	sem_init(&args->ra_count, 0, max_queue);
=20
 	if (!prev_args) {
 		if (!pf_create_prefetch_thread(args))

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/xfs_repair.c	2008-05-29 16:00:34.000000000 +1000
+++ b/xfsprogs/repair/xfs_repair.c	2008-05-29 15:49:06.100019069 +1000
@@ -572,7 +572,8 @@ main(int argc, char **argv)
=20
 	chunks_pblock =3D mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
 	max_symlink_blocks =3D howmany(MAXPATHLEN - 1, mp->m_sb.sb_blocksize);
-	inodes_per_cluster =3D XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	inodes_per_cluster =3D MAX(mp->m_sb.sb_inopblock,
+			XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
=20
 	if (ag_stride) {
 		thread_count =3D (glob_agcount + ag_stride - 1) / ag_stride;

------------qdbq859JlvQAf3J6ERfKN9--
