Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O5wirB179299 for <xfs@oss.sgi.com>; Fri, 24 Aug 2012 00:58:45 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id aeWKb0QD7Ap3GynC for
	<xfs@oss.sgi.com>; Thu, 23 Aug 2012 22:59:30 -0700 (PDT)
Message-ID: <50371623.9040505@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 13:50:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: fix wrong number of the required devices
	and add independent device check for case 265
References: <5036F1FB.80205@cn.fujitsu.com> <20120824041804.GB19235@dastard>
In-Reply-To: <20120824041804.GB19235@dastard>
Reply-To: miaox@cn.fujitsu.com
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
Cc: anand.jain@oracle.com, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On fri, 24 Aug 2012 14:18:04 +1000, Dave Chinner wrote:
> On Fri, Aug 24, 2012 at 11:16:11AM +0800, Miao Xie wrote:
>> Case 265 need 4 devices to test RAID10, so we need 4 or more devices not 2.
>> and it is better that these 4 devices are independent devices, especially
>> the 2nd last one, so we add independent device check to check the devices
>> in SCRATCH_DEV_POOL.
> 
> I don't see any reason for requiring the devices to be independent.

README said we need independent devices. I think the reason is:
Case 265 will remove/add the 2nd last device in SCRATCH_DEV_POOL, if this device
is a partition of a device, not a independent device, it is easy to make a mistake
for the users that the other partitions are used while doing the test. If so,
the name of the device will be changed, and it will make the next test cases fail.

> You're basically checking if the devices are on an MD device, which
> isn't really a check for indpendent devices. e.g. my 4 devices could
> be loopback devices with files all the in the same filesystem, or on
> a VM using images at that are all hosted on the same device, or LVM
> volumes on top of a single MD device, hardware lun, etc. They are
> most certainly not independent, but your test won't pick up any of
> them.

The check _require_deletable_scratch_dev_pool will make sure the device is not
a virtual device. My check just make sure the devices are not partitions.
Maybe I should change the name of the my check.

P.S. I made a mistake, I needn't take the soft raid into account because
the soft raid devices are also virtual disks.

> Hence the test does not require the devices to be independent to run
> correctly.  Sure, the test will run faster if each device is on an
> independent spindle, but it's not a requirement for test success or
> failure....
> 
>> diff --git a/common.rc b/common.rc
>> index 602513a..ede25fe 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -1699,12 +1699,14 @@ _require_scratch_dev_pool()
>>  		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
>>  	fi
>>  
>> -	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
>> +	# btrfs test case needs 4 or more scratch_dev_pool; other FS not sure
>>  	# so fail it
>> +	# common.config has moved the first device to SCRATCH_DEV, so
>> +	# SCRATCH_DEV_POOL should have 3 or more disks.
>>  	case $FSTYP in
>>  	btrfs)
>> -		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
>> -			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
>> +		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 3 ]; then
>> +			_notrun "btrfs and this test needs 4 or more disks in SCRATCH_DEV_POOL"
>>  		fi
>>  	;;
>>  	*)
> 
> Rather than changing this every time a new number of disks is
> required, change it so that the number of devices required by the
> test is passed as a parameter to _require_scratch_dev_pool.

Yes, I'll update my patch.

Thanks
Miao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
