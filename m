Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R0vPii175499 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 18:57:25 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E82688CAF5B
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 16:59:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	idHDrPZXIOGg09qv for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 16:59:47 -0800 (PST)
Date: Thu, 27 Jan 2011 11:59:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Xfstests: make 014 only run on xfs
Message-ID: <20110127005945.GE21311@dastard>
References: <1296050729-17316-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296050729-17316-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 26, 2011 at 09:05:29AM -0500, Josef Bacik wrote:
> This test relies on mounting with -o allocsize, which is an xfs specific mount
> option, so make the test only work on xfs.  Thanks,

Oh, sorry, my fault. Perhaps something like this instead?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfstests: conditionalise allocsize option in 014

allocsize is an XFS specific mount option, and hence causes the test
to fail on other filesystems. Only set the mount option on xfs
filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 014 |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/014 b/014
index e6e0a6f..057e4d9 100755
--- a/014
+++ b/014
@@ -53,8 +53,10 @@ _setup_testdir
 # ensure EOF preallocation doesn't massively extend the runtime of this test
 # by limiting the amount of preallocation and therefore the amount of blocks
 # zeroed during the truncfile test run.
-umount $TEST_DIR
-_test_mount -o allocsize=64k
+if [ "$FSTYP" == "xfs" ]; then
+	umount $TEST_DIR
+	_test_mount -o allocsize=64k
+fi
 
 echo "brevity is wit..."
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
