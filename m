Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AE6d2w181516 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:06:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69D0D145BF07
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 07:13:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6W4lAmNS9GzYlP6F for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 07:13:46 -0700 (PDT)
Date: Mon, 10 Oct 2011 10:06:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] repair: handle repair of image files on large sector
	size filesystems
Message-ID: <20111010140634.GA31429@infradead.org>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318208915-14975-2-git-send-email-david@fromorbit.com>
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

On Mon, Oct 10, 2011 at 12:08:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because repair uses direct IO, it cannot do IO smaller than a sector
> on the underlying device. When repairing a filesystem image, the
> filesystem hosting the image may have a sector size larger than the
> sector size of the image, and so single image sector reads and
> writes will fail.
> 
> To avoid this, when checking a file and there is a sector size
> mismatch like this, turn off direct IO. While there, fix a compile
> bug in the IO_DEBUG option for libxfs which was found during triage.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
