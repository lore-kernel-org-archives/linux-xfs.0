Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VLZPDs101061 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:35:25 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id WDZqcZslqjKpNuNE for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 13:35:24 -0800 (PST)
Date: Tue, 31 Jan 2012 21:35:22 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131213522.GA47420@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131200635.GI9090@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131200635.GI9090@dastard>
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

On Wed, Feb 01, 2012 at 07:06:35AM +1100, Dave Chinner wrote:
> The number of IOs does not equal the number of seeks. Two adjacent,
> sequential IOs issued serially will show up as two IOs, even though
> there was no seek in between. Especially if the files are large
> enough that readahead tops out (500-800k is large enough for this as
> readahead maximum is 128k by default).  So it might be taking 3-4
> IOs just to read the file data.

Ah. And if the IOs are not stacked up, then the platter has to rotate nearly
a whole turn to perform the next one.

> > So the next thing I'd have to do is to try to get a trace of the I/O
> > operations being performed, and I don't know how to do that.
> 
> blktrace/blkparse or seekwatcher.

Excellent, just what I wanted. I've made a start with this and will report
back.

Many thanks for the help and pointers you have provided.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
