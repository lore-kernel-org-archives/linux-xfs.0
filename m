Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E00D57CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 01:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66CA8AC001
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 23:38:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id I9giJMitqjGMv5Uk (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 23:38:17 -0700 (PDT)
Date: Mon, 5 Sep 2016 23:38:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/71] xfs: defer should allow ->finish_item to request a
	new transaction
Message-ID: <20160906063815.GA11411@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216794133.867.4063030531885190227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216794133.867.4063030531885190227.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:32:21PM -0700, Darrick J. Wong wrote:
> When xfs_defer_finish calls ->finish_item, it's possible that
> (refcount) won't be able to finish all the work in a single
> transaction.  When this happens, the ->finish_item handler should
> shorten the log done item's list count, update the work item to
> reflect where work should continue, and return -EAGAIN so that
> defer_finish knows to retain the pending item on the pending list,
> roll the transaction, and restart processing where we left off.
> 
> Plumb in the code and document how this mechanism is supposed to work.

I've voiced this before, and I will again:  I think the whole xfs_defer
mechanism is a major, major mistake.  All three users look somewhat
similar, but actually are different underneath.  Especially the extent
free case is a lot simpler than all others, and we now place the burden
of a complex abstraction onto code that would otherwise be fairly
easily understandable.

Also it adds a memory allocation to the extent free code, and gets in
the way of merging the freed extent and extent busy structures,
something I prototyped a while ago.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
