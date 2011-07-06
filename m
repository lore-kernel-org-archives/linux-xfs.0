Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663av0k063779 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:36:57 -0500
Subject: Re: [PATCH 16/27] xfs: avoid usage of struct xfs_dir2_block
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094605.621819832@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.621819832@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:36:53 -0500
Message-ID: <1309923413.3381.31.camel@doink>
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
> In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
> which is the first and most important member of struct xfs_dir2_block instead
> of the full structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
