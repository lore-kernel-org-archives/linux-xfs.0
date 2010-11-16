Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGBpLTZ037993 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 05:51:21 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29DD81C47956
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 03:52:53 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RCGBMEJZ5xcg9MDY for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 03:52:53 -0800 (PST)
Date: Tue, 16 Nov 2010 12:52:52 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101116115252.GD4757@quack.suse.cz>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289840723-3056-5-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon 15-11-10 12:05:21, Josef Bacik wrote:
> Ext4 doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> be added later.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/extents.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0554c48..35bca73 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits = inode->i_blkbits;
>  
> +	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> +	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
