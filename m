Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QHoTUv067831 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 12:50:29 -0500
Message-ID: <50118365.8020504@sgi.com>
Date: Thu, 26 Jul 2012 12:50:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/7] xfs: add a short cut to xfs_dialloc for the non-NULL
	agbp case
References: <20120704145444.863203951@bombadil.infradead.org>
	<20120704145615.870767549@bombadil.infradead.org>
In-Reply-To: <20120704145615.870767549@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/12 09:54, Christoph Hellwig wrote:
> In this case we already have selected an AG and know it has free space
> beause the buffer lock never got released.  Jump directly into xfs_dialloc_ag
> and short cut the AG selection loop.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
