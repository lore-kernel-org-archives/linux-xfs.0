Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83FjDCf111807 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 10:45:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8561D4240DF
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 08:46:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G4xMP3NhRTSWBdiJ for
	<xfs@oss.sgi.com>; Thu, 03 Sep 2009 08:46:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MjEVn-000532-5N
	for xfs@oss.sgi.com; Thu, 03 Sep 2009 15:46:11 +0000
Date: Thu, 3 Sep 2009 11:46:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use correct log reservation when handling ENOSPC
	in xfs_create
Message-ID: <20090903154611.GB16715@infradead.org>
References: <20090826113736.GA15562@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090826113736.GA15562@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Wed, Aug 26, 2009 at 07:37:36AM -0400, Christoph Hellwig wrote:
> We added the ENOSPC handling patch in xfs_create just after it got mered
> with xfs_mkdir.  Change the log reservation to the variable for either
> the create or mkdir value so it does the right thing if get here for creating
> a directory.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-08-24 11:35:52.794261954 -0300
> +++ xfs/fs/xfs/xfs_vnodeops.c	2009-08-24 11:36:25.466636450 -0300
> @@ -1479,8 +1479,8 @@ xfs_create(
>  	if (error == ENOSPC) {
>  		/* flush outstanding delalloc blocks and retry */
>  		xfs_flush_inodes(dp);
> -		error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
> -			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
> +		error = xfs_trans_reserve(tp, resblks, log_res, 0,
> +				XFS_TRANS_PERM_LOG_RES, log_count);
>  	}
>  	if (error == ENOSPC) {
>  		/* No space at all so try a "no-allocation" reservation */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
