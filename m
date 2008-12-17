Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHHkHcK003432 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 11:46:17 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AB2D2C988
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 09:46:16 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 78SjiGWHwnwKIHUg for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2008 09:46:16 -0800 (PST)
Message-ID: <49493AE5.2050202@sandeen.net>
Date: Wed, 17 Dec 2008 11:46:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] avoid memory allocations in xfs_fs_vcmn_err
References: <20081217172736.GA10797@infradead.org>
In-Reply-To: <20081217172736.GA10797@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:

> +	if (mp) {
> +		len = sprintf(message, "Filesystem \"%s\": ", mp->m_fsname);
> +
> +		/*
> +		 * Skip the printk if we can't print anything useful
> +		 * due to an over-long device name.
> +		 */
> +		if (len >= sizeof(message))
> +			goto out;


Do we really want to drop the whole message if the fs name can't fit?
Maybe drop the fsname altogether and print the error anyway?  Being
completely silent doesn't sound great...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
