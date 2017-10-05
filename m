Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:53191 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdJEKxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 06:53:54 -0400
Received: by mail-wm0-f48.google.com with SMTP id k4so1372626wmc.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2017 03:53:53 -0700 (PDT)
From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <jg@lightnvm.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3D47C07D-E4B9-45AC-9729-12E9FC346D1D";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Circular locking dependency with pblk
Message-Id: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
Date: Thu, 5 Oct 2017 12:53:50 +0200
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: darrick.wong@oracle.com, Christoph Hellwig <hch@infradead.org>


--Apple-Mail=_3D47C07D-E4B9-45AC-9729-12E9FC346D1D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi,

lockdep is reporting a circular dependency when using XFS and pblk,
which I am a bit confused about.

This happens when XFS sends a number of nested reads and (at least) one
of them hits partially pblk's cache. In this case, pblk will retrieve
the cached lbas and form a new bio, which is submitted _synchronously_
to the media using struct completion. The original bio is then populated
with the read data.

What lockdep complains about, is that the unlocking operation in
complete() has a circular dependency with ionode->i_rwsem when they both
happen on the same core, which is different from the core that issued
wait_for_completion_io_timeout() and is waiting for the partial read.
However, AFAIU complete() happens in interrupt context, so this should
not be a problem.

The only thing I can think of is that XFS is making an assumption when
submitting direct I/O that there will be no synchronous I/O coming from
anybody underneath.

Any thoughts?

TRACE:
[ 8557.938336] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 8557.944513] WARNING: possible circular locking dependency detected
[ 8557.950688] 4.14.0-rc2--509811f1f2df #726 Not tainted
[ 8557.955739] ------------------------------------------------------
[ 8557.961919] rocksdb:bg11/19129 is trying to acquire lock:
[ 8557.967319]  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] =
xfs_ilock+0x1a1/0x230
[ 8557.975063]
               but now in release context of a crosslock acquired at the =
