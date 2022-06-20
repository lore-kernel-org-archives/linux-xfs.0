Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E92CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 05:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbiFTFwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 01:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbiFTFwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 01:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C9DF7F
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jun 2022 22:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCAC6110F
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 05:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F9D5C341C6
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 05:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655704336;
        bh=jkH5UR74AnPRMX0Gs+SQzuzQosqNeJ6er/DESMjSV8g=;
        h=From:To:Subject:Date:From;
        b=JccAyDOPHxP363mtSY6FzWJVjMM/0R+RbuhmZ/4ghTZLYl8AKBu+SvPpoVnpzq74q
         ZXPEKfyfTjx+xfAoBIsSbt4+zW85fB4Jd3JyimCO6LjemWHAsNSzouVnwDCGzdXBr2
         NV2QROK6e0Vl2CypsHZT2VZZI9Gjf5EHClaooRnqZsfCsWfxDnW37Etj9l47C2EsaT
         N6+a+3bltWDxhctMirCgDYamcYMJLRonHTvZbVGlNFEsKU9SGOnqC7IzJT6nn0jX1/
         pyzYshDNDJZvipJIrjYMLcSRCt/EZzIuTJpLcA05Q+j1rYGdv4pz3czEGX5a+hM5Dy
         IK6FsXiCza8JA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 29242C05FD5; Mon, 20 Jun 2022 05:52:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216151] New: kernel panic after BUG: KASAN: use-after-free in
 _copy_to_iter+0x830/0x1030
Date:   Mon, 20 Jun 2022 05:52:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216151-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216151

            Bug ID: 216151
           Summary: kernel panic after BUG: KASAN: use-after-free in
                    _copy_to_iter+0x830/0x1030
           Product: File System
           Version: 2.5
    Kernel Version: v5.19-rc2+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests generic/465 hit below kernel panic and KASAN BUG on NFS through
XFS(default mkfs options). Hit on linux v5.19-rc2+, which HEAD is:

commit 05c6ca8512f2722f57743d653bb68cf2a273a55a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 19 09:58:28 2022 -0500

    Merge tag 'x86-urgent-2022-06-19' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip


# cat local.config
FSTYP=3Dnfs
TEST_DEV=3D$mynfs_server:/mnt/xfstests/test/nfs-server
TEST_DIR=3D/mnt/xfstests/test/nfs-client
SCRATCH_DEV=3D$mynfs_server:/mnt/xfstests/scratch/nfs-server
SCRATCH_MNT=3D/mnt/xfstests/scratch/nfs-client
MOUNT_OPTIONS=3D"-o vers=3D4.2"
TEST_FS_MOUNT_OPTS=3D"-o vers=3D4.2"

XFS info:
meta-data=3D/dev/vda4              isize=3D512    agcount=3D4, agsize=3D983=
040 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D4096   blocks=3D3932160, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D16384, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

