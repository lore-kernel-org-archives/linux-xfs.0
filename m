Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2742F7F37
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 00:23:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E60A98F80A1
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 22:23:11 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	XyB9ohAZ8M99xfCE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 22:23:06 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id ox1so2096675veb.35
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 22:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
Date: Fri, 12 Apr 2013 13:23:05 +0800
Message-ID: <CADFMGuJjS2OOeAsVfd6Sb0Rada=qbL8Udu+wEOhoUE5+pT83rg@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1913850148657396942=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1913850148657396942==
Content-Type: multipart/alternative; boundary=089e011831980e5b8d04da231926

--089e011831980e5b8d04da231926
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

sudo stap -L 'kernel.trace("*")'|grep xfs_iunlink
sudo stap -L 'kernel.trace("*")'|grep xfs_ifree
sudo stap -L 'kernel.trace("*")'|grep xfs
kernel.trace("xfs_agf") $mp:struct xfs_mount* $agf:struct xfs_agf*
$flags:int $caller_ip:long unsigned int
kernel.trace("xfs_alloc_busy") $mp:struct xfs_mount* $agno:xfs_agnumber_t
$agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_alloc_busy_clear") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_alloc_busy_enomem") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_alloc_busy_force") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_alloc_busy_reuse") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_alloc_busy_trim") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
$tbno:xfs_agblock_t $tlen:xfs_extlen_t
kernel.trace("xfs_alloc_exact_done") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_exact_error") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_exact_notfound") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_file_space") $ip:struct xfs_inode*
kernel.trace("xfs_alloc_near_busy") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_error") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_first") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_greater") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_lesser") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_noentry") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_near_nominleft") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_busy") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_done") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_error") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_neither") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_noentry") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_size_nominleft") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_small_done") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_small_error") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_small_freelist") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_small_notenough") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_vextent_allfailed") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_vextent_badargs") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_vextent_loopfailed") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_vextent_noagbp") $args:struct xfs_alloc_arg*
kernel.trace("xfs_alloc_vextent_nofix") $args:struct xfs_alloc_arg*
kernel.trace("xfs_attr_list_add") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_full") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_leaf") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_leaf_end") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_node_descend") $ctx:struct
xfs_attr_list_context* $btree:struct xfs_da_node_entry*
kernel.trace("xfs_attr_list_notfound") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_sf") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_sf_all") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_attr_list_wrong_blk") $ctx:struct xfs_attr_list_context*
kernel.trace("xfs_bdstrat_shut") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_bmap_post_update") $ip:struct xfs_inode*
$idx:xfs_extnum_t $state:int $caller_ip:long unsigned int
kernel.trace("xfs_bmap_pre_update") $ip:struct xfs_inode* $idx:xfs_extnum_t
$state:int $caller_ip:long unsigned int
kernel.trace("xfs_btree_corrupt") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_bawrite") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_bdwrite") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_cond_lock") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_delwri_dequeue") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_delwri_queue") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_delwri_split") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_error_relse") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_find") $bp:struct xfs_buf* $flags:unsigned int
$caller_ip:long unsigned int
kernel.trace("xfs_buf_free") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_get") $bp:struct xfs_buf* $flags:unsigned int
$caller_ip:long unsigned int
kernel.trace("xfs_buf_get_uncached") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_hold") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_init") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_iodone") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_ioerror") $bp:struct xfs_buf* $error:int
$caller_ip:long unsigned int
kernel.trace("xfs_buf_iorequest") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_iowait") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_iowait_done") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_item_committed") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_format") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_format_stale") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_iodone") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_item_iodone_async") $bp:struct xfs_buf*
$caller_ip:long unsigned int
kernel.trace("xfs_buf_item_pin") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_push") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_pushbuf") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_relse") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_item_size") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_size_stale") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_trylock") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_unlock") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_unlock_stale") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_unpin") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_item_unpin_stale") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_buf_lock") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_lock_done") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_buf_read") $bp:struct xfs_buf* $flags:unsigned int
$caller_ip:long unsigned int
kernel.trace("xfs_buf_rele") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_buf_unlock") $bp:struct xfs_buf* $caller_ip:long unsigned
int
kernel.trace("xfs_bunmap") $ip:struct xfs_inode* $bno:xfs_fileoff_t
$len:xfs_filblks_t $flags:int $caller_ip:long unsigned int
kernel.trace("xfs_check_acl") $ip:struct xfs_inode*
kernel.trace("xfs_clear_inode") $ip:struct xfs_inode*
kernel.trace("xfs_create") $dp:struct xfs_inode* $xfs_create:struct
xfs_name*
kernel.trace("xfs_da_btree_corrupt") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_delalloc_enospc") $ip:struct xfs_inode* $offset:xfs_off_t
$count:ssize_t
kernel.trace("xfs_destroy_inode") $ip:struct xfs_inode*
kernel.trace("xfs_dir2_block_addname") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_block_lookup") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_block_removename") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_block_replace") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_block_to_leaf") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_block_to_sf") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_grow_inode") $args:struct xfs_da_args* $idx:int
kernel.trace("xfs_dir2_leaf_addname") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leaf_lookup") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leaf_removename") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leaf_replace") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leaf_to_block") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leaf_to_node") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_leafn_add") $args:struct xfs_da_args* $idx:int
kernel.trace("xfs_dir2_leafn_moveents") $args:struct xfs_da_args*
$src_idx:int $dst_idx:int $count:int
kernel.trace("xfs_dir2_leafn_remove") $args:struct xfs_da_args* $idx:int
kernel.trace("xfs_dir2_node_addname") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_node_lookup") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_node_removename") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_node_replace") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_node_to_leaf") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_addname") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_create") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_lookup") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_removename") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_replace") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_to_block") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_toino4") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_sf_toino8") $args:struct xfs_da_args*
kernel.trace("xfs_dir2_shrink_inode") $args:struct xfs_da_args* $idx:int
kernel.trace("xfs_discard_busy") $mp:struct xfs_mount* $agno:xfs_agnumber_t
$agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_discard_exclude") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_discard_extent") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_discard_toosmall") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t
kernel.trace("xfs_dqadjust") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqalloc") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqattach_found") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqattach_get") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqflush") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqflush_done") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqflush_force") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqget_hit") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqget_miss") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqinit") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqlookup_done") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqlookup_found") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqlookup_freelist") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqlookup_want") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqput") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqput_free") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqput_wait") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqread") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqread_fail") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqreclaim_dirty") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqreclaim_unlink") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqreclaim_want") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqrele") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqreuse") $dqp:struct xfs_dquot*
kernel.trace("xfs_dqtobp_read") $dqp:struct xfs_dquot*
kernel.trace("xfs_dquot_dqalloc") $ip:struct xfs_inode*
kernel.trace("xfs_dquot_dqdetach") $ip:struct xfs_inode*
kernel.trace("xfs_extlist") $ip:struct xfs_inode* $idx:xfs_extnum_t
$state:int $caller_ip:long unsigned int
kernel.trace("xfs_file_buffered_write") $ip:struct xfs_inode* $count:size_t
$offset:loff_t $flags:int
kernel.trace("xfs_file_compat_ioctl") $ip:struct xfs_inode*
kernel.trace("xfs_file_direct_write") $ip:struct xfs_inode* $count:size_t
$offset:loff_t $flags:int
kernel.trace("xfs_file_fsync") $ip:struct xfs_inode*
kernel.trace("xfs_file_ioctl") $ip:struct xfs_inode*
kernel.trace("xfs_file_read") $ip:struct xfs_inode* $count:size_t
$offset:loff_t $flags:int
kernel.trace("xfs_file_splice_read") $ip:struct xfs_inode* $count:size_t
$offset:loff_t $flags:int
kernel.trace("xfs_file_splice_write") $ip:struct xfs_inode* $count:size_t
$offset:loff_t $flags:int
kernel.trace("xfs_free_extent") $mp:struct xfs_mount* $agno:xfs_agnumber_t
$agbno:xfs_agblock_t $len:xfs_extlen_t $isfl:bool $haveleft:int
$haveright:int
kernel.trace("xfs_free_file_space") $ip:struct xfs_inode*
kernel.trace("xfs_get_blocks_alloc") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*
kernel.trace("xfs_get_blocks_found") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*
kernel.trace("xfs_get_blocks_notfound") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t
kernel.trace("xfs_getattr") $ip:struct xfs_inode*
kernel.trace("xfs_iext_insert") $ip:struct xfs_inode* $idx:xfs_extnum_t
$r:struct xfs_bmbt_irec* $state:int $caller_ip:long unsigned int
kernel.trace("xfs_iext_remove") $ip:struct xfs_inode* $idx:xfs_extnum_t
$state:int $caller_ip:long unsigned int
kernel.trace("xfs_iget_hit") $ip:struct xfs_inode*
kernel.trace("xfs_iget_miss") $ip:struct xfs_inode*
kernel.trace("xfs_iget_reclaim") $ip:struct xfs_inode*
kernel.trace("xfs_iget_reclaim_fail") $ip:struct xfs_inode*
kernel.trace("xfs_iget_skip") $ip:struct xfs_inode*
kernel.trace("xfs_ihold") $ip:struct xfs_inode* $caller_ip:long unsigned in=
t
kernel.trace("xfs_ilock") $ip:struct xfs_inode* $lock_flags:unsigned int
$caller_ip:long unsigned int
kernel.trace("xfs_ilock_demote") $ip:struct xfs_inode* $lock_flags:unsigned
int $caller_ip:long unsigned int
kernel.trace("xfs_ilock_nowait") $ip:struct xfs_inode* $lock_flags:unsigned
int $caller_ip:long unsigned int
kernel.trace("xfs_inode_item_push") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_inode_pin") $ip:struct xfs_inode* $caller_ip:long
unsigned int
kernel.trace("xfs_inode_unpin") $ip:struct xfs_inode* $caller_ip:long
unsigned int
kernel.trace("xfs_inode_unpin_nowait") $ip:struct xfs_inode*
$caller_ip:long unsigned int
kernel.trace("xfs_invalidatepage") $inode:struct inode* $page:struct page*
$off:long unsigned int
kernel.trace("xfs_ioctl_setattr") $ip:struct xfs_inode*
kernel.trace("xfs_irele") $ip:struct xfs_inode* $caller_ip:long unsigned in=
t
kernel.trace("xfs_itruncate_finish_end") $ip:struct xfs_inode*
$new_size:xfs_fsize_t
kernel.trace("xfs_itruncate_finish_start") $ip:struct xfs_inode*
$new_size:xfs_fsize_t
kernel.trace("xfs_itruncate_start") $ip:struct xfs_inode*
$new_size:xfs_fsize_t $flag:int $toss_start:xfs_off_t $toss_finish:xfs_off_=
t
kernel.trace("xfs_iunlock") $ip:struct xfs_inode* $lock_flags:unsigned int
$caller_ip:long unsigned int
kernel.trace("xfs_link") $dp:struct xfs_inode* $xfs_link:struct xfs_name*
kernel.trace("xfs_log_done_nonperm") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_done_perm") $log:struct log* $tic:struct xlog_ticket*
kernel.trace("xfs_log_grant_enter") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_error") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_exit") $log:struct log* $tic:struct xlog_ticket=
*
kernel.trace("xfs_log_grant_sleep1") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_sleep2") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_wake1") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_wake2") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_grant_wake_up") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_recover_buf_cancel") $log:struct log* $buf_f:struct
xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_cancel_add") $log:struct log*
$buf_f:struct xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_cancel_ref_inc") $log:struct log*
$buf_f:struct xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_dquot_buf") $log:struct log*
$buf_f:struct xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_inode_buf") $log:struct log*
$buf_f:struct xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_not_cancel") $log:struct log*
$buf_f:struct xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_recover") $log:struct log* $buf_f:struct
xfs_buf_log_format*
kernel.trace("xfs_log_recover_buf_reg_buf") $log:struct log* $buf_f:struct
xfs_buf_log_format*
kernel.trace("xfs_log_recover_inode_cancel") $log:struct log* $in_f:struct
xfs_inode_log_format*
kernel.trace("xfs_log_recover_inode_recover") $log:struct log* $in_f:struct
xfs_inode_log_format*
kernel.trace("xfs_log_recover_inode_skip") $log:struct log* $in_f:struct
xfs_inode_log_format*
kernel.trace("xfs_log_recover_item_add") $log:struct log* $trans:struct
xlog_recover* $item:struct xlog_recover_item* $pass:int
kernel.trace("xfs_log_recover_item_add_cont") $log:struct log*
$trans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int
kernel.trace("xfs_log_recover_item_recover") $log:struct log* $trans:struct
xlog_recover* $item:struct xlog_recover_item* $pass:int
kernel.trace("xfs_log_recover_item_reorder_head") $log:struct log*
$trans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int
kernel.trace("xfs_log_recover_item_reorder_tail") $log:struct log*
$trans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int
kernel.trace("xfs_log_regrant_reserve_enter") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_reserve_exit") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_reserve_sub") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_enter") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_error") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_exit") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_sleep1") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_sleep2") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_wake1") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_wake2") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_regrant_write_wake_up") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_reserve") $log:struct log* $tic:struct xlog_ticket*
kernel.trace("xfs_log_umount_write") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_ungrant_enter") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_ungrant_exit") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_log_ungrant_sub") $log:struct log* $tic:struct
xlog_ticket*
kernel.trace("xfs_lookup") $dp:struct xfs_inode* $xfs_lookup:struct
xfs_name*
kernel.trace("xfs_map_blocks_alloc") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*
kernel.trace("xfs_map_blocks_found") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*
kernel.trace("xfs_pagecache_inval") $ip:struct xfs_inode* $start:xfs_off_t
$finish:xfs_off_t
kernel.trace("xfs_perag_clear_reclaim") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $refcount:int $caller_ip:long unsigned int
kernel.trace("xfs_perag_get") $mp:struct xfs_mount* $agno:xfs_agnumber_t
$refcount:int $caller_ip:long unsigned int
kernel.trace("xfs_perag_get_tag") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $refcount:int $caller_ip:long unsigned int
kernel.trace("xfs_perag_put") $mp:struct xfs_mount* $agno:xfs_agnumber_t
$refcount:int $caller_ip:long unsigned int
kernel.trace("xfs_perag_set_reclaim") $mp:struct xfs_mount*
$agno:xfs_agnumber_t $refcount:int $caller_ip:long unsigned int
kernel.trace("xfs_readdir") $ip:struct xfs_inode*
kernel.trace("xfs_readlink") $ip:struct xfs_inode*
kernel.trace("xfs_releasepage") $inode:struct inode* $page:struct page*
$off:long unsigned int
kernel.trace("xfs_remove") $dp:struct xfs_inode* $xfs_remove:struct
xfs_name*
kernel.trace("xfs_rename") $src_dp:struct xfs_inode* $target_dp:struct
xfs_inode* $src_name:struct xfs_name* $target_name:struct xfs_name*
kernel.trace("xfs_reset_dqcounts") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_setattr") $ip:struct xfs_inode*
kernel.trace("xfs_swap_extent_after") $ip:struct xfs_inode* $which:int
kernel.trace("xfs_swap_extent_before") $ip:struct xfs_inode* $which:int
kernel.trace("xfs_symlink") $dp:struct xfs_inode* $xfs_symlink:struct
xfs_name*
kernel.trace("xfs_trans_bhold") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_bhold_release") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_binval") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_bjoin") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_brelse") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_commit_lsn") $trans:struct xfs_trans*
kernel.trace("xfs_trans_get_buf") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_get_buf_recur") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_getsb") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_getsb_recur") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_log_buf") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_read_buf") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_read_buf_io") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_trans_read_buf_recur") $bip:struct xfs_buf_log_item*
kernel.trace("xfs_trans_read_buf_shut") $bp:struct xfs_buf* $caller_ip:long
unsigned int
kernel.trace("xfs_unwritten_convert") $ip:struct xfs_inode*
$offset:xfs_off_t $count:ssize_t
kernel.trace("xfs_vm_bmap") $ip:struct xfs_inode*
kernel.trace("xfs_write_inode") $ip:struct xfs_inode*
kernel.trace("xfs_writepage") $inode:struct inode* $page:struct page*
$off:long unsigned int


