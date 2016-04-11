Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBD197CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 09:14:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E7DB30404E
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 07:14:13 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com
	[209.85.161.182]) by cuda.sgi.com with ESMTP id
	ren0VlzM4H3dCtzx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2016 07:14:07 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id d68so210112914ywe.1
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 07:14:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Apr 2016 22:14:06 +0800
Message-ID: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
Subject: about the xfs performance
From: Songbo Wang <hack.coo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4349656936905688600=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4349656936905688600==
Content-Type: multipart/alternative; boundary=001a114272e45301b605303628a6

--001a114272e45301b605303628a6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi xfsers:

I got some troubles on the performance of  xfs.
The environment is ,
     xfs version is 3.2.1,
     centos 7.1,
     kernel version:3.10.0-229.el7.x86_64.
     pcie-ssd card,
     mkfs: mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D512 -d agcount=3D=
40 -l
size=3D1024m.
     mount: mount /dev/hioa2 /mnt/  -t xfs -o
rw,noexec,nodev,noatime,nodiratime,nobarrier,discard,inode64,logbsize=3D256=
k,delaylog
I use the following command to test iops: fio -ioengine=3Dlibaio -bs=3D4k
-direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/test -name=
=3D"EBS
4KB randwrite test" -iodepth=3D64 -runtime=3D60
The results is normal at the beginning which is about 210k=C2=B1=EF=BC=8Cbu=
t some
seconds later, the results down to 19k=C2=B1.

I did a senond test ,
     umount the /dev/hioa2,
     fio -ioengine=3Dlibaio -bs=3D4k -direct=3D1  -thread -rw=3Drandwrite
-filename=3D/dev/hioa2  -name=3D"EBS 8KB randwrite test" -iodepth=3D64 -run=
time=3D60
The results was normal, the iops is about 210k=C2=B1 all the time.

Then I use perf-tools to trace xfs:
     # ./funccount -i 1 'xfs*'

In the first test case , when the iops seems normal , the results is as
follows:
FUNC                              COUNT
xfs_free_eofblocks                    1
xfs_attr_get                          5
xfs_attr_get_int                      5
xfs_attr_name_to_xname                5
xfs_attr_shortform_getvalue           5
xfs_da_hashname                       5
xfs_ilock_attr_map_shared             5
xfs_xattr_get                         5
xfs_fs_statfs                         7
xfs_icsb_count                        7
xfs_icsb_sync_counters                7
xfs_icsb_sync_counters_locked         7
xfs_can_free_eofblocks                9
xfs_file_release                      9
xfs_release                           9
xfs_icsb_counter_disabled            21
xfs_file_open                        30
xfs_file_aio_read                    33
xfs_readlink                         37
xfs_vn_follow_link                   37
xfs_vn_put_link                      37
xfs_buf_delwri_submit_nowait         41
xfs_trans_ail_cursor_first           41
xfs_trans_ail_cursor_init            41
xfs_vn_getattr                       44
xfs_file_mmap                        48
xfs_cil_prepare_item.isra.1        1004
xfs_extent_busy_clear              1004
xfs_inode_item_committing          1004
xfs_inode_item_data_fork_size.     1004
xfs_inode_item_format              1004
xfs_inode_item_format_data_for     1004
xfs_inode_item_size                1004
xfs_inode_item_unlock              1004
xfs_log_calc_unit_res              1004
xfs_log_commit_cil                 1004
xfs_log_done                       1004
xfs_log_reserve                    1004
xfs_log_space_wake                 1004
xfs_log_ticket_put                 1004
xfs_trans_add_item                 1004
xfs_trans_alloc                    1004
xfs_trans_apply_dquot_deltas       1004
xfs_trans_commit                   1004
xfs_trans_free                     1004
xfs_trans_free_dqinfo              1004
xfs_trans_free_item_desc           1004
xfs_trans_free_items               1004
xfs_trans_ijoin                    1004
xfs_trans_log_inode                1004
xfs_trans_reserve                  1004
xfs_trans_unreserve_and_mod_sb     1004
xfs_vn_update_time                 1004
xfs_destroy_ioend                 84845
xfs_end_io_direct_write           84845
xfs_finish_ioend                  84845
xfs_file_aio_write                84880
xfs_file_dio_aio_write            84882
xfs_vm_direct_IO                  84882
xfs_get_blocks_direct             84883
xfs_bmapi_read                    84885
xfs_bmap_search_extents           84886
xfs_bmap_search_multi_extents     84886
xfs_iext_bno_to_ext               84887
xfs_iext_bno_to_irec              84887
xfs_iext_get_ext                  84890
xfs_iext_idx_to_irec              84890
xfs_ilock_data_map_shared         84891
xfs_map_buffer.isra.9             84892
xfs_file_aio_write_checks         84893
xfs_alloc_ioend                   84895
xfs_bmapi_trim_map.isra.11        84900
xfs_fsb_to_db                     84902
xfs_bmapi_update_map              84903
xfs_bmbt_get_all                 169793
xfs_find_bdev_for_inode          169794
xfs_ilock                        170868
xfs_iunlock                      170872
xfs_bmbt_get_blockcount          555016
xfs_bmbt_get_startoff           2277490

