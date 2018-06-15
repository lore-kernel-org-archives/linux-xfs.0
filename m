Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38044 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755645AbeFOLox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 07:44:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id 69-v6so3339812wmf.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 04:44:53 -0700 (PDT)
Date: Fri, 15 Jun 2018 13:44:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_quota: fix -d option to limit directory depth
 correctly
Message-ID: <20180615114449.cuzz5nkqrxn6j4bk@odin.usersys.redhat.com>
References: <C26C67884C4B7A48980D5746355948640347D54C@BPXM20GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C26C67884C4B7A48980D5746355948640347D54C@BPXM20GP.gisp.nec.co.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

Although the patch looks correct, the patch description/subject is confusing
IMHO.

On Mon, Jun 11, 2018 at 05:39:59AM +0000, Kazuya Mio wrote:

> xfs_quota -x -c "project -d DEPTH" stops in the middle of its operation
> if a directory whose level is more than DEPTH was found.
> 

> To set/check/clear a project quota, xfs_quota performs pre-order tree traversal
> by using nftw(3). However, if the directory whose level is more than
> the recursion level specified by -d option is found, the function called
> by nftw() returns -1 and nftw() stops the tree walk.
> 

I've got what you meant here, but in fact, this description just sounds to me
as the operation should work, i.e. stop when DEPTH is hit.

What you think about something like:

====
Continue the file tree walk, even though DEPTH is hit in one or more
sub-directory tree(s), so all sub-directory trees are processed up to DEPTH

To set/check/clear a project quota, xfs_quota performs pre-order tree traversal
by using nftw(3). However, by now, {check,setup,clear}_project, returns -1 when
DEPTH is hit, stopping the directory tree walk.

Change the return value of these functions to 0, when DEPTH is hit, so, the
remaining sub-directory trees are also processed up to DEPTH.
====

But well, English is not my native language too, so, might be more useful if some
native English speaker commented on it.

For the patch itself:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> The following steps show that only one directory is set a project quota,
> even though another directory whose level is the same as the recursion level
> isn't set a project quota.
> 

> # mkfs.xfs -f /dev/sdb1
> # mount -o pquota /dev/sdb1 /mnt
> # mkdir -p /mnt/pquota/dirA/dirAA /mnt/pquota/dirB/dirBB
> # xfs_quota -x -c "project -d 1 -s -p /mnt/pquota 100" 
> # xfs_io -c stat /mnt/pquota/dirA | grep projid
> fsxattr.projid = 100
> # xfs_io -c stat /mnt/pquota/dirB | grep projid
> fsxattr.projid = 0
> 
> To fix above problem, if the directory whose level is more than the recursion
> level is found, the function called by nftw() returns 0 instead of -1.
> 
> Note that the time of tree traversal is the same as no limitation of
> recursion level. To reduce the time, we have to use FTW_SKIP_SUBTREE
> that is glibc-specified flag. Is it better to use this flag?
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  quota/project.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> diff --git a/quota/project.c b/quota/project.c
> index e4e7a01..20bc01b 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -101,7 +101,7 @@ check_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> @@ -146,7 +146,7 @@ clear_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> @@ -193,7 +193,7 @@ setup_project(
>  	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
> -		return -1;
> +		return 0;
>  
>  	if (flag == FTW_NS ){
>  		exitcode = 1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
