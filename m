Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:14149 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbeKHSjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 13:39:07 -0500
Date: Thu, 8 Nov 2018 20:04:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 00/16] xfs: Block size > PAGE_SIZE support
Message-ID: <20181108090432.GC19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107171405.GB4135@magnolia>
 <20181107220441.GX19305@dastard>
 <20181108013843.GB4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108013843.GB4127@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 07, 2018 at 05:38:43PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 08, 2018 at 09:04:41AM +1100, Dave Chinner wrote:
> > On Wed, Nov 07, 2018 at 09:14:05AM -0800, Darrick J. Wong wrote:
> > > On Wed, Nov 07, 2018 at 05:31:11PM +1100, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > We've had a fair number of problems reported on 64k block size
> > > > filesystems of late, but none of the XFS developers have Power or
> > > > ARM machines handy to reproduce them or even really test the fixes.
> > > > 
> > > > The iomap infrastructure we introduced a while back was designed
> > > > with the capabity of block size > page size support in mind, but we
> > > > hadn't tried to implement it.
> > > > 
> > > > So after another 64k block size bug report late last week I said to
> > > > Darrick "How hard could it be"?
> > > 
> > > "Nothing is ever simple" :)
> > 
> > "It'll only take a couple of minutes!"
> > 
> > > > About 6 billion (yes, B) fsx ops later, I have most of the XFS
> > > > functionality working on 64k block sizes on x86_64.  Buffered
> > > > read/write, mmap read/write and direct IO read/write all work. All
> > > > the fallocate() operations work correctly, as does truncate. xfsdump
> > > > and xfs_restore are happy with it, as is xfs_repair. xfs-scrub
> > > > needed some help, but I've tested Darrick's fixes for that quite a
> > > > bit over the past few days.
> > > > 
> > > > It passes most of xfstests - there's some test failures that I have
> > > > to determine whether they are code bugs or test problems (i.e. some
> > > > tests don't deal with 64k block sizes correctly or assume block size
> > > > <= page size).
> > > > 
> > > > What I haven't tested yet is shared extents - the COW path,
> > > > clone_file_range and dedupe_file_range. I discovered earlier today
> > > > that fsx doesn't support copy/clone/dedupe_file_operations
> > > > operations, so before I go any further I need to enxpahnce fsx. Then
> > > 
> > > I assume that means you only tested this on reflink=0 filesystems?
> > 
> > Correct.
> > 
> > > Looking at fsstress, it looks like we don't test copy_file_range either.
> > > I can try adding the missing clone/dedupe/copy to both programs, but
> > > maybe you've already done that while I was asleep?
> > 
> > No, I haven't started on this yet. I've been sleeping. :P
> 
> I started wondering if we were missing anything from not having fsx
> support clone/dedupe and ended up with:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsstress-clone

Some fixes to that below.

I haven't got to testing dedupe or clone - copy_file_range explodes
in under 40 operations in on generic/263. do_splice_direct() looks
to be broken in several different waysat this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

fsx: clean up copy/dedupe file range support.

From: Dave Chinner <dchinner@redhat.com>

copy_file_range() needs to obey read/write constraints otherwise is
blows up when direct IO is used.

FIDEDUPERANGE has a completely screwed up API for error reporting.
The ioctl succeeds even if dedupe fails, so you have to check
every individual dedupe operations for failure. Without this, dedupe
"succeeds" on kernels filesystems that don't even support dedupe...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 ltp/fsx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index fad50e0022af..b51910b8b2e1 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1382,7 +1382,11 @@ do_dedupe_range(unsigned offset, unsigned length, unsigned dest)
 	fdr->info[0].dest_fd = fd;
 	fdr->info[0].dest_offset = dest;
 
-	if (ioctl(fd, FIDEDUPERANGE, fdr) == -1) {
+	if (ioctl(fd, FIDEDUPERANGE, fdr) == -1 ||
+	    fdr->info[0].status < 0) {
+		if (fdr->info[0].status < 0)
+			errno = -fdr->info[0].status;
+
 		if (errno == EOPNOTSUPP || errno == ENOTTY) {
 			if (!quiet && testcalls > simulatedopcount)
 				prt("skipping unsupported dedupe range\n");
@@ -1416,6 +1420,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 	loff_t o1, o2;
 	ssize_t nr;
 
+	offset -= offset % readbdy;
+	dest -= dest % writebdy;
+	if (o_direct)
+		length -= length % readbdy;
+
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
 			prt("skipping zero length copy range\n");
