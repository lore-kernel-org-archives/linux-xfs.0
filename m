Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BECBE7CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 21:56:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A242AC001
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 19:56:54 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0t8sNd8ZYDOYF7d0 for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 19:56:50 -0800 (PST)
Date: Tue, 8 Mar 2016 14:56:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: pad xfs_attr_leaf_name_remote to avoid tripping
	on m68k
Message-ID: <20160308035648.GV30721@dastard>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-7-git-send-email-david@fromorbit.com>
	<20160307162858.GE19784@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160307162858.GE19784@infradead.org>
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

On Mon, Mar 07, 2016 at 08:28:58AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 07, 2016 at 08:49:50AM +1100, Dave Chinner wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > Pad the xfs_attr_leaf_name_remote so that we don't trip the structure
> > size checker on m68k.
> > 
> > [dchinner: add comment, XFS_ATTR_LEAF_NAME_BYTES constant and make sure
> > 	   xfs_attr_leaf_entsize_remote() does the right thing. ]
> 
> I think using a small fixed size array as a variable sized array
> is not a good idea, especially with increasinly "smart" optimizing
> compilers.  I'd rather take this structure out the size checking,
> and then move it to a C99 VLA instead of the size 1 hack in the long
> run.

I don't have the time right now to do this, so I'm just going to
drop it - I'd guess the overlap between m68k and XFS users is so
close to zero that it just doesn't matter.  I'll just drop this
patch for now.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
