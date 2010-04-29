Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAGl7d062043 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:16:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F231D1D49293
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:18:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1Pp6DqgXowTxeKpU for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:18:52 -0700 (PDT)
Date: Thu, 29 Apr 2010 06:18:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfsqa: clean up 030 repair output
Message-ID: <20100429101850.GA29677@infradead.org>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272500186-29393-2-git-send-email-david@fromorbit.com>
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

On Thu, Apr 29, 2010 at 10:16:24AM +1000, Dave Chinner wrote:
> With the new checks in xfs_repair, it outputs more information
> about errors found than previously. This new output can be ignored
> for the purpose?? of this test, so filter it all out. This will
> allow the test to run on new and old reapir binaries.

Oh well, I had promised faking up the new output for too long time but
never managed to do it, so let's just put this one in.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