console log:
[26844.323108] run fstests generic/465 at 2022-06-20 00:24:32=20
[26847.872804]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
[26847.872854] BUG: KASAN: use-after-free in _copy_to_iter+0x694/0xd0c=20
[26847.872992] Write of size 16 at addr ffff2fb1d4013000 by task nfsd/45920=
=20
[26847.872999]=20=20
[26847.873083] CPU: 0 PID: 45920 Comm: nfsd Kdump: loaded Not tainted
5.19.0-rc2+ #1=20
[26847.873090] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20
[26847.873094] Call trace:=20
[26847.873174]  dump_backtrace+0x1e0/0x26c=20
[26847.873198]  show_stack+0x1c/0x70=20
[26847.873203]  dump_stack_lvl+0x98/0xd0=20
[26847.873262]  print_address_description.constprop.0+0x74/0x420=20
[26847.873285]  print_report+0xc8/0x234=20
[26847.873290]  kasan_report+0xb0/0xf0=20
[26847.873294]  kasan_check_range+0xf4/0x1a0=20
[26847.873298]  memcpy+0xdc/0x100=20
[26847.873303]  _copy_to_iter+0x694/0xd0c=20
[26847.873307]  copy_page_to_iter+0x3f0/0xb30=20
[26847.873311]  filemap_read+0x3e8/0x7e0=20
[26847.873319]  generic_file_read_iter+0x2b0/0x404=20
[26847.873324]  xfs_file_buffered_read+0x18c/0x4e0 [xfs]=20
[26847.873854]  xfs_file_read_iter+0x260/0x514 [xfs]=20
[26847.874168]  do_iter_readv_writev+0x338/0x4b0=20
[26847.874176]  do_iter_read+0x120/0x374=20
[26847.874180]  vfs_iter_read+0x5c/0xa0=20
[26847.874185]  nfsd_readv+0x1a0/0x9ac [nfsd]=20
[26847.874308]  nfsd4_encode_read_plus_data+0x2f0/0x690 [nfsd]=20
[26847.874387]  nfsd4_encode_read_plus+0x344/0x924 [nfsd]=20
[26847.874468]  nfsd4_encode_operation+0x1fc/0x800 [nfsd]=20
[26847.874544]  nfsd4_proc_compound+0x9c4/0x2364 [nfsd]=20
[26847.874620]  nfsd_dispatch+0x3a4/0x67c [nfsd]=20
[26847.874697]  svc_process_common+0xd54/0x1be0 [sunrpc]=20
[26847.874921]  svc_process+0x298/0x484 [sunrpc]=20
[26847.875063]  nfsd+0x2b0/0x580 [nfsd]=20
[26847.875143]  kthread+0x230/0x294=20
[26847.875170]  ret_from_fork+0x10/0x20=20
[26847.875178]=20=20
[26847.875180] Allocated by task 602477:=20
[26847.875185]  kasan_save_stack+0x28/0x50=20
[26847.875191]  __kasan_slab_alloc+0x68/0x90=20
[26847.875195]  kmem_cache_alloc+0x180/0x394=20
[26847.875199]  security_inode_alloc+0x30/0x120=20
[26847.875221]  inode_init_always+0x49c/0xb1c=20
[26847.875228]  alloc_inode+0x70/0x1c0=20
[26847.875232]  new_inode+0x20/0x230=20
[26847.875236]  debugfs_create_dir+0x74/0x48c=20
[26847.875243]  rpc_clnt_debugfs_register+0xd0/0x174 [sunrpc]=20
[26847.875384]  rpc_client_register+0x90/0x4c4 [sunrpc]=20
[26847.875526]  rpc_new_client+0x6e0/0x1260 [sunrpc]=20
[26847.875666]  __rpc_clone_client+0x158/0x7d4 [sunrpc]=20
[26847.875831]  rpc_clone_client+0x168/0x1dc [sunrpc]=20
[26847.875972]  nfs4_proc_lookup_mountpoint+0x180/0x1f0 [nfsv4]=20
[26847.876149]  nfs4_submount+0xcc/0x6cc [nfsv4]=20
[26847.876251]  nfs_d_automount+0x4b4/0x7bc [nfs]=20
[26847.876389]  __traverse_mounts+0x180/0x4a0=20
[26847.876396]  step_into+0x510/0x940=20
[26847.876400]  walk_component+0xf0/0x510=20
[26847.876405]  link_path_walk.part.0.constprop.0+0x4c0/0xa3c=20
[26847.876410]  path_lookupat+0x6c/0x57c=20
[26847.876436]  filename_lookup+0x13c/0x400=20
[26847.876440]  vfs_path_lookup+0xa0/0xec=20
[26847.876445]  mount_subtree+0x1c4/0x380=20
[26847.876451]  do_nfs4_mount+0x3c0/0x770 [nfsv4]=20
[26847.876554]  nfs4_try_get_tree+0xc0/0x24c [nfsv4]=20
[26847.876653]  nfs_get_tree+0xc0/0x110 [nfs]=20
[26847.876742]  vfs_get_tree+0x78/0x2a0=20
[26847.876748]  do_new_mount+0x228/0x4fc=20
[26847.876753]  path_mount+0x268/0x16d4=20
[26847.876757]  __arm64_sys_mount+0x1dc/0x240=20
[26847.876762]  invoke_syscall.constprop.0+0xd8/0x1d0=20
[26847.876769]  el0_svc_common.constprop.0+0x224/0x2bc=20
[26847.876774]  do_el0_svc+0x4c/0x90=20
[26847.876778]  el0_svc+0x5c/0x140=20
[26847.876785]  el0t_64_sync_handler+0xb4/0x130=20
[26847.876789]  el0t_64_sync+0x174/0x178=20
[26847.876793]=20=20
[26847.876794] Last potentially related work creation:=20
[26847.876797]  kasan_save_stack+0x28/0x50=20
[26847.876802]  __kasan_record_aux_stack+0x9c/0xc0=20
[26847.876806]  kasan_record_aux_stack_noalloc+0x10/0x20=20
[26847.876811]  call_rcu+0xf8/0x6c0=20
[26847.876818]  security_inode_free+0x94/0xc0=20
[26847.876823]  __destroy_inode+0xb0/0x420=20
[26847.876828]  destroy_inode+0x80/0x170=20
[26847.876832]  evict+0x334/0x4c0=20
[26847.876836]  iput_final+0x138/0x364=20
[26847.876841]  iput.part.0+0x330/0x47c=20
[26847.876845]  iput+0x44/0x60=20
[26847.876849]  dentry_unlink_inode+0x200/0x43c=20
[26847.876853]  __dentry_kill+0x29c/0x56c=20
[26847.876857]  dput+0x41c/0x870=20
[26847.876860]  simple_recursive_removal+0x4ac/0x630=20
[26847.876865]  debugfs_remove+0x5c/0x80=20
[26847.876870]  rpc_clnt_debugfs_unregister+0x3c/0x7c [sunrpc]=20
[26847.877011]  rpc_free_client_work+0xdc/0x480 [sunrpc]=20
[26847.877154]  process_one_work+0x794/0x184c=20
[26847.877161]  worker_thread+0x3d4/0xc40=20
[26847.877165]  kthread+0x230/0x294=20
[26847.877168]  ret_from_fork+0x10/0x20=20
[26847.877172]=20=20
[26847.877174] Second to last potentially related work creation:=20
[26847.877177]  kasan_save_stack+0x28/0x50=20
[26847.877181]  __kasan_record_aux_stack+0x9c/0xc0=20
[26847.877185]  kasan_record_aux_stack_noalloc+0x10/0x20=20
[26847.877190]  call_rcu+0xf8/0x6c0=20
[26847.877195]  security_inode_free+0x94/0xc0=20
[26847.877200]  __destroy_inode+0xb0/0x420=20
[26847.877205]  destroy_inode+0x80/0x170=20
[26847.877209]  evict+0x334/0x4c0=20
[26847.877213]  iput_final+0x138/0x364=20
[26847.877217]  iput.part.0+0x330/0x47c=20
[26847.877221]  iput+0x44/0x60=20
[26847.877226]  dentry_unlink_inode+0x200/0x43c=20
[26847.877229]  __dentry_kill+0x29c/0x56c=20
[26847.877233]  dput+0x44c/0x870=20
[26847.877237]  __fput+0x244/0x730=20
[26847.877241]  ____fput+0x14/0x20=20
[26847.877245]  task_work_run+0xd0/0x240=20
[26847.877250]  do_exit+0x3a0/0xaac=20
[26847.877256]  do_group_exit+0xac/0x244=20
[26847.877260]  __arm64_sys_exit_group+0x40/0x4c=20
[26847.877264]  invoke_syscall.constprop.0+0xd8/0x1d0=20
[26847.877270]  el0_svc_common.constprop.0+0x224/0x2bc=20
[26847.877275]  do_el0_svc+0x4c/0x90=20
[26847.877280]  el0_svc+0x5c/0x140=20
[26847.877284]  el0t_64_sync_handler+0xb4/0x130=20
[26847.877288]  el0t_64_sync+0x174/0x178=20
[26847.877292]=20=20
[26847.877293] The buggy address belongs to the object at ffff2fb1d4013000=
=20
[26847.877293]  which belongs to the cache lsm_inode_cache of size 128=20
[26847.877298] The buggy address is located 0 bytes inside of=20
[26847.877298]  128-byte region [ffff2fb1d4013000, ffff2fb1d4013080)=20
[26847.877302]=20=20
[26847.877304] The buggy address belongs to the physical page:=20
[26847.877308] page:000000007bc4a504 refcount:1 mapcount:0
mapping:0000000000000000 index:0xffff2fb1d4013000 pfn:0x154013=20
[26847.877363] flags: 0x17ffff800000200(slab|node=3D0|zone=3D2|lastcpupid=
=3D0xfffff)=20
[26847.877375] raw: 017ffff800000200 fffffcbec6646688 fffffcbec750d708
ffff2fb1808dfe00=20
[26847.877379] raw: ffff2fb1d4013000 0000000000150010 00000001ffffffff
0000000000000000=20
[26847.877382] page dumped because: kasan: bad access detected=20
[26847.877384]=20=20
[26847.877385] Memory state around the buggy address:=20
[26847.877389]  ffff2fb1d4012f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00
00=20
[26847.877392]  ffff2fb1d4012f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00
00=20
[26847.877395] >ffff2fb1d4013000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb
fb=20
[26847.877397]                    ^=20
[26847.877400]  ffff2fb1d4013080: fc fc fc fc fc fc fc fc fa fb fb fb fb fb=
 fb
