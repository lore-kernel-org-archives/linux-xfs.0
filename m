Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D859D7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 13:14:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1ECA8F8039
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 11:14:52 -0700 (PDT)
Message-ID: <51ACDE03.4090501@redhat.com>
Date: Mon, 03 Jun 2013 14:18:43 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfs: inode unlinked list needs to recalculate the
	inode CRC
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-4-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 06/03/2013 01:28 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unlinked list manipulations operate directly on the inode
> buffer, and so bypass the inode CRC calculation mechanisms. Hence an
> inode on the unlinked list has an invalid CRC. Fix this by
> recalculating the CRC whenever we modify an unlinked list pointer in
> an inode, ncluding during log recovery. This is trivial to do and
> results in  unlinked list operations always leaving a consistent
> inode in the buffer.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c       |   16 ++++++++++++++++
>  fs/xfs/xfs_log_recover.c |    9 +++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index efbe1ac..c50e785 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1638,6 +1638,10 @@ xfs_iunlink(
>  		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
>  		offset = ip->i_imap.im_boffset +
>  			offsetof(xfs_dinode_t, di_next_unlinked);
> +
> +		/* need to recalc the inode CRC if appropriate */
> +		xfs_dinode_calc_crc(mp, dip);
> +
>  		xfs_trans_inode_buf(tp, ibp);
>  		xfs_trans_log_buf(tp, ibp, offset,
>  				  (offset + sizeof(xfs_agino_t) - 1));
> @@ -1723,6 +1727,10 @@ xfs_iunlink_remove(
>  			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
>  			offset = ip->i_imap.im_boffset +
>  				offsetof(xfs_dinode_t, di_next_unlinked);
> +
> +			/* need to recalc the inode CRC if appropriate */
> +			xfs_dinode_calc_crc(mp, dip);
> +
>  			xfs_trans_inode_buf(tp, ibp);
>  			xfs_trans_log_buf(tp, ibp, offset,
>  					  (offset + sizeof(xfs_agino_t) - 1));
> @@ -1796,6 +1804,10 @@ xfs_iunlink_remove(
>  			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
>  			offset = ip->i_imap.im_boffset +
>  				offsetof(xfs_dinode_t, di_next_unlinked);
> +
> +			/* need to recalc the inode CRC if appropriate */
> +			xfs_dinode_calc_crc(mp, dip);
> +
>  			xfs_trans_inode_buf(tp, ibp);
>  			xfs_trans_log_buf(tp, ibp, offset,
>  					  (offset + sizeof(xfs_agino_t) - 1));
> @@ -1809,6 +1821,10 @@ xfs_iunlink_remove(
>  		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
>  		ASSERT(next_agino != 0);
>  		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
> +
> +		/* need to recalc the inode CRC if appropriate */
> +		xfs_dinode_calc_crc(mp, dip);
> +

Ugh, sorry I didn't notice this last time around, but this one looks
like it should recalculate the crc on last_dip instead of dip.

Brian

>  		xfs_trans_inode_buf(tp, last_ibp);
>  		xfs_trans_log_buf(tp, last_ibp, offset,
>  				  (offset + sizeof(xfs_agino_t) - 1));
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 83088d9..45a85ff 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1912,6 +1912,15 @@ xlog_recover_do_inode_buffer(
>  		buffer_nextp = (xfs_agino_t *)xfs_buf_offset(bp,
>  					      next_unlinked_offset);
>  		*buffer_nextp = *logged_nextp;
> +
> +		/*
> +		 * If necessary, recalculate the CRC in the on-disk inode. We
> +		 * have to leave the inode in a consistent state for whoever
> +		 * reads it next....
> +		 */
> +		xfs_dinode_calc_crc(mp, (struct xfs_dinode *)
> +				xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize));
> +
>  	}
>  
>  	return 0;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
