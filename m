Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A2447F53
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 23:28:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8566AC004
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:28:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	m3iwUgQdEPahel11 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 21:28:33 -0800 (PST)
Date: Mon, 24 Feb 2014 16:28:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest generic/280: use waidpid instead of ugly sleep
Message-ID: <20140224052830.GL4317@dastard>
References: <1392972948-2463-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392972948-2463-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 21, 2014 at 12:55:48PM +0400, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  tests/generic/280 |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/generic/280 b/tests/generic/280
> index 815a2c5..7a2d1d0 100755
> --- a/tests/generic/280
> +++ b/tests/generic/280
> @@ -61,9 +61,10 @@ quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>  quotaon $SCRATCH_MNT 2>/dev/null
>  xfs_freeze -f $SCRATCH_MNT
>  setquota -u root 1 2 3 4 $SCRATCH_MNT &
> +pid=$!
>  sleep 1
>  xfs_freeze -u $SCRATCH_MNT
> -sleep 1
> +wait $pid
>  umount $SCRATCH_DEV

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
