Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 05:05:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83C59Mt021776
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 05:05:10 -0700
Date: Wed, 3 Sep 2008 08:06:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Tweak tracing allocation sizes
Message-ID: <20080903120635.GA14662@infradead.org>
References: <48BCD3BE.5040107@sgi.com> <20080902055604.GD15962@disturbed> <48BCD93E.9040407@sgi.com> <87fxojvy5v.fsf@basil.nowhere.org> <20080902215516.GE9204@infradead.org> <20080903070654.GP18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903070654.GP18288@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, lachlan@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 03, 2008 at 09:06:54AM +0200, Andi Kleen wrote:
> On Tue, Sep 02, 2008 at 05:55:16PM -0400, Christoph Hellwig wrote:
> > On Tue, Sep 02, 2008 at 08:50:52AM +0200, Andi Kleen wrote:
> > > > alternative - maybe a very large global trace buffer that is allocated at mount
> > > > time and shared by all inodes?
> > > 
> > > You could use vmalloc(). While that is also not fast it will at least
> > > not stall.
> > 
> > In fact kmem_alloc first tries vmalloc, and then falls back to slab
> > when it fails.  See fs/xfs/linux-2.6/kmem.c:kmem_alloc().
> 
> You mean the other way around? 

No, take a look at the function.  I guess the intent is that vmalloc
can fail due to a full vmalloc area and kmalloc could theoretically
still scucceed.
