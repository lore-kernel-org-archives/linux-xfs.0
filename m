Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T1sLCU197697 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 20:54:21 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCC8A384D9C
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 18:57:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7roT2tST1J1NUvzT for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2011 18:57:30 -0700 (PDT)
Date: Tue, 29 Mar 2011 12:57:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Very aggressive memory reclaim
Message-ID: <20110329015727.GE3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard> <m2bp0u23wl.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m2bp0u23wl.fsf@firstfloor.org>
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
Cc: linux-mm@kvack.org, John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Mar 28, 2011 at 04:58:50PM -0700, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > First it would be useful to determine why the VM is reclaiming so
> > much memory. If it is somewhat predictable when the excessive
> > reclaim is going to happen, it might be worth capturing an event
> 
> Often it's to get pages of a higher order. Just tracing alloc_pages
> should tell you that.

Yes, the kmem/mm_page_alloc tracepoint gives us that. But in case
that is not the cause, grabbing all the trace points I suggested is
more likely to indicate where the problem is. I'd prefer to get more
data than needed the first time around than have to do multiple
round trips because a single trace point doesn't tell us the cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
