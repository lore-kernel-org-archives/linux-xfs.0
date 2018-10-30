Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:27393 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbeJaF3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:29:32 -0400
Date: Wed, 31 Oct 2018 07:34:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
Message-ID: <20181030203428.GN19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-3-david@fromorbit.com>
 <539a02d8-f9fd-e9b4-d928-dcdced642376@sandeen.net>
 <a2aa0727-21db-fd2a-6207-0b70d05a7374@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2aa0727-21db-fd2a-6207-0b70d05a7374@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 03:09:56PM -0500, Eric Sandeen wrote:
> So I'm not stealing commits: ;)
> 
> ===
> 
> repair: don't dirty inodes unconditionally when testing unlinked state
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> I noticed phase 4 writing back lots of inode buffers during recent
> testing. The recent rework of clear_inode() in commit 0724d0f4cb53
> ("xfs_repair: clear_dinode should simply clear, not check contents")
> accidentally caught a call to clear_inode_unlinked() as well,
> resulting in all inodes being marked dirty whether then needed
> updating or not.
> 
> Fix it by making clear_inode_unlinked unconditionally do the clear
> (as was done for clear_inode), and move the test to the caller.
> Add warnings as well so that this corruption is no longer silently
> fixed.
> 
> Reported-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> [sandeen: rework so clear_inode_unlinked is unconditional]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 379f85c..f466e77 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -125,23 +125,16 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  	return;
>  }
>  
> -static int
> +static void
>  clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
>  {
>  
> -	if (be32_to_cpu(dino->di_next_unlinked) != NULLAGINO)  {
> -		if (!no_modify)
> -			dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -		return(1);
> -	}
> -
> -	return(0);
> +	dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
>  }

What's the point of keeping this wrapper now?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
