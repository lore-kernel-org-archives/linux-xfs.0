Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088E6C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 06:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbiFTGIC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 02:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiFTGIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 02:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE2BE64
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jun 2022 23:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB27B80E5A
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 06:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD838C341C8
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655705269;
        bh=LF/1+6sboTA4LrPienkAhXQY3vJNQmvGXhtvSrc1w4E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BWLG6U0QheLpd0xtxQc4xKRohkQ4b6N/JPRVdcEcaE/4LbqD7zlNjDR1BP7GOOJZd
         0cbt9jc5AMs+b7VEwxGJ183CtjUJYQyLLTJXovla2CEVC4SBwL2IUcbsmlzXt6xJEA
         CqDL916XALh5YhPrKvZ0PCBuVZcRmEW3+p6trX6jixNgpd5UmPk8cMkUU+V3+BBv0G
         t7UROQMTP0LZawdb5z1q+FJksketzvC1yrYjmg4zmpCtdNXEu7MLtD7qpMrGFZoq9C
         UGX+sbr+vlzWIZ4x1oUGYpJxA1YsnlkuNMIq17bH3vZaTpmwDYF2wiYjxIoCY42an9
         nE3Lc3WOtBaCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BAA4DCC13AD; Mon, 20 Jun 2022 06:07:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216151] kernel panic after BUG: KASAN: use-after-free in
 _copy_to_iter+0x830/0x1030
Date:   Mon, 20 Jun 2022 06:07:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216151-201763-fT9L0Bnj3w@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216151-201763@https.bugzilla.kernel.org/>
References: <bug-216151-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216151

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
# ./scripts/decode_stacktrace.sh vmlinux < crash.log

[26844.323108] run fstests generic/465 at 2022-06-20 00:24:32=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
                               [26847.872804]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
