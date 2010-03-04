Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24Dss4D171306 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 07:54:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CD062184C3
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 05:56:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hw8VKM2Ezy0vyQBq for
	<xfs@oss.sgi.com>; Thu, 04 Mar 2010 05:56:23 -0800 (PST)
Date: Thu, 4 Mar 2010 08:56:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsqa: define resblks for tests near ENOSPC
Message-ID: <20100304135623.GB31753@infradead.org>
References: <1267667254-7971-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267667254-7971-1-git-send-email-david@fromorbit.com>
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

On Thu, Mar 04, 2010 at 12:47:34PM +1100, Dave Chinner wrote:
> +	# fix the reserve block pool to a known size so that the enospc
> +	# calculations work out correctly.
> +	xfs_io -x -c "resblks 1024" $SCRATCH_MNT > /dev/null 2>&1

What about a _scratch_resvblks helper - that means we could also
add noops for non-xfs filesystems there easily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
