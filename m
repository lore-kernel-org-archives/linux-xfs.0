Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69A077F61
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:32:00 -0600 (CST)
Date: Wed, 6 Nov 2013 15:31:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20131106213159.GV1935@sgi.com>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
	<20131105164307.GD32110@infradead.org>
	<20131105195650.GA6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131105195650.GA6188@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi Dave,

On Wed, Nov 06, 2013 at 06:56:50AM +1100, Dave Chinner wrote:
> On Tue, Nov 05, 2013 at 08:43:07AM -0800, Christoph Hellwig wrote:
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > > +		int	new_size = mp->m_inode_cluster_size;
> > > +
> > > +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> > > +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> > > +			mp->m_inode_cluster_size = new_size;
> > > +		xfs_info(mp, "Using inode cluster size of %d bytes",
> > > +			 mp->m_inode_cluster_size);
> > 
> > printing this on every mount seem a bit too verbose.
> 
> I'd like to leave it there until we remove the experimental tag from
> the v5 superblock configuration, as there is no good way of
> determining that someone is using a mkfs patched to enable this
> feature yet...

I don't think I have a problem with bumping up the inode cluster size, but I am
a little concerned about two aspects of this patch:

1) Backward compatability issue with earlier v5 filesystems that don't support
the larger inode cluster.  I know it's experimental, but what do those failures
look like?  This strikes me as being kind of scary.

2) I don't like to overload the inode alignment mkfs option to do this.  I
think it would be better if we explicitly set the inode cluster size at mkfs
time.

Or maybe this one should have an incompatability bit.  Maybe it doesn't need to
be a separate mkfs option.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
