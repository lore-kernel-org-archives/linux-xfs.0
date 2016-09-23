Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43021 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965908AbcIWQOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 12:14:02 -0400
Date: Fri, 23 Sep 2016 09:13:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 3/4] vfs: allow vfs_copy_file_range() across file
 systems
Message-ID: <20160923161350.GN9314@birch.djwong.org>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-4-git-send-email-amir73il@gmail.com>
 <CAOQ4uxiZBE_2qy86b6x19opLcGbMzhtqrWBkFZqHeQnZgHtJfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiZBE_2qy86b6x19opLcGbMzhtqrWBkFZqHeQnZgHtJfQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 23, 2016 at 10:57:56AM +0300, Amir Goldstein wrote:
> On Wed, Sep 14, 2016 at 3:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > copy_file_range syscall returns -EXDEV if src and dest
> > file are not on the same file system.
> > The vfs_copy_file_range() helper, however, knows how to copy
> > across file systems with do_splice_direct().
> >
> > Move the enforcement of same file system from the vfs helper
> > to the syscall code.
> >
> > A following patch is going to use the vfs_copy_file_range()
> > helper in overlayfs to copy up between lower and upper
> > not on the same file system.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/read_write.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 9dc6e52..6975fe8 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1502,10 +1502,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> >             (file_out->f_flags & O_APPEND))
> >                 return -EBADF;
> >
> > -       /* this could be relaxed once a method supports cross-fs copies */
> > -       if (inode_in->i_sb != inode_out->i_sb)
> > -               return -EXDEV;
> > -
> >         if (len == 0)
> >                 return 0;
> >
> > @@ -1514,7 +1510,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> >                 return ret;
> >
> >         ret = -EOPNOTSUPP;
> > -       if (file_out->f_op->copy_file_range)
> > +       /* copy_file_range() method does not support cross-fs copies */
> > +       if (inode_in->i_sb == inode_out->i_sb &&
> > +           file_out->f_op->copy_file_range)
> >                 ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
> >                                                       pos_out, len, flags);
> >         if (ret == -EOPNOTSUPP)
> > @@ -1569,6 +1567,14 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
> >                 pos_out = f_out.file->f_pos;
> >         }
> >
> > +       /*
> > +        * vfs_copy_file_range() can do cross-fs copy, but we want to
> > +        * fulfill the guaranty to userland that copy_file_range syscall
> > +        * does not allow cross-fs copy
> > +        */
> > +       if (file_inode(f_in.file)->i_sb != file_inode(f_out.file)->i_sb)
> > +               return -EXDEV;
> 
> Oops, that was supposed to be goto out;
> Anyway, I am holding back on the vfs_copy_file_range() patches sub set
> until I have a reliable test on xfs to fall back from clone to copy range

Ok, attached are two rough patches -- one to add the error injection point
into the kernel, and a second one to add it to the xfs_io 'inject' command.
Note that you'll have to format the XFS filesystem with rmapbt=1 since we
can't otherwise avoid per-AG ENOSPC if rmap is enabled.

The relevant xfstests commands are:

_require_xfs_io_error_injection "ag_resv_critical"
_scratch_inject_error "ag_resv_critical"

See the xfs/325 test for a rough framework.  I'll work on cleaning up the
patches and trying to get them into 4.9.

--D

--0OAP2g/MAC+5xKAE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="kernel.patch"

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index adf770f..e5ebc37 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -109,7 +109,9 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS;
+	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL,
+			XFS_RANDOM_AG_RESV_CRITICAL);
 }
 
 /*
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 8d8e1b07..e539194 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -95,7 +95,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
-#define XFS_ERRTAG_MAX					27
+#define XFS_ERRTAG_AG_RESV_CRITICAL			27
+#define XFS_ERRTAG_MAX					28
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -127,6 +128,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
+#define XFS_RANDOM_AG_RESV_CRITICAL			1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7881142..ead31f8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1124,7 +1124,8 @@ xfs_reflink_ag_has_free_space(
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
-	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL))
+	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) ||
+	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
 		error = -ENOSPC;
 	xfs_perag_put(pag);
 	return error;

--0OAP2g/MAC+5xKAE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs.patch"

diff --git a/io/inject.c b/io/inject.c
index 56642b8..5d5e4ae 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -84,7 +84,9 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
-#define XFS_ERRTAG_MAX                                  27
+#define XFS_ERRTAG_AG_RESV_CRITICAL			27
+		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
+#define XFS_ERRTAG_MAX                                  28
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

--0OAP2g/MAC+5xKAE--
