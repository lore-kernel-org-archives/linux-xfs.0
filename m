Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FE238011
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:37:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D9088F8040
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 03:37:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id CUEqX7e2qX48ZRn3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 03:37:25 -0700 (PDT)
Date: Fri, 26 Sep 2014 03:37:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: force the log before shutting down
Message-ID: <20140926103724.GA24436@infradead.org>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 10:34:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we have marked the filesystem for shutdown, we want to prevent
> any further buffer IO from being submitted. However, we currently
> force the log after marking the filesystem as shut down, hence
> allowing IO to the log *after* we have marked both the filesystem
> and the log as in an error state.
> 
> Clean this up by forcing the log before we mark the filesytem with
> an error. This replaces the pure CIL flush that we currently have
> which works around this same issue (i.e the CIL can't be flushed
> once the shutdown flags are set) and hence enables us to clean up
> the logic substantially.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>


A couple nitpicks:

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b1131fe..a598955 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3924,13 +3924,14 @@ xfs_log_force_umount(

The top of the function comment speaks about the delaylog case,
given that this is the only option now it might be worth to clean
that up.

>  	retval = 0;

This assignment can be removed now that the xlog_state_ioerror call
below is unconditional.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
