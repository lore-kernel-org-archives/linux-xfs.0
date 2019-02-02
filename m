Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfBBTvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 14:51:11 -0500
Date: Sat, 2 Feb 2019 11:51:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: refactor AGI unlinked bucket updates
Message-ID: <20190202195104.GR5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668914.26065.4021602625860113731.stgit@magnolia>
 <20190202162121.GA25154@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202162121.GA25154@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 02, 2019 at 08:21:21AM -0800, Christoph Hellwig wrote:
> > +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
> > +	xfs_agino_t		old_value;
> > +	int			offset;
> > +
> > +	ASSERT(new_agino == NULLAGINO ||
> > +	       xfs_verify_agino(tp->t_mountp, be32_to_cpu(agi->agi_seqno),
> > +				new_agino));
> > +
> > +	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> > +	trace_xfs_iunlink_update_bucket(tp->t_mountp,
> > +			be32_to_cpu(agi->agi_seqno), bucket_index, old_value,
> > +			new_agino);
> 
> As already mentioned by Brian I'd rather pass the agno rather than
> recalculating it twice.
> 
> > +	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
> > +	offset = offsetof(struct xfs_agi, agi_unlinked) +
> > +			(sizeof(xfs_agino_t) * bucket_index);
> > +	xfs_trans_log_buf(tp, agibp, offset,
> > +			(offset + sizeof(xfs_agino_t) - 1));
> 
> No need for the braces here.

Will fix.

--D
