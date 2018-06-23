Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751787AbeFWNG1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jun 2018 09:06:27 -0400
Date: Sat, 23 Jun 2018 09:06:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180623130624.GA16691@bfoster>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-24-hch@lst.de>
 <20180619165211.GD2806@bfoster>
 <20180620075655.GA2668@lst.de>
 <20180620143252.GE3241@bfoster>
 <20180620160803.GA4838@magnolia>
 <20180620181259.GD4493@bfoster>
 <20180620190230.GB4838@magnolia>
 <20180621084646.GA5764@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621084646.GA5764@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Jun 21, 2018 at 10:46:46AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 20, 2018 at 12:02:30PM -0700, Darrick J. Wong wrote:
> > I managed to cut the testcase down to a nine-line fsx script and so
> > turned it into a fstests regression case.  It seems to reproduce 100% on
> > scsi disks and doesn't at all on pmem.
> > 
> > Note that changing the second to last line of the fsxops script to call
> > punch_hole instead of zero_range triggers it too.
> > 
> > I've also narrowed it down to something going wrong w.r.t. handling the
> > page cache somewhere under xfs_free_file_space.
> 
> So far this doesn't reproduce for me with or without the iomap code.
> But I've only run it a few times in a VM on my laptop.

After playing around a bit more, I observed that this became much harder
to reproduce after creating a new fs or using a largish fs. I think it's
hit or miss based on the content of free space in the filesystem. The
appended diff applied on top of Darrick's recent xfstests test[1] makes
this reproduce reliably for me (with -bsize=1k).

The problem, I think, is essentially that readpage doesn't zero out
real/allocated post-eof blocks on the current page. For example, once
this test runs at least once, the following command is all that is
required to observe the difference in behavior between the buffer head
path and the new iomap path:

  xfs_io -c "mmap 0x21000 0x1000" -c "mread -v 0x21c00 0x100" <scratch_mnt>/a

The former returns zeroes for the post-eof (i_size == 0x21a20) portion
of the page due to the (iblock < lblock) check in
block_read_full_page(). If the block is post eof, get_block() isn't
called, the bh is left unmapped and the portion of the page is
explicitly zeroed in the same loop. The iomap code appears to read and
expose whatever is on disk if the block is allocated. I'm guessing we at
least need to consider doing something similar in iomap_readpage_actor()
(or perhaps somewhere in that path that also covers the write path)..?
I'm not sure it's sufficient to rely on writeback to zero the page and
otherwise let it expose garbage until that point.

Brian

[1] https://marc.info/?l=linux-xfs&m=152960597620340&w=2

--- 8< ---

diff --git a/tests/generic/708 b/tests/generic/708
index d380053f..355cc6b1 100755
--- a/tests/generic/708
+++ b/tests/generic/708
@@ -30,19 +30,17 @@ _require_scratch
 
 rm -f $seqres.full
 
-_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mkfs_sized $((1024 * 1024 * 100)) >>$seqres.full 2>&1
 _scratch_mount
 
+$XFS_IO_PROG -fc "pwrite 0 100m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
+rm -f $SCRATCH_MNT/file
+
 cat >> $tmp.fsxops << ENDL
-fallocate 0x77e2 0x5f06 0x269a2 keep_size
-mapwrite 0x2e7fc 0x42ba 0x3f989
-write 0x67a9 0x714e 0x3f989
-write 0x39f96 0x185a 0x3f989
-collapse_range 0x36000 0x8000 0x3f989
-mapread 0x74c0 0x1bb3 0x3e2d0
-truncate 0x0 0x8aa2 0x3e2d0
-zero_range 0x1265 0x783d 0x8aa2
-mapread 0x7bd8 0xeca 0x8aa2
+truncate 0x0 0x1f0d6 0x380e1
+write 0x1ad87 0x6c99 0x180d6
+zero_range 0x14426 0xd3aa 0x21a20 keep_size
+mapread 0x1f69a 0x2386 0x21a20
 ENDL
 
 victim=$SCRATCH_MNT/a
