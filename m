Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E58C07E9D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Sep 2022 18:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiI0Seo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiI0Sen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2022 14:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA9F4D4F9
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 11:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C21F61B0E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 18:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD18C433D6;
        Tue, 27 Sep 2022 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664303679;
        bh=fuzJOLAqsieOhgNHdK8p2DNb/KMOkCuAbDW9Fyq05so=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cboRUV8ddOo+mQstfrP+6EMW7GaCvRmswkhi0pt/6ETa87d9iiXn4XdSoO9fIBhke
         WkCD42lOsT2K+rwpOhAnCmaoOHAzKsZwhgHz5NRUifP0YElTZp6MnxSa1KXoelmLDg
         HtSgarMOKe2n5qRlJGgc2G/ksuVye5cQuXPbASOe8xkGVkrdk8BZxoEkZzRGnnENcg
         L0m+0NoQC9Lff3+f9i85guvCWutBeFDRFFShuf+xbvmcen9tXyRMtCb7t6kn+Altra
         eDdCz3trNF/8DI/FAAHT3qJ4W7EmNlq7QTSRlQbDRD3FXxDmS/jUZqLqc8ncq05ul2
         Qw4uS/PGLRLqQ==
Date:   Tue, 27 Sep 2022 11:34:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 24/26] xfs: Add parent pointer ioctl
Message-ID: <YzNCPld9zlU6dP8z@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-25-allison.henderson@oracle.com>
 <Yy5Pox+x86HvXoWj@magnolia>
 <b8fdb74201f4b9075c373637a592eaeda4e36c12.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8fdb74201f4b9075c373637a592eaeda4e36c12.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 26, 2022 at 09:50:53PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 17:30 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:56PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch adds a new file ioctl to retrieve the parent pointer of
> > > a
> > > given inode
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > 
> > To recap from the v2 thread:
> > 
> > Parent pointers are backwards links through the directory tree. 
> > xfsdump
> > already records the forward links in the dump file.  xfsrestore uses
> > those forward links to rebuild the directory tree, which recreates
> > the
> > parent pointers automatically.  Hence we don't need ATTRMULTI to
> > reveal
> > (or recreate) the parent pointer xattrs; the kernel does that when we
> > create the directory tree.
> > 
> > The second reason I can think of why we don't want to expose the
> > parent
> > pointers through the xattr APIs is that we don't want to reveal
> > ondisk
> > metadata directly to users -- some day we might want to change
> > wthat's
> > stored on disk, or store them in a totally separate structure, or
> > whatever.
> > 
> > If we force the interface to be the GETPARENTS ioctl, then we've
> > decoupled the front and backends.  I conclude that the /only/
> > userspace
> > API that should ever touch parent pointers is XFS_IOC_GETPARENTS.
> > 
> > > ---
> > >  fs/xfs/Makefile            |   1 +
> > >  fs/xfs/libxfs/xfs_fs.h     |  59 +++++++++++++++++
> > >  fs/xfs/libxfs/xfs_parent.c |  10 +++
> > >  fs/xfs/libxfs/xfs_parent.h |   2 +
> > >  fs/xfs/xfs_ioctl.c         | 106 ++++++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_ondisk.h        |   4 ++
> > >  fs/xfs/xfs_parent_utils.c  | 126
> > > +++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_parent_utils.h  |  11 ++++
> > >  8 files changed, 316 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > > index e2b2cf50ffcf..42d0496fdad7 100644
> > > --- a/fs/xfs/Makefile
> > > +++ b/fs/xfs/Makefile
> > > @@ -86,6 +86,7 @@ xfs-y                         += xfs_aops.o \
> > >                                    xfs_mount.o \
> > >                                    xfs_mru_cache.o \
> > >                                    xfs_pwork.o \
> > > +                                  xfs_parent_utils.o \
> > >                                    xfs_reflink.o \
> > >                                    xfs_stats.o \
> > >                                    xfs_super.o \
> > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > index b0b4d7a3aa15..42bb343f6952 100644
> > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > @@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
> > >  #define XFS_IOC_ATTR_SECURE    0x0008  /* use attrs in security
> > > namespace */
> > >  #define XFS_IOC_ATTR_CREATE    0x0010  /* fail if attr already
> > > exists */
> > >  #define XFS_IOC_ATTR_REPLACE   0x0020  /* fail if attr does not
> > > exist */
> > > +#define XFS_IOC_ATTR_PARENT    0x0040  /* use attrs in parent
> > > namespace */
> > 
> > We definitely don't need this in the userspace API anymore.
> We can take this out if it bothers folks, but I dont worry about this
> one since the multi list ioctls actually use the filter from the user

