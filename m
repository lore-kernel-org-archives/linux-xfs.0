Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLNgJpO116663 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 17:42:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F5AE1CE9852
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 15:44:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	WZWxVLcOj1Vc2xCj for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 15:44:14 -0800 (PST)
Date: Wed, 22 Dec 2010 10:44:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/34] xfs: dynamic speculative EOF preallocation
Message-ID: <20101221234412.GC4907@dastard>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-7-git-send-email-david@fromorbit.com>
	<20101221151511.GA26127@infradead.org>
	<20101221214240.GB4907@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101221214240.GB4907@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 08:42:40AM +1100, Dave Chinner wrote:
> On Tue, Dec 21, 2010 at 10:15:11AM -0500, Christoph Hellwig wrote:
> > This patch causes tesr 014 to take ~ 870 seconds instead of 6, thus
> > beeing almost 150 times slower on mt 32-bit test VM, so I'll have to NAK
> > it for now.
> 
> It's not the speculative preallocation changes - ithey are just
> exposing some other regression. That is, using MOUNT_OPTIONS="-o
> allocsize=4k" gives the previous behaviour, while allocsize=512m
> gives the same behaviour as the dynamic preallocation.
> 
> The dynamic behaviour is resulting in megabyte sized IOs being
> issued for random 512 byte writes (which is wrong), so I'm tending
> towards it being a regression caused by the reecent writeback path
> changes. I'll dig deeper today.

Ok, it's not a recent regression - it's the fact that the test is 
writing and truncating to random offsets so the file size is
constantly changing resulting in xfs_zero_eof() writing huge amounts
of zeros into preallocated extents beyond EOF. The patch below
explains the situation and the change to the test to avoid
the extended runtime.

Ultimately, we probably need to change xfs_zero_eof() to allocate
unwritten extents rather than write megabytes of zero for
speculative allocation beyond EOF. However, I'm going to worry about
that when (if) we come across applications that trigger this issue.

--

xfstests: 014 takes forever with large preallocation sizes

From: Dave Chinner <dchinner@redhat.com>

Christoph reported that test 014 went from 7s to 870s runtime with
the dynamic speculative delayed allocation changes. Analysis of test
014 shows that it does this loop 10,000 times:

	pwrite(random offset, 512 bytes);
	truncate(random offset);

Where the random offset is anywhere in a 256MB file. Hence on
average every second write or truncate extends the file.

If large preallocatione beyond EOF sizes are used each extending
write or truncate will zero large numbers of blocks - tens of
megabytes at a time. The result is that instead of only writing
~10,000 blocks, we write hundreds to thousands of megabytes of zeros
to the file and that is where the difference in runtime is coming
from.

The IO pattern that this test is using does not reflect a common (or
sane!) real-world application IO pattern, so it is really just
exercising the allocation and truncation paths in XFS. To do this,
we don't need large amounts of preallocation beyond EOF that just
slows down the operation, so execute the test with a fixed, small
preallocation size that reflects the previous default.

By specifying the preallocation size via the allocsize mount option,
this also overrides any custom allocsize option provided for the
test, so the test will not revert to extremely long runtimes when
allocsize is provided on the command line.

However, to ensure that we do actually get some coverage of the
zeroing paths, set the allocsize mount option to 64k - this
exercises the EOF zeroing paths, but does not affect the runtime of
the test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 014 |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/014 b/014
index a0c0403..e6e0a6f 100755
--- a/014
+++ b/014
@@ -50,6 +50,12 @@ _supported_os IRIX Linux
 _require_sparse_files
 _setup_testdir
 
+# ensure EOF preallocation doesn't massively extend the runtime of this test
+# by limiting the amount of preallocation and therefore the amount of blocks
+# zeroed during the truncfile test run.
+umount $TEST_DIR
+_test_mount -o allocsize=64k
+
 echo "brevity is wit..."
 
 echo "------"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
