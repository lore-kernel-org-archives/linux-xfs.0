Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GJGCGZ181608 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 14:16:12 -0500
Message-ID: <502D4703.3010603@sgi.com>
Date: Thu, 16 Aug 2012 14:16:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfstests: test 110 sometimes fails to unmount scratch
	dev
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/2012 03:35 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> It runs a bunch of rm processes in the background, then immediately
> calls _check_scratch_fs without waiting for them to complete, hence
> the unmount can fail with a busy filesystem error.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   110 |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/110 b/110
> index aad5835..c58e6c9 100755
> --- a/110
> +++ b/110
> @@ -69,6 +69,7 @@ do
>       let I=$I+1
>       [ $[$I % 1000] -eq 0 ] && echo "Created $I/$E"
>   done
#RCJ Yes wait for rm processes to complete
> +wait
>
>   sync
>
>
Looks good to me.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
