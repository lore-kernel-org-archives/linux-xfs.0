Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TCx07l205151 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 07:59:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74D2148985D
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 06:00:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uVst2OrfGEtkBgZL for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2009 06:00:22 -0700 (PDT)
Date: Tue, 29 Sep 2009 09:00:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Possible small bug in xfsprogs-dev/db/metadump.c
Message-ID: <20090929130022.GD11375@infradead.org>
References: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
	<20090928172137.GA21868@infradead.org>
	<46b8a8850909281036j1bdbf61h18b4134912735d92@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <46b8a8850909281036j1bdbf61h18b4134912735d92@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Sep 28, 2009 at 10:36:13AM -0700, Richard Sharpe wrote:
> >
> > ? ? ? ?if (level == 0)
> > ? ? ? ? ? ? ? ?return 1;
> >
> > which should take care of the leaf nodes by exiting early.
> 
> Well, yes there is, but that is the problem I encountered. It is level
> as passed in when starting at the top of the tree, which is obtained
> from the levels value in the AGF, and is decremented by one on each
> recursion:
> 
>         if (!(*func)(iocur_top->data, agno, agbno, level - 1, btype, arg))
> 
> However, what should really be looked at is the value bb_level in the
> header in each free-space Btree node.

I think bother are equally valid.  The one passed in fro mthe top should
always be right while the ondisk one might be corrupted.

> After I made that change to my changes, I started being able to
> properly count all leaf nodes and free extents, and the numbers came
> out where I expected them to be (instead of not seeing many leaf nodes
> and vastly undercounting free extents).

Still not quite understanding your problem here.  Do you have a tool
of your own that doesn't start from the btree root but only walks
subtrees?  In that case you need to look at the on-disk level unless
you can find out easily what level you start at.  But I don't think we
need this for the existing tools that always walk from the root.

> 
> 
> 
> 
> 
> -- 
> Regards,
> Richard Sharpe
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
