Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C9B729E07
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 09:37:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C2628F8074
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 07:37:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id E5YCeP350nCyTP0I for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 07:37:26 -0700 (PDT)
Message-ID: <518A6325.3030809@sandeen.net>
Date: Wed, 08 May 2013 09:37:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: quota not supported on realtime filesystems
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
	<1367993066-9313-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1367993066-9313-3-git-send-email-david@fromorbit.com>
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
> Realtime XFS filesystems do not support quotas, so quota tests
> always fail on such filesystems. Add a check to _require_quota to
> detect this situation and notrun the quota tests...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(PS why is USE_EXTERNAL a thing?  if it's set, shouldn't it be used?)

-Eric

> ---
>  common/quota |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/common/quota b/common/quota
> index fd5374f..3550cd4 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -40,6 +40,12 @@ _require_quota()
>  	if [ ! -f /proc/fs/xfs/xqmstat ]; then
>  	    _notrun "Installed kernel does not support XFS quotas"
>          fi
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
> +	    _notrun "Quotas not supported on realtime test device"
> +	fi
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +	    _notrun "Quotas not supported on realtime scratch device"
> +	fi
>  	;;
>      *)
>  	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
