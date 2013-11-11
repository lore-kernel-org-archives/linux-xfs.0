Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 91B5C7F6F
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 05:10:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D5F9AC002
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 03:10:51 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id rpzB6x0PrSEZARFW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 03:10:50 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rABBAmQi028337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:10:49 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rABBAm25010279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:10:48 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rABBAmDB025364 for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:10:48 GMT
Message-ID: <5280BB33.4000508@oracle.com>
Date: Mon, 11 Nov 2013 19:10:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/273: use src/feature -o
References: <20131024010929.GR2797@dastard>
	<1384162494-17002-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1384162494-17002-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>, xfs@oss.sgi.com
Cc: vasily.isaenko@oracle.com

On 11/11, 2013 17:34 PM, Stanislav Kholmanskikh wrote:
> Due to partially committed series (fd080d64b6e9677cb9d0a15dc7e308b6ca0e273f)
> generic/273 test uses '_no_of_online_cpus' function which is not defined.
> 
> Now it's safe to switch it to 'src/feature -o'.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  tests/generic/273 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/generic/273 b/tests/generic/273
> index c028438..ab04dfa 100755
> --- a/tests/generic/273
> +++ b/tests/generic/273
> @@ -47,7 +47,7 @@ count=2
>  
>  _threads_set()
>  {
> -	_cpu_num=`_no_of_online_cpus`
> +	_cpu_num=`$here/src/feature -o`
>  	threads=$(($_cpu_num * 50))
>  	if [ $threads -gt 200 ]
>  	then
Looks good to me.
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
