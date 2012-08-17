Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HI2wNq072351 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 13:02:58 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8B5c930vTtiUFIWP (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 11:02:57 -0700 (PDT)
Date: Fri, 17 Aug 2012 14:02:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS regression: Oops in xfs_buf_do_callbacks on xfstest 137
Message-ID: <20120817180254.GA15382@infradead.org>
References: <501ABC84.6030708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501ABC84.6030708@sandeen.net>
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

I'd be this is my new code added to xfs_buf_item_unpin, but I don't
quite understand why.  It's been a long time since I wrote that code,
but I had to add that code to make sure we clear all buffers during
a forced shutdown.  Can you test if things go away if you just remove it
(even if causes other hangs?)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
