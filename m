Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE80BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6A62465B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R56y/A7h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVRCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:02:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgAVRCa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 12:02:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwjlt078568;
        Wed, 22 Jan 2020 17:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xGK6xRJsl2hVUKmpcAHvdK3/hsRDoCNSkD/n5h2SX5o=;
 b=R56y/A7h7AqYEWjhtp72XHt1f1cenD6ow3Cz7i4jV7Z+mS+L0F8bqtVdX0X6lrG1p3Ci
 jK/iKWWLf/KTFcSPMZB5Ko8+CM4Y0SZNZPlr7vuTbC/jmNgB4uu9PoZSpFqffOu6I4LJ
 OjHAXpN41nIq7x0BP5nTZbK2FJHiY/gpD/XbhoYHC8gtTeP3cxdlS/6V9lDZj53LDMc9
 tMHshrDFZP7z9XduKJwcutnMuCzPJF0ZUUoeaioc9WVmEY4k82sm2BDCKI6M7JXGd1DS
 8hQWCWXTWIg2b03Xh6SJM89T9UbkR0sIE/9fvpDJVnnGLVZWuPNiMFyKi1XiC5u4OSgf 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrcxt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 17:02:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwAPj009014;
        Wed, 22 Jan 2020 17:02:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xpq7jnexy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 17:02:23 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00MH2MYk000588;
        Wed, 22 Jan 2020 17:02:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 09:02:22 -0800
Date:   Wed, 22 Jan 2020 09:02:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfsprogs: alphabetize libxfs_api_defs.h
Message-ID: <20200122170221.GS8247@magnolia>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 10:41:05AM -0600, Eric Sandeen wrote:
> Rather than randomly choosing locations for new #defines in the
> future, alphabetize the file now for consistency.

