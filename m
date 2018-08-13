Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33016 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbeHMK1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:27:11 -0400
Received: by mail-wm0-f67.google.com with SMTP id r24-v6so6873299wmh.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 00:46:06 -0700 (PDT)
Date: Mon, 13 Aug 2018 09:46:03 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/6] xfs: recalculate summary counters at mount time if
 icount is bad
Message-ID: <20180813074603.snvyddbl2z2xmp7t@odin.usersys.redhat.com>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400170370.27471.3984686896617555055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400170370.27471.3984686896617555055.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the sb write verifier trips on bad icounts, we should also force a
> mount time recalculation of the summary counters if the icount is bad.
> This helps us avoid blowing up at freeze/unmount time when the bad
> counter gets written back out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_mount.c |    1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 99db27d6ac8a..02d15098dbee 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -637,6 +637,7 @@ xfs_check_summary_counts(
>  	 */
>  	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
>  	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
> +	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
>  	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
>  		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
>  
> 

-- 
Carlos