[26847.872854] BUG: KASAN: use-after-free in _copy_to_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter=
.c:667
(discriminator 31))=20
[26847.872992] Write of size 16 at addr ffff2fb1d4013000 by task nfsd/45920=
=20=20=20=20=20
[26847.872999]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.873090] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20=20=20
[26847.873094] Call trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
                               [26847.873174] dump_backtrace
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/stacktrace.c:200)=20
[26847.873198] show_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/stacktrace.c:207)=20
[26847.873203] dump_stack_lvl
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/dump_sta=
ck.c:107
(discriminator 4))=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.873262] print_address_description.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/mm.h:848
/mnt/tests/kernel/distribution/upstream-kernel/ins
tall/kernel/mm/kasan/report.c:210
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/repo=
rt.c:311)=20
[26847.873285] print_report
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/rep=
ort.c:390
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/repo=
rt.
c:430)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[26847.873290] kasan_report
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/rep=
ort.c:162
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/repo=
rt.
c:493)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[26847.873294] kasan_check_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/gen=
eric.c:173
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/g
eneric.c:189)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.873298] memcpy
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/sha=
dow.c:65
(discriminator 1))=20=20
[26847.873303] _copy_to_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter=
.c:667
(discriminator 31))=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.873307] copy_page_to_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter=
.c:855
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter.c
:880)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[26847.873311] filemap_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/uio.h:153
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/filemap.c
:2730)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[26847.873319] generic_file_read_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/filemap.c=
:2825)=20
[26847.873324] xfs_file_buffered_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_f=
ile.c:270)
xfs
[26847.873854] xfs_file_read_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_f=
ile.c:295)
xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.874168] do_iter_readv_writev
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/fs.h:2052
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/r
ead_write.c:740)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.874176] do_iter_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/read_writ=
e.c:803)=20
[26847.874180] vfs_iter_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/read_writ=
e.c:846)
[26847.874185] nfsd_readv
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/vfs.=
c:931)
nfsd=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[175/1812]
[26847.874308] nfsd4_encode_read_plus_data
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:4762)
nfsd
[26847.874387] nfsd4_encode_read_plus
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:4795
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nf
sd/nfs4xdr.c:4854) nfsd=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.874468] nfsd4_encode_operation
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:5323
(discriminator 4)) nfsd=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
[26847.874544] nfsd4_proc_compound
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
proc.c:2757)
nfsd
[26847.874620] nfsd_dispatch
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfss=
vc.c:1056)
nfsd
[26847.874697] svc_process_common
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/s=
vc.c:1339)
sunrpc
[26847.874921] svc_process
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/s=
vc.c:1470)
sunrpc
[26847.875063] nfsd
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfss=
vc.c:979)
nfsd
[26847.875143] kthread
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/kthre=
ad.c:376)=20
[26847.875170] ret_from_fork
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:868)=20
[26847.875178]
[26847.875180] Allocated by task 602477:
[26847.875185] kasan_save_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/com=
mon.c:39)=20
[26847.875191] __kasan_slab_alloc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/com=
mon.c:45
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/co
mmon.c:436
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/comm=
on.c:469)=20
[26847.875195] kmem_cache_alloc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/slab.h:750
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/slub.c:3214
/mnt/
tests/kernel/distribution/upstream-kernel/install/kernel/mm/slub.c:3222
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/slub.c:3229
/mnt/tests/kernel/distribution/upstream-ke
rnel/install/kernel/mm/slub.c:3239)=20
[26847.875199] security_inode_alloc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/security/sec=
urity.c:594
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/securi
ty/security.c:1024)=20
[26847.875221] inode_init_always
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
95)=20
[26847.875228] alloc_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:2=
67)=20
[26847.875232] new_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
018
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:10=
47)=20
[26847.875236] debugfs_create_dir
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/debugfs/i=
node.c:72
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/debugfs
/inode.c:578)=20
[26847.875243] rpc_clnt_debugfs_register
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/d=
ebugfs.c:157)
sunrpc
[26847.875384] rpc_client_register
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/c=
lnt.c:306)
sunrpc
[26847.875526] rpc_new_client
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/c=
lnt.c:431)
sunrpc
[26847.875666] __rpc_clone_client
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/c=
lnt.c:642)
sunrpc
[26847.875831] rpc_clone_client
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/c=
lnt.c:670)
sunrpc
[26847.875972] nfs4_proc_lookup_mountpoint
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/nfs4p=
roc.c:4507
(discriminator 1)) nfsv4
[26847.876149] nfs4_submount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/nfs4n=
amespace.c:460)
nfsv4
[26847.876251] nfs_d_automount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/names=
pace.c:189)
nfs
[26847.876389] __traverse_mounts
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:1=
355
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:14=
00)=20
[26847.876396] step_into
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:1=
539
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:18=
44)=20
[26847.876400] walk_component
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:2=
020)=20
[26847.876405] link_path_walk.part.0.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:2=
341)=20
[26847.876410] path_lookupat
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:2=
466
(discriminator 2)
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/
namei.c:2492 (discriminator 2))=20
[26847.876436] filename_lookup
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:2=
522)=20
[26847.876440] vfs_path_lookup
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namei.c:2=
638)=20
[26847.876445] mount_subtree
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace=
.c:3549)
[26847.876451] do_nfs4_mount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/nfs4s=
uper.c:206)
nfsv4=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[26847.876554] nfs4_try_get_tree
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/nfs4s=
uper.c:226
(discriminator 3)) nfsv4
[26847.876653] nfs_get_tree
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfs/fs_co=
ntext.c:1433)
nfs
[26847.876742] vfs_get_tree
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/super.c:1=
497)=20
[26847.876748] do_new_mount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace=
.c:3040)=20
[26847.876753] path_mount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace=
.c:3370)=20
[26847.876757] __arm64_sys_mount
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace=
.c:3383
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace.
c:3591
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace.=
c:3568
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/namespace.=
c:3568)=20
[26847.876762] invoke_syscall.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:38
/mnt/tests/kernel/distribution/upstream-kernel/install/
kernel/arch/arm64/kernel/syscall.c:52)=20
[26847.876769] el0_svc_common.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:158)=20
[26847.876774] do_el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:207)=20
[26847.876778] el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:133
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/a
rm64/kernel/entry-common.c:142
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/ke=
rnel/entry-common.c:625)=20
[26847.876785] el0t_64_sync_handler
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:643)=20
[26847.876789] el0t_64_sync
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:581)=20
[26847.876793]
[26847.876794] Last potentially related work creation:
[26847.876797] kasan_save_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/com=
mon.c:39)=20
[26847.876802] __kasan_record_aux_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/gen=
eric.c:348)=20
[26847.876806] kasan_record_aux_stack_noalloc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/gen=
eric.c:359)=20
[26847.876811] call_rcu
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/rcu/t=
ree.c:3127)=20
[26847.876818] security_inode_free
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/security/sec=
urity.c:1058)=20
[26847.876823] __destroy_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/fsnotify.h:176
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/i
node.c:286)=20
[26847.876828] destroy_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:3=
09
(discriminator 2))=20
[26847.876832] evict
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:6=
80
(discriminator 2))=20
[26847.876836] iput_final
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
745)=20
[26847.876841] iput.part.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
772)=20
[26847.876845] iput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
772
(discriminator 2))=20
[26847.876849] dentry_unlink_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:=
402)=20
[26847.876853] __dentry_kill
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./arch/arm64=
/include/asm/current.h:19
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel
/./arch/arm64/include/asm/preempt.h:47
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:6=
10)=20
[26847.876857] dput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:=
896)=20
[26847.876860] simple_recursive_removal
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/libfs.c:3=
12)=20
[26847.876865] debugfs_remove
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/debugfs/i=
node.c:743
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/debugfs/in
ode.c:736)=20
[26847.876870] rpc_clnt_debugfs_unregister
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/d=
ebugfs.c:170)
sunrpc
[26847.877011] rpc_free_client_work
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/c=
lnt.c:357
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunr
pc/clnt.c:897) sunrpc
[26847.877154] process_one_work
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/workq=
ueue.c:2294)=20
[26847.877161] worker_thread
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/list.h:292
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/wor
kqueue.c:2437)

