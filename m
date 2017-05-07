Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50418 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdEGVh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 17:37:29 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v47FvF1O009245
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 7 May 2017 15:57:16 GMT
Subject: [PATCH 8/9] xfs_spaceman: add a man page
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 May 2017 08:57:06 -0700
Message-ID: <149417262663.24656.8692128796429145917.stgit@birch.djwong.org>
In-Reply-To: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a manual page describing xfs_spaceman's behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_spaceman.8 |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 man/man8/xfs_spaceman.8


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
new file mode 100644
index 0000000..c1d19c0
--- /dev/null
+++ b/man/man8/xfs_spaceman.8
@@ -0,0 +1,102 @@
+.TH xfs_spaceman 8
+.SH NAME
+xfs_spaceman \- show free space information about an XFS filesystem
+.SH SYNOPSIS
+.B xfs_spaceman
+[
+.B \-c
+.I cmd
+]
+.I file
+.br
+.B xfs_spaceman \-V
+.SH DESCRIPTION
+.B xfs_spaceman
+reports and controls free space usage in an XFS filesystem.
+.SH OPTIONS
+.TP 1.0i
+.BI \-c " cmd"
+.B xfs_spaceman
+commands may be run interactively (the default) or as arguments on
+the command line. Multiple
+.B \-c
+arguments may be given. The commands are run in the sequence given,
+then the program exits.
+
+.SH COMMANDS
+.TP
+.BI "freesp [ \-sr ] [ \-b | \-e bsize | \-h h1 [ \-m bmult ]] [-a agno]"
+With no arguments,
+.B freesp
+shows a histogram of all free space extents in the filesystem.
+The
+.B -b
+argument establishes that the histogram bins are successive powers of two.
+This is the default.
+The
+.BR -h " and " -m
+options can be used to specify a custom histogram bin size as well as a
+multiplication factor for subsequent bin sizes.
+The
+.BR -e
+option fixes the histogram size to a particular value.
+The
+.BR -a " and " -r
+options constrain the free space information report to a particular AG
+or the realtime device, respectively.  The
+.B -a
+option may be specified multiple times.
+A summary of free space information will be printed if the
+.B -s
+option is given.
+.TP
+.BR "help [ " command " ]"
+Display a brief description of one or all commands.
+.TP
+.BI "prealloc [ \-ugp id ] [ \-m minlen ] [ \-s ]"
+Controls speculative preallocation.  The
+.BR -u ","
+.BR -g ","
+and
+.B -p
+options will clear all speculative preallocations for a given user,
+group, or project ID, respectively.
+The
+.B -m
+option causes the operation to ignore any file with a size smaller than
+.BR minlen "."
+The
+.B -s
+option will flush all dirty data and metadata to disk.
+.TP
+.B print
+Display a list of all open files.
+.TP
+.B quit
+Exit
+.BR xfs_spaceman .
+.TP
+.BI "trim [ \-f ] [ \-a agno ] [ \-m minlen ] [" " offset length " ]
+Instructs the underlying storage device to release all storage that may
+be backing free space in the filesystem.
+The
+.B -f
+option trims all free space in the entire filesystem.
+The
+.B -a
+option trims only the free space in a given AG.
+The
+.B -m
+option only trims free space extents that are longer than
+.IR minlen "."
+The
+.IR offset " and " length
+arguments trim all free space between
+.I offset
+and
+.IR "offset+length" "."
+The
+.BR -a " and " -f
+options are mutually exclusive with each other as well as with the
+.IR offset " and " length
+arguments.

