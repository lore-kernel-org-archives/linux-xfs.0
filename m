Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E27E29E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 22:04:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6C9D78F8040
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 20:04:23 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	3Lyt8AJAdYSJpk0h (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 20:04:22 -0700 (PDT)
Received: by mail-ie0-f178.google.com with SMTP id b11so4138179iee.9
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 20:04:22 -0700 (PDT)
Message-ID: <519C3596.7080109@gmail.com>
Date: Tue, 21 May 2013 23:03:50 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: generic/258 questions (mount issue)...
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
In-Reply-To: <20130522012620.GA29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/21/2013 09:26 PM, Dave Chinner wrote:
> On Tue, May 21, 2013 at 08:43:13PM -0400, Michael L. Semon wrote:
>> Hi!  When using xfstests generic/258 with along with $TEST_RTDEV
>> $TEST_LOGDEV, it tends to scream bloody murder about corrupted
>> partitions and such.  In fact, the commands in the test seem to do
>> the right thing when executed by hand.  So once again, I grasped for
>> straws and came up with this:
>>
>> --- xfstests/tests/generic/258.orig	2013-05-21 20:19:38.430754829 -0400
>> +++ xfstests/tests/generic/258	2013-05-21 20:10:11.509021368 -0400
>> @@ -62,7 +62,7 @@
>>  # unmount, remount, and check the timestamp
>>  echo "Remounting to flush cache"
>>  umount $TEST_DEV
>> -mount $TEST_DEV $TEST_DIR
>> +_test_mount
>>
>>  # Should yield -315593940 (prior to epoch)
>>  echo "Testing for negative seconds since epoch"
>>
>> My questions are these:
>>
>> 1) Was there a better way to do this?
> 
> No, your change is correct. Can you clean up the description of the
> problem you had and add a Signed-off-by?
> 
>> 2) Not knowing the policy on umounting $TEST_DEV, could this have
>> been a test for $SCRATCH_DEV?
> 
> There are a handful of other tests that also unmount the TEST_DEV.
> Perhaps adding a _test_umount() wrapper to common/rc (similar to
> _scratch_umount) would be best. At least shared/243 needs the same
> _test_mount treatment as this test.
> 
> Cheers,
> 
> Dave.
> 

This is my first attempt at doing a `git format-patch --stdout`.  
Hopefully, this is somewhat more presentable to git.  Comments and 
brow-beating are welcome.

Thanks!

Michael

>From 7dc0667e1f8cd1c98f15ebf412dd0f038b55306e Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Tue, 21 May 2013 22:50:59 -0400
Subject: [PATCH] Change mount method for generic/258

Use the built-in _test_mount function from xfstests so it will use
the correct mount options for xfstests.  The script used a simple
umount-and-mount sequence, which caused a test failure on an XFS
filesystem that used both realtime and external log devices.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 tests/generic/258 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/258 b/tests/generic/258
index fb091ae..3aeb5ce 100755
--- a/tests/generic/258
+++ b/tests/generic/258
@@ -62,7 +62,7 @@ fi
 # unmount, remount, and check the timestamp
 echo "Remounting to flush cache"
 umount $TEST_DEV
-mount $TEST_DEV $TEST_DIR
+_test_mount
 
 # Should yield -315593940 (prior to epoch)
 echo "Testing for negative seconds since epoch"
-- 
1.8.2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
