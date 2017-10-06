Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35185 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdJFM3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 08:29:02 -0400
Received: by mail-qt0-f195.google.com with SMTP id p15so4630470qtp.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2017 05:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171001224904.GG3666@dastard>
References: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
 <20171001224904.GG3666@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Oct 2017 15:29:01 +0300
Message-ID: <CAOQ4uxgqjhnn8FOfkZAruigQcewNFewhGZ_jnj24RG4mNu5MZQ@mail.gmail.com>
Subject: Re: XFS AIL lockup
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 2, 2017 at 1:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 01, 2017 at 03:10:03PM -0700, Sargun Dhillon wrote:
>> I'm running into an issue where xfs aild is locking up. This is on
>> kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G of
>> RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
>> quotas in use. It's the only XFS filesystem on the host. The root
>> partition is running EXT4, and isn't involved in this.
>>
>> There are containers that use overlayfs atop this filesystem. It looks
>> like one of the processes (10090, or 11504) has gotten into a state
>> where it's holding a lock on a xfs_buf, and they're trying to lock
>> xfs_buf's which are currently on the xfs ail list.
>>
...
> Ok, this is a RENAME_WHITEOUT case, and that points to the issue.
> The whiteout inode is allocated as a temporary inode, which means
> it remains on the unlinked list so that if we crash part way through
> the update log recovery will free it again.
>
> Once all the dirent updates and other rename work is done, we remove
> the whiteout inode from the unlinked list, and that requires
> grabbing the AGI lock. That's what we are stuck on here.
>
...
>
> Because this is the deadlock - we're trying to lock the AGF with an
> AGI already locked. That means the above RENAME_WHITEOUT has either
> allocated or freed extents in manipulating the dirents during
> rename, and so holds an AGF locked. It's a classic ABBA deadlock.
>
> That's the problem, not sure what the solution is yet - there's no
> obvious or simple way around this RENAME_WHITEOUT behaviour (which
> only affects overlay, fwiw). I'll have a think about it.
>

Dave,

Could you explain why the RENAME_WHITEOUT case is different locking
order wise from linking an O_TEMPFILE?

Is it because xfs_iunlink_remove() is called before xfs_dir_createname()
in xfs_link()?

Also, in xfs_rename(), before removing whiteout inode from unlinked list,
the comment says: "If we fail here after bumping the link
         * count, we're shutting down the filesystem so we'll never see the
         * intermediate state on disk.",
but I am not actually seeing where that shutdown takes place, or maybe
I don't know what to look for.

Thanks,
Amir.
