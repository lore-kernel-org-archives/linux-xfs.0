Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18145 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdF0AfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 20:35:12 -0400
Date: Mon, 26 Jun 2017 17:34:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 5/5] xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170627003435.GI4733@birch.djwong.org>
References: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
 <1498487118-6564-6-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498487118-6564-6-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

[adding Christoph to cc]

On Mon, Jun 26, 2017 at 04:25:18PM +0200, Andreas Gruenbacher wrote:
> Switch to the iomap_seek_hole_data vfs helper for implementing lseek
> SEEK_HOLE / SEEK_DATA.  __xfs_seek_hole_data can go away once it's no
> longer used by the quota code.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 962dafd..94fe89a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1131,29 +1131,18 @@ xfs_seek_hole_data(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint			lock;
> -	loff_t			offset, end;
> -	int			error = 0;
> +	loff_t			offset;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
>  	lock = xfs_ilock_data_map_shared(ip);
> -
> -	end = i_size_read(inode);
> -	offset = __xfs_seek_hole_data(inode, start, end, whence);
> -	if (offset < 0) {
> -		error = offset;
> -		goto out_unlock;
> -	}
> -
> -	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> -
> -out_unlock:
> +	offset = iomap_seek_hole_data(inode, start, whence, &xfs_iomap_ops);

Hm.  We grab the data map ilock above, then we call
iomap_seek_hole_data, which (eventually) calls xfs_file_iomap_begin,
which tries to grab the data map ilock.  We shouldn't be grabbing the
ilock twice, obviously, but on the other hand...

...under the old code, we'd take the ilock and do the whole block map
and page cache scans without ever dropping the ilock.  This new iomap
based thing only holds the ilock during ->iomap_begin, which makes me
worry that someone else can wander in and mess with things while we're
looking for holes/data?

--D

FWIW generic/285 blows up with this:

[ 2975.947417] run fstests generic/285 at 2017-06-26 10:13:48

[ 2976.474195] ============================================
[ 2976.474856] WARNING: possible recursive locking detected
[ 2976.475392] 4.12.0-rc6-dgc #2 Tainted: G        W      
[ 2976.475875] --------------------------------------------
[ 2976.476361] seek_sanity_tes/18280 is trying to acquire lock:
[ 2976.476874]  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa0143eb7>] xfs_ilock+0x137/0x330 [xfs]
[ 2976.478009] 
               but task is already holding lock:
[ 2976.479328]  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa0143eb7>] xfs_ilock+0x137/0x330 [xfs]
[ 2976.480506] 
               other info that might help us debug this:
[ 2976.481295]  Possible unsafe locking scenario:

[ 2976.481973]        CPU0
[ 2976.482253]        ----
[ 2976.482556]   lock(&xfs_nondir_ilock_class);
[ 2976.482960]   lock(&xfs_nondir_ilock_class);
[ 2976.483360] 
                *** DEADLOCK ***

[ 2976.486560]  May be due to missing lock nesting notation

[ 2976.487274] 1 lock held by seek_sanity_tes/18280:
[ 2976.487775]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa0143eb7>] xfs_ilock+0x137/0x330 [xfs]
[ 2976.489006] 
               stack backtrace:
[ 2976.489760] CPU: 0 PID: 18280 Comm: seek_sanity_tes Tainted: G        W       4.12.0-rc6-dgc #2
[ 2976.491308] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 2976.492907] Call Trace:
[ 2976.493422]  dump_stack+0x85/0xc7
[ 2976.494049]  __lock_acquire+0x1567/0x15c0
[ 2976.494782]  ? _raw_spin_unlock+0x31/0x50
[ 2976.495499]  lock_acquire+0xac/0x200
[ 2976.496485]  ? lock_acquire+0xac/0x200
[ 2976.497347]  ? xfs_ilock+0x137/0x330 [xfs]
[ 2976.497949]  ? xfs_ilock_data_map_shared+0x30/0x40 [xfs]
[ 2976.498799]  down_read_nested+0x49/0xb0
[ 2976.499414]  ? xfs_ilock+0x137/0x330 [xfs]
[ 2976.500153]  xfs_ilock+0x137/0x330 [xfs]
[ 2976.503377]  xfs_ilock_data_map_shared+0x30/0x40 [xfs]
[ 2976.504281]  xfs_file_iomap_begin+0x8e/0xd40 [xfs]
[ 2976.504981]  ? xfs_iunlock+0x2ab/0x310 [xfs]
[ 2976.505630]  ? xfs_ilock+0x137/0x330 [xfs]
[ 2976.506198]  iomap_apply+0x48/0xe0
[ 2976.506760]  iomap_seek_hole_data+0xa6/0x100
[ 2976.507510]  ? iomap_to_fiemap+0x80/0x80
[ 2976.508163]  xfs_seek_hole_data+0x6a/0xb0 [xfs]
[ 2976.508903]  xfs_file_llseek+0x1c/0x30 [xfs]
[ 2976.509497]  SyS_lseek+0x8d/0xb0
[ 2976.509936]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[ 2976.510622] RIP: 0033:0x7f43f2468b67
[ 2976.511162] RSP: 002b:00007ffd07380e58 EFLAGS: 00000202 ORIG_RAX: 0000000000000008
[ 2976.512312] RAX: ffffffffffffffda RBX: 00007f43f2452b20 RCX: 00007f43f2468b67
[ 2976.513448] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000004
[ 2976.514769] RBP: 0000000000001011 R08: 0000000000000000 R09: 0000000000000016
[ 2976.515995] R10: 00000000000000c2 R11: 0000000000000202 R12: 00007f43f2452b78
[ 2976.517290] R13: 00007f43f2452b78 R14: 0000000000002710 R15: 0000000000403e26
[ 2976.733289] XFS (pmem1): Unmounting Filesystem
[ 2976.850354] XFS (pmem1): Mounting V4 Filesystem
[ 2976.856274] XFS (pmem1): Ending clean mount


>  	xfs_iunlock(ip, lock);
>  
> -	if (error)
> -		return error;
> -	return offset;
> +	if (offset < 0)
> +		return offset;
> +	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
>  }
>  
>  STATIC loff_t
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
