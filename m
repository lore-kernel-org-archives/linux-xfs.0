Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF89D7F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 10:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B254F304051
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 08:21:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id fNvh4jCSQ8AGpuXR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 08:21:47 -0700 (PDT)
Date: Wed, 23 Apr 2014 08:21:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] generic/204: tweak reserve pool size
Message-ID: <20140423152146.GA26128@infradead.org>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
	<1398204274-2113-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398204274-2113-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 08:04:29AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On small block size filesystems, the reserve pool size is kept
> constant at 4MB. filesystems with smaller blocks use comparitively
> more blocks for indexing metadata (e.g. in the inode and extent
> btrees) and so having a higher indirect block usage. Hence we need
> to leave the reserve pool at 1024 block and not scale it for a
> constant size.
> 
> This makes the test pass on a filesystem made with MKFS_OPTIONS="-b
> size=1024 -m crc=1".

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
