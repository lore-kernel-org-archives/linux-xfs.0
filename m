Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB7LiVW6115477 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 15:44:32 -0600
Date: Wed, 7 Dec 2011 15:44:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 01/19] xfs: remove the deprecated nodelaylog option
Message-ID: <20111207214453.GR29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215852.699758135@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215852.699758135@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:07PM -0500, Christoph Hellwig wrote:
> The delaylog mode has been the default for a long time, and the nodelaylog
> option has been scheduled for removal in Linux 3.3.  Remove it and code
> only used by it now that we have opened the 3.3 window.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good, one comment below.
Reviewed-by: Ben Myers <bpm@sgi.com>

> Index: xfs/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_cil.c	2011-11-28 09:13:10.684813018 +0100
> +++ xfs/fs/xfs/xfs_log_cil.c	2011-11-28 09:17:38.320029780 +0100
> @@ -44,10 +44,6 @@ xlog_cil_init(

>  	struct xfs_cil	*cil;
>  	struct xfs_cil_ctx *ctx;
>  
> -	log->l_cilp = NULL;
> -	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
> -		return 0;
> -

There is a section of comment above xlog_cil_init that only applies if
we could still switch the CIL off.  It should be removed with this
patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
