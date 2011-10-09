Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99Nqg5p132709 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:52:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7CE11C79BD3
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:52:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bQl1OlhHZ6AHQLWj for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:52:41 -0700 (PDT)
Date: Sun, 9 Oct 2011 19:52:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] repair: handle repair of image files on large sector
	size filesystems
Message-ID: <20111009235240.GD13527@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318201910-11144-2-git-send-email-david@fromorbit.com>
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

On Mon, Oct 10, 2011 at 10:11:46AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because repair uses direct IO, it cannot do IO smaller than a sector
> on the underlying device. When repairing a filesystem image, the
> filesystem hosting the image may have a sector size larger than the
> sector size of the image, and so single image sector reads and
> writes will fail.

Does it?  Given that the loop driver uses buffered I/O that would be
unexpected behaviour.  I'll try to reproduce it as soon as my 4k
disk is available again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
