Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC40F29DF9
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:01:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7FA28F8039
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 03:01:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id SGBGY1qIVpEOhJAS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 03:01:14 -0800 (PST)
Date: Mon, 18 Nov 2013 03:01:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] xfs: introduce a new helper
	xfs_inobt_reada_chunk()
Message-ID: <20131118110113.GA1304@infradead.org>
References: <5281F509.7020105@oracle.com>
	<20131115170325.GA16942@infradead.org>
	<5288B58D.5030609@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5288B58D.5030609@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> > I'd prefer to factor this out even further. xfs_ialloc_inode_init and
> > xfs_ifree_cluster already have two pieces of code that calculate these
> > two (with more readable names) and an additional nuber buffers counter
> > we won't need here, it might make most sense to factor that into a
> > single common helper.
> Yup, I also thought this can be factored out, however, I can not figure out
> a meaningful function name at that time due to my poor skill...
> 
> How about if we introduce an inline helper to xfs_ialloc.h as below?
> 
> /* Helper function to extract the # of blocks/inodes/buffers hint per cluster */
> static inline void
> xfs_ialloc_get_cluster_hints(
> 	struct xfs_mount	*mp,
> 	int			*nblks;
> 	int			*ninodes;
> 	int			*nbufs)
> {
> 	....
> }

Probably fine to make it an inline.  I don't think we need the nbufs
parameter, as it requires the length to calculate, and it's a trivial
length / blks_per_cluster.

Similarly the ninodes value is trivially calculatable, so it might be
as easy as:

static inline int
xfs_ialloc_blks_per_cluster(struct xfs_mount *mp)
{
	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))
		return 1;
	return XFS_INODE_CLUSTER_SIZE(mp) / mp->m_sb.sb_blocksize;
}


...

	blks_per_cluster = xfs_ialloc_blks_per_cluster(mp);
	nbufs = length / blks_per_cluster;
	ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
