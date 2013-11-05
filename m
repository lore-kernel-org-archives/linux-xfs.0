Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 630CE29DF9
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 06:42:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BCE7304062
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 04:42:30 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Izj8Zm5qSdeCj7ey (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 04:42:29 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rA5CgSZx001030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:42:28 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rA5CgRKI025298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:42:27 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rA5CgR1i022754 for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 12:42:27 GMT
Message-ID: <5278E7B0.5050803@oracle.com>
Date: Tue, 05 Nov 2013 16:42:24 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: added -P option to $DF_PROG
References: <20131028214444.GE2797@dastard>
	<1383038724-4365-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1383038724-4365-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Cc: vasily.isaenko@oracle.com


On 10/29/2013 01:25 PM, Stanislav Kholmanskikh wrote:
> Added -P option to $DF_PROG and changed the invocation of
> 'df' command in generic/{251,260,273,275} testcases
> with $DF_PROG.
>
> Otherwise the testcases will fail if the scratch
> device has a long name (for example, if it's an LVM volume).
> Because df outputs its usage stats with two lines:
>
> /dev/mapper/xfstests-disk1
>                         3030800      4608   2868908   1% /tmp/mnt/disk1
>
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>   
Hi!

Please, review.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
