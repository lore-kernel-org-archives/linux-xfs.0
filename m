Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8PKGh3l187510 for <xfs@oss.sgi.com>; Fri, 25 Sep 2009 15:16:43 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: fix spin_is_locked assert on uni-processor builds
Date: Fri, 25 Sep 2009 15:17:59 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ACE9@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090810140006.GA21521@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
> Without SMP or preemption spin_is_locked always returns false,
> so we can't do an assert with it.  Instead use assert_spin_locked,
> which does the right thing on all builds.
> 
> This fixes kernel.org BZ #13621.

Looks good.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Johannes Engel <jcnengel@googlemail.com>
> Tested-by: Johannes Engel <jcnengel@googlemail.com>
Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_log.c	2009-08-09 23:27:07.889729629 -0300
> +++ linux-2.6/fs/xfs/xfs_log.c	2009-08-09 23:27:24.092725926 -0300
> @@ -3180,7 +3180,7 @@ try_again:
>  STATIC void
>  xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
>  {
> -	ASSERT(spin_is_locked(&log->l_icloglock));
> +	assert_spin_locked(&log->l_icloglock);
> 
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		xlog_state_switch_iclogs(log, iclog, 0);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
