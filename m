Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D239B29E15
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 14:12:29 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas1-dc21-nlb.corp.sgi.com [137.38.102.126])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C00408F8059
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 12:12:26 -0700 (PDT)
Message-ID: <518AA3AE.4090407@sgi.com>
Date: Wed, 8 May 2013 14:12:46 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs v3.1.11  PLEASE LOOK AT THIS
References: <518A9E7E.7070402@sgi.com>
In-Reply-To: <518A9E7E.7070402@sgi.com>
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
To: xfs-external <xfs@oss.sgi.com>

On 05/08/2013 01:50 PM, Rich Johnston wrote:
> I was about to send out the following:  Please note the deprecated
> statement, is it correct??????
>
OOPS I meant to get internal verification about the deprecated message 
first. Please disregard the above lines.


>
> Version 3.1.11 of xfsprogs has been released.
>
> The source code can be accessed via git using this URL:
>
>      git://oss.sgi.com/xfs/cmds/xfsprogs.git
>
> A gzipped-tar archive of the source code is available here:
>
>      ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.1.11.tar.gz
>
> The development tree previously hosted on kernel.org for this code has
> been deprecated:
>
>      git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>
Yes it is deprecated.

> Below is a summary (from the doc/CHANGES file) of changes
> since release 3.1.10:
>
> xfsprogs-3.1.11 (8 May 2013)
>          - Support for relative paths in xfs_quota thanks to Satoru
> Takeuchi.
>          - mkfs.xfs will always go into multidisk mode when filesystem
>            geometry is specified on the command line.
>          - Document all commands in xfs_io.
>          - Remove setfl command from xfs_io.
>          - xfs_metadump will obfuscate symlinks by path component.
>          - mkfs.xfs no longer accepts geometry settings smaller than the
>            physical sector size.
>          - xfs_logprint now supports multiply-logged inode fields and
>            handles continued inode transactions correctly.
>          - kill XLOG_SET
>          - Update release scripts to use git archive to address a
>            missing source file reported by Arkadiusz Mi?kiewicz
>          - Fix a build error with -Werror=format-security, reported
>            by Arkadiusz Mi?kiewicz
>          - mkfs.xfs no longer attempts to discard when -N option is used.
>          - Update 'make deb' to use tarball
>          - Sync up with log reservation changes in the kernel.
>          - Fix possible unallocated memory access in fiemap.
>          - Guard against string overflow in path_to_fspath.
>          - Fix setup_cursor array allocation.
>          - Fix free of unintialized pointer in xfs_acl_valid error path.
>          - Guard against path string overflows.
>          - Check strdup results properly in initallfs().
>          - Fix attribute no_change_count logic.
>          - Remove extraneous close() in fsrallfs().
>          - xfs_repair now skips the freelist scan of a corrupt agf
>            when in no-modify mode.
>          - xfs_db now skips freelist scans of corrupt agfs.
>          - Remove unconditional ASSERT(0) in xfs_repair.
>          - Reduce bb_numrecs in bno/cnt btrees when log consumes all agf
> space.
>          - Add depraction message for xfs_check.
>          - xfs_quota allow user or group names beginning with digits
> reported by
>            James Carter.
>          - Fix manpages and usage() spelling, errors and omissions.
>          - Validate the extent count is at least within the positive
>            range of a signed 32 bit integer before using it.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
