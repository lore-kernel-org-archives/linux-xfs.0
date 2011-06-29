Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TMDbBg145547 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:13:37 -0500
Subject: Re: [PATCH 08/27] xfs: kill xfs_itruncate_start
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110629140338.098991196@bombadil.infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.098991196@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 17:13:32 -0500
Message-ID: <1309385612.8649.38.camel@doink>
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

On Wed, 2011-06-29 at 10:01 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-kill-xfs_itruncate_start)
> xfs_itruncate_start is a rather length wrapper that evaluates to a call
> to xfs_ioend_wait and xfs_tosspages, and only has two callers.
> 
> Instead of using the complicated checks left over from IRIX where we
> can to truncate the pagecache just call xfs_tosspages
> (aka truncate_inode_pages) directly as we want to get rid of all data
> after i_size, and truncate_inode_pages handles incorrect alignments
> and too large offsets just fine.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Nice cleanup.  Looks good.

I will continue reviewing this series tomorrow.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
