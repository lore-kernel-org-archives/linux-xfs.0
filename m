Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o339U8Bt034349 for <xfs@oss.sgi.com>; Sat, 3 Apr 2010 04:30:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB6DE2987B7
	for <xfs@oss.sgi.com>; Sat,  3 Apr 2010 02:31:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Gg6TsirewhWWPvPS for
	<xfs@oss.sgi.com>; Sat, 03 Apr 2010 02:31:56 -0700 (PDT)
Date: Sat, 3 Apr 2010 05:31:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: make the log ticket transaction id random
Message-ID: <20100403093156.GD20166@infradead.org>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
	<1270125691-29266-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270125691-29266-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 01, 2010 at 11:41:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The transaction ID that is written to the log for a transaction is
> currently set by taking the lower 32 bits of the memory address of
> the ticket structure.  This is not guaranteed to be unique as
> tickets comes from a slab and slots can be reallocated immediately
> after being freed. As a result, there is no guarantee of uniqueness
> in the ticket ID value.
> 
> Fix this by assigning a random number to the ticket ID field so that
> it is extremely unlikely that duplicates will occur and remove the
> possibility of transactions being mixed up during recovery due to
> duplicate IDs.

I already noticed that you uses a random tid in your delayed logging
patches.  But even a random number means we can get duplicate tids.
If we assign tids from a wrapping counter instead we can guarantee
that they are unique as long as we don't have more than UINT_MAX
transactions in the log, which is a limitation we could easily enforce.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
