Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751844AbeBAVyy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 16:54:54 -0500
Date: Thu, 1 Feb 2018 15:54:52 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_mdrestore: Don't restore over a dump file
Message-ID: <20180201215452.GB9528@redhat.com>
References: <1517517463-99951-1-git-send-email-marco.antonio.780@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517517463-99951-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco A Benatto <marco.antonio.780@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 06:37:43PM -0200, Marco A Benatto wrote:
> Currently, if the user switch source and target parameters
> position, xfs_mdrestore truncates the dumpfile before abort
> the execution.
> 
> This patch checks the target parameter and if XFS_MD_MAGIC is
> found, it aborts execution and leave dump file intact.
> 
> Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>

a few nits...otherwise,

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mdrestore/xfs_mdrestore.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c49c13a..b4bf7b4 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -205,7 +205,7 @@ main(
>  	int 		argc,
>  	char 		**argv)
>  {
> -	FILE		*src_f;
> +	FILE		*src_f, *dst_f;
>  	int		dst_fd;
>  	int		c;
>  	int		open_flags;
> @@ -277,6 +277,7 @@ main(
>  
>  	optind++;
>  
> +
^^^ extra space.

>  	/* check and open target */
>  	open_flags = O_RDWR;
>  	is_target_file = 0;
> @@ -285,6 +286,19 @@ main(
>  		open_flags |= O_CREAT;
>  		is_target_file = 1;
>  	} else if (S_ISREG(statbuf.st_mode))  {
> +		xfs_metablock_t mb;
> +
> +		dst_f = fopen(argv[optind], "rb");
> +		if (dst_f == NULL)
> +			fatal("cannot open target\n");
> +
> +		if (fread(&mb, sizeof(mb), 1, dst_f) == 1) {
> +			if (be32_to_cpu(mb.mb_magic) == XFS_MD_MAGIC)
> +				fatal("target file is a xfs_metadump. switched arguments?\n");
^^^ exceeded 80 columns...probably ok for stdout messages... shrug.

> +		}
> +
> +		fclose(dst_f);
> +
>  		open_flags |= O_TRUNC;
>  		is_target_file = 1;
>  	} else  {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
