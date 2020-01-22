Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAAEC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0EFB2465A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 16:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RybKASFD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVQlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:41:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725970AbgAVQlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 11:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579711269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=PT8cibtYYIibxsVFDOtflyVCGNaG5eXNGuMkqpxAjCo=;
        b=RybKASFDfW04qz2lFPOqpAYZ9o8ZB8PFujoS+YyLfrI+mFE87wVJYdjO59ood/8sXKdiHi
        3j66VJXRKSbAcXAVKDou05aKWEU28NeY2L/iZZLFNxf4pZY6iOknyvXa0t1Y2jv4pd9G41
        tyOoxSdu9GNFBqEzXY7IVV27LOLWlx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-MrU30TCUME6aLNFAv60KIA-1; Wed, 22 Jan 2020 11:41:06 -0500
X-MC-Unique: MrU30TCUME6aLNFAv60KIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D37BC18C8C02
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:41:05 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7DAC19C6A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 16:41:05 +0000 (UTC)
Subject: [PATCH 1/2] xfsprogs: alphabetize libxfs_api_defs.h
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCRFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5AcmVkaGF0LmNvbT6JAjgEEwECACIFAk6yrl4CGwMGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAAAoJECCuFpLhPd7gh2kP/A6CRmIF2MSttebyBk+6Ppx47ct+Kcmp
 YokwfI9iahSPiQ+LmmBZE+PMYesE+8+lsSiAvzz6YEXsfWMlGzHiqiE76d2xSOYVPO2rX7xl
 4T2J98yZlYrjMDmQ6gpFe0ZBpVl45CFUYkBaeulEMspzaYLH6zGsPjgfVJyYnW94ZXLWcrST
 ixBPJcDtk4j6jrbY3K8eVFimK+RSq6CqZgUZ+uaDA/wJ4kHrYuvM3QPbsHQr/bYSNkVAFxgl
 G6a4CSJ4w70/dT9FFb7jzj30nmaBmDFcuC+xzecpcflaLvuFayuBJslMp4ebaL8fglvntWsQ
 ZM8361Ckjt82upo2JRYiTrlE9XiSEGsxW3EpdFT3vUmIlgY0/Xo5PGv3ySwcFucRUk1Q9j+Z
 X4gCaX5sHpQM03UTaDx4jFdGqOLnTT1hfrMQZ3EizVbnQW9HN0snm9lD5P6O1dxyKbZpevfW
 BfwdQ35RXBbIKDmmZnwJGJgYl5Bzh5DlT0J7oMVOzdEVYipWx82wBqHVW4I1tPunygrYO+jN
 n+BLwRCOYRJm5BANwYx0MvWlm3Mt3OkkW2pbX+C3P5oAcxrflaw3HeEBi/KYkygxovWl93IL
 TsW03R0aNcI6bSdYR/68pL4ELdx7G/SLbaHf28FzzUFjRvN55nBoMePOFo1O6KtkXXQ4GbXV
 ebdvuQINBE6x99QBEADQOtSJ9OtdDOrE7xqJA4Lmn1PPbk2n9N+m/Wuh87AvxU8Ey8lfg/mX
 VXbJ3vQxlFRWCOYLJ0TLEsnobZjIc7YhlMRqNRjRSn5vcSs6kulnCG+BZq2OJ+mPpsFIq4Nd
 5OGoV2SmEXmQCaB9UAiRqflLFYrf5LRXYX+jGy0hWIGEyEPAjpexGWdUGgsthwSKXEDYWVFR
 Lsw5kaZEmRG10YPmShVlIzrFVlBKZ8QFphD9YkEYlB0/L3ieeUBWfeUff43ule81S4IZX63h
 hS3e0txG4ilgEI5aVztumB4KmzldrR0hmAnwui67o4Enm9VeM/FOWQV1PRLT+56sIbnW7ynq
 wZEudR4BQaRB8hSoZSNbasdpeBY2/M5XqLe1/1hqJcqXdq8Vo1bWQoGzRPkzVyeVZlRS2XqT
 TiXPk6Og1j0n9sbJXcNKWRuVdEwrzuIthBKtxXpwXP09GXi9bUsZ9/fFFAeeB43l8/HN7xfk
 0TeFv5JLDIxISonGFVNclV9BZZbR1DE/sc3CqY5ZgX/qb7WAr9jaBjeMBCexZOu7hFVNkacr
 AQ+Y4KlJS+xNFexUeCxYnvSp3TI5KNa6K/hvy+YPf5AWDK8IHE8x0/fGzE3l62F4sw6BHBak
 ufrI0Wr/G2Cz4QKAb6BHvzJdDIDuIKzm0WzY6sypXmO5IwaafSTElQARAQABiQIfBBgBAgAJ
 BQJOsffUAhsMAAoJECCuFpLhPd7gErAP/Rk46ZQ05kJI4sAyNnHea1i2NiB9Q0qLSSJg+94a
 hFZOpuKzxSK0+02sbhfGDMs6KNJ04TNDCR04in9CdmEY2ywx6MKeyW4rQZB35GQVVY2ZxBPv
 yEF4ZycQwBdkqrtuQgrO9zToYWaQxtf+ACXoOI0a/RQ0Bf7kViH65wIllLICnewD738sqPGd
 N51fRrKBcDquSlfRjQW83/11+bjv4sartYCoE7JhNTcTr/5nvZtmgb9wbsA0vFw+iiUs6tTj
 eioWcPxDBw3nrLhV8WPf+MMXYxffG7i/Y6OCVWMwRgdMLE/eanF6wYe6o6K38VH6YXQw/0kZ
 +PrH5uP/0kwG0JbVtj9o94x08ZMm9eMa05VhuUZmtKNdGfn75S7LfoK+RyuO7OJIMb4kR7Eb
 FzNbA3ias5BaExPknJv7XwI74JbEl8dpheIsRbt0jUDKcviOOfhbQxKJelYNTD5+wE4+TpqH
 XQLj5HUlzt3JSwqSwx+++FFfWFMheG2HzkfXrvTpud5NrJkGGVn+ErXy6pNf6zSicb+bUXe9
 i92UTina2zWaaLEwXspqM338TlFC2JICu8pNt+wHpPCjgy2Ei4u5/4zSYjiA+X1I+V99YJhU
 +FpT2jzfLUoVsP/6WHWmM/tsS79i50G/PsXYzKOHj/0ZQCKOsJM14NMMCC8gkONe4tek
