Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97CE97F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E1F68F8064
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:24:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nONRRy1fJSoEVjwE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:24:06 -0700 (PDT)
Message-ID: <52708A25.80602@oracle.com>
Date: Wed, 30 Oct 2013 12:25:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix mkfs filter on xfs/096
References: <1383105535-28686-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1383105535-28686-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On 10/30/2013 11:58 AM, Dave Chinner wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> Needs to filter out the new ftype field.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/096 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/096 b/tests/xfs/096
> index 44b19b0..b2719bc 100755
> --- a/tests/xfs/096
> +++ b/tests/xfs/096
> @@ -87,6 +87,7 @@ _mkfs_filter()
>  	-e 's/\(realtime[ 	]*=\).*extsz/\1REALTIME               extsz/' \
>  	-e '/.*crc=/d' \
>  	-e 's/ *$//' \
> +	-e 's/ ftype=[01]//' \
>     | grep -v parent
>  }
>  

Looks good to me, thanks.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
