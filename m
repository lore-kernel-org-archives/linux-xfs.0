Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A80307F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 08:38:12 -0600 (CST)
Message-ID: <52CABFD1.70100@sgi.com>
Date: Mon, 06 Jan 2014 08:38:09 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix off-by-one error in xfs_attr3_rmt_verify
References: <52C3FBC3.3050304@oracle.com>
In-Reply-To: <52C3FBC3.3050304@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/01/14 05:28, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> With CRC check is enabled, if trying to set an attributes value just
> equal to the maximum size of XATTR_SIZE_MAX would cause the v3 remote
> attr write verification procedure failure, which would yield the back
> trace like below:
>
> <snip>
> XFS (sda7): Internal error xfs_attr3_rmt_write_verify at line 191 of file fs/xfs/xfs_attr_remote.c
> <snip>
> Call Trace:
> [<ffffffff816f0042>] dump_stack+0x45/0x56
> [<ffffffffa0d99c8b>] xfs_error_report+0x3b/0x40 [xfs]
> [<ffffffffa0d96edd>] ? _xfs_buf_ioapply+0x6d/0x390 [xfs]
> [<ffffffffa0d99ce5>] xfs_corruption_error+0x55/0x80 [xfs]
> [<ffffffffa0dbef6b>] xfs_attr3_rmt_write_verify+0x14b/0x1a0 [xfs]
> [<ffffffffa0d96edd>] ? _xfs_buf_ioapply+0x6d/0x390 [xfs]
> [<ffffffffa0d97315>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
> [<ffffffffa0d96edd>] _xfs_buf_ioapply+0x6d/0x390 [xfs]
> [<ffffffff81184cda>] ? vm_map_ram+0x31a/0x460
> [<ffffffff81097230>] ? wake_up_state+0x20/0x20
> [<ffffffffa0d97315>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
> [<ffffffffa0d9726b>] xfs_buf_iorequest+0x6b/0xc0 [xfs]
> [<ffffffffa0d97315>] xfs_bdstrat_cb+0x55/0xb0 [xfs]
> [<ffffffffa0d97906>] xfs_bwrite+0x46/0x80 [xfs]
> [<ffffffffa0dbfa94>] xfs_attr_rmtval_set+0x334/0x490 [xfs]
> [<ffffffffa0db84aa>] xfs_attr_leaf_addname+0x24a/0x410 [xfs]
> [<ffffffffa0db8893>] xfs_attr_set_int+0x223/0x470 [xfs]
> [<ffffffffa0db8b76>] xfs_attr_set+0x96/0xb0 [xfs]
> [<ffffffffa0db13b2>] xfs_xattr_set+0x42/0x70 [xfs]
> [<ffffffff811df9b2>] generic_setxattr+0x62/0x80
> [<ffffffff811e0213>] __vfs_setxattr_noperm+0x63/0x1b0
> [<ffffffff81307afe>] ? evm_inode_setxattr+0xe/0x10
> [<ffffffff811e0415>] vfs_setxattr+0xb5/0xc0
> [<ffffffff811e054e>] setxattr+0x12e/0x1c0
> [<ffffffff811c6e82>] ? final_putname+0x22/0x50
> [<ffffffff811c708b>] ? putname+0x2b/0x40
> [<ffffffff811cc4bf>] ? user_path_at_empty+0x5f/0x90
> [<ffffffff811bdfd9>] ? __sb_start_write+0x49/0xe0
> [<ffffffff81168589>] ? vm_mmap_pgoff+0x99/0xc0
> [<ffffffff811e07df>] SyS_setxattr+0x8f/0xe0
> [<ffffffff81700c2d>] system_call_fastpath+0x1a/0x1f
>
> Tests:
>      setfattr -n user.longxattr -v `perl -e 'print "A"x65536'` testfile
>
> This patch fix it to check the remote EA size is greater than the
> XATTR_SIZE_MAX rather than more than or equal to it, because it's
> valid if the specified EA value size is equal to the limitation as
> per VFS setxattr interface.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

Good catch. Are you making an edge case xfstest?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
