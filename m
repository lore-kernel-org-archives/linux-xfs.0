Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E79729E3F
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 18:32:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3515A8F804C
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 16:32:55 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	v9SwE5MFIn84w8S4 for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 16:32:53 -0800 (PST)
Date: Thu, 7 Nov 2013 11:32:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20131107003249.GL6188@dastard>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
	<20131105164307.GD32110@infradead.org>
	<20131105195650.GA6188@dastard> <20131106213159.GV1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106213159.GV1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 03:31:59PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Nov 06, 2013 at 06:56:50AM +1100, Dave Chinner wrote:
> > On Tue, Nov 05, 2013 at 08:43:07AM -0800, Christoph Hellwig wrote:
> > > > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > > > +		int	new_size = mp->m_inode_cluster_size;
> > > > +
> > > > +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> > > > +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> > > > +			mp->m_inode_cluster_size = new_size;
> > > > +		xfs_info(mp, "Using inode cluster size of %d bytes",
> > > > +			 mp->m_inode_cluster_size);
> > > 
> > > printing this on every mount seem a bit too verbose.
> > 
> > I'd like to leave it there until we remove the experimental tag from
> > the v5 superblock configuration, as there is no good way of
> > determining that someone is using a mkfs patched to enable this
> > feature yet...
> 
> I don't think I have a problem with bumping up the inode cluster size, but I am
> a little concerned about two aspects of this patch:
> 
> 1) Backward compatability issue with earlier v5 filesystems that don't support
> the larger inode cluster.  I know it's experimental, but what do those failures
> look like?  This strikes me as being kind of scary.

There shouldn't be any failures - it should just work.

That is, larger alignment on older kernels will only affect
allocation alignment of new chunks, not the cluster size, and so
everything should work just fine because it's inode chunk alignment
that matters for larger inode clusters to work....

Also, log recovery knows about the fact that inode clusters could
potentially change size from mount to mount and handles such cases
appropriately e.g. see the comment in xlog_recover_buffer_pass2().

Hence there should be no problems at all.

If there are, discovering flaws in my understanding of how inode
alignment and clusters interact is part of reason I have not enabled
this feature on v4 superblocks (as the original commit explained).
If we discover one, then the worst case is that we change mkfs back
to setting sb_inoalign = 2 for the xfsprogs 3.2.0 release and this
code in the kernel becomes a no-op...


> 2) I don't like to overload the inode alignment mkfs option to do this.  I
> think it would be better if we explicitly set the inode cluster size at mkfs
> time.

Overload? Not at all - inode alignment was introduced back in 1996
specifically to alleviate performance issues with mapping inode
numbers to cluster buffers way back in 1996. The two have been
intimately related for a long time, and you can't use larger inode
clusters without first adjusting the inode alignment to support
those larger cluster sizes.

FWIW, the kernel is free to use whatever cluster size it likes as
they are an in-memory construct - the kernel can do inode IO in
single blocks if it wants to or needs to. However, it can't do
correct inode number to cluster offset calculations if the inode
chunk block number is not appropriately aligned for the size of the
cluster it wants to use.

Originally (1995), clusters were 4k:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=3f6e8796aa0c6511a6c33035ab75a842e27ab8da

months later, 8k:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=94c9a3cfa5c94ca002dfb3476b321422337e7637

But we don't have the history of mkfs available to what inode
alignment was used at the time.

Then when the various Irix trees got merged into a combined tree a
few months later, both 4k and 8k clusters were supported:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=978576245cd1d77c157ae39e4a569e7b88c3a75b
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=7c9131fe8bd196ed4dda6af83d62dde87486b205
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=e50cfe641aa9555e8446318c8db865671b284a5d

And so you can see that the cluster size was chosen base on the
amount of RAM the system had. However, because mkfs never set an
alignment of more than 2 blocks, the cluster size couldn't be
increased to be any larger....

> Or maybe this one should have an incompatability bit.  Maybe it doesn't need to
> be a separate mkfs option.

It shouldn't need an incompatibility bit, nor should it be a
separate mkfs option for v5 filesystems. Whether either are
necessary for v4 filesystems is separate discussion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
