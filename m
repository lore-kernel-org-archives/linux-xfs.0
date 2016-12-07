Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35244 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbcLGDt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 22:49:58 -0500
MIME-Version: 1.0
In-Reply-To: <20161206225147.GF4219@dastard>
References: <1481003038-23740-1-git-send-email-amir73il@gmail.com> <20161206225147.GF4219@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Dec 2016 05:49:55 +0200
Message-ID: <CAOQ4uxh=fGTObQ=mix1ZbP7DbJ287WKfNNi8ePzSMUyb1egS9A@mail.gmail.com>
Subject: Re: [PATCH v4] xfs_io: support -c "open foo" command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Dec 7, 2016 at 12:51 AM, Dave Chinner <david@fromorbit.com> wrote:
...
> Again, you've defined the solution to meet only your immediate
> needs.  The git history will tells us what is "proper", and I'm
> pretty sure what I suggested first up (use of CMD_FLAG_GLOBAL) will
> be close to the mark....
>

True, I've defined the solution to meet my needs, though I believe my
needs are not crazy and serve a greater good.
The reason I did not go for the "proper" solution is because I did not
understand how your suggestion aims to solve the problem defined
by my test. And by solve I don't mean just avoid the endless loop.

> So the initial fix for the current problem is to mark all the
> "one-shot" commands with CMD_FLAG_GLOBAL so they don't iterate the
> file table and behave sanely by default. I'd rename CMD_FLAG_GLOBAL
> to something more appropriate as well,

CMD_FLAG_ONESHOT?

> and probably rework the main
> command loop to get this check out of the main loop and into the
> args_command() function where we can do single shot command
> control cleanly.
>


And I would gladly follow your suggestion to fix endless loop issue,
but first I would like to understood where this is going to end up in terms
of "expected behavior" (see below).

> The next fix is to be able to control iteration directly, so if we
> want to stat all or just the current file we can. I'd suggest that
> we should introduce a "-C <cmd>" option to indicate that the command
> should only be run on the current active file. That will allow new
> tests that use multiple files to control behaviour appropriately...
>

So that is what I was missing in your first reply.
I realized that a new semantic must be added to be able to both
keep existing behavior and enable the desired functionality.

But I am not sure that -C <cmd> does the job.
See the example below from test overlay/016.
It's a perfectly valid use case that cannot be described with
existing semantics.

#
# case #1:
# open file for read (rofd)
# open file for write (rwfd)
# write to rwfd
# read from rofd
#
$XFS_IO_PROG \
        -c "open -r foo" \
        -c "open foo" \
        -c "pwrite -S 0x61 0 16" \
        -c "file 0" \
        -c "pread -v 0 16" \

With the suggested -C <cmd> semantics,
it would look something like this:
$XFS_IO_PROG \
        -c "open -r foo" \
        -c "open foo" \
        -C "pwrite -S 0x61 0 16" \
        -c "file 0" \
        -C "pread -v 0 16" \


This could work out if -C meant to mark that cmd CMD_FLAG_ONESHOT
and run it only once. It suffice for the use case of writing a script, but
not sure if that is what you meant.

I assert that any usage containing multiple files and -C commands is
going to be confusing to read, but if that is the price we have to pay
for not getting the semantics clear from the start, so be it.

I am hoping you are able to clarify that we are on the same page,
so I can go on with implementation.

Thanks,
Amir.
