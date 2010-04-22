Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGempm215569 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:40:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F9FF8A5551
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:42:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 93BfB5HWfwlaB8ES for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:42:49 -0700 (PDT)
Date: Thu, 22 Apr 2010 12:42:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100422164247.GA15882@infradead.org>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop> <20100420103216.GK15130@dastard>
	<20100421084004.GS5683@laptop>
	<20100422163211.GA2478@infradead.org>
	<20100422163801.GZ5683@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422163801.GZ5683@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, Apr 23, 2010 at 02:38:01AM +1000, Nick Piggin wrote:
> I don't understand, it should be implemented like just all the other
> shrinkers AFAIKS. Like the dcache one that has to shrink multiple
> superblocks. There is absolutely no requirement for this API change
> to implement it in XFS.

The dcache shrinker is an example for a complete mess.

> But the shrinker list *is* a global list. The downside of it in the way
> it was done in the XFS patch is that 1) it is much larger than a simple
> list head, and 2) not usable by anything other then the shrinker.

It is an existing global list just made more useful.  Whenever a driver
has muliple instances of pool that need shrinking this comes in useful,
it's not related to filesystems at all. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
