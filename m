Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VEqJWr021375 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 08:52:19 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BonLJw8V5UWoUuE2 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 06:52:17 -0800 (PST)
Date: Tue, 31 Jan 2012 09:52:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131145205.GA6607@infradead.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131103126.GA46170@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 10:31:26AM +0000, Brian Candler wrote:
> - seek to inode (if the inode block isn't already in cache)
> - seek to extents table (if all extents don't fit in the inode)
> - seek(s) to the file contents, depending on how they're fragmented.
> 
> I am currently seeing somewhere between 7 and 8 seeks per file read, and
> this just doesn't seem right to me.

You don't just read a single file at a time but multiple ones, don't
you?

Try playing with the following tweaks to get larger I/O to the disk:

 a) make sure you use the noop or deadline elevators
 b) increase /sys/block/sdX/queue/max_sectors_kb from its low default
 c) dramatically increase /sys/devices/virtual/bdi/<major>:<minor>/read_ahead_kb

> OK. I saw "df -i" reporting a stupid number of available inodes, over 500
> million, so I decided to reduce it to 100 million.  But df -k didn't show
> any corresponding increase in disk space, so I'm guessing in xfs these are
> allocated on-demand, and the inode limit doesn't really matter?

Exactly, the number displayed is the upper bound.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
