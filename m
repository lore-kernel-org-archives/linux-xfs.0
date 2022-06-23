Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B05C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 23:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiFWXew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 19:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiFWXeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 19:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C495DC31
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0D36B825BB
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 23:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA08DC341CF
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 23:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656027283;
        bh=1xKv0V09eKOnEuJdzLj0s13gri4ZKy6HDJ9nJv8aVvY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LMzEmRbl4iBpuYwcENwyJpaMRaRTEIebcoO5jXlbTyvsEyPe+YdLfPC0uXsHUFcoQ
         HJy0gKEdUM1RjJABD7w3/Odw1kYJQBh9M4MUCtsLAv9pGu15oJn1PObCF6dIw7RCEY
         63y78R80Y1cYKnPjy957LmCi3GCYCCQ8tchgxHp28joGlXHnN+66esmrN0zN3TLfvR
         tVK9y9SnqdtfhI0z4J+dbFOVrVbq3zrwzlwSVLdzwvwzd2KOWlVhDZVb13w2REzT7P
         Qo37PLzPl31kae4KKUzOGU380zncxdT4AthXmGA/V1OTvkR7cLIeH6vIuAJZls6lGu
         HyWmaMTTLd0Tw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A9E8CCC13B5; Thu, 23 Jun 2022 23:34:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216151] kernel panic after BUG: KASAN: use-after-free in
 _copy_to_iter+0x830/0x1030
Date:   Thu, 23 Jun 2022 23:34:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216151-201763-aoNb2pAn7g@https.bugzilla.kernel.org/>
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

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
On Mon, Jun 20, 2022 at 06:10:40AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216151
>=20
> --- Comment #2 from Zorro Lang (zlang@redhat.com) ---
> Same panic on another machine (s390x):
>=20
> [10054.497558] run fstests generic/465 at 2022-06-19 16:09:21=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731299]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
> =3D=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.731308] BUG: KASAN: use-after-free in _copy_to_iter+0x830/0x1030=
=20=20=20=20=20=20=20
> [10055.731324] Write of size 16 at addr 0000000090ebd000 by task nfsd/459=
99=20=20=20
> [10055.731328]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731331] CPU: 1 PID: 45999 Comm: nfsd Kdump: loaded Not tainted
> 5.19.0-rc2=20
> + #1=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
> [10055.731335] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731338] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731339]  [<000000007bc24fda>] dump_stack_lvl+0xfa/0x150=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731345]  [<000000007bc173bc>]
> print_address_description.constprop.0+0x64/=20
> 0x3a8=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
> [10055.731351]  [<000000007a98757e>] print_report+0xbe/0x230=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731356]  [<000000007a987ba6>] kasan_report+0xa6/0x1e0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731359]  [<000000007a988fa4>] kasan_check_range+0x174/0x1c0=20=20=
=20=20=20=20=20=20=20=20=20=20
> [10055.731362]  [<000000007a989a38>] memcpy+0x58/0x90=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731365]  [<000000007affd0c0>] _copy_to_iter+0x830/0x1030=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731369]  [<000000007affddd0>] copy_page_to_iter+0x510/0xcb0=20=20=
=20=20=20=20=20=20=20=20=20=20
> [10055.731372]  [<000000007a7e986c>] filemap_read+0x52c/0x950=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731378]  [<001bffff80599042>] xfs_file_buffered_read+0x1c2/0x410 [=
xfs]=20
> [10055.731751]  [<001bffff80599eba>] xfs_file_read_iter+0x28a/0x4c0 [xfs]=
=20=20=20=20=20
> [10055.731975]  [<000000007aa1084a>] do_iter_readv_writev+0x2ca/0x4c0=20=
=20=20=20=20=20=20=20=20
> [10055.731981]  [<000000007aa1102a>] do_iter_read+0x23a/0x3a0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.731984]  [<001bffff80f58d30>] nfsd_readv+0x1e0/0x710 [nfsd]=20=20=
=20=20=20=20=20=20=20=20=20=20
> [10055.732070]  [<001bffff80fa2f88>] nfsd4_encode_read_plus_data+0x3a8/0x=
770
> [nf=20
> sd]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732129]  [<001bffff80fa5010>] nfsd4_encode_read_plus+0x3e0/0xaa0
> [nfsd]=20=20
> [10055.732188]  [<001bffff80fbc0ac>] nfsd4_encode_operation+0x21c/0xab0
> [nfsd]=20=20
> [10055.732249]  [<001bffff80f9ca7e>] nfsd4_proc_compound+0x125e/0x21a0 [n=
fsd]=20
> [10055.732307]  [<001bffff80f441aa>] nfsd_dispatch+0x44a/0xc40 [nfsd]=20=
=20=20=20=20=20=20=20=20
> [10055.732362]  [<001bffff80b8d00c>] svc_process_common+0x92c/0x1cd0 [sun=
rpc]=20
> [10055.732500]  [<001bffff80b8e6ac>] svc_process+0x2fc/0x4c0 [sunrpc]=20=
=20=20=20=20=20=20=20=20
> [10055.732579]  [<001bffff80f42f4e>] nfsd+0x31e/0x600 [nfsd]=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732634]  [<000000007a2cc514>] kthread+0x2a4/0x360=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732640]  [<000000007a186a5a>] __ret_from_fork+0x8a/0xf0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732645]  [<000000007bc5575a>] ret_from_fork+0xa/0x40=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

