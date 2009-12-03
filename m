Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB3H0RLm127119 for <xfs@oss.sgi.com>; Thu, 3 Dec 2009 11:00:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AD77CAEE0
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2009 09:00:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yBR2juGyaVpzZ5Vw for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2009 09:00:59 -0800 (PST)
Date: Thu, 3 Dec 2009 12:00:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: enable missing functions
Message-ID: <20091203170059.GC6894@infradead.org>
References: <4B16AE64.5080700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B16AE64.5080700@sandeen.net>
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

On Wed, Dec 02, 2009 at 12:13:56PM -0600, Eric Sandeen wrote:
> madvise and mincore were never hooked up to init_commands().
> 
> Further, there is no HAVE_INJECT test in the configure scripts,
> so just remove that test (and keep the existing unconditional
> inject_init() prototype.

Hmm, maybe Nathan still has an idea what it's for, probably some IRIX
build.

Anyway, the madvise and mincore wireup looks good.  Note entirely sure
what they do in xfs_io, though - they're VM syscalls not filesystem and
don't cause I/O normally.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