The fewer symbols we create in xfs_fs.h, the fewer userspace ABI we'll
have to support forever.  Plus, you already have a means to read all the
parent pointers.  I think that covers everything in your reply?

--D

> > 
> > >  typedef struct xfs_attrlist_cursor {
> > >         __u32           opaque[4];
> > > @@ -752,6 +753,63 @@ struct xfs_scrub_metadata {
> > >                                  XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
> > >  #define XFS_SCRUB_FLAGS_ALL    (XFS_SCRUB_FLAGS_IN |
> > > XFS_SCRUB_FLAGS_OUT)
> > >  
> > > +#define XFS_PPTR_MAXNAMELEN                            256
> > > +
> > > +/* return parents of the handle, not the open fd */
> > > +#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
> > > +
> > > +/* target was the root directory */
> > > +#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
> > > +
> > > +/* Cursor is done iterating pptrs */
> > > +#define XFS_PPTR_OFLAG_DONE    (1U << 2)
> > > +
> > > + #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE |
> > > XFS_PPTR_OFLAG_ROOT | \
> > > +                               XFS_PPTR_OFLAG_DONE)
> > > +
> > > +/* Get an inode parent pointer through ioctl */
> > > +struct xfs_parent_ptr {
> > > +       __u64           xpp_ino;                        /* Inode */
> > > +       __u32           xpp_gen;                        /* Inode
> > > generation */
> > > +       __u32           xpp_diroffset;                  /*
> > > Directory offset */
> > > +       __u32           xpp_rsvd;                       /* Reserved
> > > */
> > > +       __u32           xpp_pad;
> > 
> > No need for two empty __u32, right?
> Sure, will merge the fields
> 
> > 
> >         __u64           xpp_reserved;
> > 
> > > +       __u8            xpp_name[XFS_PPTR_MAXNAMELEN];  /* File
> > > name */
> > > +};
> > > +
> > > +/* Iterate through an inodes parent pointers */
> > > +struct xfs_pptr_info {
> > 
> > The fields in here ought to have short comments:
> > 
> > /* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
> > > +       struct xfs_handle               pi_handle;
> > 
> > /*
> >  * Structure to track progress in iterating the parent pointers.
> >  * Must be initialized to zeroes before the first ioctl call, and
> >  * not touched by callers after that.
> >  */
> > > +       struct xfs_attrlist_cursor      pi_cursor;
> > 
> > /* Operational flags: XFS_PPTR_*FLAG* */
> > > +       __u32                           pi_flags;
> > 
> > /* Must be set to zero */
> > > +       __u32                           pi_reserved;
> > 
> > /* # of entries in array */
> > > +       __u32                           pi_ptrs_size;
> > 
> > /* # of entries filled in (output) */
> > > +       __u32                           pi_ptrs_used;
> > 
> > /* Must be set to zero */
> > > +       __u64                           pi_reserved2[6];
> > > +
> > > +       /*
> > > +        * An array of struct xfs_parent_ptr follows the header
> > > +        * information. Use XFS_PPINFO_TO_PP() to access the
> > 
> > s/XFS_PPINFO_TO_PP/xfs_ppinfo_to_pp/
> Sure will add these comment clean ups
> > 
> > > +        * parent pointer array entries.
> > > +        */
> > > +       struct xfs_parent_ptr           pi_parents[];
> > > +};
> > > +
> > > +static inline size_t
> > > +xfs_pptr_info_sizeof(int nr_ptrs)
> > > +{
> > > +       return sizeof(struct xfs_pptr_info) +
> > > +              (nr_ptrs * sizeof(struct xfs_parent_ptr));
> > > +}
> > > +
> > > +static inline struct xfs_parent_ptr*
> > > +xfs_ppinfo_to_pp(
> > > +       struct xfs_pptr_info    *info,
> > > +       int                     idx)
> > > +{
> > > +       return &info->pi_parents[idx];
> > > +}
> > > +
> > >  /*
> > >   * ioctl limits
> > >   */
> > > @@ -797,6 +855,7 @@ struct xfs_scrub_metadata {
> > >  /*     XFS_IOC_GETFSMAP ------ hoisted 59         */
> > >  #define XFS_IOC_SCRUB_METADATA _IOWR('X', 60, struct
> > > xfs_scrub_metadata)
> > >  #define XFS_IOC_AG_GEOMETRY    _IOWR('X', 61, struct
> > > xfs_ag_geometry)
> > > +#define XFS_IOC_GETPARENTS     _IOWR('X', 62, struct
> > > xfs_parent_ptr)
> > >  
> > >  /*
> > >   * ioctl commands that replace IRIX syssgi()'s
> > > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > > b/fs/xfs/libxfs/xfs_parent.c
> > > index 7db1570e1841..58382a5c40a6 100644
> > > --- a/fs/xfs/libxfs/xfs_parent.c
> > > +++ b/fs/xfs/libxfs/xfs_parent.c
> > > @@ -26,6 +26,16 @@
> > >  #include "xfs_xattr.h"
> > >  #include "xfs_parent.h"
> > >  
> > > +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> > > +void
> > > +xfs_init_parent_ptr(struct xfs_parent_ptr              *xpp,
> > > +                   const struct xfs_parent_name_rec    *rec)
> > > +{
> > > +       xpp->xpp_ino = be64_to_cpu(rec->p_ino);
> > > +       xpp->xpp_gen = be32_to_cpu(rec->p_gen);
> > > +       xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
> > > +}
> > > +
> > >  /*
> > >   * Parent pointer attribute handling.
> > >   *
> > > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > > b/fs/xfs/libxfs/xfs_parent.h
> > > index b2ed4f373799..99765e65af8d 100644
> > > --- a/fs/xfs/libxfs/xfs_parent.h
> > > +++ b/fs/xfs/libxfs/xfs_parent.h
> > > @@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct
> > > xfs_parent_name_rec *rec,
> > >                               uint32_t p_diroffset);
> > >  void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> > >                                struct xfs_parent_name_rec *rec);
> > > +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> > > +                        const struct xfs_parent_name_rec *rec);
> > >  int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer
> > > **parentp);
> > >  int xfs_parent_defer_add(struct xfs_trans *tp, struct
> > > xfs_parent_defer *parent,
> > >                          struct xfs_inode *dp, struct xfs_name
> > > *parent_name,
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index 5b600d3f7981..7dc9f37d96cb 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -37,6 +37,7 @@
> > >  #include "xfs_health.h"
> > >  #include "xfs_reflink.h"
> > >  #include "xfs_ioctl.h"
> > > +#include "xfs_parent_utils.h"
> > >  #include "xfs_xattr.h"
> > >  
> > >  #include <linux/mount.h>
> > > @@ -355,6 +356,8 @@ xfs_attr_filter(
> > >                 return XFS_ATTR_ROOT;
> > >         if (ioc_flags & XFS_IOC_ATTR_SECURE)
> > >                 return XFS_ATTR_SECURE;
> > > +       if (ioc_flags & XFS_IOC_ATTR_PARENT)
> > > +               return XFS_ATTR_PARENT;
> > >         return 0;
> > >  }
> > >  
> > > @@ -422,7 +425,8 @@ xfs_ioc_attr_list(
> > >         /*
> > >          * Reject flags, only allow namespaces.
> > >          */
> > > -       if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> > > +       if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
> > > +                     XFS_IOC_ATTR_PARENT))
> > >                 return -EINVAL;
> > >         if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> > >                 return -EINVAL;
> > > @@ -538,6 +542,9 @@ xfs_attrmulti_attr_set(
> > >         if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> > >                 return -EPERM;
> > >  
> > > +       if (flags & XFS_IOC_ATTR_PARENT)
> > > +               return -EINVAL;
> > > +
> > >         if (ubuf) {
> > >                 if (len > XFS_XATTR_SIZE_MAX)
> > >                         return -EINVAL;
> > > @@ -567,7 +574,9 @@ xfs_ioc_attrmulti_one(
> > >         unsigned char           *name;
> > >         int                     error;
> > >  
> > > -       if ((flags & XFS_IOC_ATTR_ROOT) && (flags &
> > > XFS_IOC_ATTR_SECURE))
> > > +       if (((flags & XFS_IOC_ATTR_ROOT) &&
> > > +           ((flags & XFS_IOC_ATTR_SECURE) || (flags &
> > > XFS_IOC_ATTR_PARENT))) ||
> > > +           ((flags & XFS_IOC_ATTR_SECURE) && (flags &
> > > XFS_IOC_ATTR_PARENT)))
> > 
> > All these bits go away since XFS_IOC_ATTR_PARENT is no longer
> > necessary...
> > 
> > >                 return -EINVAL;
> > >  
> > >         name = strndup_user(uname, MAXNAMELEN);
> > > @@ -1679,6 +1688,96 @@ xfs_ioc_scrub_metadata(
> > >         return 0;
> > >  }
> > >  
> > > +/*
> > > + * IOCTL routine to get the parent pointers of an inode and return
> > > it to user
> > > + * space.  Caller must pass a buffer space containing a struct
> > > xfs_pptr_info,
> > > + * followed by a region large enough to contain an array of struct
> > > + * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the
> > > inode contains
> > > + * more parent pointers than can fit in the buffer space, caller
> > > may re-call
> > > + * the function using the returned pi_cursor to resume iteration. 
> > > The
> > > + * number of xfs_parent_ptr returned will be stored in
> > > pi_ptrs_used.
> > > + *
> > > + * Returns 0 on success or non-zero on failure
> > > + */
> > > +STATIC int
> > > +xfs_ioc_get_parent_pointer(
> > > +       struct file                     *filp,
> > > +       void                            __user *arg)
> > > +{
> > > +       struct xfs_pptr_info            *ppi = NULL;
> > > +       int                             error = 0;
> > > +       struct xfs_inode                *ip =
> > > XFS_I(file_inode(filp));
> > > +       struct xfs_mount                *mp = ip->i_mount;
> > > +
> > > +       if (!capable(CAP_SYS_ADMIN))
> > > +               return -EPERM;
> > > +
> > > +       /* Allocate an xfs_pptr_info to put the user data */
> > > +       ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
> > > +       if (!ppi)
> > > +               return -ENOMEM;
> > > +
> > > +       /* Copy the data from the user */
> > > +       error = copy_from_user(ppi, arg, sizeof(struct
> > > xfs_pptr_info));
> > > +       if (error) {
> > > +               error = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       /* Check size of buffer requested by user */
> > > +       if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) >
> > > XFS_XATTR_LIST_MAX) {
> > > +               error = -ENOMEM;
> > > +               goto out;
> > > +       }
> > > +
> > > +       if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
> > > +               error = -EINVAL;
> > > +               goto out;
> > > +       }
> > > +       ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT |
> > > XFS_PPTR_OFLAG_DONE);
> > > +
> > > +       /*
> > > +        * Now that we know how big the trailing buffer is, expand
> > > +        * our kernel xfs_pptr_info to be the same size
> > > +        */
> > > +       ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi-
> > > >pi_ptrs_size), 0);
> > > +       if (!ppi)
> > > +               return -ENOMEM;
> > > +
> > > +       if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
> > > +               error = xfs_iget(mp, NULL, ppi-
> > > >pi_handle.ha_fid.fid_ino,
> > > +                               0, 0, &ip);
> > > +               if (error)
> > > +                       goto out;
> > > +
> > > +               if (VFS_I(ip)->i_generation != ppi-
> > > >pi_handle.ha_fid.fid_gen) {
> > > +                       error = -EINVAL;
> > > +                       goto out;
> > > +               }
> > > +       }
> > > +
> > > +       if (ip->i_ino == mp->m_sb.sb_rootino)
> > > +               ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
> > > +
> > > +       /* Get the parent pointers */
> > > +       error = xfs_attr_get_parent_pointer(ip, ppi);
> > > +
> > > +       if (error)
> > > +               goto out;
> > > +
> > > +       /* Copy the parent pointers back to the user */
> > > +       error = copy_to_user(arg, ppi,
> > > +                       xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
> > > +       if (error) {
> > > +               error = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +out:
> > > +       kmem_free(ppi);
> > > +       return error;
> > > +}
> > > +
> > >  int
> > >  xfs_ioc_swapext(
> > >         xfs_swapext_t   *sxp)
> > > @@ -1968,7 +2067,8 @@ xfs_file_ioctl(
> > >  
> > >         case XFS_IOC_FSGETXATTRA:
> > >                 return xfs_ioc_fsgetxattra(ip, arg);
> > > -
> > > +       case XFS_IOC_GETPARENTS:
> > > +               return xfs_ioc_get_parent_pointer(filp, arg);
> > >         case XFS_IOC_GETBMAP:
> > >         case XFS_IOC_GETBMAPA:
> > >         case XFS_IOC_GETBMAPX:
> > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > index 758702b9495f..765eb514a917 100644
> > > --- a/fs/xfs/xfs_ondisk.h
> > > +++ b/fs/xfs/xfs_ondisk.h
> > > @@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
> > >         XFS_CHECK_STRUCT_SIZE(struct
> > > xfs_attri_log_format,      40);
> > >         XFS_CHECK_STRUCT_SIZE(struct
> > > xfs_attrd_log_format,      16);
> > >  
> > > +       /* parent pointer ioctls */
> > > +       XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,           
> > > 280);
> > > +       XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,            
> > > 104);
> > > +
> > >         /*
> > >          * The v5 superblock format extended several v4 header
> > > structures with
> > >          * additional data. While new fields are only accessible on
> > > v5
> > > diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> > > new file mode 100644
> > > index 000000000000..fd7156addd38
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_parent_utils.c
> > > @@ -0,0 +1,126 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2022 Oracle, Inc.
> > > + * All rights reserved.
> > > + */
> > > +#include "xfs.h"
> > > +#include "xfs_fs.h"
> > > +#include "xfs_format.h"
> > > +#include "xfs_log_format.h"
> > > +#include "xfs_shared.h"
> > > +#include "xfs_trans_resv.h"
> > > +#include "xfs_mount.h"
> > > +#include "xfs_bmap_btree.h"
> > > +#include "xfs_inode.h"
> > > +#include "xfs_error.h"
> > > +#include "xfs_trace.h"
> > > +#include "xfs_trans.h"
> > > +#include "xfs_da_format.h"
> > > +#include "xfs_da_btree.h"
> > > +#include "xfs_attr.h"
> > > +#include "xfs_ioctl.h"
> > > +#include "xfs_parent.h"
> > > +#include "xfs_da_btree.h"
> > > +
> > > +/*
> > > + * Get the parent pointers for a given inode
> > > + *
> > > + * Returns 0 on success and non zero on error
> > > + */
> > > +int
> > > +xfs_attr_get_parent_pointer(
> > > +       struct xfs_inode                *ip,
> > > +       struct xfs_pptr_info            *ppi)
> > > +{
> > > +
> > > +       struct xfs_attrlist             *alist;
> > > +       struct xfs_attrlist_ent         *aent;
> > > +       struct xfs_parent_ptr           *xpp;
> > > +       struct xfs_parent_name_rec      *xpnr;
> > > +       char                            *namebuf;
> > > +       unsigned int                    namebuf_size;
> > > +       int                             name_len, i, error = 0;
> > > +       unsigned int                    ioc_flags =
> > > XFS_IOC_ATTR_PARENT;
> > > +       unsigned int                    lock_mode, flags =
> > > XFS_ATTR_PARENT;
> > > +       struct xfs_attr_list_context    context;
> > > +
> > > +       /* Allocate a buffer to store the attribute names */
> > > +       namebuf_size = sizeof(struct xfs_attrlist) +
> > > +                      (ppi->pi_ptrs_size) * sizeof(struct
> > > xfs_attrlist_ent);
> > > +       namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
> > > +       if (!namebuf)
> > > +               return -ENOMEM;
> > > +
> > > +       memset(&context, 0, sizeof(struct xfs_attr_list_context));
> > > +       error = xfs_ioc_attr_list_context_init(ip, namebuf,
> > > namebuf_size,
> > > +                       ioc_flags, &context);
> > > +       if (error)
> > > +               goto out_kfree;
> > 
> > And now that we don't have XFS_IOC_ATTR_PARENT anymore, change this
> > to:
> > 
> >         memset(&context, 0, sizeof(struct xfs_attr_list_context));
> >         error = xfs_ioc_attr_list_context_init(ip, namebuf,
> >                         namebuf_size, 0, &context);
> >         if (error)
> >                 goto out_kfree;
> >         context.attr_flags = XFS_ATTR_PARENT;
> I do that a few lines down when we set up the cursor, I think this
> parts ok with the IOC flag gone
> 
> > 
> > This way you can reuse the xfs_attr_list* infrastructure without
> > needing
> > to add flags to the userspace xattr APIs or then have to filter that
> > out
> > from all the incoming xattr calls.
> > 
> > > +
> > > +       /* Copy the cursor provided by caller */
> > > +       memcpy(&context.cursor, &ppi->pi_cursor,
> > > +               sizeof(struct xfs_attrlist_cursor));
> > > +       context.attr_filter = XFS_ATTR_PARENT;
> > > +
> > > +       lock_mode = xfs_ilock_attr_map_shared(ip);
> > > +
> > > +       error = xfs_attr_list_ilocked(&context);
> > > +       if (error)
> > > +               goto out_kfree;
> > > +
> > > +       alist = (struct xfs_attrlist *)namebuf;
> > > +       for (i = 0; i < alist->al_count; i++) {
> > > +               struct xfs_da_args args = {
> > > +                       .geo = ip->i_mount->m_attr_geo,
> > > +                       .whichfork = XFS_ATTR_FORK,
> > > +                       .dp = ip,
> > > +                       .namelen = sizeof(struct
> > > xfs_parent_name_rec),
> > > +                       .attr_filter = flags,
> > > +                       .op_flags = XFS_DA_OP_OKNOENT,
> > 
> > We hold the ILOCK between the list and the attr getting, so we
> > shouldn't
> > need OKNOENT here to avoid error returns, right?
> Yes, i think it should be ok to come out
> 
> > 
> > > +               };
> > > +
> > > +               xpp = xfs_ppinfo_to_pp(ppi, i);
> > > +               memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> > > +               aent = (struct xfs_attrlist_ent *)
> > > +                       &namebuf[alist->al_offset[i]];
> > > +               xpnr = (struct xfs_parent_name_rec *)(aent-
> > > >a_name);
> > > +
> > > +               if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> > > +                       error = -EFSCORRUPTED;
> > > +                       goto out_kfree;
> > > +               }
> > > +               name_len = aent->a_valuelen;
> > > +
> > > +               args.name = (char *)xpnr;
> > > +               args.hashval = xfs_da_hashname(args.name,
> > > args.namelen),
> > > +               args.value = (unsigned char *)(xpp->xpp_name);
> > > +               args.valuelen = name_len;
> > > +
> > > +               error = xfs_attr_get_ilocked(&args);
> > > +               error = (error == -EEXIST ? 0 : error);
> > > +               if (error) {
> > > +                       error = -EFSCORRUPTED;
> > > +                       goto out_kfree;
> > > +               }
> > > +
> > > +               xfs_init_parent_ptr(xpp, xpnr);
> > > +               if(!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino))
> > > {
> > 
> > Space before the '('
> will fix
> 
> > 
> > > +                       error = -EFSCORRUPTED;
> > > +                       goto out_kfree;
> > > +               }
> > > +       }
> > > +       ppi->pi_ptrs_used = alist->al_count;
> > > +       if (!alist->al_more)
> > > +               ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
> > > +
> > > +       /* Update the caller with the current cursor position */
> > > +       memcpy(&ppi->pi_cursor, &context.cursor,
> > > +               sizeof(struct xfs_attrlist_cursor));
> > 
> > Two tabs for the continuation line.
> Alrighty, will up date.  Thanks for the reviews!
> Allison
> 
> > 
> > --D
> > 
> > > +
> > > +out_kfree:
> > > +       xfs_iunlock(ip, lock_mode);
> > > +       kvfree(namebuf);
> > > +
> > > +       return error;
> > > +}
> > > +
> > > diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> > > new file mode 100644
> > > index 000000000000..ad60baee8b2a
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_parent_utils.h
> > > @@ -0,0 +1,11 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2022 Oracle, Inc.
> > > + * All rights reserved.
> > > + */
> > > +#ifndef        __XFS_PARENT_UTILS_H__
> > > +#define        __XFS_PARENT_UTILS_H__
> > > +
> > > +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
> > > +                               struct xfs_pptr_info *ppi);
> > > +#endif /* __XFS_PARENT_UTILS_H__ */
> > > -- 
> > > 2.25.1
> > > 
> 
