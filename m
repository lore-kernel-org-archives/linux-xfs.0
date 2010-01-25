Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PFSS4g061702 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 09:28:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF4ED1DB4563
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 07:29:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WOQTdJ3znZKPMsXH for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 07:29:32 -0800 (PST)
Date: Mon, 25 Jan 2010 10:29:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: Use delayed write for inodes rather than async
Message-ID: <20100125152931.GA19111@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264400564-19704-3-git-send-email-david@fromorbit.com>
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

>  	/*
> -	 * Write out the inode.  The completion routine ('iflush_done') will
> -	 * pull it from the AIL, mark it clean, unlock the flush lock.
> +	 * Push the inode to it's backing buffer. This will not remove
> +	 * the inode from the AIL - a further push will be required to trigger
> +	 * a buffer push. However, this allows all the dirty inodes to be pushed to

Btw, this creates a rather annoying and pointless too long line in the
source file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
