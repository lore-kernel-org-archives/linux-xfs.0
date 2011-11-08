Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8J7NrE144664 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 13:07:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C27E148A49C
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 11:07:22 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iYIBRvnoYeA5nZ3m for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 11:07:22 -0800 (PST)
Date: Tue, 8 Nov 2011 14:07:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs_repair: Add inline function to get avl tree node
Message-ID: <20111108190722.GB7941@infradead.org>
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
	<1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320777990-6556-2-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 04:46:29PM -0200, Carlos Maiolino wrote:
> dd get_inode_offset() inline function, which will return the offset
> of a specific node in the AVL tree avoiding the need to calculate the
> the offset each time it needs to be used.

Looks good.  We should also use it a bit more, but I can take care of
that.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
