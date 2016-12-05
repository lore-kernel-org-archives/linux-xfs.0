Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:36227 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbcLEL2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 06:28:00 -0500
MIME-Version: 1.0
In-Reply-To: <20161205110257.GC4326@dastard>
References: <1480921485-14888-1-git-send-email-amir73il@gmail.com> <20161205110257.GC4326@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Dec 2016 13:27:57 +0200
Message-ID: <CAOQ4uxg80mjF7KcLbfhdCnDQx8p50MABvh=fpSZaucKZPy9Chw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: support -c <cmd> without <file> args
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Dec 5, 2016 at 1:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 05, 2016 at 09:04:45AM +0200, Amir Goldstein wrote:
>> There is an undocumented and possibly unused feature in xfs_io
>> where all commands are executed per file given in the file args list.
>>
>> This feature creates ambiguity when trying to execute commands
>> such as "open" and "file" from command line.
>>
>> When running xfs_io -c <cmd> without any file args, xfs_io exits
>> without doing anything. This behavior is undocumented and does not
>> make much sense either.
>>
>> Change the behavior in the case where no file args are given in
>> command line to execute every command exactly once, exactly as if
>> the commands where executed from an interactive shell.
>>
>> This enables writing proper xfs_io scripts in command line, which
>> include "open" and "file" commands.
>
> NACK.
>
> This does not fix any of the underlying problems. It just adds
> another WTF case to CLI processing as two things that should be
> equivlent now behave differently. i.e.
>
> $ xfs_io -c "open foo" -c "open bar" -c file
>

You meant:
$ xfs_io -c "open foo" -c "open bar"

> and
>
> $ xfs_io -c "open bar" -c file foo
>
> will have different behaviour, even though the man page says they
> should be equivalent and do exactly the same thing.
>
> Fix the underlying problems once and for all: do not hack bandaids
> into the code that only hides the symptom for your specific use
> case.
>

Dave,

I would be glad to fix the code, but you did not answer my question.

The "execute all commands per file" behavior is not documented,
does not appear to have any known users and makes every attempt
to parse "file" commands ambiguous.

Can we, in your option, do away with this behavior?

If the answer is yes, then the patch is even simpler then these 16 lines.
Just replace the old init_args_command() with the new
do_once_args_command().

Would you like me to re-submit the patch with this change?

Amir.
