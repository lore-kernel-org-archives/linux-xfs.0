Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LL3jjR030732 for <xfs@oss.sgi.com>; Fri, 21 May 2010 16:03:45 -0500
Subject: Re: [PATCH 09/12] xfs: Introduce delayed logging core code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1274138668-1662-10-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-10-git-send-email-david@fromorbit.com>
Date: Fri, 21 May 2010 16:06:03 -0500
Message-ID: <1274475963.2255.42.camel@doink>
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

On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The delayed logging code only changes in-memory structures and as
> such can be enabled and disabled with a mount option. Add the mount
> option and emit a warning that this is an experimental feature that
> should not be used in production yet.

I gave this a careful review.  I am a little surprised at
how nicely you could stitch this in, leveraging the existing
code, while still supporting the "old" logging model.

Anyway, I found some nits but no bugs so I'm not going
to bother mentioning them here.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> the necessary synchronisation for correct operation in both cases.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
