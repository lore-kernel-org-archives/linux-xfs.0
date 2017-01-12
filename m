Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34192 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750700AbdALFOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 00:14:10 -0500
MIME-Version: 1.0
In-Reply-To: <20161207034724.1613-1-david@fromorbit.com>
References: <20161207034724.1613-1-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Jan 2017 07:14:09 +0200
Message-ID: <CAOQ4uxivcaKy6X3i41Tjh25Uy_UpnvXgJUKY8fpZ3r5REm6BPw@mail.gmail.com>
Subject: Re: [PATCH 0/6] xfs_io: fix up command iteration
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>

On Wed, Dec 7, 2016 at 5:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> Here are teh changes I've put together to address the command
> iteration problems that xfs_io is demonstrating. I described the
> history that lead us to the current problems here:
>
> https://www.spinics.net/lists/fstests/msg04572.html
>
> This series cleans up the libxcmd command code and fixes the xfs_io
> problems without completely removing the existing iteration
> behaviour.
>
> The first three patches address the "args_command" abstraction,
> renaming it to a "command iterator" abstraction and clean up the
> command loop implementation to make it easier to follow. It is now
> clear that the the command loop has an external command iterator
> control function, and it has a clean and clear mechanism for the
> external commands to prevent iteration from occurring
> (CMD_FLAG_ONESHOT).
>
> The fourth patch cleans up a recent change made to the xfs_quota
> interface to support foreign filesystems - it still needs to be abel
> to run the help and quit commands regardless of other state. The
> same requirement exists for xfs_io, it just implemented the command
> check that allowed them to be run differently. This patch
> centralises that by marking libxcmd functions as "library" functions
> and skips the application provided command checking altogether.
> Hence the apps no longer need to handle these cases at all.
>
> The fifth patch makes all the xfs_io commands that shouldn't iterate
> the file table one-shot only commands. This avoids all the nasty
> problems with commands like open that end up completely filling
> the open file table with thousands of filedescriptors pointing to
> the same file. THis makes those commands usable and predictable.
>
> Finally, the last patch adds CLI support for running xfs_io commands
> as one-shot commands rather than iterating commands. This is useful
> for being able to set up multiple files and operate on them as a
> whole or individually as necessary. This patch also documents in the
> man page that some commands may iterate all open files and that the
> new "-C" command option can be used to avoid problems arising from
> this historical behaviour.
>
> -Dave.
>

Eric,

I wanted to make sure that this work by Dave is on your radar for next.
Please note that most of the patches got Reviewed-by Christoph on v1,
but Dave did not add the tag on v2 posting.

Thanks,
Amir.
