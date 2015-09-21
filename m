Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C70B77F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 15:50:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65895AC001
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 13:50:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wvPGn07LgpiU7Oka for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 13:50:18 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs_io: Implement inodes64 command
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
Date: Mon, 21 Sep 2015 15:50:21 -0500
Message-Id: <67F3D80A-F1B2-468C-A105-4AA881BC4F72@sandeen.net>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Sep 21, 2015, at 3:56 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> 
> Implement an easy way to check a filesystem for the existence of 64bit inodes.
> 
> Based on XFS_IOC_FSINUMBERS, and starting with a lastip of XFS_MAXINUMBER_32, it
> returns a string saying if there is or there isn't 64bit inodes in the
> filesystem.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> io/open.c | 39 +++++++++++++++++++++++++++++++++++++++
> 1 file changed, 39 insertions(+)
> 
> diff --git a/io/open.c b/io/open.c
> index ac5a5e0..b25b09d 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -20,6 +20,7 @@
> #include "input.h"
> #include "init.h"
> #include "io.h"
> +#include "libxfs.h"
> 
> #ifndef __O_TMPFILE
> #if defined __alpha__
> @@ -44,6 +45,7 @@ static cmdinfo_t statfs_cmd;
> static cmdinfo_t chproj_cmd;
> static cmdinfo_t lsproj_cmd;
> static cmdinfo_t extsize_cmd;
> +static cmdinfo_t inodes64_cmd;
> static prid_t prid;
> static long extsize;
> 
> @@ -750,6 +752,36 @@ statfs_f(
>    return 0;
> }
> 
> +static int
> +inodes64_f(
> +      int            argc,
> +      char            **argv)
> +{
> +    int            i;
> +    __s32            count;
> +    __u64            last = XFS_MAXINUMBER_32;
> +    xfs_inogrp_t        igroup;
> +    xfs_fsop_bulkreq_t    bulkreq;
> +
> +    bulkreq.lastip = &last;
> +    bulkreq.icount = 1;
> +    bulkreq.ubuffer = &igroup;
> +    bulkreq.ocount = &count;
> +
> +    if (!xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> +        if (count > 0) {
> +            printf("Filesystem does have 64bit inodes\n");
> +            return 0;
> +        } else {
> +            printf("Filesystem does not have 64bit inodes\n");
> +            return 0;
> +        }
> +    }
> +    perror("xfsctl(XFS_IOC_FSINUMBERS)");
> +    exitcode = 1;
> +    return 0;
> +}
> +
> void
> open_init(void)
> {
> @@ -815,6 +847,12 @@ open_init(void)
>        _("get/set preferred extent size (in bytes) for the open file");
>    extsize_cmd.help = extsize_help;
> 
> +    inodes64_cmd.name = "inodes64";
> +    inodes64_cmd.cfunc = inodes64_f;
> +    inodes64_cmd.flags = CMD_NOMAP_OK;
> +    inodes64_cmd.oneline =
> +        _("Checks if filesyste contais 64bit inodes");

"Check if filesystem contains 64bit inodes"

Still needs a manpage update ;)

Also is it ok to not have inodes64_cmd.help?  (Sorry, on phone right now, can't look, perhaps it's fine)

Thanks,
Eric


> +
>    add_command(&open_cmd);
>    add_command(&stat_cmd);
>    add_command(&close_cmd);
> @@ -822,4 +860,5 @@ open_init(void)
>    add_command(&chproj_cmd);
>    add_command(&lsproj_cmd);
>    add_command(&extsize_cmd);
> +    add_command(&inodes64_cmd);
> }
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
