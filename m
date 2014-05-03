Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D8477F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:16:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B8E5AC002
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:16:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id QSWNiMIlXfb8CjwJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:16:01 -0700 (PDT)
Date: Sat, 3 May 2014 08:16:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140503151601.GB28608@infradead.org>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
	<20140502100802.GB14028@infradead.org>
	<20140502232339.GD26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502232339.GD26353@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, May 03, 2014 at 09:23:39AM +1000, Dave Chinner wrote:
> before we get to the transaction that can fail:
> block_truncate_page() zeroes the tail of the page cache page. Hence
> if the transaction reservation fails, we've already trashed the file
> data - we may as well finish off the job and at least make it look
> like the truncate succeeded from a user point of view. They then get
> a ENOMEM error (only non-fatal error that can come from
> xfs_trans_reserve) and try the truncate again....

I don't think we can even get the ENOMEM.  But yeah, I guess
we want something like the old version, with comments explaining exactly
we we have this order.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
