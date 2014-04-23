Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B82C7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67F7F8F8064
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 23:20:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7FUQJx5LAxrWHlDI for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 23:20:45 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:19:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 14/20] xfsprogs/repair: phase 2 finobt scan
Message-ID: <20140423061945.GO15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-15-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146270-42993-15-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 12:11:04PM -0400, Brian Foster wrote:
> If one exists, scan the free inode btree in phase 2 of xfs_repair.
> We use the same general infrastructure as for the inobt scan, but
> trigger finobt chunk scan logic in in scan_inobt() via the magic
> value.
> 
> The new scan_single_finobt_chunk() function is similar to the inobt
> equivalent with some finobt specific logic. We can expect that
> underlying inode chunk blocks are already marked used due to the
> previous inobt scan. We can also expect to find every record
> tracked by the finobt already accounted for in the in-core tree
> with equivalent (and internally consistent) inobt record data.
> 
> Spit out a warning on any divergences from the above and add the
> inodes referenced by the current finobt record to the appropriate
> in-core tree.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
....
> +	/*
> +	 * on multi-block block chunks, all chunks start
> +	 * at the beginning of the block.  with multi-chunk
> +	 * blocks, all chunks must start on 64-inode boundaries
> +	 * since each block can hold N complete chunks. if
> +	 * fs has aligned inodes, all chunks must start
> +	 * at a fs_ino_alignment*N'th agbno.  skip recs
> +	 * with badly aligned starting inodes.
> +	 */

Use all 80 columns for the comment ;)

> +	if (ino == 0 ||
> +	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
> +	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
> +	     off % XFS_INODES_PER_CHUNK != 0) ||
> +	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0)) {
> +		do_warn(
> +	_("badly aligned finobt inode rec (starting inode = %" PRIu64 ")\n"),
> +			lino);
> +		suspect++;
> +	}
> +
> +	/*
> +	 * verify numeric validity of inode chunk first
> +	 * before inserting into a tree.  don't have to
> +	 * worry about the overflow case because the
> +	 * starting ino number of a chunk can only get
> +	 * within 255 inodes of max (NULLAGINO).  if it
> +	 * gets closer, the agino number will be illegal
> +	 * as the agbno will be too large.
> +	 */

Same.

> +
> +	/*
> +	 * the finobt contains a record that the previous alloc inobt scan never
> +	 * found. insert the inodes into the appropriate tree.
> +	 */
> +
> +	do_warn(
> +		_("undiscovered finobt record, ino %" PRIu64 " (%d/%u)\n"),
> +		lino, agno, ino);

No need for the new line for the _("...") there, nor the whitespace
before it.

> +
> +	if (!suspect) {
> +		/*
> +		 * inodes previously inserted into the uncertain tree should be
> +		 * superceded by these when the uncertain tree is processed
> +		 */
> +		nfree = 0;
> +		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
> +			nfree++;
> +			ino_rec = set_inode_free_alloc(mp, agno, ino);
> +		} else  {
> +			ino_rec = set_inode_used_alloc(mp, agno, ino);
> +		}
> +		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
> +			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> +				nfree++;
> +				set_inode_free(ino_rec, j);
> +			} else  {
> +				set_inode_used(ino_rec, j);
> +			}
> +		}
> +	} else {
> +		/*
> +		 * this should handle the case where the inobt scan may have
> +		 * already added uncertain inodes
> +		 */
> +		nfree = 0;
> +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> +			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> +				add_aginode_uncertain(mp, agno, ino + j, 1);
> +				nfree++;
> +			} else {
> +				add_aginode_uncertain(mp, agno, ino + j, 0);
> +			}
> +		}
> +	}
> +
> +check_freecount:
> +
> +	if (nfree != be32_to_cpu(rp->ir_freecount)) {
> +		do_warn(
> +_("finobt ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
> +			agno, ino, be32_to_cpu(rp->ir_freecount), nfree);
> +	}
> +
> +	if (!nfree) {
> +		do_warn(
> +_("finobt record with no free inodes, inode chunk %d/%u\n"), agno, ino);
> +	}

Shouldn't both of these increment suspect?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
