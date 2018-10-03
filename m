Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36300 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbeJCTgD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:36:03 -0400
Subject: Re: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-2-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <46ff8aca-5053-541d-6d74-fbc7e12a9898@sandeen.net>
Date: Wed, 3 Oct 2018 07:47:46 -0500
MIME-Version: 1.0
In-Reply-To: <20181003123537.30965-2-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 10/3/18 7:35 AM, Carlos Maiolino wrote:
> The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> __xfssats structure.
> 
> Although this didn't cause any direct issue,  xqmstat_proc_show() relied
> on the old offsets to display the xqm statistics.

Well, it caused /proc/fs/xfs/xqmstat to display garbage data, right?
That seems worth highlighting in the changelog, and not glossing over.

Could maybe use Fixes: tags for:

00f4e4f9 xfs: add rmap btree stats infrastructure
aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
46eeb521 xfs: introduce refcount btree definitions

and a stable tag as well?  Though stable is tricky because different patches
would be required for different points along the stats structure evolution...
maybe best to ignore it, chances of auto-applying it correctly are slim to
none.

As for the change itself,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>



> Fix it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 4e4423153071..740ac9674848 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
>  	int j;
>  
>  	seq_printf(m, "qm");
> -	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
> +	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
>  		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
>  	seq_putc(m, '\n');
>  	return 0;
> 
