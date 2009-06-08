Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58MK5oE255132 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 17:20:05 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B5AFAC007
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 15:20:23 -0700 (PDT)
Message-Id: <CF93E8E0-7A01-465F-898B-016D9C8C5171@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A2D31E3.3090108@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: Allow fsx tests to run on generic filesystems
Date: Mon, 8 Jun 2009 17:20:22 -0500
References: <4A2D31E3.3090108@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>


On Jun 8, 2009, at 10:44 AM, Eric Sandeen wrote:

> There is already logic in 075 to gracefully skip nfs for fsx
> invocations with -x (xfs-specific preallocation) - just extend
> this to any non-xfs filesystem, and add to test 112 as well.
>
> Later we can change this behavior to use fallocate and include
> more filesystems but this gets some fsx coverage for now.
>
> Test 127 doesn't seem to have anything xfs-specific, so mark
> that as generic too.
>
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> diff --git a/075 b/075
> index 7948c1f..49d006d 100755
> --- a/075
> +++ b/075
> @@ -66,11 +66,11 @@ _do_test()
>     echo "fsx.$_n : $_filter_param"
>     echo "-----------------------------------------------"
>
> -    if [ "$FSTYP" = "nfs" ]
> +    if [ "$FSTYP" != "xfs" ]
>     then
> 	if [ "$_n" = "1" -o "$_n" = "3" ]
> 	then
> -	    # HACK: nfs don't handle preallocation (-x) so just skip this  
> test
> +	    # HACK: only xfs handles preallocation (-x) so just skip this  
> test
> 	    return
> 	fi
>     fi
> @@ -124,7 +124,7 @@ _process_args()
>
>
> # real QA test starts here
> -_supported_fs xfs udf nfs
> +_supported_fs generic
> _supported_os IRIX Linux
>
> size10=`expr 10 \* 1024 \* 1024`	# 10 megabytes
> diff --git a/112 b/112
> index 70fa487..d6c2952 100755
> --- a/112
> +++ b/112
> @@ -66,6 +66,15 @@ _do_test()
>     echo "fsx.$_n : $_filter_param"
>     echo "-----------------------------------------------"
>
> +    if [ "$FSTYP" != "xfs" ]
> +    then
> +        if [ "$_n" = "1" -o "$_n" = "3" ]
> +        then
> +            # HACK: only xfs handles preallocation (-x) so just  
> skip this test
> +            return
> +        fi
> +    fi
> +
>     # This cd and use of -P gets full debug on $here (not TEST_DEV)
>     cd $out
>     if ! $here/ltp/fsx $_param -P $here $seq.$_n >/dev/null
> @@ -113,7 +122,7 @@ _process_args()
>
>
> # real QA test starts here
> -_supported_fs xfs
> +_supported_fs generic
> _supported_os Linux
>
> [ -x $here/ltp/aio-stress ] || \
> diff --git a/127 b/127
> index 44db4fb..30f4fdb 100755
> --- a/127
> +++ b/127
> @@ -103,7 +103,7 @@ _fsx_std_mmap()
> }
>
> # real QA test starts here
> -_supported_fs xfs
> +_supported_fs generic
> _supported_os Linux
>
> _setup_testdir
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
