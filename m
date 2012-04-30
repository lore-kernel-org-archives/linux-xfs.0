Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UNCRUV047377 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 18:12:27 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2sR51ZlBIkFehGal for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 16:12:25 -0700 (PDT)
Date: Tue, 1 May 2012 09:12:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Assertion failed: RB_EMPTY_NODE(&bp->b_rbnode)
Message-ID: <20120430231223.GN7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120430143200.GL16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430143200.GL16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 09:32:00AM -0500, Ben Myers wrote:
> While testing this patchset without Jan's freeze work, I hit this assert.  I
> believe I have not seen this one before.
> 
> -Ben
> 
> [36850.416217] XFS: Assertion failed: RB_EMPTY_NODE(&bp->b_rbnode), file: /work/xfs/fs/xfs/xfs_buf.c, line: 838
> [36850.445669] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038

Two problems - the BUG seems to be one that you have reported
before, while the assert failure tends to indicate a use after free
situation on a buffer (i.e.  a log buffer has been torn down while
IO is still in progress). That smells like different symptoms of the
same problem....

I think you are going to have to debug this one, Ben, because I have
not seen anything at all like these problems on any of my test or
stress workloads. I don't even know what test you are running at the
time these failures are occurring, so I can't even start looking...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
