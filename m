Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:39658 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdEJTdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 15:33:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20170507155855.GD5970@birch.djwong.org>
        <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
        <20170508184112.GJ5973@birch.djwong.org>
        <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
        <20170508204738.GL5973@birch.djwong.org>
        <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
        <20170509015324.GM5973@birch.djwong.org>
        <20170509211746.GA87747@gmail.com>
        <20170510163818.7bleiykxgnx3pkds@thunk.org>
Date: Wed, 10 May 2017 14:27:33 -0500
In-Reply-To: <20170510163818.7bleiykxgnx3pkds@thunk.org> (Theodore Ts'o's
        message of "Wed, 10 May 2017 12:38:18 -0400")
Message-ID: <87mvakpl5m.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> On Tue, May 09, 2017 at 02:17:46PM -0700, Eric Biggers wrote:
>> 1.) Privacy implications.  Say the filesystem is being shared between multiple
>>     users, and one user unpacks foo.tar.gz into their home directory, which
>>     they've set to mode 700 to hide from other users.  Because of this new
>>     ioctl, all users will be able to see every (inode number, size in blocks)
>>     pair that was added to the filesystem, as well as the exact layout of the
>>     physical block allocations which might hint at how the files were created.
>>     If there is a known "fingerprint" for the unpacked foo.tar.gz in this
>>     regard, its presence on the filesystem will be revealed to all users.  And
>>     if any filesystems happen to prefer allocating blocks near the containing
>>     directory, the directory the files are in would likely be revealed too.
>
> Unix/Linux has historically not been terribly concerned about trying
> to protect this kind of privacy between users.  So for example, in
> order to do this, you would have to call GETFSMAP continously to track
> this sort of thing.  Someone who wanted to do this could probably get
> this information (and much, much more) by continuously running "ps" to
> see what processes are running.
>
> (I will note. wryly, that in the bad old days, when dozens of users
> were sharing a one MIPS Vax/780, it was considered a *good* thing
> that social pressure could be applied when it was found that someone
> was running a CPU or memory hogger on a time sharing system.  The
> privacy right of someone running "xtrek" to be able to hide this from
> other users on the system was never considered important at all.  :-)
>
> Fortunately, the days of timesharing seem to well behind us.  For
> those people who think that containers are as secure as VM's (hah,
> hah, hah), it might be that best way to handle this is to have a mount
> option that requires root access to this functionality.  For those
> people who really care about this, they can disable access.

What would be the reason for not putting this behind
capable(CAP_SYS_ADMIN)?

What possible legitimate function could this functionality serve to
users who don't own your filesystem?

I have seen several people speak up how this is a concern I don't see
anyone saying here is a legitimate use for a non-system administrator.

This doesn't seem like something where abuses of time-sharing systems
can be observed.

Eric
