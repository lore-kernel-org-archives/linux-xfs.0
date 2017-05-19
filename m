Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34096 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdESI3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 04:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <20170519002032.GA21202@birch.djwong.org>
References: <20170519002032.GA21202@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 May 2017 11:29:04 +0300
Message-ID: <CAOQ4uxhbck8g0o1mSrY7wGvvYtqGpiJjWG8vHFN8Pc5pWc0X+A@mail.gmail.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>

On Fri, May 19, 2017 at 3:20 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:

>
> Therefore, add a reboot hook to freeze all filesystems (which in general
> will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
> This is an unfortunate and insufficient workaround for multiple layers
> of inadequate external software, but at least it will reduce boot time
> surprises for the "OS updater failed to disengage the filesystem before
> rebooting" case.
>

Darrick,

Did you consider how many support calls this will generate for a stuck
reboot command?

I can think of at least one situation where this is guarantied to hang.
See this patch for the details:
https://patchwork.kernel.org/patch/6266791/

The referenced patch was applied to Android kernel to prevent
system crash on emergency remount-ro via sysrq trigger.

I don't know if it was even seriously considered by Al, because
I got no comment, but I do realize that the change of behavior
could generate support calls, so it's scary to make that change
in mainline.

I know it's not going to work around broken system software update,
but how about providing sysrq trigger for emergency_freeze_all()?
like emergency_remount(), but stronger.
And this time, iterate supers in reverse order like I suggested to
avoid loop mounted fs freeze dependencies.

There is one little tiny problem though. Eric used up the last sysrq trigger
key for emergency_thaw_all(). Do you see the irony in that? ;)

I am wondering how many people know about or use the emergency
thaw trigger, but one dodgy option is to use the 't' trigger to toggle
thaw_all/freeze_all.

Another perhaps slightly less dodgy option is to trigger freeze_all
on a sequence of sysrq "emergency" triggers where it makes sense
and is least likely to change any existing behavior, for example:

echo u > /proc/sysrq-trigger

# Remember if do_emergency_remount() completed with failures

echo u > /proc/sysrq-trigger

# Escalate to emergency freeze

OR

echo u > /proc/sysrq-trigger

# Remember if do_emergency_remount() completed with failures

echo s > /proc/sysrq-trigger

# Sync *after* remount r/o? That must mean emergency freeze

I bet that system software that is already aware of and is issuing
emergency remount r/o trigger prior to reboot, won't see any harm
in adding an extra u/s trigger for good luck.

Do you know if the gnarly system software in question is issuing
emergency remount r/o prior to reboot?

Amir.
