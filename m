Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FI0SCG202928 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 13:00:28 -0500
Subject: Re: [PATCH 15/18] xfs; pack xfs_buf structure more tightly
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-16-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-16-git-send-email-david@fromorbit.com>
Date: Wed, 15 Sep 2010 13:01:14 -0500
Message-ID: <1284573674.2452.14.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> pahole reports the struct xfs_buf has quite a few holes in it, so
> packing the structure better will reduce the size of it by 16 bytes.
> Also, move all the fields used in cache lookups into the first
> cacheline.
> 
> Before on x86_64:
> 
>         /* size: 320, cachelines: 5 */
> 	/* sum members: 298, holes: 6, sum holes: 22 */
> 
> After on x86_64:
> 
>         /* size: 304, cachelines: 5 */
> 	/* padding: 6 */
> 	/* last cacheline: 48 bytes */

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.h |   30 +++++++++++++++++++-----------
>  1 files changed, 19 insertions(+), 11 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
