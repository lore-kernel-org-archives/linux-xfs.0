Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E2597F58
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 01:36:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F10BAC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 23:36:45 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6VcUIC8h9OTzskk5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 23:36:43 -0800 (PST)
Message-ID: <529D8A03.1060603@oracle.com>
Date: Tue, 03 Dec 2013 15:36:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: introduce xfs/324 to verify turn
	group/project quota off along with fsstress
References: <52983C4B.1090202@oracle.com> <20131203005308.GK10988@dastard>
In-Reply-To: <20131203005308.GK10988@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/03 2013 08:53 AM, Dave Chinner wrote:
> On Fri, Nov 29, 2013 at 03:03:39PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Introduce xfs/324 to verify that we can turn group/project quotas off
>> while user quota is on and fsstress is running.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ....
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +
>> +_require_scratch
>> +_require_xfs_quota
>> +_require_xfs_crc_sb
> 
> Hmmm, now that I look at the way you are using _require_xfs_crc_sb,
> it's broken. The scratch device is in an undefined state until a
> test runs _scratch_mkfs on it.
> 
> What you need to do is check whether mkfs supports "-m crc=1", and
> then mkfs the scratch device with that option set.
Got it.
> 
>> +
>> +_qmount_option "uquota,gquota,pquota"
>> +
>> +STRESS_DIR=$SCRATCH_MNT/testdir
>> +
> 
> Where do you mkfs the scratch device?
Oops, this problem must be concealed as it has ran against the environment
from previous test.
> 
>> +_exercise()
>> +{
>> +	type=$1
>> +
>> +	_qmount
>> +	mkdir -p $STRESS_DIR
>> +
>> +	$FSSTRESS_PROG -d $STRESS_DIR -n 100 -p 1000 $FSSTRESS_AVOID >>/dev/null 2>&1 &
> 
> There's no real reason for creating a load of 1000 processes here.
> Half of them won't even get started before this:
> 
>> +	xfs_quota -x -c "off -$type" $SCRATCH_DEV
> 
> is run.
> 
>> +	killall -q $FSSTRESS_PROG
>> +	wait
> 
> and then you kill them straight away.
> 
>> +	rm -rf $STRESS_DIR
>> +	umount $SCRATCH_MNT
> 
> You don't need this if you just scratch_mkfs the device between
> tests. 
> 
> So, wouldn't it be better to do:
> 
> 	scratch_mkfs -m crc=1
> 	_qmount
> 	mkdir -p $STRESS_DIR
> 	$FSSTRESS_PROG -d $STRESS_DIR -n 1000 -p 100 $FSSTRESS_AVOID >>/dev/null 2>&1 &
> 	sleep 10
> 	xfs_quota -x -c "off -$type" $SCRATCH_DEV
> 	sleep 5
> 	killall -q $FSSTRESS_PROG
> 	wait
Above problems will be fixed in next round of post.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
