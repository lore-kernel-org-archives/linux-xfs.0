Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADB657F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 00:59:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 351E3AC004
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 22:59:56 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GfqijVmJZUTjXr5N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 22:59:51 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB66xoMM009089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 06:59:51 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB66xnLb010953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 06:59:50 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB66xnZh023050 for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 06:59:49 GMT
Message-ID: <52A175DD.5050908@oracle.com>
Date: Fri, 06 Dec 2013 10:59:41 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
References: <20131107204635.GA22954@infradead.org>
In-Reply-To: <20131107204635.GA22954@infradead.org>
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


On 11/08/2013 12:46 AM, Christoph Hellwig wrote:
> For historical reasons beyond my knowledge xfstests tries to abuse the
> scratch device as test device for nfs and udf.  Because not all test
> have inherited the right usage of the _setup_testdir and _cleanup_testdir
> helpers this leads to lots of unessecary test failures.
>
> Remove the special casing, which gets nfs down to a minimal number of
> failures.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> diff --git a/common/rc b/common/rc
> index ea3af12..c64933a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -975,11 +975,7 @@ _require_scratch()
>   {
>       case "$FSTYP" in
>   	nfs*)
> -		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> -		 if [ -z "$SCRATCH_DEV" -o "$?" != "0" ]
> -		 then
> -		     _notrun "this test requires a valid \$SCRATCH_DEV"
> -		 fi
> +                 _notrun "requires a scratch device"
>   		 ;;
>   	*)
>   		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
> @@ -1773,100 +1769,6 @@ _full_platform_details()
>        echo "$os/$platform $host $kernel"
>   }
Hi!

Sorry for my post-commit "review".

But for what purposes did you delete this scratch device handling for nfs?
Now each test case that uses _require_scratch returns [not run].

It means most of the generic/ test cases.

I think we should revert this part of code. How do you think?

Thanks.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
