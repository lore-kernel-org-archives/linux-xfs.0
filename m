Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 045A47FA7
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 08:14:12 -0600 (CST)
Message-ID: <53075F34.7010703@sgi.com>
Date: Fri, 21 Feb 2014 08:14:12 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS Failed to recover EFIs - XFS_WANT_CORRUPTED_GOTO at line
	1602 of xfs_alloc.c
References: <20140221084717.3364a23e@pluto>
In-Reply-To: <20140221084717.3364a23e@pluto>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 02/21/14 01:47, Bruno Pr=E9mont wrote:
> Hi,
>
> A virtual server of mine stopped working properly yesterday because one
> partition became corrupted (or corruption has been stumbled over).
>
>
> Restarting the system any attempt to mount that partition (without
> -o norecovery,ro) results in the following trace (transcribed):
> XFS (sda5): Mounting Filesystem
> XFS (sda5): Starting recovery (logdev: internal)
> XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file
>       /var/cache/kernel/linux-git/fs/xfs/xfs_alloc.c. Caller
> 0xffffffff8116d926
> CPU: 0 PID: 606 Commm: mount Not tainted 3.13.0-hetzner #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>   000000000002eb84 ffff88001dc53ab8 ffffffff813ca339 ffff88001dc53ad8
>   ffffffff81156d4a ffffffff8116d926 00000000000002a8 ffff88001dc53b68
>   ffffffff8116b8dd ffff88001dd7ccc0 0000000000000000 0000000000000001
> Call Trace:
>   [<ffffffff813ca339>] dump_stack+0x19/0x1b
>   [<ffffffff81156d4a>] xfs_error_report+0x3a0x40
>   [<ffffffff8116d926>] ? xfs_free_extent+0xd6/0x120
>   [<ffffffff8116b8dd>] xfs_free_ag_extent+0x48d/0x5c0
>   [<ffffffff8116d926>] xfs_free_extent+0xd6/0x120
>   [<ffffffff810d5fa4>] ? kmem_cache_alloc+0xa4/0xb0
>   [<ffffffff8119c390>] xlog_recover_process_efi+0x170/0x1b0
>   [<ffffffff81074709>] ? wake_up_bit+0x29/0x40
>   [<ffffffff8119d106>] xlog_recover_process_efis.isra.27+0x46/0x80
>   [<ffffffff811a17c5>] xlog_recover_finish+0x2c/0x50
>   [<ffffffff811a5c4c>] xfs_log_mount_finish+0x2c/0x50
>   [<ffffffff811958ee>] ? xfs_iunlock+0x6e/0x90
>   [<ffffffff81164733>] xfs_mountfs+0x473/0x690
>   [<ffffffff81167072>] xfs_fs_fill_super+0x292/0x310
>   [<ffffffff810e7a61>] mount_bdev+0x191/0x1d0
>   [<ffffffff811e337c>] ? ida_get_new_above+0x21c/0x290
>   [<ffffffff81166de0>] ? xfs_parseargs+0xc10/0xc10
>   [<ffffffff81165310>] xfs_fs_mount+0x10/0x20
>   [<ffffffff810e7cab>] mount_fs+0x1b/0xd0
>   [<ffffffff811001ad>] vfs_kern_mount+0x6d/0x100
>   [<ffffffff811019bb>] do_mount+0x1fb/0x9d0
>   [<ffffffff810b3b43>] ? strndup_user+0x53/0x70
>   [<ffffffff81102469>] SyS_mount+0x89/0xd0
>   [<ffffffff831ce4b7>] system_call_fastpath+0x16/0x1b
> XFS (sda5): Failed to recover EFIs
> XFS (sda5): log mount finish failed

curious on which version of Linux hit this problem?

>
>
> After that the mount process remains in D state and any attempt to
> xfs_repair that fileysystem blocks (reboot needed to do anything).
>
> Is that expected or should the mount either completely fail, returning
> proper error to mount and leave system in a state as if the mount had
> never been attempted (except for the log messages)?

The xfs_ail_push_all_sync() is hanging because the EFI was not and will =

not be removed. There is a patch for this problem, but is waiting for a =

similar issue in xlog_cil_push() that would change the recovery patch.
>
>
>> From the cause of this, I guess it's some left-over of "unclean"
> live migration of the KVM guest this system is running on some longer
> time ago. After live migration some processes started dying weird
> deaths. Rebooting the system worked fine by the time though.
>
> The only major load on that system (not so heavy, about 10-20 IO-ops
> per second on average, mostly writes) is updating RRD files and
> running a slave MySQL (InnoDB) database.
>
> I recovered the filesystem with xfs_repair -L /dev/sda5 though the
> InnoDB state remaining is rather broken.
> xfs_repair reported only claimed free space issues (I didn't save its
> output).
>
> Bruno
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
