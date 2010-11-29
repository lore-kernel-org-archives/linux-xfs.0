Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATKfJ3I214607 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 14:41:20 -0600
Subject: Re: [PATCH v4 4/9] xfsrestore: mmap dirent names for faster lookups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101129145627.GB22839@infradead.org>
References: <20101119183837.GA9505@sgi.com>
	<20101123134818.GA31206@infradead.org> <4CF3B875.3020701@sgi.com>
	<20101129145627.GB22839@infradead.org>
Date: Mon, 29 Nov 2010 14:42:10 -0600
Message-ID: <1291063330.2425.12.camel@doink>
Mime-Version: 1.0
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

On Mon, 2010-11-29 at 09:56 -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 08:28:05AM -0600, Bill Kendall wrote:
> > There are several modules in xfsrestore which map files. None of them
> > currently contain a destructor/cleanup function for unmapping the files.
> > It would be a good change to make though.
> 
> If keeping it mapped later it's fine with me.  So ACK from me for the
> whole series.
> 
> Alex, maybe it's time to push out another xfsdump release after this?
> There's quite a few changes that have accumulated.

Yes, I had planned to do that once we got Bill's series
committed.  I am doing a final test of it today before
pushing it to the -dev tree, for starters.

I also wanted to update my metadump series and, after
getting that committed, mark a new release for xfsprogs
as well.  I thought I'd do these releases at the same
time but I guess they don't have to be.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
