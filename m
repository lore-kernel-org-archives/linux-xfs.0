Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42350 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbdFNQGq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 12:06:46 -0400
Subject: Re: [PATCH 09/10] xfs_spaceman: add a man page
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643312994.15899.11143097512362345347.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <996ddf19-1bf9-44c8-f41d-93ac45c354e3@sandeen.net>
Date: Wed, 14 Jun 2017 11:06:44 -0500
MIME-Version: 1.0
In-Reply-To: <149643312994.15899.11143097512362345347.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/2/17 2:52 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a manual page describing xfs_spaceman's behavior.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/xfs_spaceman.8 |  102 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
>  create mode 100644 man/man8/xfs_spaceman.8
> 
> 
> diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
> new file mode 100644
> index 0000000..c1d19c0
> --- /dev/null
> +++ b/man/man8/xfs_spaceman.8
> @@ -0,0 +1,102 @@
> +.TH xfs_spaceman 8
> +.SH NAME
> +xfs_spaceman \- show free space information about an XFS filesystem
> +.SH SYNOPSIS
> +.B xfs_spaceman
> +[
> +.B \-c
> +.I cmd
> +]
> +.I file
> +.br
> +.B xfs_spaceman \-V
> +.SH DESCRIPTION
> +.B xfs_spaceman
> +reports and controls free space usage in an XFS filesystem.
> +.SH OPTIONS
> +.TP 1.0i
> +.BI \-c " cmd"
> +.B xfs_spaceman
> +commands may be run interactively (the default) or as arguments on
> +the command line. Multiple
> +.B \-c
> +arguments may be given. The commands are run in the sequence given,
> +then the program exits.
> +
> +.SH COMMANDS
> +.TP
> +.BI "freesp [ \-sr ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"

Hmm this differs from program help:

freesp [-bdgsr] [-a agno] [-e bsize] [-h h1]... [-m bmult] 

are -b, -e, and -h mutually exclusive or not?

xfs_spaceman> freesp -b
   from      to extents  blocks    pct
      2       3       1       3   0.00
  32768   65536       4  259537 100.00
xfs_spaceman> freesp -e 4096
   from      to extents  blocks    pct
      1    4096       1       3   0.00
  61441   65536       4  259537 100.00
xfs_spaceman> freesp -e 4096 -b
xfs_spaceman> 

Also, where are -g and -d ?


[-a agno]...

(multiple allowed)

> +With no arguments,
> +.B freesp
> +shows a histogram of all free space extents in the filesystem.
> +The
> +.B -b
> +argument establishes that the histogram bins are successive powers of two.
> +This is the default.
> +The
> +.BR -h " and " -m
> +options can be used to specify a custom histogram bin size as well as a
> +multiplication factor for subsequent bin sizes.
> +The
> +.BR -e
> +option fixes the histogram size to a particular value.
> +The
> +.BR -a " and " -r
> +options constrain the free space information report to a particular AG
> +or the realtime device, respectively.  The
> +.B -a
> +option may be specified multiple times.
> +A summary of free space information will be printed if the
> +.B -s
> +option is given.
> +.TP
> +.BR "help [ " command " ]"
> +Display a brief description of one or all commands.
> +.TP
> +.BI "prealloc [ \-ugp id ] [ \-m minlen ] [ \-s ]"
> +Controls speculative preallocation.  The
> +.BR -u ","
> +.BR -g ","
> +and
> +.B -p
> +options will clear all speculative preallocations for a given user,
> +group, or project ID, respectively.
> +The
> +.B -m
> +option causes the operation to ignore any file with a size smaller than
> +.BR minlen "."
> +The
> +.B -s
> +option will flush all dirty data and metadata to disk.
> +.TP
> +.B print
> +Display a list of all open files.
> +.TP
> +.B quit
> +Exit
> +.BR xfs_spaceman .
> +.TP
> +.BI "trim [ \-f ] [ \-a agno ] [ \-m minlen ] [" " offset length " ]

Hm, this looks like -f / -a / offset/length are all optional, and not
mutually exclusive.

If this were in a SYNOPSIS section, it'd require 3 synopses I think.

Perhaps here it should be:

trim -f [ -m minlen ] [ offset length ]
trim -a agno [ -m minlen ] [ offset length ]
trim offset length [ -m minlen ]

as 3 separate invocation methods?

> +Instructs the underlying storage device to release all storage that may
> +be backing free space in the filesystem.
> +The
> +.B -f
> +option trims all free space in the entire filesystem.
> +The
> +.B -a
> +option trims only the free space in a given AG.
> +The
> +.B -m
> +option only trims free space extents that are longer than
> +.IR minlen "."

units?  (suffixes?)

> +The
> +.IR offset " and " length
> +arguments trim all free space between
> +.I offset
> +and
> +.IR "offset+length" "."

Units?

> +The
> +.BR -a " and " -f
> +options are mutually exclusive with each other as well as with the
> +.IR offset " and " length
> +arguments.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
