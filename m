Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BC297F54
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:59:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3937AC00A
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:59:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8NVfZUL5tUdkYn6E for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 10:59:57 -0800 (PST)
Message-ID: <52851DAC.2040804@sandeen.net>
Date: Thu, 14 Nov 2013 12:59:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest generic/280: wait for setquota to finish before
	umount
References: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
In-Reply-To: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
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
To: Guangyu Sun <guangyu.sun@oracle.com>, xfs@oss.sgi.com

On 10/24/13, 12:56 PM, Guangyu Sun wrote:
> While running xfstest 280, we occasionally got such error:
> 
>   setquota: Cannot set quota for user 0 from kernel on
>   /dev/mapper/xfstests-disk1: No such device
>   setquota: Cannot write quota for 0 on /dev/mapper/xfstests-disk1: No such
>   device
> 
> setquota calls syscall quotactl, and the kernel will wait for the filesystem
> to unfreeze and then performs command. Then kernel will double check if the
> device is still mounted. If not, an ENODEV will be thrown.
> 
> While in the testcase, unfreeze and umount might be so close that the device
> got umounted before quotactl is performed.
> 
> Reported-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>

Wanted to make sure the sleep didn't disturb the deadlock it's testing,
and it doesn't.  So:

Reviewed-by: Eric Sandeen <sandeen@redaht.com>

Thanks,
-Eric

> ---
>  tests/generic/280 |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/generic/280 b/tests/generic/280
> index 5491a6b..815a2c5 100755
> --- a/tests/generic/280
> +++ b/tests/generic/280
> @@ -63,6 +63,7 @@ xfs_freeze -f $SCRATCH_MNT
>  setquota -u root 1 2 3 4 $SCRATCH_MNT &
>  sleep 1
>  xfs_freeze -u $SCRATCH_MNT
> +sleep 1
>  umount $SCRATCH_DEV
>  
>  # Failure comes in the form of a deadlock.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
