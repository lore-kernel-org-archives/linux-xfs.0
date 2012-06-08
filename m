Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58LS53T259190 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 16:28:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id r2PNAF4o5SuxNxaF for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 14:28:03 -0700 (PDT)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH] fs: push rcu_barrier() from deactivate_locked_super() to
	filesystems
Date: Sat,  9 Jun 2012 00:28:50 +0300
Message-Id: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.cz>, Kai Bankett <chaosman@ontika.net>, logfs@logfs.org, Frederic Weisbecker <fweisbec@gmail.com>, Anders Larsen <al@alarsen.net>, Trond Myklebust <Trond.Myklebust@netapp.com>, William Irwin <wli@holomorphy.com>, "Dmitry V. Levin" <ldv@altlinux.org>, David Howells <dhowells@redhat.com>, Dustin Kirkland <dustin.kirkland@gazzang.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Petr Vandrovec <petr@vandrovec.name>, linux-afs@lists.infradead.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu, Chris Mason <chris.mason@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-mtd@lists.infradead.org, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, Prasad Joshi <prasadjoshi.linux@gmail.com>, Evgeniy Dushistov <dushistov@mail.ru>, Nick Piggin <npiggin@kernel.dk>, Eric Van Hensbergen <ericvh@gmail.com>, Tao Ma <boyu.mt@taobao.com>, Joern Engel <joern@logfs.org>, ecryptfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Seth Forshee <seth.forshee@canonical.com>, Ben Myers <bpm@sgi.com>, Josh Boyer <jwboyer@redhat.com>, Joel Becker <jlbec@evilplan.org>, Timo Warns <warns@pre-sense.de>, Ron Minnich <rminnich@sandia.gov>, ceph-devel@vger.kernel.org, Anton Altaparmakov <anton@tuxera.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, codalist@TELEMANN.coda.cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>, linux-ntfs-dev@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>, samba-technical@lists.samba.org, Adrian Hunter <adrian.hunter@intel.com>, Tyler Hicks <tyhicks@canonical.com>, Steve French <sfrench@samba.org>, Benny Halevy <bhalevy@tonian.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

There's no reason to call rcu_barrier() on every deactivate_locked_super().
We only need to make sure that all delayed rcu free inodes are flushed
before we destroy related cache.

Removing rcu_barrier() from deactivate_locked_super() affects some
fas paths. E.g. on my machine exit_group() of a last process in IPC
namespace takes 0.07538s. rcu_barrier() takes 0.05188s of that time.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/9p/v9fs.c             |    5 +++++
 fs/adfs/super.c          |    5 +++++
 fs/affs/super.c          |    5 +++++
 fs/afs/super.c           |    5 +++++
 fs/befs/linuxvfs.c       |    5 +++++
 fs/bfs/inode.c           |    5 +++++
 fs/btrfs/extent_io.c     |    6 ++++++
 fs/btrfs/inode.c         |    5 +++++
 fs/ceph/super.c          |    5 +++++
 fs/cifs/cifsfs.c         |    5 +++++
 fs/coda/inode.c          |    5 +++++
 fs/ecryptfs/main.c       |    6 ++++++
 fs/efs/super.c           |    5 +++++
 fs/exofs/super.c         |    5 +++++
 fs/ext2/super.c          |    5 +++++
 fs/ext3/super.c          |    5 +++++
 fs/ext4/super.c          |    5 +++++
 fs/fat/inode.c           |    5 +++++
 fs/freevxfs/vxfs_super.c |    5 +++++
 fs/fuse/inode.c          |    6 ++++++
 fs/hfs/super.c           |    6 ++++++
 fs/hfsplus/super.c       |    6 ++++++
 fs/hpfs/super.c          |    5 +++++
 fs/hugetlbfs/inode.c     |    5 +++++
 fs/isofs/inode.c         |    5 +++++
 fs/jffs2/super.c         |    6 ++++++
 fs/jfs/super.c           |    6 ++++++
 fs/logfs/inode.c         |    5 +++++
 fs/minix/inode.c         |    5 +++++
 fs/ncpfs/inode.c         |    5 +++++
 fs/nfs/inode.c           |    5 +++++
 fs/nilfs2/super.c        |    6 ++++++
 fs/ntfs/super.c          |    6 ++++++
 fs/ocfs2/dlmfs/dlmfs.c   |    5 +++++
 fs/ocfs2/super.c         |    5 +++++
 fs/openpromfs/inode.c    |    5 +++++
 fs/qnx4/inode.c          |    5 +++++
 fs/qnx6/inode.c          |    5 +++++
 fs/reiserfs/super.c      |    5 +++++
 fs/romfs/super.c         |    5 +++++
 fs/squashfs/super.c      |    5 +++++
 fs/super.c               |    6 ------
 fs/sysv/inode.c          |    5 +++++
 fs/ubifs/super.c         |    6 ++++++
 fs/udf/super.c           |    5 +++++
 fs/ufs/super.c           |    5 +++++
 fs/xfs/xfs_super.c       |    5 +++++
 47 files changed, 240 insertions(+), 6 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index b85efa7..392c5da 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -560,6 +560,11 @@ static int v9fs_init_inode_cache(void)
  */
 static void v9fs_destroy_inode_cache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(v9fs_inode_cache);
 }
 
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 06fdcc9..f137165 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -276,6 +276,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(adfs_inode_cachep);
 }
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0782653..4fe18a8 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -129,6 +129,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(affs_inode_cachep);
 }
 
