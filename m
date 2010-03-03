Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o23Cugfg077688 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 06:56:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F26F3213C10
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 04:58:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fuVhefvsxkKXMejs for
	<xfs@oss.sgi.com>; Wed, 03 Mar 2010 04:58:09 -0800 (PST)
Date: Wed, 3 Mar 2010 07:58:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfsqa: fix size specification for scratch mkfs
Message-ID: <20100303125809.GB26672@infradead.org>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
	<1267597162-12092-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267597162-12092-3-git-send-email-david@fromorbit.com>
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

On Wed, Mar 03, 2010 at 05:19:21PM +1100, Dave Chinner wrote:
> When making a specifically sized scratch filesystem, we need to
> calculate the size rather than assigning the caclculation expression
> to a variable and passing that into the _scratch_mkfs_sized
> function. Currently sized filesystems are failing to be made and the
> code is falling back to full sized filesystems so we are not testing
> enospc issues correctly.

This seems rather fragile.  Maybe instead of calculating the bignums
which I suspect are the problem could we pass symbolic values like 104M
in and parse them in _scratch_mkfs_sized?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
