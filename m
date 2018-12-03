Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:46403 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbeLCReK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 12:34:10 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-8-david@fromorbit.com>
 <CAOQ4uxiCi9qJ15J=L6fNjuLGykQm5CDuJ-=Y=TwTP5c=jx-_fA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiCi9qJ15J=L6fNjuLGykQm5CDuJ-=Y=TwTP5c=jx-_fA@mail.gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 3 Dec 2018 12:33:50 -0500
Message-ID: <CAN-5tyFMDnjm5cMneYyRTveyJ-6ddLCt1za-kk5eemOO2ngq=A@mail.gmail.com>
Subject: Re: [PATCH 07/11] vfs: copy_file_range should update file timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 5:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Timestamps are not updated right now, so programs looking for
> > timestamp updates for file modifications (like rsync) will not
> > detect that files have changed. We are also accessing the source
> > data when doing a copy (but not when cloning) so we need to update
> > atime on the source file as well.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/read_write.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 3b101183ea19..3288db1d5f21 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1576,6 +1576,16 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
> >  {
> >         ssize_t ret;
> >
> > +       /* Update source timestamps, because we are accessing file data */
> > +       file_accessed(file_in);
> > +
> > +       /* Update destination timestamps, since we can alter file contents. */
> > +       if (!(file_out->f_mode & FMODE_NOCMTIME)) {
> > +               ret = file_update_time(file_out);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
>
> If there is a consistency about who is responsible of calling file_accessed()
> and file_update_time() it eludes me. grep tells me that they are mostly
> handled by filesystem code or generic helpers called by filesystem code
> and not in the vfs helpers.
>
> FMODE_NOCMTIME seems like an xfs specific flag (for DMAPI?), which
> most generic callers of file_update_time() completely ignore.
> This seems like another argument in favor of leaving the responsibility
> of the timestamp updates to the filesystem.
>
> Maybe I am missing something?
>

I had similar question before about who is responsible for doing the
checks. I agree that attributes should be updated for the case when no
filesystem support exist for copy_file_range() but this code does it
for all the cases. I also wonder if it's appropriate to update the
attributes before the copy is actually done?

> Thanks,
> Amir.
