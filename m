Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC67B7F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 17:34:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFCCC8F8033
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 15:34:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sIdaJNZgKfbYgTBf for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 15:34:37 -0700 (PDT)
Date: Sat, 3 Oct 2015 08:34:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: two failing xfstests using xfs (no DAX)
Message-ID: <20151002223402.GM27164@dastard>
References: <20151002174941.GA25082@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151002174941.GA25082@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 02, 2015 at 11:49:41AM -0600, Ross Zwisler wrote:
> Recently I've been trying to get a stable baseline for my DAX testing using
> various filesystems, and in doing so I noticed a pair of tests that were
> behaving badly when run on XFS without DAX.  These test failures happen in
> both v4.2 and v4.3-rc3, though the signatures may vary a bit.
> 
> My testing setup is a kvm virtual machine with 8 GiB of its 16GiB of memory
> reserved for PMEM using the mmap parameter (memmap=8G!8G) and with the
> CONFIG_X86_PMEM_LEGACY config option enabled.  I've attached my full kernel
> config to this mail.
> 
> The first test failure is generic/299, which consistently deadlocks in the XFS
> code in both v4.2 and v4.3-rc3.  The stack traces presented in dmesg via "echo
> w > /proc/sysrq-trigger" are consistent between these two kernel versions, and
> can be found in the "generic_299.deadlock" attachment.

Yes, we've recently identified a AGF locking order problem on an
older kernel that this looks like. We haven't found the root cause
of it yet, but it's good to know that generic/299 seems to reproduce
it. I'll run that in a loop to see if I can get it to fail here...

> The second test failure is xfs/083, which in v4.2 seems to fail with an XFS
> assertion (I have XFS_DEBUG turned on):
> 
> XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_dir2_data.c, line: 168

No surprise:

$ grep 083 tests/xfs/group
083 dangerous_fuzzers
$

Yup, it's expected to trigger corruptions and when a
CONFIG_XFS_DEBUG=y kernel triggers a corruption warning it triggers
an ASSERT failure ot allow debugging.  That particular corruption is
being detected in the /block validation function/ that is run to
detect corruptions in directory data blocks as they are read for
disk (__xfs_dir3_data_check).

Any test that is not in the auto group is not expected to work
reliably as a regression test. Any many are actively dangerous like
this and will crash/panic machines when they hit whatever problem
they were written to exercise. For regression test purposes, the
test groups to run are:

# check -g quick

For a fast smoke test, and

# check -g auto

to run all the tests that should function correctly as regression
tests.

> In v4.3, though, this same test seems to create some random memory corruption
> in XFS.  I've hit at least two failure signatures that look nothing alike
> except they both look like somebody corrupted memory.

There's no memory corruption evident. The hexdumps are of disk
buffers and, well, they've been fuzzed by the test...

> [   53.636917] run fstests xfs/083 at 2015-10-02 11:24:09
> [   53.760098] XFS (pmem0p2): Unmounting Filesystem
> [   53.779642] XFS (pmem0p2): Mounting V4 Filesystem

You're using v4 XFS filesystems. It's only valid to use CRC enabled
XFS filesystems ("V5 filesystems") on pmem devices so we can detect
torn sector writes correctly.

I'd suggest upgrading xfsprogs to the latest (v4.2.0) as it
defaults to creating CRC enabled filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
