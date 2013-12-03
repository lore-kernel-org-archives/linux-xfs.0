Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 479047F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 18:53:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33A298F8089
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:53:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Dvk4AqEcLT2Zn4jR for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 16:53:14 -0800 (PST)
Date: Tue, 3 Dec 2013 11:53:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfstests: introduce xfs/324 to verify turn
	group/project quota off along with fsstress
Message-ID: <20131203005308.GK10988@dastard>
References: <52983C4B.1090202@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52983C4B.1090202@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 29, 2013 at 03:03:39PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce xfs/324 to verify that we can turn group/project quotas off
> while user quota is on and fsstress is running.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
....
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_xfs_quota
> +_require_xfs_crc_sb

Hmmm, now that I look at the way you are using _require_xfs_crc_sb,
it's broken. The scratch device is in an undefined state until a
test runs _scratch_mkfs on it.

What you need to do is check whether mkfs supports "-m crc=1", and
then mkfs the scratch device with that option set.

> +
> +_qmount_option "uquota,gquota,pquota"
> +
> +STRESS_DIR=$SCRATCH_MNT/testdir
> +

Where do you mkfs the scratch device?

> +_exercise()
> +{
> +	type=$1
> +
> +	_qmount
> +	mkdir -p $STRESS_DIR
> +
> +	$FSSTRESS_PROG -d $STRESS_DIR -n 100 -p 1000 $FSSTRESS_AVOID >>/dev/null 2>&1 &

There's no real reason for creating a load of 1000 processes here.
Half of them won't even get started before this:

> +	xfs_quota -x -c "off -$type" $SCRATCH_DEV

is run.

> +	killall -q $FSSTRESS_PROG
> +	wait

and then you kill them straight away.

> +	rm -rf $STRESS_DIR
> +	umount $SCRATCH_MNT

You don't need this if you just scratch_mkfs the device between
tests.

So, wouldn't it be better to do:

	scratch_mkfs -m crc=1
	_qmount
	mkdir -p $STRESS_DIR
	$FSSTRESS_PROG -d $STRESS_DIR -n 1000 -p 100 $FSSTRESS_AVOID >>/dev/null 2>&1 &
	sleep 10
	xfs_quota -x -c "off -$type" $SCRATCH_DEV
	sleep 5
	killall -q $FSSTRESS_PROG
	wait

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
