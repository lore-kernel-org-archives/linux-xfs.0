Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HCAw8f011661 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 06:10:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D33E5F189B3
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:11:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V0CcK0Kl5yFpJ3Pq for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:11:57 -0800 (PST)
Date: Sun, 17 Jan 2010 07:11:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfsprogs: fix warning in adfs superblock probe
Message-ID: <20100117121157.GA29034@infradead.org>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-5-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2010 at 09:09:07PM +1100, Dave Chinner wrote:
> The probe gets an array subscript warning because gcc is not smart
> enough to realise that a structure made up of multiple byte arrays
> in it can be referenced as a flat buffer and it is valid to access
> bytes beyond the first array in the structure....
> 
> Fix it by passing the adfs superblock in and using the internal
> checksum array to get the checksum value.

The check still seems horribly ugly, but hey given that this is code
superceeded by blkid it should be good enough,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
