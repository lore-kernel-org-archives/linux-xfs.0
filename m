Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBNHvmxc243268 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 11:57:48 -0600
Date: Fri, 23 Dec 2011 11:58:15 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/1] xfs: log the inode in ->write_inode calls for kupdate
Message-ID: <20111223175815.GU29840@sgi.com>
References: <20111218154936.GA17626@infradead.org>
	<20111218154955.GB17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218154955.GB17626@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 10:49:55AM -0500, Christoph Hellwig wrote:
> If the writeback code writes back an inode because it has expired we currently
> use the non-blockin ->write_inode path.  This means any inode that is pinned
> is skipped.  With delayed logging and a workload that has very little log
> traffic otherwise it is very likely that an inode that gets constantly
> written to is always pinned, and thus we keep refusing to write it.  The VM
> writeback code at that point redirties it and doesn't try to write it again
> for another 30 seconds.  This means under certain scenarious time based
> metadata writeback never happens.
> 
> Fix this by calling into xfs_log_inode for kupdate in addition to data
> integrity syncs, and thus transfer the inode to the log ASAP.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c	2011-12-14 05:33:07.193262189 -0800
> +++ xfs/fs/xfs/xfs_super.c	2011-12-14 05:38:56.108038623 -0800
> @@ -905,7 +884,7 @@ xfs_fs_write_inode(

I could not reproduce a situation where this was called with for_kupdate
set and the inode was pinned for very long.  I'm curious if there was an
easy workload to reproduce this.

>  	if (!ip->i_update_core)
>  		return 0;
>  
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->for_kupdate) {

It looks to me that this is the relevant codepath:

       bdi_writeback_thread .or. bdi_forker_thread
         wb_do_writeback
           wb_check_old_data_flush
             wb_writeback
               writeback_sb_inodes
                 writeback_single_inode
                   write_inode
                     .write_inode
                       xfs_fs_write_inode

AFAICS the only place that for_kupdate is set is in
wb_check_old_data_flush.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
