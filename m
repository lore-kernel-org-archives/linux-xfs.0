Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD2827F52
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 11:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58EC4AC009
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 09:06:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id tVmDR0GJzUHPgefQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 09:06:46 -0700 (PDT)
Date: Tue, 15 Oct 2013 09:06:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: stop caching inode structures
Message-ID: <20131015160645.GA643@infradead.org>
References: <20131009130241.GA8754@infradead.org>
	<20131014201659.GN4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014201659.GN4446@dastard>
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

On Tue, Oct 15, 2013 at 07:16:59AM +1100, Dave Chinner wrote:
> This all sounds good and the code looks fine, but there's one
> lingering question I have - what's the impact on performance for
> repair? Does it slow down phase 6/7 at all?

I have to admit that I'm just pulling memory from my hat as this is a
repost of an almost 1 year old patch, and I don't have equipment for
large scale performance testing at the moment.

But the biggest speedups I had seen was in filesystems where we had to
delete lots of inodes and thus manipulate the link count of hundreds of
thousands of directories in phase7 - with the current code we thrash the
inode cache badly there and got into deep swapping, and with this patch
we removed that thrashing (and often got the inodes from the buffer
cache still) and got rid of the swapping, causing speedups up to about
10%.  Upto because the numbers for the previous case weren't too
reliable.

Not sure if my wording in the description wasn't clear enough but I
really can't come up with a case where the inode cache would help
in repair - all the users of it will eventually modify the inode and
thus hit the buffers anyway, so any unlikely help during lookup would
still be mood once we write back.

Actually I'll have to correct myself after going through the scenarious
another time - the no_modify case might get hit a little, but I don't
think it's worth optimizing for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
