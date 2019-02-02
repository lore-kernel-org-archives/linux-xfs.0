Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34832 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfBBQVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:21:22 -0500
Date: Sat, 2 Feb 2019 08:21:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: refactor AGI unlinked bucket updates
Message-ID: <20190202162121.GA25154@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668914.26065.4021602625860113731.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897668914.26065.4021602625860113731.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
> +	xfs_agino_t		old_value;
> +	int			offset;
> +
> +	ASSERT(new_agino == NULLAGINO ||
> +	       xfs_verify_agino(tp->t_mountp, be32_to_cpu(agi->agi_seqno),
> +				new_agino));
> +
> +	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	trace_xfs_iunlink_update_bucket(tp->t_mountp,
> +			be32_to_cpu(agi->agi_seqno), bucket_index, old_value,
> +			new_agino);

As already mentioned by Brian I'd rather pass the agno rather than
recalculating it twice.

> +	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
> +	offset = offsetof(struct xfs_agi, agi_unlinked) +
> +			(sizeof(xfs_agino_t) * bucket_index);
> +	xfs_trans_log_buf(tp, agibp, offset,
> +			(offset + sizeof(xfs_agino_t) - 1));

No need for the braces here.
