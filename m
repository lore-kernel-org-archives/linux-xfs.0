Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41277 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbfE2Vly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 17:41:54 -0400
Date: Thu, 30 May 2019 07:41:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 06/13] vfs: introduce file_modified() helper
Message-ID: <20190529214145.GC29573@dread.disaster.area>
References: <20190529174318.22424-1-amir73il@gmail.com>
 <20190529174318.22424-7-amir73il@gmail.com>
 <20190529182748.GF5231@magnolia>
 <CAOQ4uxgsMLTPtYaQwwNHo3NrzXz9u=YGc2v6Pg8TSo7-xFrqQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgsMLTPtYaQwwNHo3NrzXz9u=YGc2v6Pg8TSo7-xFrqQQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

On Wed, May 29, 2019 at 10:08:44PM +0300, Amir Goldstein wrote:
> On Wed, May 29, 2019 at 9:27 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, May 29, 2019 at 08:43:10PM +0300, Amir Goldstein wrote:
> > > The combination of file_remove_privs() and file_update_mtime() is
> > > quite common in filesystem ->write_iter() methods.
> > >
> > > Modelled after the helper file_accessed(), introduce file_modified()
> > > and use it from generic_remap_file_range_prep().
> > >
> > > Note that the order of calling file_remove_privs() before
> > > file_update_mtime() in the helper was matched to the more common order by
> > > filesystems and not the current order in generic_remap_file_range_prep().
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/inode.c         | 20 ++++++++++++++++++++
> > >  fs/read_write.c    | 21 +++------------------
> > >  include/linux/fs.h |  2 ++
> > >  3 files changed, 25 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/fs/inode.c b/fs/inode.c
> > > index df6542ec3b88..2885f2f2c7a5 100644
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -1899,6 +1899,26 @@ int file_update_time(struct file *file)
> > >  }
> > >  EXPORT_SYMBOL(file_update_time);
> > >
> > > +/* Caller must hold the file's inode lock */
> > > +int file_modified(struct file *file)
> > > +{
> > > +     int err;
> > > +
> > > +     /*
> > > +      * Clear the security bits if the process is not being run by root.
> > > +      * This keeps people from modifying setuid and setgid binaries.
> > > +      */
> > > +     err = file_remove_privs(file);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     if (likely(file->f_mode & FMODE_NOCMTIME))
> >
> > I would not have thought NOCMTIME is likely?
> >
> > Maybe it is for io requests coming from overlayfs, but for regular uses
> > I don't think that's true.
> 
> Nope that's a typo. Good spotting.
> Overlayfs doesn't set FMODE_NOCMTIME (yet). Only xfs does from
> XFS_IOC_OPEN_BY_HANDLE, but I think Dave said that is a deprecated
> API. so should have been very_unlikely().

It is most definitely not a deprecated API. I don't know where you
got that idea from. It's used explicitly by the xfs utilities to
perform invisible IO. Anyone who runs xfs_fsr or xfsdump or has an
application that links to libhandle is using XFS_IOC_OPEN_BY_HANDLE
and FMODE_NOCMTIME....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
