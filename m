Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P0B8Y7127530 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 19:11:08 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E58B6113ED2
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 17:11:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tn254WAsKhLLxNsF for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 17:11:06 -0700 (PDT)
Date: Thu, 25 Aug 2011 10:10:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: deprecate the nodelaylog mount option
Message-ID: <20110825001039.GJ3162@dastard>
References: <20110824055750.GA11175@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110824055750.GA11175@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2011 at 01:57:51AM -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/Documentation/feature-removal-schedule.txt
> ===================================================================
> --- xfs.orig/Documentation/feature-removal-schedule.txt	2011-08-24 07:45:56.450196165 +0200
> +++ xfs/Documentation/feature-removal-schedule.txt	2011-08-24 07:47:17.049759519 +0200
> @@ -592,3 +592,11 @@ Why:    In 3.0, we can now autodetect in
>  	interface that was used by acer-wmi driver. It will replaced by
>  	information log when acer-wmi initial.
>  Who:    Lee, Chun-Yi <jlee@novell.com>
> +
> +----------------------------
> +What:	The XFS nodelaylog mount option
> +When:	3.3
> +Why:	The delaylog mode that has been the default since 2.6.39 has proven
> +	stable, and the old code is in the way of additional improvements in
> +	the log code.
> +Who:	Christoph Hellwig <hch@lst.de>
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c	2011-08-24 07:47:53.696227656 +0200
> +++ xfs/fs/xfs/xfs_super.c	2011-08-24 07:48:53.249238363 +0200
> @@ -356,6 +356,8 @@ xfs_parseargs(
>  			mp->m_flags |= XFS_MOUNT_DELAYLOG;
>  		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
>  			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
> +			xfs_warn(mp,
> +	"nodelaylog is deprecated and will be removed in Linux 3.3");
>  		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
>  			mp->m_flags |= XFS_MOUNT_DISCARD;
>  		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {

No argument here. Getting rid of the old transaction commit code
would both siginficantly cleanup the code and enable lots of
interesting transaction optimisations to be made....

So it gets my thumbs-up.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
