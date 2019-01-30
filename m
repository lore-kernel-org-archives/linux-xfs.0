Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f44.google.com ([209.85.161.44]:39965 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Nav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 08:30:51 -0500
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard>
 <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
 <20190129001826.GV4205@dastard> <CAOQ4uxiNe8i6YZ3dQvsW_fDNoPj5HPyY5ve93wXChmqAC10B4w@mail.gmail.com>
 <20190129230129.GD4205@dastard>
In-Reply-To: <20190129230129.GD4205@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Jan 2019 15:30:39 +0200
Message-ID: <CAOQ4uxifnvHnM-i7LnHx6a9s9msx_=X_RweRxXu9US0_NEK2Hw@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Wed, Jan 30, 2019 at 1:01 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jan 29, 2019 at 09:18:57AM +0200, Amir Goldstein wrote:
> > > > I think it's a good idea to add file freeze semantics to the toolbox
> > > > of useful things that could be accomplished with reflink.
> > >
> > > reflink is already atomic w.r.t. other writes - in what way does a
> > > "file freeze" have any impact on a reflink operation? that is, apart
> > > from preventing it from being done, because reflink can modify the
> > > source inode on XFS, too....
> > >
> >
> > - create O_TMPFILE
> > - freeze source file
> > - read and calculate hash from source file
> > - likely unfreeze and skip reflink+backup
>
> IF you can read the file to determine if you need to back up the
> file while it's frozen, then why do you need to reflink it
> before you read the file to back it up? It's the /exact same
> read operation/ on the file.
>
> I'm not sure what the hell you actually want now, because you've
> contradicting yourself again by saying you want read the entire file
> while it's frozen and blocking writes, after you just said that's
> not acceptible and why reflink is required....
>

Mmm. I've tried to stick to a simplified description and picked one specific
use case of large file that was not a good example.
A colleague has corrected me that we are more concerned over the cost of
reflinking many millions of files just to find out that they were not change
and even just to back them up.
Ended up being confusing. If I contradicted myself is because my description
was often missing "sometimes".

Let's start over:
For small files, that can fit in application buffers, freeze is probably enough.
For very large files, your assertion that reflink is cheap compared to reading
the file is correct, so there is probably no justification for lazy reflink.

In the middle, there are files that we can analyse fast enough to determine
which parts of the file have been modified and send the modified parts.
Send can happen quite later.
If we analysed the frozen file, we wouldn't want the file to change
before sending
out the modified parts, hence we would want a reflink that is consistent with
the file that we analysed.

For that case, I think we need freeze+reflink, where reflink is done under
write protection. If I am wrong from show me how.

> > Bottom line: I completely agree with you that "file freeze" is sufficient
> > for the case I presented, as long as reflink is allowed while file is frozen.
> > IOW, break the existing compound API freeze+reflink+unfreeze to
> > individual operations to give more control over to user.
>
> I don't think that's a good idea. If we allow "metadata" to be
> unfrozen, but only freeze data, does that mean we allow modifying
> owner, perms, attributes, etc, but then don't allow truncate. What
> about preallocation over holes? That doesn't change data, and it's
> only a metadata modification. What about background dedupe? That
> sort of thing is a can of worms that I don't want to go anywhere
> near. Either the file is frozen (i.e. effectively immutable but
> blocks modifications rather than EPERMs) or it's a normal, writeable
> file - madness lies within any other boundary...
>

OK. the data/metadata dichotomy may be wrong to use here,
because it is not well defined.
We all know that truncate and fallocate need to be serialized with
data modifications and filesystems already do that, so however you
call it, we all know what data changes means.
I agree that data sometimes requires consistency with metadata.

Fact is that the backup application is interested in the file content
and metadata, but NOT the file disk layout.

generic_remap_file_range_prep() does not require that source
file is not immutable. Does XFS? I don't know if "immutable"
has ever been defined w.r.t file layout on disk. has it?
I recon btrfs re-balancing would not stop at migrating "immutable"
file blocks would it?

Still madness? or sparks of sanity?

Thanks,
Amir.
