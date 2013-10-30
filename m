Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 036B07F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 13:31:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2C9A8F8040
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 11:31:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iDQled2hD1cKiFx8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 11:31:18 -0700 (PDT)
Date: Wed, 30 Oct 2013 14:30:50 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] xfstests: generic/317 use relative paths to avoid traversal
	permission problems
Message-ID: <20131030143050.34a3b120@oracle.com>
In-Reply-To: <20131030162441.GA1112@infradead.org>
References: <20131024161235.GA29381@infradead.org>
	<20131024162557.6dd72435@oracle.com>
	<20131025093333.GB24583@infradead.org>
	<20131028114328.4b05e0ee@oracle.com>
	<20131030161955.GA28755@infradead.org>
	<20131030162441.GA1112@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 30 Oct 2013 09:24:41 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Oct 30, 2013 at 09:19:55AM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 28, 2013 at 11:43:28AM -0400, Dwight Engen wrote:
> > > Hi Cristoph, on my system (where fsgqa is id 501) the one liner
> > > the test is running is:
> > > 
> > > # ./src/nsexec -s -U -M "0 501 1000" -G "0 501 1000" ./src/lstat64
> > > Usage: lstat64 [-t] filename ...
> > 
> > The id here is 1000 and the following works just fine:
> > 
> > /src/nsexec -s -U -M "0 1000 1000" -G "0 1000 1000" ./src/lstat64
> > Usage: lstat64 [-t] filename ...
> 
> But:
> 
> ./src/nsexec -s -U -M "0 1000 1000" -G "0 501
> 1000" /root/xfstests/src/lstat64 execvp: Permission denied
> 
> 
> Which is probably due to:
> root@vm:~/xfstests# ls -ld ~ 
> drwx------ 6 root root 4096 Oct 30 16:24 /root
> 
> 
> Guess we need a relative path here?

Yep, that makes sense. I modeled this on 219 which was using
$here/src/lstat64 but didn't think about the fact that in my test fsgqa
might have traversal problems. I see plenty of other tests are using
relative paths so the following patch should (hopefully) fix 317 for you.
Thanks for tracking it down.

--

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 tests/generic/317 |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)
 mode change 100644 => 100755 tests/generic/317

diff --git a/tests/generic/317 b/tests/generic/317
old mode 100644
new mode 100755
index 6d8d3c4..f5d1b21
--- a/tests/generic/317
+++ b/tests/generic/317
@@ -46,8 +46,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/filter
 . ./common/attr
 
-nsexec=$here/src/nsexec
-lstat64=$here/src/lstat64
 file=$SCRATCH_MNT/file1
 
 # real QA test starts here
@@ -75,10 +73,10 @@ _filter_output()
 _print_numeric_uid()
 {
     echo "From init_user_ns"
-    $here/src/lstat64 $file |head -3 |_filter_output
+    src/lstat64 $file |head -3 |_filter_output
 
     echo "From user_ns"
-    $nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" $here/src/lstat64 $file |head -3 |_filter_output
+    src/nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" src/lstat64 $file |head -3 |_filter_output
 }
 
 umount $SCRATCH_DEV >/dev/null 2>&1
@@ -89,7 +87,7 @@ _scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
 chmod 777 $SCRATCH_MNT
 
 # create $file as "root" in userns, which is $qa_user in parent namespace
-$nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" touch $file
+src/nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" touch $file
 
 _print_numeric_uid
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