[26847.877165] kthread
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/kthre=
ad.c:376)
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[88/1812]
[26847.877168] ret_from_fork
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:868)=20
[26847.877172]
[26847.877174] Second to last potentially related work creation:
[26847.877177] kasan_save_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/com=
mon.c:39)=20
[26847.877181] __kasan_record_aux_stack
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/gen=
eric.c:348)=20
[26847.877185] kasan_record_aux_stack_noalloc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/gen=
eric.c:359)=20
[26847.877190] call_rcu
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/rcu/t=
ree.c:3127)=20
[26847.877195] security_inode_free
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/security/sec=
urity.c:1058)=20
[26847.877200] __destroy_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/fsnotify.h:176
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/i
node.c:286)=20
[26847.877205] destroy_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:3=
09
(discriminator 2))=20
[26847.877209] evict
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:6=
80
(discriminator 2))=20
[26847.877213] iput_final
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
745)=20
[26847.877217] iput.part.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
772)=20
[26847.877221] iput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/inode.c:1=
772
(discriminator 2))=20
[26847.877226] dentry_unlink_inode
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:=
402)=20
[26847.877229] __dentry_kill
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./arch/arm64=
/include/asm/current.h:19
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel
/./arch/arm64/include/asm/preempt.h:47
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:6=
10)=20
[26847.877233] dput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/dcache.c:=
896)=20
[26847.877237] __fput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/file_tabl=
e.c:331)=20
[26847.877241] ____fput
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/file_tabl=
e.c:351)=20
[26847.877245] task_work_run
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/task_=
work.c:179
(discriminator 1))=20
[26847.877250] do_exit
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/exit.=
c:804)=20
[26847.877256] do_group_exit
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/exit.=
c:906)=20
[26847.877260] __arm64_sys_exit_group
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/exit.=
c:934)=20
[26847.877264] invoke_syscall.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:38
/mnt/tests/kernel/distribution/upstream-kernel/install/
kernel/arch/arm64/kernel/syscall.c:52)=20
[26847.877270] el0_svc_common.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:158)=20
[26847.877275] do_el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:207)=20
[26847.877280] el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:133
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/a
rm64/kernel/entry-common.c:142
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/ke=
rnel/entry-common.c:625)=20
[26847.877284] el0t_64_sync_handler
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:643)=20
[26847.877288] el0t_64_sync
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:581)=20
[26847.877292]
[26847.877293] The buggy address belongs to the object at ffff2fb1d4013000
[26847.877293]  which belongs to the cache lsm_inode_cache of size 128
[26847.877298] The buggy address is located 0 bytes inside of
[26847.877298]  128-byte region [ffff2fb1d4013000, ffff2fb1d4013080)
[26847.877302]
[26847.877304] The buggy address belongs to the physical page:
[26847.877308] page:000000007bc4a504 refcount:1 mapcount:0
mapping:0000000000000000 index:0xffff2fb1d4013000 pfn:0x154013=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
                                           [47/1812]
