Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CCC729E31
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DF038F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VKT9ALYUb4ZFaXq9 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:42 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWi-0003x4-Lv
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWY-0001NV-Jq
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 48/48] xfsprogs: Document XFs specific mount options in xfs(5)
Date: Fri,  7 Jun 2013 10:26:11 +1000
Message-Id: <1370564771-4929-49-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Rather than reference mount(8) to see xfs specific mount options,
document them directly in the xfs(5) man page in this package. That
way it is easy to update XFS mount options when the change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 man/man5/xfs.5 |  197 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 194 insertions(+), 3 deletions(-)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 0f490f0..7123008 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -98,9 +98,200 @@ and by-handle (see
 .BR open_by_handle (3))
 interfaces.
 .SH MOUNT OPTIONS
-Refer to the
-.BR mount (8)
-manual entry for descriptions of the individual XFS mount options.
+.TP
+.BI allocsize= size
+Sets the buffered I/O end-of-file preallocation size when
+doing delayed allocation writeout (default size is 64KiB).
+Valid values for this option are page size (typically 4KiB)
+through to 1GiB, inclusive, in power-of-2 increments.
+.TP
+.BR attr2 | noattr2
+The options enable/disable (default is enabled) an "opportunistic"
+improvement to be made in the way inline extended attributes are
+stored on-disk.
+When the new form is used for the first time (by setting or
+removing extended attributes) the on-disk superblock feature
+bit field will be updated to reflect this format being in use.
+.TP
+.B barrier | nobarrier
+Enables/disables the use of block layer write barriers for writes into
+the journal and for data integrity operations.
+This allows for drive level write caching to be enabled, for devices that
+support write barriers.
+The default behaviour is to have barriers enabled.
+.TP
+.BR ikeep | noikeep
+When inode clusters are emptied of inodes, keep them around
+on the disk (ikeep) - this is the traditional XFS behaviour
+and is still the default for now.  Using the noikeep option,
+inode clusters are returned to the free space pool.
+.TP
+.B inode64
+Indicates that XFS is allowed to create inodes at any location
+in the filesystem, including those which will result in inode
+numbers occupying more than 32 bits of significance.  This is
+provided for backwards compatibility, but causes problems for
+backup applications that cannot handle large inode numbers.
+.TP
+.BR largeio | nolargeio
+If
+.B nolargeio
+is specified, the optimal I/O reported in
+st_blksize by
+.BR stat (2)
+will be as small as possible to allow user
+applications to avoid inefficient read/modify/write I/O.
+If
+.B largeio
+is specified, a filesystem that has a
+.B swidth
+specified
+will return the
+.B swidth
+value (in bytes) in st_blksize. If the
+filesystem does not have a
+.B swidth
+specified but does specify
+an
+.B allocsize
+then
+.B allocsize
+(in bytes) will be returned
+instead.
+If neither of these two options are specified, then filesystem
+will behave as if
+.B nolargeio
+was specified.
+.TP
+.BI logbufs= value
+Set the number of in-memory log buffers.  Valid numbers range
+from 2-8 inclusive.
+The default value is 8 buffers for any recent kernel.
+.TP
+.BI logbsize= value
+Set the size of each in-memory log buffer.
+Size may be specified in bytes, or in kilobytes with a "k" suffix.
+Valid sizes for version 1 and version 2 logs are 16384 (16k) and
+32768 (32k).  Valid sizes for version 2 logs also include
+65536 (64k), 131072 (128k) and 262144 (256k).
+The default value for any recent kernel is 32768.
+.TP
+\fBlogdev=\fP\fIdevice\fP and \fBrtdev=\fP\fIdevice\fP
+Use an external log (metadata journal) and/or real-time device.
+An XFS filesystem has up to three parts: a data section, a log section,
+and a real-time section.
+The real-time section is optional, and the log section can be separate
+from the data section or contained within it.
+Refer to
+.BR xfs (5).
+.TP
+.BI  mtpt= mountpoint
+Use with the
+.B dmapi
+option. The value specified here will be
+included in the DMAPI mount event, and should be the path of
+the actual mountpoint that is used.
+.TP
+.B noalign
+Data allocations will not be aligned at stripe unit boundaries.
+.TP
+.B noatime
+Access timestamps are not updated when a file is read.
+.TP
+.B norecovery
+The filesystem will be mounted without running log recovery.
+If the filesystem was not cleanly unmounted, it is likely to
+be inconsistent when mounted in
+.B norecovery
+mode.
+Some files or directories may not be accessible because of this.
+Filesystems mounted
+.B norecovery
+must be mounted read-only or the mount will fail.
+.TP
+.B nouuid
+Don't check for double mounted filesystems using the filesystem uuid.
+This is useful to mount LVM snapshot volumes.
+.TP
+.B osyncisosync
+Make O_SYNC writes implement true O_SYNC.  WITHOUT this option,
+Linux XFS behaves as if an
+.B osyncisdsync
+option is used,
+which will make writes to files opened with the O_SYNC flag set
+behave as if the O_DSYNC flag had been used instead.
+This can result in better performance without compromising
+data safety.
+However if this option is not in effect, timestamp updates from
+O_SYNC writes can be lost if the system crashes.
+If timestamp updates are critical, use the
+.B osyncisosync
+option.
+.TP
+.BR uquota | usrquota | uqnoenforce | quota
+User disk quota accounting enabled, and limits (optionally)
+enforced.  Refer to
+.BR xfs_quota (8)
+for further details.
+.TP
+.BR gquota | grpquota | gqnoenforce
+Group disk quota accounting enabled and limits (optionally)
+enforced. Refer to
+.BR xfs_quota (8)
+for further details.
+.TP
+.BR pquota | prjquota | pqnoenforce
+Project disk quota accounting enabled and limits (optionally)
+enforced. Refer to
+.BR xfs_quota (8)
+for further details.
+.TP
+\fBsunit=\fP\fIvalue\fP and \fBswidth=\fP\fIvalue\fP
+Used to specify the stripe unit and width for a RAID device or a stripe
+volume.
+.I value
+must be specified in 512-byte block units.
+If this option is not specified and the filesystem was made on a stripe
+volume or the stripe width or unit were specified for the RAID device at
+mkfs time, then the mount system call will restore the value from the
+superblock.
+For filesystems that are made directly on RAID devices, these options can be
+used to override the information in the superblock if the underlying disk
+layout changes after the filesystem has been created.
+The
+.B swidth
+option is required if the
+.B sunit
+option has been specified,
+and must be a multiple of the
+.B sunit
+value.
+.TP
+.B swalloc
+Data allocations will be rounded up to stripe width boundaries
+when the current end of file is being extended and the file
+size is larger than the stripe width size.
+.TP
+.B dmapi
+Enable the DMAPI (Data Management API) event callouts.
+Use with the
+.B mtpt
+option.
+.TP
+.BR grpid | bsdgroups " and " nogrpid | sysvgroups
+These options define what group ID a newly created file gets.
+When grpid is set, it takes the group ID of the directory in
+which it is created; otherwise (the default) it takes the fsgid
+of the current process, unless the directory has the setgid bit
+set, in which case it takes the gid from the parent directory,
+and also gets the setgid bit set if it is a directory itself.
+.TP
+.BI ihashsize= value
+Sets the number of hash buckets available for hashing the
+in-memory inodes of the specified mount point.  If a value
+of zero is used, the value selected by the default algorithm
+will be displayed in
+.IR /proc/mounts .
 .SH SEE ALSO
 .BR xfsctl (3),
 .BR mount (8),
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
