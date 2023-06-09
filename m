Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415EEC7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 12:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjFIMtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240759AbjFIMt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 08:49:26 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24ACDD;
        Fri,  9 Jun 2023 05:49:25 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-78ca4500467so136990241.3;
        Fri, 09 Jun 2023 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686314964; x=1688906964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTPAv/QmjcDW9itePSk8p0/Lv0ERnxt+H+GsshWp374=;
        b=pL8nRL6Ys7H3ld011/8hTdheGeuaBsPhbmQDZ4Z1ySwVW2a8floEfkOymaAdfFIqDE
         XvaFds6FQQ/D77PCczDUMDzrlD2y0PUEmVGyK+Za2Vg2p/ACPWPZgI8q2jTUxkaNAjGG
         oYC/OrtdafOpHy0NJlxPFEfXrwkb8KkH0BaK74qGHpzN9z+6khIqAWrReVClLzBGZG8x
         10fH0Um5TL1iFJ7PSTlqFbORupwBvrz2WBEmMUFsOsv6KeieEnAuRSZuK0OMBk9kfFJ6
         XMWQiHU88IYd0NSaOCWL26GCixanuAmO4w202lR59m6xkxrg+diQ1rnJ/ZxhilDrdt+s
         rKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686314964; x=1688906964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTPAv/QmjcDW9itePSk8p0/Lv0ERnxt+H+GsshWp374=;
        b=BI8VyNxg+9/0WuzpsQ4eu3maXfgyIISafjFkx1ACTcJ8KbZvXBsvUwxGouJ04jGqmO
         3fvXByjWYyKlInwFlmR4INmgYupBpgYp85uIa0Z5xtmec+AUT34M5R5uknAQt8eZDeIB
         qjF79Qg6dSCI797QrmIOscX4v77bq9dcepxoQRWBM/mv5DrLzmFyzLi7YKauHloUhFSh
         8sJvz7bXIVR2la84HO0EPdPa/xzj6u5LdEbeIyc6g6cjuFfxmunw1qqZ5D3IFqUUaoIc
         /mpbIdBW7Qb0GGpZV/q63fvOELr7NJPLz/mRXjc5nBecIFh8TRpzdTfky+/jEN7LlRsL
         PjDw==
X-Gm-Message-State: AC+VfDwktCmdjin7/bWh5/ZEqx4E2BIdAIWYdfs+W7SAN6rnafrjc0gq
        EPI6/WUDePX8bigv/DzLwR6IBAq08/+behyL4PU=
X-Google-Smtp-Source: ACHHUZ76jiqSSjSIyfsl93o0Co07GwwFWZdtwinJbc3NVvchMlzGphKlV2aYfRJYZR2LdsQ47eBbLDhxGRGQtUo7UXY=
X-Received: by 2002:a67:f705:0:b0:439:31ec:8602 with SMTP id
 m5-20020a67f705000000b0043931ec8602mr516954vso.27.1686314964367; Fri, 09 Jun
 2023 05:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230605075258.308475-1-amir73il@gmail.com>
In-Reply-To: <20230605075258.308475-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 9 Jun 2023 15:49:13 +0300
Message-ID: <CAOQ4uxgkS2Ma36o2c6FBtnXnxr=KEF02646UL11hT1k489-wYA@mail.gmail.com>
Subject: Re: [PATCH 6.1] xfs: verify buffer contents when we skip log replay
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Danila Chernetsov <listdansp@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 5, 2023 at 10:53=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.
>
> syzbot detected a crash during log recovery:
>
> XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Trunca=
ting head block from 0x200.
> XFS (loop0): Starting recovery (logdev: internal)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 =
fs/xfs/libxfs/xfs_btree.c:1813
> Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074
>
> CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
>  print_address_description+0x74/0x340 mm/kasan/report.c:306
>  print_report+0x107/0x1f0 mm/kasan/report.c:417
>  kasan_report+0xcd/0x100 mm/kasan/report.c:517
>  xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
>  xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
>  xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
>  xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
>  xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcoun=
t.c:1946
>  xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
>  xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
>  xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
>  xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
>  xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
>  get_tree_bdev+0x400/0x620 fs/super.c:1282
>  vfs_get_tree+0x88/0x270 fs/super.c:1489
>  do_new_mount+0x289/0xad0 fs/namespace.c:3145
>  do_mount fs/namespace.c:3488 [inline]
>  __do_sys_mount fs/namespace.c:3697 [inline]
>  __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f89fa3f4aca
> Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 0=
0 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
> RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
> RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
> R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
> R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
>  </TASK>
>
> The fuzzed image contains an AGF with an obviously garbage
> agf_refcount_level value of 32, and a dirty log with a buffer log item
> for that AGF.  The ondisk AGF has a higher LSN than the recovered log
> item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
> LSNs, and decides to skip replay because the ondisk buffer appears to be
> newer.
>
> Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> buffer with no buffer ops specified:
>
>         error =3D xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
>                         buf_f->blf_len, buf_flags, &bp, NULL);
>
> Skipping the buffer leaves its contents in memory unverified.  This sets
> us up for a kernel crash because xfs_refcount_recover_cow_leftovers
> reads the buffer (which is still around in XBF_DONE state, so no read
> verification) and creates a refcountbt cursor of height 32.  This is
> impossible so we run off the end of the cursor object and crash.
>
> Fix this by invoking the verifier on all skipped buffers and aborting
> log recovery if the ondisk buffer is corrupt.  It might be smarter to
> force replay the log item atop the buffer and then see if it'll pass the
> write verifier (like ext4 does) but for now let's go with the
> conservative option where we stop immediately.
>
> Link: https://syzkaller.appspot.com/bug?extid=3D7e9494b8b399902e994e
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Reported-by: Danila Chernetsov <listdansp@mail.ru>
> Link: https://lore.kernel.org/linux-xfs/20230601164439.15404-1-listdansp@=
mail.ru
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
>
> Greg,
>
> This is the backport proposed by Danila for 5.10.y.
> I've already tested it on 6.1.y as well as 5.10.y, but waiting for Leah t=
o
> test 5.15.y before requesting apply to 5.10.y.
>

Greg,

Leah has tested and posted for 5.15.
So please apply to 5.10 as well.

Thanks,
Amir.
