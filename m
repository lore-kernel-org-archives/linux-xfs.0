Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38715 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfE2F6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 01:58:21 -0400
MIME-Version: 1.0
References: <20190527172655.9287-1-amir73il@gmail.com> <20190528200659.GK5221@magnolia>
In-Reply-To: <20190528200659.GK5221@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 08:58:09 +0300
Message-ID: <CAOQ4uxgq-A7qpi8Mj-N2f2TC1fCHZ45yBc0_KfA9CygwqLMNHw@mail.gmail.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org

On Tue, May 28, 2019 at 11:07 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Mon, May 27, 2019 at 08:26:55PM +0300, Amir Goldstein wrote:
> > New link flags to request "atomic" link.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Hi Guys,
> >
> > Following our discussions on LSF/MM and beyond [1][2], here is
> > an RFC documentation patch.
> >
> > Ted, I know we discussed limiting the API for linking an O_TMPFILE
> > to avert the hardlinks issue, but I decided it would be better to
> > document the hardlinks non-guaranty instead. This will allow me to
> > replicate the same semantics and documentation to renameat(2).
> > Let me know how that works out for you.
> >
> > I also decided to try out two separate flags for data and metadata.
> > I do not find any of those flags very useful without the other, but
> > documenting them seprately was easier, because of the fsync/fdatasync
> > reference.  In the end, we are trying to solve a social engineering
> > problem, so this is the least confusing way I could think of to describe
> > the new API.
> >
> > First implementation of AT_ATOMIC_METADATA is expected to be
> > noop for xfs/ext4 and probably fsync for btrfs.
> >
> > First implementation of AT_ATOMIC_DATA is expected to be
> > filemap_write_and_wait() for xfs/ext4 and probably fdatasync for btrfs.
> >
> > Thoughts?
> >
> > Amir.
> >
> > [1] https://lwn.net/Articles/789038/
> > [2] https://lore.kernel.org/linux-fsdevel/CAOQ4uxjZm6E2TmCv8JOyQr7f-2VB0uFRy7XEp8HBHQmMdQg+6w@mail.gmail.com/
> >
> >  man2/link.2 | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >
> > diff --git a/man2/link.2 b/man2/link.2
> > index 649ba00c7..15c24703e 100644
> > --- a/man2/link.2
> > +++ b/man2/link.2
> > @@ -184,6 +184,57 @@ See
> >  .BR openat (2)
> >  for an explanation of the need for
> >  .BR linkat ().
> > +.TP
> > +.BR AT_ATOMIC_METADATA " (since Linux 5.x)"
> > +By default, a link operation followed by a system crash, may result in the
> > +new file name being linked with old inode metadata, such as out dated time
> > +stamps or missing extended attributes.
> > +.BR fsync (2)
> > +before linking the inode, but that involves flushing of volatile disk caches.
> > +
> > +A filesystem that accepts this flag will guaranty, that old inode metadata
> > +will not be exposed in the new linked name.
> > +Some filesystems may internally perform
> > +.BR fsync (2)
> > +before linking the inode to provide this guaranty,
> > +but often, filesystems will have a more efficient method to provide this
> > +guaranty without flushing volatile disk caches.
> > +
> > +A filesystem that accepts this flag does
> > +.BR NOT
> > +guaranty that the new file name will exist after a system crash, nor that the
> > +current inode metadata is persisted to disk.
>
> Hmmm.  I think it would be much clearer to state the two expectations in
> the same place, e.g.:
>
> "A filesystem that accepts this flag guarantees that after a successful
> call completion, the filesystem will return either (a) the version of
> the metadata that was on disk at the time the call completed; (b) a
> newer version of that metadata; or (c) -ENOENT.  In other words, a
> subsequent access of the file path will never return metadata that was
> obsolete at the time that the call completed, even if the system crashes
> immediately afterwards."

Your feedback is along the same line as Ted's feedback.
I will try out the phrasing that Ted proposed, will see how that goes...

>
> Did I get that right?  I /think/ this means that one could implement Ye
> Olde Write And Rename as:
>
> fd = open(".", O_TMPFILE...);
> write(fd);
> fsync(fd);

Certainly not fsync(), that what my "counter-fsync()" phrasing was trying to
convey. The flags are meant as a "cheaper" replacement for that fsync().

> snprintf(path, PATH_MAX, "/proc/self/fd/%d", fd);
> linkat(AT_FDCWD, path, AT_FDCWD, "file.txt",
>         AT_EMPTY_PATH | AT_ATOMIC_DATA | AT_ATOMIC_METADATA);
>
> (Still struggling to figure out what userspace programs would use this
> for...)
>

There are generally two use cases:

1. Flushing volatile disk caches is very expensive.
In this case sync_file_range(SYNC_FILE_RANGE_WRITE_AND_WAIT)
is cheaper than fdatasync() for a preallocated file and obviously a noop
for AT_ATOMIC_METADATA in "S.O.M.C" filesystem is cheaper than
a journal commit.

2. Highly concurrent metadata workloads
Many users running  AT_ATOMIC_METADATA concurrently are much
less likely to interfere each other than many users running fsync concurrently.

IWO, when I'm using fsync() to provide the AT_ATOMIC_METADATA guarantee
on a single journal fs, other users pay the penalty for a guaranty that I didn't
ask for (i.e. persistency).

Thanks,
Amir.
