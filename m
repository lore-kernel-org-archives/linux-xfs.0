Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ILBd1c234962 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 16:11:39 -0500
Message-ID: <4F8F2E0A.5020807@sgi.com>
Date: Wed, 18 Apr 2012 16:11:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/10] xfs: do not write the buffer from xfs_qm_dqflush
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.158577302@bombadil.infradead.org>
In-Reply-To: <20120327164646.158577302@bombadil.infradead.org>
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

On 03/27/12 11:44, Christoph Hellwig wrote:
> Instead of writing the buffer directly from inside xfs_qm_dqflush return it
> to the caller and let the caller decide what to do with the buffer.  Also
> remove the pincount check in xfs_qm_dqflush that all non-blocking callers
> already implement and the now unused flags parameter and the XFS_DQ_IS_DIRTY
> check that all callers already perform.
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
