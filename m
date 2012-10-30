Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WM061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:16 -0500
Date: Mon, 29 Oct 2012 18:00:28 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 08/25] xfs: verify AGFL blocks as they are read from disk
Message-ID: <20121030010027.GK30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-9-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:33:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add an AGFL block verify callback function and pass it into the
> buffer read functions.
> 
> While this commit adds verification code to the AGFL, it cannot be
> used reliably until the CRC format change comes along as mkfs does
> not initialise the full AGFL. Hence it can be full of garbage at the
> first mount and will fail verification right now. CRC enabled
> filesystems won't have this problem, so leave the code that has
> already been written ifdef'd out until the proper time.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)

Okee doke by me.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
