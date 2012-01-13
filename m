Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DK9xU7158159 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 14:09:59 -0600
Message-ID: <4F108F95.3060606@sgi.com>
Date: Fri, 13 Jan 2012 14:09:57 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] repair: avoid ABBA deadlocks on prefetched buffers
References: <20111115210953.GA6670@infradead.org>
In-Reply-To: <20111115210953.GA6670@infradead.org>
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

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Both the prefetch threads and actual repair processing threads can have
> multiple buffers at a time locked, but they do no use a common locker
> order, which can lead to ABBA deadlocks while trying to lock the buffers.
>
> Switch the prefetch code to do a trylock and skip buffers that have
> already been locked to avoid this deadlock.
>
> Reported-by: Arkadiusz Mi??kiewicz<arekm@maven.pl>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>

Part of a series of fixes. Needed for "
[PATCH 06/12] repair: use recursive buffer locking" patch.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
