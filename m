Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGmhVl245069 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:48:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61099140EBEB
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 09:54:11 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aiAM9g2EYOKvgaIJ for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2011 09:54:11 -0700 (PDT)
Date: Thu, 22 Sep 2011 12:48:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test timestamps before the epoch
Message-ID: <20110922164841.GB12353@infradead.org>
References: <4E778C51.7040100@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E778C51.7040100@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 19, 2011 at 01:39:13PM -0500, Eric Sandeen wrote:
> ext2/3/4 was sign-extending times before the timestamp when read
> from disk on 64-bit systems.  This was fixed by:
> 
> 4d7bf11d649c72621ca31b8ea12b9c94af380e63
> ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems
> 
> Here's a generic regression test.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
