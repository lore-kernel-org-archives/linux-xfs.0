Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3731 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755638AbeEaQCR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:02:17 -0400
Subject: Re: [PATCH] xfs_db: handle realtime bitmap / summary files as text
References: <20180531155724.GZ837@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <29f4d635-e090-ddaf-c2b4-bcd1309f4196@redhat.com>
Date: Thu, 31 May 2018 11:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <20180531155724.GZ837@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 5/31/18 10:57 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use handle_text to print realtime bitmap / summary file blocks instead
> of erroring out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   db/type.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/db/type.c b/db/type.c
> index 8b2f7b2f..7045d829 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -71,8 +71,8 @@ static const typ_t	__typtab[] = {
>   	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> @@ -115,8 +115,8 @@ static const typ_t	__typtab_crc[] = {
>   	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>   		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>   	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
>   		XFS_SB_CRC_OFF },
>   	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
> @@ -161,8 +161,8 @@ static const typ_t	__typtab_spcrc[] = {
>   	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>   		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>   	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> +	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
>   	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
>   		XFS_SB_CRC_OFF },
>   	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
> 

