Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7E167F54
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 17:37:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7F00304051
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:37:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PaasE1lAn8C0uWRp for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 15:37:39 -0800 (PST)
Date: Fri, 9 Jan 2015 10:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: move xfs_fs.h to libxfs
Message-ID: <20150108231540.GK25000@dastard>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
	<1420666983-7275-2-git-send-email-david@fromorbit.com>
	<20150108124446.GA3424@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108124446.GA3424@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 04:44:46AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 08, 2015 at 08:43:00AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Ioctl API definitions are shared with userspace, so move the header
> > file that defines them all to libxfs along with all the other code
> > shared with userspace.
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> This might also be a good time to get rid of the ifdefs in there
> for IRIX compatibility.

I'll have to check the userspace autoconf stuff to see if we can do
that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
