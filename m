Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22807 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdHaO6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:58:04 -0400
Date: Thu, 31 Aug 2017 07:57:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: linux-next: build warning after merge of the xfs tree
Message-ID: <20170831145752.GH3775@magnolia>
References: <20170831100703.16eeb69f@canb.auug.org.au>
 <20170831103040.GB21508@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831103040.GB21508@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Aug 31, 2017 at 06:30:41AM -0400, Brian Foster wrote:
> On Thu, Aug 31, 2017 at 10:07:03AM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the xfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > fs/xfs/xfs_buf_item.c: In function 'xfs_buf_item_unlock':
> > fs/xfs/xfs_buf_item.c:573:9: warning: unused variable 'ordered' [-Wunused-variable]
> >   bool   ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> >          ^
> > 
> > Introduced by commit
> > 
> >   a097077ef708 ("xfs: remove unnecessary dirty bli format check for ordered bufs")
> > 
> 
> Ugh, this is due to the refactoring of this patch between v1 and v2. I
> specifically recall testing for this in v1 because I added the ordered
> bool purely to clean up the ASSERT(), then I apparently lost of track of
> it for v2.
> 
> Anyways.. Christoph, Darrick, preferences to clean this up..? I have no
> preference between the v1 or v2 factoring. Or if it's easier, we could
> always just drop something like the hunk below on top. Thoughts?
> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index ef2c137..f5d25f5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -567,10 +567,15 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> -	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> -	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> -	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> +	bool			aborted;
> +	bool			hold;
> +	bool			dirty;
> +	bool			ordered;
> +
> +	aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> +	hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> +	dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> +	ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);

The trouble is, 'ordered' is still an unused variable on !DEBUG builds,
since the only user of ordered is that ASSERT.  So either we #ifdef
DEBUG the variable out of existence or employ one of those silly
'ordered = ordered' constructions to shut up gcc, if that even still
works.

--D

>  
>  	/* Clear the buffer's association with this transaction. */
>  	bp->b_transp = NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