Message-ID: <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
Date:   Wed, 22 Jan 2020 10:41:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rather than randomly choosing locations for new #defines in the
future, alphabetize the file now for consistency.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index eed63ace..33e52926 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -13,164 +13,167 @@
  * it can be included in both the internal and external libxfs header files
  * without introducing any depenencies between the two.
  */
-#define xfs_highbit32			libxfs_highbit32
-#define xfs_highbit64			libxfs_highbit64
-
-#define xfs_trans_alloc			libxfs_trans_alloc
-#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
-#define xfs_trans_add_item		libxfs_trans_add_item
-#define xfs_trans_bhold			libxfs_trans_bhold
-#define xfs_trans_bhold_release		libxfs_trans_bhold_release
-#define xfs_trans_binval		libxfs_trans_binval
-#define xfs_trans_bjoin			libxfs_trans_bjoin
-#define xfs_trans_brelse		libxfs_trans_brelse
-#define xfs_trans_commit		libxfs_trans_commit
-#define xfs_trans_cancel		libxfs_trans_cancel
-#define xfs_trans_del_item		libxfs_trans_del_item
-#define xfs_trans_get_buf		libxfs_trans_get_buf
-#define xfs_trans_getsb			libxfs_trans_getsb
-#define xfs_trans_ichgtime		libxfs_trans_ichgtime
-#define xfs_trans_ijoin			libxfs_trans_ijoin
-#define xfs_trans_init			libxfs_trans_init
-#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
-#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
-#define xfs_trans_log_buf		libxfs_trans_log_buf
-#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
-#define xfs_trans_log_inode		libxfs_trans_log_inode
-#define xfs_trans_roll_inode		libxfs_trans_roll_inode
-#define xfs_trans_mod_sb		libxfs_trans_mod_sb
-#define xfs_trans_read_buf		libxfs_trans_read_buf
-#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
-#define xfs_trans_roll			libxfs_trans_roll
-#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
-#define xfs_trans_resv_calc		libxfs_trans_resv_calc
-#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
-#define xfs_attr_get			libxfs_attr_get
-#define xfs_attr_set			libxfs_attr_set
-#define xfs_attr_remove			libxfs_attr_remove
-#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
+#define LIBXFS_ATTR_CREATE		ATTR_CREATE
+#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
+#define LIBXFS_ATTR_ROOT		ATTR_ROOT
+#define LIBXFS_ATTR_SECURE		ATTR_SECURE
 
