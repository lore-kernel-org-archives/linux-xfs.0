Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F7c0sY078055 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 02:38:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A01221B1D357
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:40:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ng0mBuhPQQ1F3J7J for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 00:40:36 -0700 (PDT)
Date: Tue, 15 Jun 2010 03:40:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100615074028.GA15322@infradead.org>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100614042700.GC6590@dastard>
	<20100614074309.GA17092@basil.fritz.box>
	<20100614133755.GE6590@dastard>
	<20100614143720.GI17092@basil.fritz.box>
	<20100614222458.GF6590@dastard>
	<20100615070244.GD6727@basil.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615070244.GD6727@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 15, 2010 at 09:02:45AM +0200, Andi Kleen wrote:
> I suspect you miss quite a lot of valuable information from
> your user base by not supporting kerneloops.org. On the other
> hand it would likely also save you from spending time on 
> flakes.
> 
> That said you don't need BUG_ON to support it (WARN etc. work
> too), it's just the easiest way.

Note that a XFS filesystem shutdown already gives a stack trace.
But picking up every filesystem shutdown on kerneloops.org seems
to be quite a bit too much.  It's usually due to IO errors from
the underlying device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
