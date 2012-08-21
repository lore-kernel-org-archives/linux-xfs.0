Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L83upN054396 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 03:03:56 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jkJCIjGWHa3AeIuX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Aug 2012 01:03:54 -0700 (PDT)
Date: Tue, 21 Aug 2012 10:03:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Test 272 fails for ext3
Message-ID: <20120821080338.GA7537@quack.suse.cz>
References: <20120816092808.GA9057@quack.suse.cz>
	<20120816093757.GA11519@quack.suse.cz>
	<20120816224858.GY2877@dastard>
	<20120820162212.GA17354@quack.suse.cz>
	<20120820210638.GA4591@quack.suse.cz>
	<20120820224941.GG19235@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20120820224941.GG19235@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, dmonakhov@openvz.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 21-08-12 08:49:41, Dave Chinner wrote:
> On Mon, Aug 20, 2012 at 11:06:38PM +0200, Jan Kara wrote:
> ....
> > --- a/272
> > +++ b/272
> > @@ -32,15 +32,18 @@ tmp=/tmp/$$
> >  status=1	# failure is the default!
> >  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> >  
> > +write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> > +if [ $FSTYP = "ext3" ]; then
> > +	# ext3 doesn't support direct IO in journalling mode
> > +	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> > +fi
> 
> Seems like asking for trouble duplicating the common options.
> 
> # ext3 doesn't support direct IO in journalling mode
> write_opt_list="iflag=noatime conv=notrunc conv=fsync
> [ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"
> 
> Otherwise looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
  OK, I've updated the test as you suggested. Result is attached.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--k1lZvvs/B4yU6o8G
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Make-test-272-work-for-ext3.patch"

>From ffae802de298576f701a7cc0e0bfd2b33c6be36e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Aug 2012 11:14:35 +0200
Subject: [PATCH v4] Make test 272 work for ext3

ext3 does not support direct IO for files with data journalling. This
confuses test 272. Make the test check whether open succeeds and perform
the writing only if it does.

Thanks for Dave Chinner for suggesting a simpler way to fix the test.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 272     |   14 ++++++++------
 272.out |   36 +-----------------------------------
 2 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/272 b/272
index 26dfa3b..c7f1efc 100755
--- a/272
+++ b/272
@@ -32,15 +32,17 @@ tmp=/tmp/$$
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
+# ext3 doesn't support direct IO in journalling mode
+write_opt_list="iflag=noatime conv=notrunc conv=fsync"
+# For filesystems that can handle it, add also direct IO test
+[ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"
+
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
 _workout()
 {
-	echo ""
-	echo " Switch data journalling mode"
-	echo ""
-	write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
+	echo "Switch data journalling mode. Silence is golden."
 	chattr_opt_list="+j -j +jS -j"
 	idx=0
 	#
@@ -51,7 +53,7 @@ _workout()
 		do
 		    
 			echo "OP write_opt: $write_opt 4M, \
-chattr_opt: $chattr_opt"
+chattr_opt: $chattr_opt" >>$seq.full
 			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
 				bs=1M count=4 $write_opt \
 				>> $seq.full 2>&1 || exit
@@ -69,7 +71,7 @@ chattr_opt: $chattr_opt"
 		do
 
 			echo "OP write_opt: $write_opt ENOSPC, \
-chattr_opt: $chattr_opt"
+chattr_opt: $chattr_opt" >>$seq.full
 			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
 				bs=1M $write_opt >> $seq.full 2>&1
 			chattr $chattr_opt $SCRATCH_MNT/file.$idx \
diff --git a/272.out b/272.out
index cc687aa..a9eaf84 100644
--- a/272.out
+++ b/272.out
@@ -1,37 +1,3 @@
 QA output created by 272
-
- Switch data journalling mode
-
-OP write_opt: iflag=noatime 4M, chattr_opt: +j
-OP write_opt: iflag=noatime 4M, chattr_opt: -j
-OP write_opt: iflag=noatime 4M, chattr_opt: +jS
-OP write_opt: iflag=noatime 4M, chattr_opt: -j
-OP write_opt: conv=notrunc 4M, chattr_opt: +j
-OP write_opt: conv=notrunc 4M, chattr_opt: -j
-OP write_opt: conv=notrunc 4M, chattr_opt: +jS
-OP write_opt: conv=notrunc 4M, chattr_opt: -j
-OP write_opt: conv=fsync 4M, chattr_opt: +j
-OP write_opt: conv=fsync 4M, chattr_opt: -j
-OP write_opt: conv=fsync 4M, chattr_opt: +jS
-OP write_opt: conv=fsync 4M, chattr_opt: -j
-OP write_opt: oflag=direct 4M, chattr_opt: +j
-OP write_opt: oflag=direct 4M, chattr_opt: -j
-OP write_opt: oflag=direct 4M, chattr_opt: +jS
-OP write_opt: oflag=direct 4M, chattr_opt: -j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: +j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: +jS
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: +j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: +jS
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: +j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: +jS
-OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: +j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: +jS
-OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
+Switch data journalling mode. Silence is golden.
 Check filesystem
-- 
1.7.1


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--k1lZvvs/B4yU6o8G--
