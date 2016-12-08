Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34559 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbcLHKO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 05:14:26 -0500
MIME-Version: 1.0
In-Reply-To: <20161207201637.GI4219@dastard>
References: <20161207034724.1613-1-david@fromorbit.com> <20161207034724.1613-7-david@fromorbit.com>
 <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
 <CAOQ4uxhrtaHauNJypezpFAT0VCN61oZLFKtxuBLw32jn7FOSFw@mail.gmail.com> <20161207201637.GI4219@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Dec 2016 12:14:24 +0200
Message-ID: <CAOQ4uxh+QX5uzJCXtEG8vg0qhUTgQ0QG1ZWDkr1ryH0kQxi0ZA@mail.gmail.com>
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Dec 7, 2016 at 10:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Dec 07, 2016 at 04:21:31PM +0200, Amir Goldstein wrote:
...
>>
>> 1. Do you think that xfs_io should error on -c "open foo"  to force
>> explicit -C "open foo"?
>
> No.
>
>>     it can't be breaking any existing users, because -c "open foo" is
>> already very broken.
>
> Maybe so, but there are users of it. e.g:
>
> $ git grep open |grep XFS_IO
> tests/overlay/001:      $XFS_IO_PROG -c "open" $f >>$seqres.full
> $
>
> This is precisely why I made oneshot commands just work silently
> with "-c" - who knows what will break if we start rejecting commands
> that otherwise work just fine when there is only one open file....
>

Interesting example. Here -c "open" is actually an 'alias' for
-c "stat", which could have been non one shot.
Nevertheless, I see your point.

>> 2. You marked mmap ONE_SHOT, but not all the m* commands.
>>    Stands to reason that they should all be marked ONE_SHOT. because iterating
>>    the file table has nothing to do with the m* commands. no?
>
> It is not clear to me what the correct thing to do here is, I don't
> have the time right now to look into it, so I didn't
> change mread/mwrite/msync behaviour. If it's broken before it is
> still broken now.
>

Very well, but I am not sure why mmap should be marked one shot?
Possibly, mmap caught your filters because it is CMD_NOFILE_OK,
but in fact, the only case where mmap with no open files works is
after mmaping files and closing all open files.

Currently, this command:
$ xfs_io -c "mmap 0 4" -C "mmap" foo bar

Results in:
[000] 0x7f17319ae000 - 0x7f17319ae004 rwx             bar (0 : 4)

IMO, it would be more useful if it resulted in:
 000  0x7f27e289d000 - 0x7f27e289d004 rwx             foo (0 : 4)
[001] 0x7f27e289c000 - 0x7f27e289c004 rwx             bar (0 : 4)

Which will allow following up with more specific -C m* commands
and it would be more consistent with the result of:
$ xfs_io -C "file" foo bar
 000  foo            (foreign,non-sync,non-direct,read-write)
[001] bar            (foreign,non-sync,non-direct,read-write)



>> About the fix to overlay/016.
>> How would you prefer to address the conditional availability of xfs_io -C?
>>
>> 1. new helper _require_xfs_io_one_shot_command
>> 2. _require_xfs_io_command "open" (which internally checks for xfs_io -C "open")
>> 3. third option?
>
> I don't really care - #2 is probably neatest. If what you do is too
> ugly to live then I'll let you know.
>

I trust that you will :-)
Will post it soon.

Thanks,
Amir.
