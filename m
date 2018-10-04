Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:38362 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeJDOYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 10:24:55 -0400
Received: by mail-io1-f68.google.com with SMTP id e2-v6so5435242ioh.5
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 00:33:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181004053838.GT18567@dastard>
References: <20181001010931.GO31060@dastard> <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard> <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard> <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
 <20181002231421.GQ18567@dastard> <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
 <20181003225917.GR18567@dastard> <CAJfpegsHwm=w8HhqEuYTBE1yFkhiTFB5Su1f2VrAB9XPhWrrbg@mail.gmail.com>
 <20181004053838.GT18567@dastard>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 4 Oct 2018 09:33:01 +0200
Message-ID: <CAJfpegsr3hKcrE3i7nJ=AiTi8DJoQCYHG=uNEd2EFJtefEVybA@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Thu, Oct 4, 2018 at 7:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Oct 04, 2018 at 01:14:12AM +0200, Miklos Szeredi wrote:
>> On Thu, Oct 4, 2018 at 12:59 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > overlay
>> >   lower_fs
>> >     loopback dev
>> >       loop img fs
>> >
>> > And freeze the loop img fs, overlay can still get stuck in it's
>> > shrinker because the the lower_fs gets stuck doing IO on the frozen
>> > loop img fs.
>> >
>> > i.e. it's the same issue - kswapd will get stuck doing reclaim from
>> > the overlay shrinker.
>>
>> Is overlay making the situation any worse in this case?  IOW, would
>
> No, it's not. My point is that it's the same layering problem, not
> that it is an issue unique to overlay. Fixing one without addressing
> the other does not make the problem go away.

But you were suggesting that this should be solved by somehow
preventing the shrink after unlink issue in overlayfs.

But the freeze dependency is not unique to that: if filesystem A is
frozen and a file in that fs is loopback mounted in filesystem B then
B also needs to be frozen before A is frozen to prevent deadlocking
through kswapd.

Both could be solved by creating a new "struct freeze_dep" object with
->freeze/unfreeze methods, that can be embedded into overlay and
loopback device and whatever else, and which is installed onto a
"struct list_head s_freeze_deps" list in the superblock.

Does that make sense?

>
>> >> If vfs stores a reverse tree of stacked fs dependencies, then individual
>> >> sb freeze can be solved.
>> >
>> > Don't make me mention bind mounts... :/
>>
>> How do mounts have anything to do with this?
>
> Bind mounts layer superblocks in unpredictable manners. e.g. the
> lowerfs for overlay could be a directory heirachy made up of
> multiple bind mounts from different source filesystems. So it's not
> just a 1:1 upper/lower superblock relationship it could be 1:many.
> Dependency graphs get complx quickly in such configurations.

Overlayfs avoids that sort of mess by not overlaying mount trees, just
single mounts.

> My point is that it's not obvious that there is a simple, clear
> dependency hierarchy between superblocks because there are so many
> ways they can be layered by userspace and layered fileystems and
> block devices.

For overlay and loopback there's a simple dependency graph.  As for
stacked block devs, I have no idea if such an infrastructure makes
sense or is possible at all.

Thanks,
Miklos