2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Brian,
> Sorry but when I execute the script it says:
> WARNING: cannot find module xfs debuginfo: No DWARF information found
> semantic error: no match while resolving probe point
> module("xfs").function("xfs_iunlink")
>
> uname -a
> 2.6.32-279.el6.x86_64
> kernel debuginfo has been installed.
>
> Where can I find the correct xfs debuginfo?
>
>
> Thank you for your help.
>
>
> 2013/4/12 Brian Foster <bfoster@redhat.com>
>
>> On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:
>> > It happens tonight again on one of our servers, how to debug the root
>> > cause? Thank you.
>> >
>>
>> Hi,
>>
>> I've attached a system tap script (stap -v xfs.stp) that should
>> hopefully print out a bit more data should the issue happen again. Do
>> you have a small enough number of nodes (or predictable enough pattern)
>> that you could run this on the nodes that tend to fail and collect the
>> output?
>>
>> Also, could you collect an xfs_metadump of the filesystem in question
>> and make it available for download and analysis somewhere? I believe the
>> ideal approach is to mount/umount the filesystem first to replay the log
>> before collecting a metadump, but somebody could correct me on that (to
>> be safe, you could collect multiple dumps: pre-mount and post-mount).
>>
>> Could you also describe your workload a little bit? Thanks.
>>
>> Brian
>>
>> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
>> > xfs_inotobp() returned error 22.
>> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree return=
ed
>> > error 22
>> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)
>> > called from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =
=3D
>> > 0xffffffffa02ee20a
>> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting
>> > down filesystem
>> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem a=
nd
>> > rectify the problem(s)
>> > Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
>> > Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
>> > Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
>> > Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
>> >
>> > xfs_repair -n
>> >
>> >
>> > Phase 7 - verify link counts...
>> > would have reset inode 20021 nlinks from 0 to 1
>> > would have reset inode 20789 nlinks from 0 to 1
>> > would have reset inode 35125 nlinks from 0 to 1
>> > would have reset inode 35637 nlinks from 0 to 1
>> > would have reset inode 36149 nlinks from 0 to 1
>> > would have reset inode 38197 nlinks from 0 to 1
>> > would have reset inode 39477 nlinks from 0 to 1
>> > would have reset inode 54069 nlinks from 0 to 1
>> > would have reset inode 62261 nlinks from 0 to 1
>> > would have reset inode 63029 nlinks from 0 to 1
>> > would have reset inode 72501 nlinks from 0 to 1
>> > would have reset inode 79925 nlinks from 0 to 1
>> > would have reset inode 81205 nlinks from 0 to 1
>> > would have reset inode 84789 nlinks from 0 to 1
>> > would have reset inode 87861 nlinks from 0 to 1
>> > would have reset inode 90663 nlinks from 0 to 1
>> > would have reset inode 91189 nlinks from 0 to 1
>> > would have reset inode 95541 nlinks from 0 to 1
>> > would have reset inode 98101 nlinks from 0 to 1
>> > would have reset inode 101173 nlinks from 0 to 1
>> > would have reset inode 113205 nlinks from 0 to 1
>> > would have reset inode 114741 nlinks from 0 to 1
>> > would have reset inode 126261 nlinks from 0 to 1
>> > would have reset inode 140597 nlinks from 0 to 1
>> > would have reset inode 144693 nlinks from 0 to 1
>> > would have reset inode 147765 nlinks from 0 to 1
>> > would have reset inode 152885 nlinks from 0 to 1
>> > would have reset inode 161333 nlinks from 0 to 1
>> > would have reset inode 161845 nlinks from 0 to 1
>> > would have reset inode 167477 nlinks from 0 to 1
>> > would have reset inode 172341 nlinks from 0 to 1
>> > would have reset inode 191797 nlinks from 0 to 1
>> > would have reset inode 204853 nlinks from 0 to 1
>> > would have reset inode 205365 nlinks from 0 to 1
>> > would have reset inode 215349 nlinks from 0 to 1
>> > would have reset inode 215861 nlinks from 0 to 1
>> > would have reset inode 216373 nlinks from 0 to 1
>> > would have reset inode 217397 nlinks from 0 to 1
>> > would have reset inode 224309 nlinks from 0 to 1
>> > would have reset inode 225589 nlinks from 0 to 1
>> > would have reset inode 234549 nlinks from 0 to 1
>> > would have reset inode 234805 nlinks from 0 to 1
>> > would have reset inode 249653 nlinks from 0 to 1
>> > would have reset inode 250677 nlinks from 0 to 1
>> > would have reset inode 252469 nlinks from 0 to 1
>> > would have reset inode 261429 nlinks from 0 to 1
>> > would have reset inode 265013 nlinks from 0 to 1
>> > would have reset inode 266805 nlinks from 0 to 1
>> > would have reset inode 267317 nlinks from 0 to 1
>> > would have reset inode 268853 nlinks from 0 to 1
>> > would have reset inode 272437 nlinks from 0 to 1
>> > would have reset inode 273205 nlinks from 0 to 1
>> > would have reset inode 274229 nlinks from 0 to 1
>> > would have reset inode 278325 nlinks from 0 to 1
>> > would have reset inode 278837 nlinks from 0 to 1
>> > would have reset inode 281397 nlinks from 0 to 1
>> > would have reset inode 292661 nlinks from 0 to 1
>> > would have reset inode 300853 nlinks from 0 to 1
>> > would have reset inode 302901 nlinks from 0 to 1
>> > would have reset inode 305205 nlinks from 0 to 1
>> > would have reset inode 314165 nlinks from 0 to 1
>> > would have reset inode 315189 nlinks from 0 to 1
>> > would have reset inode 320309 nlinks from 0 to 1
>> > would have reset inode 324917 nlinks from 0 to 1
>> > would have reset inode 328245 nlinks from 0 to 1
>> > would have reset inode 335925 nlinks from 0 to 1
>> > would have reset inode 339253 nlinks from 0 to 1
>> > would have reset inode 339765 nlinks from 0 to 1
>> > would have reset inode 348213 nlinks from 0 to 1
>> > would have reset inode 360501 nlinks from 0 to 1
>> > would have reset inode 362037 nlinks from 0 to 1
>> > would have reset inode 366389 nlinks from 0 to 1
>> > would have reset inode 385845 nlinks from 0 to 1
>> > would have reset inode 390709 nlinks from 0 to 1
>> > would have reset inode 409141 nlinks from 0 to 1
>> > would have reset inode 413237 nlinks from 0 to 1
>> > would have reset inode 414773 nlinks from 0 to 1
>> > would have reset inode 417845 nlinks from 0 to 1
>> > would have reset inode 436021 nlinks from 0 to 1
>> > would have reset inode 439349 nlinks from 0 to 1
>> > would have reset inode 447029 nlinks from 0 to 1
>> > would have reset inode 491317 nlinks from 0 to 1
>> > would have reset inode 494133 nlinks from 0 to 1
>> > would have reset inode 495413 nlinks from 0 to 1
>> > would have reset inode 501301 nlinks from 0 to 1
>> > would have reset inode 506421 nlinks from 0 to 1
>> > would have reset inode 508469 nlinks from 0 to 1
>> > would have reset inode 508981 nlinks from 0 to 1
>> > would have reset inode 511797 nlinks from 0 to 1
>> > would have reset inode 513077 nlinks from 0 to 1
>> > would have reset inode 517941 nlinks from 0 to 1
>> > would have reset inode 521013 nlinks from 0 to 1
>> > would have reset inode 522805 nlinks from 0 to 1
>> > would have reset inode 523317 nlinks from 0 to 1
>> > would have reset inode 525621 nlinks from 0 to 1
>> > would have reset inode 527925 nlinks from 0 to 1
>> > would have reset inode 535605 nlinks from 0 to 1
>> > would have reset inode 541749 nlinks from 0 to 1
>> > would have reset inode 573493 nlinks from 0 to 1
>> > would have reset inode 578613 nlinks from 0 to 1
>> > would have reset inode 583029 nlinks from 0 to 1
>> > would have reset inode 585525 nlinks from 0 to 1
>> > would have reset inode 586293 nlinks from 0 to 1
>> > would have reset inode 586805 nlinks from 0 to 1
>> > would have reset inode 591413 nlinks from 0 to 1
>> > would have reset inode 594485 nlinks from 0 to 1
>> > would have reset inode 596277 nlinks from 0 to 1
>> > would have reset inode 603189 nlinks from 0 to 1
>> > would have reset inode 613429 nlinks from 0 to 1
>> > would have reset inode 617781 nlinks from 0 to 1
>> > would have reset inode 621877 nlinks from 0 to 1
>> > would have reset inode 623925 nlinks from 0 to 1
>> > would have reset inode 625205 nlinks from 0 to 1
>> > would have reset inode 626741 nlinks from 0 to 1
>> > would have reset inode 639541 nlinks from 0 to 1
>> > would have reset inode 640053 nlinks from 0 to 1
>> > would have reset inode 640565 nlinks from 0 to 1
>> > would have reset inode 645173 nlinks from 0 to 1
>> > would have reset inode 652853 nlinks from 0 to 1
>> > would have reset inode 656181 nlinks from 0 to 1
>> > would have reset inode 659253 nlinks from 0 to 1
>> > would have reset inode 663605 nlinks from 0 to 1
>> > would have reset inode 667445 nlinks from 0 to 1
>> > would have reset inode 680757 nlinks from 0 to 1
>> > would have reset inode 691253 nlinks from 0 to 1
>> > would have reset inode 691765 nlinks from 0 to 1
>> > would have reset inode 697653 nlinks from 0 to 1
>> > would have reset inode 700469 nlinks from 0 to 1
>> > would have reset inode 707893 nlinks from 0 to 1
>> > would have reset inode 716853 nlinks from 0 to 1
>> > would have reset inode 722229 nlinks from 0 to 1
>> > would have reset inode 722741 nlinks from 0 to 1
>> > would have reset inode 723765 nlinks from 0 to 1
>> > would have reset inode 731957 nlinks from 0 to 1
>> > would have reset inode 742965 nlinks from 0 to 1
>> > would have reset inode 743477 nlinks from 0 to 1
>> > would have reset inode 745781 nlinks from 0 to 1
>> > would have reset inode 746293 nlinks from 0 to 1
>> > would have reset inode 774453 nlinks from 0 to 1
>> > would have reset inode 778805 nlinks from 0 to 1
>> > would have reset inode 785013 nlinks from 0 to 1
>> > would have reset inode 785973 nlinks from 0 to 1
>> > would have reset inode 791349 nlinks from 0 to 1
>> > would have reset inode 796981 nlinks from 0 to 1
>> > would have reset inode 803381 nlinks from 0 to 1
>> > would have reset inode 806965 nlinks from 0 to 1
>> > would have reset inode 811798 nlinks from 0 to 1
>> > would have reset inode 812310 nlinks from 0 to 1
>> > would have reset inode 813078 nlinks from 0 to 1
>> > would have reset inode 813607 nlinks from 0 to 1
>> > would have reset inode 814183 nlinks from 0 to 1
>> > would have reset inode 822069 nlinks from 0 to 1
>> > would have reset inode 828469 nlinks from 0 to 1
>> > would have reset inode 830005 nlinks from 0 to 1
>> > would have reset inode 832053 nlinks from 0 to 1
>> > would have reset inode 832565 nlinks from 0 to 1
>> > would have reset inode 836661 nlinks from 0 to 1
>> > would have reset inode 841013 nlinks from 0 to 1
>> > would have reset inode 841525 nlinks from 0 to 1
>> > would have reset inode 845365 nlinks from 0 to 1
>> > would have reset inode 846133 nlinks from 0 to 1
>> > would have reset inode 847157 nlinks from 0 to 1
>> > would have reset inode 852533 nlinks from 0 to 1
>> > would have reset inode 857141 nlinks from 0 to 1
>> > would have reset inode 863271 nlinks from 0 to 1
>> > would have reset inode 866855 nlinks from 0 to 1
>> > would have reset inode 887861 nlinks from 0 to 1
>> > would have reset inode 891701 nlinks from 0 to 1
>> > would have reset inode 894773 nlinks from 0 to 1
>> > would have reset inode 900149 nlinks from 0 to 1
>> > would have reset inode 902197 nlinks from 0 to 1
>> > would have reset inode 906293 nlinks from 0 to 1
>> > would have reset inode 906805 nlinks from 0 to 1
>> > would have reset inode 909877 nlinks from 0 to 1
>> > would have reset inode 925493 nlinks from 0 to 1
>> > would have reset inode 949543 nlinks from 0 to 1
>> > would have reset inode 955175 nlinks from 0 to 1
>> > would have reset inode 963623 nlinks from 0 to 1
>> > would have reset inode 967733 nlinks from 0 to 1
>> > would have reset inode 968231 nlinks from 0 to 1
>> > would have reset inode 982069 nlinks from 0 to 1
>> > would have reset inode 1007413 nlinks from 0 to 1
>> > would have reset inode 1011509 nlinks from 0 to 1
>> > would have reset inode 1014069 nlinks from 0 to 1
>> > would have reset inode 1014581 nlinks from 0 to 1
>> > would have reset inode 1022005 nlinks from 0 to 1
>> > would have reset inode 1022517 nlinks from 0 to 1
>> > would have reset inode 1023029 nlinks from 0 to 1
>> > would have reset inode 1025333 nlinks from 0 to 1
>> > would have reset inode 1043765 nlinks from 0 to 1
>> > would have reset inode 1044789 nlinks from 0 to 1
>> > would have reset inode 1049397 nlinks from 0 to 1
>> > would have reset inode 1050933 nlinks from 0 to 1
>> > would have reset inode 1051445 nlinks from 0 to 1
>> > would have reset inode 1054261 nlinks from 0 to 1
>> > would have reset inode 1060917 nlinks from 0 to 1
>> > would have reset inode 1063477 nlinks from 0 to 1
>> > would have reset inode 1076021 nlinks from 0 to 1
>> > would have reset inode 1081141 nlinks from 0 to 1
>> > would have reset inode 1086261 nlinks from 0 to 1
>> > would have reset inode 1097269 nlinks from 0 to 1
>> > would have reset inode 1099829 nlinks from 0 to 1
>> > would have reset inode 1100853 nlinks from 0 to 1
>> > would have reset inode 1101877 nlinks from 0 to 1
>> > would have reset inode 1126709 nlinks from 0 to 1
>> > would have reset inode 1134389 nlinks from 0 to 1
>> > would have reset inode 1141045 nlinks from 0 to 1
>> > would have reset inode 1141557 nlinks from 0 to 1
>> > would have reset inode 1142581 nlinks from 0 to 1
>> > would have reset inode 1148469 nlinks from 0 to 1
>> > would have reset inode 1153333 nlinks from 0 to 1
>> > would have reset inode 1181749 nlinks from 0 to 1
>> > would have reset inode 1192245 nlinks from 0 to 1
>> > would have reset inode 1198133 nlinks from 0 to 1
>> > would have reset inode 1203765 nlinks from 0 to 1
>> > would have reset inode 1221429 nlinks from 0 to 1
>> > would have reset inode 1223989 nlinks from 0 to 1
>> > would have reset inode 1235509 nlinks from 0 to 1
>> > would have reset inode 1239349 nlinks from 0 to 1
>> > would have reset inode 1240885 nlinks from 0 to 1
>> > would have reset inode 1241397 nlinks from 0 to 1
>> > would have reset inode 1241909 nlinks from 0 to 1
>> > would have reset inode 1242421 nlinks from 0 to 1
>> > would have reset inode 1244981 nlinks from 0 to 1
>> > would have reset inode 1246517 nlinks from 0 to 1
>> > would have reset inode 1253429 nlinks from 0 to 1
>> > would have reset inode 1271861 nlinks from 0 to 1
>> > would have reset inode 1274677 nlinks from 0 to 1
>> > would have reset inode 1277749 nlinks from 0 to 1
>> > would have reset inode 1278773 nlinks from 0 to 1
>> > would have reset inode 1286709 nlinks from 0 to 1
>> > would have reset inode 1288245 nlinks from 0 to 1
>> > would have reset inode 1299765 nlinks from 0 to 1
>> > would have reset inode 1302325 nlinks from 0 to 1
>> > would have reset inode 1304885 nlinks from 0 to 1
>> > would have reset inode 1305397 nlinks from 0 to 1
>> > would have reset inode 1307509 nlinks from 0 to 1
>> > would have reset inode 1309493 nlinks from 0 to 1
>> > would have reset inode 1310517 nlinks from 0 to 1
>> > would have reset inode 1311029 nlinks from 0 to 1
>> > would have reset inode 1312053 nlinks from 0 to 1
>> > would have reset inode 1316917 nlinks from 0 to 1
>> > would have reset inode 1317941 nlinks from 0 to 1
>> > would have reset inode 1320821 nlinks from 0 to 1
>> > would have reset inode 1322805 nlinks from 0 to 1
>> > would have reset inode 1332789 nlinks from 0 to 1
>> > would have reset inode 1336373 nlinks from 0 to 1
>> > would have reset inode 1345653 nlinks from 0 to 1
>> > would have reset inode 1354549 nlinks from 0 to 1
>> > would have reset inode 1361973 nlinks from 0 to 1
>> > would have reset inode 1369909 nlinks from 0 to 1
>> > would have reset inode 1372981 nlinks from 0 to 1
>> > would have reset inode 1388853 nlinks from 0 to 1
>> > would have reset inode 1402933 nlinks from 0 to 1
>> > would have reset inode 1403445 nlinks from 0 to 1
>> > would have reset inode 1420085 nlinks from 0 to 1
>> > would have reset inode 1452853 nlinks from 0 to 1
>> > would have reset inode 1456437 nlinks from 0 to 1
>> > would have reset inode 1457973 nlinks from 0 to 1
>> > would have reset inode 1459253 nlinks from 0 to 1
>> > would have reset inode 1467957 nlinks from 0 to 1
>> > would have reset inode 1471541 nlinks from 0 to 1
>> > would have reset inode 1476661 nlinks from 0 to 1
>> > would have reset inode 1479733 nlinks from 0 to 1
>> > would have reset inode 1483061 nlinks from 0 to 1
>> > would have reset inode 1484085 nlinks from 0 to 1
>> > would have reset inode 1486133 nlinks from 0 to 1
>> > would have reset inode 1489461 nlinks from 0 to 1
>> > would have reset inode 1490037 nlinks from 0 to 1
>> > would have reset inode 1492021 nlinks from 0 to 1
>> > would have reset inode 1493557 nlinks from 0 to 1
>> > would have reset inode 1494069 nlinks from 0 to 1
>> > would have reset inode 1496885 nlinks from 0 to 1
>> > would have reset inode 1498421 nlinks from 0 to 1
>> > would have reset inode 1498933 nlinks from 0 to 1
>> > would have reset inode 1499957 nlinks from 0 to 1
>> > would have reset inode 1506101 nlinks from 0 to 1
>> > would have reset inode 1507637 nlinks from 0 to 1
>> > would have reset inode 1510453 nlinks from 0 to 1
>> > would have reset inode 1514293 nlinks from 0 to 1
>> > would have reset inode 1517365 nlinks from 0 to 1
>> > would have reset inode 1520693 nlinks from 0 to 1
>> > would have reset inode 1521973 nlinks from 0 to 1
>> > would have reset inode 1530421 nlinks from 0 to 1
>> > would have reset inode 1530933 nlinks from 0 to 1
>> > would have reset inode 1537333 nlinks from 0 to 1
>> > would have reset inode 1538357 nlinks from 0 to 1
>> > would have reset inode 1548853 nlinks from 0 to 1
>> > would have reset inode 1553973 nlinks from 0 to 1
>> > would have reset inode 1557301 nlinks from 0 to 1
>> > would have reset inode 1564213 nlinks from 0 to 1
>> > would have reset inode 1564725 nlinks from 0 to 1
>> > would have reset inode 1576501 nlinks from 0 to 1
>> > would have reset inode 1580597 nlinks from 0 to 1
>> > would have reset inode 1584693 nlinks from 0 to 1
>> > would have reset inode 1586485 nlinks from 0 to 1
>> > would have reset inode 1589301 nlinks from 0 to 1
>> > would have reset inode 1589813 nlinks from 0 to 1
>> > would have reset inode 1592629 nlinks from 0 to 1
>> > would have reset inode 1595701 nlinks from 0 to 1
>> > would have reset inode 1601077 nlinks from 0 to 1
>> > would have reset inode 1623861 nlinks from 0 to 1
>> > would have reset inode 1626677 nlinks from 0 to 1
>> > would have reset inode 1627701 nlinks from 0 to 1
>> > would have reset inode 1633333 nlinks from 0 to 1
>> > would have reset inode 1639221 nlinks from 0 to 1
>> > would have reset inode 1649205 nlinks from 0 to 1
>> > would have reset inode 1686325 nlinks from 0 to 1
>> > would have reset inode 1690677 nlinks from 0 to 1
>> > would have reset inode 1693749 nlinks from 0 to 1
>> > would have reset inode 1704757 nlinks from 0 to 1
>> > would have reset inode 1707061 nlinks from 0 to 1
>> > would have reset inode 1709109 nlinks from 0 to 1
>> > would have reset inode 1719349 nlinks from 0 to 1
>> > would have reset inode 1737013 nlinks from 0 to 1
>> > would have reset inode 1741365 nlinks from 0 to 1
>> > would have reset inode 1747509 nlinks from 0 to 1
>> > would have reset inode 1770805 nlinks from 0 to 1
>> > would have reset inode 1780789 nlinks from 0 to 1
>> > would have reset inode 1793589 nlinks from 0 to 1
>> > would have reset inode 1795125 nlinks from 0 to 1
>> > would have reset inode 1800757 nlinks from 0 to 1
>> > would have reset inode 1801269 nlinks from 0 to 1
>> > would have reset inode 1802549 nlinks from 0 to 1
>> > would have reset inode 1804085 nlinks from 0 to 1
>> > would have reset inode 1817141 nlinks from 0 to 1
>> > would have reset inode 1821749 nlinks from 0 to 1
>> > would have reset inode 1832757 nlinks from 0 to 1
>> > would have reset inode 1836341 nlinks from 0 to 1
>> > would have reset inode 1856309 nlinks from 0 to 1
>> > would have reset inode 1900597 nlinks from 0 to 1
>> > would have reset inode 1902901 nlinks from 0 to 1
>> > would have reset inode 1912373 nlinks from 0 to 1
>> > would have reset inode 1943093 nlinks from 0 to 1
>> > would have reset inode 1944373 nlinks from 0 to 1
>> > would have reset inode 1954101 nlinks from 0 to 1
>> > would have reset inode 1955893 nlinks from 0 to 1
>> > would have reset inode 1961781 nlinks from 0 to 1
>> > would have reset inode 1974325 nlinks from 0 to 1
>> > would have reset inode 1978677 nlinks from 0 to 1
>> > would have reset inode 1981237 nlinks from 0 to 1
>> > would have reset inode 1992245 nlinks from 0 to 1
>> > would have reset inode 2000949 nlinks from 0 to 1
>> > would have reset inode 2002229 nlinks from 0 to 1
>> > would have reset inode 2004789 nlinks from 0 to 1
>> > would have reset inode 2005301 nlinks from 0 to 1
>> > would have reset inode 2011189 nlinks from 0 to 1
>> > would have reset inode 2012981 nlinks from 0 to 1
>> > would have reset inode 2015285 nlinks from 0 to 1
>> > would have reset inode 2018869 nlinks from 0 to 1
>> > would have reset inode 2028341 nlinks from 0 to 1
>> > would have reset inode 2028853 nlinks from 0 to 1
>> > would have reset inode 2030901 nlinks from 0 to 1
>> > would have reset inode 2032181 nlinks from 0 to 1
>> > would have reset inode 2032693 nlinks from 0 to 1
>> > would have reset inode 2040117 nlinks from 0 to 1
>> > would have reset inode 2053685 nlinks from 0 to 1
>> > would have reset inode 2083893 nlinks from 0 to 1
>> > would have reset inode 2087221 nlinks from 0 to 1
>> > would have reset inode 2095925 nlinks from 0 to 1
>> > would have reset inode 2098741 nlinks from 0 to 1
>> > would have reset inode 2100533 nlinks from 0 to 1
>> > would have reset inode 2101301 nlinks from 0 to 1
>> > would have reset inode 2123573 nlinks from 0 to 1
>> > would have reset inode 2132789 nlinks from 0 to 1
>> > would have reset inode 2133813 nlinks from 0 to 1
>> >
>> >
>> >
>> >
>> >
>> > 2013/4/10 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gm=
ail.com>>
>> >
>> >     The storage info is as following:
>> >     RAID-6
>> >     SATA HDD
>> >     Controller: PERC H710P Mini (Embedded)
>> >     Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes
>> >     255 heads, 63 sectors/track, 3647334 cylinders
>> >     Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>> >     Sector size (logical/physical): 512 bytes / 512 bytes
>> >     I/O size (minimum/optimal): 512 bytes / 512 bytes
>> >     Disk identifier: 0x00000000
>> >
>> >     sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (30.0 TB/27=
.2
>> >     TiB)
>> >     sd 0:2:1:0: [sdb] Write Protect is off
>> >     sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
>> >     sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn=
't
>> >     support DPO or FUA
>> >     sd 0:2:1:0: [sdb] Attached SCSI disk
>> >
>> >     *-storage
>> >            description: RAID bus controller
>> >            product: MegaRAID SAS 2208 [Thunderbolt]
>> >            vendor: LSI Logic / Symbios Logic
>> >            physical id: 0
>> >            bus info: pci@0000:02:00.0
>> >            logical name: scsi0
>> >            version: 01
>> >            width: 64 bits
>> >            clock: 33MHz
>> >            capabilities: storage pm pciexpress vpd msi msix bus_master
>> >     cap_list rom
>> >            configuration: driver=3Dmegaraid_sas latency=3D0
>> >            resources: irq:42 ioport:fc00(size=3D256)
>> >     memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff
>> >     memory:dc800000-dc81ffff(prefetchable)
>> >          *-disk:0
>> >               description: SCSI Disk
>> >               product: PERC H710P
>> >               vendor: DELL
>> >               physical id: 2.0.0
>> >               bus info: scsi@0:2.0.0
>> >               logical name: /dev/sda
>> >               version: 3.13
>> >               serial: 0049d6ce1d9f2035180096fde490f648
>> >               size: 558GiB (599GB)
>> >               capabilities: partitioned partitioned:dos
>> >               configuration: ansiversion=3D5 signature=3D000aa336
>> >          *-disk:1
>> >               description: SCSI Disk
>> >               product: PERC H710P
>> >               vendor: DELL
>> >               physical id: 2.1.0
>> >               bus info: scsi@0:2.1.0
>> >               logical name: /dev/sdb
>> >               logical name: /mnt/xfsd
>> >               version: 3.13
>> >               serial: 003366f71da22035180096fde490f648
>> >               size: 27TiB (30TB)
>> >               configuration: ansiversion=3D5 mount.fstype=3Dxfs
>> >
>> mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,sw=
idth=3D1280,noquota
>> >     state=3Dmounted
>> >
>> >     Thank you.
>> >
>> >
>> >     2013/4/10 Emmanuel Florac <eflorac@intellique.com
>> >     <mailto:eflorac@intellique.com>>
>> >
>> >         Le Tue, 9 Apr 2013 23:10:03 +0800
>> >         =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gmai=
l.com>>
>> =A8=A6crivait:
>> >
>> >         > > Apr  9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected=
.
>> >         > > Shutting down filesystem
>> >
>> >         This. I/O error detected. That means that at some point the
>> >         underlying
>> >         device (disk, RAID array, SAN volume) couldn't be reached. So
>> this
>> >         could very well be a case of a flakey drive, array, cable or
>> SCSI
>> >         driver.
>> >
>> >         What's the storage setup here?
>> >
>> >         --
>> >
>> ------------------------------------------------------------------------
>> >         Emmanuel Florac     |   Direction technique
>> >                             |   Intellique
>> >                             |   <eflorac@intellique.com
>> >         <mailto:eflorac@intellique.com>>
>> >                             |   +33 1 78 94 84 02
>> >
>> ------------------------------------------------------------------------
>> >
>> >
>> >
>> >
>> >     --
>> >     =B7=FB=D3=C0=CC=CE
>> >
>> >
>> >
>> >
>> > --
>> > =B7=FB=D3=C0=CC=CE
>> >
>> >
>> > _______________________________________________
>> > xfs mailing list
>> > xfs@oss.sgi.com
>> > http://oss.sgi.com/mailman/listinfo/xfs
>> >
>>
>>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--089e011831980e5b8d04da231926
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">sudo stap -L &#39;kernel.trace(&quot;*&quot;)&#39;|grep xf=
s_iunlink<br>sudo stap -L &#39;kernel.trace(&quot;*&quot;)&#39;|grep xfs_if=
ree<br>sudo stap -L &#39;kernel.trace(&quot;*&quot;)&#39;|grep xfs<br>kerne=
l.trace(&quot;xfs_agf&quot;) $mp:struct xfs_mount* $agf:struct xfs_agf* $fl=
ags:int $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_alloc_busy&quot;) $mp:struct xfs_mount* $agno:xfs_ag=
number_t $agbno:xfs_agblock_t $len:xfs_extlen_t<br>kernel.trace(&quot;xfs_a=
lloc_busy_clear&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $agbno:xf=
s_agblock_t $len:xfs_extlen_t<br>
kernel.trace(&quot;xfs_alloc_busy_enomem&quot;) $mp:struct xfs_mount* $agno=
:xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t<br>kernel.trace(&quo=
t;xfs_alloc_busy_force&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $a=
gbno:xfs_agblock_t $len:xfs_extlen_t<br>
kernel.trace(&quot;xfs_alloc_busy_reuse&quot;) $mp:struct xfs_mount* $agno:=
xfs_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t<br>kernel.trace(&quot=
;xfs_alloc_busy_trim&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $agb=
no:xfs_agblock_t $len:xfs_extlen_t $tbno:xfs_agblock_t $tlen:xfs_extlen_t<b=
r>
kernel.trace(&quot;xfs_alloc_exact_done&quot;) $args:struct xfs_alloc_arg*<=
br>kernel.trace(&quot;xfs_alloc_exact_error&quot;) $args:struct xfs_alloc_a=
rg*<br>kernel.trace(&quot;xfs_alloc_exact_notfound&quot;) $args:struct xfs_=
alloc_arg*<br>
kernel.trace(&quot;xfs_alloc_file_space&quot;) $ip:struct xfs_inode*<br>ker=
nel.trace(&quot;xfs_alloc_near_busy&quot;) $args:struct xfs_alloc_arg*<br>k=
ernel.trace(&quot;xfs_alloc_near_error&quot;) $args:struct xfs_alloc_arg*<b=
r>
kernel.trace(&quot;xfs_alloc_near_first&quot;) $args:struct xfs_alloc_arg*<=
br>kernel.trace(&quot;xfs_alloc_near_greater&quot;) $args:struct xfs_alloc_=
arg*<br>kernel.trace(&quot;xfs_alloc_near_lesser&quot;) $args:struct xfs_al=
loc_arg*<br>
kernel.trace(&quot;xfs_alloc_near_noentry&quot;) $args:struct xfs_alloc_arg=
*<br>kernel.trace(&quot;xfs_alloc_near_nominleft&quot;) $args:struct xfs_al=
loc_arg*<br>kernel.trace(&quot;xfs_alloc_size_busy&quot;) $args:struct xfs_=
alloc_arg*<br>
kernel.trace(&quot;xfs_alloc_size_done&quot;) $args:struct xfs_alloc_arg*<b=
r>kernel.trace(&quot;xfs_alloc_size_error&quot;) $args:struct xfs_alloc_arg=
*<br>kernel.trace(&quot;xfs_alloc_size_neither&quot;) $args:struct xfs_allo=
c_arg*<br>
kernel.trace(&quot;xfs_alloc_size_noentry&quot;) $args:struct xfs_alloc_arg=
*<br>kernel.trace(&quot;xfs_alloc_size_nominleft&quot;) $args:struct xfs_al=
loc_arg*<br>kernel.trace(&quot;xfs_alloc_small_done&quot;) $args:struct xfs=
_alloc_arg*<br>
kernel.trace(&quot;xfs_alloc_small_error&quot;) $args:struct xfs_alloc_arg*=
<br>kernel.trace(&quot;xfs_alloc_small_freelist&quot;) $args:struct xfs_all=
oc_arg*<br>kernel.trace(&quot;xfs_alloc_small_notenough&quot;) $args:struct=
 xfs_alloc_arg*<br>
kernel.trace(&quot;xfs_alloc_vextent_allfailed&quot;) $args:struct xfs_allo=
c_arg*<br>kernel.trace(&quot;xfs_alloc_vextent_badargs&quot;) $args:struct =
xfs_alloc_arg*<br>kernel.trace(&quot;xfs_alloc_vextent_loopfailed&quot;) $a=
rgs:struct xfs_alloc_arg*<br>
kernel.trace(&quot;xfs_alloc_vextent_noagbp&quot;) $args:struct xfs_alloc_a=
rg*<br>kernel.trace(&quot;xfs_alloc_vextent_nofix&quot;) $args:struct xfs_a=
lloc_arg*<br>kernel.trace(&quot;xfs_attr_list_add&quot;) $ctx:struct xfs_at=
tr_list_context*<br>
kernel.trace(&quot;xfs_attr_list_full&quot;) $ctx:struct xfs_attr_list_cont=
ext*<br>kernel.trace(&quot;xfs_attr_list_leaf&quot;) $ctx:struct xfs_attr_l=
ist_context*<br>kernel.trace(&quot;xfs_attr_list_leaf_end&quot;) $ctx:struc=
t xfs_attr_list_context*<br>
kernel.trace(&quot;xfs_attr_list_node_descend&quot;) $ctx:struct xfs_attr_l=
ist_context* $btree:struct xfs_da_node_entry*<br>kernel.trace(&quot;xfs_att=
r_list_notfound&quot;) $ctx:struct xfs_attr_list_context*<br>kernel.trace(&=
quot;xfs_attr_list_sf&quot;) $ctx:struct xfs_attr_list_context*<br>
kernel.trace(&quot;xfs_attr_list_sf_all&quot;) $ctx:struct xfs_attr_list_co=
ntext*<br>kernel.trace(&quot;xfs_attr_list_wrong_blk&quot;) $ctx:struct xfs=
_attr_list_context*<br>kernel.trace(&quot;xfs_bdstrat_shut&quot;) $bp:struc=
t xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_bmap_post_update&quot;) $ip:struct xfs_inode* $idx:x=
fs_extnum_t $state:int $caller_ip:long unsigned int<br>kernel.trace(&quot;x=
fs_bmap_pre_update&quot;) $ip:struct xfs_inode* $idx:xfs_extnum_t $state:in=
t $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_btree_corrupt&quot;) $bp:struct xfs_buf* $caller_ip:=
long unsigned int<br>kernel.trace(&quot;xfs_buf_bawrite&quot;) $bp:struct x=
fs_buf* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_bdwrite&=
quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_cond_lock&quot;) $bp:struct xfs_buf* $caller_ip:=
long unsigned int<br>kernel.trace(&quot;xfs_buf_delwri_dequeue&quot;) $bp:s=
truct xfs_buf* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_d=
elwri_queue&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_delwri_split&quot;) $bp:struct xfs_buf* $caller_=
ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_error_relse&quot;) $bp:s=
truct xfs_buf* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_f=
ind&quot;) $bp:struct xfs_buf* $flags:unsigned int $caller_ip:long unsigned=
 int<br>
