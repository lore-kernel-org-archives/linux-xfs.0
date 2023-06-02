Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0940FC7EE2C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 10:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbjFBKQ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbjFBKQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 06:16:28 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF5418D
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 03:16:26 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-437e2e0a5c7so532812137.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jun 2023 03:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685700985; x=1688292985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNQwbfwa2ljTIbuntiwWlYIAjybuLedTewwv2ZHLZ50=;
        b=qgtHLsNQlU/21wX3zFtNkWbvAM9ftDJYoZdLqrd8bbIB7YVY1hCArtEv0JveAtvLV8
         MEq2Ly2ygV2XAGJM0o2DdaIcAzu7MY6lrZ8MitOq1Y77ng0uHjGGugMhy50TAyh6bJO4
         6Zb9MTjDQigRvgtSJtFjvjn4hHQT15MpuvlX1JhHA0OQrF4VTSZ9ZikeRdx8XkrMC/Sj
         sXC45lnQfmTGuwEwF0EY0pleeeDulWd1OMqeJeWzKj9q/13yJCdXJgh4XzLAKq0EDYtF
         QFwuvLTcLFuCiFfItuuTwiSuRT5XIey4vj0L9qQgXf1YeczALJZ/Z0z+ywhcJLfvm+Pz
         RL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685700985; x=1688292985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNQwbfwa2ljTIbuntiwWlYIAjybuLedTewwv2ZHLZ50=;
        b=FQPrWPB6xRKApCd80ryf6YjRnA+PnGyFRoSJ/7w+A7vZ2nQSyX0hPn91fOMD6hP2/p
         irhmYyUeWWfifGj3VJ9swDzJQH1XXTNRIRVmKjjHMExPZgwS1XivYzvVga/eDCGyYK9V
         bgIWzKRAqwoUrjR4VWDCLEnOI2qvYQxzTLdDBVS9fJ1ci5ZtBD9Umz9k6QsFvd5aZxRc
         5lvsVfRlpaRZs7xM+FDNwSw7jYUiBDAfC29ayK/z7wZplF0Dq8YlCXbrsVbvf208gsce
         4xIqe9xTqPJ6il4TfadYRrRx7Fm1zzZ99ddZeJCzOkeitbXGGFMsBLrmHNUTVpC4MXRS
         Mr1A==
X-Gm-Message-State: AC+VfDz5YT2pyojov+0y6rP7aNxwSv1UVzhDdlhFzVyWhvm9Oc373Toq
        Sb0dZm22/GRMGpRjdz/7/kaDR8Nkzxu4E2QSWlI=
X-Google-Smtp-Source: ACHHUZ7f5T7Qj0K2fqQXEVgE5vRYjoQ6Y1zwsc1YiuOYcXVKbIrSKuqUhfkamrfuURnV7PiApZKNqz38Zjrqf2MenFI=
X-Received: by 2002:a67:fb19:0:b0:432:8d2b:893 with SMTP id
 d25-20020a67fb19000000b004328d2b0893mr4872457vsr.28.1685700985043; Fri, 02
 Jun 2023 03:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230411233159.GH360895@frogsfrogsfrogs> <20230601130351.GA1787684@google.com>
 <20230601151146.GH16865@frogsfrogsfrogs>
In-Reply-To: <20230601151146.GH16865@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 2 Jun 2023 13:16:13 +0300
Message-ID: <CAOQ4uxh5m9VHnq0JG9BeAjAXyRdYy0fi9NwJVgWvH2tD7f9mLA@mail.gmail.com>
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <lrumancik@google.com>
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

I already have a kdevops baseline that I established for xfs-6.1.y when
I backported the SGID vfs fixes, so it is not a problem for me to test
this patch (or any other if you have hints).

I have not yet invested in selecting patches for backport, partly
because Leah wrote that she intends to take this up.

Leah, if your priorities have changed, I can try to start collecting
candidates for backport in my spare time, whenever that will be.

In any case, testing the occasional patch for 6.1.y is something that
I can do until a company/distro becomes the owner of xfs-6.1.y.

Darrick et al.,

If you want me to test any other patches for 6.1.y, please let me know.

Thanks,
Amir.
