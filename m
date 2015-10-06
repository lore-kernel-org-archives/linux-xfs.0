Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CF0C7F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 09:39:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33A6F304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 07:38:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oAPKFoumYmfd7p87 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 07:38:56 -0700 (PDT)
Date: Tue, 6 Oct 2015 10:38:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: two failing xfstests using xfs (no DAX)
Message-ID: <20151006143854.GA63205@bfoster.bfoster>
References: <20151002174941.GA25082@linux.intel.com>
	<20151002223402.GM27164@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151002223402.GM27164@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

On Sat, Oct 03, 2015 at 08:34:02AM +1000, Dave Chinner wrote:
> On Fri, Oct 02, 2015 at 11:49:41AM -0600, Ross Zwisler wrote:
> > Recently I've been trying to get a stable baseline for my DAX testing using
> > various filesystems, and in doing so I noticed a pair of tests that were
> > behaving badly when run on XFS without DAX.  These test failures happen in
> > both v4.2 and v4.3-rc3, though the signatures may vary a bit.
> > 
> > My testing setup is a kvm virtual machine with 8 GiB of its 16GiB of memory
> > reserved for PMEM using the mmap parameter (memmap=8G!8G) and with the
> > CONFIG_X86_PMEM_LEGACY config option enabled.  I've attached my full kernel
> > config to this mail.
> > 
> > The first test failure is generic/299, which consistently deadlocks in the XFS
> > code in both v4.2 and v4.3-rc3.  The stack traces presented in dmesg via "echo
> > w > /proc/sysrq-trigger" are consistent between these two kernel versions, and
> > can be found in the "generic_299.deadlock" attachment.
> 
> Yes, we've recently identified a AGF locking order problem on an
> older kernel that this looks like. We haven't found the root cause
> of it yet, but it's good to know that generic/299 seems to reproduce
> it. I'll run that in a loop to see if I can get it to fail here...
> 

First off, a quick rundown of where we're at so far:

- The deadlock occurs because a dio/aio write attempts a reverse ordered
  agf lock (e.g., lock agf3 -> lock agf0, assuming agcount == 4) and
  races with a truncate (doing something likelock agf0 -> agf3).
- The reverse ordered agf lock occurs in xfs_alloc_vextent() because
  xfs_alloc_space_available() (via xfs_alloc_fix_freelist()) indicates
  an AG can support an allocation, but subsequently fails to allocate
  later on in xfs_alloc_fix_minleft(). This causes the higher level code
  in xfs_alloc_vextent to wrap around to ag 0 when it should have either
  not locked ag3 or successfully allocated.

I pointed out that xfs_alloc_space_available() appears to incorporate
agf_flcount whereas xfs_alloc_fix_minleft() does not. Dave subsequently
pointed out that the flcount is factored out of the former via the
'min_free' parameter, so this calculation is actually consistent with
respect to the free list count.

The calculation in question is:

        /* do have enough free space remaining for the allocation? */
        available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
                          min_free - args->total);
        if (available < (int)args->minleft)
                return false;

In the test case where I reproduce the hang, pag->pagf_flcount ==
min_free, which means that no free list fixups are needed and we can
simplify things and cancel those two fields out. This means we are
basically checking if (pagf_freeblks - args->total < args->minleft). In
my test case, pagf_freeblks == 3, args->total == 0 and args->minleft ==
3. args->total in this context gives the impression that it is the block
count of the requested allocation, but it is not always used in this
manner. Indeed, the immediately prior extent length check uses
args->minlen, which is effectively the requested extent length.

FWIW, incorporating args->minlen into this check also seems to resolve
the hang, but that leads to other questions with regard to args->total.
My impression is that args->total could more be something like a
prediction on how many blocks off the free list an allocation might
require, but it's really not clear to me because 1.) it's only used in
this calculation 2.) it doesn't appear to be consistently used from the
callers and 3.) the comments above or on the data structure definition
aren't very clear.

With regard to the callers, the args->total field makes its way down
from the associated xfs_bmapi_write() parameter, passed as 0 from
xfs_iomap_write_direct(). The other iomap callers pass 1 (the actual
extent length is a separate param). It's not really clear to me what the
difference is between the direct case and the others here, but fwiw,
even just passing 1 in the direct case is enough to avoid the deadlock
(but doesn't make it correct, obviously).

The xfs_symlink() case calculates and passes two separate block counts:
fs_blocks is presumably the extent length required for the actual
symlink and resblks is the overall block count reservation for the
transaction (incorporating blocks to allocate a new inode chunk, if
necessary, etc.). This xfs_bmapi_write() call passes fs_blocks as the
extent length and resblks as "total." resblks is updated as
sub-operations occur, so this usage appears to be a mechanism that
protects the individual allocations against the overall requirement of
the transaction. Note that resblks incorporates fs_blocks, so this also
covers the length of the current allocation request and is inconsistent
with the iomap usage. The xfs_qm_dqalloc() and xfs_dir_*() callers (via
da_args) appear to similarly pass along a resblks value that
incorporates the overall extent length.

On the contrary, the call from xfs_alloc_file_space() passes a 0 similar
to the iomap_write_direct() case. Furthermore, the xfs_bmap_btalloc()
code can set (or reset) args.total to minlen internally based on a free
list flag. Given the documentation for xbf_low, perhaps this code
assumes args.total > args.minlen and is effectively "resetting" it to
the minimum length? If so, that suggests that the 1/0 callers are the
incorrect callers and should be fixed to incorporate the extent
length..?

I need to stare at this more, but at the moment I can only speculate as
to what the appropriate use of this field is. Sorry for the long mail.
I wanted to get this itemized and hopefully fill any gaps or
misunderstandings along the way. Thoughts..?

Brian

> > The second test failure is xfs/083, which in v4.2 seems to fail with an XFS
> > assertion (I have XFS_DEBUG turned on):
> > 
> > XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_dir2_data.c, line: 168
> 
> No surprise:
> 
> $ grep 083 tests/xfs/group
> 083 dangerous_fuzzers
> $
> 
> Yup, it's expected to trigger corruptions and when a
> CONFIG_XFS_DEBUG=y kernel triggers a corruption warning it triggers
> an ASSERT failure ot allow debugging.  That particular corruption is
> being detected in the /block validation function/ that is run to
> detect corruptions in directory data blocks as they are read for
> disk (__xfs_dir3_data_check).
> 
> Any test that is not in the auto group is not expected to work
> reliably as a regression test. Any many are actively dangerous like
> this and will crash/panic machines when they hit whatever problem
> they were written to exercise. For regression test purposes, the
> test groups to run are:
> 
> # check -g quick
> 
> For a fast smoke test, and
> 
> # check -g auto
> 
> to run all the tests that should function correctly as regression
> tests.
> 
> > In v4.3, though, this same test seems to create some random memory corruption
> > in XFS.  I've hit at least two failure signatures that look nothing alike
> > except they both look like somebody corrupted memory.
> 
> There's no memory corruption evident. The hexdumps are of disk
> buffers and, well, they've been fuzzed by the test...
> 
> > [   53.636917] run fstests xfs/083 at 2015-10-02 11:24:09
> > [   53.760098] XFS (pmem0p2): Unmounting Filesystem
> > [   53.779642] XFS (pmem0p2): Mounting V4 Filesystem
> 
> You're using v4 XFS filesystems. It's only valid to use CRC enabled
> XFS filesystems ("V5 filesystems") on pmem devices so we can detect
> torn sector writes correctly.
> 
> I'd suggest upgrading xfsprogs to the latest (v4.2.0) as it
> defaults to creating CRC enabled filesystems.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
