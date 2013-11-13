Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30D0B7F51
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 02:04:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 06FDC8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:04:09 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ib61eBa4WMXVDitm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 00:04:08 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAD8477E026252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:04:08 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAD846OR024228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:04:07 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAD845gV016800 for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:04:06 GMT
Message-ID: <52833272.8060507@oracle.com>
Date: Wed, 13 Nov 2013 12:04:02 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Guangyu Sun <guangyu.sun@oracle.com>


On 10/24/2013 09:56 PM, Guangyu Sun wrote:
> While running xfstest 280, we occasionally got such error:
>
>    setquota: Cannot set quota for user 0 from kernel on
>    /dev/mapper/xfstests-disk1: No such device
>    setquota: Cannot write quota for 0 on /dev/mapper/xfstests-disk1: No such
>    device
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
> ---
>   tests/generic/280 |    1 +
>   1 file changed, 1 insertion(+)
Hi!

Could anybody review this?

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
