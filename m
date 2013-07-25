Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35E5F7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 23:36:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F2768F8033
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 21:36:37 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id XsfPdAfyVtSkDxbz
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 21:36:36 -0700 (PDT)
Message-ID: <51F0AB56.7020705@hardwarefreak.com>
Date: Wed, 24 Jul 2013 23:36:38 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 091, 240, 268 fix for xfs on 4k sector hard
	drive
References: <20130724143208.34b77534@oracle.com>
	<20130724235739.GR19986@dastard>
In-Reply-To: <20130724235739.GR19986@dastard>
Reply-To: stan@hardwarefreak.com
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
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On 7/24/2013 6:57 PM, Dave Chinner wrote:
> On Wed, Jul 24, 2013 at 02:32:08PM -0400, Dwight Engen wrote:
>> Tests 091,240, and 268 are failing on my 4k sector hard disk. The dio writes
>> from fsx and aiodio_sparse2 are failing on xfs with EINVAL which is returned
>> from the check at the top of xfs_file_dio_aio_write().
>>
>> The fix is to use blockdev -getpbsz to get the physical sector size instead
>> of the logical sector size. This makes 091 and 268 work. 240 will not run
>> on a 4k drive since fs block size == device block size. Tested against
>> xfs,ext4, and btrfs.
> 
> What's the logical sector size of the drive? If it's 4k, then
> blockdev --getss should be returning 4k. If it's not, then either
> the drive is reporting that it supports 512 bytes sectors when it
> doesn't (i.e. the drive is broken) or blockdev is returning the
> wrong information (i.e. blockdev is broken)....
> 
> What does mkfs.xfs output on that device?
> 
>>  rm -f $TEST_DIR/aiodio_sparse
>>  
>> -logical_block_size=`blockdev --getss $TEST_DEV`
>> +logical_block_size=`blockdev --getpbsz $TEST_DEV`
> 
> FWIW, that doesn't make much sense - putting the physical block size
> into a variable named "logical_block_size".....
> 
> Cheers,
> 
> Dave.

AFAIK there are no native 4K sector drives on the market yet.  All of
the currently shipping models with physical 4K sectors are "Advanced
Format" drives.  The Advanced Format standard specifies 4K physical
sectors -internal- to the drive, but with traditional 512B LBA addressing.

Dwight, what disk drive is this in question?  Make/model?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
