Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KGMHKK242728 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 11:22:17 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0GLL8XqBuPcd8ZNq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 09:22:15 -0700 (PDT)
Date: Mon, 20 Aug 2012 18:22:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Test 272 fails for ext3
Message-ID: <20120820162212.GA17354@quack.suse.cz>
References: <20120816092808.GA9057@quack.suse.cz>
	<20120816093757.GA11519@quack.suse.cz>
	<20120816224858.GY2877@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20120816224858.GY2877@dastard>
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


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 17-08-12 08:48:58, Dave Chinner wrote:
> On Thu, Aug 16, 2012 at 11:37:57AM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   I was looking into why test 272 from xfstests fails for ext3 and the
> > reason is that ext3 does not support direct IO to file with enabled data
> > journalling (open returns EINVAL because ->direct_IO callback is not
> > specified). So I was thinking how to accomodate this fact in the test -
> > the best I found was to just check using xfs_io whether O_DIRECT open
> > succeeds and perform the test only in that case. Attached patch does this
> > or do people have other ideas?
> 
> 
> # ext3 doesn't support direct IO in journalling mode
> ext3_write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> ext4_write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> 
> if [ $FSTYP = "ext3" ]; then
> 	write_opt_list="$ext3_write_opt_list"
> else
> 	write_opt_list="$ext4_write_opt_list"
> fi
  Yeah, this is probably simpler. Thanks for suggestion. BTW, ext4 also
does not support direct IO and data journalling but it silently falls back
to buffered IO. Anyway new patch is attached.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--+QahgC5+KEYLbs62
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Make-test-272-work-for-ext3.patch"

>From 563edb54e3f3a45b5c92ab21bbe41deacef0ae39 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Aug 2012 11:14:35 +0200
Subject: [PATCH v2] Make test 272 work for ext3

ext3 does not support direct IO for files with data journalling. This
confuses test 272. Make the test check whether open succeeds and perform
the writing only if it does.

Thanks for Dave Chinner for suggesting a simpler way to fix the test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 272 |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/272 b/272
index 26dfa3b..7b142e2 100755
--- a/272
+++ b/272
@@ -32,6 +32,12 @@ tmp=/tmp/$$
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
+write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
+if [ $FSTYP = "ext3" ]; then
+	# ext3 doesn't support direct IO in journalling mode
+	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
+fi
+
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
@@ -40,7 +46,6 @@ _workout()
 	echo ""
 	echo " Switch data journalling mode"
 	echo ""
-	write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
 	chattr_opt_list="+j -j +jS -j"
 	idx=0
 	#
-- 
1.7.1


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--+QahgC5+KEYLbs62--