[26847.877363] flags: 0x17ffff800000200(slab|node=3D0|zone=3D2|lastcpupid=
=3D0xfffff)
[26847.877375] raw: 017ffff800000200 fffffcbec6646688 fffffcbec750d708
ffff2fb1808dfe00
[26847.877379] raw: ffff2fb1d4013000 0000000000150010 00000001ffffffff
0000000000000000
[26847.877382] page dumped because: kasan: bad access detected
[26847.877384]
[26847.877385] Memory state around the buggy address:
[26847.877389]  ffff2fb1d4012f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00
00
[26847.877392]  ffff2fb1d4012f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00
00
[26847.877395] >ffff2fb1d4013000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb
fb
[26847.877397]                    ^
[26847.877400]  ffff2fb1d4013080: fc fc fc fc fc fc fc fc fa fb fb fb fb fb=
 fb
fb
[26847.877402]  ffff2fb1d4013100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc=
 fc
fc
[26847.877405]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[26847.877570] Disabling lock debugging due to kernel taint
[26848.391268] Unable to handle kernel write to read-only memory at virtual
address ffff2fb197f76000
[26848.393628] KASAN: maybe wild-memory-access in range
[0xfffd7d8cbfbb0000-0xfffd7d8cbfbb0007]=20
[26848.395572] Mem abort info:
[26848.396408]   ESR =3D 0x000000009600004f
[26848.397314]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[26848.398520]   SET =3D 0, FnV =3D 0
[26848.506889]   EA =3D 0, S1PTW =3D 0
[26848.507633]   FSC =3D 0x0f: level 3 permission fault
[26848.508802] Data abort info:
[26848.509480]   ISV =3D 0, ISS =3D 0x0000004f
[26848.510347]   CM =3D 0, WnR =3D 1
[26848.511032] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000b22dd0=
00
[26848.512543] [ffff2fb197f76000] pgd=3D18000001bfff8003, p4d=3D18000001bff=
f8003,
pud=3D18000001bfa08003, pmd=3D18000001bf948003, pte=3D0060000117f76f87
[26848.515600] Internal error: Oops: 9600004f [#1] SMP
[26848.516870] Modules linked in: loop dm_mod tls rpcsec_gss_krb5 nfsv4
dns_resolver nfs fscache netfs rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd
auth_rpcgss nfs_acl lockd grace rfkill sunrpc v
fat fat drm fuse xfs libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64
sha1_ce virtio_blk virtio_net virtio_console net_failover failover virtio_m=
mio
ipmi_devintf ipmi_msghandler
[26848.527934] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15
[26848.529819] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[26848.531625] pc : __memcpy
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/l=
ib/memcpy.S:73)=20
[26848.532583] lr : memcpy
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/kasan/sha=
dow.c:70)=20
[26848.533497] sp : ffff80000bbb6f00
[26848.534444] x29: ffff80000bbb6f00 x28: 0000000000000000 x27:
ffff2fb18a4bd5b8
[26848.536435] x26: 0000000000000000 x25: ffff80000bbb7740 x24:
ffff2fb18a4bd5b0
[26848.538283] x23: ffff2fb1ee80bff0 x22: ffffa83e4692e000 x21:
ffffa83e434ae3e8
[26848.540181] x20: ffff2fb197f76000 x19: 0000000000000010 x18:
ffff2fb1d3c34530
[26848.542071] x17: 0000000000000000 x16: ffffa83e42d01a30 x15:
6161616161616161
[26848.543840] x14: 6161616161616161 x13: 6161616161616161 x12:
6161616161616161
[26848.545614] x11: 1fffe5f632feec01 x10: ffff65f632feec01 x9 :
dfff800000000000
[26848.547387] x8 : ffff2fb197f7600f x7 : 6161616161616161 x6 :
6161616161616161
[26848.549156] x5 : ffff2fb197f76010 x4 : ffff2fb1ee80c000 x3 :
ffffa83e434ae3e8
[26848.550924] x2 : 0000000000000010 x1 : ffff2fb1ee80bff0 x0 :
ffff2fb197f76000
[26848.552694] Call trace:
[26848.553314] __memcpy
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/l=
ib/memcpy.S:73)=20
[26848.554123] _copy_to_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter=
.c:667
(discriminator 31))=20
[26848.555084] copy_page_to_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter=
.c:855
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/lib/iov_iter.c
:880)=20
[26848.556104] filemap_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/uio.h:153
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/filemap.c
:2730)=20
[26848.557020] generic_file_read_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/filemap.c=
:2825)=20
[26848.558152] xfs_file_buffered_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_f=
ile.c:270)
xfs
[26848.559795] xfs_file_read_iter
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_f=
ile.c:295)
xfs
[26848.561265] do_iter_readv_writev
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/fs.h:2052
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/r
ead_write.c:740)=20
[26848.562346] do_iter_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/read_writ=
e.c:803)=20
[26848.563263] vfs_iter_read
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/read_writ=
e.c:846)=20
[26848.564162] nfsd_readv
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/vfs.=
c:931)
nfsd
[26848.565415] nfsd4_encode_read_plus_data
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:4762)
nfsd
[26848.566869] nfsd4_encode_read_plus
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:4795
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nf
sd/nfs4xdr.c:4854) nfsd
[26848.568231] nfsd4_encode_operation
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
xdr.c:5323
(discriminator 4)) nfsd
[26848.569596] nfsd4_proc_compound
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfs4=
proc.c:2757)
nfsd
[26848.570908] nfsd_dispatch
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfss=
vc.c:1056)
nfsd
[26848.572067] svc_process_common
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/s=
vc.c:1339)
sunrpc
[26848.573508] svc_process
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/net/sunrpc/s=
vc.c:1470)
sunrpc
[26848.574743] nfsd
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/nfsd/nfss=
vc.c:979)
nfsd
[26848.575718] kthread
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/kernel/kthre=
ad.c:376)=20
[26848.576528] ret_from_fork
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:868)=20
[26848.577421] Code: f100405f 540000c3 a9401c26 a97f348c (a9001c06)
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   f100405f        cmp     x2, #0x10
   4:   540000c3        b.cc    0x1c  // b.lo, b.ul, b.last
   8:   a9401c26        ldp     x6, x7, [x1]
   c:   a97f348c        ldp     x12, x13, [x4, #-16]
  10:*  a9001c06        stp     x6, x7, [x0]            <-- trapping
instruction

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   a9001c06        stp     x6, x7, [x0]
[26848.578934] SMP: stopping secondary CPUs
[26848.582664] Starting crashdump kernel...
[26848.583602] Bye!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
