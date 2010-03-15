Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FI77Pn074520 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:07:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E24B1D33FEE
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:08:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HTfxnLi38eJXvEdT for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:08:43 -0700 (PDT)
Date: Mon, 15 Mar 2010 14:08:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100315180841.GA21975@infradead.org>
References: <20100315043000.GK4732@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315043000.GK4732@dastard>
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

On Mon, Mar 15, 2010 at 03:30:00PM +1100, Dave Chinner wrote:
> 	- occasional recovery failure with recovery reading an inode
> 	  buffer that does not contain inodes. Cause unknown, tends
> 	  to be reproduced by xfsqa test 121 semi-reliably. Needs
> 	  further analysis and fixing. May already be fixed with a
> 	  recent fix to commit record synchronisation.

I just saw a corrupted inode buffer during log recovery in 087, even
without the delaylog mount option.  It's however not easily
reproducible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
