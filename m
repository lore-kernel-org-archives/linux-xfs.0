Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 784397F4E
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 07:32:30 -0500 (CDT)
Message-ID: <5194D1FB.90004@sgi.com>
Date: Thu, 16 May 2013 07:32:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: quota not supported on realtime filesystems
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/08/2013 08:21 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Realtime XFS filesystems do not support quotas, so quota tests
> always fail on such filesystems. Add a check to _require_quota to
> detect this situation and notrun the quota tests...
>
> Also, fix _require_xfs_quota and _require_prjquota to have the same
> checks.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   common/quota |   15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/common/quota b/common/quota
> index fd5374f..b320cf2 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -40,6 +40,12 @@ _require_quota()
>   	if [ ! -f /proc/fs/xfs/xqmstat ]; then
>   	    _notrun "Installed kernel does not support XFS quotas"
>           fi
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
> +	    _notrun "Quotas not supported on realtime test device"
> +	fi
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +	    _notrun "Quotas not supported on realtime scratch device"
> +	fi
>   	;;
>       *)
>   	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
> @@ -62,6 +68,12 @@ _require_xfs_quota()
>   {
>       src/feature -q $TEST_DEV
>       [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS quota"
> +    if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
> +	_notrun "Quotas not supported on realtime test device"
> +    fi
> +    if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +	_notrun "Quotas not supported on realtime scratch device"
> +    fi
>       [ -n $XFS_QUOTA_PROG ] || _notrun "XFS quota user tools not installed"
>   }
>
> @@ -73,6 +85,9 @@ _require_prjquota()
>       [ -n "$1" ] && _dev="$1" || _dev="$TEST_DEV"
>       src/feature -p $_dev
>       [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
> +    if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
> +	_notrun "Project quotas not supported on realtime filesystem"
> +    fi
>   }
>
>   #
>
Another nice cleanup patch, looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
