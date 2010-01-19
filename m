Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J98sfG179512 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:08:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0ACF1734F0
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:09:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cKPlZNkbT7nx1X1D for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:09:54 -0800 (PST)
Date: Tue, 19 Jan 2010 04:09:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: don't warn about topology when mkfsing a file
Message-ID: <20100119090953.GA24737@infradead.org>
References: <4B54B4D1.7020500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B54B4D1.7020500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 18, 2010 at 01:21:53PM -0600, Eric Sandeen wrote:
> Some tests were failing for me like:
> 
>  QA output created by 206
>  === truncate file ===
>  === mkfs.xfs ===
> +warning: unable to probe device toplology for device /mnt/test/fsfile.21615
> ...
> 
> I thought about filtering the tests, but ...
> 
> It seems that we shouldn't even be trying to get topology for a
> plain file, should we?  And then we won't warn about failure.

Looks good to me.  Would be even nicer if libblkid handled that case,
but let's fix it where we can easily do it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
