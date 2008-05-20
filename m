Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 23:10:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K6A9um027534
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:10:13 -0700
Date: Tue, 20 May 2008 16:10:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080520061047.GP103491721@sgi.com>
References: <20080516222755.3e557c00@galadriel.home> <20080518131855.GA1383@infradead.org> <20080518132127.GA19006@infradead.org> <20080518154208.77b6be3e@galadriel.home> <20080519221057.75e0a775@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080519221057.75e0a775@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, May 19, 2008 at 10:10:57PM +0200, Emmanuel Florac wrote:
> Le Sun, 18 May 2008 15:42:08 +0200 vous écriviez:
> 
> > IIRC I tried both, however I'll double check monday...
> 
> Well obviously I didn't try both, because it worked as expected when
> using "inode64". However there'ssomething slightly weird in the data
> layout:
> 
> /dev/dm-0:
> AG     Inodes    IUsed    IFree    Use%
>   0      4288     4277       11     99%
>   1         0        0        0      0%
>   2         0        0        0      0%
.....

If there's no free space in AGs > 0 when you enable inode64, then
you will still get enospc...

> See how all inodes are in the same vg? is it OK?
                                     ^^ AG

This is typical of inode32 allocation...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
