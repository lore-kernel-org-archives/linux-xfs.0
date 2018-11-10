Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49370 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbeKJK2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 05:28:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA0hlbP088237
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:23 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nh3mq9tqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jM1E019198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:22 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jMQr031561
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:22 GMT
Subject: [PATCH 1/6] xfs_io.8: rearrange command listings by section
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 09 Nov 2018 16:45:21 -0800
Message-ID: <154181072098.3727.12783001969841425328.stgit@magnolia>
In-Reply-To: <154181071499.3727.3910572718199592407.stgit@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Most of the commands listed under "OTHER COMMANDS" apply to files or
filesystems.  Create two new sections for that and populate them
appropriately.

Here's what moves:

fsmap: moves from file io commands to filesystem commands
utimes: moves from file io commands to file commands

>From the OTHER COMMANDS section:

lsattr/chattr: moves to file commands
flink: moves to file commands
stat/statx: moves to file commands
lsproj/chproj: moves to file commands
parent: moves to file commands
[gs]et_encpolicy: moves to file io commands
freeze/thaw: move to filesystem commands
inject: move to filesystem commands
resblks: move to filesystem commands
shutdown: move to filesystem commands
statfs: move to filesystem commands
label: move to filesystem commands

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_io.8 |  446 +++++++++++++++++++++++++++--------------------------
 1 file changed, 226 insertions(+), 220 deletions(-)


diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f1099c32..938aa0c2 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -338,108 +338,6 @@ or ends in a hole,
 will print the hole, truncated to the requested range.
 .RE
 .TP
-.BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
-Prints the mapping of disk blocks used by the filesystem hosting the current
-file.  The map lists each extent used by files, allocation group metadata,
-journalling logs, and static filesystem metadata, as well as any
-regions that are unused.
-Each line of the listings takes the following form:
-.PP
-.RS
-.IR extent ": " major ":" minor " [" startblock .. endblock "]: " owner " " startoffset .. endoffset " " length
-.PP
-Static filesystem metadata, allocation group metadata, btrees,
-journalling logs, and free space are marked by replacing the
-.IR startoffset .. endoffset
-with the appropriate marker.
-All blocks, offsets, and lengths are specified in units of 512-byte
-blocks, no matter what the filesystem's block size is.
-The optional
-.I start
-and
-.I end
-arguments can be used to constrain the output to a particular range of
-disk blocks.
-If these two options are specified, exactly one of
-.BR "-d" ", " "-l" ", or " "-r"
-must also be set.
-.RE
-.RS 1.0i
-.PD 0
-.TP
-.BI \-d
-Display only extents from the data device.
-This option only applies for XFS filesystems.
-.TP
-.BI \-l
-Display only extents from the external log device.
-This option only applies to XFS filesystems.
-.TP
-.BI \-r
-Display only extents from the realtime device.
-This option only applies to XFS filesystems.
-.TP
-.BI \-m
-Display results in a machine readable format (CSV).
-This option is not compatible with the
-.B \-v
-flag.
-The columns of the output are: extent number, device major, device minor,
-physical start, physical end, owner, offset start, offset end, length.
-The start, end, and length numbers are provided in units of 512b.
-The owner field is a special string that takes the form:
-
-.RS 1.0i
-.PD 0
-.TP 0.4i
-.I inode_%lld_data
-for inode data.
-.TP
-.I inode_%lld_data_bmbt
-for inode data extent maps.
-.TP
-.I inode_%lld_attr
-for inode extended attribute data.
-.TP
-.I inode_%lld_attr_bmbt
-for inode extended attribute extent maps.
-.TP
-.I special_%u:%u
-for other filesystem metadata.
-.PD
-.RE
-
-.TP
-.BI \-n " num_extents"
-If this option is given,
-.B fsmap
-obtains the extent list of the file in groups of
-.I num_extents
-extents.
-In the absence of
-.BR "-n" ", " "fsmap"
-queries the system for extents in groups of 131,072 records.
-.TP
-.B \-v
-Shows verbose information.
-When this flag is specified, additional AG specific information is
-appended to each line in the following form:
-.IP
-.RS 1.2i
-.IR agno " (" startagblock .. endagblock ") " nblocks " " flags
-.RE
-.IP
-A second
-.B \-v
-option will print out the
-.I flags
-legend.
-This option is not compatible with the
-.B \-m
-flag.
-.RE
-.PD
-.TP
 .BI "extsize [ \-R | \-D ] [ " value " ]"
 Display and/or modify the preferred extent size used when allocating
 space for the currently open file. If the
