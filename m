Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 757FF7F90
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 05:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E90F6AC009
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 03:58:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kXXV4A1fNUIZsDSH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 03:58:27 -0800 (PST)
Message-ID: <52E8ECDD.8050303@oracle.com>
Date: Wed, 29 Jan 2014 19:58:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: don't use TEST_DIR before initialized in
	generic/313
References: <1390950403-19755-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1390950403-19755-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com


On 01/29 2014 07:06 AM, Brian Foster wrote:
> The 'testfile' environment variable is initialized before the
> xfstests environment is included into generic/313. TEST_DIR is not
> defined at this point and causes the test to operate on the root.
> Move the testfile initialization down after the general environment
> is sourced.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  tests/generic/313 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/313 b/tests/generic/313
> index 1237ded..623c777 100755
> --- a/tests/generic/313
> +++ b/tests/generic/313
> @@ -29,7 +29,6 @@ seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> -testfile=$TEST_DIR/testfile.$seq
>  status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> @@ -47,6 +46,8 @@ _cleanup()
>  _supported_fs generic
>  _supported_os IRIX Linux
>  
> +testfile=$TEST_DIR/testfile.$seq
> +
>  echo "Silence is golden"
>  
>  $here/src/t_truncate_cmtime $testfile 2>&1

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
