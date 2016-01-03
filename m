Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EA377F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 15:29:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A6C9AC002
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 13:29:36 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ppdbFuMyZlC81sgz for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 13:29:34 -0800 (PST)
Date: Mon, 4 Jan 2016 08:29:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/76] xfs: fix log ticket type printing
Message-ID: <20160103212905.GY19802@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085636.12713.59155.stgit@birch.djwong.org>
	<20160103121353.GA28429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103121353.GA28429@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Jan 03, 2016 at 04:13:53AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 19, 2015 at 12:56:36AM -0800, Darrick J. Wong wrote:
> > Update the log ticket reservation type printing code to reflect
> > all the types of log tickets, to avoid incorrect debug output and
> > avoid running off the end of the array.
> 
> This looks okay, but I think we should use name array initializers
> to make sure it doesn't got out of sync ever.

Good idea, separate patch is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
