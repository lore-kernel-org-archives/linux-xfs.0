Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4B917CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:21:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 784B8304039
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 23:21:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AAmogCG8tlANwEzg for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 23:21:08 -0800 (PST)
Date: Tue, 9 Feb 2016 18:21:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4.1 00/23] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20160209072106.GH19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
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

On Mon, Feb 08, 2016 at 05:11:45PM -0800, Darrick J. Wong wrote:
> Happy New Year!
> 
> Dave Chinner: I've renumbered the new tests and pushed to github[3] if
> you'd like to pull.

Can you include the commit ID I should see at the head of the
tree so I can confirm I'm pulling the right branch?

BTW, git doesn't like this:

https://github.com/djwong/xfstests/tree/for-dave

What git really wants is the tree url with a separate branch name
like so:

https://github.com/djwong/xfstests.git for-dave

(i.e. the typical output from a git request-pull command)

> This is a (no longer) small patch set against the reflink/dedupe test
> cases in xfstests.  The first four patches fix errors in the existing
> reflink tests, some of which are from Christoph Hellwig.
> 
> Patches 5-6 refactor the dmerror code so that we can use it to
> simulate transient IO errors, then use this code to test that
> unwritten extent conversion does NOT happen after a directio write to
> an unwritten extent hits a disk error.   Due to a bug in the VFS
> directio code, ext4 can disclose stale disk contents if an aio dio
> write fails; XFS suffers this problem for any failing dio write to an
> unwritten extent.  Christoph's kernel patchset titled "vfs/xfs:
> directio updates to ease COW handling V2" (and a separate ext4 warning
> cleanup) is needed to fix this.
> 
> Patches 7-9, 13, 15, 17, 18, 20, 21, and 23 exercise various parts
> of the copy on write behavior that are necessary to support shared
> blocks.  The earlier patches focus on correct CoW behavior in the
> presence of IO errors during the copy-write, and the later patches
> focus on XFS' new cow-extent-size hint that greatly reduces
> fragmentation due to copy on write behavior by encouraging the
> allocator to allocate larger extents of replacement blocks.
> 
> Patches 10-12 and 14 perform stress testing on reflink and CoW to
> check the behaviors when we get close to maximum refcount, when we
> specify obnxiously large offsets and lengths, and when we try to
> reflink millions of extents at a time.
> 
> Patch 16 tests quota accounting behavior when reflink is enabled.
> 
> Patch 19 adds a few tests for the XFS reverse mapping btree to ensure
> that things like metadump and growfs work correctly.
> 
> Patch 22 checks that get_bmapx and fiemap (on XFS) correctly flag
> extents as having shared blocks.  XFS now follows btrfs and ocfs2
> FIEMAP behavior such that if any blocks of a file's extent are shared,
> the whole extent is marked shared.  This is in contrast to earlier
> XFS-only behavior that reported shared and non-shared regions as
> separate extents.

This may change - xfs_bmap doesn't combine extents in it's output
even if they are adjacent. For debugging purposes (which is what
xfs_bmap/fiemap is for), it's much better to be able to see the
exact extent layout and block sharing.

I suspect the solution of least surprise is to make fiemap behave
like the other filesystems, and make xfs_bmap behave in a manner
that is useful to us.... :P

> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
> xfs-docs[4], and man-pages[5].  All tests should pass on XFS.   I
> tried btrfs this weekend and it failed 166, 175, 182, 266, 271, 272,
> 278, 281, 297, 298, 304, 333, and 334.  ocfs2 (when I jury-rigged it
> to run the cp_reflink tests) seemed to have a quota bug and crashes
> hard in 284 (but was otherwise fine).

Fun fun fun. I'll look through the patchs, and if there's nothing
major I'll pull it in once I get a commit ID from you.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