kernel.trace(&quot;xfs_buf_free&quot;) $bp:struct xfs_buf* $caller_ip:long =
unsigned int<br>kernel.trace(&quot;xfs_buf_get&quot;) $bp:struct xfs_buf* $=
flags:unsigned int $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_b=
uf_get_uncached&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_hold&quot;) $bp:struct xfs_buf* $caller_ip:long =
unsigned int<br>kernel.trace(&quot;xfs_buf_init&quot;) $bp:struct xfs_buf* =
$caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_iodone&quot;) $b=
p:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_ioerror&quot;) $bp:struct xfs_buf* $error:int $c=
aller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_iorequest&quot;) $=
bp:struct xfs_buf* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_b=
uf_iowait&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_iowait_done&quot;) $bp:struct xfs_buf* $caller_i=
p:long unsigned int<br>kernel.trace(&quot;xfs_buf_item_committed&quot;) $bi=
p:struct xfs_buf_log_item*<br>kernel.trace(&quot;xfs_buf_item_format&quot;)=
 $bip:struct xfs_buf_log_item*<br>
kernel.trace(&quot;xfs_buf_item_format_stale&quot;) $bip:struct xfs_buf_log=
_item*<br>kernel.trace(&quot;xfs_buf_item_iodone&quot;) $bp:struct xfs_buf*=
 $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_buf_item_iodone_asy=
