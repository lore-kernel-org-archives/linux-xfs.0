Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20999 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdCAQeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 11:34:18 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v21GXg4f021561
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Mar 2017 16:33:42 GMT
Date: Wed, 1 Mar 2017 08:32:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: detect invalid zero-sized symlink inodes
Message-ID: <20170301163204.GK5297@birch.djwong.org>
References: <1488380403-5826-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488380403-5826-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Mathias Troiden <mathias.troiden@gmail.com>

On Wed, Mar 01, 2017 at 10:00:03AM -0500, Brian Foster wrote:
> Mathias Troiden reproduced a filesystem corruption that resulted in
> a zero-sized local format symlink inode. This is invalid state and
> results in an inode that cannot be accessed or modified.
> 
> The kernel detects this problem on inode access, fails and warns the
> user to umount and run xfs_repair. Unfortunately, xfs_repair doesn't
> even detect the problem. Thus the user has no path to recovery.
> 
> Update xfs_repair to check for invalid zero-sized symlinks and flag
> them as corrupted. This results in tossing the inode, but returns
> the fs to a valid state.
> 
> Reported-by: Mathias Troiden <mathias.troiden@gmail.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/dinode.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8d01409..d664f87 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1385,6 +1385,11 @@ process_symlink(
>  		return(1);
>  	}
>  
> +	if (be64_to_cpu(dino->di_size) == 0) {
> +		do_warn(_("zero size symlink in inode %" PRIu64 "\n"), lino);
> +		return 1;
> +	}
> +
>  	/*
>  	 * have to check symlink component by component.
>  	 * get symlink contents into data area
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
