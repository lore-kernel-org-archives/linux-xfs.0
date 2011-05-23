Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NCpunM001355 for <xfs@oss.sgi.com>; Mon, 23 May 2011 07:51:56 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A61451625EBB
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 05:51:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uhoYL0NzCisLa4kz for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 05:51:54 -0700 (PDT)
Subject: Re: xfstests - SCRATCH_DIR mounted/unmounted twice when testing nfs
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <1305805778.8615.109.camel@dhcp-31-190.brq.redhat.com>
References: <1305722498.25226.110.camel@dhcp-31-190.brq.redhat.com>
	<20110519000202.GC32466@dastard>
	<1305805778.8615.109.camel@dhcp-31-190.brq.redhat.com>
Date: Mon, 23 May 2011 14:51:45 +0200
Message-ID: <1306155105.3091.68.camel@dhcp-31-190.brq.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, 2011-05-19 at 13:49 +0200, Boris Ranto wrote:
> On Thu, 2011-05-19 at 10:02 +1000, Dave Chinner wrote:
> > On Wed, May 18, 2011 at 12:41:38PM +0000, Boris Ranto wrote:
> > > Tests 124, 127 and 128 unmount their SCRATCH_DEV manually while using _cleanup_testdir in trapped cleanup function.
> > > This can lead to test fails due to double unmount on nfs where _cleanup_testdir unmounts SCRATCH_DEV.
> > > 
> > > Tests 129 and 130 use _setup_testdir and _scratch_mount that can lead to double mount on nfs where _setup_testdir mounts SCRATCH_DEV.
> > > 
> > > The least invasive patch (only nfs shall be affected by this patch) I could come up with that fixed this issue used conditional umounts in _cleanup_testdir and conditional mount/remount in _scratch_mount (remount was used so that mount flags do not get lost).
> > > 
> > From the code:
> > 
> > #
> > # Warning for UDF and NFS:
> > # this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
> > # which actually uses the scratch dir for the test dir.
> > #
> > # This was done because testdir was intended to be a persistent
> > # XFS only partition.  This should eventually change, and treat
> > # at least local filesystems all the same.
> > #
> > 
> > I think that this means that the way _setup_testdir uses the scratch
> > device was a nasty hack and was intended to be fixed at some point.
> > Perhaps we should actually understand the issue that lead to this
> > hack first, and then determine what is needed to fix it rather than
> > just layering more hacks on top of it?
> > 
> > > Alternatively, _setup_testdir could stop mounting SCRATCH_DEV but
> > > that would be probably too invasive.
> > 
> > I don't really care about how invasive fixing the problem
> > properly is if it's the better long term solution....
> 
> I also prefer that solution. The fix could be relatively simple: just
> treat nfs as regular local filesystem. The question is whether there are
> any test cases that depends on the old _setup_testdir behaviour.
> 
> Looking through the tests I found two tests that have nfs in their
> _supported_fs field: 062 and 192.
> 
> 062 expects scratch dev to be regular device and hence fails for nfs
> either way. Therefore restricting the test to xfs (maybe +udf) shouldn't
> cause any problems.
> 
> 192 uses TEST_DIR directly so it probably expects TEST_DIR to be mounted
> xfs filesystem, therefore just changing _supported_fs to xfs (maybe
> +udf) should be sufficient.
> 
> 
> > Cheers,
> > 
> > Dave.
> 
> 
> So far I could test the following patch (nfs only, udf unchanged) on few
> tests with success. I'll let it run for all the tests and report back
> later if it still makes sense.
> 
> diff --git a/062 b/062
> index 5cb6f92..83644be 100755
> --- a/062
> +++ b/062
> @@ -71,7 +71,7 @@ _create_test_bed()
>  }
>  
>  # real QA test starts here
> -_supported_fs xfs udf nfs
> +_supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
>  
> diff --git a/192 b/192
> index d8301d5..1e582d1 100755
> --- a/192
> +++ b/192
> @@ -45,7 +45,7 @@ _access_time()
>  
>  # real QA test starts here
>  
> -_supported_fs xfs udf nfs
> +_supported_fs xfs
>  _supported_os Linux
>  #delay=150
>  #delay=75
> diff --git a/common.rc b/common.rc
> index e634fbb..3d1a17b 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -302,7 +302,10 @@ _scratch_mkfs()
>          _scratch_mkfs_xfs $*
>  	;;
>      nfs*)
> -	# do nothing for nfs
> +       # clean scratch dir
> +       _scratch_mount
> +       rm -rf $SCRATCH_MNT/* $SCRATCH_MNT/.*
> +       _scratch_unmount
>  	;;
>      udf)
>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
> @@ -703,6 +706,10 @@ _require_scratch()
>  		 then
>  		     _notrun "this test requires a valid \$SCRATCH_DEV"
>  		 fi
> +		 if [ ! -d "$SCRATCH_MNT" ]
> +		 then
> +		     _notrun "this test requires a valid \$SCRATCH_MNT"
> +		 fi
>  		 ;;
>  	*)
>  		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
> @@ -1320,35 +1327,9 @@ _setup_udf_scratchdir()
>      testdir=$SCRATCH_MNT
>  }
>  
> -_setup_nfs_scratchdir()
> -{
> -    [ "$FSTYP" != "nfs" ] \
> -	&& _fail "setup_nfs_testdir: \$FSTYP is not nfs"
> -    [ -z "$SCRATCH_DEV" ] \
> -	&& _notrun "this test requires a valid host fs for \$SCRATCH_DEV"
> -    [ -z "$SCRATCH_MNT" ] \
> -	&& _notrun "this test requires a valid \$SCRATCH_MNT"
> -
> -    # mounted?
> -    if _mount | grep -q $SCRATCH_DEV
> -    then
> -        # if it's mounted, make sure its on $SCRATCH_MNT
> -        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
> -        then
> -            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT -
> aborting"
> -        fi
> -    	$UMOUNT_PROG $SCRATCH_DEV
> -    fi
> -
> -    _scratch_mkfs
> -    _scratch_mount
> -
> -    testdir=$SCRATCH_MNT
> -}
> -
>  #
> -# Warning for UDF and NFS:
> -# this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
> +# Warning for UDF:
> +# this function calls _setup_udf_scratchdir
>  # which actually uses the scratch dir for the test dir.
>  #
>  # This was done because testdir was intended to be a persistent
> @@ -1361,9 +1342,6 @@ _setup_testdir()
>      udf)
>  	_setup_udf_scratchdir
>  	;;
> -    nfs*)
> -	_setup_nfs_scratchdir
> -	;;
>      *)
>  	testdir=$TEST_DIR
>  	;;
> @@ -1377,10 +1355,6 @@ _cleanup_testdir()
>  	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
>  	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
>  	;;
> -    nfs*)
> -	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
> -	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
> -	;;
>      *)
>  	# do nothing, testdir is $TEST_DIR
>  	:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

I've tested the patch with all the tests. Since neither nfs TEST_DEV nor
SCRATCH_DEV are block devices tests 076 and 240 fail for nfs. All the
other tests worked fine for me.

This could be fixed by including _requrie_block_dev:

diff --git a/076 b/076
index e472b26..630d6f4 100755
--- a/076
+++ b/076
@@ -57,6 +57,7 @@ _supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
+_require_block_dev $SCRATCH_DEV
 
 echo "*** init fs"
 
diff --git a/240 b/240
index 563449e..11e5180 100755
--- a/240
+++ b/240
@@ -52,6 +52,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
+_require_block_dev $TEST_DEV
 
 echo "Silence is golden."
 
diff --git a/common.rc b/common.rc
index bc76812..5ea5a78 100644
--- a/common.rc
+++ b/common.rc
@@ -918,6 +918,15 @@ _require_sparse_files()
     esac
 }
 
+# Check if the device is block device
+#
+_require_block_dev()
+{
+       DEV=$1
+       [ "`_is_block_dev $DEV`" = "" ] && \
+               _notrun "Device $DEV is not block device"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
