Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD8BD7CA6
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 17:05:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60F47AC001
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 15:05:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id W5kkqGXydVCfMswQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 15:05:42 -0700 (PDT)
Date: Mon, 28 Mar 2016 15:05:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/16] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20160328220506.GB5822@birch.djwong.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<1457410578-30233-6-git-send-email-david@fromorbit.com>
	<20160310141913.GC29058@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310141913.GC29058@infradead.org>
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

On Thu, Mar 10, 2016 at 06:19:13AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 08, 2016 at 03:16:07PM +1100, Dave Chinner wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > For the rmap btree to work, we have to fed the extent owner
> 
> s/fed/feed/

<nod>

> 
> > +/*
> > + * Ownership info for an extent.  This is used to create reverse-mapping
> > + * entries.
> > + */
> > +#define XFS_RMAP_INO_ATTR_FORK	(1)
> > +#define XFS_RMAP_BMBT_BLOCK	(2)
> 
> These are OR-able flags - it might make sense to define them as:
> 
> #define XFS_RMAP_INO_ATTR_FORK	(1 << 0)
> #define XFS_RMAP_BMBT_BLOCK	(1 << 1)
> 
> to make this more obvious.

Ok.  Will do when I merge the "separate xfs_rmap_irec flags field" patch
into the appropriate patches (like this one).

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
