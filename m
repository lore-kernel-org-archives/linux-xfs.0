Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbeJFEsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 00:48:31 -0400
Date: Fri, 5 Oct 2018 14:47:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/15] vfs: change clone and dedupe range function
 pointers to return bytes completed
Message-ID: <20181005214725.GD19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870033496.29072.3660384210745578982.stgit@magnolia>
 <CAOQ4uxjjSFt07P1Qv9am9sN--UZOojzE4QGQSdx1o+sLN+M2RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjjSFt07P1Qv9am9sN--UZOojzE4QGQSdx1o+sLN+M2RQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>, Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 05, 2018 at 11:06:54AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Change the clone_file_range and dedupe_file_range functions to return
> > the number of bytes they operated on.  This is the precursor to allowing
> > fs implementations to return short clone/dedupe results to the user,
> > which will enable us to obey resource limits in a graceful manner.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> [...]
> 
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index aeaefd2a551b..6d792d817538 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -487,16 +487,21 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
> >                             OVL_COPY);
> >  }
> >
> > -static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
> > +static s64 ovl_clone_file_range(struct file *file_in, loff_t pos_in,
> >                                 struct file *file_out, loff_t pos_out, u64 len)
> >  {
> > -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > -                           OVL_CLONE);
> > +       int ret;
> > +
> > +       ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > +                          OVL_CLONE);
> > +       return ret < 0 ? ret : len;
> >  }
> >
> > -static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> > +static s64 ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> >                                  struct file *file_out, loff_t pos_out, u64 len)
> >  {
> > +       int ret;
> > +
> >         /*
> >          * Don't copy up because of a dedupe request, this wouldn't make sense
> >          * most of the time (data would be duplicated instead of deduplicated).
> > @@ -505,8 +510,9 @@ static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> >             !ovl_inode_upper(file_inode(file_out)))
> >                 return -EPERM;
> >
> > -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > -                           OVL_DEDUPE);
> > +       ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > +                          OVL_DEDUPE);
> > +       return ret < 0 ? ret : len;
> >  }
> >
> 
> This is not pretty at all.
> You are blocking the propagation of partial dedupe/clone result
> of files that are accessed via overlay over xfs.
> 
> Please extend the interface change to the vfs helpers
> (i.e. vfs_clone_file_range()) and then the change above is not needed.
> 
> Of course you would need to change the 3 callers of
> vfs_clone_file_range() that expect 0 is ok.

Ok, I'll plumb the bytes-finished return value all the way through the
internal APIs.

> Please take a look at commit
> a725356b6659 ("vfs: swap names of {do,vfs}_clone_file_range()")
> 
> That was just merged for rc7.
> 
> I do apologize for the churn, but it's a semantic mistake that
> I made that needed fixing, so please rebase your work on top
> of that and take care not to trip over it.

Err... ok.  That makes working on this a little messy, we'll see if I
can get this mess rebased in time for 5.0.

> ioctl_file_clone() and ovl_copy_up_data() just need to interpret
> positive return value correctly.
> nfsd4_clone_file_range() should have the same return value as
> vfs_clone_file_range() to be interpreted in nfsd4_clone(), following
> same practice as nfsd4_copy_file_range().
> 
> [...]
> 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 2a4141d36ebf..e5755340e825 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1759,10 +1759,12 @@ struct file_operations {
> >  #endif
> >         ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
> >                         loff_t, size_t, unsigned int);
> > -       int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -                       u64);
> > -       int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -                       u64);
> > +       s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
> > +                               struct file *file_out, loff_t pos_out,
> > +                               u64 count);
> > +       s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
> > +                                struct file *file_out, loff_t pos_out,
> > +                                u64 count);
> 
> Matthew has objected a similar interface change when it was proposed by Miklos:
> https://marc.info/?l=linux-fsdevel&m=152570317110292&w=2
> https://marc.info/?l=linux-fsdevel&m=152569298704781&w=2
> 
> He claimed that the interface should look like this:
> +       loff_t (*dedupe_file_range)(struct file *src, loff_t src_off,
> +                       struct file *dst, loff_t dst_off, loff_t len);

I don't really like loff_t (why does the typename for a size include
"offset" in the name??) but I guess that's not horrible.  I've never
liked how functions take size_t (unsigned) but return ssize_t (signed)
anyway.

--D

> Thanks,
> Amir.
