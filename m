Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9LDBiiA212460 for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 08:11:44 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id 64AqHq4EV5cwN2kJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Oct 2012 06:13:26 -0700 (PDT)
Message-ID: <5083F4DD.1090600@oracle.com>
Date: Sun, 21 Oct 2012 21:13:01 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: get return value in seek_sanity_test
References: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
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
To: "wenqing.lz" <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 10/21/12 21:15, wenqing.lz wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> In seek_sanity_test getting return value is missing.  Thus we couldn't get the
> result unless someone read the log file (e.g. # 285).
>
> CC: Jeff Liu <jeff.liu@oracle.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> v2 <- v1:
> 	* put return value check below the run_test()
>
> Hi Jeff,
>
> Could you please review this patch again?  Thanks.
>
> Regards,
> Zheng
>
>  src/seek_sanity_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index 34f5508..3897f02 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -674,9 +674,9 @@ int main(int argc, char **argv)
>  		goto out;
>  
>  	for (i = 0; i < numtests; ++i) {
> +		ret = run_test(&seek_tests[i]);
>  		if (ret)
> -			goto out;
> -		run_test(&seek_tests[i]);
> +			break;
>  	}
>  
>  out:
Looks good to me, thank you!

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
