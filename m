Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GG5f2V252256 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 11:05:41 -0500
Message-ID: <50043BD2.7080105@sgi.com>
Date: Mon, 16 Jul 2012 11:05:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: handle EOF correctly in xfs_vm_writepage
References: <20120703162000.GA13016@infradead.org>
In-Reply-To: <20120703162000.GA13016@infradead.org>
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

On 07/03/12 11:20, Christoph Hellwig wrote:
> We need to zero out part of a page which beyond EOF before setting uptodate,
> otherwise, mapread or write will see non-zero data beyond EOF.
>
> Based on the code in fs/buffer.c and the following ext4 commit:
>
>    ext4: handle EOF correctly in ext4_bio_write_page()
>
> And yes, I wish we had a good test case for it.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
