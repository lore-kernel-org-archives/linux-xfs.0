Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXR46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:56:58 -0400
Date: Mon, 24 Jun 2019 10:56:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/10] xfs: mount-api - add xfs_fc_free()
Message-ID: <20190624175627.GY5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134514204.2519.9597800141023778002.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134514204.2519.9597800141023778002.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:59:02AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .free that performs fs
> context cleanup on context release.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7326b21b32d1..0a771e1390e7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2413,10 +2413,33 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static void xfs_fc_free(struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +
> +	if (mp) {
> +		/*
> +		 * If an error occurs before ownership the xfs_mount
> +		 * info struct is passed to xfs by the VFS (by assigning
> +		 * it to sb->s_fs_info and clearing the corresponding
> +		 * fs_context field, done before calling fill super via
> +		 * .get_tree()) there may be some strings to cleanup.
> +		 */
> +		if (mp->m_logname)
> +			kfree(mp->m_logname);

Doesn't kfree handle null parameters gracefully?

--D

> +		if (mp->m_rtname)
> +			kfree(mp->m_rtname);
> +		kfree(mp);
> +	}
> +	kfree(ctx);
> +}
> +
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
>  	.reconfigure = xfs_reconfigure,
> +	.free	     = xfs_fc_free,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
