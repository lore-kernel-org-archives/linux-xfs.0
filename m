Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E5F57F4E
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 04:49:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F3728F8052
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 02:49:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HHNGMv5W7nATCBin for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 02:49:16 -0800 (PST)
Date: Fri, 13 Dec 2013 21:48:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131213104853.GS10988@dastard>
References: <20131213071407.GA6527@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213071407.GA6527@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 02:14:07AM -0500, Dave Jones wrote:
> I can hit this pretty reliably on one of my slower test machines.
> (8gb ram, 1 slow sata disk)
> 
> the machine is pretty responsive, and recovers after a while.
> anything we can do to shut it up ?

Actually, I think this indicates a problem.

> BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u8:2:8479]
...
> Call Trace:
>  [<c112f8f8>] lru_add_drain+0x1c/0x39
>  [<c112f934>] __pagevec_release+0x10/0x26
>  [<c112baba>] write_cache_pages+0x2f9/0x486

That code in write_cache_pages():

1907         while (!done && (index <= end)) {
1908                 int i;
1909
1910                 nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
1911                               min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)
1912                 if (nr_pages == 0)
1913                         break;
1914
1915                 for (i = 0; i < nr_pages; i++) {
1916                         struct page *page = pvec.pages[i];
....
....
2001                 }
2002                 pagevec_release(&pvec);
2003                 cond_resched();
2004         }

So after all the pages in a pagevec are processed, we release the
CPU before we grab the next pagevec. This softlockup implies we
have been processing this pagevec for 22s. That tells me the code
is actually stuck spinning on something, not that this is a false
positive. i.e. it should not take 22s to process 14 pages. 

[ Yes, I know XFS can process more than that ->writepage, but it's
still only a millisecond of work if it doesn't block on anything.
And it can't be blocking, otherwise we wouldn't be firing the
softlockup warning. ]

The page cache LRU code is a maze of twisty per-cpu passages that go
deep into the mm subsystem and memcg code - I'm not really sure what
all that code is doing, so you'll probably have to ask someone who
knows about that code.

All I can say is that there doesn't look to be any obvious signs
that this is a XFS or writeback problem fom the stack trace, and
without more information or a reproducable test case I'm not going
to be able to understand the cause.

Is the problem reproducable, or is it just a one-off?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
