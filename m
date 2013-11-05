Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D1447FBA
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 13:57:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27B06AC00B
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 11:56:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MTafHgKgIrwspB0F for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 11:56:55 -0800 (PST)
Date: Wed, 6 Nov 2013 06:56:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20131105195650.GA6188@dastard>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
	<20131105164307.GD32110@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131105164307.GD32110@infradead.org>
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

On Tue, Nov 05, 2013 at 08:43:07AM -0800, Christoph Hellwig wrote:
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		int	new_size = mp->m_inode_cluster_size;
> > +
> > +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> > +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> > +			mp->m_inode_cluster_size = new_size;
> > +		xfs_info(mp, "Using inode cluster size of %d bytes",
> > +			 mp->m_inode_cluster_size);
> 
> printing this on every mount seem a bit too verbose.

I'd like to leave it there until we remove the experimental tag from
the v5 superblock configuration, as there is no good way of
determining that someone is using a mkfs patched to enable this
feature yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
