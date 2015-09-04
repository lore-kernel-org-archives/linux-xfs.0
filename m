Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2177B7FB5
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 13:32:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01C28304039
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 11:32:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Pwa1j5fADX4xeEdf for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 11:32:54 -0700 (PDT)
Subject: Re: [PATCH 2/3] xfs: create symlink proc/fs/xfs/stat to
	sys/fs/xfs/stats
References: <1441371319-31625-1-git-send-email-billodo@redhat.com>
	<1441371319-31625-3-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E9E3D4.5090509@sandeen.net>
Date: Fri, 4 Sep 2015 13:32:52 -0500
MIME-Version: 1.0
In-Reply-To: <1441371319-31625-3-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>, xfs@oss.sgi.com

On 9/4/15 7:55 AM, Bill O'Donnell wrote:
> As a part of the work to move xfs global stats from procfs to sysfs,
> this patch creates the symlink from proc/fs/xfs/stat to sys/fs/xfs/stats.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 6008e25..734b867 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -244,9 +244,12 @@ xfs_init_procfs(void)
>  	if (!proc_mkdir("fs/xfs", NULL))
>  		goto out;
>  
> -	if (!proc_create("fs/xfs/stat", 0, NULL,
> -			 &xfs_stat_proc_fops))
> +	if (!proc_symlink("fs/xfs/stat", NULL,
> +			  "/sys/fs/xfs/stats/stats"))
> +	{
>  		goto out_remove_xfs_dir;
> +	}

Ok, without the printk, now there's no need for the braces :)

Also, as an aside, the kernel/xfs style is:

	if (foo) {
		...
	}

not:

	if (foo)
	{
		...
	}

just FYI...

Thanks,
-Eric
> +
>  #ifdef CONFIG_XFS_QUOTA
>  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
>  			 &xqmstat_proc_fops))
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
