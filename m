Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1768B7F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 15:03:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDEF38F8040
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 13:02:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T8Ue0hriNbDPT6Yg for
	<xfs@oss.sgi.com>; Wed, 11 Jun 2014 13:02:54 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5BK2s9t014992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 16:02:54 -0400
Message-ID: <5398B5ED.6030703@redhat.com>
Date: Wed, 11 Jun 2014 15:02:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfsprogs: add mount options to xfs.5 manpage
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, Karel Zak <kzak@redhat.com>

This is a straight cut and paste from the util-linux
mount manpage to xfs.5.

It's pretty much impossible for util-linux to keep up
with every filesystem out there, and Karel has more than
once expressed a wish that mount options move into fs-specific
manpages.

So, here we go.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 0f490f0..1729e38 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -1,6 +1,6 @@
 .TH xfs 5
 .SH NAME
-xfs \- layout of the XFS filesystem
+xfs \- layout and mount options for the XFS filesystem
 .SH DESCRIPTION
 An XFS filesystem can reside on a regular disk partition or on a
 logical volume.
@@ -98,9 +98,205 @@ and by-handle (see
 .BR open_by_handle (3))
 interfaces.
 .SH MOUNT OPTIONS
-Refer to the
+The following XFS-specific mount options may be used when mounting
+an XFS filesystem. Other generic options may be used as well; refer to the
 .BR mount (8)
