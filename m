Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9AYLc2233074 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 04:34:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EC59152AFC6
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 02:36:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	yebwcRK5aipmAlQy for <xfs@oss.sgi.com>;
	Thu, 09 Dec 2010 02:36:08 -0800 (PST)
Date: Thu, 9 Dec 2010 21:36:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: log timestamp changes to the source inode in rename
Message-ID: <20101209103605.GC29856@dastard>
References: <20101207101641.GA25995@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101207101641.GA25995@infradead.org>
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

On Tue, Dec 07, 2010 at 05:16:41AM -0500, Christoph Hellwig wrote:
> Now that we don't mark VFS inodes dirty anymore for internal timestamp changes,
> but rely on the transaction subsystem to push them out, we need to explicitly
> log the source inode in rename after updating it's timestamps to make sure
> the changes actually get forced out by sync/fsync or an AIL push.
> 
> We already account for the fourth inode in the log reservation, as a rename
> of directories needs to update the nlink field, so just adding the
> xfs_trans_log_inode call is enough.
> 
> This fixes the xfsqa 065 regression introduced by:
> 
> 	"xfs: don't use vfs writeback for pure metadata modifications"
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
