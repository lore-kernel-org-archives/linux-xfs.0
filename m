Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C2B57F54
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 06:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0511030405F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 04:59:40 -0700 (PDT)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id uxm2RGz9MVVHCdDT (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 04:59:39 -0700 (PDT)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8E00MG66NEPC30@mailout2.samsung.com> for
	xfs@oss.sgi.com; Tue, 08 Jul 2014 20:59:38 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 1/3] fs: Add support IOC_MOV_DATA ioctl
Date: Tue, 08 Jul 2014 20:59:37 +0900
Message-id: <003e01cf9aa4$176da750$4648f5f0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

For speeding non linear media editing operations, we have already implemeted
FALLOC_FL_COLLAPSE_RANGE (merged in kernel since 3.15) and 
FALLOC_FL_INSERT_RANGE (currently awaiting review).
Both of these fallocate flags are used to remove/insert data within same file.
In continuation of our effort of speeding non linear media editing
(although the use case is not limited to just media editing) we introduce here
an ioctl FS_IOC_MOV_DATA which moves arbitrary (but fs block size aligned
as of now) bytes of data from one file into other file .

The movement takes place by transfering complete extents from donor file to
receiver file and leaves a hole in the donor file at the point from where
the blocks are moved. To eliminate the hole from donor, user can call
COLLAPSE_RANGE after the ioctl is finished if contiguous file space is required.

The main data structure for this ioctl is:
struct mov_data {
       int     donor_fd;               /* fd of donor file */
       int     receiver_fd;            /* fd of receiver file */
       loff_t  donor_offset;           /* offset into donor file */
       loff_t  receiver_offset;        /* offset into receiver file */
       loff_t  length;                 /* data length to be moved */
       loff_t  moved_len;              /* data length actually moved after completion */
       int     flags;                  /* Currently unused */
};

FS_IOC_MOV_DATA will move length bytes of data from donor_fd's donor_offset
to receiver_fd's receiver_offset. The prerequisite is that there must be 
atleast length size hole present @receiver_offset.

For inserting hole within file size at receiver_offset, FALLOC_FL_INSERT_RANGE
can be used. We will shortly post new version of FALLOC_FL_INSERT_RANGE which
enables inserting hole instead of current behavior of allocating unwritten
extents. If the requirement is to create hole at the end of file, truncate(2)
will suffice.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ioctl.c              | 108 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |   2 +
 include/uapi/linux/fs.h |  13 ++++++
 3 files changed, 123 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..a1508f8 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -215,6 +215,111 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+static int ioctl_mov_data(struct file *filp, unsigned long arg)
+{
+	int error;
+	struct mov_data m_data;
+	struct mov_data __user *um_data = (struct mov_data __user *) arg;
+	struct inode *donor, *receiver;
+	struct fd donor_fd, receiver_fd;
+
+	if (copy_from_user(&m_data, um_data, sizeof(struct mov_data)))
+		return -EFAULT;
+
+	if (m_data.donor_offset < 0 || m_data.receiver_offset < 0 ||
+	    m_data.length <= 0)
+		return -EINVAL;
+
+	donor_fd = fdget(m_data.donor_fd);
+	if (!donor_fd.file) {
+		error = -EINVAL;
+		goto out1;
+	}
+
+	if (!(donor_fd.file->f_mode & FMODE_WRITE) ||
+	    !(donor_fd.file->f_mode & FMODE_READ) ||
+	    (donor_fd.file->f_flags & O_APPEND)) {
+		error = -EBADF;
+		goto out1;
+	}
+
+	receiver_fd = fdget(m_data.receiver_fd);
+	if (!receiver_fd.file) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (!(receiver_fd.file->f_mode & FMODE_WRITE) ||
+	    !(receiver_fd.file->f_mode & FMODE_READ) ||
+	    (receiver_fd.file->f_flags & O_APPEND)) {
+		error = -EBADF;
+		goto out2;
+	}
+
+	donor = file_inode(donor_fd.file);
+	receiver = file_inode(receiver_fd.file);
+
+	if (donor->i_sb != receiver->i_sb) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (donor == receiver) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	error = security_file_permission(donor_fd.file, MAY_WRITE);
+	if (error)
+		goto out2;
+
+	error = security_file_permission(receiver_fd.file, MAY_WRITE);
+	if (error)
+		goto out2;
+
+	if (IS_IMMUTABLE(donor) || IS_IMMUTABLE(receiver)) {
+		error = -EPERM;
+		goto out2;
+	}
+
+	if (IS_SWAPFILE(donor) || IS_SWAPFILE(receiver)) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (S_ISFIFO(donor->i_mode) | S_ISFIFO(receiver->i_mode)) {
+		error = -ESPIPE;
+		goto out2;
+	}
+
+	if (!S_ISREG(donor->i_mode) || !S_ISREG(receiver->i_mode)) {
+		error = -ENODEV;
+		goto out2;
+	}
+
+	if (!donor->i_op->mov_data) {
+		error = -EOPNOTSUPP;
+		goto out2;
+	}
+
+	m_data.moved_len = 0;
+	sb_start_write(donor->i_sb);
+	error = donor->i_op->mov_data(donor, receiver, m_data.donor_offset,
+				      m_data.receiver_offset, m_data.length,
+				      &m_data.moved_len);
+	sb_end_write(donor->i_sb);
+
+	if (copy_to_user(um_data, &m_data, sizeof(struct mov_data)))
+		error = -EFAULT;
+
+out2:
+	fdput(receiver_fd);
+out1:
+	fdput(donor_fd);
+
+	return error;
+}
+
 #ifdef CONFIG_BLOCK
 
 static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
@@ -591,6 +696,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_MOV_DATA:
+		return ioctl_mov_data(filp, arg);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1649d9d..a13afe3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1520,6 +1520,8 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	int (*mov_data)(struct inode *, struct inode *, loff_t, loff_t,
+			loff_t, loff_t *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11b..6766d12 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -57,6 +57,18 @@ struct inodes_stat_t {
 	long dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+/*
+ * Structure passed to IOC_MOV_DATA
+ */
+struct mov_data {
+	int	donor_fd;		/* fd of donor file */
+	int	receiver_fd;		/* fd of receiver file */
+	loff_t	donor_offset;		/* offset into donor file */
+	loff_t	receiver_offset;	/* offset into receiver file */
+	loff_t	length;			/* data length to be moved */
+	loff_t	moved_len;		/* successfully moved length */
+	int	flags;			/* option to expand new feature */
+};
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -162,6 +174,7 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
+#define FS_IOC_MOV_DATA			_IOWR('f', 12, struct mov_data)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
