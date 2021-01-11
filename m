Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952B6C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 20:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEF222CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAKUxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 15:53:34 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40726 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727448AbhAKUxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 15:53:33 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0B181828B1A;
        Tue, 12 Jan 2021 07:52:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kz4BE-005Sll-SL; Tue, 12 Jan 2021 07:52:48 +1100
Date:   Tue, 12 Jan 2021 07:52:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: try to avoid the iolock exclusive for
 non-aligned direct writes
Message-ID: <20210111205248.GO331610@dread.disaster.area>
References: <20210111161212.1414034-1-hch@lst.de>
 <20210111161212.1414034-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161212.1414034-4-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=Eg5pMCMCAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=MQ8e_jTYQEvP-IBnO0UA:9 a=CjuIK1q_8ugA:10
        a=0UDKrKjV3BTaI6JRjsAj:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:12:12PM +0100, Christoph Hellwig wrote:
> We only need the exclusive iolock for direct writes to protect sub-block
> zeroing after an allocation or conversion of unwritten extents, and the
> synchronous execution of these writes is also only needed because the
> iolock is dropped early for the dodgy i_dio_count synchronisation.
> 
> Always start out with the shared iolock in xfs_file_dio_aio_write for
> non-appending writes and only upgrade it to exclusive if the start and
> end of the write range are not already allocated and in written
> state.  This means one or two extra lookups in the in-core extent tree,
> but with our btree data structure those lookups are very cheap and do
> not show up in profiles on NVMe hardware for me.  On the other hand
> avoiding the lock allows for a high concurrency using aio or io_uring.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Avi Kivity <avi@scylladb.com>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 127 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 96 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1470fc4f2e0255..59d4c6e90f06c1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -521,6 +521,57 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
>  	.end_io		= xfs_dio_write_end_io,
>  };
>  
> +static int
> +xfs_dio_write_exclusive(
> +	struct kiocb		*iocb,
> +	size_t			count,
> +	bool			*exclusive_io)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = &ip->i_df;
> +	loff_t			offset = iocb->ki_pos;
> +	loff_t			end = offset + count;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
> +	struct xfs_bmbt_irec	got = { };
> +	struct xfs_iext_cursor	icur;
> +	int			ret;
> +
> +	*exclusive_io = true;
> +
> +	/*
> +	 * Bmap information not read in yet or no blocks allocated at all?
> +	 */
> +	if (!(ifp->if_flags & XFS_IFEXTENTS) || !ip->i_d.di_nblocks)
> +		return 0;
> +
> +	ret = xfs_ilock_iocb(iocb, XFS_ILOCK_SHARED);
> +	if (ret)
> +		return ret;
> +
> +	if (offset & mp->m_blockmask) {
> +		if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got) ||
> +		    got.br_startoff > offset_fsb ||
> +		    got.br_state == XFS_EXT_UNWRITTEN)
> +		    	goto out_unlock;
> +	}
> +
> +	if ((end & mp->m_blockmask) &&
> +	    got.br_startoff + got.br_blockcount <= end_fsb) {
> +		if (!xfs_iext_lookup_extent(ip, ifp, end_fsb, &icur, &got) ||
> +		    got.br_startoff > end_fsb ||
> +		    got.br_state == XFS_EXT_UNWRITTEN)
> +		    	goto out_unlock;
> +	}
> +
> +	*exclusive_io = false;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	return ret;
> +}

OK, this has a bug in it. We have to do exclusive sub-block IO when
the end of the IO is >= i_size_read(inode) because in this situation
iomap_dio_rw_actor() will issue an extra bio to zero the portion of
the filesystem block that lies beyond EOF. generic/418 hammers this
case, and randomly ends up with zeroes where there should be data.

Otherwise, it largely makes a similar mess of
xfs_file_dio_aio_write() as my initial patchset does. We should just
move the unaligned IO out of the main path, regardless of whether it
is exclusive or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
