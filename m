Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34685 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeLDJRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 04:17:51 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-9-david@fromorbit.com>
 <CAOQ4uxgwZLsO1yV37_CHaZ-O+-+-OggSP9g6m9YE57kLPc5yDw@mail.gmail.com>
 <20181203191130.GD24487@magnolia> <20181203233714.GL6311@dastard> <20181203235837.GF24487@magnolia>
In-Reply-To: <20181203235837.GF24487@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Dec 2018 11:17:38 +0200
Message-ID: <CAOQ4uxgRe8yqeRv-UEqCa+YD2buTUq5FdguHtJoQAgtBEpTTVw@mail.gmail.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

> > > I think this is sort of backwards -- the checks should stay in
> > > do_clone_file_range, and vfs_copy_file_range should be calling that
> > > instead of directly calling ->remap_range():
> > >
> > > vfs_copy_file_range()
> > > {
> > >     file_start_write(...);
> > >     ret = do_clone_file_range(...);
> > >     if (ret > 0)
> > >             return ret;
> > >     ret = do_copy_file_range(...);
> > >     file_end_write(...);
> > >     return ret;
> > > }
> >
> > I'm already confused by the way we weave in and out of "vfs_/do_*"
> > functions, and this just makes it worse.
> >
> > Just what the hell is supposed to be in a "vfs_" prefixed function,
> > and why the hell is it considered a "vfs" level function if we then
> > export it's internal functions for individual filesystems to use?
>
> I /think/ vfs_ functions are file_start_write()/file_end_write()
> wrappers around a similarly named function that lacks the freeze
> protection??

That is definitely not an official definition of vfs_ vs. do_, but I found
this rule to be a common practice, which is why I swapped
{do,vfs}_clone_file_range(). But around vfs you can find many examples
where do_ helpers wrap vfs_ helpers.

>
> (AFAICT Amir made that split so that overlayfs could use these
> functions, though I do not know if everything vfs_ was made that way
> /specifically/ for overlayfs or if that's the way things have been and
> ovlfs simply takes advantage of it...)
>
> Guhhh, none of this is documented......
>

It looks like in git epoc, things were pretty straight forward.
vfs_XXX was the interface called after sys_XXX converted
userspace arguments (e.g. char *name, int fd) to vfs objects
(e.g. struct path,dentry,inode,file). Sometimes vfs_ helpers called
do_ helpers for several reasons. See for example epoc version
of fs/namei.c fs/read_write.c.
Even then there were exception. For example do_sendfile()
doesn't even have a vfs_ interface, although it is clear what
that prospect interface would look like.
To that end, do_splice_direct() acts as the standard do_ helper
to that non-existing vfs_ interface.

>From there on, I guess things kinda grew organically.
fs/namei.c syscalls grew do_XXXat() helpers between syscalls
and vfs_XXX interface.

Overlayfs uses vfs_ interface 99% of the time, so from that perspective
it is regarded as an interface with vfs objects as arguments that does
NOT skip security_ checks and does NOT bypass freeze protection.

Overlayfs calling do_clone_file_range() and do_splice_direct() are
the only exception to this rule.
If we would want to replace those calls in ovl_copy_up_data() with
a single call to do_copy_file_range(), than said helper should NOT
be taking freeze protection and should do the fallback between
filesystem copy_file_range and generic_copy_file_range.

Cheers,
Amir.
