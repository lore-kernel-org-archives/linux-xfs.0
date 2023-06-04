Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1D7C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 05:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjFDFvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 01:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjFDFva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 01:51:30 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93DDAF
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jun 2023 22:51:28 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f805d07040so27321341cf.3
        for <linux-xfs@vger.kernel.org>; Sat, 03 Jun 2023 22:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685857888; x=1688449888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBDm4RSnbGjJZ7dBFgGz699uhT56mWJWOj0zL3b/W3Q=;
        b=NgEoUQEsQ5jZuNeaLCh1E4+xMKAzQFrcGKJLqgR44V+3YTnLg5/gc1l3D+z1WSpJHj
         UWR//c0nUtSpiwDxahKn0CiICzDQ6lzkp3LZhi1rqnILx7HCXTJJxjRypILDPR/3pOHB
         OHQroxwCi8dsC1U/VkkQ9zen+5TLCJNS0keDgG/78ijlvMSRbyYpKoLMjb/bpWI47t0s
         t+IxEX5/RSJzfFtaasp/rVSzX4VBEtH34SmKNyFxNRurbwjoKdK/Oa/V3jXf6NOO8hEh
         7Tpkl/P8RQooXYEJe5xcwbHw8W0D/S4JNBknKabYVbqPtvbKlz7a1LO5Nbike7fdFosp
         opEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685857888; x=1688449888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBDm4RSnbGjJZ7dBFgGz699uhT56mWJWOj0zL3b/W3Q=;
        b=FtQ5N0AP4p+xAy+QAPzf6yf1OqK6pmwq7FpxYK1AQw2W/q/A9/dm+3D3hyaSntbu0F
         2pI22UeqU0heyHsiZxlsVGEz4RxldttU/CVEG3woJyJaZAhWd8gQfuhzro4ve9aBpEbt
         SGSby7O9WqkDzQFoP9S4Mv2/R2scozFV3BTmFveJg55ATsbA90YfVnGi4yqo2+W0gBQn
         lWJjx2O4c+nrCMKd//DmjaZAiqPSaDqegHPkqjAn9qKt+qUz4T+Gs0KB/sxw54nnMhK6
         ULFgGg1ximoY2SzjioUnJoeeSkMTsSVWidGAh9AJNzehrTgMzpnvQgGVyHJs8m4Iapzm
         aB6g==
X-Gm-Message-State: AC+VfDzB/KG1rDBNafiVl0rMdn0eCBceWP9eVIrCb+VVWVg8c1L4Kzqh
        IyhR5599T8hkmfQG0l+ChAjvZY1LqGJoLgKcJh18NH7I
X-Google-Smtp-Source: ACHHUZ6vX9uaS6EjVqVeF4a9BF8ugAwGTF+YVsotTxztw+tWSN6sU3n+ITThSctU31qGLpo5xFI3soKcloX0izQk4wk=
X-Received: by 2002:ac8:5b91:0:b0:3f5:3641:f3ba with SMTP id
 a17-20020ac85b91000000b003f53641f3bamr3985145qta.3.1685857887787; Sat, 03 Jun
 2023 22:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230411233159.GH360895@frogsfrogsfrogs> <20230601130351.GA1787684@google.com>
 <20230601151146.GH16865@frogsfrogsfrogs>
In-Reply-To: <20230601151146.GH16865@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 4 Jun 2023 08:51:16 +0300
Message-ID: <CAOQ4uxg3=azXC+b=c1mzQgbM2HWfsAzD+82M1j+5=b-Em+3qug@mail.gmail.com>
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <lrumancik@google.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 1, 2023 at 6:18=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jun 01, 2023 at 02:03:51PM +0100, Lee Jones wrote:
> > Hi Darrick,
> >
> > On Tue, 11 Apr 2023, Darrick J. Wong wrote:
> >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > syzbot detected a crash during log recovery:
> > >
> > > XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f=
791
> > > XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Tr=
uncating head block from 0x200.
> > > XFS (loop0): Starting recovery (logdev: internal)
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x=
6d0 fs/xfs/libxfs/xfs_btree.c:1813
> > > Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074
> > >
> > > CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkalle=
r #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 10/26/2022
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:88 [inline]
> > >  dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
> > >  print_address_description+0x74/0x340 mm/kasan/report.c:306
> > >  print_report+0x107/0x1f0 mm/kasan/report.c:417
> > >  kasan_report+0xcd/0x100 mm/kasan/report.c:517
> > >  xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:181=
3
> > >  xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
> > >  xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:47=
13
> > >  xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
> > >  xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_ref=
count.c:1946
> > >  xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
> > >  xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
> > >  xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
> > >  xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
> > >  xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
> > >  get_tree_bdev+0x400/0x620 fs/super.c:1282
> > >  vfs_get_tree+0x88/0x270 fs/super.c:1489
> > >  do_new_mount+0x289/0xad0 fs/namespace.c:3145
> > >  do_mount fs/namespace.c:3488 [inline]
> > >  __do_sys_mount fs/namespace.c:3697 [inline]
> > >  __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7f89fa3f4aca
> > > Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f =
84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a=
5
> > > RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
> > > RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
> > > RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
> > > R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
> > > R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
> > >  </TASK>
> > >
> > > The fuzzed image contains an AGF with an obviously garbage
> > > agf_refcount_level value of 32, and a dirty log with a buffer log ite=
m
> > > for that AGF.  The ondisk AGF has a higher LSN than the recovered log
> > > item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
> > > LSNs, and decides to skip replay because the ondisk buffer appears to=
 be
> > > newer.
> > >
> > > Unfortunately, the ondisk buffer is corrupt, but recovery just read t=
he
> > > buffer with no buffer ops specified:
> > >
> > >     error =3D xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> > >                     buf_f->blf_len, buf_flags, &bp, NULL);
> > >
> > > Skipping the buffer leaves its contents in memory unverified.  This s=
ets
> > > us up for a kernel crash because xfs_refcount_recover_cow_leftovers
> > > reads the buffer (which is still around in XBF_DONE state, so no read
> > > verification) and creates a refcountbt cursor of height 32.  This is
> > > impossible so we run off the end of the cursor object and crash.
> > >
> > > Fix this by invoking the verifier on all skipped buffers and aborting
> > > log recovery if the ondisk buffer is corrupt.  It might be smarter to
> > > force replay the log item atop the buffer and then see if it'll pass =
the
> > > write verifier (like ext4 does) but for now let's go with the
> > > conservative option where we stop immediately.
> > >
> > > Link: https://syzkaller.appspot.com/bug?extid=3D7e9494b8b399902e994e
> > > Fixes: 67dc288c2106 ("xfs: ensure verifiers are attached to recovered=
 buffers")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_buf_item_recover.c |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> >
> > Rightly or wrongly, CVE-2023-212 has been raised against this issue.
> >
> > It looks as though the Fixes: tag above was stripped when applied.
> >
> > Should this still be submitted to Stable?
>
> Yes, but we have not been successful in persuading any company to pick
> up stable backporting and QA for any kernel newer than 5.15.
>

All right. I tested this one on 6.1.31. No regressions observed.

Darrick,

I know you literally said Yes to stable above,
but please state your official ACK and I will send it to stable 6.1.y
so that we can follow up with the rest of the LTS

Thanks,
Amir.
