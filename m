Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f42.google.com ([209.85.161.42]:36555 "EHLO
        mail-yw1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfA2HTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 02:19:10 -0500
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard>
 <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com> <20190129001826.GV4205@dastard>
In-Reply-To: <20190129001826.GV4205@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Jan 2019 09:18:57 +0200
Message-ID: <CAOQ4uxiNe8i6YZ3dQvsW_fDNoPj5HPyY5ve93wXChmqAC10B4w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

> > I think it's a good idea to add file freeze semantics to the toolbox
> > of useful things that could be accomplished with reflink.
>
> reflink is already atomic w.r.t. other writes - in what way does a
> "file freeze" have any impact on a reflink operation? that is, apart
> from preventing it from being done, because reflink can modify the
> source inode on XFS, too....
>

- create O_TMPFILE
- freeze source file
- read and calculate hash from source file
- likely unfreeze and skip reflink+backup

For the unlikely case, application could copy_file_range
before unfreeze and that means that reflink of source should
be allowed while file is frozen, that is, while file *data* is frozen.

That mean that file freeze API needs to be able to express if both
metadata and data freeze are required.

> > Anyway, freeze semantics alone won't work for our backup application
> > that needs to be non intrusive. Even if writes to large file are few,
> > backup may take time, so blocking those few write for that long is
> > not acceptable.
>
> So, reflink is too expensive because there are only occasional
> writes, but blocking that occasional write is too expensive, too,
> even though it is rare?
>

All right. I admit to have presented a weak example, but I am
not submitting a patch to be merged. I am proposing a discussion
on what I think is a gap in existing API. The feedback of "what is
the measurable benefits?" is well expected, but I brought this up
anyway, without concrete measurable figures to hear what others
have to say. And frankly, I quite like the file freeze suggestion, so
I am glad that I did.

Besides, even if existing filesystems implement reflink fast "enough",
this is not at all an mandated by the API.

> > Blocking the writes for the setup time of a reflink
> > is exactly what I was proposing and in your analogy,
>
> No, I proposed a way to provide a -point in time snapshot- of a
> file that doesn't require reflink or any other special filesystem
> support.
>
> > the block
> > device is frozen only for a short period of time for setting up the
> > snapshot and not for the duration of the backup.
>
> Right, it's frozen for as long as it takes to set up a -point in
> time snapshot- that the backup can be taken from. You don't need
> that to reflink a file. You need it if you want to do something
> other than a reflink....
>

Correct. As I wrote above, that could be used for conditional
copy or conditional reflink on a filesystem where reflink  has a
measurable cost.

Bottom line: I completely agree with you that "file freeze" is sufficient
for the case I presented, as long as reflink is allowed while file is frozen.
IOW, break the existing compound API freeze+reflink+unfreeze to
individual operations to give more control over to user.

Thanks,
Amir.
