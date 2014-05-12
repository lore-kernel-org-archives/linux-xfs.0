Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 433CF7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 18:01:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 160AB8F8071
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 16:01:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PqvuSRCV4QAFbUDV for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 16:01:49 -0700 (PDT)
Date: Tue, 13 May 2014 09:00:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfstests PATCH] loggen: remove deprecated header includes and
	add definition for XFS_TRANS_MAGIC
Message-ID: <20140512230049.GO26353@dastard>
References: <1399898795-12967-1-git-send-email-jlayton@poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399898795-12967-1-git-send-email-jlayton@poochiereds.net>
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
To: Jeff Layton <jlayton@poochiereds.net>
Cc: xfs@oss.sgi.com

On Mon, May 12, 2014 at 08:46:35AM -0400, Jeff Layton wrote:
> xfstests was failing to build on my rawhide box. The problem was that
> some of the headers included by loggen.c no longer exist in current
> releases. This just removes those includes and adds a conditional
> definition of XFS_TRANS_MAGIC.
> 
> It may make more sense to just move XFS_TRANS_MAGIC to a different
> header, but this seems to work on both f20 and rawhide boxes.
> 
> Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
> ---
>  src/loggen.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/src/loggen.c b/src/loggen.c
> index 522c9178ee26..1740732249b6 100644
> --- a/src/loggen.c
> +++ b/src/loggen.c
> @@ -26,8 +26,6 @@
>   */
>  
>  #include <xfs/libxfs.h>
> -#include <xfs/xfs_log.h>
> -#include <xfs/xfs_log_priv.h>
>  
>  #ifndef ASSIGN_ANY_LSN_DISK
>  #define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \
> @@ -37,6 +35,10 @@
>      }
>  #endif
>  
> +#ifndef XFS_TRANS_MAGIC
> +#define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
> +#endif

It's now defined as XFS_TRANS_HEADER_MAGIC, and defined in
xfs/xfs_log_format.h.

So, some autoconf magic, perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
