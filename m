Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBHNEKAC132354 for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 17:14:21 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Zqs3bs3oFeMnuvX2 for <xfs@oss.sgi.com>;
	Sat, 17 Dec 2011 15:14:19 -0800 (PST)
Date: Sat, 17 Dec 2011 18:14:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/12] xfs: add compound buffer get and read interfaces
Message-ID: <20111217231418.GB2383@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<1323238703-13198-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-5-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

After looking over all the patches I really thing we should be passing
struct xfs_buf_vec arguments to the functions, and provide a helper
to convert struct xfs_bmbt_irec to the callers.  That avoids having to
add the XFS_EXT_DADDR hack, and keeps the amount of data structures
used in the buffer cache small.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
