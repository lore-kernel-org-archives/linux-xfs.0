Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQLmTxk232743 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:48:29 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	K10tGPjfATFbYFsk for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 13:50:43 -0800 (PST)
Date: Tue, 27 Nov 2012 08:50:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Project quota behaviour on hardlinks
Message-ID: <20121126215032.GQ32450@dastard>
References: <CAB+GMR8yU4LaU7EwXboKQLDsGGD0N6EuDT4CgxYLpVFPsROKXg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB+GMR8yU4LaU7EwXboKQLDsGGD0N6EuDT4CgxYLpVFPsROKXg@mail.gmail.com>
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
To: Varun Shastry <vrn.shastry@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 26, 2012 at 12:47:08PM +0530, Varun Shastry wrote:
> Hello everyone,
> 
> I wanted to know how project quota behaves on hardlinks when created in
> different tree structures based on below 2 situations.

Test it and see.

> * Does it account twice if the file is hard linked in the same parent?

Hard links are only accounted once to the owner of the inode.

> * Does it account twice if the file is hard linked in a different tree
> which is also set quota in other project?

You can't hard link across directory tree quota boundaries - you'll
get EXDEV. Similarly for rename across directory tree boundaries.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
