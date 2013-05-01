Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1DA07F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 16:01:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E555AC005
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 14:01:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FKrIIg0iAG64Qwc6 for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 14:01:47 -0700 (PDT)
Message-ID: <518182BA.4010406@sandeen.net>
Date: Wed, 01 May 2013 16:01:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs-3.1.11 pre-release   please test!
References: <51817712.6000807@sgi.com> <51817C88.4060208@sgi.com>
In-Reply-To: <51817C88.4060208@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 5/1/13 3:35 PM, Mark Tinguely wrote:
> On 05/01/13 15:12, Rich Johnston wrote:
>> Hi Folks,
>>
>> Here are the changes for this release:
>>
>> xfsprogs-3.1.11 (30 April 2013)
>>
>> - Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
>> - mkfs.xfs will always go into multidisk mode when filesystem
>> geometry is specified on the command line.
>> - Document all commands in xfs_io.
>> - Remove setfl command from xfs_io.
>> - xfs_metadump will obfuscate symlinks by path component.
>> - mkfs.xfs no longer accepts geometry settings smaller than the
>> physical sector size.
>> - xfs_logprint now supports multiply-logged inode fields and
>> handles continued inode transactions correctly.
>> - kill XLOG_SET
>> - Update release scripts to use git archive to address a
>> missing source file reported by Arkadiusz Mi?kiewicz
>> - Fix a build error with -Werror=format-security, reported
>> by Arkadiusz Mi?kiewicz
>> - mkfs.xfs no longer attempts to discard when -N option is used.
>> - Update 'make deb' to use tarball
>> - Sync up with log reservation changes in the kernel.
>> - Fix possible unallocated memory access in fiemap.
>> - Guard against string overflow in path_to_fspath.
>> - Fix setup_cursor array allocation.
>> - Fix free of unintialized pointer in xfs_acl_valid error path.
>> - Guard against path string overflows.
>> - Check strdup results properly in initallfs().
>> - Fix attribute no_change_count logic.
>> - Remove extraneous close() in fsrallfs().
>> - xfs_repair now skips the freelist scan of a corrupt agf
>> when in no-modify mode.
>> - xfs_db now skips freelist scans of corrupt agfs.
>> - Remove unconditional ASSERT(0) in xfs_repair.
>> - Reduce bb_numrecs in bno/cnt btrees when log consumes all agf space.
>> - Add depraction message for xfs_check.
>> - xfs_quota allow user or group names beginning with digits reported by
>> James Carter.
>> - Fix manpages and usage() spelling, errors and omissions.
>>
>> I have placed a pre-release tarball here:
>>
>> ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsprogs-pre-3.1.11-3.tar.gz
>>
>>
>> Please take a look and report any issues before next Wednesday (08 May
>> 2013). If there are other patches which you feel are essential, now is
>> the time to say so.
>>
>> Regards
>> --Rich
> 
> The new lines (below) in xfs_check.sh breaks older xfstests:
> 
>   xfs_check is deprecated and scheduled for removal in June 2014.
>   Please use xfs_repair -n <dev> instead.

Hum, I thought xfstests stopped calling xfs_check.sh and implemented
its own xfs_check internally:

commit 187bccd310dc253feaebd69df4ccdda21eee12d0
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Apr 18 17:44:02 2013 +0000

    xfstests: Remove dependence of xfs_check script
    
    Replace the usage of the script xfs_check and add the relevant code to
    xfstests.

...
-        [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
... etc ...

where is check getting called directly?

(Or: is your xfstests up to date?)

-Eric

> xfstests' ./check thinks the TEST directory is inconsistent and stops.
> I simply commented the lines out of the installed /usr/sbin/xfs_check
> for my tests.
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 host 3.9.0-rc1+
> MKFS_OPTIONS  -- -f -bsize=4096 {SCRATCH_DEV}
> MOUNT_OPTIONS -- {SCRATCH_DEV} {SCRATCH_MNT}
> 
> _check_xfs_filesystem: filesystem on {TEST_DEV} is inconsistent (c) (see check.full)
> Passed all 0 tests
> 
> --Mark.
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