when the results down to 19k=C2=B1=EF=BC=8C the trace results are:
FUNC                              COUNT
xfs_bitmap_empty                      1
xfs_free_eofblocks                    1
xfs_attr_get                          5
xfs_attr_get_int                      5
xfs_attr_name_to_xname                5
xfs_attr_shortform_getvalue           5
xfs_da_hashname                       5
xfs_ilock_attr_map_shared             5
xfs_xattr_get                         5
xfs_fs_statfs                         7
xfs_icsb_count                        7
xfs_icsb_sync_counters                7
xfs_icsb_sync_counters_locked         7
xfs_can_free_eofblocks                9
xfs_file_release                      9
xfs_release                           9
xfs_file_open                        30
xfs_file_aio_read                    33
xfs_readlink                         37
xfs_vn_follow_link                   37
xfs_vn_put_link                      37
xfs_buf_delwri_submit_nowait         41
xfs_trans_ail_cursor_first           41
xfs_trans_ail_cursor_init            41
xfs_alloc_ag_vextent                 43
xfs_alloc_ag_vextent_near            43
xfs_alloc_find_best_extent           43
xfs_alloc_fix_freelist               43
xfs_alloc_fixup_trees                43
xfs_alloc_read_agf                   43
xfs_alloc_read_agfl                  43
xfs_alloc_update                     43
xfs_alloc_update_counters.isra       43
xfs_alloc_vextent                    43
xfs_bmbt_alloc_block                 43
xfs_btree_get_buf_block.constp       43
xfs_btree_reada_bufs                 43
xfs_btree_readahead_sblock.isr       43
xfs_btree_split                      43
xfs_btree_split_worker               43
xfs_read_agf                         43
xfs_trans_get_buf_map                43
xfs_allocbt_dup_cursor               44
xfs_allocbt_get_minrecs              44
xfs_allocbt_init_rec_from_cur        44
xfs_allocbt_update_lastrec           44
xfs_alloc_fix_minleft                44
xfs_alloc_log_agf                    44
xfs_alloc_longest_free_extent        44
xfs_bmbt_init_rec_from_key           44
xfs_bmbt_update_cursor               44
xfs_btree_buf_to_ptr.isra.17         44
xfs_btree_check_sblock               44
xfs_btree_init_block_cur.isra.       44
xfs_btree_init_block_int             44
xfs_btree_islastblock                44
xfs_trans_mod_dquot_byino            44
xfs_trans_mod_sb                     44
xfs_vn_getattr                       44
xfs_file_mmap                        48
xfs_iext_irec_new                    57
xfs_iext_realloc_indirect            57
xfs_btree_copy_ptrs                  66
xfs_btree_shift_keys.isra.23         66
xfs_btree_shift_ptrs                 66
xfs_btree_log_ptrs                   72
xfs_alloc_get_rec                    86
xfs_alloc_lookup_eq                  86
xfs_alloc_compute_aligned            88
xfs_btree_get_rec                    88
xfs_extent_busy_trim                 88
xfs_iext_add_indirect_multi         108
xfs_alloc_compute_diff              110
xfs_alloc_fix_len                   110
xfs_allocbt_init_cursor             132
xfs_iext_irec_compact               163
xfs_iext_remove                     163
xfs_iext_remove_indirect            163
xfs_buf_item_relse                  173
xfs_allocbt_init_ptr_from_cur       176
xfs_btree_set_sibling.isra.12       176
xfs_buf_item_free                   177
xfs_buf_item_free_format            177
xfs_buf_hold                        248
xfs_buf_item_get_format             248
xfs_log_item_init                   248
xfs_allocbt_get_maxrecs             264
xfs_bmbt_get_minrecs                326
xfs_btree_dec_cursor                369
xfs_btree_delete                    369
xfs_btree_delrec                    369
xfs_bmbt_set_allf                   633
xfs_bmbt_set_startblock            1007
xfs_bmbt_set_startoff              1007
xfs_trans_alloc                    1029
xfs_vn_update_time                 1029
xfs_btree_lshift                   1048
xfs_btree_decrement                1332
xfs_allocbt_init_key_from_rec      1481
xfs_allocbt_key_diff               2427
xfs_btree_check_lblock             3653
xfs_btree_lastrec                  3653
xfs_buf_free                       3660
xfs_bmbt_dup_cursor                3696
xfs_btree_check_block              3696
xfs_buf_allocate_memory            3703
xfs_btree_dup_cursor               3738
xfs_btree_increment                4324
xfs_btree_make_block_unfull        4699
xfs_btree_rshift                   4699
xfs_btree_updkey                   4738
xfs_btree_copy_keys.isra.22        4824
xfs_btree_log_keys                 4832
xfs_iext_add                       4876
xfs_iext_insert                    4876
xfs_btree_reada_bufl               5465
xfs_btree_readahead_lblock.isr     5465
xfs_buf_readahead_map              5508
xfs_btree_readahead                5670
xfs_inode_item_format              6071
xfs_inode_item_format_data_for     6072
xfs_inode_item_size                6072
xfs_inode_item_data_fork_size.     6073
xfs_trans_log_inode                6115
xfs_buf_item_pin                   6315
xfs_bmapi_write                    6674
xfs_end_io                         6674
xfs_iomap_write_unwritten          6674
xfs_bmap_add_extent_unwritten_     6675
xfs_bmapi_convert_unwritten        6675
xfs_destroy_ioend                  6675
xfs_end_io_direct_write            6676
xfs_finish_ioend                   6677
xfs_bmap_finish                    6683
xfs_file_aio_write                 6784
xfs_bmapi_read                     6785
xfs_file_aio_write_checks          6785
xfs_file_dio_aio_write             6785
xfs_get_blocks_direct              6785
xfs_ilock_data_map_shared          6785
xfs_map_buffer.isra.9              6785
xfs_vm_direct_IO                   6785
xfs_alloc_ioend                    6786
xfs_fsb_to_db                      6786
xfs_bmbt_set_blockcount            7691
xfs_log_commit_cil                 7704
xfs_trans_commit                   7704
xfs_trans_free_items               7704
xfs_trans_reserve                  7705
xfs_trans_unreserve_and_mod_sb     7705
xfs_log_done                       7706
xfs_trans_free                     7706
xfs_log_reserve                    7708
xfs_trans_ijoin                    7708
xfs_extent_busy_clear              7712
xfs_inode_item_unlock              7712
xfs_log_space_wake                 7712
xfs_log_ticket_put                 7712
xfs_trans_apply_dquot_deltas       7712
xfs_inode_item_committing          7713
xfs_log_calc_unit_res              7713
xfs_trans_free_dqinfo              7713
xfs_bmbt_update                    8311
xfs_btree_update                   8354
xfs_bmbt_init_rec_from_cur         9758
xfs_bmbt_disk_set_all              9760
xfs_bmbt_set_all                   9760
xfs_btree_insert                   9795
xfs_btree_insrec                   9838
xfs_bmbt_init_cursor              10379
xfs_btree_del_cursor              10498
xfs_trans_del_item                11101
xfs_buf_item_dirty                11109
xfs_bmbt_lookup_eq                11551
xfs_bmbt_init_ptr_from_cur        11563
xfs_btree_get_iroot.isra.8        11563
xfs_buf_item_format               11690
xfs_buf_item_size                 11690
xfs_buf_item_size_segment.isra    11690
xfs_btree_lookup                  11723
xfs_btree_get_sibling.isra.11     11974
xfs_buf_item_unlock               12229
xfs_buf_item_committing           12237
xfs_icsb_modify_counters          13351
xfs_icsb_lock_cntr                13365
xfs_icsb_unlock_cntr              13365
xfs_iext_bno_to_irec              13458
xfs_bmap_search_extents           13459
xfs_bmap_search_multi_extents     13459
xfs_iext_bno_to_ext               13459
xfs_bmapi_trim_map.isra.11        13469
xfs_bmapi_update_map              13469
xfs_find_bdev_for_inode           13573
xfs_btree_shift_recs.isra.24      14798
xfs_cil_prepare_item.isra.1       17769
xfs_bmbt_disk_set_allf            18126
xfs_btree_is_lastrec              18581
xfs_btree_log_block               19648
xfs_btree_set_ptr_null.isra.10    19649
xfs_btree_offsets                 19703
xfs_iunlock                       21348
xfs_ilock                         21349
xfs_btree_copy_recs.isra.21       22849
xfs_buf_item_init                 23331
xfs_buf_unlock                    23345
xfs_btree_setbuf                  23948
xfs_btree_log_recs                24190
xfs_icsb_counter_disabled         26751
xfs_buf_read_map                  28786
xfs_buf_get_map                   28829
xfs_btree_ptr_is_null.isra.9      29274
xfs_btree_read_buf_block.isra.    29684
xfs_btree_set_refs.isra.13        29712
xfs_trans_add_item                31037
xfs_trans_free_item_desc          31052
xfs_buf_trylock                   32463
xfs_perag_put                     32606
xfs_perag_get                     32633
xfs_buf_rele                      32693
xfs_trans_brelse                  35148
xfs_btree_ptr_addr                38591
xfs_btree_ptr_offset              38738
xfs_trans_read_buf_map            40938
xfs_trans_buf_item_match          41000
xfs_btree_ptr_to_daddr            44562
xfs_btree_lookup_get_block        46548
xfs_trans_log_buf                 48783
xfs_buf_item_log                  48806
xfs_trans_buf_set_type            48815
xfs_iext_get_ext                  51712
xfs_bmbt_get_all                  53669
xfs_btree_get_block               54424
xfs_iext_idx_to_irec              56768
xfs_bmbt_get_maxrecs              57774
xfs_bmbt_get_blockcount           89650
xfs_bmbt_disk_get_startoff        98285
xfs_bmbt_init_key_from_rec        98285
xfs_btree_rec_addr               115199
xfs_btree_rec_offset             163635
xfs_btree_key_addr               176837
xfs_btree_key_offset             186525
xfs_bmbt_key_diff                254763
xfs_lookup_get_search_key        257190
xfs_bmbt_get_startoff            363158
xfs_next_bit                     631334
xfs_buf_offset                  1166477


Compare with the two results above, I found  when the iops down to 19k=C2=
=B1,
lots of functions were traced, such
as xfs_buf_trylock, xfs_iext_insert, xfs_btree_insert, etc.

I cannot find what cause the iops down to 19k=C2=B1, any suggestion ?

