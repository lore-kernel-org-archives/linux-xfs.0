Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59540 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbfAERsF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Jan 2019 12:48:05 -0500
Subject: Re: [PATCH] xfs_quota: fix false error reporting of project
 inheritance flag is not set
References: <20190105102556.GA4200@nevermore.lan>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9eb0d635-54a3-7796-e7bb-a0be7352210e@sandeen.net>
Date: Sat, 5 Jan 2019 11:48:03 -0600
MIME-Version: 1.0
In-Reply-To: <20190105102556.GA4200@nevermore.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Achilles Gaikwad <agaikwad@redhat.com>, linux-xfs@vger.kernel.org
Cc: sgardner@redhat.com, sandeen@redhat.com

On 1/5/19 4:26 AM, Achilles Gaikwad wrote:
> xfs_quota project check results in "project inheritance flag is not set" error

Thanks for doing this.

> https://bugzilla.redhat.com/show_bug.cgi?id=1663502

As I mentioned in the bug, this started happening after:

commit 9336e3a765b68d4a7fdd8256f393ebce95ecb0a7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:18:40 2014 +1000

    xfs: project id inheritance is a directory only flag
    
    xfs_set_diflags() allows it to be set on non-directory inodes, and
    this flags errors in xfs_repair. Further, inode allocation allows
    the same directory-only flag to be inherited to non-directories.
    Make sure directory inode flags don't appear on other types of
    inodes.
    
    This fixes several xfstests scratch fileystem corruption reports
    (e.g. xfs/050) now that xfstests checks scratch filesystems after
    test completion.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>


which is present in v3.18 upstream.  i.e. we stopped setting the
project inheritance flag on regular files in the kernel, but quotacheck
still looks for it in userspace.

It's good to write changelogs that will give full context to future readers,
so something like this might be more useful:

===

After kernel commit:

9336e3a7 "xfs: project id inheritance is a directory only flag"

xfs stopped setting the project inheritance flag on regular files, but
userspace quota code still checks for it and will now issue the error:

"project inheritance flag is not set"

for every regular file during quotacheck.  Fix this by only checking
for the flag on directories.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1663502
Reported-by: Steven Gardner <sgardner@redhat.com>
Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>

===

But the change itself is fine, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Also, this should really have an xfstest, because it's been broken
for a long time, and only just now turned up...

Thanks,
-Eric

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
>  			printf(_("%s - project inheritance flag is not set\n"),
>  				path);
>  	}
> 
