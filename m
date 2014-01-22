Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F36A07F87
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 10:56:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCC2B8F8059
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:56:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id W9ZoJJLrqbuDECsr for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 08:55:59 -0800 (PST)
Message-ID: <52DFF81E.3030802@sandeen.net>
Date: Wed, 22 Jan 2014 10:55:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: define $seqres in btrfs/026-029
References: <1390404738-387-1-git-send-email-koen.de.wit@oracle.com>
In-Reply-To: <1390404738-387-1-git-send-email-koen.de.wit@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com

On 1/22/14, 9:32 AM, Koen De Wit wrote:
> I forgot to define $seqres in btrfs/026-029. As a result, a file named
> .full was created in the current working directory. Fix it.
> ---
>  tests/btrfs/026 |    1 +
>  tests/btrfs/027 |    1 +
>  tests/btrfs/028 |    1 +
>  tests/btrfs/029 |    1 +
>  4 files changed, 4 insertions(+), 0 deletions(-)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

presumably we can add your signed-off-by?  ;)

I wonder if this can't be done in the common scripts:

# grep -h seqres= tests/*/??? | sort | uniq -c
    349 seqres=$RESULT_DIR/$seq

rather than doing it in every single test ...

-Eric

> 
> diff --git a/tests/btrfs/026 b/tests/btrfs/026
> index bf6f528..6c54590 100644
> --- a/tests/btrfs/026
> +++ b/tests/btrfs/026
> @@ -26,6 +26,7 @@
>  #
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/027 b/tests/btrfs/027
> index d76bb0f..b2dff1c 100644
> --- a/tests/btrfs/027
> +++ b/tests/btrfs/027
> @@ -26,6 +26,7 @@
>  #-----------------------------------------------------------------------
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/028 b/tests/btrfs/028
> index 06d2faf..f17f102 100644
> --- a/tests/btrfs/028
> +++ b/tests/btrfs/028
> @@ -24,6 +24,7 @@
>  #-----------------------------------------------------------------------
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> diff --git a/tests/btrfs/029 b/tests/btrfs/029
> index 1fd2a93..b93b6df 100644
> --- a/tests/btrfs/029
> +++ b/tests/btrfs/029
> @@ -29,6 +29,7 @@
>  #-----------------------------------------------------------------------
>  
>  seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  here=`pwd`
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
