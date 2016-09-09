Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbcIIN7S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Sep 2016 09:59:18 -0400
Subject: Re: [PATCH] xfs_io: fix building with musl
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
 <1473427942-10726-1-git-send-email-ralph.sennhauser@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <106faf8f-3b68-56b9-6188-af01601cc870@sandeen.net>
Date: Fri, 9 Sep 2016 08:59:16 -0500
MIME-Version: 1.0
In-Reply-To: <1473427942-10726-1-git-send-email-ralph.sennhauser@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>, linux-xfs@vger.kernel.org

On 9/9/16 8:32 AM, Ralph Sennhauser wrote:
> The fallback in case the libc doesn't have or doesn't advertise the
> existence of d_reclen in struct dirent uses d_namlen. Musl neither
> advertises d_reclen nor does it have a d_namlen member.
> 
> Calculate the value for d_namlen from d_name in the fallback path.
> 
> Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
> ---
> 
> With ustat.h issue resolved in 4.8.0-rc1 this is the only musl related
> one left.
> 
> An alternative could be some autoconf magic [1] or waiting for a long
> time for musl to add _DIRENT_HAVE_D_RECLEN [2] and for it to propagate
> to distributions.
> 
> [1] http://oss.sgi.com/archives/xfs/2016-01/msg00388.html
> [2] http://www.openwall.com/lists/musl/2016/01/15/9

eh, this is fine by me.  Even Linus has hated d_namlen for over
a decade ;)  http://lkml.iu.edu/hypermail/linux/kernel/9506/0033.html

Last question, have you tested it beyond the build, i.e.
with xfs_io -c "readdir -v" /some/dir ?  Works here but it'd be nice
to know that it's working properly on musl as well.

the d_reclen field doesn't exist in any xfstests output, so looks
like its loss on some platforms won't affect any existing tests.

If you can verify that you did a runtime test as well, that'd
be great, but in any case:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  io/readdir.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/io/readdir.c b/io/readdir.c
> index 151b72e..2b56dc8 100644
> --- a/io/readdir.c
> +++ b/io/readdir.c
> @@ -24,6 +24,10 @@
>  #include <sys/types.h>
>  #include <dirent.h>
>  
> +#ifndef _DIRENT_HAVE_D_RECLEN
> +#include <string.h>
> +#endif
> +
>  static struct cmdinfo readdir_cmd;
>  
>  const char *d_type_str(unsigned int type)
> @@ -106,7 +110,7 @@ read_directory(
>  #ifdef _DIRENT_HAVE_D_RECLEN
>  		*total += dirent->d_reclen;
>  #else
> -		*total += dirent->d_namlen + sizeof(*dirent);
> +		*total += strlen(dirent->d_name) + sizeof(*dirent);
>  #endif
>  		count++;
>  
> 
