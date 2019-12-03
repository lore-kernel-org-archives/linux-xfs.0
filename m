Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5981BC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 249052080F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsFJBHH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLCNso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 08:48:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38069 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbfLCNso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 08:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575380921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2426TUXH46Dvbw7yzD1hSMTjB99OXECttwgkoFd/DRo=;
        b=VsFJBHH0VVa/qyNMUtytPY/+epTaxLEVw5/wspYCVVau1GJrGZzTWFJcIaeYWlnht5BVAi
        ZfESldp1BCcyMDaskzDw/ag3oksqrR1ttVmF7v5SIiEXsO2WZKj279mxF6o0fxXAmSOS/D
        N/6rOPDJF/st0OP+ATNeaDn8xhOuOJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-dR6Bu5Q8O12bf7__N6_-gQ-1; Tue, 03 Dec 2019 08:48:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C6E800D41;
        Tue,  3 Dec 2019 13:48:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A51715C28F;
        Tue,  3 Dec 2019 13:48:36 +0000 (UTC)
Date:   Tue, 3 Dec 2019 08:48:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     syzbot <syzbot+c732f8644185de340492@syzkaller.appspotmail.com>
Cc:     darrick.wong@oracle.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in xlog_alloc_log (2)
Message-ID: <20191203134836.GC18418@bfoster>
References: <00000000000087c51905988b297b@google.com>
MIME-Version: 1.0
In-Reply-To: <00000000000087c51905988b297b@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: dR6Bu5Q8O12bf7__N6_-gQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 29, 2019 at 11:19:08PM -0800, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pu=
b..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D13b27696e0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D773597fe8d7cb=
41a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc732f8644185de3=
40492
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>=20
> Unfortunately, I don't have any reproducer for this crash yet.
>=20

It looks like the out_free_iclog: error path in xlog_alloc_log() doesn't
handle the case of a fully initialized iclog list. It uses an iclog !=3D
NULL check to terminate the freeing loop, and that might never occur if
we failed after the linked list was set up. I've confirmed with a simple
error injection test and will send a patch..

Brian

> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in xlog_alloc_log+0x1398/0x14b0
> fs/xfs/xfs_log.c:1495
> Read of size 8 at addr ffff888068139890 by task syz-executor.3/32544
>=20
> CPU: 0 PID: 32544 Comm: syz-executor.3 Not tainted 5.4.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:=
374
>  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
>  kasan_report+0x12/0x20 mm/kasan/common.c:634
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>  xlog_alloc_log+0x1398/0x14b0 fs/xfs/xfs_log.c:1495
>  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
>  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
>  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
>  mount_bdev+0x304/0x3c0 fs/super.c:1415
>  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
>  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
>  vfs_get_tree+0x8e/0x300 fs/super.c:1545
>  do_new_mount fs/namespace.c:2822 [inline]
>  do_mount+0x135a/0x1b50 fs/namespace.c:3142
>  ksys_mount+0xdb/0x150 fs/namespace.c:3351
>  __do_sys_mount fs/namespace.c:3365 [inline]
>  __se_sys_mount fs/namespace.c:3362 [inline]
>  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45d0ca
> Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 4d 8c fb ff c3 66 2e 0=
f
> 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff
> 0f 83 2a 8c fb ff c3 66 0f 1f 84 00 00 00 00 00
> RSP: 002b:00007f525b430a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f525b430b40 RCX: 000000000045d0ca
> RDX: 00007f525b430ae0 RSI: 0000000020000100 RDI: 00007f525b430b00
> RBP: 0000000000000001 R08: 00007f525b430b40 R09: 00007f525b430ae0
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
> R13: 00000000004ca258 R14: 00000000004e2870 R15: 00000000ffffffff
>=20
> Allocated by task 32544:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  __kasan_kmalloc mm/kasan/common.c:510 [inline]
>  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
>  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
>  __do_kmalloc mm/slab.c:3655 [inline]
>  __kmalloc+0x163/0x770 mm/slab.c:3664
>  kmalloc include/linux/slab.h:561 [inline]
>  kmem_alloc+0x15b/0x4d0 fs/xfs/kmem.c:21
>  kmem_zalloc fs/xfs/kmem.h:68 [inline]
>  xlog_alloc_log+0xcce/0x14b0 fs/xfs/xfs_log.c:1437
>  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
>  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
>  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
>  mount_bdev+0x304/0x3c0 fs/super.c:1415
>  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
>  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
>  vfs_get_tree+0x8e/0x300 fs/super.c:1545
>  do_new_mount fs/namespace.c:2822 [inline]
>  do_mount+0x135a/0x1b50 fs/namespace.c:3142
>  ksys_mount+0xdb/0x150 fs/namespace.c:3351
>  __do_sys_mount fs/namespace.c:3365 [inline]
>  __se_sys_mount fs/namespace.c:3362 [inline]
>  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
> Freed by task 32544:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  kasan_set_free_info mm/kasan/common.c:332 [inline]
>  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
>  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
>  __cache_free mm/slab.c:3425 [inline]
>  kfree+0x10a/0x2c0 mm/slab.c:3756
>  kvfree+0x61/0x70 mm/util.c:593
>  kmem_free fs/xfs/kmem.h:61 [inline]
>  xlog_alloc_log+0xeb5/0x14b0 fs/xfs/xfs_log.c:1497
>  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
>  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
>  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
>  mount_bdev+0x304/0x3c0 fs/super.c:1415
>  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
>  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
>  vfs_get_tree+0x8e/0x300 fs/super.c:1545
>  do_new_mount fs/namespace.c:2822 [inline]
>  do_mount+0x135a/0x1b50 fs/namespace.c:3142
>  ksys_mount+0xdb/0x150 fs/namespace.c:3351
>  __do_sys_mount fs/namespace.c:3365 [inline]
>  __se_sys_mount fs/namespace.c:3362 [inline]
>  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
> The buggy address belongs to the object at ffff888068139800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 144 bytes inside of
>  1024-byte region [ffff888068139800, ffff888068139c00)
> The buggy address belongs to the page:
> page:ffffea0001a04e40 refcount:1 mapcount:0 mapping:ffff8880aa400c40
> index:0x0
> raw: 00fffe0000000200 ffffea0002728148 ffffea00015604c8 ffff8880aa400c40
> raw: 0000000000000000 ffff888068139000 0000000100000002 0000000000000000
> page dumped because: kasan: bad access detected
>=20
> Memory state around the buggy address:
>  ffff888068139780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888068139800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff888068139880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                          ^
>  ffff888068139900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888068139980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20

