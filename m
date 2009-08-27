Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R6o89x069171 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 01:50:18 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6AE4530404E
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 23:51:01 -0700 (PDT)
Message-Id: <F4B636D7-71BF-46AB-825B-D3E93796F1E5@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090827031116.GA6147@infradead.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: merge fsync and O_SYNC handling
Date: Thu, 27 Aug 2009 01:22:15 -0500
References: <20090827031116.GA6147@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Aug 26, 2009, at 10:11 PM, Christoph Hellwig wrote:

> The guarantees for O_SYNC are exactly the same as the ones we need to
> make for an fsync call (and given that Linux O_SYNC is O_DSYNC the
> equivalent is fdadatasync, but we treat both the same in XFS), except
> with a range data writeout.  Jan Kara has started unifying these two
> path for filesystems using the generic helpers, and I've started to
> look at XFS.
>
> The actual transaction commited by xfs_fsync and  
> xfs_write_sync_logforce
> has a different transaction number, but actually is exactly the same.
> We'll only use the fsync transaction going forward.  One major  
> difference
> is that xfs_write_sync_logforce never issues a cache flush unless we
> commit a transaction causing that as a side-effect, which is an  
> obvious
> bug in the O_SYNC handling.  Second all the locking and i_update_size
> vs i_update_core changes from 978b7237123d007b9fa983af6e0e2fa8f97f9934
> never made it to xfs_write_sync_logforce, so we add them back.
>
> To make xfs_fsync easily usable from the O_SYNC path, the  
> filemap_fdatawait
> call is moved up to xfs_file_fsync, so that we don't wait on the whole
> file after we already waited for our portion in xfs_write.
>
> We'll also use a plain call to filemap_write_and_wait_range instead
> of the previous sync_page_rang which did it in two steps including
> an half-hearted inode write out that doesn't help us.
>
> Once we're done with this also remove the now useless i_update_size
> tracking.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
