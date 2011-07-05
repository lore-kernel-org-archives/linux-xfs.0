Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65MaUNQ044743 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 17:36:30 -0500
Subject: Re: [PATCH 09/27] xfs: fix filesystsem freeze race in xfs_trans_alloc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094604.200765470@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094604.200765470@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 17:36:25 -0500
Message-ID: <1309905385.1950.51.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> As pointed out by Jan xfs_trans_alloc can race with a concurrent filesystem
> freeze when it sleeps during the memory allocation.  Fix this by moving the
> wait_for_freeze call after the memory allocation.  This means moving the
> freeze into the low-level _xfs_trans_alloc helper, which thus grows a new
> argument.  Also fix up some comments in that area while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <david@fromorbit.com>

Looks good.  The race has to do with the check of
mp->m_active_trans in xfs_quiesce_attr(), which
is called by the freeze_fs method, xfs_fs_freeze()

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
