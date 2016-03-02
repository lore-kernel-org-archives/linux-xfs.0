Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47CA27CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 15:09:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF575AC004
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 13:09:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9utqgYJBDboGGGAp for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2016 13:09:34 -0800 (PST)
Date: Thu, 3 Mar 2016 08:09:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs; for-next branch updated to 31bb236
Message-ID: <20160302210931.GN30721@dastard>
References: <20160301231511.GM30721@dastard>
	<20160302094559.GB18130@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302094559.GB18130@infradead.org>
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

On Wed, Mar 02, 2016 at 01:45:59AM -0800, Christoph Hellwig wrote:
> > Mateusz Guzik (1):
> >       [2e83b79] xfs: fix two memory leaks in xfs_attr_list.c error paths
> 
> This didn't seem to address the comment about using a goto for
> error handling?

I looked at it, and there isn't a case for a goto. The allocated
memory is in a variable local to the if branch where the leak was
found. Using a jump-based error handling stack means making
all those variables global, and then having to make the freeing
of it conditional. Simply didn't seem worth it to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
