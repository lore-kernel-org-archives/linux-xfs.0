Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB3GwE7l126847 for <xfs@oss.sgi.com>; Thu, 3 Dec 2009 10:58:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E12941919842
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2009 08:58:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EqVCwKuU1Q4swcnA for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2009 08:58:45 -0800 (PST)
Date: Thu, 3 Dec 2009 11:58:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: don't assign cvtnum() return to unsigned var
Message-ID: <20091203165844.GA6894@infradead.org>
References: <4B16AFCA.5040302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B16AFCA.5040302@sandeen.net>
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

On Wed, Dec 02, 2009 at 12:19:54PM -0600, Eric Sandeen wrote:
> cvtnum() returns -1LL for unparseable values, but if we
> assign to a signed var, we can't test it:
> 
> xfs_io> mincore 0 xxx
> range (0:0) is beyond mapping (0:1048576)
> 
> Use a temporary signed var so we can detect the error:
> 
> xfs_io> mincore 0 xxx
> non-numeric length argument -- xxx
> 
> and also test whether it may overflow a size_t.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
