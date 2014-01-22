Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3250A7F5D
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 03:53:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADDC3AC002
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 01:53:17 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 73rZ76KnHph3VOJL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 01:53:16 -0800 (PST)
Message-ID: <52DF9503.6080708@oracle.com>
Date: Wed, 22 Jan 2014 17:53:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs/199: enforce v4 superblock format for test
References: <1390302628-19020-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1390302628-19020-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


On 01/21 2014 19:10 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This test relies of the contents of the sb_features2 field being
> known. Make sure ot clear allt eh MKFS_OPTIONS and ensure that we
> direct mkfs to create only the simplest of featuresets to test this
> functionality.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/199 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index 1d64e02..c1b5962 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -49,7 +49,10 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -_scratch_mkfs_xfs -l lazy-count=1 >/dev/null 2>&1
> +# clear any mkfs options so taht we can directly specify the options we need to
				^^^
				a typo...
> +# be able to test the features bitmask behaviour correctly.
> +MKFS_OPTIONS=
> +_scratch_mkfs_xfs -l lazy-count=1 -i projid32bit=0 >/dev/null 2>&1
>  
>  #
>  # Print the current flags.  Just a dummy so that the test breaks

Looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
