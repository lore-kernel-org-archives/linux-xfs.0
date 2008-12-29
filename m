Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTJL8NE025650 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:21:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC6DC1794045
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:21:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id F3VgQF0YWo4JUxkH for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:21:07 -0800 (PST)
Date: Mon, 29 Dec 2008 14:20:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
Message-ID: <20081229192032.GA30477@infradead.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
	<4959205E.4000000@thebarn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4959205E.4000000@thebarn.com>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Martin Steigerwald <Martin@Lichtvoll.de>, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 01:09:18PM -0600, Russell Cattelan wrote:
> I would have to look for sure when Dave's rewrite of the inode cache/fs 
> sync code went in but
> it could be around the time of 2.6.27.

That's all in the 2.6.29 queue.

> The other thing that is odd is why files full of nulls still? xfs 
> changed its behavior to write out size changes
> at flush time and not before, previously size changes would be synced 
> out prior to the data being synced
> out, thus creating "null files" or rather a file with size but no extent 
> data.
> 
> The "null files" problem should be an "empty files" problem at worst 
> now, so it is really curious that you
> are seeing null files still.

One good way would be to mount the partition with -o sync.  That way
you get data integrity for all files at the epense of really sucky
performance..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
