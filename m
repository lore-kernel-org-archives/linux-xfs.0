Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARHAA8w069912 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 11:10:10 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vnzdqvKIvKqdgeQa for
	<xfs@oss.sgi.com>; Tue, 27 Nov 2012 09:12:26 -0800 (PST)
Date: Tue, 27 Nov 2012 14:50:01 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC] [PATCH] xfs_quota: support relative path as `path' arguments
Message-ID: <20121127165001.GA11620@andromeda.usersys.redhat.com>
References: <50B49074.1020000@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B49074.1020000@jp.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: xfs ML <xfs@oss.sgi.com>

On Tue, Nov 27, 2012 at 07:05:40PM +0900, Satoru Takeuchi wrote:

> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Current xfs_quota only accepts absolute path as its `path' arguments.
> This patch adds the support of relative path for user's convenience.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>

Using realpath() to handle the path being passed by user, not only makes able
the usage of relative paths, but also fixes the problem in having a "/" at the
end of the path. For those who abuses of TABs, this is very annoying.

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com> 
Tested-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxcmd/paths.c |   42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index 2a92299..bd84cde 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -27,6 +27,7 @@
>  #include <xfs/path.h>
>  #include <xfs/input.h>
>  #include <xfs/project.h>
> +#include <limits.h>
>  
>  extern char *progname;
>  
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
