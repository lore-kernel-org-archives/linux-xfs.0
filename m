Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfAFSKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jan 2019 13:10:25 -0500
Date: Sun, 6 Jan 2019 10:10:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs_quota: fix false error reporting of project
 inheritance flag is not set
Message-ID: <20190106181018.GI12689@magnolia>
References: <20190106102745.GA7347@nevermore.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190106102745.GA7347@nevermore.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Achilles Gaikwad <agaikwad@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, sgardner@redhat.com

On Sun, Jan 06, 2019 at 03:58:07PM +0530, Achilles Gaikwad wrote:
> After kernel commit:
> 
> 9336e3a7 "xfs: project id inheritance is a directory only flag"
> 
> xfs stopped setting the project inheritance flag on regular files, but
> userspace quota code still checks for it and will now issue the error:
> 
> "project inheritance flag is not set"
> 
> for every regular file during quotacheck.  Fix this by only checking
> for the flag on directories.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1663502
> Reported-by: Steven Gardner <sgardner@redhat.com>
> Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>

Looks ok to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  quota/project.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/quota/project.c b/quota/project.c
> index e4e7a012..11f3be04 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -126,7 +126,7 @@ check_project(
>  			printf(_("%s - project identifier is not set"
>  				 " (inode=%u, tree=%u)\n"),
>  				path, fsx.fsx_projid, (unsigned int)prid);
> -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
> +		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
>  			printf(_("%s - project inheritance flag is not set\n"),
>  				path);
>  	}
> -- 
> 2.20.1
> 
