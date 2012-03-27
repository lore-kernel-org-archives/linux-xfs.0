Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RIHZk7145397 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 13:17:35 -0500
Message-ID: <4F72043A.5010600@sgi.com>
Date: Tue, 27 Mar 2012 13:17:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/10] xfs: remove log item from AIL in xfs_qm_dqflush
	after a shutdown
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.243162639@bombadil.infradead.org>
In-Reply-To: <20120327164644.243162639@bombadil.infradead.org>
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
> If a filesystem has been forced shutdown we are never going to write dquots
> to disk, which means the dquot items will stay in the AIL forever.
> Currently that is not a problem, but a pending chance requires us to
> empty the AIL before shutting down the filesystem, in which case this
> behaviour is lethal.  Make sure to remove the log item from the AIL
> to allow emptying the AIL on shutdown filesystems.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
