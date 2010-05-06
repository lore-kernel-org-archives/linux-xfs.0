Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46Kf0mk130438 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:41:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F28D31781D
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 13:43:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8I7HWK0TMSjpkuhk for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 13:43:11 -0700 (PDT)
Date: Thu, 6 May 2010 16:43:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: allow log ticket allocation to take
	allocation flags
Message-ID: <20100506204310.GB14309@infradead.org>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<1273110351-2333-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-4-git-send-email-david@fromorbit.com>
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

On Thu, May 06, 2010 at 11:45:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Delayed logging currently requires ticket allocation to succeed, so
> we need to be able to sleep on allocation. It also should not allow
> memory allocation to recurse into the filesystem. hence we need to
> pass allocation flags directing the type of allocation the caller
> requires.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
