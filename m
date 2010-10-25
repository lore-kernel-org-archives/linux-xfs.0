Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PDfx3c234819 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:42:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DE8E151E52B
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:58:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ywg7IfUi3CiKYdur for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:58:43 -0700 (PDT)
Date: Mon, 25 Oct 2010 09:43:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
Message-ID: <20101025134310.GA3758@infradead.org>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
	<20101021125219.GA21472@infradead.org>
	<AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: linux-mips@linux-mips.org, xfs@oss.sgi.com

On Thu, Oct 21, 2010 at 06:57:15PM +0530, Ajeet Yadav wrote:
> Thanks for response,
> 
> Linux kernel I am using is 2.6.30, where as XFS I have ported until 2.6.34
> on given kernel.
> Do you think I need the mentioned API
> flush_kernel_vmap_range/invalidate_kernel_vmap_range in 2.6.30.9 as well.I
> will be grateful if you can provide me sample code for the above API.

I don't really know how to implement it - it's up to the cache
architecture.  Take a look at the existing implementations in 2.6.34+
kernels and possibly ask on the Linux-mips mainglinglist how to
implement it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
