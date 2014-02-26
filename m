Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E3AE7F37
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 00:00:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 242E3304089
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 22:00:52 -0800 (PST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	AiBYri2kFE8YIlOg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 22:00:49 -0800 (PST)
Received: by mail-qc0-f171.google.com with SMTP id x3so694827qcv.30
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 22:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393355679-11160-6-git-send-email-lczerner@redhat.com>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
	<1393355679-11160-6-git-send-email-lczerner@redhat.com>
Date: Wed, 26 Feb 2014 01:00:48 -0500
Message-ID: <CAGW2f1G_HjhVXc9jyNEAaX8VUaZov7qaRVuj+KvnbbqvtL0k3g@mail.gmail.com>
Subject: Re: [PATCH 5/6 v2] ext4: Introduce FALLOC_FL_ZERO_RANGE flag for
	fallocate
From: jon ernst <jonernst07@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 2:14 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
>
> It can be used to convert a range of file to zeros preferably without
> issuing data IO. Blocks should be preallocated for the regions that span
> holes in the file, and the entire range is preferable converted to
> unwritten extents
>
> This can be also used to preallocate blocks past EOF in the same way as
> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> size to remain the same.
>
> Also add appropriate tracepoints.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/ext4.h              |   2 +
>  fs/ext4/extents.c           | 270 +++++++++++++++++++++++++++++++++++++++++---
>  fs/ext4/inode.c             |  17 ++-
>  include/trace/events/ext4.h |  64 +++++------
>  4 files changed, 300 insertions(+), 53 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3b9601c..a649abe 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -568,6 +568,8 @@ enum {
>  #define EXT4_GET_BLOCKS_NO_LOCK                        0x0100
>         /* Do not put hole in extent cache */
>  #define EXT4_GET_BLOCKS_NO_PUT_HOLE            0x0200
> +       /* Convert written extents to unwritten */
> +#define EXT4_GET_BLOCKS_CONVERT_UNWRITTEN      0x0400
>
>  /*
>   * The bit position of these flags must not overlap with any of the
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e5485eb..017b4fb 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3568,6 +3568,8 @@ out:
>   *   b> Splits in two extents: Write is happening at either end of the extent
>   *   c> Splits in three extents: Somone is writing in middle of the extent
>   *
> + * This works the same way in the case of initialized -> unwritten conversion.
> + *
>   * One of more index blocks maybe needed if the extent tree grow after
>   * the uninitialized extent split. To prevent ENOSPC occur at the IO
>   * complete, we need to split the uninitialized extent before DIO submit
> @@ -3578,7 +3580,7 @@ out:
>   *
>   * Returns the size of uninitialized extent to be written on success.
>   */
> -static int ext4_split_unwritten_extents(handle_t *handle,
> +static int ext4_split_convert_extents(handle_t *handle,
>                                         struct inode *inode,
>                                         struct ext4_map_blocks *map,
>                                         struct ext4_ext_path *path,
> @@ -3590,9 +3592,9 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>         unsigned int ee_len;
>         int split_flag = 0, depth;
>
> -       ext_debug("ext4_split_unwritten_extents: inode %lu, logical"
> -               "block %llu, max_blocks %u\n", inode->i_ino,
> -               (unsigned long long)map->m_lblk, map->m_len);
> +       ext_debug("%s: inode %lu, logical block %llu, max_blocks %u\n",
> +                 __func__, inode->i_ino,
> +                 (unsigned long long)map->m_lblk, map->m_len);
>
>         eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
>                 inode->i_sb->s_blocksize_bits;
> @@ -3607,14 +3609,73 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>         ee_block = le32_to_cpu(ex->ee_block);
>         ee_len = ext4_ext_get_actual_len(ex);
>
> -       split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
> -       split_flag |= EXT4_EXT_MARK_UNINIT2;
> -       if (flags & EXT4_GET_BLOCKS_CONVERT)
> -               split_flag |= EXT4_EXT_DATA_VALID2;
> +       /* Convert to unwritten */
> +       if (flags | EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
> +               split_flag |= EXT4_EXT_DATA_VALID1;
> +       /* Convert to initialized */
> +       } else if (flags | EXT4_GET_BLOCKS_CONVERT) {
> +               split_flag |= ee_block + ee_len <= eof_block ?
> +                             EXT4_EXT_MAY_ZEROOUT : 0;
> +               split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
> +       }
>         flags |= EXT4_GET_BLOCKS_PRE_IO;
>         return ext4_split_extent(handle, inode, path, map, split_flag, flags);
>  }
>
> +static int ext4_convert_initialized_extents(handle_t *handle,
> +                                           struct inode *inode,
> +                                           struct ext4_map_blocks *map,
> +                                           struct ext4_ext_path *path)
> +{
> +       struct ext4_extent *ex;
> +       ext4_lblk_t ee_block;
> +       unsigned int ee_len;
> +       int depth;
> +       int err = 0;
> +
> +       depth = ext_depth(inode);
> +       ex = path[depth].p_ext;
> +       ee_block = le32_to_cpu(ex->ee_block);
> +       ee_len = ext4_ext_get_actual_len(ex);
> +
> +       ext_debug("%s: inode %lu, logical"
> +               "block %llu, max_blocks %u\n", __func__, inode->i_ino,
> +                 (unsigned long long)ee_block, ee_len);
> +
> +       if (ee_block != map->m_lblk || ee_len > map->m_len) {
> +               err = ext4_split_convert_extents(handle, inode, map, path,
> +                               EXT4_GET_BLOCKS_CONVERT_UNWRITTEN);
> +               if (err < 0)
> +                       goto out;
> +               ext4_ext_drop_refs(path);
> +               path = ext4_ext_find_extent(inode, map->m_lblk, path, 0);
> +               if (IS_ERR(path)) {
> +                       err = PTR_ERR(path);
> +                       goto out;
> +               }
> +               depth = ext_depth(inode);
> +               ex = path[depth].p_ext;
> +       }
> +
> +       err = ext4_ext_get_access(handle, inode, path + depth);
> +       if (err)
> +               goto out;
> +       /* first mark the extent as uninitialized */
> +       ext4_ext_mark_uninitialized(ex);
> +
> +       /* note: ext4_ext_correct_indexes() isn't needed here because
> +        * borders are not changed
> +        */
> +       ext4_ext_try_to_merge(handle, inode, path, ex);
> +
> +       /* Mark modified extent as dirty */
> +       err = ext4_ext_dirty(handle, inode, path + path->p_depth);
> +out:
> +       ext4_ext_show_leaf(inode, path);
> +       return err;
> +}
> +
> +
>  static int ext4_convert_unwritten_extents_endio(handle_t *handle,
>                                                 struct inode *inode,
>                                                 struct ext4_map_blocks *map,
> @@ -3648,8 +3709,8 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
>                              inode->i_ino, (unsigned long long)ee_block, ee_len,
>                              (unsigned long long)map->m_lblk, map->m_len);
>  #endif
> -               err = ext4_split_unwritten_extents(handle, inode, map, path,
> -                                                  EXT4_GET_BLOCKS_CONVERT);
> +               err = ext4_split_convert_extents(handle, inode, map, path,
> +                                                EXT4_GET_BLOCKS_CONVERT);
>                 if (err < 0)
>                         goto out;
>                 ext4_ext_drop_refs(path);
> @@ -3850,6 +3911,42 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
>  }
>
>  static int
> +ext4_ext_convert_initialized_extent(handle_t *handle, struct inode *inode,
> +                       struct ext4_map_blocks *map,
> +                       struct ext4_ext_path *path, int flags,
> +                       unsigned int allocated, ext4_fsblk_t newblock)
> +{
> +       int ret = 0;
> +       int err = 0;
> +
> +       /*
> +        * Make sure that the extent is no bigger than we support with
> +        * uninitialized extent
> +        */
> +       if (map->m_len > EXT_UNINIT_MAX_LEN)
> +               map->m_len = EXT_UNINIT_MAX_LEN / 2;

Pardon my possible dumb question. Why do you use  "EXT_UNINIT_MAX_LEN
/ 2;" here instead of "EXT_UNINIT_MAX_LEN"
I don't see the reason why we can't use EXT_UNINIT_MAX_LEN here.




Thanks!
Jon


> +
> +       ret = ext4_convert_initialized_extents(handle, inode, map,
> +                                               path);
> +       if (ret >= 0) {
> +               ext4_update_inode_fsync_trans(handle, inode, 1);
> +               err = check_eofblocks_fl(handle, inode, map->m_lblk,
> +                                        path, map->m_len);
> +       } else
> +               err = ret;
> +       map->m_flags |= EXT4_MAP_UNWRITTEN;
> +       if (allocated > map->m_len)
> +               allocated = map->m_len;
> +       map->m_len = allocated;
> +
> +       if (path) {
> +               ext4_ext_drop_refs(path);
> +               kfree(path);
> +       }
> +       return err ? err : allocated;
> +}
> +
> +static int
>  ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>                         struct ext4_map_blocks *map,
>                         struct ext4_ext_path *path, int flags,
> @@ -3876,8 +3973,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>
>         /* get_block() before submit the IO, split the extent */
>         if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> -               ret = ext4_split_unwritten_extents(handle, inode, map,
> -                                                  path, flags);
> +               ret = ext4_split_convert_extents(handle, inode, map,
> +                                        path, flags | EXT4_GET_BLOCKS_CONVERT);
>                 if (ret <= 0)
>                         goto out;
>                 /*
> @@ -4168,6 +4265,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>                 ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>                 unsigned short ee_len;
>
> +
>                 /*
>                  * Uninitialized extents are treated as holes, except that
>                  * we split out initialized portions during a write.
> @@ -4184,7 +4282,17 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>                         ext_debug("%u fit into %u:%d -> %llu\n", map->m_lblk,
>                                   ee_block, ee_len, newblock);
>
> -                       if (!ext4_ext_is_uninitialized(ex))
> +                       /*
> +                        * If the extent is initialized check whether the
> +                        * caller wants to convert it to unwritten.
> +                        */
> +                       if ((!ext4_ext_is_uninitialized(ex)) &&
> +                           (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
> +                               allocated = ext4_ext_convert_initialized_extent(
> +                                               handle, inode, map, path, flags,
> +                                               allocated, newblock);
> +                               goto out3;
> +                       } else if (!ext4_ext_is_uninitialized(ex))
>                                 goto out;
>
>                         allocated = ext4_ext_handle_uninitialized_extents(
> @@ -4570,6 +4678,136 @@ retry:
>         return ret > 0 ? ret2 : ret;
>  }
>
> +static long ext4_zero_range(struct file *file, loff_t offset,
> +                           loff_t len, int mode)
> +{
> +       struct inode *inode = file_inode(file);
> +       handle_t *handle = NULL;
> +       unsigned int max_blocks;
> +       loff_t new_size = 0;
> +       int ret = 0;
> +       int flags;
> +       int partial;
> +       loff_t start, end;
> +       ext4_lblk_t lblk;
> +       struct address_space *mapping = inode->i_mapping;
> +       unsigned int blkbits = inode->i_blkbits;
> +
> +       trace_ext4_zero_range(inode, offset, len, mode);
> +
> +       /*
> +        * Write out all dirty pages to avoid race conditions
> +        * Then release them.
> +        */
> +       if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +               ret = filemap_write_and_wait_range(mapping, offset,
> +                                                  offset + len - 1);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       /*
> +        * Round up offset. This is not fallocate, we neet to zero out
> +        * blocks, so convert interior block aligned part of the range to
> +        * unwritten and possibly manually zero out unaligned parts of the
> +        * range.
> +        */
> +       start = round_up(offset, 1 << blkbits);
> +       end = round_down((offset + len), 1 << blkbits);
> +
> +       if (start < offset || end > offset + len)
> +               return -EINVAL;
> +       partial = (offset + len) & ((1 << blkbits) - 1);
> +
> +       lblk = start >> blkbits;
> +       max_blocks = (end >> blkbits);
> +       if (max_blocks < lblk)
> +               max_blocks = 0;
> +       else
> +               max_blocks -= lblk;
> +
> +       flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
> +               EXT4_GET_BLOCKS_CONVERT_UNWRITTEN;
> +       if (mode & FALLOC_FL_KEEP_SIZE)
> +               flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
> +
> +       mutex_lock(&inode->i_mutex);
> +
> +       /*
> +        * Indirect files do not support unwritten extnets
> +        */
> +       if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> +               ret = -EOPNOTSUPP;
> +               goto out_mutex;
> +       }
> +
> +       if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +            offset + len > i_size_read(inode)) {
> +               new_size = offset + len;
> +               ret = inode_newsize_ok(inode, new_size);
> +               if (ret)
> +                       goto out_mutex;
> +               /*
> +                * If we have a partial block after EOF we have to allocate
> +                * the entire block.
> +                */
> +               if (partial)
> +                       max_blocks += 1;
> +       }
> +
> +       if (max_blocks > 0) {
> +
> +               /* Now release the pages and zero block aligned part of pages*/
> +               truncate_pagecache_range(inode, start, end - 1);
> +
> +               /* Wait all existing dio workers, newcomers will block on i_mutex */
> +               ext4_inode_block_unlocked_dio(inode);
> +               inode_dio_wait(inode);
> +
> +               /*
> +                * Remove entire range from the extent status tree.
> +                */
> +               ret = ext4_es_remove_extent(inode, lblk, max_blocks);
> +               if (ret)
> +                       goto out_dio;
> +
> +               ret = ext4_alloc_file_blocks(file, lblk, max_blocks, flags,
> +                                            mode);
> +               if (ret)
> +                       goto out_dio;
> +       }
> +
> +       handle = ext4_journal_start(inode, EXT4_HT_MISC, 4);
> +       if (IS_ERR(handle)) {
> +               ret = PTR_ERR(handle);
> +               ext4_std_error(inode->i_sb, ret);
> +               goto out_dio;
> +       }
> +
> +       inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> +
> +       if (!ret && new_size) {
> +               if (new_size > i_size_read(inode))
> +                       i_size_write(inode, new_size);
> +               if (new_size > EXT4_I(inode)->i_disksize)
> +                       ext4_update_i_disksize(inode, new_size);
> +       }
> +       ext4_mark_inode_dirty(handle, inode);
> +
> +       /* Zero out partial block at the edges of the range */
> +       ret = ext4_zero_partial_blocks(handle, inode, offset, len);
> +
> +       if (file->f_flags & O_SYNC)
> +               ext4_handle_sync(handle);
> +
> +       ext4_journal_stop(handle);
> +out_dio:
> +       ext4_inode_resume_unlocked_dio(inode);
> +out_mutex:
> +       mutex_unlock(&inode->i_mutex);
> +       return ret;
> +}
> +
>  /*
>   * preallocate space for a file. This implements ext4's fallocate file
>   * operation, which gets called from sys_fallocate system call.
> @@ -4590,7 +4828,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>         unsigned int blkbits = inode->i_blkbits;
>
>         /* Return error if mode is not supported */
> -       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +                    FALLOC_FL_ZERO_RANGE))
>                 return -EOPNOTSUPP;
>
>         if (mode & FALLOC_FL_PUNCH_HOLE)
> @@ -4607,6 +4846,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>         if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>                 return -EOPNOTSUPP;
>
> +       if (mode & FALLOC_FL_ZERO_RANGE)
> +               return ext4_zero_range(file, offset, len, mode);
> +
>         trace_ext4_fallocate_enter(inode, offset, len, mode);
>         lblk = offset >> blkbits;
>         /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6e39895..e64807f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -503,6 +503,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  {
>         struct extent_status es;
>         int retval;
> +       int ret = 0;
>  #ifdef ES_AGGRESSIVE_TEST
>         struct ext4_map_blocks orig_map;
>
> @@ -552,7 +553,6 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>                                              EXT4_GET_BLOCKS_KEEP_SIZE);
>         }
>         if (retval > 0) {
> -               int ret;
>                 unsigned int status;
>
>                 if (unlikely(retval != map->m_len)) {
> @@ -579,7 +579,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>
>  found:
>         if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> -               int ret = check_block_validity(inode, map);
> +               ret = check_block_validity(inode, map);
>                 if (ret != 0)
>                         return ret;
>         }
> @@ -596,7 +596,13 @@ found:
>          * with buffer head unmapped.
>          */
>         if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
> -               return retval;
> +               /*
> +                * If we need to convert extent to unwritten
> +                * we continue and do the actual work in
> +                * ext4_ext_map_blocks()
> +                */
> +               if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
> +                       return retval;
>
>         /*
>          * Here we clear m_flags because after allocating an new extent,
> @@ -652,7 +658,6 @@ found:
>                 ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
>
>         if (retval > 0) {
> -               int ret;
>                 unsigned int status;
>
>                 if (unlikely(retval != map->m_len)) {
> @@ -687,7 +692,7 @@ found:
>  has_zeroout:
>         up_write((&EXT4_I(inode)->i_data_sem));
>         if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> -               int ret = check_block_validity(inode, map);
> +               ret = check_block_validity(inode, map);
>                 if (ret != 0)
>                         return ret;
>         }
> @@ -3501,7 +3506,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>         if (!S_ISREG(inode->i_mode))
>                 return -EOPNOTSUPP;
>
> -       trace_ext4_punch_hole(inode, offset, length);
> +       trace_ext4_punch_hole(inode, offset, length, 0);
>
>         /*
>          * Write out all dirty pages to avoid race conditions
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 451e020..7bb26aa 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -71,7 +71,8 @@ struct extent_status;
>  #define show_falloc_mode(mode) __print_flags(mode, "|",                \
>         { FALLOC_FL_KEEP_SIZE,          "KEEP_SIZE"},           \
>         { FALLOC_FL_PUNCH_HOLE,         "PUNCH_HOLE"},          \
> -       { FALLOC_FL_NO_HIDE_STALE,      "NO_HIDE_STALE"})
> +       { FALLOC_FL_NO_HIDE_STALE,      "NO_HIDE_STALE"},       \
> +       { FALLOC_FL_ZERO_RANGE,         "ZERO_RANGE"})
>
>
>  TRACE_EVENT(ext4_free_inode,
> @@ -1333,7 +1334,7 @@ TRACE_EVENT(ext4_direct_IO_exit,
>                   __entry->rw, __entry->ret)
>  );
>
> -TRACE_EVENT(ext4_fallocate_enter,
> +DECLARE_EVENT_CLASS(ext4__fallocate_mode,
>         TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
>
>         TP_ARGS(inode, offset, len, mode),
> @@ -1341,23 +1342,45 @@ TRACE_EVENT(ext4_fallocate_enter,
>         TP_STRUCT__entry(
>                 __field(        dev_t,  dev                     )
>                 __field(        ino_t,  ino                     )
> -               __field(        loff_t, pos                     )
> -               __field(        loff_t, len                     )
> +               __field(        loff_t, offset                  )
> +               __field(        loff_t, len                     )
>                 __field(        int,    mode                    )
>         ),
>
>         TP_fast_assign(
>                 __entry->dev    = inode->i_sb->s_dev;
>                 __entry->ino    = inode->i_ino;
> -               __entry->pos    = offset;
> +               __entry->offset = offset;
>                 __entry->len    = len;
>                 __entry->mode   = mode;
>         ),
>
> -       TP_printk("dev %d,%d ino %lu pos %lld len %lld mode %s",
> +       TP_printk("dev %d,%d ino %lu offset %lld len %lld mode %s",
>                   MAJOR(__entry->dev), MINOR(__entry->dev),
> -                 (unsigned long) __entry->ino, __entry->pos,
> -                 __entry->len, show_falloc_mode(__entry->mode))
> +                 (unsigned long) __entry->ino,
> +                 __entry->offset, __entry->len,
> +                 show_falloc_mode(__entry->mode))
> +);
> +
> +DEFINE_EVENT(ext4__fallocate_mode, ext4_fallocate_enter,
> +
> +       TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
> +
> +       TP_ARGS(inode, offset, len, mode)
> +);
> +
> +DEFINE_EVENT(ext4__fallocate_mode, ext4_punch_hole,
> +
> +       TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
> +
> +       TP_ARGS(inode, offset, len, mode)
> +);
> +
> +DEFINE_EVENT(ext4__fallocate_mode, ext4_zero_range,
> +
> +       TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
> +
> +       TP_ARGS(inode, offset, len, mode)
>  );
>
>  TRACE_EVENT(ext4_fallocate_exit,
> @@ -1389,31 +1412,6 @@ TRACE_EVENT(ext4_fallocate_exit,
>                   __entry->ret)
>  );
>
> -TRACE_EVENT(ext4_punch_hole,
> -       TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
> -
> -       TP_ARGS(inode, offset, len),
> -
> -       TP_STRUCT__entry(
> -               __field(        dev_t,  dev                     )
> -               __field(        ino_t,  ino                     )
> -               __field(        loff_t, offset                  )
> -               __field(        loff_t, len                     )
> -       ),
> -
> -       TP_fast_assign(
> -               __entry->dev    = inode->i_sb->s_dev;
> -               __entry->ino    = inode->i_ino;
> -               __entry->offset = offset;
> -               __entry->len    = len;
> -       ),
> -
> -       TP_printk("dev %d,%d ino %lu offset %lld len %lld",
> -                 MAJOR(__entry->dev), MINOR(__entry->dev),
> -                 (unsigned long) __entry->ino,
> -                 __entry->offset, __entry->len)
> -);
> -
>  TRACE_EVENT(ext4_unlink_enter,
>         TP_PROTO(struct inode *parent, struct dentry *dentry),
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
