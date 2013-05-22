Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95F9B29DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:58:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C02AAC001
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 15:58:45 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	VNNSpDL7CagvTKWC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 15:58:44 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so6730319iec.36
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 15:58:43 -0700 (PDT)
Message-ID: <519D4D87.2070806@gmail.com>
Date: Wed, 22 May 2013 18:58:15 -0400
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

I have a simple _test_mount change in shared/243, tested and ready to 
post.  However, it may work the same either way.  AFAIK, the test seems 
to go like this:

xfs_io this;
if ( ext4 )
{
  umount;
  do some unmounted ext4 stuff;
  mount -t ${FSTYP} ...;
}
xfs_io that;
if ( ext4 )
{
  ...
}
...

So if it isn't ext4 being tested, $TEST_DEV is not umounted at all.
Until I got a closer look at this, it was a surprise to see the 
XFS+rtdev+logdev pass without changes.

The rest of your comments will be followed when I get home.  To use the 
external logdev means a 20%-30% improvement in some test results on XFS.
To get the other file systems to do this will certainly have me looking
at the $TEST_DEV mount and umount code anyway.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
