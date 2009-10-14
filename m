Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9ENEx8D218213
	for <linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 18:14:59 -0500
Received: from tneu02.synserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1E737E03
	for <linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 16:16:29 -0700 (PDT)
Received: from tneu02.synserver.de (tneu02.synserver.de [217.119.58.222]) by
	cuda.sgi.com with ESMTP id DKGBewECfpkAqum7 for
	<linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 16:16:29 -0700 (PDT)
From: Thomas Neumann <tneumann@users.sourceforge.net>
Subject: Re: deadlocks with fallocate
Date: Thu, 15 Oct 2009 01:16:27 +0200
References: <hak2l2$ko2$1@ger.gmane.org> <20091014150951.GA13123@infradead.org>
In-Reply-To: <20091014150951.GA13123@infradead.org>
MIME-Version: 1.0
Message-Id: <200910150116.27421.tneumann@users.sourceforge.net>
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
Cc: linux-xfs@oss.sgi.com

> And this thread is inside the fallocate handler.
> 
> Can you try if the hack below makes the problem go away?
> 
> +	current->flags |= PF_FSTRANS;

that seems to do the trick. I will test it some more, but so far it has 
already survived a workload that usually triggered the deadlock quite 
reliably.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
