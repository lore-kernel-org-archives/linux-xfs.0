Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeJaCVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:21:12 -0400
Date: Tue, 30 Oct 2018 10:26:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
Message-ID: <20181030172644.GH4135@magnolia>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030112043.6034-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:20:38PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I noticed phase 4 writing back lots of inode buffers during recent
> testing. The recent rework of clear_inode() in commit 0724d0f4cb53
> ("xfs_repair: clear_dinode should simply clear, not check contents")
> accidentally caught a call to clear_inode_unlinked() as well,
> resulting in all inodes being marked dirty whether then needed
> updating or not.
> 
> Fix it by reverting the erroneous hunk and adding warnings so taht
> this corruption is no longer silently fixed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Oops... that explains a lot. :/

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/dinode.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 379f85cf1268..90400128d4bb 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2675,9 +2675,15 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	 * we're going to find.  check_dups is set to 1 only during
>  	 * phase 4.  Ugly.
>  	 */
> -	if (check_dups && !no_modify) {
> -		clear_dinode_unlinked(mp, dino);
> -		*dirty += 1;
> +	if (check_dups && clear_dinode_unlinked(mp, dino)) {
> +		if (no_modify) {
> +			do_warn(
> +	_("Would clear unlinked_next in inode %" PRIu64 "\n"), lino);
> +		} else  {
> +			do_warn(
> +	_("Cleared unlinked_next in inode %" PRIu64 "\n"), lino);
> +			*dirty += 1;
> +		}
>  	}
>  
>  	/* set type and map type info */
> -- 
> 2.19.1
> 
