Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54Aj2up237010 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 05:45:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F4F02D027E
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 03:45:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FFT5PhVz9M82881G for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 03:45:20 -0700 (PDT)
Date: Thu, 4 Jun 2009 06:45:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: split xfs_sync_inodes
Message-ID: <20090604104520.GB8413@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171559.231368000@bombadil.infradead.org>
	<20090603232605.GB9167@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090603232605.GB9167@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 03, 2009 at 07:26:05PM -0400, Josef 'Jeff' Sipek wrote:
> > order.  The moved log force in that path doesn't make a different because
>                                                           ^^^^^^^^^
> 
> Typo.
> 

> > +		 * Or more likely no needed at all because the VFS is already
>                                   ^^
> 
> Typo.


Thanks, fixed both for the next iteration.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
