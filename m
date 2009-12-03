Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB3E1jn3114059 for <xfs@oss.sgi.com>; Thu, 3 Dec 2009 08:01:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5C0B14F0354
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2009 06:02:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jrSxVixYtOLqCHSQ for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2009 06:02:16 -0800 (PST)
Date: Thu, 3 Dec 2009 09:02:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix up aio-dio install & build
Message-ID: <20091203140216.GA17917@infradead.org>
References: <4B16C181.4070601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B16C181.4070601@sandeen.net>
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

On Wed, Dec 02, 2009 at 01:35:29PM -0600, Eric Sandeen wrote:
> commit bd53c922 added src/aio-dio-regress to the top-level
> Makefile so that it would get caught on make install, but
> doing this unconditionally means that we tried to build that
> subdir even if libaio headers weren't found.
> 
> Fix this up to do a properly chained make install through
> the subdirs...

Looks good, and also fits the other userspace packages better.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
