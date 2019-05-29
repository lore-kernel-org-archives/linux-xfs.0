Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42040 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfE2VBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 17:01:01 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-13-amir73il@gmail.com>
 <CAOQ4uxgYM_eM==uqGQuKiGb+f08qs53=E+DONMMzW=N-Ab5YZA@mail.gmail.com> <c32af433639b451419d36382a05edabfcb742294.camel@hammerspace.com>
In-Reply-To: <c32af433639b451419d36382a05edabfcb742294.camel@hammerspace.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 30 May 2019 00:00:49 +0300
Message-ID: <CAOQ4uxio_1J-v3dcXO154N0Ntq+vrM0FOQv0G6Nh1HBmtHZEfQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] nfs: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "Anna.Schumaker@netapp.com" <Anna.Schumaker@netapp.com>, "olga.kornievskaia@gmail.com" <olga.kornievskaia@gmail.com>, "hch@lst.de" <hch@lst.de>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "lhenriques@suse.com" <lhenriques@suse.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Wed, May 29, 2019 at 11:02 PM Trond Myklebust
<trondmy@hammerspace.com> wrote:
>
> On Wed, 2019-05-29 at 22:34 +0300, Amir Goldstein wrote:
> > Hi Olga,Anna,Trond
> >
> > Could we get an ACK on this patch.
> > It is a prerequisite for merging the cross-device copy_file_range
> > work.
> >
> > It depends on a new helper introduced here:
> > https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a
> >
> > Thanks,
> > Amir,
> >
> > On Wed, May 29, 2019 at 8:43 PM Amir Goldstein <amir73il@gmail.com>
> > wrote:
> > > Like ->write_iter(), we update mtime and strip setuid of dst file
> > > before
> > > copy and like ->read_iter(), we update atime of src file after
> > > copy.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/nfs/nfs42proc.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
> > > index 5196bfa7894d..c37a8e5116c6 100644
> > > --- a/fs/nfs/nfs42proc.c
> > > +++ b/fs/nfs/nfs42proc.c
> > > @@ -345,10 +345,13 @@ ssize_t nfs42_proc_copy(struct file *src,
> > > loff_t pos_src,
> > >
> > >         do {
> > >                 inode_lock(file_inode(dst));
> > > -               err = _nfs42_proc_copy(src, src_lock,
> > > -                               dst, dst_lock,
> > > -                               &args, &res);
> > > +               err = file_modified(dst);
> > > +               if (!err)
> > > +                       err = _nfs42_proc_copy(src, src_lock,
> > > +                                              dst, dst_lock,
> > > +                                              &args, &res);
> > >                 inode_unlock(file_inode(dst));
> > > +               file_accessed(src);
> > >
> > >                 if (err >= 0)
> > >                         break;
> > > --
> > > 2.17.1
> > >
>
> Please drop this patch. In the NFS protocol, the client is not expected
> to mess with atime or mtime other than when the user explicitly sets it
> through a call to utimensat() or similar. The server takes care of any
> a/mtime updates as and when the file is read/written to.
>
> Ditto for suid/sgid clearing.
>
> Motto: "No file_accessed() or file_remove_privs() calls, please. We're
> NFS."

OK.

Thanks,
Amir.
