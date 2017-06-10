Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35932 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbdFJF1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2017 01:27:08 -0400
Date: Sat, 10 Jun 2017 06:27:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT
Message-ID: <20170610052703.GC6365@ZenIV.linux.org.uk>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170606111939.27272-5-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606111939.27272-5-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, Jun 06, 2017 at 06:19:33AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> RWF_NOWAIT informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
> 
> The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
> is called by most filesystems, either through fsops.write_iter() or through
> the function defined by write_iter(). If not, we perform the check defined
> by .write_iter() which is called for direct IO specifically.
> 
> Filesystems xfs, btrfs and ext4 would be supported in the following patches.

Umm...  What about ->write_iter() instances outside of fs/*?  Even in fs/*,
consider e.g.
int cifs_get_writer(struct cifsInodeInfo *cinode)
{
        int rc;

start:
        rc = wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK,
                         TASK_KILLABLE);

and cifs_file_write_iter() calling it before going to generic_file_write_iter().
Ditto for cifs_struct_writev()...  coda_file_write_iter() does inode_lock()
before calling vfs_iter_write().  ext2_dax_write_iter(): inode_lock().
f2fs_file_write_iter(): ditto.  fuse_file_write_iter(): ditto in case when
->writeback_cache is false.  gfs2 is O_APPEND case: almost certainly blocks.
ncp_file_write_iter(): blocks (mutex_lock(&NCP_FINFO(inode)->open_mutex)
in ncp_make_open(), not to mention anything else). ntfs_file_write_iter():
inode_lock().  orangefs_file_write_iter(): ditto.  ubifs_write_iter():
may block in update_mctime().  udf_file_write_iter(): inode_lock().

Lustre sure as hell does block before it gets anywhere near mm/filemap.c.

And that - just from looking at regular files.  Then we have sockets and
pipes, not to mention weird stuff like fs/fuse/cuse.c, etc.
