Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMkMmG257012 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:46:22 -0500
Subject: Re: [PATCH] xfs: start periodic workers later
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110711135957.GA23737@infradead.org>
References: <20110711135957.GA23737@infradead.org>
Date: Mon, 11 Jul 2011 17:34:35 -0500
Message-ID: <1310423675.7019.64.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2011-07-11 at 09:59 -0400, Christoph Hellwig wrote:
> Start the periodic sync workers only after we have finished xfs_mountfs
> and thus fully set up the filesystem structures.  Without this we can
> call into xfs_qm_sync before the quotainfo strucute is set up if the
> mount takes unusually long, and probably hit other incomplete states
> as well.
> 
> Also clean up the xfs_fs_fill_super error path by using consistent
> label names, and removing an impossible to reach case.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
