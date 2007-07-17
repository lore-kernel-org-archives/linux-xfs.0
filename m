Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 22:03:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6H53Wbm013478
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 22:03:33 -0700
Message-ID: <469C4D9A.7080304@sgi.com>
Date: Tue, 17 Jul 2007 15:03:22 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Fwd: Re: xfs_fsr and null byte areas in files (fwd)
References: <Pine.LNX.4.64.0707151747390.21990@p34.internal.lan> <20070716070400.GU31489@sgi.com>
In-Reply-To: <20070716070400.GU31489@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------050004050904000400070000"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050004050904000400070000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> [Justin, thanks for the forward]
> 
>> Subject: Re: xfs_fsr and null byte areas in files
>> Date: Sonntag 15 Juli 2007
>> From: Martin Steigerwald <Martin@lichtvoll.de>
>> To: xfs@oss.sgi.com
>>
>>
>> Okay, trying once again. This time just with xfs@oss.sgi.com (no CC, no
>> nothing) as according to my test mail that seems to work best.
>>
>> Well maybe my build problem is already fixed. I will try on another day.
> 
> Your domain is on various RBLs so spamassassin scores are causing your
> mail to get classified as spam and are being dropped.
> 
>> Am Dienstag 10 Juli 2007 schrieb David Chinner:
>>> On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:
>>>> 1) Is there an XFS qa test available for xfs_fsr? If so I could use
>>>> that one. Are there some hints on how to get started on XFS qa?
>>> Yes, test 042. Download it from CVS, build it (installing all the
>>> bits it asks for ;), edit common.config to add your test and scratch
>> Hi,
>>
>> Do I need both partitions for test 42? On the notebook I have only one
>> free partition and since it is a primary partition and all primary
>> partitions are used up, I cannot split it.
> 
> Split the single partition with LVM. i.e. create a physvol using that
> partition and then create 2 logical volumes within it and use those.
> 

Test 042 really only needs the scratch partition and not the test
partition.
So alternatively, if you want to get out of doing the above, then
I've attached a hack patch to circumvent the testdir checks that
are normally done in xfstests.
(I wonder if ideally, we could have a _require_testdir like we do
for scratch, and so we are not forced to be dependent on it -
generally, though, the idea is that testdir will always be there
between qa runs)

>> I can try with an external USB harddrive and hope that this test setup is
>> similar enough to the situation that yielded my xfs_fsr problems.
>>
>>> partitions (both volatile) and the 'check -l 042' to run test 042.
>> In order to test xfs_fsr on my laptop I tried compiling XFS qa, but I get
>> a compiler error in dmapi. I do not know what dmapi is, well I read
>> something about "Data Management API runtime environment" on google and
>> thought I may not need it to run test 42. But I do not find any option
>> in "./configure" to disable buildin it.
>>
>> I am using:
>>
>> ---------------------------------------------------------------------
>> shambala:~#1> apt-show-versions | grep xfs
>> xfsprogs/sid uptodate 2.9.0-1
>> xfslibs-dev/sid uptodate 2.9.0-1
>> xfsdump/sid uptodate 2.2.45-1
>> ---------------------------------------------------------------------
> 
> $ sudo apt-get install libdm0 libdm0-dev
> 
> You probably also want libacl1, libacl1-dev, libattr, libattr1-dev
> libblkid1, libuuid1 and uuid-dev.....
> 
>> I used
>>
>> ---------------------------------------------------------------------
>> export CVSROOT=':pserver:cvs@oss.sgi.com:/cvs'
>> cvs checkout xfs-cmds
>> ---------------------------------------------------------------------
> 
> or you could build them all from xfs-cmds/acl .../attr .../dmapi, etc.
> 
>> to get xfsqa, then changed to the "xfs-cmds/xfs-tests" directory and
>> typed "make".
> 
> It's the prereqs that you are missing....
> 
If you take the build route, then remember to do
a "make install-dev" in the packages to get the headers installed.

--Tim

--------------050004050904000400070000
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="notestdir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="notestdir.patch"


===========================================================================
Index: xfstests/check
===========================================================================

--- a/xfstests/check	2007-07-17 14:51:52.000000000 +1000
+++ b/xfstests/check	2007-07-17 14:49:15.000000000 +1000
@@ -176,7 +176,7 @@ then
 fi
 
 seq="check"
-_check_test_fs
+#_check_test_fs
 
 [ -n "$TESTS_REMAINING_LOG" ] && echo $list > $TESTS_REMAINING_LOG
 
@@ -284,7 +284,7 @@ do
     [ -f $seq.notrun ] || try=`expr $try + 1`
     
     seq="after_$seq"
-    _check_test_fs
+    #_check_test_fs
 done
 
 interrupt=false

===========================================================================
Index: xfstests/common.config
===========================================================================

--- a/xfstests/common.config	2007-07-17 14:51:52.000000000 +1000
+++ b/xfstests/common.config	2007-07-17 14:45:24.000000000 +1000
@@ -579,16 +579,16 @@ else
     known_hosts
 fi
 
-echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
-    exit 1
-fi
-
-if [ ! -d "$TEST_DIR" ]; then
-    echo "common.config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
-    exit 1
-fi
+#echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+#if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
+#    echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+#    exit 1
+#fi
+#
+#if [ ! -d "$TEST_DIR" ]; then
+#    echo "common.config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
+#    exit 1
+#fi
 
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then

===========================================================================
Index: xfstests/common.rc
===========================================================================

--- a/xfstests/common.rc	2007-07-17 14:51:52.000000000 +1000
+++ b/xfstests/common.rc	2007-07-17 14:47:55.000000000 +1000
@@ -572,10 +572,10 @@ _require_scratch()
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
-		 if [ "`_is_block_dev $SCRATCH_DEV`" = "`_is_block_dev $TEST_DEV`" ]
-		 then
-		     _notrun "this test requires a valid \$SCRATCH_DEV"
-		 fi
+#		 if [ "`_is_block_dev $SCRATCH_DEV`" = "`_is_block_dev $TEST_DEV`" ]
+#		 then
+#		     _notrun "this test requires a valid \$SCRATCH_DEV"
+#		 fi
 		 ;;
 	nfs*|ext2|ext3|reiserfs)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
@@ -1212,7 +1212,8 @@ _test_inode_extsz()
 
 ################################################################################
 
-if [ "$iam" != new -a "$iam" != bench ]
+#if [ "$iam" != new -a "$iam" != bench ]
+if false
 then
     # make some further configuration checks here
 

--------------050004050904000400070000--
