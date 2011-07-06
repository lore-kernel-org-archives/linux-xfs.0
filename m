Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6641Js7065392 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:01:20 -0500
Subject: Re: [PATCH 24/27] xfs: clean up buffer locking helpers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094607.155544131@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.155544131@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:55:06 -0500
Message-ID: <1309924506.3381.48.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> Rename xfs_buf_cond_lock and reverse it's return value to fit most other
> trylock operations in the Kernel and XFS (with the exception of down_trylock,
> after which xfs_buf_cond_lock was modelled), and replace xfs_buf_lock_val
> with an xfs_buf_islocked for use in asserts, or and opencoded variant in
> tracing.  remove the XFS_BUF_* wrappers for all the locking helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice change.  More readable.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