This doesn't look like an XFS problem. The _copy_to_iter() call that
is tripping up here is copying from the page cache page to the
buffer supplied to XFS by the NFSD in the iov_iter structure. We
know that because it's a memory write operation that is triggering
(read from page cache page, write to iov_iter buffer) here.

> [10055.732650] 1 lock held by nfsd/45999:=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732653]  #0: 000000009cc7fb38
> (&sb->s_type->i_mutex_key#13){++++}-{3:3},=20
> at: xfs_ilock+0x2fa/0x4e0 [xfs]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20
> [10055.732887]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732888] Allocated by task 601543:=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732890]  kasan_save_stack+0x34/0x60=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
> [10055.732893]  __kasan_slab_alloc+0x84/0xb0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732896]  kmem_cache_alloc+0x1e2/0x3d0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732900]  security_file_alloc+0x3a/0x150=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732906]  __alloc_file+0xc0/0x210=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
> [10055.732908]  alloc_empty_file+0x5c/0x140=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732911]  path_openat+0xf8/0x700=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732914]  do_filp_open+0x1b0/0x390=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732917]  do_sys_openat2+0x134/0x3c0=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
> [10055.732920]  do_sys_open+0xdc/0x120=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732922]  do_syscall+0x22c/0x330=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732925]  __do_syscall+0xce/0xf0=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732928]  system_call+0x82/0xb0=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732931]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732932] Freed by task 601543:=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
> [10055.732933]  kasan_save_stack+0x34/0x60=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
> [10055.732935]  kasan_set_track+0x36/0x50=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732937]  kasan_set_free_info+0x34/0x60=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732940]  __kasan_slab_free+0x106/0x150=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732942]  slab_free_freelist_hook+0x148/0x230=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732946]  kmem_cache_free+0x132/0x370=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732948]  __fput+0x2b2/0x700=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
> [10055.732950]  task_work_run+0xf4/0x1b0=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10055.732952]  exit_to_user_mode_prepare+0x286/0x290=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10055.732957]  __do_syscall+0xce/0xf0=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
> [10055.732959]  system_call+0x82/0xb0=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20

And that memory was last used as a struct file *, again something
that XFS does not allocate but will be allocated by the NFSD as it
opens and closes the files it receives requests to process for...

> [10058.575635] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575638]  [<000000007a989e3c>] qlist_free_all+0x9c/0x130=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575643] ([<000000007a989e1e>] qlist_free_all+0x7e/0x130)=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575647]  [<000000007a98a45a>] kasan_quarantine_reduce+0x16a/0x1c0=
=20=20=20=20=20=20
> [10058.575652]  [<000000007a98720e>] __kasan_slab_alloc+0x9e/0xb0=20=20=
=20=20=20=20=20=20=20=20=20=20=20
> [10058.575657]  [<000000007a9810a4>] __kmalloc+0x214/0x440=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575663]  [<000000007ab19aa6>] inotify_handle_inode_event+0x1b6/0x7=
d0=20=20=20
> [10058.575669]  [<000000007ab0ee74>]
> fsnotify_handle_inode_event.isra.0+0x1c4/0x=20
> 2f0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
> [10058.575674]  [<000000007ab0f490>] send_to_group+0x4f0/0x6c0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575678]  [<000000007ab0fe14>] fsnotify+0x654/0xb30=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575682]  [<000000007ab10ca2>] __fsnotify_parent+0x372/0x780=20=20=
=20=20=20=20=20=20=20=20=20=20
> [10058.575687]  [<000000007aa7eb9e>] notify_change+0x96e/0xcf0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575693]  [<000000007aa0a0c8>] do_truncate+0x108/0x190=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575699]  [<000000007aa0aafc>] do_sys_ftruncate+0x31c/0x600=20=20=
=20=20=20=20=20=20=20=20=20=20=20
> [10058.575703]  [<000000007a18da8c>] do_syscall+0x22c/0x330=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575709]  [<000000007bc2cb6e>] __do_syscall+0xce/0xf0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575716]  [<000000007bc55722>] system_call+0x82/0xb0=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575722] INFO: lockdep is turned off.=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575725] Last Breaking-Event-Address:=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575727]  [<000000007a985860>] ___cache_free+0x150/0x2a0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [10058.575733] ---[ end trace 0000000000000000 ]---=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

And this subsequent oops has doesn't have anything to do with XFS
either - this is indicative of slab cache (memory heap) corruption
causing stuff to go badly wrong.

Hence I think XFS is messenger here - something is corrupting the
heap and an NFSD->XFS code path is the first to trip over it.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