following:
[ 8557.983921]  ((complete)&wait#5){+.+.}, at: [<ffffffffad933d0a>] =
pblk_fill_partial_read_bio+0x22a/0x520
[ 8557.993318]
               which lock already depends on the new lock.

[ 8558.001490]
               the existing dependency chain (in reverse order) is:
[ 8558.008966]
               -> #1 ((complete)&wait#5){+.+.}:
[ 8558.014715]        __lock_acquire+0x1186/0x11d0
[ 8558.019245]        lock_acquire+0xed/0x1e0
[ 8558.023337]        wait_for_completion_io_timeout+0x65/0x180
[ 8558.028989]        pblk_fill_partial_read_bio+0x22a/0x520
[ 8558.034375]        pblk_submit_read+0x158/0x3a0
[ 8558.038900]        pblk_make_rq+0xc1/0x110
[ 8558.042992]        generic_make_request+0x11d/0x3c0
[ 8558.047862]        submit_bio+0x73/0x140
[ 8558.051781]        iomap_dio_actor+0x1f8/0x3a0
[ 8558.056216]        iomap_apply+0xa1/0x110
[ 8558.060220]        iomap_dio_rw+0x26f/0x3c0
[ 8558.064398]        xfs_file_dio_aio_read+0x88/0x1c0
[ 8558.069269]        xfs_file_read_iter+0xab/0xc0
[ 8558.073794]        __vfs_read+0xef/0x160
[ 8558.077709]        vfs_read+0xa8/0x150
[ 8558.081454]        SyS_pread64+0x98/0xc0
[ 8558.085372]        entry_SYSCALL_64_fastpath+0x23/0xc2
[ 8558.090501]
               -> #0 (&inode->i_rwsem){++++}:
[ 8558.096067]        down_read_nested+0x49/0x70
[ 8558.100417]        xfs_ilock+0x1a1/0x230
[ 8558.104335]        xfs_file_dio_aio_read+0x74/0x1c0
[ 8558.109202]        xfs_file_read_iter+0xab/0xc0
[ 8558.113729]        __vfs_read+0xef/0x160
[ 8558.117646]
               other info that might help us debug this:

[ 8558.125636]  Possible unsafe locking scenario by crosslock:

[ 8558.132672]        CPU0                    CPU1
[ 8558.137196]        ----                    ----
[ 8558.141720]   lock(&inode->i_rwsem);
[ 8558.145291]   lock((complete)&wait#5);
[ 8558.149035]                                lock(&inode->i_rwsem);
[ 8558.155118]                                unlock((complete)&wait#5);
[ 8558.161550]
                *** DEADLOCK ***

[ 8558.167461] 4 locks held by rocksdb:bg11/19129:
[ 8558.171984]  #0:  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] =
xfs_ilock+0x1a1/0x230
[ 8558.180148]  #1:  (rcu_read_lock){....}, at: [<ffffffffad72b8cc>] =
__blk_mq_run_hw_queue+0xec/0x1d0
[ 8558.189091]  #2:  (&(&nvmeq->q_lock)->rlock){-.-.}, at: =
[<ffffffffad9d438c>] nvme_queue_rq+0x14c/0x9a0
[ 8558.198384]  #3:  (&x->wait#17){-.-.}, at: [<ffffffffad16444d>] =
complete+0x1d/0x60
[ 8558.205948]
               stack backtrace:
[ 8558.210300] CPU: 6 PID: 19129 Comm: rocksdb:bg11 Not tainted =
4.14.0-rc2--509811f1f2df #726
[ 8558.218550] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a =
06/23/2016
[ 8558.225675] Call Trace:
[ 8558.228123]  dump_stack+0x85/0xc7
[ 8558.231438]  print_circular_bug+0x226/0x330
[ 8558.235616]  ? print_bfs_bug+0x40/0x40
[ 8558.239358]  check_prev_add+0x432/0x840
[ 8558.243190]  ? __lock_acquire+0x736/0x11d0
[ 8558.247282]  lock_commit_crosslock+0x3d3/0x5d0
[ 8558.251718]  ? lock_commit_crosslock+0x3d3/0x5d0
[ 8558.256328]  complete+0x29/0x60
[ 8558.259469]  pblk_end_io_sync+0x12/0x20
[ 8558.263297]  nvm_end_io+0x2b/0x30
[ 8558.266607]  nvme_nvm_end_io+0x2e/0x50
[ 8558.270351]  blk_mq_end_request+0x3e/0x70
[ 8558.274360]  nvme_complete_rq+0x1c/0xd0
[ 8558.278194]  nvme_pci_complete_rq+0x7b/0x130
[ 8558.282459]  __blk_mq_complete_request+0xa3/0x160
[ 8558.287156]  blk_mq_complete_request+0x16/0x20
[ 8558.291592]  nvme_process_cq+0xf8/0x1e0
[ 8558.295424]  nvme_queue_rq+0x16e/0x9a0
[ 8558.299172]  blk_mq_dispatch_rq_list+0x19e/0x330
[ 8558.303787]  ? blk_mq_flush_busy_ctxs+0x91/0x130
[ 8558.308400]  blk_mq_sched_dispatch_requests+0x19d/0x1d0
[ 8558.313617]  __blk_mq_run_hw_queue+0x12e/0x1d0
[ 8558.318053]  __blk_mq_delay_run_hw_queue+0xb9/0xd0
[ 8558.322837]  blk_mq_run_hw_queue+0x14/0x20
[ 8558.326928]  blk_mq_sched_insert_request+0xa4/0x180
[ 8558.331797]  blk_execute_rq_nowait+0x72/0xf0
[ 8558.336061]  nvme_nvm_submit_io+0xd9/0x130
[ 8558.340151]  nvm_submit_io+0x3c/0x70
[ 8558.343723]  pblk_submit_io+0x1b/0x20
[ 8558.347379]  pblk_submit_read+0x1ec/0x3a0
[ 8558.351385]  pblk_make_rq+0xc1/0x110
[ 8558.354954]  generic_make_request+0x11d/0x3c0
[ 8558.359308]  ? iov_iter_get_pages+0xc0/0x350
[ 8558.363569]  submit_bio+0x73/0x140
[ 8558.366966]  ? submit_bio+0x73/0x140
[ 8558.370541]  ? bio_iov_iter_get_pages+0xd7/0x120
[ 8558.375147]  iomap_dio_actor+0x1f8/0x3a0
[ 8558.379066]  ? iomap_dio_zero+0x110/0x110
[ 8558.383068]  iomap_apply+0xa1/0x110
[ 8558.386553]  iomap_dio_rw+0x26f/0x3c0
[ 8558.390210]  ? iomap_dio_zero+0x110/0x110
[ 8558.394216]  ? down_read_nested+0x49/0x70
[ 8558.398219]  xfs_file_dio_aio_read+0x88/0x1c0
[ 8558.402570]  ? xfs_file_dio_aio_read+0x88/0x1c0
[ 8558.407094]  xfs_file_read_iter+0xab/0xc0
[ 8558.411098]  __vfs_read+0xef/0x160
[ 8558.414494]  vfs_read+0xa8/0x150
[ 8558.417718]  SyS_pread64+0x98/0xc0
[ 8558.421116]  entry_SYSCALL_64_fastpath+0x23/0xc2
[ 8558.425726] RIP: 0033:0x7f816caaed43
[ 8558.429296] RSP: 002b:00007f8150ff4d50 EFLAGS: 00000293 ORIG_RAX: =
0000000000000011
[ 8558.436854] RAX: ffffffffffffffda RBX: 00007f8130219a10 RCX: =
00007f816caaed43
[ 8558.443978] RDX: 0000000000200000 RSI: 00007f8130408000 RDI: =
0000000000000114
[ 8558.451102] RBP: 00007f8150ff6110 R08: 00007f8150ff4f20 R09: =
00007f8130408000
[ 8558.458226] R10: 0000000000000000 R11: 0000000000000293 R12: =
0000000000000114
[ 8558.465350] R13: 000000000143fb20 R14: 0000000001445fb8 R15: =
00007f8150ff6550
[40409.278987] perf: interrupt took too long (6252 > 6245), lowering =
kernel.perf_event_max_sample_rate to 31750
[40458.049396] XFS (pblk0): Unmounting Filesystem
javigon@hero:~$
[ 8558.117646]
               other info that might help us debug this:

[ 8558.125636]  Possible unsafe locking scenario by crosslock:

[ 8558.132672]        CPU0                    CPU1
[ 8558.137196]        ----                    ----
[ 8558.141720]   lock(&inode->i_rwsem);
[ 8558.145291]   lock((complete)&wait#5);
[ 8558.149035]                                lock(&inode->i_rwsem);
[ 8558.155118]                                unlock((complete)&wait#5);
[ 8558.161550]
                *** DEADLOCK ***

[ 8558.167461] 4 locks held by rocksdb:bg11/19129:
[ 8558.171984]  #0:  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] =
xfs_ilock+0x1a1/0x230
[ 8558.180148]  #1:  (rcu_read_lock){....}, at: [<ffffffffad72b8cc>] =
__blk_mq_run_hw_queue+0xec/0x1d0
[ 8558.189091]  #2:  (&(&nvmeq->q_lock)->rlock){-.-.}, at: =
[<ffffffffad9d438c>] nvme_queue_rq+0x14c/0x9a0
[ 8558.198384]  #3:  (&x->wait#17){-.-.}, at: [<ffffffffad16444d>] =
complete+0x1d/0x60
[ 8558.205948]
               stack backtrace:
[ 8558.210300] CPU: 6 PID: 19129 Comm: rocksdb:bg11 Not tainted =
4.14.0-rc2--509811f1f2df #726
[ 8558.218550] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a =
06/23/2016
[ 8558.225675] Call Trace:
[ 8558.228123]  dump_stack+0x85/0xc7
[ 8558.231438]  print_circular_bug+0x226/0x330
[ 8558.235616]  ? print_bfs_bug+0x40/0x40
[ 8558.239358]  check_prev_add+0x432/0x840
[ 8558.243190]  ? __lock_acquire+0x736/0x11d0
[ 8558.247282]  lock_commit_crosslock+0x3d3/0x5d0
[ 8558.251718]  ? lock_commit_crosslock+0x3d3/0x5d0
[ 8558.256328]  complete+0x29/0x60
[ 8558.259469]  pblk_end_io_sync+0x12/0x20
[ 8558.263297]  nvm_end_io+0x2b/0x30
[ 8558.266607]  nvme_nvm_end_io+0x2e/0x50
[ 8558.270351]  blk_mq_end_request+0x3e/0x70
[ 8558.274360]  nvme_complete_rq+0x1c/0xd0
[ 8558.278194]  nvme_pci_complete_rq+0x7b/0x130
[ 8558.282459]  __blk_mq_complete_request+0xa3/0x160
[ 8558.287156]  blk_mq_complete_request+0x16/0x20
[ 8558.291592]  nvme_process_cq+0xf8/0x1e0
[ 8558.295424]  nvme_queue_rq+0x16e/0x9a0
[ 8558.299172]  blk_mq_dispatch_rq_list+0x19e/0x330
[ 8558.303787]  ? blk_mq_flush_busy_ctxs+0x91/0x130
[ 8558.308400]  blk_mq_sched_dispatch_requests+0x19d/0x1d0
[ 8558.313617]  __blk_mq_run_hw_queue+0x12e/0x1d0
[ 8558.318053]  __blk_mq_delay_run_hw_queue+0xb9/0xd0
[ 8558.322837]  blk_mq_run_hw_queue+0x14/0x20
[ 8558.326928]  blk_mq_sched_insert_request+0xa4/0x180
[ 8558.331797]  blk_execute_rq_nowait+0x72/0xf0
[ 8558.336061]  nvme_nvm_submit_io+0xd9/0x130
[ 8558.340151]  nvm_submit_io+0x3c/0x70
[ 8558.343723]  pblk_submit_io+0x1b/0x20
[ 8558.347379]  pblk_submit_read+0x1ec/0x3a0
[ 8558.351385]  pblk_make_rq+0xc1/0x110
[ 8558.354954]  generic_make_request+0x11d/0x3c0
[ 8558.359308]  ? iov_iter_get_pages+0xc0/0x350
[ 8558.363569]  submit_bio+0x73/0x140
[ 8558.366966]  ? submit_bio+0x73/0x140
[ 8558.370541]  ? bio_iov_iter_get_pages+0xd7/0x120
[ 8558.375147]  iomap_dio_actor+0x1f8/0x3a0
[ 8558.379066]  ? iomap_dio_zero+0x110/0x110
[ 8558.383068]  iomap_apply+0xa1/0x110
[ 8558.386553]  iomap_dio_rw+0x26f/0x3c0
[ 8558.390210]  ? iomap_dio_zero+0x110/0x110
[ 8558.394216]  ? down_read_nested+0x49/0x70
[ 8558.398219]  xfs_file_dio_aio_read+0x88/0x1c0
[ 8558.402570]  ? xfs_file_dio_aio_read+0x88/0x1c0
[ 8558.407094]  xfs_file_read_iter+0xab/0xc0
[ 8558.411098]  __vfs_read+0xef/0x160
[ 8558.414494]  vfs_read+0xa8/0x150
[ 8558.417718]  SyS_pread64+0x98/0xc0
[ 8558.421116]  entry_SYSCALL_64_fastpath+0x23/0xc2
[ 8558.425726] RIP: 0033:0x7f816caaed43
[ 8558.429296] RSP: 002b:00007f8150ff4d50 EFLAGS: 00000293 ORIG_RAX: =
0000000000000011
[ 8558.436854] RAX: ffffffffffffffda RBX: 00007f8130219a10 RCX: =
00007f816caaed43
[ 8558.443978] RDX: 0000000000200000 RSI: 00007f8130408000 RDI: =
0000000000000114
[ 8558.451102] RBP: 00007f8150ff6110 R08: 00007f8150ff4f20 R09: =
00007f8130408000
[ 8558.458226] R10: 0000000000000000 R11: 0000000000000293 R12: =
0000000000000114
[ 8558.465350] R13: 000000000143fb20 R14: 0000000001445fb8 R15: =
00007f8150ff6550
[40409.278987] perf: interrupt took too long (6252 > 6245), lowering =
kernel.perf_event_max_sample_rate to 31750
[40458.049396] XFS (pblk0): Unmounting Filesystem

Thanks,
Javier


--Apple-Mail=_3D47C07D-E4B9-45AC-9729-12E9FC346D1D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEm1mT7zen+vs9+T8kYx8FO3WZGMoFAlnWDz4ACgkQYx8FO3WZ
GMrSGRAAy/r30tDoS1/HUVqqyPIYVYVPhmco/gKy3uuxjmm6T+W3HHORBUmOuGBN
xPF+RKcuvowcUSfcqrS096+deepsErP+tHXOSRk/qjFGdbMveipx/NoLBjwnnimE
DqdyFNSf3Lyat8JeDpnnV0JxBiB86jLcnhTP3bTZQjXf/CcpQkdcQaaqw6mdQmiY
ewGz840vV26ZK1p0awfsYiBgX+0G9yD2BYwTWrSdCOL6mFcibZfK0QZ31MMUCczW
11xKrbDMBNkhB+S9sRdFqvwHAGdJMUr/kcvf4a0suxjPN4kqDSp3BF3ZZ9YOUShR
1xGiLFU7T+uUKhPbT+ghqvWA/1e7ZzzyXAh2CKfjLrJTo0+2X1ISVqRelik7wzHL
63ExmQwDi6/06dQFTGylUc4DyQyHTiVHnssanOgvJyc3l/QpPNp7YZnTD+5yFy6I
hqHpaoDqldBaVs7S/0ygMJxUHCIjwnh6xE6NN0w2GWcbemsgznYa7EGTzZn17esM
54d7BF8pYcWptdYZYolaviMEu96o9q2eQfTkSAlUPl3YFanWl7optHepS7Aj790n
mf6n/l03DZxo53D5N2kqM2tgLVdaI4ea9r1Mh3EOq6b3104hvOybyDn/MgUZ1GjR
bT4jm1+ZRTTQPA8VJc98SeoXJD83WxHha2ouF5ynJDUOBXpZAOk=
=OGof
-----END PGP SIGNATURE-----

--Apple-Mail=_3D47C07D-E4B9-45AC-9729-12E9FC346D1D--