@@ -782,18 +680,37 @@ bytes of data.
 .RE
 .PD
 .TP
-.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
-The utimes command changes the atime and mtime of the current file.
-sec uses UNIX timestamp notation and is the seconds elapsed since
-1970-01-01 00:00:00 UTC.
-nsec is the nanoseconds since the sec. This value needs to be in
-the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
-Each (sec, nsec) pair constitutes a single timestamp value.
-.TP
 .BI swapext " donor_file "
 Swaps extent forks between files. The current open file is the target. The donor
 file is specified by path. Note that file data is not copied (file content moves
 with the fork(s)).
+.TP
+.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]"
+On filesystems that support encryption, assign an encryption policy to the
+current file.
+.I keydesc
+is a 16-byte hex string which identifies the encryption key to use.
+If not specified, a "default" key descriptor of all 0's will be used.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.BI \-c " mode"
+contents encryption mode (e.g. AES-256-XTS)
+.TP
+.BI \-n " mode"
+filenames encryption mode (e.g. AES-256-CTS)
+.TP
+.BI \-f " flags"
+policy flags (numeric)
+.TP
+.BI \-v " version"
+version of policy structure (numeric)
+.RE
+.PD
+.TP
+.BR get_encpolicy
+On filesystems that support encryption, display the encryption policy of the
+current file.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
@@ -946,29 +863,7 @@ which forces the maximum readahead.
 Dumps a list of pages or ranges of pages that are currently in core,
 for the current memory mapping.
 
-.SH OTHER COMMANDS
-.TP
-.BR "help [ " command " ]"
-Display a brief description of one or all commands.
-.TP
-.B print
-Display a list of all open files and memory mapped regions.
-The current file and current mapping are distinguishable from
-any others.
-.TP
-.B p
-See the
-.B print
-command.
-.TP
-.B quit
-Exit
-.BR xfs_io .
-.TP
-.B q
-See the
-.B quit
-command.
+.SH FILE COMMANDS
 .TP
 .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
 List extended inode flags on the currently open file. If the
@@ -992,50 +887,9 @@ for the full list) is available via the
 .B help
 command.
 .TP
-.B freeze
-Suspend all write I/O requests to the filesystem of the current file.
-Only available in expert mode and requires privileges.
-.TP
-.B thaw
-Undo the effects of a filesystem freeze operation.
-Only available in expert mode and requires privileges.
-.TP
 .BI "flink " path
 Link the currently open file descriptor into the filesystem namespace.
 .TP
-.BI "inject [ " tag " ]"
-Inject errors into a filesystem to observe filesystem behavior at
-specific points under adverse conditions. Without the
-.I tag
-argument, displays the list of error tags available.
-Only available in expert mode and requires privileges.
-.TP
-.BI "resblks [ " blocks " ]"
-Get and/or set count of reserved filesystem blocks using the
-XFS_IOC_GET_RESBLKS or XFS_IOC_SET_RESBLKS system calls.
-Note \-\- this can be useful for exercising out of space behavior.
-Only available in expert mode and requires privileges.
-.TP
-.BR shutdown " [ " \-f " ]"
-Force the filesystem to shut down, preventing any further IO.
-XFS and other filesystems implement this functionality, although implementation
-details may differ slightly.
-Only available in expert mode and requires privileges.
-.PP
-.RS
-By default, the filesystem will not attempt to flush completed transactions to
-disk before shutting down the filesystem.  This simulates a disk failure or
-crash.
-.RE
-.RS 1.0i
-.PD 0
-.TP 0.4i
-.B \-f
-Force the filesystem to flush all completed transactions to disk before shutting
-down, matching XFS behavior when critical corruption is encountered.
-.PD
-.RE
-.TP
 .BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from
 .BR stat (2)
