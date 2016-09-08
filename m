Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27681 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753204AbcIHXR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 19:17:29 -0400
Date: Thu, 8 Sep 2016 16:16:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160908231656.GC8969@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216802075.867.12945255918683675311.stgit@birch.djwong.org>
 <20160906152155.GJ24287@infradead.org>
 <20160908191404.GB8969@birch.djwong.org>
 <20160908231326.GA30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908231326.GA30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 09:13:26AM +1000, Dave Chinner wrote:
> On Thu, Sep 08, 2016 at 12:14:04PM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 06, 2016 at 08:21:55AM -0700, Christoph Hellwig wrote:
> > > > +	__uint64_t			cui_id;
> > > > +	struct xfs_ail_cursor		cur;
> > > > +	struct xfs_ail			*ailp = log->l_ailp;
> > > > +
> > > > +	cud_formatp = item->ri_buf[0].i_addr;
> > > > +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_cud_log_format));
> > > 
> > > Should we return -EFSCORRUPTED here instead?
> > 
> > Yes.  The RUD recovery routine should probably get that change too.
> > 
> > > > +	/* XXX: do nothing for now */
> > > 
> > > What else would be do in the future here?
> > > 
> > > > +static void
> > > > +xfs_trans_set_refcount_flags(
> > > > +	struct xfs_phys_extent		*refc,
> > > > +	enum xfs_refcount_intent_type	type)
> > > > +{
> > > > +	refc->pe_flags = 0;
> > > > +	switch (type) {
> > > > +	case XFS_REFCOUNT_INCREASE:
> > > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
> > > > +		break;
> > > > +	case XFS_REFCOUNT_DECREASE:
> > > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
> > > > +		break;
> > > > +	case XFS_REFCOUNT_ALLOC_COW:
> > > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
> > > > +		break;
> > > > +	case XFS_REFCOUNT_FREE_COW:
> > > > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
> > > > +		break;
> > > 
> > > Is there any good reasons to use a type enum in core, but flags on
> > > disk?
> > 
> > I suppose since log structures aren't guaranteed to be platform agnostic
> > it's fine to just copy in the in-core enum here.
> 
> Carfeul there - enums are not defined to have a fixed size and so
> can change from compiler version to compiler version. IOWs, the
> enum values can be written idirectly to an on-disk structure, but
> the on-disk structure should not be using the enum as the type
> definition for whatever gets stored on disk.

<nod>  I left the fields (and the #define flags) definitions alone,
so it's only writing enum values indirectly into a fixed size (u32)
variable on-disk.

i.e. I'm not using enums in the on-disk structure definitions.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
