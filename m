Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753186AbeALAQD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 19:16:03 -0500
Subject: Re: [PATCH 01/27] xfs_scrub: create online filesystem scrub program
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520349393.2027.11445111828418979100.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <beabcf8b-4a09-60c9-ad27-c123ddb545b3@sandeen.net>
Date: Thu, 11 Jan 2018 18:16:02 -0600
MIME-Version: 1.0
In-Reply-To: <151520349393.2027.11445111828418979100.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>

<man page nitpicking>

> diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> new file mode 100644
> index 0000000..95f4fea
> --- /dev/null
> +++ b/man/man8/xfs_scrub.8
> @@ -0,0 +1,117 @@
> +.TH xfs_scrub 8
> +.SH NAME
> +xfs_scrub \- scrub the contents of an XFS filesystem
> +.SH SYNOPSIS
> +.B xfs_scrub
> +[
> +.B \-abemnTvVxy
               ^
> +]
> +.I mount-point

or block device?

> +.br
> +.B xfs_scrub \-V
                  ^

If V is special it probably shouldn't be in the first arg string?

Do you mean to hide the "-d" option?


> +.SH DESCRIPTION
> +.B xfs_scrub
> +attempts to check and repair all metadata in a mounted XFS filesystem.
> +.PP
> +.B xfs_scrub
> +asks the kernel to scrub all metadata objects in the filesystem.
> +Metadata records are scanned for obviously bad values and then
> +cross-referenced against other metadata.
> +The goal is to establish a threasonable confidence about the consistency

"reasonable"

> +of the overall filesystem by examining the consistency of individual
> +metadata records against the other metadata in the filesystem across the
> +entire filesystem.

Redundant, "examining the consistency of individual metadata records against
the other medtadata in the filesystem."  would suffice.

> +Damaged metadata can be rebuilt from other metadata if there is
> +sufficient redundancy (and no other corruption) in the metadata.

Again redundant, maybe just "if there is sufficient redundancy within
other intact metadata?"

> +.PP
> +This utility does not know how to correct all errors.
> +If the tool cannot fix the detected errors, you must unmount the
> +filesystem and run
> +.B xfs_repair
> +to fix the problems.
> +If this tool is not run with either of the
> +.B \-n
> +or
> +.B \-y
> +options, then it will optimize the filesystem when possible,
> +but it will not try to fix errors.

I think the manpage needs to describe what this optimization might
involve, at least at a high level.  Will it fsr all my files? Will
it trim my free space?  Will it compact my directories?  Will it ...?
What exactly am I agreeing to here? :)

> +.SH OPTIONS
> +.TP
> +.BI \-a " errors"
> +Abort if more than this many errors are found on the filesystem.
> +.TP
> +.B \-b
> +Run in background mode.
> +If the option is specified once, only run a single scrubbing thread at a
> +time.
> +If given more than once, an artificial delay of 100us is added to each
> +scrub call to reduce CPU overhead even further.

I wonder, should it take a value instead of -bbbbbbbbb?

> +.TP
> +.B \-e
> +Specifies what happens when errors are detected.
> +If
> +.IR shutdown
> +is given, the filesystem will be taken offline if errors are found.
> +Not all backends can shut down a filesystem.

<user> what's a backend? </user>

> +If
> +.IR continue
> +is given, no action taken if errors are found.
> +This is the default.

<user> so how do I know what errors were found? </user>

> +.TP
> +.BI \-m " file"
> +Search this file for mounted filesystems instead of /etc/mtab.
> +.TP
> +.B \-n
> +Dry run, do not modify anything in the filesystem.
> +This disables all preening and optimization behaviors, and disables
> +calling FITRIM on the free space after a successful run.

what if I only want to disable FITRIM?  (-k?)
Oh, and it runs FITRIM?  Can you mention that more prominently
in the behavior description?  (and should it, given that we
have a tool for that purpose?)

> +.TP
> +.BI \-T
> +Print timing and memory usage information for each phase.
> +.TP
> +.B \-v
> +Enable verbose mode, which prints periodic status updates.
> +.TP
> +.B \-V
> +Prints the version number and exits.
> +.TP
> +.B \-x
> +Scrub all file data too.

colloquial?  maybe s/too/as well/ 

> +The block list will be sorted in disk order for better performance.

Cool, so when I'm done, my filesystem will have better performance if I use -x?
and none of my files will be corrupted!  ;)

The read order is probably an implementation detail that doesn't need to be in
the manpage.  It may be worth changing the description a bit to make it
clearer that the purpose is to determine readability of every file block?
I mean, that should probably be obvious, but ...

> +.B xfs_scrub
> +will issue O_DIRECT reads to the block device directly.
> +If the block device is a SCSI disk, it will issue READ VERIFY commands
> +directly to the disk.

+ These actions will confirm that all file data blocks can be read from storage.

or something?

> +.TP
> +.B \-y
> +Try to repair all filesystem errors.
> +If the errors cannot be fixed online, then the filesystem must be taken
> +offline for repair.
> +.SH EXIT CODE
> +The exit code returned by
> +.B xfs_scrub
> +is the sum of the following conditions:
> +.br
> +\	0\	\-\ No errors
> +.br
> +\	1\	\-\ File system errors left uncorrected
> +.br
> +\	2\	\-\ File system optimizations possible
> +.br
> +\	4\	\-\ Operational error
> +.br
> +\	8\	\-\ Usage or syntax error
> +.br
> +.SH CAVEATS
> +.B xfs_scrub
> +is an immature utility!

Might it damage my filesystem? ;)

> +This program takes advantage of in-kernel scrubbing to verify a given
> +data structure with locks held.
> +The kernel must support the BULKSTAT, FSGEOMETRY, FSCOUNTS, GET_RESBLKS,
> +GETBMAPX, GETFSMAP, INUMBERS, and SCRUB_METADATA ioctls.

Some of those ioctls are ancient and probably don't need to be specified...
Can you do anything at all without SCRUB_METADATA?  If not,
is SCRUB_METADATA sufficient to determine that the kernel has the rest
of what it needs?

> +This can tie up the system for a while.

Maybe that's a statement to go right after "locks held"

> +.PP
> +If errors are found and cannot be repaired, the filesystem must be taken
> +offline and repaired.

"unmounted and repaired" might be more specific?  *shrug*

> +.SH SEE ALSO
> +.BR xfs_repair (8).


