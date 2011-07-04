Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p648Dqgt124637 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 03:13:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34DBB1EE78DB
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 01:13:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	drUm43u0c7nUy99A for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 01:13:49 -0700 (PDT)
Date: Mon, 4 Jul 2011 04:13:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: unpin stale inodes directly in IOP_COMMITTED
Message-ID: <20110704081349.GB22496@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 04, 2011 at 03:27:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When inodes are marked stale in a transaction, they are treated
> specially when the iinode log item is being inserted into the AIL.

s/iinode/inode/

> It trie?? to avoid moving the log item forward in the AIL due to a

Weird character.

Otherwise looks good good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
