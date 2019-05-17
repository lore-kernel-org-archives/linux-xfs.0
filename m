Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfEQVGi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 17:06:38 -0400
Subject: Re: [PATCH 2/3] libxfs: remove libxfs API #defines for unexported xfs
 functions
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <085b0a9f-9ae7-72da-743e-0cccc81146a1@redhat.com>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <2ff713b6-0f9e-2f6e-e685-4990f719e61b@oracle.com>
Date: Fri, 17 May 2019 14:06:19 -0700
MIME-Version: 1.0
In-Reply-To: <085b0a9f-9ae7-72da-743e-0cccc81146a1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 5/16/19 10:45 AM, Eric Sandeen wrote:
> We define "libxfs_*" functions for anything used by userspace,
> called from outside the libxfs/ directory.  However, many of the
> current redefinitions are for functions only used within libxfs/*
> so remove their API redefinitions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Ok, looks good to me.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 2b8ac5ab..a53efa68 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -18,37 +18,22 @@
>   
>   #define xfs_trans_alloc			libxfs_trans_alloc
>   #define xfs_trans_alloc_rollable	libxfs_trans_alloc_rollable
> -#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
> -#define xfs_trans_add_item		libxfs_trans_add_item
>   #define xfs_trans_bhold			libxfs_trans_bhold
>   #define xfs_trans_binval		libxfs_trans_binval
>   #define xfs_trans_bjoin			libxfs_trans_bjoin
>   #define xfs_trans_brelse		libxfs_trans_brelse
>   #define xfs_trans_commit		libxfs_trans_commit
>   #define xfs_trans_cancel		libxfs_trans_cancel
> -#define xfs_trans_del_item		libxfs_trans_del_item
>   #define xfs_trans_get_buf		libxfs_trans_get_buf
> -#define xfs_trans_getsb			libxfs_trans_getsb
>   #define xfs_trans_ichgtime		libxfs_trans_ichgtime
>   #define xfs_trans_ijoin			libxfs_trans_ijoin
> -#define xfs_trans_init			libxfs_trans_init
> -#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
> -#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
>   #define xfs_trans_log_buf		libxfs_trans_log_buf
> -#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
>   #define xfs_trans_log_inode		libxfs_trans_log_inode
>   #define xfs_trans_roll_inode		libxfs_trans_roll_inode
> -#define xfs_trans_mod_sb		libxfs_trans_mod_sb
>   #define xfs_trans_read_buf		libxfs_trans_read_buf
> -#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
> -#define xfs_trans_roll			libxfs_trans_roll
> -#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
> -#define xfs_trans_resv_calc		libxfs_trans_resv_calc
>   #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
> -#define xfs_attr_get			libxfs_attr_get
>   #define xfs_attr_set			libxfs_attr_set
>   #define xfs_attr_remove			libxfs_attr_remove
> -#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
>   
>   #define xfs_agfl_walk			libxfs_agfl_walk
>   #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
> @@ -57,15 +42,11 @@
>   #define xfs_bmap_last_offset		libxfs_bmap_last_offset
>   #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
>   #define xfs_bmapi_write			libxfs_bmapi_write
> -#define xfs_bmapi_read			libxfs_bmapi_read
>   #define xfs_bunmapi			libxfs_bunmapi
>   #define xfs_rtfree_extent		libxfs_rtfree_extent
> -#define xfs_verify_rtbno		libxfs_verify_rtbno
>   #define xfs_verify_ino			libxfs_verify_ino
> -#define xfs_zero_extent			libxfs_zero_extent
>   
>   #define xfs_defer_finish		libxfs_defer_finish
> -#define xfs_defer_cancel		libxfs_defer_cancel
>   
>   #define xfs_da_hashname			libxfs_da_hashname
>   #define xfs_da_shrink_inode		libxfs_da_shrink_inode
> @@ -85,14 +66,11 @@
>   #define xfs_da_get_buf			libxfs_da_get_buf
>   
>   #define xfs_inode_from_disk		libxfs_inode_from_disk
> -#define xfs_inode_to_disk		libxfs_inode_to_disk
>   #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
>   #define xfs_idata_realloc		libxfs_idata_realloc
> -#define xfs_idestroy_fork		libxfs_idestroy_fork
>   #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
>   #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
>   #define xfs_inode_alloc			libxfs_inode_alloc
> -#define xfs_iflush_int			libxfs_iflush_int
>   #define xfs_alloc_file_space		libxfs_alloc_file_space
>   
>   #define xfs_rmap_alloc			libxfs_rmap_alloc
> @@ -107,7 +85,6 @@
>   
>   #define xfs_log_sb			libxfs_log_sb
>   #define xfs_sb_from_disk		libxfs_sb_from_disk
> -#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
>   #define xfs_sb_to_disk			libxfs_sb_to_disk
>   
>   #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> @@ -151,6 +128,5 @@
>   #define xfs_getsb			libxfs_getsb
>   #define xfs_irele			libxfs_irele
>   #define xfs_iget			libxfs_iget
> -#define xfs_inode_verify_forks		libxfs_inode_verify_forks
>   
>   #endif /* __LIBXFS_API_DEFS_H__ */
> 
