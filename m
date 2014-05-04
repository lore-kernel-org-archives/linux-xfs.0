Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C12877F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 19:07:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B27B2304062
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 17:06:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6vGIV8naG4X2E3KQ for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 17:06:50 -0700 (PDT)
Date: Sun, 4 May 2014 10:06:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140504000618.GK26353@dastard>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
	<20140502100802.GB14028@infradead.org>
	<20140502232339.GD26353@dastard>
	<20140503151601.GB28608@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140503151601.GB28608@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 08:16:01AM -0700, Christoph Hellwig wrote:
> On Sat, May 03, 2014 at 09:23:39AM +1000, Dave Chinner wrote:
> > before we get to the transaction that can fail:
> > block_truncate_page() zeroes the tail of the page cache page. Hence
> > if the transaction reservation fails, we've already trashed the file
> > data - we may as well finish off the job and at least make it look
> > like the truncate succeeded from a user point of view. They then get
> > a ENOMEM error (only non-fatal error that can come from
> > xfs_trans_reserve) and try the truncate again....
> 
> I don't think we can even get the ENOMEM.

We can - we pass KM_MAYFAIL to xlog_ticket_alloc() from
xfs_log_reserve().

> But yeah, I guess
> we want something like the old version, with comments explaining exactly
> we we have this order.

I'll send another version of the first patch with an expanded
comment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
