Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f68.google.com ([209.85.217.68]:38215 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbeLLUWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 15:22:36 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-5-david@fromorbit.com>
 <87a7lbrng4.fsf@suse.com> <CAN-5tyHNGtLxeFyEO6qX_+8=K4tpkgYjB11OkfCTdWfokfAyEg@mail.gmail.com>
 <20181212194258.GK6830@bombadil.infradead.org>
In-Reply-To: <20181212194258.GK6830@bombadil.infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Wed, 12 Dec 2018 15:22:23 -0500
Message-ID: <CAN-5tyGmdrbbiej_mMosYKrCzOEuKMKJALfOJxvbBqHwZFiUOw@mail.gmail.com>
Subject: Re: [PATCH 04/11] vfs: add missing checks to copy_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: willy@infradead.org
Cc: lhenriques@suse.com, david@fromorbit.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, Dec 12, 2018 at 2:43 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Dec 12, 2018 at 01:55:28PM -0500, Olga Kornievskaia wrote:
> > On Wed, Dec 12, 2018 at 6:31 AM Luis Henriques <lhenriques@suse.com> wrote:
> > > I was wondering if, with the above check, it would make sense to also
> > > have an extra patch changing some filesystems (ceph, nfs and cifs) to
> > > simply return -EOPNOTSUPP (instead of -EINVAL) when inode_in ==
> > > inode_out.  Something like the diff below (not tested!).
>
> > > +++ b/fs/nfs/nfs4file.c
> > > @@ -136,7 +136,7 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
> > >         ssize_t ret;
> > >
> > >         if (file_inode(file_in) == file_inode(file_out))
> > > -               return -EINVAL;
> > > +               return -EOPNOTSUPP;
> >
> > Please don't change the NFS bits. This is against the NFS
> > specifications. RFC 7862 15.2.3
> >
> > (snippet)
> > SAVED_FH and CURRENT_FH must be different files.  If SAVED_FH and
> >    CURRENT_FH refer to the same file, the operation MUST fail with
> >    NFS4ERR_INVAL.
>
> I don't see how that applies.  That refers to a requirement _in the
> protocol_ that determines what the server MUST do if the client sends
> it two FHs which refer to the same file.
>
> What we're talking about here is how a Linux filesystem behaves when
> receiving a copy_file_range() referring to the same file.  As long as
> the Linux filesystem doesn't react by sending out one of these invalid
> protocol messages, I don't see the problem.

Ok then this should be changed to call generic_copy_file_range() not
returning the EOPNOTSUPP since there is no longer fallback in vfs to
call the generic_copy_file_range() and in turn responsibility of each
file system.