nc&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_item_pin&quot;) $bip:struct xfs_buf_log_item*<br=
>kernel.trace(&quot;xfs_buf_item_push&quot;) $bip:struct xfs_buf_log_item*<=
br>kernel.trace(&quot;xfs_buf_item_pushbuf&quot;) $bip:struct xfs_buf_log_i=
tem*<br>
kernel.trace(&quot;xfs_buf_item_relse&quot;) $bp:struct xfs_buf* $caller_ip=
:long unsigned int<br>kernel.trace(&quot;xfs_buf_item_size&quot;) $bip:stru=
ct xfs_buf_log_item*<br>kernel.trace(&quot;xfs_buf_item_size_stale&quot;) $=
bip:struct xfs_buf_log_item*<br>
kernel.trace(&quot;xfs_buf_item_trylock&quot;) $bip:struct xfs_buf_log_item=
*<br>kernel.trace(&quot;xfs_buf_item_unlock&quot;) $bip:struct xfs_buf_log_=
item*<br>kernel.trace(&quot;xfs_buf_item_unlock_stale&quot;) $bip:struct xf=
s_buf_log_item*<br>
kernel.trace(&quot;xfs_buf_item_unpin&quot;) $bip:struct xfs_buf_log_item*<=
br>kernel.trace(&quot;xfs_buf_item_unpin_stale&quot;) $bip:struct xfs_buf_l=
og_item*<br>kernel.trace(&quot;xfs_buf_lock&quot;) $bp:struct xfs_buf* $cal=
ler_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_lock_done&quot;) $bp:struct xfs_buf* $caller_ip:=
long unsigned int<br>kernel.trace(&quot;xfs_buf_read&quot;) $bp:struct xfs_=
buf* $flags:unsigned int $caller_ip:long unsigned int<br>kernel.trace(&quot=
;xfs_buf_rele&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_buf_unlock&quot;) $bp:struct xfs_buf* $caller_ip:lon=
g unsigned int<br>kernel.trace(&quot;xfs_bunmap&quot;) $ip:struct xfs_inode=
* $bno:xfs_fileoff_t $len:xfs_filblks_t $flags:int $caller_ip:long unsigned=
 int<br>
