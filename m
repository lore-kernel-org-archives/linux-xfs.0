Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VLqEH7102122 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:52:14 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id gOGGwHs0M9gTqAf7 for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 13:52:13 -0800 (PST)
Date: Tue, 31 Jan 2012 21:52:10 +0000
From: Brian Candler <brian@soundmouse.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131215210.GB47420@soundmouse.com>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131145205.GA6607@infradead.org>
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

On Tue, Jan 31, 2012 at 09:52:05AM -0500, Christoph Hellwig wrote:
> You don't just read a single file at a time but multiple ones, don't
> you?

It's sequential at the moment, although I'll do further tests with the -c
(concurrency) option to bonnie++

> Try playing with the following tweaks to get larger I/O to the disk:
> 
>  a) make sure you use the noop or deadline elevators
>  b) increase /sys/block/sdX/queue/max_sectors_kb from its low default
>  c) dramatically increase /sys/devices/virtual/bdi/<major>:<minor>/read_ahead_kb

Thank you very much: I will do further tests with these.

Is the read_ahead_kb knob aware of file boundaries? That is, is there any
risk that if I set it too large it would read useless blocks past the end of
the file?

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
