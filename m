Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36348 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1QhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 12:37:07 -0400
MIME-Version: 1.0
References: <20190526061100.21761-1-amir73il@gmail.com> <20190526061100.21761-7-amir73il@gmail.com>
 <20190528163020.GF5221@magnolia>
In-Reply-To: <20190528163020.GF5221@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 May 2019 19:36:55 +0300
Message-ID: <CAOQ4uxh1Tk+ZN+hiEJLsSFP8Q=RNPEaJ_FDG_XkzkrtBXBL65A@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] vfs: copy_file_range should update file timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, May 28, 2019 at 7:30 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sun, May 26, 2019 at 09:10:57AM +0300, Amir Goldstein wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Timestamps are not updated right now, so programs looking for
> > timestamp updates for file modifications (like rsync) will not
> > detect that files have changed. We are also accessing the source
> > data when doing a copy (but not when cloning) so we need to update
> > atime on the source file as well.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/read_write.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index e16bcafc0da2..4b23a86aacd9 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1576,6 +1576,16 @@ int generic_copy_file_range_prep(struct file *file_in, struct file *file_out)
> >
> >       WARN_ON_ONCE(!inode_is_locked(file_inode(file_out)));
> >
> > +     /* Update source timestamps, because we are accessing file data */
> > +     file_accessed(file_in);
> > +
> > +     /* Update destination timestamps, since we can alter file contents. */
> > +     if (!(file_out->f_mode & FMODE_NOCMTIME)) {
> > +             ret = file_update_time(file_out);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> >       /*
> >        * Clear the security bits if the process is not being run by root.
> >        * This keeps people from modifying setuid and setgid binaries.
>
> Should the file_update_time and file_remove_privs calls be factored into
> a separate small function to be called by generic_{copy,remap}_range_prep?
>

Ok. same helper could be called also after copy when inode is not locked
throughout the copy.

Thanks,
Amir.
