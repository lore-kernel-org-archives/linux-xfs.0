Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34910 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753457AbcLKTXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2016 14:23:41 -0500
Received: by mail-wm0-f66.google.com with SMTP id a20so6613068wme.2
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2016 11:23:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161211182744.GM8436@birch.djwong.org>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161210194214.GL8436@birch.djwong.org> <CAOQ4uxhkfUY8HHkMkJxmAZ8TJexOqACSQjqWJc0pUvgTEN2CcQ@mail.gmail.com>
 <20161211182744.GM8436@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 11 Dec 2016 21:23:38 +0200
Message-ID: <CAOQ4uxiCTrTsBSzUp9wOs-1FmBiF4kkDCzzeaonciA-NJHWR0A@mail.gmail.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sun, Dec 11, 2016 at 8:27 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, Dec 11, 2016 at 10:38:21AM +0200, Amir Goldstein wrote:
>> On Sat, Dec 10, 2016 at 9:42 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
>> ...
>> >
>> >> I realize that rmapbt/reflink features are declared unstable and
>> >> bugs could certainly be lurking without doing any reflinks at all.
>> >> However, I estimate the the class of bugs introduces by heavily
>> >> reflinked file systems is going to take more time to tame.
>> >
>> > Yes, probably.  It seems reasonably stable on a young FS, though we'll
>> > see how gracefully it ages.  There's probably mistakes in the ENOSPC
>> > handling since that seems to be everyone's Achilles heel.
>> >
>>
>> So we seem to be in agreement on the requirement.
>
> I'm willing to consider code to dynamically enable reflink, yes.
>

Well, if we can get a consensus on what should be supported
I can work on it and if you prefer to implement I will be happy to test.

>>
>> Good, so you are saying that the tool to enable refcount offline is already
>> available and I can basically choose option #2.
>> In that case, no further questions :-)
>
> Keep in mind that editing the filesystem with xfs_db and running
> xfs_repair to fill in the gaps is totally unsupported behavior!
>
> If you break it you get to keep all the pieces.
>
> I'd much, much, much rather have a properly engineered and tested
> upgrade path, which I guess we could do for reflink.
>

I'd much much much much rather that as well.

>> > If you're building your own kernels, you could just tweak
>> > xfs_reflink_remap_range with something like:
>> >
>> > if (!capable(CAP_SYS_ADMIN))
>> >         return -EOPNOTSUPP;
>> >
>> > so that only you (well, root) can make files share blocks.
>> >
>>
>> Sure, I know that :)
>> I am not the admin in this case though, I am the developer
>> who wants to prevent other developers and admins of
>> messing with reflink before it is ripe.
>> And let us not forget:
>> a76b5b0 fs: try to clone files first in vfs_copy_file_range
>> And what would happen when the nfsd on the systems try to
>> copy file range.
>
> <shrug> vfs_copy_file_range -> xfs_clone_file_range ->
> xfs_reflink_remap_range....
>

What I meant is that I could probably make sure there are no
obvious programs on our systems that issue a clone ioctl,
but nfsd which runs as root is going to be a source for
copy/clone requests from clients, so the
!capable(CAP_SYS_ADMIN) test is in sufficient
If I have to patch our systems I will add -onoreflink

>>
>> :-/ pre-allocate log space and AG space is an issue.
>> I can tweak mkfs.xfs to preallocate those for my use case,
>> but I am hoping that the need meets a bigger crowd and xfsprogs 4.9
>> would have a solution for that.
>
> In general, mkfs seems to create a log that's more than large enough to
> handle a dynamic increase in features.
>

So for large enough arrays I suppose that preallocating log space is not
an issue?

>> How about having mkfs.xfs 4.9 preallocate the space needed for
>> refcountbt if rmapbt=1? it's a bit of a hack, which Dave most probably
>> won't like, but it avoids the need to define a new recountbt=1 flag
>> just for the preallocation.
>
> Chances are pretty good there's enough space unless your fs is totally
> full, and if it's full then you might seriously consider a full
> backup/restore cycle onto a bigger disk to reduce fragmentation.
>

I though there was an issue with reserved space per AG and
that the amount of reserved space for btree blocks depends on the
features. If a single full AG is not an issue then never mind.

>>
>> The lesson is that if xfs_repair is able to de-refcount all blocks
>> (given sufficient disk space) and turn off the reflink feature and if
>> that functionality is well tested, then more users would have the
>> courage to enable reflink during its "beta" phase.
>
> Sure, but IIRC you could nuke all the corrupt snapshots by deleting the
> hidden snapshots file and releasing all the space it referenced back to
> the filesystem, which makes it easy to zap all the snapshots if
> something is amiss.
>
> Un-sharing an fs full of reflinked files requires us to build code to
> iterate every bmbt of every file (or to cross-reference every refcountbt
> record against the rmapbt to find the sharers) and then relocate the
> data, which is quite a bit more complex... and unnecessary since we can
> rebuild all the broken refcount metadata anyway.
>

You are right, of course, from technical POV, but psychologically, if people
know they have a safe way back to what they know and trust, it is easier
for them make the leap...

Amir.
