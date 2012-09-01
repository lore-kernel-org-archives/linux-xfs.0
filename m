Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81NO2g6196821 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:24:02 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Tx6g4gp0mAqM9GCS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 16:24:57 -0700 (PDT)
Date: Sat, 1 Sep 2012 19:24:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] xfs: xfs_sync_data is redundant.
Message-ID: <20120901232456.GB31634@infradead.org>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346328017-2795-8-git-send-email-david@fromorbit.com>
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

On Thu, Aug 30, 2012 at 10:00:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't do any data writeback from XFS any more - the VFS is
> completely responsible for that, including for freeze. We can
> replace the remaining caller with the VFS level function that
> achieves the same thing, but without conflicting with current
> writeback work - writeback_inodes_sb_if_idle().
> 
> This means we can remove the flush_work and xfs_flush_inodes() - the
> VFS functionality completely replaces the internal flush queue for
> doing this writeback work in a separate context to avoid stack
> overruns..

Are the lock ordering issues with writeback_inodes_sb_if_idle sorted out
by now?  IIRC it still needs to be switch to a trylock.

> -			xfs_flush_inodes(ip);
> +			writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb,
> +						    WB_REASON_FS_FREE_SPACE);

I'd prefer to still keep a wrapper for an ugly call like this if we can.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
