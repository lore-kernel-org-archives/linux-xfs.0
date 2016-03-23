Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B601C7CA0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 22:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38D1AAC007
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 20:41:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xuBW6VAXyLbWgtVb for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2016 20:41:06 -0700 (PDT)
Date: Wed, 23 Mar 2016 14:40:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/12] xfs/030: fix output on newer filesystems
Message-ID: <20160323034040.GA11812@dastard>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003756.28738.26362.stgit@birch.djwong.org>
	<20160305202050.GF10245@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305202050.GF10245@infradead.org>
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
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sat, Mar 05, 2016 at 12:20:50PM -0800, Christoph Hellwig wrote:
> Still fails for me:
> 
> --- tests/xfs/030.out	2016-03-03 07:55:58.556427678 +0000
> +++ /root/xfstests/results//xfs/030.out.bad	2016-03-05 20:20:17.561433837 +0000
> @@ -231,8 +231,6 @@
>  bad agbno AGBNO in agfl, agno 0
>  bad agbno AGBNO in agfl, agno 0
>  bad agbno AGBNO in agfl, agno 0
> -bad agbno AGBNO in agfl, agno 0
> -bad agbno AGBNO in agfl, agno 0

That's because the free lists are of different lengths on the
different fs configs. Not sure how best to handle it - maybe just
filter then entire bad agbno in agfl line out?

I'm going to commit the change anyway, as this is a separate issue
that needs to be solved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
