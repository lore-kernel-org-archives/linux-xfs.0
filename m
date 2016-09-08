Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E6FE7CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 18:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E680E304032
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 16:13:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lJ9SyQCbeQCsvQu1 for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 16:13:28 -0700 (PDT)
Date: Fri, 9 Sep 2016 09:13:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160908231326.GA30056@dastard>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216802075.867.12945255918683675311.stgit@birch.djwong.org>
	<20160906152155.GJ24287@infradead.org>
	<20160908191404.GB8969@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160908191404.GB8969@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 12:14:04PM -0700, Darrick J. Wong wrote:
> On Tue, Sep 06, 2016 at 08:21:55AM -0700, Christoph Hellwig wrote:
> > > +	__uint64_t			cui_id;
> > > +	struct xfs_ail_cursor		cur;
> > > +	struct xfs_ail			*ailp = log->l_ailp;
> > > +
> > > +	cud_formatp = item->ri_buf[0].i_addr;
> > > +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_cud_log_format));
> > 
> > Should we return -EFSCORRUPTED here instead?
> 
> Yes.  The RUD recovery routine should probably get that change too.
> 
> > > +	/* XXX: do nothing for now */
> > 
> > What else would be do in the future here?
> > 
> > > +static void
> > > +xfs_trans_set_refcount_flags(
> > > +	struct xfs_phys_extent		*refc,
> > > +	enum xfs_refcount_intent_type	type)
> > > +{
> > > +	refc->pe_flags = 0;
> > > +	switch (type) {
> > > +	case XFS_REFCOUNT_INCREASE:
> > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
> > > +		break;
> > > +	case XFS_REFCOUNT_DECREASE:
> > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
> > > +		break;
> > > +	case XFS_REFCOUNT_ALLOC_COW:
> > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
> > > +		break;
> > > +	case XFS_REFCOUNT_FREE_COW:
> > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
> > > +		break;
> > 
> > Is there any good reasons to use a type enum in core, but flags on
> > disk?
> 
> I suppose since log structures aren't guaranteed to be platform agnostic
> it's fine to just copy in the in-core enum here.

Carfeul there - enums are not defined to have a fixed size and so
can change from compiler version to compiler version. IOWs, the
enum values can be written idirectly to an on-disk structure, but
the on-disk structure should not be using the enum as the type
definition for whatever gets stored on disk.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
