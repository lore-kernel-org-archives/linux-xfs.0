Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE2477F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:52:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5952EAC001
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 13:52:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lzjQLGliHE1maxNt for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 13:52:22 -0800 (PST)
Date: Wed, 3 Dec 2014 08:52:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: move type conversion functions to xfs_dir.h
Message-ID: <20141202215208.GC18131@dastard>
References: <1417475883-21881-1-git-send-email-david@fromorbit.com>
	<1417475883-21881-3-git-send-email-david@fromorbit.com>
	<20141202113626.GA30327@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202113626.GA30327@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 03:36:26AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 02, 2014 at 10:18:03AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > These are currently considered private to libxfs, but they are
> > widely used by the userspace code to decode, walk and check
> > directory structures. Hence they really form part of the external
> > API and as such need to bemoved to xfs_dir2.h.
> 
> Lokos good, but why do we need the additional includes in various files?

Because the conversion functions have a dependency on the struct
xfs_da_geometry definition in xfs_da_btree.h. xfs_dir2_priv.h had
that dependency, but xfs_dir2.h didn't. Now the conversion functions
have been moved, that dependency moves as well...

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Did you mean Reviewed-by? :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