@@ -1076,12 +930,6 @@ Don't sync attributes with the server.
 .PD
 .RE
 .TP
-.B statfs
-Selected statistics from
-.BR statfs (2)
-and the XFS_IOC_FSGEOMETRY
-system call on the filesystem where the current file resides.
-.TP
 .BR chproj " [ " \-R | \-D " ]"
 Modifies the project identifier associated with the current path. The 
 .B \-R
@@ -1122,6 +970,64 @@ verbose output will be printed.
 .RE
 .PD
 .TP
+.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
+The utimes command changes the atime and mtime of the current file.
+sec uses UNIX timestamp notation and is the seconds elapsed since
+1970-01-01 00:00:00 UTC.
+nsec is the nanoseconds since the sec. This value needs to be in
+the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
+Each (sec, nsec) pair constitutes a single timestamp value.
+
+
+.SH FILESYSTEM COMMANDS
+.TP
+.B freeze
+Suspend all write I/O requests to the filesystem of the current file.
+Only available in expert mode and requires privileges.
+.TP
+.B thaw
+Undo the effects of a filesystem freeze operation.
+Only available in expert mode and requires privileges.
+.TP
+.BI "inject [ " tag " ]"
+Inject errors into a filesystem to observe filesystem behavior at
+specific points under adverse conditions. Without the
+.I tag
+argument, displays the list of error tags available.
+Only available in expert mode and requires privileges.
+.TP
+.BI "resblks [ " blocks " ]"
+Get and/or set count of reserved filesystem blocks using the
+XFS_IOC_GET_RESBLKS or XFS_IOC_SET_RESBLKS system calls.
+Note \-\- this can be useful for exercising out of space behavior.
+Only available in expert mode and requires privileges.
+.TP
+.BR shutdown " [ " \-f " ]"
+Force the filesystem to shut down, preventing any further IO.
+XFS and other filesystems implement this functionality, although implementation
+details may differ slightly.
+Only available in expert mode and requires privileges.
+.PP
+.RS
+By default, the filesystem will not attempt to flush completed transactions to
+disk before shutting down the filesystem.  This simulates a disk failure or
+crash.
+.RE
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-f
+Force the filesystem to flush all completed transactions to disk before shutting
+down, matching XFS behavior when critical corruption is encountered.
+.PD
+.RE
+.TP
+.B statfs
+Selected statistics from
+.BR statfs (2)
+and the XFS_IOC_FSGEOMETRY
+system call on the filesystem where the current file resides.
+.TP
 .BI "inode  [ [ -n ] " number " ] [ -v ]"
 The inode command queries physical information about an inode. With
 no arguments, it will return 1 or 0, indicating whether or not any
@@ -1146,33 +1052,6 @@ was specified on the command line, the maximum possible inode number in
 the system will be printed along with its size.
 .PD
 .TP
-.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]"
-On filesystems that support encryption, assign an encryption policy to the
-current file.
-.I keydesc
-is a 16-byte hex string which identifies the encryption key to use.
-If not specified, a "default" key descriptor of all 0's will be used.
-.RS 1.0i
-.PD 0
-.TP 0.4i
-.BI \-c " mode"
-contents encryption mode (e.g. AES-256-XTS)
-.TP
-.BI \-n " mode"
-filenames encryption mode (e.g. AES-256-CTS)
-.TP
-.BI \-f " flags"
-policy flags (numeric)
-.TP
-.BI \-v " version"
-version of policy structure (numeric)
-.RE
-.PD
-.TP
-.BR get_encpolicy
-On filesystems that support encryption, display the encryption policy of the
-current file.
-.TP
 .BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
@@ -1191,6 +1070,146 @@ For AG metadata, one AG number must be specified.
 For file metadata, the repair is applied to the open file unless the
 inode number and generation number are specified.
 .TP
