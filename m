Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BA717F95
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 15:08:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDCA6AC005
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 13:08:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9cm2AACzHV7uUeAk for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 13:08:40 -0700 (PDT)
Subject: Re: [PATCH 2/3] xfs: create symlink proc/fs/xfs/stat to
	sys/fs/xfs/stats
References: <1441298187-29064-1-git-send-email-billodo@redhat.com>
	<1441298187-29064-3-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E8A8C7.9080506@sandeen.net>
Date: Thu, 3 Sep 2015 15:08:39 -0500
MIME-Version: 1.0
In-Reply-To: <1441298187-29064-3-git-send-email-billodo@redhat.com>
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
To: billodo <billodo@redhat.com>, xfs@oss.sgi.com

On 9/3/15 11:36 AM, billodo wrote:
> As a part of the work to move xfs global stats from procfs to sysfs,
> this patch creates the symlink from proc/fs/xfs/stat to sys/fs/xfs/stats.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 856cf57..ad435f1 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -244,9 +244,13 @@ xfs_init_procfs(void)
>  	if (!proc_mkdir("fs/xfs", NULL))
>  		goto out;
>  
> -	if (!proc_create("fs/xfs/stat", 0, NULL,
> -			 &xfs_stat_proc_fops))
> +	if (!proc_symlink("fs/xfs/stat", NULL,
> +			  "/sys/fs/xfs/stats/stats"))
> +	{
> +		printk(KERN_INFO "failed to created fs/xfs/stat symlink\n");
>  		goto out_remove_xfs_dir;
> +	}
> +

I'm not sure we need the printk, we didn't say anything if proc_create(fs/xfs/stat) failed...

I guess the cleanup is fine as it is, right, it can remove a symlink too AFAIK.

-Eric


>  #ifdef CONFIG_XFS_QUOTA
>  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
>  			 &xqmstat_proc_fops))
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
