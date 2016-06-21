Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1624B7CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 18:47:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC093304039
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 16:47:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EbnQ7wGgI9BVUH5q for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 16:47:17 -0700 (PDT)
Date: Wed, 22 Jun 2016 09:47:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/186: run test on expected XFS configuration
Message-ID: <20160621234716.GC27480@dastard>
References: <1466510507-17548-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466510507-17548-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 21, 2016 at 08:01:47PM +0800, Eryu Guan wrote:
> Usually xfs/186 _notrun on crc enabled XFS because of
> _require_attr_v1, since v2 attr format is always enabled on v5 XFS.
> 
> But when testing on 512B block size XFS, i.e. MKFS_OPTIONS="-m crc=0
> -b size=512", test fails. This is because crc enalbed XFS was

*enabled

> created in the end, not 512B block size XFS with crc disabled, and
> that's not what we want to test.
> 
> The reason why _scratch_mkfs_xfs creates a different XFS than
> expected is that, it may ignore $MKFS_OPTIONS if mkfs fails due to
> conflicts between $MKFS_OPTIONS and the provided mkfs options.
> 
> In the case of xfs/186, "-b size=512" conflicts with "-i size=512",
> and the first mkfs fails, then it ends up with a 4k block size XFS
> with crc enabled (the default config).
> 
> Fix it by checking crc enablement status and attr version in the
> test, to make sure it's testing on expected XFS.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
