Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6BNssV212541
	for <linux-xfs@oss.sgi.com>; Tue, 6 Dec 2011 05:23:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCF4B1DC2AE0
	for <linux-xfs@oss.sgi.com>; Tue,  6 Dec 2011 03:23:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VUrH4AlHqfGkJmjq for <linux-xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 03:23:53 -0800 (PST)
Date: Tue, 6 Dec 2011 06:23:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
Message-ID: <20111206112350.GB10836@infradead.org>
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206110533.GD28326@dastard>
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
Cc: hch@infradead.org, linux-xfs@oss.sgi.com, Peng Haitao <penght@cn.fujitsu.com>

On Tue, Dec 06, 2011 at 10:05:33PM +1100, Dave Chinner wrote:
> On Tue, Dec 06, 2011 at 11:42:14AM +0800, Peng Haitao wrote:
> > 
> > When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
> > the error message should be "Invalid argument".
> 
> Fixing this just requires an additional filter. The write outpu is
> already passed through 2 filters to remove ariable numbers from the
> output, so one more to standardise the error isn't a problem.
> 
> Further, filtering of the error stream on the reads to only appear
> in $seq.full solves the extra error output on reads as well.

Yes, I was about to say the same.  Also now that it passes please add
the test to the "auto" group.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
