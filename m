Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35701 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbeJKAt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 20:49:59 -0400
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913028015.32295.15993665528948323051.stgit@magnolia> <CAOQ4uxjZ1JuT3Ga1kTDF9boeYF5pafDmsnzWxVNPWcTpESchgw@mail.gmail.com>
 <20181010170137.GA24824@magnolia>
In-Reply-To: <20181010170137.GA24824@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Oct 2018 20:26:38 +0300
Message-ID: <CAOQ4uxi9ZU3La7RcaeVR_L7CXf2A-FeF1PnS_-PSO9idyf3BKg@mail.gmail.com>
Subject: Re: [PATCH 06/25] vfs: strengthen checking of file range inputs to generic_remap_checks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 8:01 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 08:23:27AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > File range remapping, if allowed to run past the destination file's EOF,
> > > is an optimization on a regular file write.  Regular file writes that
> > > extend the file length are subject to various constraints which are not
> > > checked by range cloning.
> > >
> > > This is a correctness problem because we're never allowed to touch
> > > ranges that the page cache can't support (s_maxbytes); we're not
> > > supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
> > > set; and we must obey resource limits (RLIMIT_FSIZE).
> > >
> > > Therefore, add these checks to the new generic_remap_checks function so
> > > that we curtail unexpected behavior.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  mm/filemap.c |   39 +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 39 insertions(+)
> > >
> > >
> > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > index 14041a8468ba..59056bd9c58a 100644
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -2974,6 +2974,27 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
> > >  }
> > >  EXPORT_SYMBOL(generic_write_checks);
> > >
> > > +static int
> > > +generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
> > > +{
> > > +       struct inode *inode = file->f_mapping->host;
> > > +
> > > +       /* Don't exceed the LFS limits. */
> > > +       if (unlikely(pos + *count > MAX_NON_LFS &&
> > > +                               !(file->f_flags & O_LARGEFILE))) {
> > > +               if (pos >= MAX_NON_LFS)
> > > +                       return -EFBIG;
> > > +               *count = min(*count, MAX_NON_LFS - (uint64_t)pos);
> > > +       }
> > > +
> > > +       /* Don't operate on ranges the page cache doesn't support. */
> > > +       if (unlikely(pos >= inode->i_sb->s_maxbytes))
> > > +               return -EFBIG;
> > > +
> > > +       *count = min(*count, inode->i_sb->s_maxbytes - (uint64_t)pos);
> > > +       return 0;
> > > +}
> > > +
> >
> > Sorry. I haven't explained myself properly last time.
> > What I meant is that it hurts my eyes to see generic_write_checks() and
> > generic_remap_check_limits() which from the line of (limit != RLIM_INFINITY)
> > are exactly the same thing. Yes, generic_remap_check_limits() uses
> > iov_iter_truncate(), but that's a minor semantic change - it can be easily
> > resolved by creating a dummy iter in generic_remap_checks() instead of
> > passing int *count.
>
> Making a fake kiocb and iterator seem like a terribly fragile idea.
>
> How about I make the common helper take a pos and *count, and
> generic_write_checks can translate that into iov_iter_truncate?
>

Seems good to me.

Thanks,
Amir.