+#define xfs_agfl_size			libxfs_agfl_size
 #define xfs_agfl_walk			libxfs_agfl_walk
+
+#define xfs_ag_init_headers		libxfs_ag_init_headers
+
+#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
+#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
-#define xfs_bmap_last_offset		libxfs_bmap_last_offset
-#define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
-#define xfs_bmapi_write			libxfs_bmapi_write
-#define xfs_bmapi_read			libxfs_bmapi_read
-#define xfs_bunmapi			libxfs_bunmapi
-#define xfs_rtfree_extent		libxfs_rtfree_extent
-#define xfs_verify_rtbno		libxfs_verify_rtbno
-#define xfs_verify_ino			libxfs_verify_ino
-#define xfs_zero_extent			libxfs_zero_extent
 
-#define xfs_defer_finish		libxfs_defer_finish
-#define xfs_defer_cancel		libxfs_defer_cancel
+#define xfs_attr_get			libxfs_attr_get
+#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
+#define xfs_attr_namecheck		libxfs_attr_namecheck
+#define xfs_attr_remove			libxfs_attr_remove
+#define xfs_attr_set			libxfs_attr_set
 
+#define xfs_bmapi_read			libxfs_bmapi_read
+#define xfs_bmapi_write			libxfs_bmapi_write
+#define xfs_bmap_last_offset		libxfs_bmap_last_offset
+#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
+#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
+
+#define xfs_btree_del_cursor		libxfs_btree_del_cursor
+#define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_bunmapi			libxfs_bunmapi
+#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
-#define xfs_da_shrink_inode		libxfs_da_shrink_inode
 #define xfs_da_read_buf			libxfs_da_read_buf
-#define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
-#define xfs_dir_createname		libxfs_dir_createname
-#define xfs_dir_init			libxfs_dir_init
-#define xfs_dir_lookup			libxfs_dir_lookup
-#define xfs_dir_replace			libxfs_dir_replace
+#define xfs_da_shrink_inode		libxfs_da_shrink_inode
+#define xfs_default_ifork_ops		libxfs_default_ifork_ops
+#define xfs_defer_cancel		libxfs_defer_cancel
+#define xfs_defer_finish		libxfs_defer_finish
+#define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
+#define xfs_dinode_good_version		libxfs_dinode_good_version
+#define xfs_dinode_verify		libxfs_dinode_verify
+
 #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
-#define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
-#define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
-#define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
-#define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
-#define xfs_dir2_isblock		libxfs_dir2_isblock
-#define xfs_dir2_isleaf			libxfs_dir2_isleaf
+#define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
+#define xfs_dir2_data_entsize		libxfs_dir2_data_entsize
 #define xfs_dir2_data_freescan		libxfs_dir2_data_freescan
