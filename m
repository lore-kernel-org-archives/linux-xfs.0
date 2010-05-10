Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AICtHn020424 for <xfs@oss.sgi.com>; Mon, 10 May 2010 13:12:55 -0500
Subject: Re: [PATCH] xfs: clean up xlog_align
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100510172814.GB14991@infradead.org>
References: <20100510172814.GB14991@infradead.org>
Date: Mon, 10 May 2010 13:15:05 -0500
Message-ID: <1273515305.2824.164.camel@doink>
Mime-Version: 1.0
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

On Mon, 2010-05-10 at 13:28 -0400, Christoph Hellwig wrote:
> Add suggested cleanups to commit 29db3370a1369541d58d692fbfb168b8a0bd7f41
> from review that didn't end up being commited.

Whoops.  I said I was going to change it to be that
way but I guess that didn't happen.  Sorry about that.

I do like this way better.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-10 19:12:01.539262194 +0200
> +++ xfs/fs/xfs/xfs_log_recover.c	2010-05-10 19:14:52.295255420 +0200
> @@ -132,15 +132,10 @@ xlog_align(


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
