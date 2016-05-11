Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5B317CA1
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:04:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 690F2AC005
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:04:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9zTTqwHjd6eDNXMk for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 09:04:30 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0A236873
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:04:30 -0500 (CDT)
Subject: Re: [PATCH] xfs/133 134: filter redundant projid 0 quota report
References: <1462979156-7648-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e0126658-70f7-f8f9-d3bd-a47df2c6ce96@sandeen.net>
Date: Wed, 11 May 2016 11:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <1462979156-7648-1-git-send-email-zlang@redhat.com>
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
To: xfs@oss.sgi.com

On 5/11/16 10:05 AM, Zorro Lang wrote:
> After GETNEXTQUOTA ioctl be supported, xfs_quota -c "report" always
> outputs one more quota info about default quota (as project ID 0).
> For fix this problem, xfsprogs has merged commit 3d607a1.

This is only for project quota, right?  user & group quota always
reports id 0 / root, because it exists in the passwd and group files.

> Now xfstests face this same problem from this issue. xfs/133 and
> xfs/134 can't match their golden output, due to this one more line
> quota report output. So this patch filter this redundant quota info.

It seems to do more than filter; see below.

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> Hi,
> 
> We found this problem when:
> http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968
> 
> But we didn't make a suitable decision about how to deal with it. Then
> Eryu hit this problem again and wrote a patch for xfstests:
> http://oss.sgi.com/archives/xfs/2016-04/msg00002.html
> 
> This pushed us decide to fix this problem. Now xfsprogs commit 3d607a1
> has been merged to resolve this problem. But after that xfstests still
> face one more line quota report problem, so I modify some code of Eryu's
> old patch, and send this new patch for fix that.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/133 |  3 ++-
>  tests/xfs/134 | 27 +++++++++++++++++----------
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/tests/xfs/133 b/tests/xfs/133
> index 82c38b1..ebf008b 100755
> --- a/tests/xfs/133
> +++ b/tests/xfs/133
> @@ -67,6 +67,7 @@ EOF
>  
>  	cat >$tmp.projid <<EOF
>  $qa_project:10
> +root:0
>  EOF
>  
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> @@ -81,7 +82,7 @@ EOF
>  
>  	echo "=== report command output ==="
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> -		-c "report -p -N -b" $SCRATCH_MNT | _filter_quota
> +		-c "report -p -N -b" $SCRATCH_MNT | _filter_quota | grep -v "^root "
>  }
>  
>  # Test project
> diff --git a/tests/xfs/134 b/tests/xfs/134
> index be18ee8..a46a734 100755
> --- a/tests/xfs/134
> +++ b/tests/xfs/134
> @@ -52,14 +52,15 @@ _require_test
>  _require_xfs_quota
>  
>  dir=$SCRATCH_MNT/project
> +proj_num=1
>  
>  #project quota files
>  cat >$tmp.projects <<EOF
> -1:$dir
> +${proj_num}:$dir
>  EOF
>  
>  cat >$tmp.projid <<EOF
> -test:1
> +test:${proj_num}
>  EOF

What is the reason for these changes?

>  cp /dev/null $seqres.full
> @@ -87,17 +88,24 @@ fi
>  src/feature -p $SCRATCH_DEV
>  [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
>  
> +report_quota()
> +{
> +    $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +		    -c "repquota -inN -p -L $proj_num -U $proj_num" \
> +		    $SCRATCH_DEV | tr -s '[:space:]'
> +}

Oh, ok, so you can directly query only one ID.

Well, this changes the behavior of the test a bit; it no longer exercises
the getnextquota path, and instead specifically queries a single id.
That seems like a fairly significant change to the test, when the 
patch claims to simply filter out projid 0.

Why not just do it as an actual filter, i.e.:



diff --git a/common/filter b/common/filter
index 1be377c..2012729 100644
--- a/common/filter
+++ b/common/filter
@@ -302,6 +302,13 @@ _filter_quota()
 	sed -e 'N;s/TEST_DEV\n/TEST_DEV/g'
 }
 
+_filter_project_quota()
+{
+	# Project ID 0 is always present on disk but was not reported
+	# until the GETNEXTQUOTA ioctl came into use.  Filter it out.
+	_filter_quota | grep -v "^\#0"
+}
+
 # Account for different "ln" failure messages
 _filter_ln()
 {
diff --git a/tests/xfs/133 b/tests/xfs/133
index 82c38b1..5148c50 100755
--- a/tests/xfs/133
+++ b/tests/xfs/133
@@ -77,11 +77,12 @@ EOF
 
 	echo "=== quota command output ==="
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid \
-		-c "quota -p -v -b $qa_project" $SCRATCH_MNT | _filter_quota
+		-c "quota -p -v -b $qa_project" $SCRATCH_MNT \
+		| _filter_project_quota
 
 	echo "=== report command output ==="
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-		-c "report -p -N -b" $SCRATCH_MNT | _filter_quota
+		-c "report -p -N -b" $SCRATCH_MNT | _filter_project_quota
 }
 
 # Test project
diff --git a/tests/xfs/134 b/tests/xfs/134
index be18ee8..dff8cf5 100755
--- a/tests/xfs/134
+++ b/tests/xfs/134
@@ -87,17 +87,25 @@ fi
 src/feature -p $SCRATCH_DEV
 [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
 
+report_quota()
+{
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "repquota -inN -p -L $proj_num -U $proj_num" \
+		$SCRATCH_DEV | tr -s '[:space:]' \
+		| _filter_project_quota
+}
+
 mkdir $dir
 $XFS_IO_PROG -r -c "chproj -R 1" -c "chattr -R +P" $dir
 
 xfs_quota -D $tmp.projects -P $tmp.projid -x \
     -c "limit -p bsoft=100m bhard=100m 1" $SCRATCH_DEV
-xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
+report_quota
 touch $dir/1
 touch $dir/2
 cp $dir/2 $dir/3
 
-xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
+report_quota
 
 if [ "$HOSTOS" == "IRIX" ] ; then
     mkfile 1M $TEST_DIR/6
@@ -107,12 +115,12 @@ fi
 
 #try cp to dir
 cp $TEST_DIR/6 $dir/6
-xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
+report_quota
 
 #try mv to dir
 mv $TEST_DIR/6 $dir/7
 
-xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
+report_quota
 
 # success, all done
 status=0



-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
