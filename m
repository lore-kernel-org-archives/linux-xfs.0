Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732996AbfB1U4p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Feb 2019 15:56:45 -0500
Subject: Re: [PATCH 2/2] t_attr_corruption: fix this yet again
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
 <155114853550.9683.11298191063436471344.stgit@magnolia>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ed56f33a-5fff-1200-7353-ba411c863baa@suse.com>
Date: Thu, 28 Feb 2019 15:56:40 -0500
MIME-Version: 1.0
In-Reply-To: <155114853550.9683.11298191063436471344.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 2/25/19 9:35 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Jeff Moyer pointed out that 'security.evm' actually has an expected

Mahoney :)

> value format, which breaks the test if EVM is enabled.  It turns out
> that the 'security.evm' setxattr call in the original syzkaller report
> was a total red herring, as this bug can be reproduced without it.
> 
> Fix the test case to do the minimum amount of work needed to reproduce
> the corruption.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Otherwise, works for me in the case that failed for me previously.

Thanks,

-Jeff

> ---
>  src/t_attr_corruption.c |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/src/t_attr_corruption.c b/src/t_attr_corruption.c
> index f26611f9..9101024e 100644
> --- a/src/t_attr_corruption.c
> +++ b/src/t_attr_corruption.c
> @@ -3,17 +3,21 @@
>   * Copyright (C) 2019 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   *
> - * Test program to tickle a use-after-free bug in xfs.
> + * XFS had a memory corruption bug in its handling of the POSIX ACL attribute
> + * names during a listxattr call.
>   *
> - * XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
> - * listxattr buffer space while trying to store the name
> - * "system.posix_acl_access" and then corrupts memory by not checking the
> - * seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into the
> - * buffer as well.
> + * On IRIX, file ACLs were stored under the name "trusted.SGI_ACL_FILE",
> + * whereas on Linux the name is "system.posix_acl_access".  In order to
> + * maintain compatibility with old filesystems, XFS internally continues to
> + * use the old SGI_ACL_FILE name on disk and remap the new name whenever it
> + * sees it.
>   *
> - * In order to tickle the bug in a user visible way we must have already put a
> - * name in the buffer, so we take advantage of the fact that "security.evm"
> - * sorts before "system.posix_acl_access" to make sure this happens.
> + * In order to make this magic happen, XFS' listxattr implementation will emit
> + * first the Linux name and then the on-disk name.  Unfortunately, it doesn't
> + * correctly check the buffer length, so if the buffer is large enough to fit
> + * the on-disk name but not large enough to fit the Linux name, we screw up
> + * the buffer position accounting while trying to emit the Linux name and then
> + * corrupt memory when we try to emit the on-disk name.
>   *
>   * If we trigger the bug, the program will print the garbled string
>   * "rusted.SGI_ACL_FILE".  If the bug is fixed, the flistxattr call returns
> @@ -76,11 +80,7 @@ int main(int argc, char *argv[])
>  	if (ret)
>  		die("set posix acl");
>  
> -	ret = fsetxattr(fd, "security.evm", buf, 1, 1);
> -	if (ret)
> -		die("set evm");
> -
> -	sz = flistxattr(fd, buf, 30);
> +	sz = flistxattr(fd, buf, 20);
>  	if (sz < 0)
>  		die("list attr");
>  
> 
> 


-- 
Jeff Mahoney
SUSE Labs
