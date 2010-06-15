Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F1oR4v065790 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 20:50:28 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E9BB14CF1EE
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 18:53:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	GYMEguPCojSQIIyN for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 18:53:02 -0700 (PDT)
Date: Tue, 15 Jun 2010 11:53:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove xfs_iput_new
Message-ID: <20100615015300.GP6590@dastard>
References: <20100611161824.GA7556@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100611161824.GA7556@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jun 11, 2010 at 12:18:24PM -0400, Christoph Hellwig wrote:
> We never get an i_mode of 0 or a locked VFS inode until we pass in the
> XFS_IGET_CREATE flag to xfs_iget, which makes xfs_iput_new equivalent to
> xfs_iput for the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
