Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663liaC064249 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:47:44 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 088B81BF6E0A
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:47:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nBgLogXMnTCHldOr for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:47:43 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/27] xfs: clean up buffer locking helpers
Message-ID: <20110706034741.GS1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.155544131@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094607.155544131@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 05:43:45AM -0400, Christoph Hellwig wrote:
> Rename xfs_buf_cond_lock and reverse it's return value to fit most other
> trylock operations in the Kernel and XFS (with the exception of down_trylock,
> after which xfs_buf_cond_lock was modelled), and replace xfs_buf_lock_val
> with an xfs_buf_islocked for use in asserts, or and opencoded variant in
> tracing.  remove the XFS_BUF_* wrappers for all the locking helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
