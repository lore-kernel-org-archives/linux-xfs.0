Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FEA17F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:39:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02CE6AC001
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:39:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RrDeyq7HenpV8cGh for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 12:39:34 -0800 (PST)
Date: Wed, 26 Feb 2014 07:39:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Message-ID: <20140225203922.GC13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-5-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355728-12056-5-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:15:27PM +0100, Lukas Czerner wrote:
> Define fallocate flags such as FALLOC_FL_PUNCH_HOLE and
> FALLOC_FL_ZERO_RANGE locally if they do not exist.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  ltp/fsx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index b3c30db..331257e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -35,8 +35,13 @@
>  #endif
>  #ifdef FALLOCATE
>  #include <linux/falloc.h>
> +#ifndef FALLOC_FL_PUNCH_HOLE
> +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> +#endif
> +#ifndef FALLOC_FL_ZERO_RANGE
> +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> +#endif
>  #endif

This pattern is appearing all over the place in xfstests now.  I'd
suggest that this should really be handled by autoconf,
include/config.h and src/globals.h....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
