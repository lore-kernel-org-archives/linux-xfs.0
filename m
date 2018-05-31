Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755575AbeEaQFy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:05:54 -0400
Date: Thu, 31 May 2018 11:05:50 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_db: handle realtime bitmap / summary files as text
Message-ID: <20180531160550.GA12504@redhat.com>
References: <20180531155724.GZ837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531155724.GZ837@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, May 31, 2018 at 08:57:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use handle_text to print realtime bitmap / summary file blocks instead
> of erroring out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  db/type.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/db/type.c b/db/type.c
> index 8b2f7b2f..7045d829 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -71,8 +71,8 @@ static const typ_t	__typtab[] = {
>  	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> @@ -115,8 +115,8 @@ static const typ_t	__typtab_crc[] = {
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
>  		XFS_SB_CRC_OFF },
>  	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
> @@ -161,8 +161,8 @@ static const typ_t	__typtab_spcrc[] = {
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
>  		XFS_SB_CRC_OFF },
>  	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
