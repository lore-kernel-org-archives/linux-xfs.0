Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36664 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfAERqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Jan 2019 12:46:25 -0500
Date: Sat, 5 Jan 2019 09:46:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_quota: fix false error reporting of project
 inheritance flag is not set
Message-ID: <20190105174617.GH12689@magnolia>
References: <20190105102556.GA4200@nevermore.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190105102556.GA4200@nevermore.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Achilles Gaikwad <agaikwad@redhat.com>
Cc: linux-xfs@vger.kernel.org, sgardner@redhat.com, sandeen@redhat.com

On Sat, Jan 05, 2019 at 03:56:01PM +0530, Achilles Gaikwad wrote:
> xfs_quota project check results in "project inheritance flag is not set" error
> https://bugzilla.redhat.com/show_bug.cgi?id=1663502
> 
> Reported-by: Steven Gardner <sgardner@redhat.com>
> Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>
> ---
>  quota/project.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/quota/project.c b/quota/project.c
> index e4e7a012..8c9be08b 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -99,6 +99,7 @@ check_project(
>  {
>  	struct fsxattr		fsx;
>  	int			fd;
> +	int			isdir;

Use bool for boolean values, or...

>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
>  		return -1;
> @@ -126,7 +127,8 @@ check_project(
>  			printf(_("%s - project identifier is not set"
>  				 " (inode=%u, tree=%u)\n"),
>  				path, fsx.fsx_projid, (unsigned int)prid);
> -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
> +		isdir = S_ISDIR(stat->st_mode);
> +		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && isdir)

...move the S_ISDIR test directly into the if condition test?

Otherwise looks fine to me.

--D

>  			printf(_("%s - project inheritance flag is not set\n"),
>  				path);
>  	}
> -- 
> 2.20.1
> 
