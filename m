Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A1C97CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 09:53:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AE5B8F8033
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 07:53:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Kv61lUKbpbNQZ1a2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 07:53:19 -0700 (PDT)
Date: Mon, 29 Aug 2016 07:52:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 800b269
Message-ID: <20160829145249.GF22760@birch.djwong.org>
References: <20160826062508.GG19025@dastard>
	<20160826074844.GA17137@infradead.org>
	<20160829013111.GN19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829013111.GN19025@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 11:31:12AM +1000, Dave Chinner wrote:
> On Fri, Aug 26, 2016 at 12:48:44AM -0700, Christoph Hellwig wrote:
> > Hi Dave,
> > 
> > please consider: "[PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for
> > extent based filesystems"
> > 
> > for 4.8.  It fixes a regression in the iomap-based fiemap
> > implementation, and it's fairly trivial as well.
> 
> Oh, damn, I thought I got that one. I'll append it to the
> series and push it out.

It might be a good idea to pick up "xfs: track log done items directly
in the deferred pending work item" too, if it fixes the slab
corruptions that Christoph reported.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
