Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78B497CA4
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 16:54:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0A03AC004
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:54:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qT00MRysuyyfZRDE for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 14:54:44 -0700 (PDT)
Date: Thu, 14 Apr 2016 07:54:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V2
Message-ID: <20160413215442.GS567@dastard>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460494382-14547-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 01:52:54PM -0700, Christoph Hellwig wrote:
> This series add a new file system I/O path that uses the iomap structure
> introduced for the pNFS support and support multi-page buffered writes.
> 
> This was first started by Dave Chinner a long time ago, then I did beat
> it into shape for production runs in a very constrained ARM NAS
> enviroment for Tuxera almost as long ago, and now half a dozen rewrites
> later it's back.
> 
> The basic idea is to avoid the crazy per-block get_blocks overhead
> and make use of extents in the buffered write path by iterating over
> them instead.
> 
> Chances since V1:
>  - add support for fiemap
>  - fix a test fail on 1k block sizes
>  - prepare for 64-bit length, this will be used in a follow on patchset

This appears to pass xfstests on all my test setups without any
regressions. I haven't tested RT devices yet, but we can ignore that
for now. I guess now it's time to look harder at the code.

Christoph, have you done any perf testing of this patchset yet to
check that it does indeed reduce the CPU overhead of large write
operations? I'd also be interested to know if there is any change in
overhead for single page (4k) IOs as well, even though I suspect
there won't be.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
