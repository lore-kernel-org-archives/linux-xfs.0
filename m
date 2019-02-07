Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbfBGU1J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 15:27:09 -0500
Date: Thu, 7 Feb 2019 15:27:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/8] xfs: add magic numbers to dquot buffer ops
Message-ID: <20190207202706.GE61958@bfoster>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207185652.GH7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207185652.GH7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 10:56:52AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add dquot magic numbers to the buffer ops type, in case we ever want to
> use them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index d293f371dd54..b956638a3532 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -277,6 +277,8 @@ xfs_dquot_buf_write_verify(
>  
>  const struct xfs_buf_ops xfs_dquot_buf_ops = {
>  	.name = "xfs_dquot",
> +	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
> +		   cpu_to_be16(XFS_DQUOT_MAGIC) },
>  	.verify_read = xfs_dquot_buf_read_verify,
>  	.verify_write = xfs_dquot_buf_write_verify,
>  	.verify_struct = xfs_dquot_buf_verify_struct,
> @@ -284,6 +286,8 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
>  
>  const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
>  	.name = "xfs_dquot_ra",
> +	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
> +		   cpu_to_be16(XFS_DQUOT_MAGIC) },
>  	.verify_read = xfs_dquot_buf_readahead_verify,
>  	.verify_write = xfs_dquot_buf_write_verify,
>  };