diff --git a/fs/afs/super.c b/fs/afs/super.c
index f02b31e..af69050 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -123,6 +123,11 @@ void __exit afs_fs_exit(void)
 		BUG();
 	}
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(afs_inode_cachep);
 	_leave("");
 }
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index e18da23..02f3331 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -454,6 +454,11 @@ befs_init_inodecache(void)
 static void
 befs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(befs_inode_cachep);
 }
 
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9870417..d5fc598 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -280,6 +280,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(bfs_inode_cachep);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2c8f7b2..010623a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -106,6 +106,12 @@ void extent_io_exit(void)
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
+
+	/*
+	 * Make sure all delayed rcu free are flushed before we
+	 * destroy caches.
+	 */
+	rcu_barrier();
 	if (extent_state_cache)
 		kmem_cache_destroy(extent_state_cache);
 	if (extent_buffer_cache)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f6ab6f5..971d222 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6976,6 +6976,11 @@ static void init_once(void *foo)
 
 void btrfs_destroy_cachep(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	if (btrfs_inode_cachep)
 		kmem_cache_destroy(btrfs_inode_cachep);
 	if (btrfs_trans_handle_cachep)
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 1e67dd7..ecc251e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -602,6 +602,11 @@ bad_cap:
 
 static void destroy_caches(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ceph_inode_cachep);
 	kmem_cache_destroy(ceph_cap_cachep);
 	kmem_cache_destroy(ceph_dentry_cachep);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8b6e344..93ce9b3f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -975,6 +975,11 @@ cifs_init_inodecache(void)
 static void
 cifs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(cifs_inode_cachep);
 }
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index f181312..0c70460 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -85,6 +85,11 @@ int coda_init_inodecache(void)
 
 void coda_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(coda_inode_cachep);
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 6895493..f6acf8a 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -693,6 +693,12 @@ static void ecryptfs_free_kmem_caches(void)
 {
 	int i;
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+
 	for (i = 0; i < ARRAY_SIZE(ecryptfs_cache_infos); i++) {
 		struct ecryptfs_cache_info *info;
 
diff --git a/fs/efs/super.c b/fs/efs/super.c
index e755ec7..2002431 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -96,6 +96,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(efs_inode_cachep);
 }
 
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 4337836..d271f96 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -206,6 +206,11 @@ static int init_inodecache(void)
  */
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(exofs_inode_cachep);
 }
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b3621cb..de2051c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -204,6 +204,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext2_inode_cachep);
 }
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 8c3a44b..bd60e08 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -543,6 +543,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext3_inode_cachep);
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..4e2aacb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1046,6 +1046,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext4_inode_cachep);
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a3d81eb..35113bc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -526,6 +526,11 @@ static int __init fat_init_inodecache(void)
 
 static void __exit fat_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(fat_inode_cachep);
 }
 
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index d4fabd2..fed2c8a 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -279,6 +279,11 @@ static void __exit
 vxfs_cleanup(void)
 {
 	unregister_filesystem(&vxfs_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(vxfs_inode_cachep);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1cd6165..9078173 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1171,6 +1171,12 @@ static void fuse_fs_cleanup(void)
 {
 	unregister_filesystem(&fuse_fs_type);
 	unregister_fuseblk();
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 7b4c537..373a9e5 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -483,6 +483,12 @@ static int __init init_hfs_fs(void)
 static void __exit exit_hfs_fs(void)
 {
 	unregister_filesystem(&hfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hfs_inode_cachep);
 }
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index a9bca4b..bde9ecf 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -615,6 +615,12 @@ static int __init init_hfsplus_fs(void)
 static void __exit exit_hfsplus_fs(void)
 {
 	unregister_filesystem(&hfsplus_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hfsplus_inode_cachep);
 }
 
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..3cb1da5 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -210,6 +210,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hpfs_inode_cachep);
 }
 
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cc9281b..b482175 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1042,6 +1042,11 @@ static int __init init_hugetlbfs_fs(void)
 
 static void __exit exit_hugetlbfs_fs(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
 	kern_unmount(hugetlbfs_vfsmount);
 	unregister_filesystem(&hugetlbfs_fs_type);
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 29037c3..f94cde4 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -114,6 +114,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(isofs_inode_cachep);
 }
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 61ea413..ff48795 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -418,6 +418,12 @@ static void __exit exit_jffs2_fs(void)
 	unregister_filesystem(&jffs2_fs_type);
 	jffs2_destroy_slab_caches();
 	jffs2_compressors_exit();
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(jffs2_inode_cachep);
 }
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 4a82950..2fc7602 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -898,6 +898,12 @@ static void __exit exit_jfs_fs(void)
 	jfs_proc_clean();
 #endif
 	unregister_filesystem(&jfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(jfs_inode_cachep);
 }
 
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index a422f42..3d1b9fa 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -401,5 +401,10 @@ int logfs_init_inode_cache(void)
 
 void logfs_destroy_inode_cache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(logfs_inode_cache);
 }
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 2a503ad..dc8d362 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -100,6 +100,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(minix_inode_cachep);
 }
 
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 333df07..0c62c55 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -89,6 +89,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ncp_inode_cachep);
 }
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e605d69..39aae2e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1566,6 +1566,11 @@ static int __init nfs_init_inodecache(void)
 
 static void nfs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(nfs_inode_cachep);
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1099a76..956e5a4 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1386,6 +1386,12 @@ static void nilfs_segbuf_init_once(void *obj)
 
 static void nilfs_destroy_cachep(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+
 	if (nilfs_inode_cachep)
 		kmem_cache_destroy(nilfs_inode_cachep);
 	if (nilfs_transaction_cachep)
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index b341492..ecc8625 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3185,6 +3185,12 @@ static void __exit exit_ntfs_fs(void)
 	ntfs_debug("Unregistering NTFS driver.");
 
 	unregister_filesystem(&ntfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ntfs_big_inode_cache);
 	kmem_cache_destroy(ntfs_inode_cache);
 	kmem_cache_destroy(ntfs_name_cache);
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e31d6ae..6934459 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -691,6 +691,11 @@ static void __exit exit_dlmfs_fs(void)
 	flush_workqueue(user_dlm_worker);
 	destroy_workqueue(user_dlm_worker);
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(dlmfs_inode_cache);
 
 	bdi_destroy(&dlmfs_backing_dev_info);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 68f4541..0e91ec2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1818,6 +1818,11 @@ static int ocfs2_initialize_mem_caches(void)
 
 static void ocfs2_free_mem_caches(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	if (ocfs2_inode_cachep)
 		kmem_cache_destroy(ocfs2_inode_cachep);
 	ocfs2_inode_cachep = NULL;
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index bc49c97..1b76370 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -463,6 +463,11 @@ static int __init init_openprom_fs(void)
 static void __exit exit_openprom_fs(void)
 {
 	unregister_filesystem(&openprom_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(op_inode_cachep);
 }
 
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 552e994..9534b4f 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -391,6 +391,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(qnx4_inode_cachep);
 }
 
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index e44012d..3cba5d2 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -652,6 +652,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(qnx6_inode_cachep);
 }
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 651ce76..ad39139 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -603,6 +603,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(reiserfs_inode_cachep);
 }
 
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index e64f6b5..f901eaf 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -648,6 +648,11 @@ error_register:
 static void __exit exit_romfs_fs(void)
 {
 	unregister_filesystem(&romfs_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(romfs_inode_cachep);
 }
 
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 29cd014..260e392 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -425,6 +425,11 @@ static int __init init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(squashfs_inode_cachep);
 }
 
