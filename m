Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65MaYc3044758 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 17:36:34 -0500
Subject: Re: [PATCH 10/27] xfs: remove i_transp
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094604.425053359@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094604.425053359@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 17:36:33 -0500
Message-ID: <1309905393.1950.52.camel@doink>
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
> Remove the transaction pointer in the inode.  It's only used to avoid
> passing down an argument in the bmap code, and for a few asserts in
> the transaction code right now.

Looks OK to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
