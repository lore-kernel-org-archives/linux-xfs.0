Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GB1ICu087094 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 06:01:38 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E83C1C4558D
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:00:56 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	l5PvA3aifjwKR4Nh for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 04:00:56 -0700 (PDT)
Date: Mon, 16 Mar 2009 22:00:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] XFS: Inform the xfsaild of the push target before
	sleeping
Message-ID: <20090316110052.GL26138@disturbed>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
	<1237117243-25940-3-git-send-email-david@fromorbit.com>
	<20090316103836.GA24744@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316103836.GA24744@infradead.org>
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

On Mon, Mar 16, 2009 at 06:38:36AM -0400, Christoph Hellwig wrote:
> This looks good to me.
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But looking at that area I must say I'm not happy with it in general.
> There are tons of useless roundtrips l_grant_lock because we drop
> it just before calling xlog_grant_push_ail which needs it for
> most of it's operation, and because we acquire it just before
> sv_wait just to drop it.
> 
> And the duplication between xlog_grant_log_space
> xlog_regrant_write_log_space is quite ugly, too.

I totally agree, but I don't feel like trying to rewrite this
code right now. Maybe some rainy day....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
