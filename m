Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62EWLW8231437 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 09:32:21 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Vq1NFJEeGncyoHOR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 07:32:20 -0700 (PDT)
Date: Mon, 2 Jul 2012 15:32:15 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120702143215.GS14154@suse.de>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de> <20120701235458.GM19223@dastard>
	<20120702063226.GA32151@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702063226.GA32151@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 02:32:26AM -0400, Christoph Hellwig wrote:
> > It increases the CPU overhead (dirty_inode can be called up to 4
> > times per write(2) call, IIRC), so with limited numbers of
> > threads/limited CPU power it will result in lower performance. Where
> > you have lots of CPU power, there will be little difference in
> > performance...
> 
> When I checked it it could only be called twice, and we'd already
> optimize away the second call.  I'd defintively like to track down where
> the performance changes happend, at least to a major version but even
> better to a -rc or git commit.
> 

By all means feel free to run the test yourself and run the bisection :)

It's rare but on this occasion the test machine is idle so I started an
automated git bisection. As you know the milage with an automated bisect
varies so it may or may not find the right commit. Test machine is sandy so
http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-metadata-xfs/sandy/comparison.html
is the report of interest. The script is doing a full search between v3.3 and
v3.4 for a point where average files/sec for fsmark-single drops below 25000.
I did not limit the search to fs/xfs on the off-chance that it is an
apparently unrelated patch that caused the problem.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
