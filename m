Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AFEE7F56
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 05:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41D3A30404E
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 03:08:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id NpurRqyLZDMyxJLD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 03:08:03 -0700 (PDT)
Date: Fri, 2 May 2014 03:08:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502100802.GB14028@infradead.org>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502070054.GC26353@dastard>
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
Cc: xfs@oss.sgi.com

On Fri, May 02, 2014 at 05:00:54PM +1000, Dave Chinner wrote:
> The reason truncate_setsize() was located where in this place was
> that we can't change the file size until after we are in the
> transaction context and the operation will either succeed or shut
> down the filesystem on failure. Hence we have to split
> truncate_setsize() back into a pagecache operation that occurs
> before the transaction context, and a i_size_write() call that
> happens within the transaction context.

Further updating myself earlier on the comment next to
truncate_pagecache claims that the file size must have been updated
before, but I can't see a reason for that.

This version looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
