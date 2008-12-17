Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHHvqTx004358 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 11:57:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7FF2174B7D5
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 09:57:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QDd6lUkZXgMnDbTF for
	<xfs@oss.sgi.com>; Wed, 17 Dec 2008 09:57:51 -0800 (PST)
Date: Wed, 17 Dec 2008 12:57:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] avoid memory allocations in xfs_fs_vcmn_err
Message-ID: <20081217175750.GA27867@infradead.org>
References: <20081217172736.GA10797@infradead.org>
	<49493AE5.2050202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49493AE5.2050202@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

On Wed, Dec 17, 2008 at 11:46:13AM -0600, Eric Sandeen wrote:
> Do we really want to drop the whole message if the fs name can't fit?
> Maybe drop the fsname altogether and print the error anyway?  Being
> completely silent doesn't sound great...

That's what we effecitvely do now, except that we still call snprintf.
I think it's an unlikely enough case that we don't need to worry about
it.  And if long enough device names become common we can just increase
the buffer size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
