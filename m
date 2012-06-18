Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5I3QJ7P118918 for <xfs@oss.sgi.com>; Sun, 17 Jun 2012 22:26:19 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aj5WUhInwMTn1DAm for <xfs@oss.sgi.com>;
	Sun, 17 Jun 2012 20:26:18 -0700 (PDT)
Resent-Message-ID: <20120618032616.GS19223@dastard>
Resent-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Date: Mon, 18 Jun 2012 12:23:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: refactor xfs_ialloc_ag_select
Message-ID: <20120618022311.GL19223@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144836.296927585@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144836.296927585@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:52AM -0400, Christoph Hellwig wrote:
> Loop over the in-core perag structures and prefer using pagi_freecount over
> going out to the AGI buffer where possible.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. One minor thing:

> @@ -901,13 +897,13 @@ xfs_dialloc(
>  	xfs_buf_t	**IO_agbp,	/* in/out ag header's buffer */
>  	xfs_ino_t	*inop)		/* inode number allocated */
>  {
> +	xfs_mount_t	*mp = tp->t_mountp;

struct xfs_mount

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