-manual entry for descriptions of the individual XFS mount options.
+manual page for more details.
+.TP
+.B allocsize=size
+Sets the buffered I/O end-of-file preallocation size when
+doing delayed allocation writeout. Valid values for this
+option are page size (typically 4KiB) through to 1GiB,
+inclusive, in power-of-2 increments.
+.sp
+The default behavior is for dynamic end-of-file
+preallocation size, which uses a set of heuristics to
+optimise the preallocation size based on the current
+allocation patterns within the file and the access patterns
+to the file. Specifying a fixed allocsize value turns off
+the dynamic behavior.
+.TP
+.BR attr2 | noattr2
+The options enable/disable an "opportunistic" improvement to
+be made in the way inline extended attributes are stored
+on-disk.  When the new form is used for the first time when
+attr2 is selected (either when setting or removing extended
+attributes) the on-disk superblock feature bit field will be
+updated to reflect this format being in use.
+.sp
+The default behavior is determined by the on-disk feature
+bit indicating that attr2 behavior is active. If either
+mount option it set, then that becomes the new default used
+by the filesystem.
+.sp
+CRC enabled filesystems always use the attr2 format, and so
+will reject the noattr2 mount option if it is set.
+.TP
+.BR barrier | nobarrier
+Enables/disables the use of block layer write barriers for
+writes into the journal and for data integrity operations.
+This allows for drive level write caching to be enabled, for
+devices that support write barriers.
+.TP
+.BR discard | nodiscard
+Enable/disable the issuing of commands to let the block
+device reclaim space freed by the filesystem.  This is
+useful for SSD devices, thinly provisioned LUNs and virtual
+machine images, but may have a performance impact.
+.sp
+Note: It is currently recommended that you use the fstrim
+application to discard unused blocks rather than the discard
+mount option because the performance impact of this option
+is quite severe.
+.TP
+.BR grpid | bsdgroups | nogrpid | sysvgroups
+These options define what group ID a newly created file
+gets.  When grpid is set, it takes the group ID of the
+directory in which it is created; otherwise it takes the
+fsgid of the current process, unless the directory has the
+setgid bit set, in which case it takes the gid from the
+parent directory, and also gets the setgid bit set if it is
+a directory itself.
+.TP
+.B filestreams
+Make the data allocator use the filestreams allocation mode
+across the entire filesystem rather than just on directories
+configured to use it.
+.TP
+.BR ikeep | noikeep
+When ikeep is specified, XFS does not delete empty inode
+clusters and keeps them around on disk.  When noikeep is
+specified, empty inode clusters are returned to the free
+space pool.
+.TP
+.BR inode32 | inode64
+When inode32 is specified, it indicates that XFS limits
+inode creation to locations which will not result in inode
+numbers with more than 32 bits of significance.
+.sp
+When inode64 is specified, it indicates that XFS is allowed
+to create inodes at any location in the filesystem,
+including those which will result in inode numbers occupying
+more than 32 bits of significance.
+.sp
+inode32 is provided for backwards compatibility with older
+systems and applications, since 64 bits inode numbers might
+cause problems for some applications that cannot handle
+large inode numbers.  If applications are in use which do
+not handle inode numbers bigger than 32 bits, the inode32
+option should be specified.
+.TP
+.BR  largeio | nolargeio
+If "nolargeio" is specified, the optimal I/O reported in
+st_blksize by stat(2) will be as small as possible to allow
+user applications to avoid inefficient read/modify/write
+I/O.  This is typically the page size of the machine, as
+this is the granularity of the page cache.
+.sp
+If "largeio" specified, a filesystem that was created with a
+"swidth" specified will return the "swidth" value (in bytes)
+in st_blksize. If the filesystem does not have a "swidth"
+specified but does specify an "allocsize" then "allocsize"
+(in bytes) will be returned instead. Otherwise the behavior
+is the same as if "nolargeio" was specified.
+.TP
+.B logbufs=value
+Set the number of in-memory log buffers.  Valid numbers
+range from 2\(en8 inclusive.
+.sp
+The default value is 8 buffers.
+.sp
+If the memory cost of 8 log buffers is too high on small
+systems, then it may be reduced at some cost to performance
+on metadata intensive workloads. The logbsize option below
+controls the size of each buffer and so is also relevant to
+this case.
+.TP
+.B logbsize=value
+Set the size of each in-memory log buffer.  The size may be
+specified in bytes, or in kibibytes (KiB) with a "k" suffix.
+Valid sizes for version 1 and version 2 logs are 16384 (value=16k)
+and 32768 (value=32k).  Valid sizes for version 2 logs also
+include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k). The
+logbsize must be an integer multiple of the log
+stripe unit configured at mkfs time.
+.sp
+The default value for version 1 logs is 32768, while the
+default value for version 2 logs is MAX(32768, log_sunit).
+.TP
+.BR logdev=device and rtdev=device
+Use an external log (metadata journal) and/or real-time device.
+An XFS filesystem has up to three parts: a data section, a log
+section, and a real-time section.  The real-time section is
+optional, and the log section can be separate from the data
+section or contained within it.
+.TP
+.B noalign
+Data allocations will not be aligned at stripe unit
+boundaries. This is only relevant to filesystems created
+with non-zero data alignment parameters (sunit, swidth) by
+mkfs.
+.TP
+.B norecovery
+The filesystem will be mounted without running log recovery.
+If the filesystem was not cleanly unmounted, it is likely to
+be inconsistent when mounted in "norecovery" mode.
+Some files or directories may not be accessible because of this.
+Filesystems mounted "norecovery" must be mounted read-only or
+the mount will fail.
+.TP
+.B nouuid
+Don't check for double mounted file systems using the file
+system uuid.  This is useful to mount LVM snapshot volumes,
+and often used in combination with "norecovery" for mounting
+read-only snapshots.
+.TP
+.B noquota
+Forcibly turns off all quota accounting and enforcement
+within the filesystem.
+.TP
+.B uquota/usrquota/uqnoenforce/quota
+User disk quota accounting enabled, and limits (optionally)
+enforced.  Refer to xfs_quota(8) for further details.
+.TP
+.B gquota/grpquota/gqnoenforce
+Group disk quota accounting enabled and limits (optionally)
+enforced.  Refer to xfs_quota(8) for further details.
+.TP
+.B pquota/prjquota/pqnoenforce
+Project disk quota accounting enabled and limits (optionally)
+enforced.  Refer to xfs_quota(8) for further details.
+.TP
+.BR sunit=value " and " swidth=value
+Used to specify the stripe unit and width for a RAID device
+or a stripe volume.  "value" must be specified in 512-byte
+block units. These options are only relevant to filesystems
+that were created with non-zero data alignment parameters.
+.sp
+The sunit and swidth parameters specified must be compatible
+with the existing filesystem alignment characteristics.  In
+general, that means the only valid changes to sunit are
+increasing it by a power-of-2 multiple. Valid swidth values
+are any integer multiple of a valid sunit value.
+.sp
+Typically the only time these mount options are necessary if
+after an underlying RAID device has had it's geometry
+modified, such as adding a new disk to a RAID5 lun and
+reshaping it.
+.TP
+.B swalloc
+Data allocations will be rounded up to stripe width boundaries
+when the current end of file is being extended and the file
+size is larger than the stripe width size.
+.TP
+.B wsync
+When specified, all filesystem namespace operations are
+executed synchronously. This ensures that when the namespace
+operation (create, unlink, etc) completes, the change to the
+namespace is on stable storage. This is useful in HA setups
+where failover must not result in clients seeing
+inconsistent namespace presentation during or after a
+failover event.
 .SH SEE ALSO
 .BR xfsctl (3),
 .BR mount (8),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
