Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PGUmuS241058 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 11:30:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E1581D9402D
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:31:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0AZ5MXPJk1j1QCWY for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:31:44 -0700 (PDT)
Date: Sat, 25 Sep 2010 12:31:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/18] xfs: split out inode walk inode grabbing
Message-ID: <20100925163142.GA32390@infradead.org>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
	<1285331476-23015-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285331476-23015-14-git-send-email-david@fromorbit.com>
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

> +int
> +xfs_inode_ag_walk_grab(

Should be STATIC.


Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
