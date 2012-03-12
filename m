Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CHtCN2116276 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 12:55:12 -0500
Date: Mon, 12 Mar 2012 12:55:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120312175519.GE7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221014809.GA18227@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 20, 2012 at 08:48:09PM -0500, Christoph Hellwig wrote:
> Switch the quota code over to use the generic XFS statistics infrastructure.
> While the legacy /proc/fs/xfs/xqm and /proc/fs/xfs/xqmstats interfaces are
> preserved for now the statistics that still have a meaning with the current
> code are now also available from /proc/fs/xfs/stats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> +/* legacy quota interfaces */
> +#ifdef CONFIG_XFS_QUOTA
> +static int xqm_proc_show(struct seq_file *m, void *v)
> +{
> +	/* maximum; incore; ratio free to inuse; freelist */
> +	seq_printf(m, "%d\t%d\t%d\t%u\n",
> +			0,
> +			counter_val(XFSSTAT_END_XQMSTAT),

That's xfs_qm_dquot

> +			0,
> +			counter_val(XFSSTAT_END_XQMSTAT + 1));

and xfs_qm_dquot_unused?  A comment would make your intent clear.

> +	return 0;
> +}
> +
> +static int xqm_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, xqm_proc_show, NULL);
> +}
> +
> +static const struct file_operations xqm_proc_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= xqm_proc_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +/* legacy quota stats interface no 2 */
> +static int xqmstat_proc_show(struct seq_file *m, void *v)
> +{
> +	int j;
> +
> +	seq_printf(m, "qm");
> +	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
> +		seq_printf(m, " %u", counter_val(j));

And a comment here with all of the stuff you're printing out would be
total overkill.  Nevermind.  ;) 

...

>  int
>  xfs_init_procfs(void)
>  {
> @@ -105,10 +162,24 @@ xfs_init_procfs(void)
>  
>  	if (!proc_create("fs/xfs/stat", 0, NULL,
>  			 &xfs_stat_proc_fops))
> -		goto out_remove_entry;
> +		goto out_remove_xfs_dir;
> +#ifdef CONFIG_XFS_QUOTA
> +	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
> +			 &xqmstat_proc_fops))
> +		goto out_remove_stat_file;
> +	if (!proc_create("fs/xfs/xqm", 0, NULL,
> +			 &xqm_proc_fops))
> +		goto out_remove_xqmstat_file;
> +#endif
>  	return 0;
>  
> - out_remove_entry:
> +#ifdef CONFIG_XFS_QUOTA
> + out_remove_xqmstat_file:
> +	remove_proc_entry("fs/xfs/xqmstat", NULL);
> + out_remove_stat_file:
> +	remove_proc_entry("fs/xfs/stat", NULL);
> +#endif
> + out_remove_xfs_dir:

I'm glad to see that you added error handling here.  There wasn't any in
the xfs_qm_init_procfs before.  

This patch looks great.  It might break some PCP scripts, I'm not sure.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
