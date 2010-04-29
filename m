Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T5XXPo041539 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 00:33:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DAE18EBCDF
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 22:35:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	G0caX1Pv1fvGCkMu for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 22:35:37 -0700 (PDT)
Date: Thu, 29 Apr 2010 15:35:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Add query fiemap count test.
Message-ID: <20100429053514.GA3774@dastard>
References: <20100428015035.GC9783@dastard>
	<1272437450-4654-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272437450-4654-1-git-send-email-tao.ma@oracle.com>
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
To: Tao Ma <tao.ma@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 02:50:50PM +0800, Tao Ma wrote:
> According to Documentation/filesystems/fiemap.txt, If fm_extent_count
> is zero, then the fm_extents[] array is ignored (no extents will be
> returned), and the fm_mapped_extents count will hold the number of
> extents needed.
> 
> This is broken by commit 97db39a1f6f69e906e98118392400de5217aa33a.
> So add this test case in fiemap tester to avoid future regression.
> 
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alex Elder <aelder@sgi.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

Looks ok. Just running for a test and if I don't see any problems,
then I'll check it in. Thanks for the fix and the test, Tao. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
