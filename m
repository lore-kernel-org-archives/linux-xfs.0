Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8SHKIm1137217 for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 12:20:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E528848591E
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 10:21:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dZwKWtflFLYT7bJK for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2009 10:21:39 -0700 (PDT)
Date: Mon, 28 Sep 2009 13:21:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Possible small bug in xfsprogs-dev/db/metadump.c
Message-ID: <20090928172137.GA21868@infradead.org>
References: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: xfs@oss.sgi.com

[Cc'ed to the list, where people including the most active person on the
 userspace side hang out]

On Sun, Sep 27, 2009 at 12:20:33PM -0700, Richard Sharpe wrote:
> Hi folks,
> 
> There seems to be a small bug in
> xfsprogs-dev/db/metadump.c:scanfunc_freesp (although I think the same
> problem exists in other functions).
> 
> It has a check to see if the number of records is invalid:
> 
>         numrecs = be16_to_cpu(block->bb_numrecs);
>         if (numrecs > mp->m_alloc_mxr[1]) {
>                 if (show_warnings)
>                         print_warning("invalid numrecs (%u) in %s block %u/%u",
>                                 numrecs, typtab[btype].name, agno, agbno);
>                 return 1;
>         }
> 
> However, it seems to me that you should pay attention to bb_level in
> the node when using that test, because leaf nodes can appear at
> multiple levels in the tree.

Before that code there is a

	if (level == 0)
		return 1;

which should take care of the leaf nodes by exiting early.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
