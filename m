Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83Gc1pH114883 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 11:38:11 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3C37304093
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 09:38:58 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: use correct log reservation when handling ENOSPC
	inxfs_create
Date: Thu, 3 Sep 2009 11:35:41 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AC27@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090826113736.GA15562@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
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

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
