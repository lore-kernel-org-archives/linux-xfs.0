Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F1617FBB
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 20:03:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E68AAC002
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 18:03:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u3J50wdGlup1PFzV for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 18:03:03 -0700 (PDT)
Date: Fri, 5 Jun 2015 11:03:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/28] repair: scan sparse finobt records correctly
Message-ID: <20150605010302.GN9143@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<1433270521-62026-20-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433270521-62026-20-git-send-email-bfoster@redhat.com>
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

On Tue, Jun 02, 2015 at 02:41:52PM -0400, Brian Foster wrote:
> The finobt scan performs similar checks as to the inobt scan, including
> internal record consistency checks, consistency with inobt records,
> inode block state, etc. Various parts of this mechanism also assume
> fully allocated inode records and thus lead to false errors with sparse
> records.
> 
> Update the finobt scan to detect and handle sparse inode records
> correctly. As for the inobt, do not assume that blocks associated with
> sparse regions are allocated for inodes and do not account sparse inodes
> against the freecount. Additionally, verify that sparse state is
> consistent with the in-core record and set up any new in-core records
> that might have been missing from the inobt correctly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
....
>  
> +	/*
> +	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
> +	 * inodes are free and that freecount is consistent with the free mask.
> +	 */
> +	nfree = 0;
> +	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> +		if (ino_issparse(rp, j)) {
> +			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
> +				do_warn(
> +_("finobt ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
> +					agno, ino,
> +					be16_to_cpu(rp->ir_u.sp.ir_holemask),
> +					be64_to_cpu(rp->ir_free));
> +				suspect++;
> +			}
> +			if (!suspect && ino_rec)
> +				set_inode_sparse(ino_rec, j);
> +		} else if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
> +			/* freecount only tracks non-sparse inos */
> +			nfree++;
> +		}
> +	}
> +

This is the same checking code as used for the inobt. Can you factor
these into a helper? I'll apply as is, so delta patch again. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