+.BI "label" " " "[ -c | -s " label " ] "
+On filesystems that support online label manipulation, get, set, or clear the
+filesystem label.  With no options, print the current filesystem label.  The
+.B \-c
+option clears the filesystem label by setting it to the null string.  The
+.BI "\-s " label
+option sets the filesystem label to
+.IR label .
+If the label is longer than the filesystem will accept,
+.B xfs_io
+will print an error message.  XFS filesystem labels can be at most 12
+characters long.
+.TP
+.BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
+Prints the mapping of disk blocks used by the filesystem hosting the current
+file.  The map lists each extent used by files, allocation group metadata,
+journalling logs, and static filesystem metadata, as well as any
+regions that are unused.
+Each line of the listings takes the following form:
+.PP
+.RS
+.IR extent ": " major ":" minor " [" startblock .. endblock "]: " owner " " startoffset .. endoffset " " length
+.PP
+Static filesystem metadata, allocation group metadata, btrees,
+journalling logs, and free space are marked by replacing the
+.IR startoffset .. endoffset
+with the appropriate marker.
+All blocks, offsets, and lengths are specified in units of 512-byte
+blocks, no matter what the filesystem's block size is.
+The optional
+.I start
+and
+.I end
+arguments can be used to constrain the output to a particular range of
+disk blocks.
+If these two options are specified, exactly one of
+.BR "-d" ", " "-l" ", or " "-r"
+must also be set.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-d
+Display only extents from the data device.
+This option only applies for XFS filesystems.
+.TP
+.BI \-l
+Display only extents from the external log device.
+This option only applies to XFS filesystems.
+.TP
+.BI \-r
+Display only extents from the realtime device.
+This option only applies to XFS filesystems.
+.TP
+.BI \-m
+Display results in a machine readable format (CSV).
+This option is not compatible with the
+.B \-v
+flag.
+The columns of the output are: extent number, device major, device minor,
+physical start, physical end, owner, offset start, offset end, length.
+The start, end, and length numbers are provided in units of 512b.
+The owner field is a special string that takes the form:
+
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.I inode_%lld_data
+for inode data.
+.TP
+.I inode_%lld_data_bmbt
+for inode data extent maps.
+.TP
+.I inode_%lld_attr
+for inode extended attribute data.
+.TP
+.I inode_%lld_attr_bmbt
+for inode extended attribute extent maps.
+.TP
+.I special_%u:%u
+for other filesystem metadata.
+.PD
+.RE
+
+.TP
+.BI \-n " num_extents"
+If this option is given,
+.B fsmap
+obtains the extent list of the file in groups of
+.I num_extents
+extents.
+In the absence of
+.BR "-n" ", " "fsmap"
+queries the system for extents in groups of 131,072 records.
+.TP
+.B \-v
+Shows verbose information.
+When this flag is specified, additional AG specific information is
+appended to each line in the following form:
+.IP
+.RS 1.2i
+.IR agno " (" startagblock .. endagblock ") " nblocks " " flags
+.RE
+.IP
+A second
+.B \-v
+option will print out the
+.I flags
+legend.
+This option is not compatible with the
+.B \-m
+flag.
+.RE
+.PD
+
+
+.SH OTHER COMMANDS
+.TP
+.BR "help [ " command " ]"
+Display a brief description of one or all commands.
+.TP
+.B print
+Display a list of all open files and memory mapped regions.
+The current file and current mapping are distinguishable from
+any others.
+.TP
+.B p
+See the
+.B print
+command.
+.TP
+.B quit
+Exit
+.BR xfs_io .
+.TP
+.B q
+See the
+.B quit
+command.
+.TP
 .BI "log_writes \-d " device " \-m "  mark
 Create a mark named
 .I mark
@@ -1210,19 +1229,6 @@ See the
 .B log_writes
 command.
 .TP
-.BI "label" " " "[ -c | -s " label " ] "
-On filesystems that support online label manipulation, get, set, or clear the
-filesystem label.  With no options, print the current filesystem label.  The
-.B \-c
-option clears the filesystem label by setting it to the null string.  The
-.BI "\-s " label
-option sets the filesystem label to
-.IR label .
-If the label is longer than the filesystem will accept,
-.B xfs_io
-will print an error message.  XFS filesystem labels can be at most 12
-characters long.
-.TP
 .B crc32cselftest
 Test the internal crc32c implementation to make sure that it computes results
 correctly.
