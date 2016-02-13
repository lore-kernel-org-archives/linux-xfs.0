Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18BE57CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 19:27:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D96608F8039
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 17:27:03 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BdsNvFUUzlK74LgS for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 17:27:01 -0800 (PST)
Date: Sat, 13 Feb 2016 12:26:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4.2 00/32] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20160213012659.GA14668@dastard>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 03:39:16PM -0800, Darrick J. Wong wrote:
> Dave Chinner: I've renumbered the new tests and pushed to github[3] if
> you'd like to pull.  See the pull request at the end of this message.
> 
> This is a patch set against the reflink/dedupe test cases in xfstests.
> The first three patches fix errors in the existing reflink tests, some
> of which are from Christoph Hellwig.
> 
> The next eight patches fix style errors, refactor commonly used code,
> remove unnecessary clutter, and add missing _require* checks to the
> existing reflink tests.
> 
> Patch 12 adds a test checking that unwritten extent conversion does
> NOT happen after a directio write to an unwritten extent hits a disk
> error.   Due to a bug in the VFS directio code, ext4 can disclose
> stale disk contents if an aio dio write fails; XFS suffers this
> problem for any failing dio write to an unwritten extent.  Christoph's
> kernel patchset titled "vfs/xfs: directio updates to ease COW handling
> V2" (and a separate ext4 warning cleanup) is needed to fix this.
> 
> Patches 13-31 add more reflink tests focusing on correct CoW behavior
> particularly with the CoW extent size hint enabled.  It also provides
> a few regression tests for bugs that have been hit while running XFS
> reflink, a few tests of the quota accounting when various reflink
> operations happen, and a few tests for get_bmapx to ensure that what
> it reports is at least somewhat accurate.
> 
> Patch 25 adds a few basic reverse-mapping tests for XFS.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
> xfs-docs[4], and man-pages[5].  All tests should pass on XFS, YMWV on
> btrfs and ocfs2.
> 
> Comments and questions are, as always, welcome.

I haven't worked out which patch causes this, but:

xfs/246  - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_1k/xfs/246.out.bad)
    --- tests/xfs/246.out       2016-02-13 09:46:01.419169115 +1100
    +++ /home/dave/src/xfstests-dev/results//xfs_1k/xfs/246.out.bad     2016-02-13 11:36:05.205851863 +1100
    @@ -3,4 +3,5 @@
     Create the original files
     Dump extents after sync
     Hole CoW extents:
    -SCRATCH_MNT/test-246/file1: no extents
    +bmap: invalid option -- 'c'
    +bmap [-adlpv] [-n nx] -- print block mapping for an XFS file
    ...
    (Run 'diff -u tests/xfs/246.out /home/dave/src/xfstests-dev/results//xfs_1k/xfs/246.out.bad'  to see the entire diff)

This test neds a check that the "-c" option in the bmap command
exists. Not sure if you can use '_requires_xfs_io_command "bmap -c"'
here or whether this requires more help...

Followup patch, anyway, because I'm about to push out everything
that was in your second pull req (i.e. with the aiocp fix).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
