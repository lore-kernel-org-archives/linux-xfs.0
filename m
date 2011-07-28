Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6SEoOMY260943 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 09:50:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B19F16892D3
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 07:50:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FZZVfefPFJoeDqBH for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 07:50:39 -0700 (PDT)
Date: Thu, 28 Jul 2011 10:50:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "xfs: fix error handling for synchronous writes" revisited
Message-ID: <20110728145020.GA30785@infradead.org>
References: <CAB4K4y6-2odbRhqn6q7ZDOxqF9oUcj2zKvyCEV6374QGyM-ddA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB4K4y6-2odbRhqn6q7ZDOxqF9oUcj2zKvyCEV6374QGyM-ddA@mail.gmail.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jul 28, 2011 at 04:21:01PM +0530, Ajeet Yadav wrote:
> Just to recall, last year we have reported one hang issue in 2.6.30.9
> wherein we get hang if we remove the device while synchronous write was underway
> It was because synchronous buffer remain locked in case of EIO error.
> 
> In response to that a fix commit: bfc60177f8ab509bc225becbb58f7e53a0e33e81
>  "xfs: fix error handling for synchronous writes" for 2.6.38 was given
> by community
> Unfortunately I did not use this patch and therefore did not test it.
> 
> Coming to present, I run the same test case again, and I got different
> hang pasted below.
> While debugging I compared with my own solution, wherein I did not
> have any issue
> Kindly review the solution patch

Given that xfs_bwrite actually does the shutdown already after
waiting for the b_iodone completion this looks fine to me.  And given
that we actually found that calling xfs_force_shutdown from inside
xfs_buf_iodone_callbacks was a major contributor the problem it looks
like an onversight that we didn't drop this call.

Can you re-send the patch with a proper changelog and signoff?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
