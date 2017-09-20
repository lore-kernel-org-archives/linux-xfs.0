Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbdITLFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Sep 2017 07:05:09 -0400
Date: Wed, 20 Sep 2017 19:05:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] test race when checking i_size on direct i/o read
Message-ID: <20170920110504.GU8034@eguan.usersys.redhat.com>
References: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
 <20170919073616.GP8034@eguan.usersys.redhat.com>
 <20170919141351.GB3487@bfoster.bfoster>
 <20170919143406.GA7437@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919143406.GA7437@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:34:06AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 10:13:52AM -0400, Brian Foster wrote:
> > Can we pass a boolean or flag to xfs_iomap_write_unwritten() to have it
> > update the incore i_size after unwritten extent conversion? Then move
> > (or remove) the associated update from xfs_dio_write_end_io().
> 
> I don't think we even need a flag - all three callers of
> xfs_iomap_write_unwritten want to update the file size.

I tried this approach, but seems there's some problem in the buffered
aio path, generic/112 (aio fsx) failed quickly. But I haven't digged
into the reason (maybe I screwed it up, not the method is wrong..).

Then I tried Brian's suggestion, pass a boolean to
xfs_iomap_write_unwritten() to tell if we want it to update in-core
isize after unwritten extent conversion, and skip the in-core isize
update in xfs_dio_write_end_io() accordingly. This approach seems to
work, it passed the test Eric posted here, and fstests 'aio' group
tests, a run of 'quick' group didn't find any new failure as well.

I attached the WIP patch (without proper comments) I was testing, if
this looks fine I can format a formal patch and do more testings.

Thanks,
Eryu

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 29172609f2a3..288da47e9ac5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -343,7 +343,7 @@ xfs_end_io(
 		error = xfs_reflink_end_cow(ip, offset, size);
 		break;
 	case XFS_IO_UNWRITTEN:
-		error = xfs_iomap_write_unwritten(ip, offset, size);
+		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 		break;
 	default:
 		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 350b6d43ba23..f3ad024573e7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -435,6 +435,7 @@ xfs_dio_write_end_io(
 	struct xfs_inode	*ip = XFS_I(inode);
 	loff_t			offset = iocb->ki_pos;
 	bool			update_size = false;
+	bool			write_unwritten = (flags & IOMAP_DIO_UNWRITTEN);
 	int			error = 0;
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
@@ -458,7 +459,8 @@ xfs_dio_write_end_io(
 	 */
 	spin_lock(&ip->i_flags_lock);
 	if (offset + size > i_size_read(inode)) {
-		i_size_write(inode, offset + size);
+		if (!write_unwritten)
+			i_size_write(inode, offset + size);
 		update_size = true;
 	}
 	spin_unlock(&ip->i_flags_lock);
@@ -469,8 +471,8 @@ xfs_dio_write_end_io(
 			return error;
 	}
 
-	if (flags & IOMAP_DIO_UNWRITTEN)
-		error = xfs_iomap_write_unwritten(ip, offset, size);
+	if (write_unwritten)
+		error = xfs_iomap_write_unwritten(ip, offset, size, update_size);
 	else if (update_size)
 		error = xfs_setfilesize(ip, offset, size);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a1909bc064e9..0a088586371e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -829,7 +829,8 @@ int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
-	xfs_off_t	count)
+	xfs_off_t	count,
+	bool		update_size)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -840,6 +841,7 @@ xfs_iomap_write_unwritten(
 	xfs_trans_t	*tp;
 	xfs_bmbt_irec_t imap;
 	struct xfs_defer_ops dfops;
+	struct inode	*inode = VFS_I(ip);
 	xfs_fsize_t	i_size;
 	uint		resblks;
 	int		error;
@@ -900,6 +902,13 @@ xfs_iomap_write_unwritten(
 		if (i_size > offset + count)
 			i_size = offset + count;
 
+		if (update_size) {
+			spin_lock(&ip->i_flags_lock);
+			if (i_size > i_size_read(inode))
+				i_size_write(inode, i_size);
+			spin_unlock(&ip->i_flags_lock);
+		}
+
 		i_size = xfs_new_eof(ip, i_size);
 		if (i_size) {
 			ip->i_d.di_size = i_size;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 00db3ecea084..ee535065c5d0 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -27,7 +27,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
 int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
 			struct xfs_bmbt_irec *);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
+int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 2f2dc3c09ad0..4246876df7b7 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -274,7 +274,7 @@ xfs_fs_commit_blocks(
 					(end - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(error);
 
-		error = xfs_iomap_write_unwritten(ip, start, length);
+		error = xfs_iomap_write_unwritten(ip, start, length, false);
 		if (error)
 			goto out_drop_iolock;
 	}
