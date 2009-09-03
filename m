Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n840vlM1150210 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 19:57:57 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5741F426D1F
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 17:58:37 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id uGaiTCt0zvcflikY for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2009 17:58:37 -0700 (PDT)
Date: Thu, 3 Sep 2009 15:19:58 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/4] 2.6.30-stable backport of the XFS+NFSD
	inode cache race fix
Message-ID: <20090903221958.GC23517@kroah.com>
References: <20090819184258.542698202@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090819184258.542698202@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: stable@kernel.org, xfs@oss.sgi.com

On Wed, Aug 19, 2009 at 02:42:58PM -0400, Christoph Hellwig wrote:
> 
> This is a backport of the fix for the XFS inode cache races lots of people
> have reported.  The context for the two VFS patches changed quite a bit from
> 2.6.30 to 2.6.31-rc so I consider these backports.  The backport has been
> tested by me with xfstest for XFS and extN, and by lots of users that have
> been waiting for the fix for their nfs servers still running 2.6.30.

All queued up, thanks.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