--001a114272e45301b605303628a6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SGkgeGZzZXJzOjxkaXY+PGJyPjwvZGl2PjxkaXY+SSBnb3Qgc29tZSB0
cm91YmxlcyBvbiB0aGUgcGVyZm9ybWFuY2Ugb2YgwqB4ZnMuwqA8ZGl2PlRoZSBlbnZpcm9ubWVu
dCBpcyAswqA8L2Rpdj48ZGl2PsKgIMKgIMKgeGZzIHZlcnNpb24gaXMgMy4yLjEswqA8L2Rpdj48
ZGl2PsKgIMKgIMKgY2VudG9zIDcuMSzCoDwvZGl2PjxkaXY+wqAgwqAgwqBrZXJuZWwgdmVyc2lv
bjozLjEwLjAtMjI5LmVsNy54ODZfNjQuPC9kaXY+PGRpdj7CoCDCoCDCoHBjaWUtc3NkIGNhcmQs
wqA8L2Rpdj48ZGl2PsKgIMKgIMKgbWtmczogbWtmcy54ZnMgL2Rldi9oaW9hMiAtZiAtbiBzaXpl
PTY0ayAtaSBzaXplPTUxMiAtZCBhZ2NvdW50PTQwIC1sIHNpemU9MTAyNG0uPC9kaXY+PC9kaXY+
PGRpdj7CoCDCoCDCoG1vdW50OsKgbW91bnQgL2Rldi9oaW9hMiAvbW50LyDCoC10IHhmcyAtbyBy
dyxub2V4ZWMsbm9kZXYsbm9hdGltZSxub2RpcmF0aW1lLG5vYmFycmllcixkaXNjYXJkLGlub2Rl
NjQsbG9nYnNpemU9MjU2ayxkZWxheWxvZzwvZGl2PjxkaXY+SSB1c2UgdGhlIGZvbGxvd2luZyBj
b21tYW5kIHRvIHRlc3QgaW9wczrCoGZpbyAtaW9lbmdpbmU9bGliYWlvIC1icz00ayAtZGlyZWN0
PTEgLXRocmVhZCAtcnc9cmFuZHdyaXRlIC1zaXplPTUwRyAtZmlsZW5hbWU9L21udC90ZXN0IC1u
YW1lPSZxdW90O0VCUyA0S0IgcmFuZHdyaXRlIHRlc3QmcXVvdDsgLWlvZGVwdGg9NjQgLXJ1bnRp
bWU9NjA8L2Rpdj48ZGl2PlRoZSByZXN1bHRzIGlzIG5vcm1hbCBhdCB0aGUgYmVnaW5uaW5nIHdo
aWNoIGlzIGFib3V0IDIxMGvCse+8jGJ1dCBzb21lIHNlY29uZHMgbGF0ZXIsIHRoZSByZXN1bHRz
IGRvd24gdG8gMTlrwrEuPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5JIGRpZCBhIHNlbm9uZCB0
ZXN0ICzCoDwvZGl2PjxkaXY+wqAgwqAgwqB1bW91bnQgdGhlIC9kZXYvaGlvYTIswqA8L2Rpdj48
ZGl2PsKgIMKgIMKgZmlvIC1pb2VuZ2luZT1saWJhaW8gLWJzPTRrIC1kaXJlY3Q9MSDCoC10aHJl
YWQgLXJ3PXJhbmR3cml0ZSAtZmlsZW5hbWU9L2Rldi9oaW9hMiDCoC1uYW1lPSZxdW90O0VCUyA4
S0IgcmFuZHdyaXRlIHRlc3QmcXVvdDsgLWlvZGVwdGg9NjQgLXJ1bnRpbWU9NjA8L2Rpdj48ZGl2
PlRoZSByZXN1bHRzIHdhcyBub3JtYWwsIHRoZSBpb3BzIGlzIGFib3V0IDIxMGvCsSBhbGwgdGhl
IHRpbWUuPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5UaGVuIEkgdXNlIHBlcmYtdG9vbHMgdG8g
dHJhY2UgeGZzOjwvZGl2PjxkaXY+wqAgwqAgwqAjIC4vZnVuY2NvdW50IC1pIDEgJiMzOTt4ZnMq
JiMzOTs8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkluIHRoZSBmaXJzdCB0ZXN0IGNhc2UgLCB3
aGVuIHRoZSBpb3BzIHNlZW1zIG5vcm1hbCAsIHRoZSByZXN1bHRzIGlzIGFzIGZvbGxvd3M6PC9k
aXY+PGRpdj48ZGl2PjxkaXY+PGRpdj5GVU5DIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgQ09VTlQ8L2Rpdj48ZGl2Pnhmc19mcmVlX2VvZmJsb2NrcyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDE8L2Rpdj48ZGl2Pnhmc19hdHRyX2dldCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDU8L2Rpdj48ZGl2Pnhmc19hdHRyX2dldF9pbnQg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA1PC9kaXY+PGRpdj54ZnNfYXR0cl9uYW1l
X3RvX3huYW1lIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNTwvZGl2PjxkaXY+eGZzX2F0dHJfc2hv
cnRmb3JtX2dldHZhbHVlIMKgIMKgIMKgIMKgIMKgIDU8L2Rpdj48ZGl2Pnhmc19kYV9oYXNobmFt
ZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA1PC9kaXY+PGRpdj54ZnNfaWxvY2tf
YXR0cl9tYXBfc2hhcmVkIMKgIMKgIMKgIMKgIMKgIMKgIDU8L2Rpdj48ZGl2Pnhmc194YXR0cl9n
ZXQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNTwvZGl2PjxkaXY+eGZzX2Zz
X3N0YXRmcyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA3PC9kaXY+PGRpdj54
ZnNfaWNzYl9jb3VudCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDc8L2Rpdj48
ZGl2Pnhmc19pY3NiX3N5bmNfY291bnRlcnMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA3PC9kaXY+
PGRpdj54ZnNfaWNzYl9zeW5jX2NvdW50ZXJzX2xvY2tlZCDCoCDCoCDCoCDCoCA3PC9kaXY+PGRp
dj54ZnNfY2FuX2ZyZWVfZW9mYmxvY2tzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgOTwvZGl2Pjxk
aXY+eGZzX2ZpbGVfcmVsZWFzZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDk8L2Rp
dj48ZGl2Pnhmc19yZWxlYXNlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IDk8L2Rpdj48ZGl2Pnhmc19pY3NiX2NvdW50ZXJfZGlzYWJsZWQgwqAgwqAgwqAgwqAgwqAgwqAy
MTwvZGl2PjxkaXY+eGZzX2ZpbGVfb3BlbiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoDMwPC9kaXY+PGRpdj54ZnNfZmlsZV9haW9fcmVhZCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoDMzPC9kaXY+PGRpdj54ZnNfcmVhZGxpbmsgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgMzc8L2Rpdj48ZGl2Pnhmc192bl9mb2xsb3dfbGluayDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAzNzwvZGl2PjxkaXY+eGZzX3ZuX3B1dF9saW5rIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgMzc8L2Rpdj48ZGl2Pnhmc19idWZfZGVsd3JpX3N1Ym1pdF9ub3dh
aXQgwqAgwqAgwqAgwqAgNDE8L2Rpdj48ZGl2Pnhmc190cmFuc19haWxfY3Vyc29yX2ZpcnN0IMKg
IMKgIMKgIMKgIMKgIDQxPC9kaXY+PGRpdj54ZnNfdHJhbnNfYWlsX2N1cnNvcl9pbml0IMKgIMKg
IMKgIMKgIMKgIMKgNDE8L2Rpdj48ZGl2Pnhmc192bl9nZXRhdHRyIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfZmlsZV9tbWFwIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgNDg8L2Rpdj48ZGl2Pnhmc19jaWxfcHJlcGFyZV9pdGVtLmlz
cmEuMSDCoCDCoCDCoCDCoDEwMDQ8L2Rpdj48ZGl2Pnhmc19leHRlbnRfYnVzeV9jbGVhciDCoCDC
oCDCoCDCoCDCoCDCoCDCoDEwMDQ8L2Rpdj48ZGl2Pnhmc19pbm9kZV9pdGVtX2NvbW1pdHRpbmcg
wqAgwqAgwqAgwqAgwqAxMDA0PC9kaXY+PGRpdj54ZnNfaW5vZGVfaXRlbV9kYXRhX2Zvcmtfc2l6
ZS4gwqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX2lub2RlX2l0ZW1fZm9ybWF0IMKgIMKgIMKgIMKg
IMKgIMKgIMKgMTAwNDwvZGl2PjxkaXY+eGZzX2lub2RlX2l0ZW1fZm9ybWF0X2RhdGFfZm9yIMKg
IMKgIDEwMDQ8L2Rpdj48ZGl2Pnhmc19pbm9kZV9pdGVtX3NpemUgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAxMDA0PC9kaXY+PGRpdj54ZnNfaW5vZGVfaXRlbV91bmxvY2sgwqAgwqAgwqAgwqAgwqAg
wqAgwqAxMDA0PC9kaXY+PGRpdj54ZnNfbG9nX2NhbGNfdW5pdF9yZXMgwqAgwqAgwqAgwqAgwqAg
wqAgwqAxMDA0PC9kaXY+PGRpdj54ZnNfbG9nX2NvbW1pdF9jaWwgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX2xvZ19kb25lIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIDEwMDQ8L2Rpdj48ZGl2Pnhmc19sb2dfcmVzZXJ2ZSDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoDEwMDQ8L2Rpdj48ZGl2Pnhmc19sb2dfc3BhY2Vfd2FrZSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAxMDA0PC9kaXY+PGRpdj54ZnNfbG9nX3RpY2tldF9wdXQgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX2FkZF9pdGVtIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIDEwMDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19hbGxvYyDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoDEwMDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19hcHBseV9kcXVvdF9k
ZWx0YXMgwqAgwqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX2NvbW1pdCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAxMDA0PC9kaXY+PGRpdj54ZnNfdHJhbnNfZnJlZSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAxMDA0PC9kaXY+PGRpdj54ZnNfdHJhbnNfZnJlZV9kcWluZm8g
wqAgwqAgwqAgwqAgwqAgwqAgwqAxMDA0PC9kaXY+PGRpdj54ZnNfdHJhbnNfZnJlZV9pdGVtX2Rl
c2MgwqAgwqAgwqAgwqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX2ZyZWVfaXRlbXMgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX2lqb2luIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX2xvZ19pbm9kZSDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDEwMDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19yZXNlcnZlIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMTAwNDwvZGl2PjxkaXY+eGZzX3RyYW5zX3VucmVzZXJ2
ZV9hbmRfbW9kX3NiIMKgIMKgIDEwMDQ8L2Rpdj48ZGl2Pnhmc192bl91cGRhdGVfdGltZSDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAxMDA0PC9kaXY+PGRpdj54ZnNfZGVzdHJveV9pb2VuZCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCA4NDg0NTwvZGl2PjxkaXY+eGZzX2VuZF9pb19kaXJlY3Rfd3Jp
dGUgwqAgwqAgwqAgwqAgwqAgODQ4NDU8L2Rpdj48ZGl2Pnhmc19maW5pc2hfaW9lbmQgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqA4NDg0NTwvZGl2PjxkaXY+eGZzX2ZpbGVfYWlvX3dyaXRlIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgODQ4ODA8L2Rpdj48ZGl2Pnhmc19maWxlX2Rpb19haW9fd3Jp
dGUgwqAgwqAgwqAgwqAgwqAgwqA4NDg4MjwvZGl2PjxkaXY+eGZzX3ZtX2RpcmVjdF9JTyDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDg0ODgyPC9kaXY+PGRpdj54ZnNfZ2V0X2Jsb2Nrc19kaXJl
Y3QgwqAgwqAgwqAgwqAgwqAgwqAgODQ4ODM8L2Rpdj48ZGl2Pnhmc19ibWFwaV9yZWFkIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgODQ4ODU8L2Rpdj48ZGl2Pnhmc19ibWFwX3NlYXJjaF9l
eHRlbnRzIMKgIMKgIMKgIMKgIMKgIDg0ODg2PC9kaXY+PGRpdj54ZnNfYm1hcF9zZWFyY2hfbXVs
dGlfZXh0ZW50cyDCoCDCoCA4NDg4NjwvZGl2PjxkaXY+eGZzX2lleHRfYm5vX3RvX2V4dCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCA4NDg4NzwvZGl2PjxkaXY+eGZzX2lleHRfYm5vX3RvX2lyZWMgwqAg
wqAgwqAgwqAgwqAgwqAgwqA4NDg4NzwvZGl2PjxkaXY+eGZzX2lleHRfZ2V0X2V4dCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoDg0ODkwPC9kaXY+PGRpdj54ZnNfaWV4dF9pZHhfdG9faXJlYyDC
oCDCoCDCoCDCoCDCoCDCoCDCoDg0ODkwPC9kaXY+PGRpdj54ZnNfaWxvY2tfZGF0YV9tYXBfc2hh
cmVkIMKgIMKgIMKgIMKgIDg0ODkxPC9kaXY+PGRpdj54ZnNfbWFwX2J1ZmZlci5pc3JhLjkgwqAg
wqAgwqAgwqAgwqAgwqAgODQ4OTI8L2Rpdj48ZGl2Pnhmc19maWxlX2Fpb193cml0ZV9jaGVja3Mg
wqAgwqAgwqAgwqAgODQ4OTM8L2Rpdj48ZGl2Pnhmc19hbGxvY19pb2VuZCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCA4NDg5NTwvZGl2PjxkaXY+eGZzX2JtYXBpX3RyaW1fbWFwLmlzcmEuMTEg
wqAgwqAgwqAgwqA4NDkwMDwvZGl2PjxkaXY+eGZzX2ZzYl90b19kYiDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCA4NDkwMjwvZGl2PjxkaXY+eGZzX2JtYXBpX3VwZGF0ZV9tYXAgwqAgwqAg
wqAgwqAgwqAgwqAgwqA4NDkwMzwvZGl2PjxkaXY+eGZzX2JtYnRfZ2V0X2FsbCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAxNjk3OTM8L2Rpdj48ZGl2Pnhmc19maW5kX2JkZXZfZm9yX2lub2RlIMKg
IMKgIMKgIMKgIMKgMTY5Nzk0PC9kaXY+PGRpdj54ZnNfaWxvY2sgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAxNzA4Njg8L2Rpdj48ZGl2Pnhmc19pdW5sb2NrIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgMTcwODcyPC9kaXY+PGRpdj54ZnNfYm1idF9nZXRfYmxvY2tj
b3VudCDCoCDCoCDCoCDCoCDCoDU1NTAxNjwvZGl2PjxkaXY+eGZzX2JtYnRfZ2V0X3N0YXJ0b2Zm
IMKgIMKgIMKgIMKgIMKgIDIyNzc0OTA8L2Rpdj48L2Rpdj48L2Rpdj48L2Rpdj48ZGl2Pjxicj48
L2Rpdj48ZGl2PndoZW4gdGhlIHJlc3VsdHMgZG93biB0byAxOWvCse+8jCB0aGUgdHJhY2UgcmVz
dWx0cyBhcmU6PC9kaXY+PGRpdj48ZGl2PkZVTkMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBDT1VOVDwvZGl2PjxkaXY+eGZzX2JpdG1hcF9lbXB0eSDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDE8L2Rpdj48ZGl2Pnhmc19mcmVlX2VvZmJsb2NrcyDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDE8L2Rpdj48ZGl2Pnhmc19hdHRyX2dldCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDU8L2Rpdj48ZGl2Pnhmc19hdHRyX2dl
dF9pbnQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA1PC9kaXY+PGRpdj54ZnNfYXR0
cl9uYW1lX3RvX3huYW1lIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNTwvZGl2PjxkaXY+eGZzX2F0
dHJfc2hvcnRmb3JtX2dldHZhbHVlIMKgIMKgIMKgIMKgIMKgIDU8L2Rpdj48ZGl2Pnhmc19kYV9o
YXNobmFtZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA1PC9kaXY+PGRpdj54ZnNf
aWxvY2tfYXR0cl9tYXBfc2hhcmVkIMKgIMKgIMKgIMKgIMKgIMKgIDU8L2Rpdj48ZGl2Pnhmc194
YXR0cl9nZXQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNTwvZGl2PjxkaXY+
eGZzX2ZzX3N0YXRmcyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA3PC9kaXY+
PGRpdj54ZnNfaWNzYl9jb3VudCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDc8
L2Rpdj48ZGl2Pnhmc19pY3NiX3N5bmNfY291bnRlcnMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA3
PC9kaXY+PGRpdj54ZnNfaWNzYl9zeW5jX2NvdW50ZXJzX2xvY2tlZCDCoCDCoCDCoCDCoCA3PC9k
aXY+PGRpdj54ZnNfY2FuX2ZyZWVfZW9mYmxvY2tzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgOTwv
ZGl2PjxkaXY+eGZzX2ZpbGVfcmVsZWFzZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oDk8L2Rpdj48ZGl2Pnhmc19yZWxlYXNlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIDk8L2Rpdj48ZGl2Pnhmc19maWxlX29wZW4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAzMDwvZGl2PjxkaXY+eGZzX2ZpbGVfYWlvX3JlYWQgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAzMzwvZGl2PjxkaXY+eGZzX3JlYWRsaW5rIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIDM3PC9kaXY+PGRpdj54ZnNfdm5fZm9sbG93X2xpbmsgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgMzc8L2Rpdj48ZGl2Pnhmc192bl9wdXRfbGluayDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDM3PC9kaXY+PGRpdj54ZnNfYnVmX2RlbHdyaV9zdWJt
aXRfbm93YWl0IMKgIMKgIMKgIMKgIDQxPC9kaXY+PGRpdj54ZnNfdHJhbnNfYWlsX2N1cnNvcl9m
aXJzdCDCoCDCoCDCoCDCoCDCoCA0MTwvZGl2PjxkaXY+eGZzX3RyYW5zX2FpbF9jdXJzb3JfaW5p
dCDCoCDCoCDCoCDCoCDCoCDCoDQxPC9kaXY+PGRpdj54ZnNfYWxsb2NfYWdfdmV4dGVudCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCA0MzwvZGl2PjxkaXY+eGZzX2FsbG9jX2FnX3ZleHRlbnRfbmVh
ciDCoCDCoCDCoCDCoCDCoCDCoDQzPC9kaXY+PGRpdj54ZnNfYWxsb2NfZmluZF9iZXN0X2V4dGVu
dCDCoCDCoCDCoCDCoCDCoCA0MzwvZGl2PjxkaXY+eGZzX2FsbG9jX2ZpeF9mcmVlbGlzdCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCA0MzwvZGl2PjxkaXY+eGZzX2FsbG9jX2ZpeHVwX3RyZWVzIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgNDM8L2Rpdj48ZGl2Pnhmc19hbGxvY19yZWFkX2FnZiDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCA0MzwvZGl2PjxkaXY+eGZzX2FsbG9jX3JlYWRfYWdmbCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDQzPC9kaXY+PGRpdj54ZnNfYWxsb2NfdXBkYXRlIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQzPC9kaXY+PGRpdj54ZnNfYWxsb2NfdXBkYXRlX2Nv
dW50ZXJzLmlzcmEgwqAgwqAgwqAgNDM8L2Rpdj48ZGl2Pnhmc19hbGxvY192ZXh0ZW50IMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNDM8L2Rpdj48ZGl2Pnhmc19ibWJ0X2FsbG9jX2Jsb2Nr
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQzPC9kaXY+PGRpdj54ZnNfYnRyZWVfZ2V0X2J1Zl9i
bG9jay5jb25zdHAgwqAgwqAgwqAgNDM8L2Rpdj48ZGl2Pnhmc19idHJlZV9yZWFkYV9idWZzIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQzPC9kaXY+PGRpdj54ZnNfYnRyZWVfcmVhZGFoZWFkX3Ni
bG9jay5pc3IgwqAgwqAgwqAgNDM8L2Rpdj48ZGl2Pnhmc19idHJlZV9zcGxpdCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDQzPC9kaXY+PGRpdj54ZnNfYnRyZWVfc3BsaXRfd29ya2Vy
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQzPC9kaXY+PGRpdj54ZnNfcmVhZF9hZ2YgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNDM8L2Rpdj48ZGl2Pnhmc190cmFuc19nZXRfYnVm
X21hcCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDQzPC9kaXY+PGRpdj54ZnNfYWxsb2NidF9kdXBf
Y3Vyc29yIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfYWxsb2NidF9nZXRf
bWlucmVjcyDCoCDCoCDCoCDCoCDCoCDCoCDCoDQ0PC9kaXY+PGRpdj54ZnNfYWxsb2NidF9pbml0
X3JlY19mcm9tX2N1ciDCoCDCoCDCoCDCoDQ0PC9kaXY+PGRpdj54ZnNfYWxsb2NidF91cGRhdGVf
bGFzdHJlYyDCoCDCoCDCoCDCoCDCoCA0NDwvZGl2PjxkaXY+eGZzX2FsbG9jX2ZpeF9taW5sZWZ0
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNDQ8L2Rpdj48ZGl2Pnhmc19hbGxvY19sb2dfYWdmIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNDQ8L2Rpdj48ZGl2Pnhmc19hbGxvY19sb25nZXN0
X2ZyZWVfZXh0ZW50IMKgIMKgIMKgIMKgNDQ8L2Rpdj48ZGl2Pnhmc19ibWJ0X2luaXRfcmVjX2Zy
b21fa2V5IMKgIMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfYm1idF91cGRhdGVfY3Vyc29y
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfYnRyZWVfYnVmX3RvX3B0ci5p
c3JhLjE3IMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfYnRyZWVfY2hlY2tfc2Jsb2NrIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIDQ0PC9kaXY+PGRpdj54ZnNfYnRyZWVfaW5pdF9ibG9ja19jdXIu
aXNyYS4gwqAgwqAgwqAgNDQ8L2Rpdj48ZGl2Pnhmc19idHJlZV9pbml0X2Jsb2NrX2ludCDCoCDC
oCDCoCDCoCDCoCDCoCA0NDwvZGl2PjxkaXY+eGZzX2J0cmVlX2lzbGFzdGJsb2NrIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgNDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19tb2RfZHF1b3RfYnlpbm8gwqAg
wqAgwqAgwqAgwqAgwqA0NDwvZGl2PjxkaXY+eGZzX3RyYW5zX21vZF9zYiDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCA0NDwvZGl2PjxkaXY+eGZzX3ZuX2dldGF0dHIgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgNDQ8L2Rpdj48ZGl2Pnhmc19maWxlX21tYXAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA0ODwvZGl2PjxkaXY+eGZzX2lleHRfaXJlY19uZXcg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA1NzwvZGl2PjxkaXY+eGZzX2lleHRfcmVhbGxv
Y19pbmRpcmVjdCDCoCDCoCDCoCDCoCDCoCDCoDU3PC9kaXY+PGRpdj54ZnNfYnRyZWVfY29weV9w
dHJzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNjY8L2Rpdj48ZGl2Pnhmc19idHJlZV9zaGlm
dF9rZXlzLmlzcmEuMjMgwqAgwqAgwqAgwqAgNjY8L2Rpdj48ZGl2Pnhmc19idHJlZV9zaGlmdF9w
dHJzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDY2PC9kaXY+PGRpdj54ZnNfYnRyZWVfbG9nX3B0
cnMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzI8L2Rpdj48ZGl2Pnhmc19hbGxvY19nZXRf
cmVjIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgODY8L2Rpdj48ZGl2Pnhmc19hbGxvY19s
b29rdXBfZXEgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA4NjwvZGl2PjxkaXY+eGZzX2FsbG9j
X2NvbXB1dGVfYWxpZ25lZCDCoCDCoCDCoCDCoCDCoCDCoDg4PC9kaXY+PGRpdj54ZnNfYnRyZWVf
Z2V0X3JlYyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDg4PC9kaXY+PGRpdj54ZnNfZXh0
ZW50X2J1c3lfdHJpbSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA4ODwvZGl2PjxkaXY+eGZzX2ll
eHRfYWRkX2luZGlyZWN0X211bHRpIMKgIMKgIMKgIMKgIDEwODwvZGl2PjxkaXY+eGZzX2FsbG9j
X2NvbXB1dGVfZGlmZiDCoCDCoCDCoCDCoCDCoCDCoCDCoDExMDwvZGl2PjxkaXY+eGZzX2FsbG9j
X2ZpeF9sZW4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMTEwPC9kaXY+PGRpdj54ZnNfYWxs
b2NidF9pbml0X2N1cnNvciDCoCDCoCDCoCDCoCDCoCDCoCAxMzI8L2Rpdj48ZGl2Pnhmc19pZXh0
X2lyZWNfY29tcGFjdCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAxNjM8L2Rpdj48ZGl2Pnhmc19pZXh0
X3JlbW92ZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAxNjM8L2Rpdj48ZGl2Pnhmc19p
ZXh0X3JlbW92ZV9pbmRpcmVjdCDCoCDCoCDCoCDCoCDCoCDCoDE2MzwvZGl2PjxkaXY+eGZzX2J1
Zl9pdGVtX3JlbHNlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMTczPC9kaXY+PGRpdj54ZnNf
YWxsb2NidF9pbml0X3B0cl9mcm9tX2N1ciDCoCDCoCDCoCAxNzY8L2Rpdj48ZGl2Pnhmc19idHJl
ZV9zZXRfc2libGluZy5pc3JhLjEyIMKgIMKgIMKgIDE3NjwvZGl2PjxkaXY+eGZzX2J1Zl9pdGVt
X2ZyZWUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMTc3PC9kaXY+PGRpdj54ZnNfYnVmX2l0
ZW1fZnJlZV9mb3JtYXQgwqAgwqAgwqAgwqAgwqAgwqAxNzc8L2Rpdj48ZGl2Pnhmc19idWZfaG9s
ZCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDI0ODwvZGl2PjxkaXY+eGZzX2J1
Zl9pdGVtX2dldF9mb3JtYXQgwqAgwqAgwqAgwqAgwqAgwqAgMjQ4PC9kaXY+PGRpdj54ZnNfbG9n
X2l0ZW1faW5pdCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAyNDg8L2Rpdj48ZGl2Pnhmc19h
bGxvY2J0X2dldF9tYXhyZWNzIMKgIMKgIMKgIMKgIMKgIMKgIDI2NDwvZGl2PjxkaXY+eGZzX2Jt
YnRfZ2V0X21pbnJlY3MgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAzMjY8L2Rpdj48ZGl2Pnhmc19i
dHJlZV9kZWNfY3Vyc29yIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzY5PC9kaXY+PGRpdj54ZnNf
YnRyZWVfZGVsZXRlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzY5PC9kaXY+PGRpdj54
ZnNfYnRyZWVfZGVscmVjIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzY5PC9kaXY+PGRp
dj54ZnNfYm1idF9zZXRfYWxsZiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA2MzM8L2Rpdj48
ZGl2Pnhmc19ibWJ0X3NldF9zdGFydGJsb2NrIMKgIMKgIMKgIMKgIMKgIMKgMTAwNzwvZGl2Pjxk
aXY+eGZzX2JtYnRfc2V0X3N0YXJ0b2ZmIMKgIMKgIMKgIMKgIMKgIMKgIMKgMTAwNzwvZGl2Pjxk
aXY+eGZzX3RyYW5zX2FsbG9jIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMTAyOTwvZGl2
PjxkaXY+eGZzX3ZuX3VwZGF0ZV90aW1lIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDEwMjk8L2Rp
dj48ZGl2Pnhmc19idHJlZV9sc2hpZnQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMTA0ODwv
ZGl2PjxkaXY+eGZzX2J0cmVlX2RlY3JlbWVudCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDEzMzI8
L2Rpdj48ZGl2Pnhmc19hbGxvY2J0X2luaXRfa2V5X2Zyb21fcmVjIMKgIMKgIMKgMTQ4MTwvZGl2
PjxkaXY+eGZzX2FsbG9jYnRfa2V5X2RpZmYgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMjQyNzwvZGl2
PjxkaXY+eGZzX2J0cmVlX2NoZWNrX2xibG9jayDCoCDCoCDCoCDCoCDCoCDCoCAzNjUzPC9kaXY+
PGRpdj54ZnNfYnRyZWVfbGFzdHJlYyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDM2NTM8L2Rp
dj48ZGl2Pnhmc19idWZfZnJlZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAzNjYw
PC9kaXY+PGRpdj54ZnNfYm1idF9kdXBfY3Vyc29yIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzY5
NjwvZGl2PjxkaXY+eGZzX2J0cmVlX2NoZWNrX2Jsb2NrIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzY5
NjwvZGl2PjxkaXY+eGZzX2J1Zl9hbGxvY2F0ZV9tZW1vcnkgwqAgwqAgwqAgwqAgwqAgwqAzNzAz
PC9kaXY+PGRpdj54ZnNfYnRyZWVfZHVwX2N1cnNvciDCoCDCoCDCoCDCoCDCoCDCoCDCoCAzNzM4
PC9kaXY+PGRpdj54ZnNfYnRyZWVfaW5jcmVtZW50IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNDMy
NDwvZGl2PjxkaXY+eGZzX2J0cmVlX21ha2VfYmxvY2tfdW5mdWxsIMKgIMKgIMKgIMKgNDY5OTwv
ZGl2PjxkaXY+eGZzX2J0cmVlX3JzaGlmdCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA0Njk5
PC9kaXY+PGRpdj54ZnNfYnRyZWVfdXBka2V5IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDQ3
Mzg8L2Rpdj48ZGl2Pnhmc19idHJlZV9jb3B5X2tleXMuaXNyYS4yMiDCoCDCoCDCoCDCoDQ4MjQ8
L2Rpdj48ZGl2Pnhmc19idHJlZV9sb2dfa2V5cyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA0ODMy
PC9kaXY+PGRpdj54ZnNfaWV4dF9hZGQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
NDg3NjwvZGl2PjxkaXY+eGZzX2lleHRfaW5zZXJ0IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgNDg3NjwvZGl2PjxkaXY+eGZzX2J0cmVlX3JlYWRhX2J1ZmwgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgNTQ2NTwvZGl2PjxkaXY+eGZzX2J0cmVlX3JlYWRhaGVhZF9sYmxvY2suaXNyIMKgIMKgIDU0
NjU8L2Rpdj48ZGl2Pnhmc19idWZfcmVhZGFoZWFkX21hcCDCoCDCoCDCoCDCoCDCoCDCoCDCoDU1
MDg8L2Rpdj48ZGl2Pnhmc19idHJlZV9yZWFkYWhlYWQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA1
NjcwPC9kaXY+PGRpdj54ZnNfaW5vZGVfaXRlbV9mb3JtYXQgwqAgwqAgwqAgwqAgwqAgwqAgwqA2
MDcxPC9kaXY+PGRpdj54ZnNfaW5vZGVfaXRlbV9mb3JtYXRfZGF0YV9mb3IgwqAgwqAgNjA3Mjwv
ZGl2PjxkaXY+eGZzX2lub2RlX2l0ZW1fc2l6ZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDYwNzI8
L2Rpdj48ZGl2Pnhmc19pbm9kZV9pdGVtX2RhdGFfZm9ya19zaXplLiDCoCDCoCA2MDczPC9kaXY+
PGRpdj54ZnNfdHJhbnNfbG9nX2lub2RlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNjExNTwvZGl2
PjxkaXY+eGZzX2J1Zl9pdGVtX3BpbiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA2MzE1PC9k
aXY+PGRpdj54ZnNfYm1hcGlfd3JpdGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA2Njc0
PC9kaXY+PGRpdj54ZnNfZW5kX2lvIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IDY2NzQ8L2Rpdj48ZGl2Pnhmc19pb21hcF93cml0ZV91bndyaXR0ZW4gwqAgwqAgwqAgwqAgwqA2
Njc0PC9kaXY+PGRpdj54ZnNfYm1hcF9hZGRfZXh0ZW50X3Vud3JpdHRlbl8gwqAgwqAgNjY3NTwv
ZGl2PjxkaXY+eGZzX2JtYXBpX2NvbnZlcnRfdW53cml0dGVuIMKgIMKgIMKgIMKgNjY3NTwvZGl2
PjxkaXY+eGZzX2Rlc3Ryb3lfaW9lbmQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA2Njc1PC9k
aXY+PGRpdj54ZnNfZW5kX2lvX2RpcmVjdF93cml0ZSDCoCDCoCDCoCDCoCDCoCDCoDY2NzY8L2Rp
dj48ZGl2Pnhmc19maW5pc2hfaW9lbmQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNjY3Nzwv
ZGl2PjxkaXY+eGZzX2JtYXBfZmluaXNoIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNjY4
MzwvZGl2PjxkaXY+eGZzX2ZpbGVfYWlvX3dyaXRlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDY3
ODQ8L2Rpdj48ZGl2Pnhmc19ibWFwaV9yZWFkIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IDY3ODU8L2Rpdj48ZGl2Pnhmc19maWxlX2Fpb193cml0ZV9jaGVja3MgwqAgwqAgwqAgwqAgwqA2
Nzg1PC9kaXY+PGRpdj54ZnNfZmlsZV9kaW9fYWlvX3dyaXRlIMKgIMKgIMKgIMKgIMKgIMKgIDY3
ODU8L2Rpdj48ZGl2Pnhmc19nZXRfYmxvY2tzX2RpcmVjdCDCoCDCoCDCoCDCoCDCoCDCoCDCoDY3
ODU8L2Rpdj48ZGl2Pnhmc19pbG9ja19kYXRhX21hcF9zaGFyZWQgwqAgwqAgwqAgwqAgwqA2Nzg1
PC9kaXY+PGRpdj54ZnNfbWFwX2J1ZmZlci5pc3JhLjkgwqAgwqAgwqAgwqAgwqAgwqAgwqA2Nzg1
PC9kaXY+PGRpdj54ZnNfdm1fZGlyZWN0X0lPIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDY3
ODU8L2Rpdj48ZGl2Pnhmc19hbGxvY19pb2VuZCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oDY3ODY8L2Rpdj48ZGl2Pnhmc19mc2JfdG9fZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqA2Nzg2PC9kaXY+PGRpdj54ZnNfYm1idF9zZXRfYmxvY2tjb3VudCDCoCDCoCDCoCDCoCDC
oCDCoDc2OTE8L2Rpdj48ZGl2Pnhmc19sb2dfY29tbWl0X2NpbCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCA3NzA0PC9kaXY+PGRpdj54ZnNfdHJhbnNfY29tbWl0IMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIDc3MDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19mcmVlX2l0ZW1zIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIDc3MDQ8L2Rpdj48ZGl2Pnhmc190cmFuc19yZXNlcnZlIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgNzcwNTwvZGl2PjxkaXY+eGZzX3RyYW5zX3VucmVzZXJ2ZV9hbmRfbW9kX3NiIMKg
IMKgIDc3MDU8L2Rpdj48ZGl2Pnhmc19sb2dfZG9uZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCA3NzA2PC9kaXY+PGRpdj54ZnNfdHJhbnNfZnJlZSDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCA3NzA2PC9kaXY+PGRpdj54ZnNfbG9nX3Jlc2VydmUgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqA3NzA4PC9kaXY+PGRpdj54ZnNfdHJhbnNfaWpvaW4gwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqA3NzA4PC9kaXY+PGRpdj54ZnNfZXh0ZW50X2J1c3lfY2xlYXIgwqAg
wqAgwqAgwqAgwqAgwqAgwqA3NzEyPC9kaXY+PGRpdj54ZnNfaW5vZGVfaXRlbV91bmxvY2sgwqAg
wqAgwqAgwqAgwqAgwqAgwqA3NzEyPC9kaXY+PGRpdj54ZnNfbG9nX3NwYWNlX3dha2UgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgNzcxMjwvZGl2PjxkaXY+eGZzX2xvZ190aWNrZXRfcHV0IMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIDc3MTI8L2Rpdj48ZGl2Pnhmc190cmFuc19hcHBseV9kcXVvdF9k
ZWx0YXMgwqAgwqAgwqAgNzcxMjwvZGl2PjxkaXY+eGZzX2lub2RlX2l0ZW1fY29tbWl0dGluZyDC
oCDCoCDCoCDCoCDCoDc3MTM8L2Rpdj48ZGl2Pnhmc19sb2dfY2FsY191bml0X3JlcyDCoCDCoCDC
oCDCoCDCoCDCoCDCoDc3MTM8L2Rpdj48ZGl2Pnhmc190cmFuc19mcmVlX2RxaW5mbyDCoCDCoCDC
oCDCoCDCoCDCoCDCoDc3MTM8L2Rpdj48ZGl2Pnhmc19ibWJ0X3VwZGF0ZSDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoDgzMTE8L2Rpdj48ZGl2Pnhmc19idHJlZV91cGRhdGUgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgODM1NDwvZGl2PjxkaXY+eGZzX2JtYnRfaW5pdF9yZWNfZnJvbV9j
dXIgwqAgwqAgwqAgwqAgOTc1ODwvZGl2PjxkaXY+eGZzX2JtYnRfZGlza19zZXRfYWxsIMKgIMKg
IMKgIMKgIMKgIMKgIMKgOTc2MDwvZGl2PjxkaXY+eGZzX2JtYnRfc2V0X2FsbCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCA5NzYwPC9kaXY+PGRpdj54ZnNfYnRyZWVfaW5zZXJ0IMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIDk3OTU8L2Rpdj48ZGl2Pnhmc19idHJlZV9pbnNyZWMgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgOTgzODwvZGl2PjxkaXY+eGZzX2JtYnRfaW5pdF9jdXJzb3Ig
wqAgwqAgwqAgwqAgwqAgwqAgwqAxMDM3OTwvZGl2PjxkaXY+eGZzX2J0cmVlX2RlbF9jdXJzb3Ig
wqAgwqAgwqAgwqAgwqAgwqAgwqAxMDQ5ODwvZGl2PjxkaXY+eGZzX3RyYW5zX2RlbF9pdGVtIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgMTExMDE8L2Rpdj48ZGl2Pnhmc19idWZfaXRlbV9kaXJ0eSDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoDExMTA5PC9kaXY+PGRpdj54ZnNfYm1idF9sb29rdXBfZXEg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAxMTU1MTwvZGl2PjxkaXY+eGZzX2JtYnRfaW5pdF9wdHJf
ZnJvbV9jdXIgwqAgwqAgwqAgwqAxMTU2MzwvZGl2PjxkaXY+eGZzX2J0cmVlX2dldF9pcm9vdC5p
c3JhLjggwqAgwqAgwqAgwqAxMTU2MzwvZGl2PjxkaXY+eGZzX2J1Zl9pdGVtX2Zvcm1hdCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAxMTY5MDwvZGl2PjxkaXY+eGZzX2J1Zl9pdGVtX3NpemUgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgMTE2OTA8L2Rpdj48ZGl2Pnhmc19idWZfaXRlbV9zaXplX3NlZ21l
bnQuaXNyYSDCoCDCoDExNjkwPC9kaXY+PGRpdj54ZnNfYnRyZWVfbG9va3VwIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgMTE3MjM8L2Rpdj48ZGl2Pnhmc19idHJlZV9nZXRfc2libGluZy5pc3Jh
LjExIMKgIMKgIDExOTc0PC9kaXY+PGRpdj54ZnNfYnVmX2l0ZW1fdW5sb2NrIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIDEyMjI5PC9kaXY+PGRpdj54ZnNfYnVmX2l0ZW1fY29tbWl0dGluZyDCoCDCoCDC
oCDCoCDCoCAxMjIzNzwvZGl2PjxkaXY+eGZzX2ljc2JfbW9kaWZ5X2NvdW50ZXJzIMKgIMKgIMKg
IMKgIMKgMTMzNTE8L2Rpdj48ZGl2Pnhmc19pY3NiX2xvY2tfY250ciDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoDEzMzY1PC9kaXY+PGRpdj54ZnNfaWNzYl91bmxvY2tfY250ciDCoCDCoCDCoCDCoCDC
oCDCoCDCoDEzMzY1PC9kaXY+PGRpdj54ZnNfaWV4dF9ibm9fdG9faXJlYyDCoCDCoCDCoCDCoCDC
oCDCoCDCoDEzNDU4PC9kaXY+PGRpdj54ZnNfYm1hcF9zZWFyY2hfZXh0ZW50cyDCoCDCoCDCoCDC
oCDCoCAxMzQ1OTwvZGl2PjxkaXY+eGZzX2JtYXBfc2VhcmNoX211bHRpX2V4dGVudHMgwqAgwqAg
MTM0NTk8L2Rpdj48ZGl2Pnhmc19pZXh0X2Jub190b19leHQgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
MTM0NTk8L2Rpdj48ZGl2Pnhmc19ibWFwaV90cmltX21hcC5pc3JhLjExIMKgIMKgIMKgIMKgMTM0
Njk8L2Rpdj48ZGl2Pnhmc19ibWFwaV91cGRhdGVfbWFwIMKgIMKgIMKgIMKgIMKgIMKgIMKgMTM0
Njk8L2Rpdj48ZGl2Pnhmc19maW5kX2JkZXZfZm9yX2lub2RlIMKgIMKgIMKgIMKgIMKgIDEzNTcz
PC9kaXY+PGRpdj54ZnNfYnRyZWVfc2hpZnRfcmVjcy5pc3JhLjI0IMKgIMKgIMKgMTQ3OTg8L2Rp
dj48ZGl2Pnhmc19jaWxfcHJlcGFyZV9pdGVtLmlzcmEuMSDCoCDCoCDCoCAxNzc2OTwvZGl2Pjxk
aXY+eGZzX2JtYnRfZGlza19zZXRfYWxsZiDCoCDCoCDCoCDCoCDCoCDCoDE4MTI2PC9kaXY+PGRp
dj54ZnNfYnRyZWVfaXNfbGFzdHJlYyDCoCDCoCDCoCDCoCDCoCDCoCDCoDE4NTgxPC9kaXY+PGRp
dj54ZnNfYnRyZWVfbG9nX2Jsb2NrIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDE5NjQ4PC9kaXY+PGRp
dj54ZnNfYnRyZWVfc2V0X3B0cl9udWxsLmlzcmEuMTAgwqAgwqAxOTY0OTwvZGl2PjxkaXY+eGZz
X2J0cmVlX29mZnNldHMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMTk3MDM8L2Rpdj48ZGl2Pnhm
c19pdW5sb2NrIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDIxMzQ4PC9kaXY+PGRp
dj54ZnNfaWxvY2sgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMjEzNDk8L2Rp
dj48ZGl2Pnhmc19idHJlZV9jb3B5X3JlY3MuaXNyYS4yMSDCoCDCoCDCoCAyMjg0OTwvZGl2Pjxk
aXY+eGZzX2J1Zl9pdGVtX2luaXQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgMjMzMzE8L2Rpdj48
ZGl2Pnhmc19idWZfdW5sb2NrIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMjMzNDU8L2Rp
dj48ZGl2Pnhmc19idHJlZV9zZXRidWYgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAyMzk0ODwv
ZGl2PjxkaXY+eGZzX2J0cmVlX2xvZ19yZWNzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMjQxOTA8
L2Rpdj48ZGl2Pnhmc19pY3NiX2NvdW50ZXJfZGlzYWJsZWQgwqAgwqAgwqAgwqAgMjY3NTE8L2Rp
dj48ZGl2Pnhmc19idWZfcmVhZF9tYXAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAyODc4Njwv
ZGl2PjxkaXY+eGZzX2J1Zl9nZXRfbWFwIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDI4ODI5
PC9kaXY+PGRpdj54ZnNfYnRyZWVfcHRyX2lzX251bGwuaXNyYS45IMKgIMKgIMKgMjkyNzQ8L2Rp
dj48ZGl2Pnhmc19idHJlZV9yZWFkX2J1Zl9ibG9jay5pc3JhLiDCoCDCoDI5Njg0PC9kaXY+PGRp
dj54ZnNfYnRyZWVfc2V0X3JlZnMuaXNyYS4xMyDCoCDCoCDCoCDCoDI5NzEyPC9kaXY+PGRpdj54
ZnNfdHJhbnNfYWRkX2l0ZW0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAzMTAzNzwvZGl2PjxkaXY+
eGZzX3RyYW5zX2ZyZWVfaXRlbV9kZXNjIMKgIMKgIMKgIMKgIMKgMzEwNTI8L2Rpdj48ZGl2Pnhm
c19idWZfdHJ5bG9jayDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAzMjQ2MzwvZGl2PjxkaXY+
eGZzX3BlcmFnX3B1dCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAzMjYwNjwvZGl2Pjxk
aXY+eGZzX3BlcmFnX2dldCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAzMjYzMzwvZGl2
PjxkaXY+eGZzX2J1Zl9yZWxlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzI2OTM8
L2Rpdj48ZGl2Pnhmc190cmFuc19icmVsc2UgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAzNTE0
ODwvZGl2PjxkaXY+eGZzX2J0cmVlX3B0cl9hZGRyIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgMzg1
OTE8L2Rpdj48ZGl2Pnhmc19idHJlZV9wdHJfb2Zmc2V0IMKgIMKgIMKgIMKgIMKgIMKgIMKgMzg3
Mzg8L2Rpdj48ZGl2Pnhmc190cmFuc19yZWFkX2J1Zl9tYXAgwqAgwqAgwqAgwqAgwqAgwqA0MDkz
ODwvZGl2PjxkaXY+eGZzX3RyYW5zX2J1Zl9pdGVtX21hdGNoIMKgIMKgIMKgIMKgIMKgNDEwMDA8
L2Rpdj48ZGl2Pnhmc19idHJlZV9wdHJfdG9fZGFkZHIgwqAgwqAgwqAgwqAgwqAgwqA0NDU2Mjwv
ZGl2PjxkaXY+eGZzX2J0cmVlX2xvb2t1cF9nZXRfYmxvY2sgwqAgwqAgwqAgwqA0NjU0ODwvZGl2
PjxkaXY+eGZzX3RyYW5zX2xvZ19idWYgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNDg3ODM8L2Rp
dj48ZGl2Pnhmc19idWZfaXRlbV9sb2cgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA0ODgwNjwv
ZGl2PjxkaXY+eGZzX3RyYW5zX2J1Zl9zZXRfdHlwZSDCoCDCoCDCoCDCoCDCoCDCoDQ4ODE1PC9k
aXY+PGRpdj54ZnNfaWV4dF9nZXRfZXh0IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgNTE3MTI8
L2Rpdj48ZGl2Pnhmc19ibWJ0X2dldF9hbGwgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqA1MzY2
OTwvZGl2PjxkaXY+eGZzX2J0cmVlX2dldF9ibG9jayDCoCDCoCDCoCDCoCDCoCDCoCDCoCA1NDQy
NDwvZGl2PjxkaXY+eGZzX2lleHRfaWR4X3RvX2lyZWMgwqAgwqAgwqAgwqAgwqAgwqAgwqA1Njc2
ODwvZGl2PjxkaXY+eGZzX2JtYnRfZ2V0X21heHJlY3MgwqAgwqAgwqAgwqAgwqAgwqAgwqA1Nzc3
NDwvZGl2PjxkaXY+eGZzX2JtYnRfZ2V0X2Jsb2NrY291bnQgwqAgwqAgwqAgwqAgwqAgODk2NTA8
L2Rpdj48ZGl2Pnhmc19ibWJ0X2Rpc2tfZ2V0X3N0YXJ0b2ZmIMKgIMKgIMKgIMKgOTgyODU8L2Rp
dj48ZGl2Pnhmc19ibWJ0X2luaXRfa2V5X2Zyb21fcmVjIMKgIMKgIMKgIMKgOTgyODU8L2Rpdj48
ZGl2Pnhmc19idHJlZV9yZWNfYWRkciDCoCDCoCDCoCDCoCDCoCDCoCDCoCAxMTUxOTk8L2Rpdj48
ZGl2Pnhmc19idHJlZV9yZWNfb2Zmc2V0IMKgIMKgIMKgIMKgIMKgIMKgIDE2MzYzNTwvZGl2Pjxk
aXY+eGZzX2J0cmVlX2tleV9hZGRyIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDE3NjgzNzwvZGl2Pjxk
aXY+eGZzX2J0cmVlX2tleV9vZmZzZXQgwqAgwqAgwqAgwqAgwqAgwqAgMTg2NTI1PC9kaXY+PGRp
dj54ZnNfYm1idF9rZXlfZGlmZiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDI1NDc2MzwvZGl2Pjxk
aXY+eGZzX2xvb2t1cF9nZXRfc2VhcmNoX2tleSDCoCDCoCDCoCDCoDI1NzE5MDwvZGl2PjxkaXY+
eGZzX2JtYnRfZ2V0X3N0YXJ0b2ZmIMKgIMKgIMKgIMKgIMKgIMKgMzYzMTU4PC9kaXY+PGRpdj54
ZnNfbmV4dF9iaXQgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNjMxMzM0PC9kaXY+PGRp
dj54ZnNfYnVmX29mZnNldCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDExNjY0Nzc8L2Rpdj48
L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkNvbXBhcmUgd2l0aCB0aGUg
dHdvIHJlc3VsdHMgYWJvdmUsIEkgZm91bmQgwqB3aGVuIHRoZSBpb3BzIGRvd24gdG8gMTlrwrEs
IGxvdHMgb2YgZnVuY3Rpb25zIHdlcmUgdHJhY2VkLCBzdWNoIGFzwqB4ZnNfYnVmX3RyeWxvY2ss
wqB4ZnNfaWV4dF9pbnNlcnQswqB4ZnNfYnRyZWVfaW5zZXJ0LCBldGMuPC9kaXY+PGRpdj48YnI+
PC9kaXY+PGRpdj5JIGNhbm5vdCBmaW5kIHdoYXQgY2F1c2UgdGhlIGlvcHMgZG93biB0byAxOWvC
sSwgYW55IHN1Z2dlc3Rpb24gPzxicj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pjxicj48L2Rp
dj48L2Rpdj4NCg==
--001a114272e45301b605303628a6--


--===============4349656936905688600==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4349656936905688600==--