LOLWUT, sanity??

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index eed63ace..33e52926 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -13,164 +13,167 @@
>   * it can be included in both the internal and external libxfs header files
>   * without introducing any depenencies between the two.
>   */
> -#define xfs_highbit32			libxfs_highbit32
> -#define xfs_highbit64			libxfs_highbit64
> -
> -#define xfs_trans_alloc			libxfs_trans_alloc
> -#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
> -#define xfs_trans_add_item		libxfs_trans_add_item
> -#define xfs_trans_bhold			libxfs_trans_bhold
> -#define xfs_trans_bhold_release		libxfs_trans_bhold_release
> -#define xfs_trans_binval		libxfs_trans_binval
> -#define xfs_trans_bjoin			libxfs_trans_bjoin
> -#define xfs_trans_brelse		libxfs_trans_brelse
> -#define xfs_trans_commit		libxfs_trans_commit
> -#define xfs_trans_cancel		libxfs_trans_cancel
> -#define xfs_trans_del_item		libxfs_trans_del_item
> -#define xfs_trans_get_buf		libxfs_trans_get_buf
> -#define xfs_trans_getsb			libxfs_trans_getsb
> -#define xfs_trans_ichgtime		libxfs_trans_ichgtime
> -#define xfs_trans_ijoin			libxfs_trans_ijoin
> -#define xfs_trans_init			libxfs_trans_init
> -#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
> -#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
> -#define xfs_trans_log_buf		libxfs_trans_log_buf
> -#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
> -#define xfs_trans_log_inode		libxfs_trans_log_inode
> -#define xfs_trans_roll_inode		libxfs_trans_roll_inode
> -#define xfs_trans_mod_sb		libxfs_trans_mod_sb
> -#define xfs_trans_read_buf		libxfs_trans_read_buf
> -#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
> -#define xfs_trans_roll			libxfs_trans_roll
> -#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
> -#define xfs_trans_resv_calc		libxfs_trans_resv_calc
> -#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
> -#define xfs_attr_get			libxfs_attr_get
> -#define xfs_attr_set			libxfs_attr_set
> -#define xfs_attr_remove			libxfs_attr_remove
> -#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
> +#define LIBXFS_ATTR_CREATE		ATTR_CREATE
> +#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
> +#define LIBXFS_ATTR_ROOT		ATTR_ROOT
> +#define LIBXFS_ATTR_SECURE		ATTR_SECURE
>  
> +#define xfs_agfl_size			libxfs_agfl_size
>  #define xfs_agfl_walk			libxfs_agfl_walk
> +
> +#define xfs_ag_init_headers		libxfs_ag_init_headers
> +
> +#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
> +#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
>  #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
>  #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
>  #define xfs_alloc_read_agf		libxfs_alloc_read_agf
> -#define xfs_bmap_last_offset		libxfs_bmap_last_offset
> -#define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
> -#define xfs_bmapi_write			libxfs_bmapi_write
> -#define xfs_bmapi_read			libxfs_bmapi_read
> -#define xfs_bunmapi			libxfs_bunmapi
> -#define xfs_rtfree_extent		libxfs_rtfree_extent
> -#define xfs_verify_rtbno		libxfs_verify_rtbno
> -#define xfs_verify_ino			libxfs_verify_ino
> -#define xfs_zero_extent			libxfs_zero_extent
>  
> -#define xfs_defer_finish		libxfs_defer_finish
> -#define xfs_defer_cancel		libxfs_defer_cancel
> +#define xfs_attr_get			libxfs_attr_get
> +#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
> +#define xfs_attr_namecheck		libxfs_attr_namecheck
> +#define xfs_attr_remove			libxfs_attr_remove
> +#define xfs_attr_set			libxfs_attr_set
>  
> +#define xfs_bmapi_read			libxfs_bmapi_read
> +#define xfs_bmapi_write			libxfs_bmapi_write
> +#define xfs_bmap_last_offset		libxfs_bmap_last_offset
> +#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
> +#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
> +
> +#define xfs_btree_del_cursor		libxfs_btree_del_cursor
> +#define xfs_btree_init_block		libxfs_btree_init_block
> +#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> +#define xfs_bunmapi			libxfs_bunmapi
> +#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> +#define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
> +#define xfs_da_get_buf			libxfs_da_get_buf
>  #define xfs_da_hashname			libxfs_da_hashname
> -#define xfs_da_shrink_inode		libxfs_da_shrink_inode
>  #define xfs_da_read_buf			libxfs_da_read_buf
> -#define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
> -#define xfs_dir_createname		libxfs_dir_createname
> -#define xfs_dir_init			libxfs_dir_init
> -#define xfs_dir_lookup			libxfs_dir_lookup
> -#define xfs_dir_replace			libxfs_dir_replace
> +#define xfs_da_shrink_inode		libxfs_da_shrink_inode
> +#define xfs_default_ifork_ops		libxfs_default_ifork_ops
> +#define xfs_defer_cancel		libxfs_defer_cancel
> +#define xfs_defer_finish		libxfs_defer_finish
> +#define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
> +#define xfs_dinode_good_version		libxfs_dinode_good_version
> +#define xfs_dinode_verify		libxfs_dinode_verify
> +
>  #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
> -#define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
> -#define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
> -#define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
> -#define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
> -#define xfs_dir2_isblock		libxfs_dir2_isblock
> -#define xfs_dir2_isleaf			libxfs_dir2_isleaf
> +#define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
> +#define xfs_dir2_data_entsize		libxfs_dir2_data_entsize
>  #define xfs_dir2_data_freescan		libxfs_dir2_data_freescan
> +#define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
>  #define xfs_dir2_data_log_entry		libxfs_dir2_data_log_entry
>  #define xfs_dir2_data_log_header	libxfs_dir2_data_log_header
>  #define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
> +#define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
>  #define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
> -#define xfs_dir2_data_entsize		libxfs_dir2_data_entsize
> -#define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
> +#define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
>  #define xfs_dir2_hashname		libxfs_dir2_hashname
> -#define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
> -#define xfs_dir2_sf_get_parent_ino	libxfs_dir2_sf_get_parent_ino
> -#define xfs_dir2_sf_put_parent_ino	libxfs_dir2_sf_put_parent_ino
> +#define xfs_dir2_isblock		libxfs_dir2_isblock
> +#define xfs_dir2_isleaf			libxfs_dir2_isleaf
> +#define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
> +#define xfs_dir2_namecheck		libxfs_dir2_namecheck
>  #define xfs_dir2_sf_entsize		libxfs_dir2_sf_entsize
> -#define xfs_dir2_sf_nextentry		libxfs_dir2_sf_nextentry
>  #define xfs_dir2_sf_get_ftype		libxfs_dir2_sf_get_ftype
> -#define xfs_dir2_sf_put_ftype		libxfs_dir2_sf_put_ftype
>  #define xfs_dir2_sf_get_ino		libxfs_dir2_sf_get_ino
> +#define xfs_dir2_sf_get_parent_ino	libxfs_dir2_sf_get_parent_ino
> +#define xfs_dir2_sf_nextentry		libxfs_dir2_sf_nextentry
> +#define xfs_dir2_sf_put_ftype		libxfs_dir2_sf_put_ftype
>  #define xfs_dir2_sf_put_ino		libxfs_dir2_sf_put_ino
> -#define xfs_dir2_namecheck		libxfs_dir2_namecheck
> -#define xfs_da_get_buf			libxfs_da_get_buf
> -
> -#define xfs_inode_from_disk		libxfs_inode_from_disk
> -#define xfs_inode_to_disk		libxfs_inode_to_disk
> -#define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
> -#define xfs_idata_realloc		libxfs_idata_realloc
> -#define xfs_idestroy_fork		libxfs_idestroy_fork
> -#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
> -#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
> -
> -#define xfs_rmap_alloc			libxfs_rmap_alloc
> -#define xfs_rmap_query_range		libxfs_rmap_query_range
> -#define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
> -#define xfs_rmap_get_rec		libxfs_rmap_get_rec
> -#define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
> -#define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
> -#define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
> -#define xfs_btree_del_cursor		libxfs_btree_del_cursor
> -#define xfs_mode_to_ftype		libxfs_mode_to_ftype
> +#define xfs_dir2_sf_put_parent_ino	libxfs_dir2_sf_put_parent_ino
> +#define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
>  
> -#define xfs_log_sb			libxfs_log_sb
> -#define xfs_sb_from_disk		libxfs_sb_from_disk
> -#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
> -#define xfs_sb_to_disk			libxfs_sb_to_disk
> +#define xfs_dir_createname		libxfs_dir_createname
> +#define xfs_dir_init			libxfs_dir_init
> +#define xfs_dir_ino_validate		libxfs_dir_ino_validate
> +#define xfs_dir_lookup			libxfs_dir_lookup
> +#define xfs_dir_replace			libxfs_dir_replace
>  
> -#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> -#define xfs_dquot_verify		libxfs_dquot_verify
>  #define xfs_dqblk_repair		libxfs_dqblk_repair
> +#define xfs_dquot_verify		libxfs_dquot_verify
>  
> -#define xfs_symlink_blocks		libxfs_symlink_blocks
> -#define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
> -
> -#define xfs_verify_cksum		libxfs_verify_cksum
> -#define xfs_dinode_verify		libxfs_dinode_verify
> -
> -#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
> -#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
> -#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
> -#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
> -#define xfs_btree_init_block		libxfs_btree_init_block
> -#define xfs_dir_ino_validate		libxfs_dir_ino_validate
> +#define xfs_free_extent			libxfs_free_extent
> +#define xfs_fs_geometry			libxfs_fs_geometry
> +#define xfs_highbit32			libxfs_highbit32
> +#define xfs_highbit64			libxfs_highbit64
> +#define xfs_idata_realloc		libxfs_idata_realloc
> +#define xfs_idestroy_fork		libxfs_idestroy_fork
> +#define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
>  #define xfs_initialize_perag_data	libxfs_initialize_perag_data
> +#define xfs_init_local_fork		libxfs_init_local_fork
> +
>  #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
> -#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
> -#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
> +#define xfs_inode_from_disk		libxfs_inode_from_disk
> +#define xfs_inode_to_disk		libxfs_inode_to_disk
> +#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
> +#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
> +
>  #define xfs_iread_extents		libxfs_iread_extents
>  #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
> +#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
> +#define xfs_log_sb			libxfs_log_sb
> +#define xfs_mode_to_ftype		libxfs_mode_to_ftype
>  #define xfs_perag_get			libxfs_perag_get
>  #define xfs_perag_put			libxfs_perag_put
>  #define xfs_prealloc_blocks		libxfs_prealloc_blocks
> -#define xfs_dinode_good_version		libxfs_dinode_good_version
> -#define xfs_free_extent			libxfs_free_extent
>  
> +#define xfs_refc_block			libxfs_refc_block
>  #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
> -#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
> +#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
>  #define xfs_refcount_get_rec		libxfs_refcount_get_rec
> -#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
> -#define xfs_agfl_size			libxfs_agfl_size
> -#define xfs_refc_block			libxfs_refc_block
> +#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
> +
> +#define xfs_rmap_alloc			libxfs_rmap_alloc
> +#define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
> +#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
>  #define xfs_rmap_compare		libxfs_rmap_compare
> -#define xfs_default_ifork_ops		libxfs_default_ifork_ops
> -#define xfs_fs_geometry			libxfs_fs_geometry
> -#define xfs_init_local_fork		libxfs_init_local_fork
> -#define xfs_attr_namecheck		libxfs_attr_namecheck
> +#define xfs_rmap_get_rec		libxfs_rmap_get_rec
> +#define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
> +#define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
> +#define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
> +#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
> +#define xfs_rmap_query_range		libxfs_rmap_query_range
>  
> -#define LIBXFS_ATTR_ROOT		ATTR_ROOT
> -#define LIBXFS_ATTR_SECURE		ATTR_SECURE
> -#define LIBXFS_ATTR_CREATE		ATTR_CREATE
> -#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
> +#define xfs_rtfree_extent		libxfs_rtfree_extent
> +#define xfs_sb_from_disk		libxfs_sb_from_disk
> +#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
> +#define xfs_sb_to_disk			libxfs_sb_to_disk
> +#define xfs_symlink_blocks		libxfs_symlink_blocks
> +#define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
>  
> -#define xfs_ag_init_headers		libxfs_ag_init_headers
> -#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> +#define xfs_trans_add_item		libxfs_trans_add_item
> +#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
> +#define xfs_trans_alloc			libxfs_trans_alloc
> +#define xfs_trans_bhold			libxfs_trans_bhold
> +#define xfs_trans_bhold_release		libxfs_trans_bhold_release
> +#define xfs_trans_binval		libxfs_trans_binval
> +#define xfs_trans_bjoin			libxfs_trans_bjoin
> +#define xfs_trans_brelse		libxfs_trans_brelse
> +#define xfs_trans_cancel		libxfs_trans_cancel
> +#define xfs_trans_commit		libxfs_trans_commit
> +#define xfs_trans_del_item		libxfs_trans_del_item
> +#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
> +#define xfs_trans_get_buf		libxfs_trans_get_buf
> +#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
> +#define xfs_trans_getsb			libxfs_trans_getsb
> +#define xfs_trans_ichgtime		libxfs_trans_ichgtime
> +#define xfs_trans_ijoin			libxfs_trans_ijoin
> +#define xfs_trans_init			libxfs_trans_init
> +#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
> +#define xfs_trans_log_buf		libxfs_trans_log_buf
> +#define xfs_trans_log_inode		libxfs_trans_log_inode
> +#define xfs_trans_mod_sb		libxfs_trans_mod_sb
> +#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
> +#define xfs_trans_read_buf		libxfs_trans_read_buf
> +#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
> +#define xfs_trans_resv_calc		libxfs_trans_resv_calc
> +#define xfs_trans_roll_inode		libxfs_trans_roll_inode
> +#define xfs_trans_roll			libxfs_trans_roll
> +
> +#define xfs_verify_cksum		libxfs_verify_cksum
> +#define xfs_verify_ino			libxfs_verify_ino
> +#define xfs_verify_rtbno		libxfs_verify_rtbno
> +#define xfs_zero_extent			libxfs_zero_extent
>  
>  #endif /* __LIBXFS_API_DEFS_H__ */
> 
