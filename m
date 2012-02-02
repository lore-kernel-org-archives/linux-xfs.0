Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12IJK9H068454 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 12:19:20 -0600
Message-ID: <4F2AD3A7.7070401@sgi.com>
Date: Thu, 02 Feb 2012 12:19:19 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] repair: update extent count after zapping duplicate
	blocks
References: <20111202174619.179530033@bombadil.infradead.org>	<20111202174741.904845954@bombadil.infradead.org>	<20111213021207.GY14273@dastard>
	<20120202123910.GA8708@infradead.org>
In-Reply-To: <20120202123910.GA8708@infradead.org>
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

On 02/02/12 06:39, Christoph Hellwig wrote:
> When we find a duplicate extent in an extern format inode we do not zap
> the whole inode, but just truncate it to the point where the duplicate
> extent was found.  But the current code only updates di_nblocks for the
> new size, but no di_nextents/di_anextents.  In most cases this isn't noticed,
> but when moving such an inode to the lost+found directoy the consistency
> check in xfs_iformat trips over it.  Fix this by updating the on-disk
> extent count as part of the inode repair.


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
