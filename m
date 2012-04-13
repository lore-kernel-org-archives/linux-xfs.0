Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DBo0Jd035292 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 06:50:00 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HSJEwkf0XFpdwZN3 for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 04:49:59 -0700 (PDT)
Date: Fri, 13 Apr 2012 21:49:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfstests 198, 240: added check for aiodio-sparse2
Message-ID: <20120413114957.GO6734@dastard>
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
	<1334310586-2281-3-git-send-email-tmarek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334310586-2281-3-git-send-email-tmarek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tmarek@redhat.com
Cc: lczerner@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 11:49:44AM +0200, tmarek@redhat.com wrote:
> From: Tom Marek <tmarek@redhat.com>
> 
> Tests number 198 and 240 could fail when aiodio-sparse2 was not build.
> Check whether aiodio-sparse is built was added to both tests.
> 
> Signed-off-by: Tom Marek <tmarek@redhat.com>
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  198 |    2 ++
>  240 |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/198 b/198
> index e46ec8d..b9b47b2 100755
> --- a/198
> +++ b/198
> @@ -45,6 +45,8 @@ _cleanup()
>  _supported_fs generic
>  _supported_os Linux
>  
> +[-x $here/src/aio-dio-regress/aiodio_sparse2] || _notrun "src/aio-dio-regress/aiodio_sparse2 not built"
> +

_require_aiodio

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
