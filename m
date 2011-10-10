Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ANCVo3210829 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 18:12:32 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D44AF1C7CEB9
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 16:12:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hGjY1Hj2ksVAiUyg for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 16:12:29 -0700 (PDT)
Date: Tue, 11 Oct 2011 10:12:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5, v3] repair: sector size and blkmap fixes
Message-ID: <20111010231214.GW3159@dastard>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<20111010141825.GF31429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010141825.GF31429@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 10:18:25AM -0400, Christoph Hellwig wrote:
> Any chance we can get some coverage for the losts of extents cases
> in xfstests?  It will probably require pre-created images, but I'd
> really hate not beeing able to regression test this.

Test 042 creates files with a lot of extents, but we don't have
coverage of extent countsin the hundreds of thousands or greater.
I can put together a simple test to do it using preallocation and/or
hole punching, though I'm not sure what the runtime will be.

Given we assume we have at least 10GB on the scratch device, I can
easily create a couple of million extent files on a 4k block size
filesystem for repair/db to walk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
