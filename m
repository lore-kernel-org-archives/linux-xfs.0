Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34543 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbcLKIiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2016 03:38:23 -0500
Received: by mail-wj0-f193.google.com with SMTP id xy5so7380715wjc.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2016 00:38:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161210194214.GL8436@birch.djwong.org>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161210194214.GL8436@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 11 Dec 2016 10:38:21 +0200
Message-ID: <CAOQ4uxhkfUY8HHkMkJxmAZ8TJexOqACSQjqWJc0pUvgTEN2CcQ@mail.gmail.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sat, Dec 10, 2016 at 9:42 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
...
>
>> I realize that rmapbt/reflink features are declared unstable and
>> bugs could certainly be lurking without doing any reflinks at all.
>> However, I estimate the the class of bugs introduces by heavily
>> reflinked file systems is going to take more time to tame.
>
> Yes, probably.  It seems reasonably stable on a young FS, though we'll
> see how gracefully it ages.  There's probably mistakes in the ENOSPC
> handling since that seems to be everyone's Achilles heel.
>

So we seem to be in agreement on the requirement.

>> Considering these options for said systems:
>> 1. kernel v4.8.y or v4.9.y and mkfs.xfs -m rmapbt=1
>> 2. kernel v4.9.y and mkfs.xfs -m rmapbt=1
>> 3. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflink=1
>>     and new mount option -onoreflink
>> 4. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflinkbt=1
>>     (separate rocomapt features reflinkbt from reflink)
>>
>> Options 1-2 would require adding support in xfs_admin to
>> enable reflink on an existing fs (by cloning the bmbt).
>
> Not sure why you'd clone the bmbt...?
>

Just because I am don't know reflink well enough..
I mistakenly thought that refcount=1 extents are tracked in refcountbt.

> You'd simply use the rmap information to calculate a new refcountbt,
> just like the offline repair already knows how to do.
>

Good, so you are saying that the tool to enable refcount offline is already
available and I can basically choose option #2.
In that case, no further questions :-)

> Now obviously if you don't have rmap information then you have to walk
> all the inode data forks in the system to get rmap information... we
> don't share non-data blocks and never will, particularly since we've
> stamped owner information into all the metadata headers.
>

I don't event want to thing about enabling rmapbt.


>>
>> Option 4 requires changing mkfs.xfs before 4.9 release
>> and possibly setting recompat feature reflink on first file
>> reflink. There are several precedents to this sort of  "set
>> on first use" feature in ext4, not sure if there are any in xfs.
>
> There are several of these in XFS, but I don't want to burn another
> feature bit if I can avoid it.  Dave might have a different opinion
> though?
>

Considering how easy it is to enable reflink offline (by running repair)
I myself see no reason for a new feature flag.

>> The benefit of having this functionality is that others,
>> like me, could provide more testing for the refcount<=1
>> use case. I myself intend to test refcount>1 as well, but
>> the goal of getting recount<=1 ready for production is
>> higher priority.
>
> If you're building your own kernels, you could just tweak
> xfs_reflink_remap_range with something like:
>
> if (!capable(CAP_SYS_ADMIN))
>         return -EOPNOTSUPP;
>
> so that only you (well, root) can make files share blocks.
>

Sure, I know that :)
I am not the admin in this case though, I am the developer
who wants to prevent other developers and admins of
messing with reflink before it is ripe.
And let us not forget:
a76b5b0 fs: try to clone files first in vfs_copy_file_range
And what would happen when the nfsd on the systems try to
copy file range.


>
> Well, to paraphrase the ext4 manual,
>
> "The recommended method for upgrading an [old] filesystem to [a new one]
> is to back up the entire volume, reformat the storage device with [the
> new mkfs options], and restore the entire volume onto the fresh
> filesystem."
>

Words of wisdom, no doubt, but reality calls for adjustments sometimes.
For the case of systems that are going to be deployed in production
and would not tolerate long downtime, I would relax this recommendation
to:
- backup the entire volume
- make the upgrade
- followup with regression testing after the upgrade
- if anything goes wrong, take system offlline and restore from backup

This just moved the penalty of downtime to the unlikely() branch.

I realize that there are other options to avoid long downtime
(switch to new server/volume), but the case above is valid as well.



>
>> Darrick,
>>
>> I seem to recall you taking about enabling reflink on existing
>> fs sometime before, but I could not find that reference.
>> I suppose you had an idea of how this should be done?
>
> Christoph posted the first patchset to enable at runtime:
> http://oss.sgi.com/archives/xfs/2016-06/msg00053.html
>

Thanks for that pointer.
Christoph, do you still have a use case for turning on reflink?
Does it have to be "online" or is enabling offline good enough?

...

>
> In theory we could allow people to turn things on dynamically provided
> the FS meets all the requirements (log space, rootino doesn't move, free
> AG space).  It'd be pretty easy to do this for reflink since the space
> requirements are minimal, and much more risky to let people do that for
> rmap.  We'd need thorough testing, too.
>

:-/ pre-allocate log space and AG space is an issue.
I can tweak mkfs.xfs to preallocate those for my use case,
but I am hoping that the need meets a bigger crowd and xfsprogs 4.9
would have a solution for that.

How about having mkfs.xfs 4.9 preallocate the space needed for
refcountbt if rmapbt=1? it's a bit of a hack, which Dave most probably
won't like, but it avoids the need to define a new recountbt=1 flag
just for the preallocation.

Thoughts?

Amir.


P.S.: I have a lesson to share:
6 years ago I released ext3 snapshots feature
It was deployed in production after a relatively short beta period
and very little community testing/review.
Since then, it was deployed on many systems and not once
did it cause any data corruption.
>From engineering POV, I consider this a miracle, but to aid that
miracle I had a powerful tool in my disposal.
I implemented e2fsck -x flag, where if anything messed up
wrt refcounting, snapshots could be discarded and file system
would be brought back to health.
The tool proved itself useful is several cases (used with no
developer intervention).

The lesson is that if xfs_repair is able to de-refcount all blocks
(given sufficient disk space) and turn off the reflink feature and if
that functionality is well tested, then more users would have the
courage to enable reflink during its "beta" phase.
