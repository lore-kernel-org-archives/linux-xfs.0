Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H5BMdX207022 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 23:11:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C95AF13B09AF
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 21:12:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	sBKr3JR0MErSYjaq for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 21:12:39 -0800 (PST)
Date: Wed, 17 Feb 2010 16:12:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: factor common xfs_trans_bjoin code
Message-ID: <20100217051236.GP28392@discord.disaster>
References: <20100215233509.GC28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215233509.GC28817@infradead.org>
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

On Mon, Feb 15, 2010 at 06:35:09PM -0500, Christoph Hellwig wrote:
> Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf, xfs_trans_getsb
> and xfs_trans_read_buf.  Add a new _xfs_trans_bjoin which can be called
> by all four functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
