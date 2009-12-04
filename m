Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB4A3UPp203211 for <xfs@oss.sgi.com>; Fri, 4 Dec 2009 04:03:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E974514A895C
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2009 02:04:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OOqBR3BE39L0Shfx for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2009 02:04:02 -0800 (PST)
Date: Fri, 4 Dec 2009 05:04:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] db: stop using xfs_bmbt_rec_32_t
Message-ID: <20091204100401.GA28986@infradead.org>
References: <20091103155019.GA28991@infradead.org>
	<4B16A5E8.8070604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B16A5E8.8070604@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 11:37:44AM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > xfs_db uses the xfs_bmbt_rec_32_t type to pass around extent information in a
> > few places.  But everywhere where we actually use it we use the normal
> > xfs_bmbt_rec_t just casting from/to xfs_bmbt_rec_32_t to pass it around.
> > 
> > Just pass the xfs_bmbt_rec_t directly and thus get rid of the last use
> > of xfs_bmbt_rec_32_t in xfsprogs.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Seems fine.
> 
> After this should the db references to xfs_bmbt_rec_64_t be
> changed to xfs_bmbt_rec_t perhaps?

Yes, except that we don't actually have the struct type for it yet which
we'll need in at least one place.  I'll do it once I've removed the _32
and _64 types in the kernel and synced over the changes to userspace.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
