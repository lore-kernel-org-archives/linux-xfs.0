Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36559 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbcLFFl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 00:41:29 -0500
MIME-Version: 1.0
In-Reply-To: <20161205221548.GD4326@dastard>
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
 <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net> <CAOQ4uxhw8Y_9NVwuAZ_xzvPYZ8k1CRonmQ=CAn=Y9j-_nkToMA@mail.gmail.com>
 <00b2b645-3cd2-f3b2-b026-40dfc97f3f90@sandeen.net> <CAOQ4uxhmLe32AMkBmRJx37Pmg3oZMFLt_6Q0kTNYxix_qz7vZA@mail.gmail.com>
 <20161205221548.GD4326@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 6 Dec 2016 07:24:12 +0200
Message-ID: <CAOQ4uxiSDniBTpfgOT9AQ8YGG5Ffz1rSLcBvWdm8TgY_OEArJA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Dec 6, 2016 at 12:15 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 05, 2016 at 05:39:17PM +0200, Amir Goldstein wrote:
>> On Mon, Dec 5, 2016 at 5:26 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> > On 12/5/16 9:19 AM, Amir Goldstein wrote:
>> >> On Mon, Dec 5, 2016 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> >>> On 12/5/16 7:03 AM, Amir Goldstein wrote:
>> >>>> There is an undocumented and possibly unused feature in xfs_io
>> >>>> where all commands are executed per file in the file args list.
>> >>>>
>> >>>> This feature creates ambiguity when trying to execute commands
>> >>>> such as "open" and "file" from command line and result in an
>> >>>> endless loop in the command loop code.
>> >>>
>> >>> I may well be dense, but it's not immediately obvious what the
>> >>> old and/or problematic behavior is.  Can you spell it out a bit
>> >>> more?  What is an example of this loop?
>> >>
>> >> $ touch foo
>> >> $ xfs_io -c "open foo" foo
>> >>
>> >> you will see the shit storm
>> >
>> > ;)  Ok thanks.  (would be nice to have that in the changelog)
>> >
>>
>> Good point. I will add that.
>>
>>
>> >
>> > Given that neither the manpage nor the short help mention that more than
>> > one filename is accepted, should this even succeed at all?
>> >
>>
>> Make sense to me to fail on multiple file args.
>
> It doesn't to me.
>
> The fact that xfs_io has an open command, and it has
> commands that can act on multiple files (e.g. sendfile) indicate
> that it should be able to handle multiple files.
>
> Indeed, in interactive mode, the current file is really just an
> index into the stack of open files. It works exactly the same way as
> other XFS tools do with context stacks and accessed object rings
> (e.g. xfs_db). i.e. you only need to open the file/access the object
> once and then you can use the stack/ring to jump straight back to
> it. In this case, it's the xfs_io "file" command.
>
> i.e. xfs_io is intended to by able to operate on multiple files at
> once, and I do use that in interactive mode from time to time.
>
> What I haven't ever done is try to access that through the command
> line, so I didn't know it had this "command loop" iteration problem.
>
> It's the command loop iteration problem we need to fix, not neuter
> the multiple file capability of xfs_io.
>

OK, v4 it is.
For some reason you fail to spell out your idea of "fixing",
so I keep having to guess what you mean.
This time I am guessing that you mean:
- open all the files in args list (all using the same -r/-f flags)
- iterate all commands exactly once without implicitly changing "file"

Amir.
