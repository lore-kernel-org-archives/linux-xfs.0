Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB82PCOP123461 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 20:25:12 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F9E92A4657
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 18:25:10 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 3FBcOqp4SZ08BOsc for
	<xfs@oss.sgi.com>; Wed, 07 Dec 2011 18:25:10 -0800 (PST)
Message-ID: <4EE02022.5000403@cn.fujitsu.com>
Date: Thu, 08 Dec 2011 10:25:38 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
	<4EDF2133.7030702@cn.fujitsu.com> <20111207100748.GB14273@dastard>
In-Reply-To: <20111207100748.GB14273@dastard>
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
Cc: hch@infradead.org, xfs@oss.sgi.com


Dave Chinner said the following on 2011-12-7 18:07:
> 
> I think you misunderstand what I was saying - I was not suggesting
> removing the error messages at all, just filtering them with sed to
> ensure the output is always constant for the error different
> messages different platforms dump out.
> 

Thanks for your reply.
Sorry for misunderstanding your comments.

I make a new patch, please review, thanks.

When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
the error message should be "Invalid argument".

The patch fix as following:
  - "pwrite64: Invalid argument" will be replaced with "pwrite64: File too large"
  - "pread64: Invalid argument" will be replaced with "read 0/xxx bytes at offset <OFFSET>"
  - delete _filter_xfs_io
  - add auto group

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
---
 071   |   16 +++++++++++++---
 group |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/071 b/071
index be9b11b..7b6e402 100755
--- a/071
+++ b/071
@@ -53,6 +53,16 @@ _filter_off()
     sed -e "s/$1/<OFFSET>/g" | _filter_io
 }
 
+_filter_pwrite()
+{
+    sed -e "s/pwrite64: Invalid argument/pwrite64: File too large/g"
+}
+
+_filter_pread()
+{
+    sed -e "s/pread64: Invalid argument/read 0\/$bytes bytes at offset <OFFSET>/g" | _filter_io
+}
+
 write_block()
 {
     location=$1
@@ -66,15 +76,15 @@ write_block()
     echo "Writing $bytes bytes, offset is $words (direct=$direct)" | _filter_io
     echo "Writing $bytes bytes at $location $words (direct=$direct)" >>$seq.full
     $XFS_IO_PROG -c "pwrite $offset 512" $flags $SCRATCH_MNT/$seq \
-	2>&1 | _filter_off $offset | _filter_xfs_io | tee -a $seq.full
+	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pwrite
     xfs_bmap -v $SCRATCH_MNT/$seq >>$seq.full
 
     echo "Reading $bytes bytes (direct=$direct)" | _filter_io
     echo "Reading $bytes bytes at $location (direct=$direct)" >>$seq.full
     $XFS_IO_PROG -c "pread $offset $bytes" $flags $SCRATCH_MNT/$seq \
-	2>&1 | _filter_off $offset | _filter_xfs_io | tee -a $seq.full
+	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pread
 
-    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seq.full
+    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seq.full 2>&1
 
     echo | tee -a $seq.full
 }
diff --git a/group b/group
index 08d999a..b49c3b0 100644
--- a/group
+++ b/group
@@ -181,7 +181,7 @@ deprecated
 068 other auto
 069 rw udf auto quick
 070 attr udf auto quick
-071 rw
+071 rw auto
 072 rw auto prealloc quick
 073 copy auto
 074 rw udf auto
-- 
1.7.1


-- 
Best Regards,
Peng

> Have a look at the patch I sent earlier today for test 103 ([PATCH
> 2/2] xfstests: ln failure output has changed again) as an example of
> error message filtering for multi-platform (Irix and Linux are
> different) and multiple-version (coreutils v < 6 output is different
> to 6 <= v < 8 and the current 8.x is different again) support with a
> single golden image.
> 
> That is, the output in the golden image does not change, instead we
> use a filter to convert the known different error messages to match
> the error in the golden image. If the error message is different to
> what the filter catches or does not appear, then the test still
> fails as desired. Essentially the output filter encodes all the
> variants of the valid error messages for the given test....
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
