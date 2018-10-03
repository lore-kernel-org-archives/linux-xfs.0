Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:43846 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeJDGEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 02:04:42 -0400
Received: by mail-io1-f66.google.com with SMTP id y10-v6so6432046ioa.10
        for <linux-xfs@vger.kernel.org>; Wed, 03 Oct 2018 16:14:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181003225917.GR18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com> <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard> <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard> <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard> <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
 <20181002231421.GQ18567@dastard> <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
 <20181003225917.GR18567@dastard>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 4 Oct 2018 01:14:12 +0200
Message-ID: <CAJfpegsHwm=w8HhqEuYTBE1yFkhiTFB5Su1f2VrAB9XPhWrrbg@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Thu, Oct 4, 2018 at 12:59 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 03, 2018 at 06:45:13AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 3, 2018 at 2:14 AM Dave Chinner <david@fromorbit.com> wrote:
>> [...]
>> > > Seems like freezing any of the layers if overlay itself is not frozen
>> > > is not a good idea.
>> >
>> > That's something we can't directly control. e.g. lower filesystem is
>> > on a DM volume. DM can freeze the lower fileystem through the block
>> > device when a dm command is run. It may well be that the admins that
>> > set up the storage and filesystem layer have no idea that there are
>> > now overlay users on top of the filesystem they originally set up.
>> > Indeed, the admins may not even know that dm operations freeze
>> > filesystems because it happens completely transparently to them.
>> >
>>
>> I don't think we should be binding the stacked filesystem issues with
>> the stacked block over fs issues.
>
> It's the same problem.  Hacking a one-off solution to hide a specific
> overlay symptom does not address the root problem. And, besides, if
> you stack like this:
>
> overlay
>   lower_fs
>     loopback dev
>       loop img fs
>
> And freeze the loop img fs, overlay can still get stuck in it's
> shrinker because the the lower_fs gets stuck doing IO on the frozen
> loop img fs.
>
> i.e. it's the same issue - kswapd will get stuck doing reclaim from
> the overlay shrinker.

Is overlay making the situation any worse in this case?  IOW, would
reclaim on fs-over-loopback not have the same issue *without* overlay?
 If not, why?

>> The latter is more complex to solve
>> generally and has by design non limited stack depth. The former has
>> limited stack depth (2) and each sb knows its own stack depth, which
>> is already used in overlay to annotate lockdep correctly.
>>
>> If vfs stores a reverse tree of stacked fs dependencies, then individual
>> sb freeze can be solved.
>
> Don't make me mention bind mounts... :/

How do mounts have anything to do with this?  We are talking about
filesystem (i.e. superblock) dependencies, not mount dependencies
(which would make zero sense anyway).

Thanks,
Miklos
