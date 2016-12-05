Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36553 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbcLEPUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 10:20:06 -0500
MIME-Version: 1.0
In-Reply-To: <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net>
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com> <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Dec 2016 17:19:11 +0200
Message-ID: <CAOQ4uxhw8Y_9NVwuAZ_xzvPYZ8k1CRonmQ=CAn=Y9j-_nkToMA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Dec 5, 2016 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 12/5/16 7:03 AM, Amir Goldstein wrote:
>> There is an undocumented and possibly unused feature in xfs_io
>> where all commands are executed per file in the file args list.
>>
>> This feature creates ambiguity when trying to execute commands
>> such as "open" and "file" from command line and result in an
>> endless loop in the command loop code.
>
> I may well be dense, but it's not immediately obvious what the
> old and/or problematic behavior is.  Can you spell it out a bit
> more?  What is an example of this loop?

$ touch foo
$ xfs_io -c "open foo" foo

you will see the shit storm

>
>> Also, when running xfs_io -c <cmd> without any file args, xfs_io
>> exits without doing anything. This behavior is also undocumented
>> and makes very little sense.
>
> What /should/ it do if there is no file specified?  Is this just for
> cmds that don't require a file, such as "-c sync?"

Execute the commands as if you ran xfs_io and entered those commands
in the shell, for example:

$ xfs_io -c "open foo" -c "pread -v 0 4"

>
>> Change the behavior of xfs_io to execute each command specified
>> with -c <cmd> exactly once, regardless of the number of files in
>> the file args list.
>
> So then which file does it act on?  I'm not saying this is incorrect,
> I'm just not quite understanding what this fixes, and what the new
> behavior is, sorry.
>

You are not to be blamed for not knowing what the old behavior is
it is undocumented and I have never seen it used in tests.

Old behavior of

$ xfs_io -c -c "pread -v 0 4" -c "pread -v 4 8" foo bar

- print 0..4 from foo
- print 4..8 from foo
- print 0..4 from bar
- print 4..8 from bar

New behavior is:

- print 0..4 from bar (the "current" file)
- print 4..8 from bar

Same behavior as when you issue the same command after running

$ xfs_io foo bar

Amir.
