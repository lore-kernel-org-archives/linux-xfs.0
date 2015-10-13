Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7410B7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 16:08:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 634A9304039
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 14:08:30 -0700 (PDT)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id toOTBEUYg04lr89g
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 14:08:29 -0700 (PDT)
Received: by vkat63 with SMTP id t63so18582647vka.1
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 14:08:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151013204119.GI31326@dastard>
References: <CA+r1Zhg0y-47JuzOMANcXykyU=No-TEBksLnnT-g0OsTKwazRQ@mail.gmail.com>
	<20151013204119.GI31326@dastard>
Date: Tue, 13 Oct 2015 14:08:28 -0700
Message-ID: <CA+r1ZhiKiVja7vm5F-mmtq3xVm4gufGW1fFuF6FD7RpU17T6PA@mail.gmail.com>
Subject: Re: randconfig build error with next-20151013,
	in fs/xfs/libxfs/xfs_alloc.c
From: Jim Davis <jim.epost@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Oct 13, 2015 at 1:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 13, 2015 at 09:41:25AM -0700, Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> fs/built-in.o: In function `xfs_free_ag_extent':
>> /home/jim/linux-next/fs/xfs/libxfs/xfs_alloc.c:1813: undefined
>> reference to `xfsstats'
>
> Please test the patch below.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
> xfs: stats are no longer dependent on CONFIG_PROC_FS
>
> From: Dave Chinner <dchinner@redhat.com>
>
> So we need to fix the makefile to understand this, otherwise build
> errors with CONFIG_PROC_FS=n occur.
>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile    | 2 +-
>  fs/xfs/xfs_stats.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 2fbf910..6506e87 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -84,6 +84,7 @@ xfs-y                         += xfs_aops.o \
>                                    xfs_message.o \
>                                    xfs_mount.o \
>                                    xfs_mru_cache.o \
> +                                  xfs_stats.o \
>                                    xfs_super.o \
>                                    xfs_symlink.o \
>                                    xfs_sysfs.o \
> @@ -118,7 +119,6 @@ xfs-$(CONFIG_XFS_QUOTA)             += xfs_dquot.o \
>  xfs-$(CONFIG_XFS_RT)           += xfs_rtalloc.o
>
>  xfs-$(CONFIG_XFS_POSIX_ACL)    += xfs_acl.o
> -xfs-$(CONFIG_PROC_FS)          += xfs_stats.o
>  xfs-$(CONFIG_SYSCTL)           += xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)           += xfs_ioctl32.o
>  xfs-$(CONFIG_NFSD_PNFS)                += xfs_pnfs.o
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index bd50619..8686df6 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -161,6 +161,7 @@ static const struct file_operations xqmstat_proc_fops = {
>  };
>  #endif /* CONFIG_XFS_QUOTA */
>
> +#ifdef CONFIG_PROC_FS
>  int
>  xfs_init_procfs(void)
>  {
> @@ -191,3 +192,4 @@ xfs_cleanup_procfs(void)
>  {
>         remove_proc_subtree("fs/xfs", NULL);
>  }
> +#endif /* CONFIG_PROC_FS */

Looks good!  Thanks.

Tested-by: Jim Davis <jim.epost@gmail.com>

-- 
Jim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
