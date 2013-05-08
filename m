Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D57B29E12
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 09:34:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B36E304064
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 07:34:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 15deIZNqOeZW5tHS for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 07:34:14 -0700 (PDT)
Message-ID: <518A6265.5040404@sandeen.net>
Date: Wed, 08 May 2013 09:34:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests: fix incorrect redirect in generic/233
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
	<1367993066-9313-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367993066-9313-2-git-send-email-david@fromorbit.com>
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

On 5/8/13 1:04 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/233 attempts to direct output to tee, but instead of using a
> pipe it uses an append operator. Hence it leaves a file named "tee"
> in the root directory of the xfstests execution path. Just direct
> the output to the $seqres.full file rather than trying to tee it
> into the test output as well.
> 
> Reported-by: "Michael L. Semon" <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/233 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/233 b/tests/generic/233
> index 2b6cd2f..58b3672 100755
> --- a/tests/generic/233
> +++ b/tests/generic/233
> @@ -62,7 +62,7 @@ _fsstress()
>  -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
>  -n $count -d $out -p 7`
>  
> -	echo "fsstress $args" >> tee -a $seqres.full
> +	echo "fsstress $args" >> $seqres.full
>  	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $seqres.full | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
