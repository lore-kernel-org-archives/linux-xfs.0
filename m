Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D2SJVH064058 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 21:28:20 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TJfkeyU8sW6V3ZsK for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 19:28:18 -0700 (PDT)
Date: Wed, 13 Jun 2012 12:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: rename log structure and remove xlog_t typedef.
Message-ID: <20120613022815.GR22848@dastard>
References: <4FD78236.6010109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD78236.6010109@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 12, 2012 at 12:53:58PM -0500, Mark Tinguely wrote:
> From: Mark Tinguely <tinguely@sgi.com>
> 
> Rename the log structure to xlog and drop the xlog_t type definition.
> This will make it easier to distinguish the XFS log from other logs
> in Linux.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Couple of things - it looks like you mailer has line wrapped the
patch. When you repost it, can you make sure it isn't line wrapped?

> ---
>  fs/xfs/xfs_log.c         |  130
> +++++++++++++++++++++++------------------------

e.g. That's a linewrapped line....

> @@ -1055,7 +1055,7 @@ xlog_iodone(xfs_buf_t *bp)
> 
>  STATIC void
>  xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
> -			   xlog_t	*log)
> +			   struct xlog	*log)
>  {
>  	int size;
>  	int xhdrs;

When we modify function headers in non-standard formats, we tend to
convert them at the same time to the standard format and remove all
the typedefs. i.e:

 STATIC void
-xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
-			   xlog_t	*log)
+xlog_get_iclog_buffer_size(
+	struct xfs_mount	*mp,
+	struct xlog		*log)
 {

Note that I'm only suggesting removing all the other typedefs for the
functions that you need to reformat, not every single one that has a
xlog_t->struct xlog transformation. ;)

The log is one of the few places left that has non-standard function
formats, so can you go through the patch and convert all the
functions that are touched and convert them fully? This way we
slowly improve the code as we go, and seeing as this is pretty much
a cleanup patch it makes sense to do this at the same time....

Otherwise it looks fine. Thanks for taking a shot at this, Mark.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