+#define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
 #define xfs_dir2_data_log_entry		libxfs_dir2_data_log_entry
 #define xfs_dir2_data_log_header	libxfs_dir2_data_log_header
 #define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
+#define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
 #define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
-#define xfs_dir2_data_entsize		libxfs_dir2_data_entsize
-#define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
+#define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
 #define xfs_dir2_hashname		libxfs_dir2_hashname
-#define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
-#define xfs_dir2_sf_get_parent_ino	libxfs_dir2_sf_get_parent_ino
-#define xfs_dir2_sf_put_parent_ino	libxfs_dir2_sf_put_parent_ino
+#define xfs_dir2_isblock		libxfs_dir2_isblock
+#define xfs_dir2_isleaf			libxfs_dir2_isleaf
+#define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
+#define xfs_dir2_namecheck		libxfs_dir2_namecheck
 #define xfs_dir2_sf_entsize		libxfs_dir2_sf_entsize
-#define xfs_dir2_sf_nextentry		libxfs_dir2_sf_nextentry
 #define xfs_dir2_sf_get_ftype		libxfs_dir2_sf_get_ftype
-#define xfs_dir2_sf_put_ftype		libxfs_dir2_sf_put_ftype
 #define xfs_dir2_sf_get_ino		libxfs_dir2_sf_get_ino
+#define xfs_dir2_sf_get_parent_ino	libxfs_dir2_sf_get_parent_ino
+#define xfs_dir2_sf_nextentry		libxfs_dir2_sf_nextentry
+#define xfs_dir2_sf_put_ftype		libxfs_dir2_sf_put_ftype
 #define xfs_dir2_sf_put_ino		libxfs_dir2_sf_put_ino
-#define xfs_dir2_namecheck		libxfs_dir2_namecheck
-#define xfs_da_get_buf			libxfs_da_get_buf
-
-#define xfs_inode_from_disk		libxfs_inode_from_disk
-#define xfs_inode_to_disk		libxfs_inode_to_disk
-#define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
-#define xfs_idata_realloc		libxfs_idata_realloc
-#define xfs_idestroy_fork		libxfs_idestroy_fork
-#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
-#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
-
-#define xfs_rmap_alloc			libxfs_rmap_alloc
-#define xfs_rmap_query_range		libxfs_rmap_query_range
-#define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
-#define xfs_rmap_get_rec		libxfs_rmap_get_rec
-#define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
-#define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
-#define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
-#define xfs_btree_del_cursor		libxfs_btree_del_cursor
-#define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_dir2_sf_put_parent_ino	libxfs_dir2_sf_put_parent_ino
+#define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
 
-#define xfs_log_sb			libxfs_log_sb
-#define xfs_sb_from_disk		libxfs_sb_from_disk
-#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
-#define xfs_sb_to_disk			libxfs_sb_to_disk
+#define xfs_dir_createname		libxfs_dir_createname
+#define xfs_dir_init			libxfs_dir_init
+#define xfs_dir_ino_validate		libxfs_dir_ino_validate
+#define xfs_dir_lookup			libxfs_dir_lookup
+#define xfs_dir_replace			libxfs_dir_replace
 
-#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
-#define xfs_dquot_verify		libxfs_dquot_verify
 #define xfs_dqblk_repair		libxfs_dqblk_repair
+#define xfs_dquot_verify		libxfs_dquot_verify
 
