Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:18517 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbfA2XBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 18:01:34 -0500
Date: Wed, 30 Jan 2019 10:01:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Message-ID: <20190129230129.GD4205@dastard>
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz>
 <20190128212642.GQ4205@dastard>
 <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
 <20190129001826.GV4205@dastard>
 <CAOQ4uxiNe8i6YZ3dQvsW_fDNoPj5HPyY5ve93wXChmqAC10B4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiNe8i6YZ3dQvsW_fDNoPj5HPyY5ve93wXChmqAC10B4w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 29, 2019 at 09:18:57AM +0200, Amir Goldstein wrote:
> > > I think it's a good idea to add file freeze semantics to the toolbox
> > > of useful things that could be accomplished with reflink.
> >
> > reflink is already atomic w.r.t. other writes - in what way does a
> > "file freeze" have any impact on a reflink operation? that is, apart
> > from preventing it from being done, because reflink can modify the
> > source inode on XFS, too....
> >
> 
> - create O_TMPFILE
> - freeze source file
> - read and calculate hash from source file
> - likely unfreeze and skip reflink+backup

IF you can read the file to determine if you need to back up the
file while it's frozen, then why do you need to reflink it
before you read the file to back it up? It's the /exact same
read operation/ on the file.

I'm not sure what the hell you actually want now, because you've
contradicting yourself again by saying you want read the entire file
while it's frozen and blocking writes, after you just said that's
not acceptible and why reflink is required....

> > > Anyway, freeze semantics alone won't work for our backup application
> > > that needs to be non intrusive. Even if writes to large file are few,
> > > backup may take time, so blocking those few write for that long is
> > > not acceptable.
> >
> > So, reflink is too expensive because there are only occasional
> > writes, but blocking that occasional write is too expensive, too,
> > even though it is rare?
> >
> 
> All right. I admit to have presented a weak example, but I am
> not submitting a patch to be merged. I am proposing a discussion
> on what I think is a gap in existing API. The feedback of "what is
> the measurable benefits?" is well expected, but I brought this up
> anyway, without concrete measurable figures to hear what others
> have to say. And frankly, I quite like the file freeze suggestion, so
> I am glad that I did.
> 
> Besides, even if existing filesystems implement reflink fast "enough",
> this is not at all an mandated by the API.

All the API mandates is that it is atomic w.r.t. other IO and
that's all that realy matters. Everything else is optional,
including performance.

Correct functionality first, performance second.

> Bottom line: I completely agree with you that "file freeze" is sufficient
> for the case I presented, as long as reflink is allowed while file is frozen.
> IOW, break the existing compound API freeze+reflink+unfreeze to
> individual operations to give more control over to user.

I don't think that's a good idea. If we allow "metadata" to be
unfrozen, but only freeze data, does that mean we allow modifying
owner, perms, attributes, etc, but then don't allow truncate. What
about preallocation over holes? That doesn't change data, and it's
only a metadata modification. What about background dedupe? That
sort of thing is a can of worms that I don't want to go anywhere
near. Either the file is frozen (i.e. effectively immutable but
blocks modifications rather than EPERMs) or it's a normal, writeable
file - madness lies within any other boundary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
