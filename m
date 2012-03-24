Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ODlXak029212 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 08:47:33 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WpPmi6C1RPQnj0FF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 06:47:32 -0700 (PDT)
Date: Sat, 24 Mar 2012 09:47:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: remove log item from AIL in xfs_iflush after a
	shutdown
Message-ID: <20120324134730.GA4674@infradead.org>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.187265302@bombadil.infradead.org>
	<20120321232029.GZ5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120321232029.GZ5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 10:20:29AM +1100, Dave Chinner wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks OK, but I'm just not sure that all the necessary places to
> remove the inode from the AIL have been found. How did you find
> them, and how can we validate them?

We flush all inodes during either an unmount of also periodically,
so we'll git it there eventually.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