diff --git a/fs/super.c b/fs/super.c
index cf00177..2d962aa 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -256,12 +256,6 @@ void deactivate_locked_super(struct super_block *s)
 
 		/* caches are now gone, we can safely kill the shrinker now */
 		unregister_shrinker(&s->s_shrink);
-
-		/*
-		 * We need to call rcu_barrier so all the delayed rcu free
-		 * inodes are flushed before we release the fs module.
-		 */
-		rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 08d0b25..a08341c 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -376,5 +376,10 @@ int __init sysv_init_icache(void)
 
 void sysv_destroy_icache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(sysv_inode_cachep);
 }
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 5862dd9..e8ae748 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2302,6 +2302,12 @@ static void __exit ubifs_exit(void)
 	dbg_debugfs_exit();
 	ubifs_compressors_exit();
 	unregister_shrinker(&ubifs_shrinker_info);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ubifs_inode_slab);
 	unregister_filesystem(&ubifs_fs_type);
 }
diff --git a/fs/udf/super.c b/fs/udf/super.c
index ac8a348..ebe9f52 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -170,6 +170,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(udf_inode_cachep);
 }
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 302f340..f655c1d 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1449,6 +1449,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ufs_inode_cachep);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..bbcbf2a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1582,6 +1582,11 @@ xfs_init_zones(void)
 STATIC void
 xfs_destroy_zones(void)
 {
+	/*
+	 * Make sure all delayed rcu free are flushed before we
+	 * destroy caches.
+	 */
+	rcu_barrier();
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
