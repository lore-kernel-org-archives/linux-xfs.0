Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38001 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753020AbcLGOVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 09:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
References: <20161207034724.1613-1-david@fromorbit.com> <20161207034724.1613-7-david@fromorbit.com>
 <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Dec 2016 16:21:31 +0200
Message-ID: <CAOQ4uxhrtaHauNJypezpFAT0VCN61oZLFKtxuBLw32jn7FOSFw@mail.gmail.com>
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Dec 7, 2016 at 6:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Dec 7, 2016 at 5:47 AM, Dave Chinner <david@fromorbit.com> wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>
> Thank you for fixing this!
> See some typo fixes below.
> I will test the fix later today.
>

Short of one compilation warning I commented on,
I tested these changes and found no regression with -g quick run
I also verified that my test can be converted to use the one shot commands,
e.g.:

$XFS_IO_PROG -r foo \
       -C "open foo" \
       -C "pwrite -S 0x61 0 16" \
       -C "file 0" \
       -C "pread -v 0 16" \
| _filter_xfs_io

$XFS_IO_PROG -r bar \
       -C "mmap -r 0 16" \
       -C "open bar" \
       -C "pwrite -S 0x61 0 16" \
       -C "mread -v 0 16" \
| _filter_xfs_io

Notice that I used explicit -C for all commands including the implicit
one shot commands.

1. Do you think that xfs_io should error on -c "open foo"  to force
explicit -C "open foo"?
    it can't be breaking any existing users, because -c "open foo" is
already very broken.
2. You marked mmap ONE_SHOT, but not all the m* commands.
   Stands to reason that they should all be marked ONE_SHOT. because iterating
   the file table has nothing to do with the m* commands. no?

About the fix to overlay/016.
How would you prefer to address the conditional availability of xfs_io -C?

1. new helper _require_xfs_io_one_shot_command
2. _require_xfs_io_command "open" (which internally checks for xfs_io -C "open")
3. third option?

Cheers,
Amir.
