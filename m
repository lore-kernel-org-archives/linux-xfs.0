Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35NbO6n030560 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 18:37:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D2201DCCA8C
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 16:39:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	VS1vmaj4CYJ9APEW for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 16:39:12 -0700 (PDT)
Date: Tue, 6 Apr 2010 09:39:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: make the log ticket transaction id random
Message-ID: <20100405233910.GA11036@dastard>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
	<1270125691-29266-4-git-send-email-david@fromorbit.com>
	<20100403093156.GD20166@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100403093156.GD20166@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Apr 03, 2010 at 05:31:56AM -0400, Christoph Hellwig wrote:
> On Thu, Apr 01, 2010 at 11:41:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The transaction ID that is written to the log for a transaction is
> > currently set by taking the lower 32 bits of the memory address of
> > the ticket structure.  This is not guaranteed to be unique as
> > tickets comes from a slab and slots can be reallocated immediately
> > after being freed. As a result, there is no guarantee of uniqueness
> > in the ticket ID value.
> > 
> > Fix this by assigning a random number to the ticket ID field so that
> > it is extremely unlikely that duplicates will occur and remove the
> > possibility of transactions being mixed up during recovery due to
> > duplicate IDs.
> 
> I already noticed that you uses a random tid in your delayed logging
> patches.  But even a random number means we can get duplicate tids.

Agreed. However, random duplicates are much more unlikely, IMO, than
memory addresses of slab objects. The existing code is giving quite
regular duplicates according to the tracing I added, but I didn't
find any from the sampling I did with this patch....

> If we assign tids from a wrapping counter instead we can guarantee
> that they are unique as long as we don't have more than UINT_MAX
> transactions in the log, which is a limitation we could easily enforce.

Ideally, yes. However, I didn't want to introduce a global
monatomically increasing counter into the transaction code. I'm
seeing upwards of 50-60k transactions/s on my test box - that's
getting into the range where reliable global counters become
scalability limitations. I know this can be solved, but it is
somewhat complex and I'm not sure at this point that the complexity
is necessary. What do you think?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
