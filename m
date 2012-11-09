Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA93BXOH058831 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 21:11:33 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id FJKIDTlFB3lxGWOe
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Nov 2012 19:13:32 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id wz12so2614529pbc.26
	for <xfs@oss.sgi.com>; Thu, 08 Nov 2012 19:13:31 -0800 (PST)
Date: Fri, 9 Nov 2012 11:25:51 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] xfstests: get return value in seek_sanity_test
Message-ID: <20121109032551.GA28325@gmail.com>
References: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Jeff Liu <jeff.liu@oracle.com>, Zheng Liu <wenqing.lz@taobao.com>

On Sun, Oct 21, 2012 at 09:15:09PM +0800, wenqing.lz wrote:

ping?

Regards,
Zheng

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
> -- 
> 1.7.12.rc2.18.g61b472e
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