fb=20
[26847.877402]  ffff2fb1d4013100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc=
 fc
fc=20
[26847.877405]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
[26847.877570] Disabling lock debugging due to kernel taint=20
[26848.391268] Unable to handle kernel write to read-only memory at virtual
address ffff2fb197f76000=20
[26848.393628] KASAN: maybe wild-memory-access in range
[0xfffd7d8cbfbb0000-0xfffd7d8cbfbb0007]=20
[26848.395572] Mem abort info:=20
[26848.396408]   ESR =3D 0x000000009600004f=20
[26848.397314]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=20
[26848.398520]   SET =3D 0, FnV =3D 0=20
[26848.506889]   EA =3D 0, S1PTW =3D 0=20
[26848.507633]   FSC =3D 0x0f: level 3 permission fault=20
[26848.508802] Data abort info:=20
[26848.509480]   ISV =3D 0, ISS =3D 0x0000004f=20
[26848.510347]   CM =3D 0, WnR =3D 1=20
[26848.511032] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000b22dd0=
00=20
[26848.512543] [ffff2fb197f76000] pgd=3D18000001bfff8003, p4d=3D18000001bff=
f8003,
pud=3D18000001bfa08003, pmd=3D18000001bf948003, pte=3D0060000117f76f87=20
[26848.515600] Internal error: Oops: 9600004f [#1] SMP=20
[26848.516870] Modules linked in: loop dm_mod tls rpcsec_gss_krb5 nfsv4
dns_resolver nfs fscache netfs rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd
auth_rpcgss nfs_acl lockd grace rfkill sunrpc vfat fat drm fuse xfs libcrc3=
2c
crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce virtio_blk virtio_net
virtio_console net_failover failover virtio_mmio ipmi_devintf ipmi_msghandl=
er=20
[26848.525472] CPU: 1 PID: 45919 Comm: nfsd Kdump: loaded Tainted: G    B=
=20=20=20=20=20=20
      5.19.0-rc2+ #1=20
[26848.527934] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20
[26848.529819] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[26848.531625] pc : __memcpy+0x2c/0x230=20
[26848.532583] lr : memcpy+0xa8/0x100=20
[26848.533497] sp : ffff80000bbb6f00=20
[26848.534444] x29: ffff80000bbb6f00 x28: 0000000000000000 x27:
ffff2fb18a4bd5b8=20
[26848.536435] x26: 0000000000000000 x25: ffff80000bbb7740 x24:
ffff2fb18a4bd5b0=20
[26848.538283] x23: ffff2fb1ee80bff0 x22: ffffa83e4692e000 x21:
ffffa83e434ae3e8=20
[26848.540181] x20: ffff2fb197f76000 x19: 0000000000000010 x18:
ffff2fb1d3c34530=20
[26848.542071] x17: 0000000000000000 x16: ffffa83e42d01a30 x15:
6161616161616161=20
[26848.543840] x14: 6161616161616161 x13: 6161616161616161 x12:
6161616161616161=20
[26848.545614] x11: 1fffe5f632feec01 x10: ffff65f632feec01 x9 :
dfff800000000000=20
[26848.547387] x8 : ffff2fb197f7600f x7 : 6161616161616161 x6 :
6161616161616161=20
[26848.549156] x5 : ffff2fb197f76010 x4 : ffff2fb1ee80c000 x3 :
ffffa83e434ae3e8=20
[26848.550924] x2 : 0000000000000010 x1 : ffff2fb1ee80bff0 x0 :
ffff2fb197f76000=20
[26848.552694] Call trace:=20
[26848.553314]  __memcpy+0x2c/0x230=20
[26848.554123]  _copy_to_iter+0x694/0xd0c=20
[26848.555084]  copy_page_to_iter+0x3f0/0xb30=20
[26848.556104]  filemap_read+0x3e8/0x7e0=20
[26848.557020]  generic_file_read_iter+0x2b0/0x404=20
[26848.558152]  xfs_file_buffered_read+0x18c/0x4e0 [xfs]=20
[26848.559795]  xfs_file_read_iter+0x260/0x514 [xfs]=20
[26848.561265]  do_iter_readv_writev+0x338/0x4b0=20
[26848.562346]  do_iter_read+0x120/0x374=20
[26848.563263]  vfs_iter_read+0x5c/0xa0=20
[26848.564162]  nfsd_readv+0x1a0/0x9ac [nfsd]=20
[26848.565415]  nfsd4_encode_read_plus_data+0x2f0/0x690 [nfsd]=20
[26848.566869]  nfsd4_encode_read_plus+0x344/0x924 [nfsd]=20
[26848.568231]  nfsd4_encode_operation+0x1fc/0x800 [nfsd]=20
[26848.569596]  nfsd4_proc_compound+0x9c4/0x2364 [nfsd]=20
[26848.570908]  nfsd_dispatch+0x3a4/0x67c [nfsd]=20
[26848.572067]  svc_process_common+0xd54/0x1be0 [sunrpc]=20
[26848.573508]  svc_process+0x298/0x484 [sunrpc]=20
[26848.574743]  nfsd+0x2b0/0x580 [nfsd]=20
[26848.575718]  kthread+0x230/0x294=20
[26848.576528]  ret_from_fork+0x10/0x20=20
[26848.577421] Code: f100405f 540000c3 a9401c26 a97f348c (a9001c06)=20=20
[26848.578934] SMP: stopping secondary CPUs=20
[26848.582664] Starting crashdump kernel...=20
[26848.583602] Bye!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
