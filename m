Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44039 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2TKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 15:10:49 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-8-amir73il@gmail.com>
 <20190529183149.GG5231@magnolia>
In-Reply-To: <20190529183149.GG5231@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 22:10:37 +0300
Message-ID: <CAOQ4uxg0Z8Ne8kadPzsushW43t3Sijy+9WQbGRRO=CtmMAbtuA@mail.gmail.com>
Subject: Re: [PATCH v3 07/13] xfs: use file_modified() helper
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

On Wed, May 29, 2019 at 9:31 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, May 29, 2019 at 08:43:11PM +0300, Amir Goldstein wrote:
> > Note that by using the helper, the order of calling file_remove_privs()
> > after file_update_mtime() in xfs_file_aio_write_checks() has changed.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/xfs_file.c | 15 +--------------
> >  1 file changed, 1 insertion(+), 14 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 76748255f843..916a35cae5e9 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -367,20 +367,7 @@ xfs_file_aio_write_checks(
> >        * lock above.  Eventually we should look into a way to avoid
> >        * the pointless lock roundtrip.
> >        */
> > -     if (likely(!(file->f_mode & FMODE_NOCMTIME))) {
>
> ...especially since here we think NOCMTIME is likely /not/ to be set.
>
> > -             error = file_update_time(file);
> > -             if (error)
> > -                     return error;
> > -     }
> > -
> > -     /*
> > -      * If we're writing the file then make sure to clear the setuid and
> > -      * setgid bits if the process is not being run by root.  This keeps
> > -      * people from modifying setuid and setgid binaries.
> > -      */
> > -     if (!IS_NOSEC(inode))
> > -             return file_remove_privs(file);
>
> Hm, file_modified doesn't have the !IS_NOSEC check guarding
> file_remove_privs, are you sure it's ok to remove the suid bits
> unconditionally?  Even if SB_NOSEC (and therefore S_NOSEC) are set?
>

file_remove_privs() has its own IS_NOSEC() check.

Thanks,
Amir.
