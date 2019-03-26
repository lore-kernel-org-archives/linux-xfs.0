Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58302 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfCZRFF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:05:05 -0400
Subject: Re: [PATCH 20/36] xfs_db: fix finobt record decoding when sparse
 inodes enabled
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259755345.31886.7689089384611545119.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <30c90f32-8edb-639a-331a-cfddea80e87b@sandeen.net>
Date: Tue, 26 Mar 2019 12:05:04 -0500
MIME-Version: 1.0
In-Reply-To: <155259755345.31886.7689089384611545119.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the sparse inobt record field decoder (inobt_spcrc_hfld) to decode
> finobt records when sparse inodes are enabled.  Otherwise, xfs_db
> prints out bogus things like:
> 
> recs[1] = [startino,freecount,free]
> 1:[214720,16429,0xfffffffffff80000]
> 
> There can never be 16429 records in an inode btree record; instead it
> should print:
> 
> recs[1] = [startino,holemask,count,freecount,free]
> 1:[214720,0,64,45,0xfffffffffff80000]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Um... :) 

commit 38c599e7782ced7d2d1b41c3182daeaddad2cee4
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Mon Jan 28 13:03:15 2019 -0600

    xfs_db: fix finobt record decoding when sparse inodes enabled
    
    Use the sparse inobt record field decoder (inobt_spcrc_hfld) to decode
    finobt records when sparse inodes are enabled.  Otherwise, xfs_db
    prints out bogus things like:
    
    recs[1] = [startino,freecount,free]
    1:[214720,16429,0xfffffffffff80000]
    
    There can never be 16429 records in an inode btree record; instead it
    should print:
    
    recs[1] = [startino,holemask,count,freecount,free]
    1:[214720,0,64,45,0xfffffffffff80000]
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  db/type.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/db/type.c b/db/type.c
> index f5f65042..d42935a2 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -107,7 +107,7 @@ static const typ_t	__typtab_crc[] = {
>  	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
>  		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
>  	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
> +	{ TYP_FINOBT, "finobt", handle_struct, inobt_spcrc_hfld,
>  		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
>  	{ TYP_NONE, NULL }
>  };
> 