kernel.trace(&quot;xfs_check_acl&quot;) $ip:struct xfs_inode*<br>kernel.tra=
ce(&quot;xfs_clear_inode&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot=
;xfs_create&quot;) $dp:struct xfs_inode* $xfs_create:struct xfs_name*<br>
kernel.trace(&quot;xfs_da_btree_corrupt&quot;) $bp:struct xfs_buf* $caller_=
ip:long unsigned int<br>kernel.trace(&quot;xfs_delalloc_enospc&quot;) $ip:s=
truct xfs_inode* $offset:xfs_off_t $count:ssize_t<br>kernel.trace(&quot;xfs=
_destroy_inode&quot;) $ip:struct xfs_inode*<br>
kernel.trace(&quot;xfs_dir2_block_addname&quot;) $args:struct xfs_da_args*<=
br>kernel.trace(&quot;xfs_dir2_block_lookup&quot;) $args:struct xfs_da_args=
*<br>kernel.trace(&quot;xfs_dir2_block_removename&quot;) $args:struct xfs_d=
a_args*<br>
kernel.trace(&quot;xfs_dir2_block_replace&quot;) $args:struct xfs_da_args*<=
br>kernel.trace(&quot;xfs_dir2_block_to_leaf&quot;) $args:struct xfs_da_arg=
s*<br>kernel.trace(&quot;xfs_dir2_block_to_sf&quot;) $args:struct xfs_da_ar=
gs*<br>
kernel.trace(&quot;xfs_dir2_grow_inode&quot;) $args:struct xfs_da_args* $id=
x:int<br>kernel.trace(&quot;xfs_dir2_leaf_addname&quot;) $args:struct xfs_d=
a_args*<br>kernel.trace(&quot;xfs_dir2_leaf_lookup&quot;) $args:struct xfs_=
da_args*<br>
kernel.trace(&quot;xfs_dir2_leaf_removename&quot;) $args:struct xfs_da_args=
*<br>kernel.trace(&quot;xfs_dir2_leaf_replace&quot;) $args:struct xfs_da_ar=
gs*<br>kernel.trace(&quot;xfs_dir2_leaf_to_block&quot;) $args:struct xfs_da=
_args*<br>
kernel.trace(&quot;xfs_dir2_leaf_to_node&quot;) $args:struct xfs_da_args*<b=
r>kernel.trace(&quot;xfs_dir2_leafn_add&quot;) $args:struct xfs_da_args* $i=
dx:int<br>kernel.trace(&quot;xfs_dir2_leafn_moveents&quot;) $args:struct xf=
s_da_args* $src_idx:int $dst_idx:int $count:int<br>
kernel.trace(&quot;xfs_dir2_leafn_remove&quot;) $args:struct xfs_da_args* $=
idx:int<br>kernel.trace(&quot;xfs_dir2_node_addname&quot;) $args:struct xfs=
_da_args*<br>kernel.trace(&quot;xfs_dir2_node_lookup&quot;) $args:struct xf=
s_da_args*<br>
kernel.trace(&quot;xfs_dir2_node_removename&quot;) $args:struct xfs_da_args=
*<br>kernel.trace(&quot;xfs_dir2_node_replace&quot;) $args:struct xfs_da_ar=
gs*<br>kernel.trace(&quot;xfs_dir2_node_to_leaf&quot;) $args:struct xfs_da_=
args*<br>
kernel.trace(&quot;xfs_dir2_sf_addname&quot;) $args:struct xfs_da_args*<br>=
kernel.trace(&quot;xfs_dir2_sf_create&quot;) $args:struct xfs_da_args*<br>k=
ernel.trace(&quot;xfs_dir2_sf_lookup&quot;) $args:struct xfs_da_args*<br>
kernel.trace(&quot;xfs_dir2_sf_removename&quot;) $args:struct xfs_da_args*<=
br>kernel.trace(&quot;xfs_dir2_sf_replace&quot;) $args:struct xfs_da_args*<=
br>kernel.trace(&quot;xfs_dir2_sf_to_block&quot;) $args:struct xfs_da_args*=
<br>
kernel.trace(&quot;xfs_dir2_sf_toino4&quot;) $args:struct xfs_da_args*<br>k=
ernel.trace(&quot;xfs_dir2_sf_toino8&quot;) $args:struct xfs_da_args*<br>ke=
rnel.trace(&quot;xfs_dir2_shrink_inode&quot;) $args:struct xfs_da_args* $id=
x:int<br>
kernel.trace(&quot;xfs_discard_busy&quot;) $mp:struct xfs_mount* $agno:xfs_=
agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t<br>kernel.trace(&quot;xfs=
_discard_exclude&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $agbno:x=
fs_agblock_t $len:xfs_extlen_t<br>
kernel.trace(&quot;xfs_discard_extent&quot;) $mp:struct xfs_mount* $agno:xf=
s_agnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t<br>kernel.trace(&quot;x=
fs_discard_toosmall&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $agbn=
o:xfs_agblock_t $len:xfs_extlen_t<br>
kernel.trace(&quot;xfs_dqadjust&quot;) $dqp:struct xfs_dquot*<br>kernel.tra=
ce(&quot;xfs_dqalloc&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;xf=
s_dqattach_found&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;xfs_dq=
attach_get&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqflush&quot;) $dqp:struct xfs_dquot*<br>kernel.trac=
e(&quot;xfs_dqflush_done&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quo=
t;xfs_dqflush_force&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;xfs=
_dqget_hit&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqget_miss&quot;) $dqp:struct xfs_dquot*<br>kernel.t=
race(&quot;xfs_dqinit&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;x=
fs_dqlookup_done&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;xfs_dq=
lookup_found&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqlookup_freelist&quot;) $dqp:struct xfs_dquot*<br>k=
ernel.trace(&quot;xfs_dqlookup_want&quot;) $dqp:struct xfs_dquot*<br>kernel=
.trace(&quot;xfs_dqput&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;=
xfs_dqput_free&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqput_wait&quot;) $dqp:struct xfs_dquot*<br>kernel.t=
race(&quot;xfs_dqread&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;x=
fs_dqread_fail&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot;xfs_dqre=
claim_dirty&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqreclaim_unlink&quot;) $dqp:struct xfs_dquot*<br>ke=
rnel.trace(&quot;xfs_dqreclaim_want&quot;) $dqp:struct xfs_dquot*<br>kernel=
.trace(&quot;xfs_dqrele&quot;) $dqp:struct xfs_dquot*<br>kernel.trace(&quot=
;xfs_dqreuse&quot;) $dqp:struct xfs_dquot*<br>
kernel.trace(&quot;xfs_dqtobp_read&quot;) $dqp:struct xfs_dquot*<br>kernel.=
trace(&quot;xfs_dquot_dqalloc&quot;) $ip:struct xfs_inode*<br>kernel.trace(=
&quot;xfs_dquot_dqdetach&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot=
;xfs_extlist&quot;) $ip:struct xfs_inode* $idx:xfs_extnum_t $state:int $cal=
ler_ip:long unsigned int<br>
kernel.trace(&quot;xfs_file_buffered_write&quot;) $ip:struct xfs_inode* $co=
unt:size_t $offset:loff_t $flags:int<br>kernel.trace(&quot;xfs_file_compat_=
ioctl&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot;xfs_file_direct_wr=
ite&quot;) $ip:struct xfs_inode* $count:size_t $offset:loff_t $flags:int<br=
>
kernel.trace(&quot;xfs_file_fsync&quot;) $ip:struct xfs_inode*<br>kernel.tr=
ace(&quot;xfs_file_ioctl&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot=
;xfs_file_read&quot;) $ip:struct xfs_inode* $count:size_t $offset:loff_t $f=
lags:int<br>
kernel.trace(&quot;xfs_file_splice_read&quot;) $ip:struct xfs_inode* $count=
:size_t $offset:loff_t $flags:int<br>kernel.trace(&quot;xfs_file_splice_wri=
te&quot;) $ip:struct xfs_inode* $count:size_t $offset:loff_t $flags:int<br>
kernel.trace(&quot;xfs_free_extent&quot;) $mp:struct xfs_mount* $agno:xfs_a=
gnumber_t $agbno:xfs_agblock_t $len:xfs_extlen_t $isfl:bool $haveleft:int $=
haveright:int<br>kernel.trace(&quot;xfs_free_file_space&quot;) $ip:struct x=
fs_inode*<br>
kernel.trace(&quot;xfs_get_blocks_alloc&quot;) $ip:struct xfs_inode* $offse=
t:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*<br>kernel.=
trace(&quot;xfs_get_blocks_found&quot;) $ip:struct xfs_inode* $offset:xfs_o=
ff_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*<br>
kernel.trace(&quot;xfs_get_blocks_notfound&quot;) $ip:struct xfs_inode* $of=
fset:xfs_off_t $count:ssize_t<br>kernel.trace(&quot;xfs_getattr&quot;) $ip:=
struct xfs_inode*<br>kernel.trace(&quot;xfs_iext_insert&quot;) $ip:struct x=
fs_inode* $idx:xfs_extnum_t $r:struct xfs_bmbt_irec* $state:int $caller_ip:=
long unsigned int<br>
kernel.trace(&quot;xfs_iext_remove&quot;) $ip:struct xfs_inode* $idx:xfs_ex=
tnum_t $state:int $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_ig=
et_hit&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot;xfs_iget_miss&quo=
t;) $ip:struct xfs_inode*<br>
kernel.trace(&quot;xfs_iget_reclaim&quot;) $ip:struct xfs_inode*<br>kernel.=
trace(&quot;xfs_iget_reclaim_fail&quot;) $ip:struct xfs_inode*<br>kernel.tr=
ace(&quot;xfs_iget_skip&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot;=
xfs_ihold&quot;) $ip:struct xfs_inode* $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_ilock&quot;) $ip:struct xfs_inode* $lock_flags:unsig=
ned int $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_ilock_demote=
&quot;) $ip:struct xfs_inode* $lock_flags:unsigned int $caller_ip:long unsi=
gned int<br>
kernel.trace(&quot;xfs_ilock_nowait&quot;) $ip:struct xfs_inode* $lock_flag=
s:unsigned int $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_inode=
_item_push&quot;) $bp:struct xfs_buf* $caller_ip:long unsigned int<br>kerne=
l.trace(&quot;xfs_inode_pin&quot;) $ip:struct xfs_inode* $caller_ip:long un=
signed int<br>
kernel.trace(&quot;xfs_inode_unpin&quot;) $ip:struct xfs_inode* $caller_ip:=
long unsigned int<br>kernel.trace(&quot;xfs_inode_unpin_nowait&quot;) $ip:s=
truct xfs_inode* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_inv=
alidatepage&quot;) $inode:struct inode* $page:struct page* $off:long unsign=
ed int<br>
kernel.trace(&quot;xfs_ioctl_setattr&quot;) $ip:struct xfs_inode*<br>kernel=
.trace(&quot;xfs_irele&quot;) $ip:struct xfs_inode* $caller_ip:long unsigne=
d int<br>kernel.trace(&quot;xfs_itruncate_finish_end&quot;) $ip:struct xfs_=
inode* $new_size:xfs_fsize_t<br>
kernel.trace(&quot;xfs_itruncate_finish_start&quot;) $ip:struct xfs_inode* =
$new_size:xfs_fsize_t<br>kernel.trace(&quot;xfs_itruncate_start&quot;) $ip:=
struct xfs_inode* $new_size:xfs_fsize_t $flag:int $toss_start:xfs_off_t $to=
ss_finish:xfs_off_t<br>
kernel.trace(&quot;xfs_iunlock&quot;) $ip:struct xfs_inode* $lock_flags:uns=
igned int $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_link&quot;=
) $dp:struct xfs_inode* $xfs_link:struct xfs_name*<br>kernel.trace(&quot;xf=
s_log_done_nonperm&quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_done_perm&quot;) $log:struct log* $tic:struct xl=
og_ticket*<br>kernel.trace(&quot;xfs_log_grant_enter&quot;) $log:struct log=
* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_grant_error&quot;)=
 $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_grant_exit&quot;) $log:struct log* $tic:struct x=
log_ticket*<br>kernel.trace(&quot;xfs_log_grant_sleep1&quot;) $log:struct l=
og* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_grant_sleep2&quo=
t;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_grant_wake1&quot;) $log:struct log* $tic:struct =
xlog_ticket*<br>kernel.trace(&quot;xfs_log_grant_wake2&quot;) $log:struct l=
og* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_grant_wake_up&qu=
ot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_recover_buf_cancel&quot;) $log:struct log* $buf_=
f:struct xfs_buf_log_format*<br>kernel.trace(&quot;xfs_log_recover_buf_canc=
el_add&quot;) $log:struct log* $buf_f:struct xfs_buf_log_format*<br>kernel.=
trace(&quot;xfs_log_recover_buf_cancel_ref_inc&quot;) $log:struct log* $buf=
_f:struct xfs_buf_log_format*<br>
kernel.trace(&quot;xfs_log_recover_buf_dquot_buf&quot;) $log:struct log* $b=
uf_f:struct xfs_buf_log_format*<br>kernel.trace(&quot;xfs_log_recover_buf_i=
node_buf&quot;) $log:struct log* $buf_f:struct xfs_buf_log_format*<br>kerne=
l.trace(&quot;xfs_log_recover_buf_not_cancel&quot;) $log:struct log* $buf_f=
:struct xfs_buf_log_format*<br>
kernel.trace(&quot;xfs_log_recover_buf_recover&quot;) $log:struct log* $buf=
_f:struct xfs_buf_log_format*<br>kernel.trace(&quot;xfs_log_recover_buf_reg=
_buf&quot;) $log:struct log* $buf_f:struct xfs_buf_log_format*<br>kernel.tr=
ace(&quot;xfs_log_recover_inode_cancel&quot;) $log:struct log* $in_f:struct=
 xfs_inode_log_format*<br>
