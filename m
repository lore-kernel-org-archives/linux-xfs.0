Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SGDJBh201280 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 10:13:19 -0600
Message-ID: <4F4CFD1D.1010408@sgi.com>
Date: Tue, 28 Feb 2012 10:13:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] xfs: use per-filesystem I/O completion workqueues
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003906.124899527@bombadil.infradead.org>
In-Reply-To: <20120221003906.124899527@bombadil.infradead.org>
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

On 02/20/12 18:38, Christoph Hellwig wrote:
> The new concurrency managed workqueues are cheap enough that we can create
> per-filesystem instead of global workqueues.  This allows us to remove the
> trylock or defer scheme on the ilock, which is not helpful once we have
> outstanding log reservations until finishing a size update.
>
> Also allow the default concurrency on this workqueues so that I/O completions
> blocking on the ilock for one inode do not block process for another inode.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
