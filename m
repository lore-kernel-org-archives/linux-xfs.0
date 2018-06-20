Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbeFTTCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 15:02:51 -0400
Date: Wed, 20 Jun 2018 12:02:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180620190230.GB4838@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-24-hch@lst.de>
 <20180619165211.GD2806@bfoster>
 <20180620075655.GA2668@lst.de>
 <20180620143252.GE3241@bfoster>
 <20180620160803.GA4838@magnolia>
 <20180620181259.GD4493@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620181259.GD4493@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 20, 2018 at 02:12:59PM -0400, Brian Foster wrote:
> On Wed, Jun 20, 2018 at 09:08:03AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 20, 2018 at 10:32:53AM -0400, Brian Foster wrote:
> > > Sending again without the attachment... Christoph, let me know if it
> > > didn't hit your mbox at least.
> > > 
> > > On Wed, Jun 20, 2018 at 09:56:55AM +0200, Christoph Hellwig wrote:
> > > > On Tue, Jun 19, 2018 at 12:52:11PM -0400, Brian Foster wrote:
> > > > > > +	/*
> > > > > > +	 * Move the caller beyond our range so that it keeps making progress.
> > > > > > +	 * For that we have to include any leading non-uptodate ranges, but
> > > > > 
> > > > > Do you mean "leading uptodate ranges" here? E.g., pos is pushed forward
> > > > > past those ranges we don't have to read, so (pos - orig_pos) reflects
> > > > > the initial uptodate range while plen reflects the length we have to
> > > > > read..?
> > > > 
> > > > Yes.
> > > > 
> > > > > > +
> > > > > > +	do {
> > > > > 
> > > > > Kind of a nit, but this catches my eye and manages to confuse me every
> > > > > time I look at it. A comment along the lines of:
> > > > > 
> > > > >                 /*
> > > > > 		 * Pass in the block aligned start/end so we get back block
> > > > > 		 * aligned/adjusted poff/plen and can compare with unaligned
> > > > > 		 * from/to below.
> > > > >                  */
> > > > > 
> > > > > ... would be nice here, IMO.
> > > > 
> > > > Fine with me.
> > > > 
> > > > > > +		iomap_adjust_read_range(inode, iop, &block_start,
> > > > > > +				block_end - block_start, &poff, &plen);
> > > > > > +		if (plen == 0)
> > > > > > +			break;
> > > > > > +
> > > > > > +		if ((from > poff && from < poff + plen) ||
> > > > > > +		    (to > poff && to < poff + plen)) {
> > > > > > +			status = iomap_read_page_sync(inode, block_start, page,
> > > > > > +					poff, plen, from, to, iomap);
> > > > > 
> > > > > After taking another look at the buffer head path, it does look like we
> > > > > have slightly different behavior here. IIUC, the former reads only the
> > > > > !uptodate blocks that fall along the from/to boundaries. Here, if say
> > > > > from = 1, to = PAGE_SIZE and the page is fully !uptodate, it looks like
> > > > > we'd read the entire page worth of blocks (assuming contiguous 512b
> > > > > blocks, for example). Intentional? Doesn't seem like a big deal, but
> > > > > could be worth a followup fix.
> > > > 
> > > > It wasn't actuall intentional, but I actually think it is the right thing
> > > > in then end, as it means we'll often do a single read instead of two
> > > > separate ones.
> > > 
> > > Ok, but if that's the argument, then shouldn't we not be doing two
> > > separate I/Os if the middle range of a write happens to be already
> > > uptodate? Or more for that matter, if the page happens to be sparsely
> > > uptodate for whatever reason..?
> > > 
> > > OTOH, I also do wonder a bit whether that may always be the right thing
> > > if we consider cases like 64k page size arches and whatnot. It seems
> > > like we could end up consuming more bandwidth for reads than we
> > > typically have in the past. That said, unless there's a functional
> > > reason to change this I think it's fine to optimize this path for these
> > > kinds of corner cases in follow on patches.
> > > 
> > > Finally, this survived xfstests on a sub-page block size fs but I
> > > managed to hit an fsx error:
> > > 
> > > Mapped Read: non-zero data past EOF (0x21a1f) page offset 0xc00 is
> > > 0xc769
> > > 
> > > It repeats 100% of the time for me using the attached fsxops file (with
> > > --replay-ops) on XFS w/ -bsize=1k. It doesn't occur without the final
> > > patch to enable sub-page block iomap on XFS.
> > 
> > Funny, because I saw the exact same complaint from generic/127 last
> > night on my development tree that doesn't include hch's patches and was
> > going to see if I could figure out what's going on.
> > 
> > FWIW it's been happening sporadically for a few weeks now but every time
> > I've tried to analyze it I (of course) couldn't get it to reproduce. :)
> > 
> > I also ran this series (all of it, including the subpagesize config)
> > last night and aside from it stumbling over an unrelated locking problem
> > seemed fine....
> > 
> 
> That's interesting. Perhaps it's a pre-existing issue in that case and
> the iomap stuff just changes the timing to make it reliably reproducible
> on this particular system.
> 
> I only ran it a handful of times in both cases and now have lost access
> to the server. Once I regain access, I'll try running for longer on
> for-next to see if the same thing eventually triggers.

I managed to cut the testcase down to a nine-line fsx script and so
turned it into a fstests regression case.  It seems to reproduce 100% on
scsi disks and doesn't at all on pmem.

Note that changing the second to last line of the fsxops script to call
punch_hole instead of zero_range triggers it too.

I've also narrowed it down to something going wrong w.r.t. handling the
page cache somewhere under xfs_free_file_space.

(See attached diff...)

--D

generic: mread past eof shows nonzero contents

Certain sequences of generic/127 invocations complain about being able
to mread nonzero contents past eof.  Replicate that here as a regression
test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/708     |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/708.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/708
 create mode 100644 tests/generic/708.out

diff --git a/tests/generic/708 b/tests/generic/708
new file mode 100755
index 00000000..fa5584f5
--- /dev/null
+++ b/tests/generic/708
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 708
+#
+# Test a specific sequence of fsx operations that causes an mmap read past
+# eof to return nonzero contents.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+cat >> $tmp.fsxops << ENDL
+fallocate 0x77e2 0x5f06 0x269a2 keep_size
+mapwrite 0x2e7fc 0x42ba 0x3f989
+write 0x67a9 0x714e 0x3f989
+write 0x39f96 0x185a 0x3f989
+collapse_range 0x36000 0x8000 0x3f989
+mapread 0x74c0 0x1bb3 0x3e2d0
+truncate 0x0 0x8aa2 0x3e2d0
+zero_range 0x1265 0x783d 0x8aa2
+mapread 0x7bd8 0xeca 0x8aa2
+ENDL
+
+victim=$SCRATCH_MNT/a
+touch $victim
+$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/708.out b/tests/generic/708.out
new file mode 100644
index 00000000..33c478ad
--- /dev/null
+++ b/tests/generic/708.out
@@ -0,0 +1,2 @@
+QA output created by 708
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 83a6fdab..1a1a0a6e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -501,3 +501,4 @@
 496 auto quick swap
 497 auto quick swap collapse
 498 auto quick log
+708 auto quick rw collapse