kernel.trace(&quot;xfs_log_recover_inode_recover&quot;) $log:struct log* $i=
n_f:struct xfs_inode_log_format*<br>kernel.trace(&quot;xfs_log_recover_inod=
e_skip&quot;) $log:struct log* $in_f:struct xfs_inode_log_format*<br>kernel=
.trace(&quot;xfs_log_recover_item_add&quot;) $log:struct log* $trans:struct=
 xlog_recover* $item:struct xlog_recover_item* $pass:int<br>
kernel.trace(&quot;xfs_log_recover_item_add_cont&quot;) $log:struct log* $t=
rans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int<br>kern=
el.trace(&quot;xfs_log_recover_item_recover&quot;) $log:struct log* $trans:=
struct xlog_recover* $item:struct xlog_recover_item* $pass:int<br>
kernel.trace(&quot;xfs_log_recover_item_reorder_head&quot;) $log:struct log=
* $trans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int<br>=
kernel.trace(&quot;xfs_log_recover_item_reorder_tail&quot;) $log:struct log=
* $trans:struct xlog_recover* $item:struct xlog_recover_item* $pass:int<br>
kernel.trace(&quot;xfs_log_regrant_reserve_enter&quot;) $log:struct log* $t=
ic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_regrant_reserve_exit&q=
uot;) $log:struct log* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_l=
og_regrant_reserve_sub&quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_regrant_write_enter&quot;) $log:struct log* $tic=
:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_regrant_write_error&quot=
;) $log:struct log* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_=
regrant_write_exit&quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_regrant_write_sleep1&quot;) $log:struct log* $ti=
c:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_regrant_write_sleep2&qu=
ot;) $log:struct log* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_lo=
g_regrant_write_wake1&quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_regrant_write_wake2&quot;) $log:struct log* $tic=
:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_regrant_write_wake_up&qu=
ot;) $log:struct log* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_lo=
g_reserve&quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_umount_write&quot;) $log:struct log* $tic:struct=
 xlog_ticket*<br>kernel.trace(&quot;xfs_log_ungrant_enter&quot;) $log:struc=
t log* $tic:struct xlog_ticket*<br>kernel.trace(&quot;xfs_log_ungrant_exit&=
quot;) $log:struct log* $tic:struct xlog_ticket*<br>
kernel.trace(&quot;xfs_log_ungrant_sub&quot;) $log:struct log* $tic:struct =
xlog_ticket*<br>kernel.trace(&quot;xfs_lookup&quot;) $dp:struct xfs_inode* =
$xfs_lookup:struct xfs_name*<br>kernel.trace(&quot;xfs_map_blocks_alloc&quo=
t;) $ip:struct xfs_inode* $offset:xfs_off_t $count:ssize_t $type:int $irec:=
struct xfs_bmbt_irec*<br>
kernel.trace(&quot;xfs_map_blocks_found&quot;) $ip:struct xfs_inode* $offse=
t:xfs_off_t $count:ssize_t $type:int $irec:struct xfs_bmbt_irec*<br>kernel.=
trace(&quot;xfs_pagecache_inval&quot;) $ip:struct xfs_inode* $start:xfs_off=
_t $finish:xfs_off_t<br>
kernel.trace(&quot;xfs_perag_clear_reclaim&quot;) $mp:struct xfs_mount* $ag=
no:xfs_agnumber_t $refcount:int $caller_ip:long unsigned int<br>kernel.trac=
e(&quot;xfs_perag_get&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $re=
fcount:int $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_perag_get_tag&quot;) $mp:struct xfs_mount* $agno:xfs=
_agnumber_t $refcount:int $caller_ip:long unsigned int<br>kernel.trace(&quo=
t;xfs_perag_put&quot;) $mp:struct xfs_mount* $agno:xfs_agnumber_t $refcount=
:int $caller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_perag_set_reclaim&quot;) $mp:struct xfs_mount* $agno=
:xfs_agnumber_t $refcount:int $caller_ip:long unsigned int<br>kernel.trace(=
&quot;xfs_readdir&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot;xfs_re=
adlink&quot;) $ip:struct xfs_inode*<br>
kernel.trace(&quot;xfs_releasepage&quot;) $inode:struct inode* $page:struct=
 page* $off:long unsigned int<br>kernel.trace(&quot;xfs_remove&quot;) $dp:s=
truct xfs_inode* $xfs_remove:struct xfs_name*<br>kernel.trace(&quot;xfs_ren=
ame&quot;) $src_dp:struct xfs_inode* $target_dp:struct xfs_inode* $src_name=
:struct xfs_name* $target_name:struct xfs_name*<br>
kernel.trace(&quot;xfs_reset_dqcounts&quot;) $bp:struct xfs_buf* $caller_ip=
:long unsigned int<br>kernel.trace(&quot;xfs_setattr&quot;) $ip:struct xfs_=
inode*<br>kernel.trace(&quot;xfs_swap_extent_after&quot;) $ip:struct xfs_in=
ode* $which:int<br>
kernel.trace(&quot;xfs_swap_extent_before&quot;) $ip:struct xfs_inode* $whi=
ch:int<br>kernel.trace(&quot;xfs_symlink&quot;) $dp:struct xfs_inode* $xfs_=
symlink:struct xfs_name*<br>kernel.trace(&quot;xfs_trans_bhold&quot;) $bip:=
struct xfs_buf_log_item*<br>
kernel.trace(&quot;xfs_trans_bhold_release&quot;) $bip:struct xfs_buf_log_i=
tem*<br>kernel.trace(&quot;xfs_trans_binval&quot;) $bip:struct xfs_buf_log_=
item*<br>kernel.trace(&quot;xfs_trans_bjoin&quot;) $bip:struct xfs_buf_log_=
item*<br>
kernel.trace(&quot;xfs_trans_brelse&quot;) $bip:struct xfs_buf_log_item*<br=
>kernel.trace(&quot;xfs_trans_commit_lsn&quot;) $trans:struct xfs_trans*<br=
>kernel.trace(&quot;xfs_trans_get_buf&quot;) $bip:struct xfs_buf_log_item*<=
br>
kernel.trace(&quot;xfs_trans_get_buf_recur&quot;) $bip:struct xfs_buf_log_i=
tem*<br>kernel.trace(&quot;xfs_trans_getsb&quot;) $bip:struct xfs_buf_log_i=
tem*<br>kernel.trace(&quot;xfs_trans_getsb_recur&quot;) $bip:struct xfs_buf=
_log_item*<br>
kernel.trace(&quot;xfs_trans_log_buf&quot;) $bip:struct xfs_buf_log_item*<b=
r>kernel.trace(&quot;xfs_trans_read_buf&quot;) $bip:struct xfs_buf_log_item=
*<br>kernel.trace(&quot;xfs_trans_read_buf_io&quot;) $bp:struct xfs_buf* $c=
aller_ip:long unsigned int<br>
kernel.trace(&quot;xfs_trans_read_buf_recur&quot;) $bip:struct xfs_buf_log_=
item*<br>kernel.trace(&quot;xfs_trans_read_buf_shut&quot;) $bp:struct xfs_b=
uf* $caller_ip:long unsigned int<br>kernel.trace(&quot;xfs_unwritten_conver=
t&quot;) $ip:struct xfs_inode* $offset:xfs_off_t $count:ssize_t<br>
kernel.trace(&quot;xfs_vm_bmap&quot;) $ip:struct xfs_inode*<br>kernel.trace=
(&quot;xfs_write_inode&quot;) $ip:struct xfs_inode*<br>kernel.trace(&quot;x=
fs_writepage&quot;) $inode:struct inode* $page:struct page* $off:long unsig=
ned int<br>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/=
12 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gma=
il.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">
<div dir=3D"ltr"><div><div><div>Hi Brian,<br></div>Sorry but when I execute=
 the script it says:<br>WARNING: cannot find module xfs debuginfo: No DWARF=
 information found<br>semantic error: no match while resolving probe point =
module(&quot;xfs&quot;).function(&quot;xfs_iunlink&quot;)<br>

