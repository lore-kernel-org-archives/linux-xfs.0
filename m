Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGbM4w173464 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:37:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0753E903138
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:39:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id w4zlKxUqzoCmlvhM for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:39:28 -0700 (PDT)
Date: Fri, 30 Apr 2010 12:39:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: replace E2BIG with EFBIG where appropriate
Message-ID: <20100430163927.GB14107@infradead.org>
References: <4BDA51B9.4010501@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BDA51B9.4010501@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 29, 2010 at 10:42:49PM -0500, Eric Sandeen wrote:
> Many places in the xfs code return E2BIG when they really
> mean EFBIG; trying to grow past 16T on a 32 bit machine,
> for example, says "Argument list too long" rather than "File
> too large" which is not particularly helpful.
> 
> Some of these don't make perfect sense as EFBIG either,
> but still better than E2BIG IMHO.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
