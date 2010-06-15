Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F7i8Wq078402 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 02:44:08 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EF03AEA2F2
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:50:15 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id c7HrdpaHg3NLF6V4 for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:50:15 -0700 (PDT)
Date: Tue, 15 Jun 2010 09:46:41 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100615074641.GF6727@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100614042700.GC6590@dastard>
	<20100614074309.GA17092@basil.fritz.box>
	<20100614133755.GE6590@dastard>
	<20100614143720.GI17092@basil.fritz.box>
	<20100614222458.GF6590@dastard>
	<20100615070244.GD6727@basil.fritz.box>
	<20100615074028.GA15322@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615074028.GA15322@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 15, 2010 at 03:40:28AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 09:02:45AM +0200, Andi Kleen wrote:
> > I suspect you miss quite a lot of valuable information from
> > your user base by not supporting kerneloops.org. On the other
> > hand it would likely also save you from spending time on 
> > flakes.
> > 
> > That said you don't need BUG_ON to support it (WARN etc. work
> > too), it's just the easiest way.
> 
> Note that a XFS filesystem shutdown already gives a stack trace.
> But picking up every filesystem shutdown on kerneloops.org seems
> to be quite a bit too much.  It's usually due to IO errors from
> the underlying device.

Yes, but known race check asserts should be probably there, right?
Maybe you need a special kind of ASSERT (or shutdown) for those? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
