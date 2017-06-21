Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33722 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbdFUVpV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:45:21 -0400
Subject: Re: [PATCH 11/12] xfs_spaceman: add a man page
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755901707.3625.18353309221066084398.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2033dd8e-da80-28bc-1b56-09780fcab326@sandeen.net>
Date: Wed, 21 Jun 2017 16:45:20 -0500
MIME-Version: 1.0
In-Reply-To: <149755901707.3625.18353309221066084398.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/15/17 3:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a manual page describing xfs_spaceman's behavior.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

With some minor edits:

freesp command:

-.BI "freesp [ \-drs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
+.BI "freesp [ \-drs ] [-a agno]... [ \-b | \-e bsize | \-h bsize | \-m factor ]"

prealloc command (did this in the utility help too):

-Controls speculative preallocation.
+Removes speculative preallocation.

prealloc command -s option:

-Flush all dirty data and metadata to disk.
+Wait for removal to complete.

trim command:

+(One of
+.BR -a ", " -f ", or the "
+.IR offset / length
+pair are required.)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_spaceman.8 |  171 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
>  create mode 100644 man/man8/xfs_spaceman.8
> 
> 
> diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
> new file mode 100644
> index 0000000..f064360
> --- /dev/null
> +++ b/man/man8/xfs_spaceman.8
> @@ -0,0 +1,171 @@
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
> +.BI "freesp [ \-drs ] [-a agno] [ \-b | \-e bsize | \-h bsize | \-m factor ]"
> +With no arguments,
> +.B freesp
> +shows a histogram of all free space extents in the filesystem.
> +The command takes the following options:
> +
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-a agno
> +Collect free space information from this allocation group.
> +This option can be specified multiple times to collect from multiple groups.
> +
> +.TP
> +.B \-b
> +This argument establishes that the histogram bin sizes are successive powers of two.
> +This is the default, and is mutually exclusive with the
> +.BR "-e" ", " "-h" ", and " "-m" " options."
> +
> +.TP
> +.B \-d
> +Print debugging information such as the raw free space extent information.
> +
> +.TP
> +.B \-e bsize
> +Set all histogram bin sizes to a specific value.
> +This option is mutually exclusive with the
> +.BR "-b" ", " "-h" ", and " "-m" " options."
> +
> +.TP
> +.B \-h bsize
> +Create a histogram bin with a lower bound of this value.
> +The upper bound of this bin will be one less than the lower bound of the
> +next highest histogram bin.
> +This option can be given multiple times to control the exact bin sizes.
> +This option is mutually exclusive with the
> +.BR "-b" ", " "-e" ", and " "-m" " options."
> +
> +.TP
> +.B \-m factor
> +Create each histogram bin with a size that is this many times the size
> +of the prvious bin created.
> +This option is mutually exclusive with the
> +.BR "-b" ", " "-e" ", and " "-h" " options."
> +
> +.TP
> +.B \-r
> +Query the realtime device for free space information.
> +
> +.TP
> +.B \-s
> +Display a summary of the free space information found.
> +.PD
> +.RE
> +.TP
> +.BR "help [ " command " ]"
> +Display a brief description of one or all commands.
> +.TP
> +.BI "prealloc [ \-u id ] [ \-g id ] [ -p id ] [ \-m minlen ] [ \-s ]"
> +Controls speculative preallocation.
> +If no
> +.BR "-u" ", " "-g" ", or " "-p"
> +options are given, this command acts on all files.
> +The command takes the following options:
> +
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-u uid
> +Clear all speculative preallocations for files with this user id.
> +This option can be given in combination with the
> +.B "-g" " and " "-p"
> +options.
> +
> +.TP
> +.B \-g gid
> +Clear all speculative preallocations for files with this group id.
> +This option can be given in combination with the
> +.B "-u" " and " "-p"
> +options.
> +
> +.TP
> +.B \-p pid
> +Clear all speculative preallocations for files with this project id.
> +This option can be given in combination with the
> +.B "-u" " and " "-g"
> +options.
> +
> +.TP
> +.B \-m minlen
> +Ignore all files smaller than this size.
> +Units can be supplied for this argument.
> +
> +.TP
> +.B \-s
> +Flush all dirty data and metadata to disk.
> +.PD
> +.RE
> +.TP
> +.B print
> +Display a list of all open files.
> +.TP
> +.B quit
> +Exit
> +.BR xfs_spaceman .
> +.TP
> +.BI "trim ( \-a agno | \-f | " "offset" " " "length" " ) [ -m minlen ]"
> +Instructs the underlying storage device to release all storage that may
> +be backing free space in the filesystem.
> +The command takes the following options:
> +
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-a agno
> +Trim free space extents in the given allocation group.
> +This option is mutually exclusive with the
> +.BR "-f" " option and the "
> +.IR "offset" "/" "length" " options."
> +
> +.TP
> +.B \-f
> +Trim all free space in the filesystem.
> +This option is mutually exclusive with the
> +.BR "-a" " option and the "
> +.IR "offset" "/" "length" " options."
> +
> +.TP
> +.IR "option" ", " "length"
> +Trim all free space within the physical range defined by the
> +.I offset
> +and
> +.I length
> +from this filesystem.
> +Units can be appended to these arguments.
> +This option is mutually exclusive with the
> +.BR "-a" " and " "-f" " options."
> +
> +.TP
> +.B \-m minlen
> +Do not trim free space extents shorter than this length.
> +Units can be appended to this argument.
> +.PD
> +.RE
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