<br>uname -a<br>2.6.32-279.el6.x86_64<br></div>kernel debuginfo has been in=
stalled.<br><br></div><div>Where can I find the correct xfs debuginfo?<br><=
/div><div><br><br></div><div>Thank you for your help.<br></div></div><div c=
lass=3D"gmail_extra">
<div><div class=3D"h5">
<br><br><div class=3D"gmail_quote">2013/4/12 Brian Foster <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat=
.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div>On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; It happens tonight again on one of our servers, how to debug the root<=
br>
&gt; cause? Thank you.<br>
&gt;<br>
<br>
</div>Hi,<br>
<br>
I&#39;ve attached a system tap script (stap -v xfs.stp) that should<br>
hopefully print out a bit more data should the issue happen again. Do<br>
you have a small enough number of nodes (or predictable enough pattern)<br>
that you could run this on the nodes that tend to fail and collect the<br>
output?<br>
<br>
Also, could you collect an xfs_metadump of the filesystem in question<br>
and make it available for download and analysis somewhere? I believe the<br=
>
ideal approach is to mount/umount the filesystem first to replay the log<br=
>
before collecting a metadump, but somebody could correct me on that (to<br>
be safe, you could collect multiple dumps: pre-mount and post-mount).<br>
<br>
Could you also describe your workload a little bit? Thanks.<br>
<br>
Brian<br>
<div><div><br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:<br>
&gt; xfs_inotobp() returned error 22.<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree return=
ed<br>
&gt; error 22<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)<br>
&gt; called from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return addr=
ess =3D<br>
&gt; 0xffffffffa02ee20a<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting<b=
r>
&gt; down filesystem<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem a=
nd<br>
&gt; rectify the problem(s)<br>
&gt; Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt;<br>
&gt; xfs_repair -n<br>
&gt;<br>
&gt;<br>
&gt; Phase 7 - verify link counts...<br>
&gt; would have reset inode 20021 nlinks from 0 to 1<br>
&gt; would have reset inode 20789 nlinks from 0 to 1<br>
&gt; would have reset inode 35125 nlinks from 0 to 1<br>
&gt; would have reset inode 35637 nlinks from 0 to 1<br>
&gt; would have reset inode 36149 nlinks from 0 to 1<br>
&gt; would have reset inode 38197 nlinks from 0 to 1<br>
&gt; would have reset inode 39477 nlinks from 0 to 1<br>
&gt; would have reset inode 54069 nlinks from 0 to 1<br>
&gt; would have reset inode 62261 nlinks from 0 to 1<br>
&gt; would have reset inode 63029 nlinks from 0 to 1<br>
&gt; would have reset inode 72501 nlinks from 0 to 1<br>
&gt; would have reset inode 79925 nlinks from 0 to 1<br>
&gt; would have reset inode 81205 nlinks from 0 to 1<br>
&gt; would have reset inode 84789 nlinks from 0 to 1<br>
&gt; would have reset inode 87861 nlinks from 0 to 1<br>
&gt; would have reset inode 90663 nlinks from 0 to 1<br>
&gt; would have reset inode 91189 nlinks from 0 to 1<br>
&gt; would have reset inode 95541 nlinks from 0 to 1<br>
&gt; would have reset inode 98101 nlinks from 0 to 1<br>
&gt; would have reset inode 101173 nlinks from 0 to 1<br>
&gt; would have reset inode 113205 nlinks from 0 to 1<br>
&gt; would have reset inode 114741 nlinks from 0 to 1<br>
&gt; would have reset inode 126261 nlinks from 0 to 1<br>
&gt; would have reset inode 140597 nlinks from 0 to 1<br>
&gt; would have reset inode 144693 nlinks from 0 to 1<br>
&gt; would have reset inode 147765 nlinks from 0 to 1<br>
&gt; would have reset inode 152885 nlinks from 0 to 1<br>
&gt; would have reset inode 161333 nlinks from 0 to 1<br>
&gt; would have reset inode 161845 nlinks from 0 to 1<br>
&gt; would have reset inode 167477 nlinks from 0 to 1<br>
&gt; would have reset inode 172341 nlinks from 0 to 1<br>
&gt; would have reset inode 191797 nlinks from 0 to 1<br>
&gt; would have reset inode 204853 nlinks from 0 to 1<br>
&gt; would have reset inode 205365 nlinks from 0 to 1<br>
&gt; would have reset inode 215349 nlinks from 0 to 1<br>
&gt; would have reset inode 215861 nlinks from 0 to 1<br>
&gt; would have reset inode 216373 nlinks from 0 to 1<br>
&gt; would have reset inode 217397 nlinks from 0 to 1<br>
&gt; would have reset inode 224309 nlinks from 0 to 1<br>
&gt; would have reset inode 225589 nlinks from 0 to 1<br>
&gt; would have reset inode 234549 nlinks from 0 to 1<br>
&gt; would have reset inode 234805 nlinks from 0 to 1<br>
&gt; would have reset inode 249653 nlinks from 0 to 1<br>
&gt; would have reset inode 250677 nlinks from 0 to 1<br>
&gt; would have reset inode 252469 nlinks from 0 to 1<br>
&gt; would have reset inode 261429 nlinks from 0 to 1<br>
&gt; would have reset inode 265013 nlinks from 0 to 1<br>
&gt; would have reset inode 266805 nlinks from 0 to 1<br>
&gt; would have reset inode 267317 nlinks from 0 to 1<br>
&gt; would have reset inode 268853 nlinks from 0 to 1<br>
&gt; would have reset inode 272437 nlinks from 0 to 1<br>
&gt; would have reset inode 273205 nlinks from 0 to 1<br>
&gt; would have reset inode 274229 nlinks from 0 to 1<br>
&gt; would have reset inode 278325 nlinks from 0 to 1<br>
&gt; would have reset inode 278837 nlinks from 0 to 1<br>
&gt; would have reset inode 281397 nlinks from 0 to 1<br>
&gt; would have reset inode 292661 nlinks from 0 to 1<br>
&gt; would have reset inode 300853 nlinks from 0 to 1<br>
&gt; would have reset inode 302901 nlinks from 0 to 1<br>
&gt; would have reset inode 305205 nlinks from 0 to 1<br>
&gt; would have reset inode 314165 nlinks from 0 to 1<br>
&gt; would have reset inode 315189 nlinks from 0 to 1<br>
&gt; would have reset inode 320309 nlinks from 0 to 1<br>
&gt; would have reset inode 324917 nlinks from 0 to 1<br>
&gt; would have reset inode 328245 nlinks from 0 to 1<br>
&gt; would have reset inode 335925 nlinks from 0 to 1<br>
&gt; would have reset inode 339253 nlinks from 0 to 1<br>
&gt; would have reset inode 339765 nlinks from 0 to 1<br>
&gt; would have reset inode 348213 nlinks from 0 to 1<br>
&gt; would have reset inode 360501 nlinks from 0 to 1<br>
&gt; would have reset inode 362037 nlinks from 0 to 1<br>
&gt; would have reset inode 366389 nlinks from 0 to 1<br>
&gt; would have reset inode 385845 nlinks from 0 to 1<br>
&gt; would have reset inode 390709 nlinks from 0 to 1<br>
&gt; would have reset inode 409141 nlinks from 0 to 1<br>
&gt; would have reset inode 413237 nlinks from 0 to 1<br>
&gt; would have reset inode 414773 nlinks from 0 to 1<br>
&gt; would have reset inode 417845 nlinks from 0 to 1<br>
&gt; would have reset inode 436021 nlinks from 0 to 1<br>
&gt; would have reset inode 439349 nlinks from 0 to 1<br>
&gt; would have reset inode 447029 nlinks from 0 to 1<br>
&gt; would have reset inode 491317 nlinks from 0 to 1<br>
&gt; would have reset inode 494133 nlinks from 0 to 1<br>
&gt; would have reset inode 495413 nlinks from 0 to 1<br>
&gt; would have reset inode 501301 nlinks from 0 to 1<br>
&gt; would have reset inode 506421 nlinks from 0 to 1<br>
&gt; would have reset inode 508469 nlinks from 0 to 1<br>
&gt; would have reset inode 508981 nlinks from 0 to 1<br>
&gt; would have reset inode 511797 nlinks from 0 to 1<br>
&gt; would have reset inode 513077 nlinks from 0 to 1<br>
&gt; would have reset inode 517941 nlinks from 0 to 1<br>
&gt; would have reset inode 521013 nlinks from 0 to 1<br>
&gt; would have reset inode 522805 nlinks from 0 to 1<br>
&gt; would have reset inode 523317 nlinks from 0 to 1<br>
&gt; would have reset inode 525621 nlinks from 0 to 1<br>
&gt; would have reset inode 527925 nlinks from 0 to 1<br>
&gt; would have reset inode 535605 nlinks from 0 to 1<br>
&gt; would have reset inode 541749 nlinks from 0 to 1<br>
&gt; would have reset inode 573493 nlinks from 0 to 1<br>
&gt; would have reset inode 578613 nlinks from 0 to 1<br>
&gt; would have reset inode 583029 nlinks from 0 to 1<br>
&gt; would have reset inode 585525 nlinks from 0 to 1<br>
&gt; would have reset inode 586293 nlinks from 0 to 1<br>
&gt; would have reset inode 586805 nlinks from 0 to 1<br>
&gt; would have reset inode 591413 nlinks from 0 to 1<br>
&gt; would have reset inode 594485 nlinks from 0 to 1<br>
&gt; would have reset inode 596277 nlinks from 0 to 1<br>
&gt; would have reset inode 603189 nlinks from 0 to 1<br>
&gt; would have reset inode 613429 nlinks from 0 to 1<br>
&gt; would have reset inode 617781 nlinks from 0 to 1<br>
&gt; would have reset inode 621877 nlinks from 0 to 1<br>
&gt; would have reset inode 623925 nlinks from 0 to 1<br>
&gt; would have reset inode 625205 nlinks from 0 to 1<br>
&gt; would have reset inode 626741 nlinks from 0 to 1<br>
&gt; would have reset inode 639541 nlinks from 0 to 1<br>
&gt; would have reset inode 640053 nlinks from 0 to 1<br>
&gt; would have reset inode 640565 nlinks from 0 to 1<br>
&gt; would have reset inode 645173 nlinks from 0 to 1<br>
&gt; would have reset inode 652853 nlinks from 0 to 1<br>
&gt; would have reset inode 656181 nlinks from 0 to 1<br>
&gt; would have reset inode 659253 nlinks from 0 to 1<br>
&gt; would have reset inode 663605 nlinks from 0 to 1<br>
&gt; would have reset inode 667445 nlinks from 0 to 1<br>
&gt; would have reset inode 680757 nlinks from 0 to 1<br>
&gt; would have reset inode 691253 nlinks from 0 to 1<br>
&gt; would have reset inode 691765 nlinks from 0 to 1<br>
&gt; would have reset inode 697653 nlinks from 0 to 1<br>
&gt; would have reset inode 700469 nlinks from 0 to 1<br>
&gt; would have reset inode 707893 nlinks from 0 to 1<br>
&gt; would have reset inode 716853 nlinks from 0 to 1<br>
&gt; would have reset inode 722229 nlinks from 0 to 1<br>
&gt; would have reset inode 722741 nlinks from 0 to 1<br>
&gt; would have reset inode 723765 nlinks from 0 to 1<br>
&gt; would have reset inode 731957 nlinks from 0 to 1<br>
&gt; would have reset inode 742965 nlinks from 0 to 1<br>
&gt; would have reset inode 743477 nlinks from 0 to 1<br>
&gt; would have reset inode 745781 nlinks from 0 to 1<br>
&gt; would have reset inode 746293 nlinks from 0 to 1<br>
&gt; would have reset inode 774453 nlinks from 0 to 1<br>
&gt; would have reset inode 778805 nlinks from 0 to 1<br>
&gt; would have reset inode 785013 nlinks from 0 to 1<br>
&gt; would have reset inode 785973 nlinks from 0 to 1<br>
&gt; would have reset inode 791349 nlinks from 0 to 1<br>
&gt; would have reset inode 796981 nlinks from 0 to 1<br>
&gt; would have reset inode 803381 nlinks from 0 to 1<br>
&gt; would have reset inode 806965 nlinks from 0 to 1<br>
&gt; would have reset inode 811798 nlinks from 0 to 1<br>
&gt; would have reset inode 812310 nlinks from 0 to 1<br>
&gt; would have reset inode 813078 nlinks from 0 to 1<br>
&gt; would have reset inode 813607 nlinks from 0 to 1<br>
&gt; would have reset inode 814183 nlinks from 0 to 1<br>
&gt; would have reset inode 822069 nlinks from 0 to 1<br>
&gt; would have reset inode 828469 nlinks from 0 to 1<br>
&gt; would have reset inode 830005 nlinks from 0 to 1<br>
&gt; would have reset inode 832053 nlinks from 0 to 1<br>
&gt; would have reset inode 832565 nlinks from 0 to 1<br>
&gt; would have reset inode 836661 nlinks from 0 to 1<br>
&gt; would have reset inode 841013 nlinks from 0 to 1<br>
&gt; would have reset inode 841525 nlinks from 0 to 1<br>
&gt; would have reset inode 845365 nlinks from 0 to 1<br>
&gt; would have reset inode 846133 nlinks from 0 to 1<br>
&gt; would have reset inode 847157 nlinks from 0 to 1<br>
&gt; would have reset inode 852533 nlinks from 0 to 1<br>
&gt; would have reset inode 857141 nlinks from 0 to 1<br>
&gt; would have reset inode 863271 nlinks from 0 to 1<br>
&gt; would have reset inode 866855 nlinks from 0 to 1<br>
&gt; would have reset inode 887861 nlinks from 0 to 1<br>
&gt; would have reset inode 891701 nlinks from 0 to 1<br>
&gt; would have reset inode 894773 nlinks from 0 to 1<br>
&gt; would have reset inode 900149 nlinks from 0 to 1<br>
&gt; would have reset inode 902197 nlinks from 0 to 1<br>
&gt; would have reset inode 906293 nlinks from 0 to 1<br>
&gt; would have reset inode 906805 nlinks from 0 to 1<br>
&gt; would have reset inode 909877 nlinks from 0 to 1<br>
&gt; would have reset inode 925493 nlinks from 0 to 1<br>
&gt; would have reset inode 949543 nlinks from 0 to 1<br>
&gt; would have reset inode 955175 nlinks from 0 to 1<br>
&gt; would have reset inode 963623 nlinks from 0 to 1<br>
&gt; would have reset inode 967733 nlinks from 0 to 1<br>
&gt; would have reset inode 968231 nlinks from 0 to 1<br>
&gt; would have reset inode 982069 nlinks from 0 to 1<br>
&gt; would have reset inode 1007413 nlinks from 0 to 1<br>
&gt; would have reset inode 1011509 nlinks from 0 to 1<br>
&gt; would have reset inode 1014069 nlinks from 0 to 1<br>
&gt; would have reset inode 1014581 nlinks from 0 to 1<br>
&gt; would have reset inode 1022005 nlinks from 0 to 1<br>
&gt; would have reset inode 1022517 nlinks from 0 to 1<br>
&gt; would have reset inode 1023029 nlinks from 0 to 1<br>
&gt; would have reset inode 1025333 nlinks from 0 to 1<br>
&gt; would have reset inode 1043765 nlinks from 0 to 1<br>
&gt; would have reset inode 1044789 nlinks from 0 to 1<br>
&gt; would have reset inode 1049397 nlinks from 0 to 1<br>
&gt; would have reset inode 1050933 nlinks from 0 to 1<br>
&gt; would have reset inode 1051445 nlinks from 0 to 1<br>
&gt; would have reset inode 1054261 nlinks from 0 to 1<br>
&gt; would have reset inode 1060917 nlinks from 0 to 1<br>
&gt; would have reset inode 1063477 nlinks from 0 to 1<br>
&gt; would have reset inode 1076021 nlinks from 0 to 1<br>
&gt; would have reset inode 1081141 nlinks from 0 to 1<br>
&gt; would have reset inode 1086261 nlinks from 0 to 1<br>
&gt; would have reset inode 1097269 nlinks from 0 to 1<br>
&gt; would have reset inode 1099829 nlinks from 0 to 1<br>
&gt; would have reset inode 1100853 nlinks from 0 to 1<br>
&gt; would have reset inode 1101877 nlinks from 0 to 1<br>
&gt; would have reset inode 1126709 nlinks from 0 to 1<br>
&gt; would have reset inode 1134389 nlinks from 0 to 1<br>
&gt; would have reset inode 1141045 nlinks from 0 to 1<br>
&gt; would have reset inode 1141557 nlinks from 0 to 1<br>
&gt; would have reset inode 1142581 nlinks from 0 to 1<br>
&gt; would have reset inode 1148469 nlinks from 0 to 1<br>
&gt; would have reset inode 1153333 nlinks from 0 to 1<br>
&gt; would have reset inode 1181749 nlinks from 0 to 1<br>
&gt; would have reset inode 1192245 nlinks from 0 to 1<br>
&gt; would have reset inode 1198133 nlinks from 0 to 1<br>
&gt; would have reset inode 1203765 nlinks from 0 to 1<br>
&gt; would have reset inode 1221429 nlinks from 0 to 1<br>
&gt; would have reset inode 1223989 nlinks from 0 to 1<br>
&gt; would have reset inode 1235509 nlinks from 0 to 1<br>
&gt; would have reset inode 1239349 nlinks from 0 to 1<br>
&gt; would have reset inode 1240885 nlinks from 0 to 1<br>
&gt; would have reset inode 1241397 nlinks from 0 to 1<br>
&gt; would have reset inode 1241909 nlinks from 0 to 1<br>
&gt; would have reset inode 1242421 nlinks from 0 to 1<br>
&gt; would have reset inode 1244981 nlinks from 0 to 1<br>
&gt; would have reset inode 1246517 nlinks from 0 to 1<br>
&gt; would have reset inode 1253429 nlinks from 0 to 1<br>
&gt; would have reset inode 1271861 nlinks from 0 to 1<br>
&gt; would have reset inode 1274677 nlinks from 0 to 1<br>
&gt; would have reset inode 1277749 nlinks from 0 to 1<br>
&gt; would have reset inode 1278773 nlinks from 0 to 1<br>
&gt; would have reset inode 1286709 nlinks from 0 to 1<br>
&gt; would have reset inode 1288245 nlinks from 0 to 1<br>
&gt; would have reset inode 1299765 nlinks from 0 to 1<br>
&gt; would have reset inode 1302325 nlinks from 0 to 1<br>
&gt; would have reset inode 1304885 nlinks from 0 to 1<br>
&gt; would have reset inode 1305397 nlinks from 0 to 1<br>
&gt; would have reset inode 1307509 nlinks from 0 to 1<br>
&gt; would have reset inode 1309493 nlinks from 0 to 1<br>
&gt; would have reset inode 1310517 nlinks from 0 to 1<br>
&gt; would have reset inode 1311029 nlinks from 0 to 1<br>
&gt; would have reset inode 1312053 nlinks from 0 to 1<br>
&gt; would have reset inode 1316917 nlinks from 0 to 1<br>
&gt; would have reset inode 1317941 nlinks from 0 to 1<br>
&gt; would have reset inode 1320821 nlinks from 0 to 1<br>
&gt; would have reset inode 1322805 nlinks from 0 to 1<br>
&gt; would have reset inode 1332789 nlinks from 0 to 1<br>
&gt; would have reset inode 1336373 nlinks from 0 to 1<br>
&gt; would have reset inode 1345653 nlinks from 0 to 1<br>
&gt; would have reset inode 1354549 nlinks from 0 to 1<br>
&gt; would have reset inode 1361973 nlinks from 0 to 1<br>
&gt; would have reset inode 1369909 nlinks from 0 to 1<br>
&gt; would have reset inode 1372981 nlinks from 0 to 1<br>
&gt; would have reset inode 1388853 nlinks from 0 to 1<br>
&gt; would have reset inode 1402933 nlinks from 0 to 1<br>
&gt; would have reset inode 1403445 nlinks from 0 to 1<br>
&gt; would have reset inode 1420085 nlinks from 0 to 1<br>
&gt; would have reset inode 1452853 nlinks from 0 to 1<br>
&gt; would have reset inode 1456437 nlinks from 0 to 1<br>
&gt; would have reset inode 1457973 nlinks from 0 to 1<br>
&gt; would have reset inode 1459253 nlinks from 0 to 1<br>
&gt; would have reset inode 1467957 nlinks from 0 to 1<br>
&gt; would have reset inode 1471541 nlinks from 0 to 1<br>
&gt; would have reset inode 1476661 nlinks from 0 to 1<br>
&gt; would have reset inode 1479733 nlinks from 0 to 1<br>
&gt; would have reset inode 1483061 nlinks from 0 to 1<br>
&gt; would have reset inode 1484085 nlinks from 0 to 1<br>
&gt; would have reset inode 1486133 nlinks from 0 to 1<br>
&gt; would have reset inode 1489461 nlinks from 0 to 1<br>
&gt; would have reset inode 1490037 nlinks from 0 to 1<br>
&gt; would have reset inode 1492021 nlinks from 0 to 1<br>
&gt; would have reset inode 1493557 nlinks from 0 to 1<br>
&gt; would have reset inode 1494069 nlinks from 0 to 1<br>
&gt; would have reset inode 1496885 nlinks from 0 to 1<br>
&gt; would have reset inode 1498421 nlinks from 0 to 1<br>
&gt; would have reset inode 1498933 nlinks from 0 to 1<br>
&gt; would have reset inode 1499957 nlinks from 0 to 1<br>
&gt; would have reset inode 1506101 nlinks from 0 to 1<br>
&gt; would have reset inode 1507637 nlinks from 0 to 1<br>
&gt; would have reset inode 1510453 nlinks from 0 to 1<br>
&gt; would have reset inode 1514293 nlinks from 0 to 1<br>
&gt; would have reset inode 1517365 nlinks from 0 to 1<br>
&gt; would have reset inode 1520693 nlinks from 0 to 1<br>
&gt; would have reset inode 1521973 nlinks from 0 to 1<br>
&gt; would have reset inode 1530421 nlinks from 0 to 1<br>
&gt; would have reset inode 1530933 nlinks from 0 to 1<br>
&gt; would have reset inode 1537333 nlinks from 0 to 1<br>
&gt; would have reset inode 1538357 nlinks from 0 to 1<br>
&gt; would have reset inode 1548853 nlinks from 0 to 1<br>
&gt; would have reset inode 1553973 nlinks from 0 to 1<br>
&gt; would have reset inode 1557301 nlinks from 0 to 1<br>
&gt; would have reset inode 1564213 nlinks from 0 to 1<br>
&gt; would have reset inode 1564725 nlinks from 0 to 1<br>
&gt; would have reset inode 1576501 nlinks from 0 to 1<br>
&gt; would have reset inode 1580597 nlinks from 0 to 1<br>
&gt; would have reset inode 1584693 nlinks from 0 to 1<br>
&gt; would have reset inode 1586485 nlinks from 0 to 1<br>
&gt; would have reset inode 1589301 nlinks from 0 to 1<br>
&gt; would have reset inode 1589813 nlinks from 0 to 1<br>
&gt; would have reset inode 1592629 nlinks from 0 to 1<br>
&gt; would have reset inode 1595701 nlinks from 0 to 1<br>
&gt; would have reset inode 1601077 nlinks from 0 to 1<br>
&gt; would have reset inode 1623861 nlinks from 0 to 1<br>
&gt; would have reset inode 1626677 nlinks from 0 to 1<br>
&gt; would have reset inode 1627701 nlinks from 0 to 1<br>
&gt; would have reset inode 1633333 nlinks from 0 to 1<br>
&gt; would have reset inode 1639221 nlinks from 0 to 1<br>
&gt; would have reset inode 1649205 nlinks from 0 to 1<br>
&gt; would have reset inode 1686325 nlinks from 0 to 1<br>
&gt; would have reset inode 1690677 nlinks from 0 to 1<br>
&gt; would have reset inode 1693749 nlinks from 0 to 1<br>
&gt; would have reset inode 1704757 nlinks from 0 to 1<br>
&gt; would have reset inode 1707061 nlinks from 0 to 1<br>
&gt; would have reset inode 1709109 nlinks from 0 to 1<br>
&gt; would have reset inode 1719349 nlinks from 0 to 1<br>
&gt; would have reset inode 1737013 nlinks from 0 to 1<br>
&gt; would have reset inode 1741365 nlinks from 0 to 1<br>
&gt; would have reset inode 1747509 nlinks from 0 to 1<br>
&gt; would have reset inode 1770805 nlinks from 0 to 1<br>
&gt; would have reset inode 1780789 nlinks from 0 to 1<br>
&gt; would have reset inode 1793589 nlinks from 0 to 1<br>
&gt; would have reset inode 1795125 nlinks from 0 to 1<br>
&gt; would have reset inode 1800757 nlinks from 0 to 1<br>
&gt; would have reset inode 1801269 nlinks from 0 to 1<br>
&gt; would have reset inode 1802549 nlinks from 0 to 1<br>
&gt; would have reset inode 1804085 nlinks from 0 to 1<br>
&gt; would have reset inode 1817141 nlinks from 0 to 1<br>
&gt; would have reset inode 1821749 nlinks from 0 to 1<br>
&gt; would have reset inode 1832757 nlinks from 0 to 1<br>
&gt; would have reset inode 1836341 nlinks from 0 to 1<br>
&gt; would have reset inode 1856309 nlinks from 0 to 1<br>
&gt; would have reset inode 1900597 nlinks from 0 to 1<br>
&gt; would have reset inode 1902901 nlinks from 0 to 1<br>
&gt; would have reset inode 1912373 nlinks from 0 to 1<br>
&gt; would have reset inode 1943093 nlinks from 0 to 1<br>
&gt; would have reset inode 1944373 nlinks from 0 to 1<br>
&gt; would have reset inode 1954101 nlinks from 0 to 1<br>
&gt; would have reset inode 1955893 nlinks from 0 to 1<br>
&gt; would have reset inode 1961781 nlinks from 0 to 1<br>
&gt; would have reset inode 1974325 nlinks from 0 to 1<br>
&gt; would have reset inode 1978677 nlinks from 0 to 1<br>
&gt; would have reset inode 1981237 nlinks from 0 to 1<br>
&gt; would have reset inode 1992245 nlinks from 0 to 1<br>
&gt; would have reset inode 2000949 nlinks from 0 to 1<br>
&gt; would have reset inode 2002229 nlinks from 0 to 1<br>
&gt; would have reset inode 2004789 nlinks from 0 to 1<br>
&gt; would have reset inode 2005301 nlinks from 0 to 1<br>
&gt; would have reset inode 2011189 nlinks from 0 to 1<br>
&gt; would have reset inode 2012981 nlinks from 0 to 1<br>
&gt; would have reset inode 2015285 nlinks from 0 to 1<br>
&gt; would have reset inode 2018869 nlinks from 0 to 1<br>
&gt; would have reset inode 2028341 nlinks from 0 to 1<br>
&gt; would have reset inode 2028853 nlinks from 0 to 1<br>
&gt; would have reset inode 2030901 nlinks from 0 to 1<br>
&gt; would have reset inode 2032181 nlinks from 0 to 1<br>
&gt; would have reset inode 2032693 nlinks from 0 to 1<br>
&gt; would have reset inode 2040117 nlinks from 0 to 1<br>
&gt; would have reset inode 2053685 nlinks from 0 to 1<br>
&gt; would have reset inode 2083893 nlinks from 0 to 1<br>
&gt; would have reset inode 2087221 nlinks from 0 to 1<br>
&gt; would have reset inode 2095925 nlinks from 0 to 1<br>
&gt; would have reset inode 2098741 nlinks from 0 to 1<br>
&gt; would have reset inode 2100533 nlinks from 0 to 1<br>
&gt; would have reset inode 2101301 nlinks from 0 to 1<br>
&gt; would have reset inode 2123573 nlinks from 0 to 1<br>
&gt; would have reset inode 2132789 nlinks from 0 to 1<br>
&gt; would have reset inode 2133813 nlinks from 0 to 1<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div></div>&gt; 2013/4/10 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtao=
fu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<a href=
=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&g=
t;&gt;<br>
<div><div>&gt;<br>
&gt; &nbsp; &nbsp; The storage info is as following:<br>
&gt; &nbsp; &nbsp; RAID-6<br>
&gt; &nbsp; &nbsp; SATA HDD<br>
&gt; &nbsp; &nbsp; Controller: PERC H710P Mini (Embedded)<br>
&gt; &nbsp; &nbsp; Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes<br>
&gt; &nbsp; &nbsp; 255 heads, 63 sectors/track, 3647334 cylinders<br>
&gt; &nbsp; &nbsp; Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
&gt; &nbsp; &nbsp; Sector size (logical/physical): 512 bytes / 512 bytes<br=
>
&gt; &nbsp; &nbsp; I/O size (minimum/optimal): 512 bytes / 512 bytes<br>
&gt; &nbsp; &nbsp; Disk identifier: 0x00000000<br>
&gt;<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (=
30.0 TB/27.2<br>
&gt; &nbsp; &nbsp; TiB)<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Write Protect is off<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn&#39;t<br>
&gt; &nbsp; &nbsp; support DPO or FUA<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Attached SCSI disk<br>
&gt;<br>
&gt; &nbsp; &nbsp; *-storage<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;description: RAID bus control=
ler<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;product: MegaRAID SAS 2208 [T=
hunderbolt]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vendor: LSI Logic / Symbios L=
ogic<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;physical id: 0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bus info: pci@0000:02:00.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;logical name: scsi0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;version: 01<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;width: 64 bits<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;clock: 33MHz<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;capabilities: storage pm pcie=
xpress vpd msi msix bus_master<br>
&gt; &nbsp; &nbsp; cap_list rom<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;configuration: driver=3Dmegar=
aid_sas latency=3D0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;resources: irq:42 ioport:fc00=
(size=3D256)<br>
&gt; &nbsp; &nbsp; memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff<br>
&gt; &nbsp; &nbsp; memory:dc800000-dc81ffff(prefetchable)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*-disk:0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; description: SCSI Dis=
k<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product: PERC H710P<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.0.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.0.=
0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sd=
a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; serial: 0049d6ce1d9f2=
035180096fde490f648<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 558GiB (599GB)<=
br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; capabilities: partiti=
oned partitioned:dos<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansive=
rsion=3D5 signature=3D000aa336<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*-disk:1<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; description: SCSI Dis=
k<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product: PERC H710P<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.1.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.1.=
0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sd=
b<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /mnt/xf=
sd<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; serial: 003366f71da22=
035180096fde490f648<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 27TiB (30TB)<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansive=
rsion=3D5 mount.fstype=3Dxfs<br>
&gt; &nbsp; &nbsp; mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64=
k,sunit=3D128,swidth=3D1280,noquota<br>
&gt; &nbsp; &nbsp; state=3Dmounted<br>
&gt;<br>
&gt; &nbsp; &nbsp; Thank you.<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; 2013/4/10 Emmanuel Florac &lt;<a href=3D"mailto:eflorac@=
intellique.com" target=3D"_blank">eflorac@intellique.com</a><br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:eflorac@intelli=
que.com" target=3D"_blank">eflorac@intellique.com</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Le Tue, 9 Apr 2013 23:10:03 +0800<br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE &lt;<a href=3D"ma=
ilto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mai=
lto:<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmai=
l.com</a>&gt;&gt; =A8=A6crivait:<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &gt; Apr &nbsp;9 11:01:30 cqdx kernel=
: XFS (sdb): I/O Error Detected.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &gt; Shutting down filesystem<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; This. I/O error detected. That means that =
at some point the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; underlying<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; device (disk, RAID array, SAN volume) coul=
dn&#39;t be reached. So this<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; could very well be a case of a flakey driv=
e, array, cable or SCSI<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; driver.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; What&#39;s the storage setup here?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ------------------------------------------=
------------------------------<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Emmanuel Florac &nbsp; &nbsp; | &nbsp; Dir=
ection technique<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; Intellique<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &lt;<a href=3D"mailto:eflorac@intelliq=
ue.com" target=3D"_blank">eflorac@intellique.com</a><br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:eflorac=
@intellique.com" target=3D"_blank">eflorac@intellique.com</a>&gt;&gt;<br>
<div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; <a href=3D"tel:%2B33%201%2078%209=
4%2084%2002" value=3D"+33178948402" target=3D"_blank">+33 1 78 94 84 02</a>=
<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ------------------------------------------=
------------------------------<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
</div><div><div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--089e011831980e5b8d04da231926--


--===============1913850148657396942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1913850148657396942==--
