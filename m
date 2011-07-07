Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67LQIwW195863 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 16:26:18 -0500
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110704212055.GA24500@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-3-git-send-email-david@fromorbit.com>
	<20110704212055.GA24500@infradead.org>
Date: Thu, 7 Jul 2011 16:26:16 -0500
Message-ID: <1310073976.1980.84.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2011-07-04 at 17:20 -0400, Christoph Hellwig wrote:
> FYI: the following patch implementing my suggested cleanups survived a
> few rounds of xfsqa:

It also eliminates the concern I had about using the value
of "lip" after falling off the front of the list with a
list_for_each_entry_reverse().  A null pointer signifies
no entry has a lower lsn than the one provided, and
that covers both the "empty list" and the "lower than
all other lsn's in the list" cases.

I think you should base your solution on Christoph's
approach, Dave.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
