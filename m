Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AIrvHk107392 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 13:53:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD8E91D3D230
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 11:54:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id poGG7imNvjF5JU3O for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 11:54:18 -0700 (PDT)
Date: Wed, 10 Jun 2009 14:54:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Gracefully fail aio tests if they weren't built
Message-ID: <20090610185418.GA24615@infradead.org>
References: <4A2FF40F.1090808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2FF40F.1090808@sandeen.net>
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

On Wed, Jun 10, 2009 at 12:57:35PM -0500, Eric Sandeen wrote:
> Gracefully fail aio tests if they weren't built
> 
> configure & make succeeds w/o aio headers or libs,
> so tests should handle that.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Maybe we should just add an _require_aio to check for libaio instead
of needing different checks in each test?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
