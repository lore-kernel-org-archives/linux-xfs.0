Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9LC7AXg208873 for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 07:07:10 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id m7BvfWohvX3fqWru (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Oct 2012 05:08:51 -0700 (PDT)
Message-ID: <5083E5B8.8060304@oracle.com>
Date: Sun, 21 Oct 2012 20:08:24 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: get return value in seek_sanity_test
References: <1350819548-29634-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1350819548-29634-1-git-send-email-wenqing.lz@taobao.com>
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

Hi Zheng,

On 10/21/12 19:39, wenqing.lz wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> In seek_sanity_test getting return value is missing.  Thus we couldn't get the
> result unless someone read the log file (e.g. # 285).
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  src/seek_sanity_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index 34f5508..e3ed64a 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -676,7 +676,7 @@ int main(int argc, char **argv)
>  	for (i = 0; i < numtests; ++i) {
>  		if (ret)
>  			goto out;
> -		run_test(&seek_tests[i]);
> +		ret = run_test(&seek_tests[i]);
Thanks for the patch.
Looks there is another issue regarding the run_test loop, i.e, it should be:

    ret = run_test(&seek_tests[i]);
    if (ret)
        break;

Could you please fix it too?

Thanks,
-Jeff
>  	}
>  
>  out:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
