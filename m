Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBeF2P221808 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:40:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 223301E10AC7
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:42:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FrwP5Y2C6DqSIDc4 for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:42:54 -0700 (PDT)
Date: Fri, 18 Jun 2010 07:42:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
Message-ID: <20100618114253.GB5417@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<1276846374-23916-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1276846374-23916-4-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org, xfs@oss.sgi.com

On Fri, Jun 18, 2010 at 05:32:53PM +1000, Dave Chinner wrote:
>  		/* no diagnostics for bulkstat, ino comes from userspace */
> -		if (flags & XFS_IGET_BULKSTAT)
> +		if (flags & XFS_IGET_UNTRUSTED)

The comment could use an update as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
