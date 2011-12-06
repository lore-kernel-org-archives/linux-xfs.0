Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6B5mor211564
	for <linux-xfs@oss.sgi.com>; Tue, 6 Dec 2011 05:05:48 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 028E529E0BB
	for <linux-xfs@oss.sgi.com>; Tue,  6 Dec 2011 03:05:46 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fny5zUBsq1eu6ECn for <linux-xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 03:05:46 -0800 (PST)
Date: Tue, 6 Dec 2011 22:05:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
Message-ID: <20111206110533.GD28326@dastard>
References: <4EDD8F16.4050402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EDD8F16.4050402@cn.fujitsu.com>
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
To: Peng Haitao <penght@cn.fujitsu.com>
Cc: hch@infradead.org, linux-xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 11:42:14AM +0800, Peng Haitao wrote:
> 
> When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
> the error message should be "Invalid argument".

Fixing this just requires an additional filter. The write outpu is
already passed through 2 filters to remove ariable numbers from the
output, so one more to standardise the error isn't a problem.

Further, filtering of the error stream on the reads to only appear
in $seq.full solves the extra error output on reads as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
