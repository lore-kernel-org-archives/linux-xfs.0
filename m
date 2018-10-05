Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbeJFAuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 20:50:03 -0400
Date: Fri, 5 Oct 2018 10:50:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
Message-ID: <20181005175008.GY19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870034158.29072.8943691140742142494.stgit@magnolia>
 <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 05, 2018 at 10:07:43AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Pass operational flags to the per-filesystem clone and dedupe
> > implementations.  This enables the vfs to signal when it can deal with
> > short clone and short dedupe operations.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [...]
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1761,7 +1761,7 @@ struct file_operations {
> >                         loff_t, size_t, unsigned int);
> >         s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
> >                                 struct file *file_out, loff_t pos_out,
> > -                               u64 count);
> > +                               u64 count, unsigned int flags);
> >         s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
> >                                  struct file *file_out, loff_t pos_out,
> >                                  u64 count);
> > @@ -1827,9 +1827,15 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
> >                 unsigned long, loff_t *, rwf_t);
> >  extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
> >                                    loff_t, size_t, unsigned int);
> > +/* Caller can handle a shortened operation. */
> > +#define CLONERANGE_SHORT       (1 << 0)
> > +/* End operation at the source file's EOF. */
> > +#define CLONERANGE_EOF         (1 << 1)
> > +/* Operation is actually dedupe, not clone. */
> > +#define CLONERANGE_DEDUPE      (1 << 2)
> 
> That's cool. But you know what's going to be the next step, right?
> Merging the 3 file operation interfaces into a single one.
> copy_file_range() already has the flags arg for future extensions
> and as you wrote somewhere, clone is really an optimized copy.
> ovl_copyfile() already does that internally.
> 
> So the only take away for this patch series, please use constant
> names COPYRANGE_* and also explicitly define:
> 
> /* Operation is actually clone, not copy. */
> #define COPYRANGE_CLONE      (1 << 2)
> /* Operation is actually dedupe, not copy. */
> #define COPYRANGE_DEDUPE      (1 << 3)

Yeah, I was too tired to try to throw that one on top of the flaming
garbage pile.  But I guess since I have a bunch more work to do to the
previous patch I might as well do that...

--D

> 
> Thanks,
> Amir.
