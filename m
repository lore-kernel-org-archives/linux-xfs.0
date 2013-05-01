Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E8F87F56
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:12:07 -0500 (CDT)
Message-ID: <51817712.6000807@sgi.com>
Date: Wed, 1 May 2013 15:12:02 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: xfsprogs-3.1.11 pre-release   please test!
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Nathan Scott <nathans@debian.org>

Hi Folks,

Here are the changes for this release:

xfsprogs-3.1.11 (30 April 2013)

         - Support for relative paths in xfs_quota thanks to Satoru 
Takeuchi.
         - mkfs.xfs will always go into multidisk mode when filesystem
           geometry is specified on the command line.
         - Document all commands in xfs_io.
         - Remove setfl command from xfs_io.
         - xfs_metadump will obfuscate symlinks by path component.
         - mkfs.xfs no longer accepts geometry settings smaller than the
           physical sector size.
         - xfs_logprint now supports multiply-logged inode fields and
           handles continued inode transactions correctly.
         - kill XLOG_SET
         - Update release scripts to use git archive to address a
           missing source file reported by Arkadiusz Mi?kiewicz
         - Fix a build error with -Werror=format-security, reported
           by Arkadiusz Mi?kiewicz
         - mkfs.xfs no longer attempts to discard when -N option is used.
         - Update 'make deb' to use tarball
         - Sync up with log reservation changes in the kernel.
         - Fix possible unallocated memory access in fiemap.
         - Guard against string overflow in path_to_fspath.
         - Fix setup_cursor array allocation.
         - Fix free of unintialized pointer in xfs_acl_valid error path.
         - Guard against path string overflows.
         - Check strdup results properly in initallfs().
         - Fix attribute no_change_count logic.
         - Remove extraneous close() in fsrallfs().
         - xfs_repair now skips the freelist scan of a corrupt agf
           when in no-modify mode.
         - xfs_db now skips freelist scans of corrupt agfs.
         - Remove unconditional ASSERT(0) in xfs_repair.
         - Reduce bb_numrecs in bno/cnt btrees when log consumes all agf 
space.
         - Add depraction message for xfs_check.
         - xfs_quota allow user or group names beginning with digits 
reported by
           James Carter.
         - Fix manpages and usage() spelling, errors and omissions.

I have placed a pre-release tarball here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsprogs-pre-3.1.11-3.tar.gz

Please take a look and report any issues before next Wednesday (08 May 
2013).  If there are other patches which you feel are essential, now is 
the time to say so.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
