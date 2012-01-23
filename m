Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NEUx8N108182 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 08:31:00 -0600
Message-ID: <4F1D6F24.6050509@sgi.com>
Date: Mon, 23 Jan 2012 08:31:00 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 03/12] xfs: remove xfs_trans_unlocked_item
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.885467482@bombadil.infradead.org>
In-Reply-To: <20111212141433.885467482@bombadil.infradead.org>
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
> There is no reason to wake up log space waiters when unlocking inodes or
> dquots, and the commit log has no explanation for this function either.
>
> Given that we now have exact log space wakeups everywhere we can assume
> to reason for this function was to paper over log space races in earlier
> XFS versions.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

I agree, these unlock won't change the amount of available log space.

I did not find the exact reason for these original calls the the log 
space wake routines.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