-#define xfs_symlink_blocks		libxfs_symlink_blocks
-#define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
-
-#define xfs_verify_cksum		libxfs_verify_cksum
-#define xfs_dinode_verify		libxfs_dinode_verify
-
-#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
-#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
-#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
-#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
-#define xfs_btree_init_block		libxfs_btree_init_block
-#define xfs_dir_ino_validate		libxfs_dir_ino_validate
+#define xfs_free_extent			libxfs_free_extent
+#define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_highbit32			libxfs_highbit32
+#define xfs_highbit64			libxfs_highbit64
+#define xfs_idata_realloc		libxfs_idata_realloc
+#define xfs_idestroy_fork		libxfs_idestroy_fork
+#define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
+#define xfs_init_local_fork		libxfs_init_local_fork
+
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
-#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
-#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
+#define xfs_inode_from_disk		libxfs_inode_from_disk
+#define xfs_inode_to_disk		libxfs_inode_to_disk
+#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
+#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
+
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
+#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
+#define xfs_log_sb			libxfs_log_sb
+#define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
-#define xfs_dinode_good_version		libxfs_dinode_good_version
-#define xfs_free_extent			libxfs_free_extent
 
+#define xfs_refc_block			libxfs_refc_block
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
-#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
-#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
-#define xfs_agfl_size			libxfs_agfl_size
-#define xfs_refc_block			libxfs_refc_block
+#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+
+#define xfs_rmap_alloc			libxfs_rmap_alloc
+#define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
+#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
 #define xfs_rmap_compare		libxfs_rmap_compare
-#define xfs_default_ifork_ops		libxfs_default_ifork_ops
-#define xfs_fs_geometry			libxfs_fs_geometry
-#define xfs_init_local_fork		libxfs_init_local_fork
-#define xfs_attr_namecheck		libxfs_attr_namecheck
+#define xfs_rmap_get_rec		libxfs_rmap_get_rec
+#define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
+#define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
+#define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
+#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_query_range		libxfs_rmap_query_range
 
-#define LIBXFS_ATTR_ROOT		ATTR_ROOT
-#define LIBXFS_ATTR_SECURE		ATTR_SECURE
-#define LIBXFS_ATTR_CREATE		ATTR_CREATE
-#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
+#define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_sb_from_disk		libxfs_sb_from_disk
+#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
+#define xfs_sb_to_disk			libxfs_sb_to_disk
+#define xfs_symlink_blocks		libxfs_symlink_blocks
+#define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
 
-#define xfs_ag_init_headers		libxfs_ag_init_headers
-#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_trans_add_item		libxfs_trans_add_item
+#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
+#define xfs_trans_alloc			libxfs_trans_alloc
+#define xfs_trans_bhold			libxfs_trans_bhold
+#define xfs_trans_bhold_release		libxfs_trans_bhold_release
+#define xfs_trans_binval		libxfs_trans_binval
+#define xfs_trans_bjoin			libxfs_trans_bjoin
+#define xfs_trans_brelse		libxfs_trans_brelse
+#define xfs_trans_cancel		libxfs_trans_cancel
+#define xfs_trans_commit		libxfs_trans_commit
+#define xfs_trans_del_item		libxfs_trans_del_item
+#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
+#define xfs_trans_get_buf		libxfs_trans_get_buf
+#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
+#define xfs_trans_getsb			libxfs_trans_getsb
+#define xfs_trans_ichgtime		libxfs_trans_ichgtime
+#define xfs_trans_ijoin			libxfs_trans_ijoin
+#define xfs_trans_init			libxfs_trans_init
+#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
+#define xfs_trans_log_buf		libxfs_trans_log_buf
+#define xfs_trans_log_inode		libxfs_trans_log_inode
+#define xfs_trans_mod_sb		libxfs_trans_mod_sb
+#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
+#define xfs_trans_read_buf		libxfs_trans_read_buf
+#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
+#define xfs_trans_resv_calc		libxfs_trans_resv_calc
+#define xfs_trans_roll_inode		libxfs_trans_roll_inode
+#define xfs_trans_roll			libxfs_trans_roll
+
+#define xfs_verify_cksum		libxfs_verify_cksum
+#define xfs_verify_ino			libxfs_verify_ino
+#define xfs_verify_rtbno		libxfs_verify_rtbno
+#define xfs_zero_extent			libxfs_zero_extent
 
 #endif /* __LIBXFS_API_DEFS_H__ */

