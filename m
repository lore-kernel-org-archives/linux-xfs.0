Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMWnn6256188 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:32:49 -0500
Subject: Re: [PATCH 02/11] xfs: cleanup struct xfs_dir2_free
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205017.074624276@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.074624276@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 17:32:45 -0500
Message-ID: <1310423565.7019.54.camel@doink>
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

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Change the bests array to be a proper variable sized entry.  This is done
> easily as no one relies on the size of the structure.  Also change
> XFS_DIR2_MAX_FREE_BESTS to an inline function while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
