Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7775 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751696AbcLFWvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 17:51:52 -0500
Date: Wed, 7 Dec 2016 09:51:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs_io: support -c "open foo" command
Message-ID: <20161206225147.GF4219@dastard>
References: <1481003038-23740-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481003038-23740-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 06, 2016 at 07:43:58AM +0200, Amir Goldstein wrote:
> There is an undocumented and possibly unused feature in xfs_io
> where all commands are executed per file when multiple files
> are provided in the args list.
> 
> This feature creates ambiguity when trying to execute commands
> such as "open" and "file" from command line and result in an
> endless loop in the command loop code, e.g.:
> 
> xfs_io -r -c "open -f bar" -c print foo
> bar: Too many open files
> [000] foo            (foreign,non-sync,non-direct,read-only)
>  001  bar            (foreign,non-sync,non-direct,read-write)
>  002  bar            (foreign,non-sync,non-direct,read-write)
>  003  bar            (foreign,non-sync,non-direct,read-write)
>  004  bar            (foreign,non-sync,non-direct,read-write)
>  005  bar            (foreign,non-sync,non-direct,read-write)
>  006  bar            (foreign,non-sync,non-direct,read-write)
> 
> Also, when running xfs_io -c <cmd> without any file args, xfs_io
> exits without doing anything. This behavior is also undocumented
> and makes very little sense.
> 
> Change the behavior of xfs_io,

No. Changing the behaviour of a tool that is widely used for
scripting is a non-starter. Even if you don't use that
functionality, there are bound to be others that do, and changing
the behaviour will break those uses.

> so commands given with -c <cmd>
> are executed exactly once, regardless of the number of file args.
> This enables writing proper xfs_io scripts in command line, which
> include "open" and "file" commands.

Again, you've defined the solution to meet only your immediate
needs.  The git history will tells us what is "proper", and I'm
pretty sure what I suggested first up (use of CMD_FLAG_GLOBAL) will
be close to the mark....

> Update the man page and usage to reflect the fact that multiple
> as well as zero file args can be given in args list.
> 
> This change does not modify the behavior of xfs_io in the most
> commonly used case of single file argument in command line and
> no "open" and "file" commands in command line.

We have to consider all cases, not just the common case....

So, the git history would tell use what the correct approach will
be. Multiple file support was added to xfs_io in 2004, and the
libxcmd/command.c file originally cam from xfs_io - it was moved
from io/command.c > libxcmd/command.c back in 2005. The main xfs_io
command parsing loop at the time was:

....
	init(argc, argv);

	for (i = 0; !done && i < ncmdline; i++) {
		for (j = 0; !done && j < filecount; j++) {
			file = &filetable[j];
			v = breakline(cmdline[i], &c);
			if (c)
				done = command(c, v);
			free(v);
		}
	}
	if (cmdline) {
		free(cmdline);
		return exitcode;
	}
	while (!done) {
		if ((input = fetchline()) == NULL)
			break;
		v = breakline(input, &c);
		if (c)
			done = command(c, v);
		doneline(input, v);
	}
	return exitcode;
}

So we can clearly see that when run from the command line, the
xfs_io operations were /clearly/ intended to be run on all open files
unless the command signalled it was done (e.g. an error). What's
also clear is that xfs_io would never run commands from the CLI
without a file being specified. This must have been added later,
which I'll come back to....

It's also clearly got the same return characteristics for CLI and
interactive mode - returning non-zero will abort the processing loop
for the command and exit with exitcode.

When added into libxcmd, this loop was modified with the file table
iteration abstracted out into the "args_command" construct. This, for
xfs_io, now sets up the filetable pointer and handles the iteration
across the filetable. For xfs_quota, it handles iteration of the
filesystem table.

At the same time, the "check command" abstraction was also added,
which enable xfs_io to add all the flag checks to determine if
the command could be run. This is where things like whether the
xfs_io command can run with no open files are checked.

The xfs_io args command function now did this:

static int
init_args_command(
       int     index)
{
       if (index >= filecount)
               return 0;
       file = &filetable[index++];
       return index;
}

Which means that if no files are opened on the CLI, it would always
return 0. Hence the new command loop:

		while (!done && (j = args_command(j))) {
			....
				done = command(c, v);
			....
		}

would still not run any command if there was no file specified on
the command line.  This was recognised as being a problem a little
while later e.g. the "help" command required a file to be specified:

http://oss.sgi.com/archives/xfs/2007-07/msg00785.html

And so we grew the CMD_FLAG_GLOBAL which is intended for commands
that don't need open files to be able to run.

This commit changed the way the command loop ran - it moved
the "while (!done && (j = args_command(j))) loop to be an inner
loop rather than the outer loop, and added a separate branch to
execute CMD_FLAG_GLOBAL commands directly.

I think this is the source of the iteration problems. xfs_io already
had command flags to allow commands to be run with no open files
(CMD_NOMAP_OK, CMD_NOFILE_OK) and these are mostly set correctly,
but this CMD_FLAG_GLOBAL introduced a different mechanism for
executing these commands.

What "CMD_FLAG_GLOBAL actually means is "bypass command loop 
args_command checking" rather than the intended "can operate with
no open files", which we already had an xfs_io command flag for but
never got to check because the command never got executed.

IOWs, CMD_FLAG_GLOBAL is intended as the flag to be used for
commands that should not iterate the xfs_io file table and instead
operated on the current file. That's obvious for commands like
"open", but it's less obvious for commands like "pwrite" or "stat"
where filetable iteration may be the desired operation.

So the initial fix for the current problem is to mark all the
"one-shot" commands with CMD_FLAG_GLOBAL so they don't iterate the
file table and behave sanely by default. I'd rename CMD_FLAG_GLOBAL
to something more appropriate as well, and probably rework the main
command loop to get this check out of the main loop and into the
args_command() function where we can do single shot command
control cleanly.

The next fix is to be able to control iteration directly, so if we
want to stat all or just the current file we can. I'd suggest that
we should introduce a "-C <cmd>" option to indicate that the command
should only be run on the current active file. That will allow new
tests that use multiple files to control behaviour appropriately...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
