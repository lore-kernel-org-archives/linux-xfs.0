Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AD9NNS131352 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 08:09:24 -0500
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id Km9nyFyAuAW3D1Z1 (version=TLSv1 cipher=RC4-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 06:09:22 -0700 (PDT)
Message-ID: <4F8430FF.2090706@netapp.com>
Date: Tue, 10 Apr 2012 09:09:19 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
References: <4F832C25.3080408@netapp.com> <20120409214445.GJ18323@dastard>
In-Reply-To: <20120409214445.GJ18323@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 04/09/12 17:44, Dave Chinner wrote:

> On Mon, Apr 09, 2012 at 02:36:21PM -0400, Bryan Schumaker wrote:
>> The cleanup function is trapped before _require_scratch() is called, and
>> then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"
> 
> It doesn't need to clean up the scratch device - tests need to mkfs
> it first before using it, so just remove the $tmp* files. The sae
> fix is needed for tests 274 and 275.
> 
> Also, it shouldn't be using "-rf" to do cleanup - "rm -f $tmp.*" is
> sufficient to remove all the tmp files...


Thanks for looking!  Maybe something like this?  (copying what 272 does):

diff --git a/273 b/273
index 2965132..4641e9d 100755
--- a/273
+++ b/273
@@ -30,14 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-	cd /
-	rm -rf $SCRATCH_MNT/* $tmp.*
-	_scratch_unmount
-}
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 . ./common.rc
 . ./common.filter
@@ -138,7 +131,18 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-_do_workload
+if ! _do_workload; then
+	echo "workout failed"
+	_scratch_unmount
+	status=1
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
 
 _check_scratch_fs
 status=$?
-- 
1.7.10

- Bryan

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
