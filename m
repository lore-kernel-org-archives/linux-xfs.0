Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGtFp4217027 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:55:15 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F0E38AA86A
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:57:15 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id DL0xDheBgTccEiUF for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 09:57:15 -0700 (PDT)
Date: Fri, 23 Apr 2010 02:57:11 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100422165711.GA5683@laptop>
References: <1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop> <20100420103216.GK15130@dastard>
	<20100421084004.GS5683@laptop>
	<20100422163211.GA2478@infradead.org>
	<20100422163801.GZ5683@laptop>
	<20100422164247.GA15882@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422164247.GA15882@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Apr 22, 2010 at 12:42:47PM -0400, Christoph Hellwig wrote:
> On Fri, Apr 23, 2010 at 02:38:01AM +1000, Nick Piggin wrote:
> > I don't understand, it should be implemented like just all the other
> > shrinkers AFAIKS. Like the dcache one that has to shrink multiple
> > superblocks. There is absolutely no requirement for this API change
> > to implement it in XFS.
> 
> The dcache shrinker is an example for a complete mess.

I don't know. It's not really caused by not registering multiple
shrinkers. It seems to be caused more by the locking, which is not
going away when you have multiple shrinkers.

The XFS patch seems to be pinning the mount structure when it is
registered, so it would have no such locking/refcounting problems
using a private list AFAIKS.


> > But the shrinker list *is* a global list. The downside of it in the way
> > it was done in the XFS patch is that 1) it is much larger than a simple
> > list head, and 2) not usable by anything other then the shrinker.
> 
> It is an existing global list just made more useful.  Whenever a driver
> has muliple instances of pool that need shrinking this comes in useful,
> it's not related to filesystems at all. 

I would say less useful, because shrinker structure cannot be used
by anything but the shrinker, wheras a private list can be used by
anything, including the applicable shrinker.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
