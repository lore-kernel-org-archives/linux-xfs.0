Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72NVXCO254878 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 18:31:34 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ObKNC9MJinhNpTG9 for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 16:31:32 -0700 (PDT)
Date: Fri, 3 Aug 2012 09:31:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db: bug in bmap command?
Message-ID: <20120802233131.GQ2877@dastard>
References: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
	<501AFCF1.70804@sandeen.net> <501AFE80.40709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501AFE80.40709@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Peter Watkins <treestem@gmail.com>, xfs@oss.sgi.com

On Thu, Aug 02, 2012 at 05:26:08PM -0500, Eric Sandeen wrote:
> On 8/2/12 5:19 PM, Eric Sandeen wrote:
> > On 8/1/12 10:17 AM, Peter Watkins wrote:
> >> Hello,
> >>
> >> If you have a moment would you be kind enough to review the test case
> >> and patch below?
> >>
> >> I ran into this while using xfs_db to dump extents for a large,
> >> fragmented file. The extents were stored in btree form.
> > 
> > The xfs_db change looks right.
> 
> (and I'll merge it, Reviewed-by: Eric Sandeen <sandeen@sandeen.net> )

Not so fast!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
