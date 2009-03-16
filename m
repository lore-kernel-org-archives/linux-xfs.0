Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAcv30084798 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:39:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5E981C45FEB
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:38:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LaQROv0rOFDyM10V for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:38:36 -0700 (PDT)
Date: Mon, 16 Mar 2009 06:38:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] XFS: Inform the xfsaild of the push target before
	sleeping
Message-ID: <20090316103836.GA24744@infradead.org>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
	<1237117243-25940-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237117243-25940-3-git-send-email-david@fromorbit.com>
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

This looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>

But looking at that area I must say I'm not happy with it in general.
There are tons of useless roundtrips l_grant_lock because we drop
it just before calling xlog_grant_push_ail which needs it for
most of it's operation, and because we acquire it just before
sv_wait just to drop it.

And the duplication between xlog_grant_log_space
xlog_regrant_write_log_space is quite ugly, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
