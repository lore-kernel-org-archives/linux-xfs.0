Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0N07kbI124699 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 18:07:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CD62185276B
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:07:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BNcvXkF9ywZFA8GE for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:07:02 -0800 (PST)
Date: Thu, 22 Jan 2009 19:06:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090123000617.GB4970@infradead.org>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
	<20090123000203.GC32390@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090123000203.GC32390@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org, npiggin@yahoo.com.au, xfs@oss.sgi.com

> [XFS] Check buffer lengths in log recovery
> 
> Before trying to obtain, read or write a buffer,
> check that the buffer length is actually valid. If
> it is not valid, then something read in the recovery
> process has been corrupted and we should abort
> recovery.
> 
> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Tested-by: Eric Sesterhenn <snakebyte@gmx.de>


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
