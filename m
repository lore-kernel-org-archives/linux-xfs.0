Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BC0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 11:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiEZLfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 07:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiEZLex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 07:34:53 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4696AA57
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 04:34:50 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id cv1so1406790qvb.5
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 04:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kn+ORS0k9MpDFwY4Hc1SSyifLMeie44QmKSFRXngi6Y=;
        b=Rp7SAxTtK+30Fy8+yHDXM/iolxNrmryv3St8aHk0q2Uh3c2LRAn7727b+8PvS0fhok
         0NJQd11CT1btsxrBlDfj1j1eS/uIfpMa8TS6BjQfjZcnLUngnFipbQS0kZ38EfezSS72
         AUaCb+uhdWiCnBa5kwdeDZdYI7JxSAm2rLKa2ew4m31iPbRrmrkStIWIOGz4lUq5eQik
         fU32qTQ/fs6CYw/W6VVFzmplZtrfC+3m6mEmO61wYdNsvKm3mjdWlk2UUA5WoAADUdWm
         jMSooBwVCkQJIp3VLxqh9ZnVAqJtQof206eXrUBvfzXzK+lniTsmi/BVpQX5t/X7eQ8A
         h4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kn+ORS0k9MpDFwY4Hc1SSyifLMeie44QmKSFRXngi6Y=;
        b=fyO7mnjdaFlrt5guuLx5+GaCQB2ZY9BSk6SQY/++71UHXwwvCuh0JxOZjz6aocddHP
         Ko3YaiVlYM6yMDUM/zuLY9ClbVps4/6SwYpsQ6kZUWbJirNbB3DTUTsnJcyrhyD+zVIK
         N4xHu0rUWtBRYE2b7ylSibnBB3kOgZEV+ADwz4b1T2sWG/Td3gdLStrFJjUVhuziEYWf
         WCz/Epc7kzVHabaT0rLQ0pmm/gRVG7D8CC4YARJOOq/nJkh+6tbu9xtX3vFioVn8tSUT
         ZcTayTw1eFyi/lFo582cYDYSnIFxH5zxq4FugkQQ+bkzOkYhJGaZ9s9AuOZaoWj2GmWd
         yTdg==
X-Gm-Message-State: AOAM531odPP5yHhf6Ert21V0BNpcl9EopKfJGIppWHxquOMqmfAzTgV2
        xaLXSiFEekQfiBkG7pBewipk/TkffnXXnmu0Ims=
X-Google-Smtp-Source: ABdhPJzZHL/giR5v5WzVwVoYYAm+KcSxDPFJwC1zzMzp2I4m1CHXd4sI47PVr00Ko6Sj84JXh3v4M+6Kj5cNm8Cz4TE=
X-Received: by 2002:a05:6214:1c83:b0:443:6749:51f8 with SMTP id
 ib3-20020a0562141c8300b00443674951f8mr29856600qvb.74.1653564889686; Thu, 26
 May 2022 04:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
In-Reply-To: <20210223123106.GB946926@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 14:34:38 +0300
Message-ID: <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 2:35 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Mon, Feb 22, 2021 at 10:27:45AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
> > > Freed extents are marked busy from the point the freeing transaction
> > > commits until the associated CIL context is checkpointed to the log.
> > > This prevents reuse and overwrite of recently freed blocks before
> > > the changes are committed to disk, which can lead to corruption
> > > after a crash. The exception to this rule is that metadata
> > > allocation is allowed to reuse busy extents because metadata changes
> > > are also logged.
> > >
> > > As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> > > has allowed modification or complete invalidation of outstanding
> > > busy extents for metadata allocations. This implementation assumes
> > > that use of the associated extent is imminent, which is not always
> > > the case. For example, the trimmed extent might not satisfy the
> > > minimum length of the allocation request, or the allocation
> > > algorithm might be involved in a search for the optimal result based
> > > on locality.
> > >
> > > generic/019 reproduces a corruption caused by this scenario. First,
> > > a metadata block (usually a bmbt or symlink block) is freed from an
> > > inode. A subsequent bmbt split on an unrelated inode attempts a near
> > > mode allocation request that invalidates the busy block during the
> > > search, but does not ultimately allocate it. Due to the busy state
> > > invalidation, the block is no longer considered busy to subsequent
> > > allocation. A direct I/O write request immediately allocates the
> > > block and writes to it.
> >
> > I really hope there's a fstest case coming for this... :)
> >
>
> generic/019? :) I'm not sure of a good way to reproduce on demand given
> the conditions required to reproduce.
>
> > > Finally, the filesystem crashes while in a
> > > state where the initial metadata block free had not committed to the
> > > on-disk log. After recovery, the original metadata block is in its
> > > original location as expected, but has been corrupted by the
> > > aforementioned dio.
> >
> > Wheee!
> >
> > Looking at xfs_alloc_ag_vextent_exact, I guess the allocator will go
> > find a freespace record, call xfs_extent_busy_trim (which could erase
> > the busy extent entry), decide that it's not interested after all, and
> > bail out without restoring the busy entry.
> >
> > Similarly, xfs_alloc_cur_check calls _busy_trim (same side effects) as
> > we wander around the free space btrees looking for a good chunk of
> > space... and doesn't restore the busy record if it decides to consider a
> > different extent.
> >
>
> Yep. I was originally curious whether the more recent allocator rework
> introduced this problem somehow, but AFAICT that just refactored the
> relevant allocator code and this bug has been latent in the existing
> code for quite some time. That's not hugely surprising given the rare
> combination of conditions required to reproduce.
>
> > So I guess this "speculatively remove busy records and forget to restore
> > them" behavior opens the door to the write allocating blocks that aren't
> > yet free and nonbusy, right?  And the solution presented here is to
> > avoid letting go of the busy record for the bmbt allocation, and if the
> > btree split caller decides it really /must/ have that block for the bmbt
> > it can force the log and try again, just like we do for a file data
> > allocation?
> >
>
> Yes, pretty much. The metadata allocation that is allowed to safely
> reuse busy extents ends up invalidating a set of blocks during a NEAR
> mode search (i.e. bmbt allocation), but ends up only using one of those
> blocks. A data allocation immediately comes along next, finds one of the
> other invalidated blocks and writes to it. A crash/recovery leaves the
> invalidated busy block in its original metadata location having already
> been written to by the dio.
>
> > Another solution could have been to restore the record if we decide not
> > to go ahead with the allocation, but as we haven't yet committed to
> > using the space, there's no sense in thrashing the busy records?
> >
>
> That was my original thought as well. Then after looking through the
> code a bit I thought that something like allowing the allocator to
> "track" a reusable, but still busy extent until allocation is imminent
> might be a bit more straightforward of an implementation given the
> layering between the allocator and busy extent tracking code. IOW, we'd
> split the busy trim/available and busy invalidate logic into two steps
> instead of doing it immediately in the busy trim path. That would allow
> the allocator to consider the same set of reusable busy blocks but not
> commit to any of them until the allocation search is complete.
>
> However, either of those options require a bit of thought and rework
> (and perhaps some value proposition justification for the complexity)
> while the current trim reuse code is pretty much bolted on and broken.
> Therefore, I think it's appropriate to fix the bug in one step and
> follow up with a different implementation separately.
>

Hi Brian,

This patch was one of my selected fixes to backport for v5.10.y.
It has a very scary looking commit message and the change seems
to be independent of any infrastructure changes(?).

The problem is that applying this patch to v5.10.y reliably reproduces
this buffer corruption assertion [*] with test xfs/076.

This happens on the kdevops system that is using loop devices over
sparse files inside qemu images. It does not reproduce on my small
VM at home.

Normally, I would just drop this patch from the stable candidates queue
and move on, but I thought you might be interested to investigate this
reliable reproducer, because maybe this system exercises an error
that is otherwise rare to hit.

It seemed weird to me that NOT reusing the extent would result in
data corruption, but it could indicate that reusing the extent was masking
the assertion and hiding another bug(?).

Can you think of another reason to explain the regression this fix
introduces to 5.10.y?

Do you care to investigate this failure or shall I just move on?

Thanks,
Amir.

[*]
: XFS (loop5): Internal error xfs_trans_cancel at line 954 of file
fs/xfs/xfs_trans.c.  Caller xfs_create+0x22f/0x590 [xfs]
: CPU: 3 PID: 25481 Comm: touch Kdump: loaded Tainted: G            E
   5.10.109-xfs-2 #8
: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
04/01/2014
: Call Trace:
:  dump_stack+0x6d/0x88
:  xfs_trans_cancel+0x17b/0x1a0 [xfs]
:  xfs_create+0x22f/0x590 [xfs]
:  xfs_generic_create+0x245/0x310 [xfs]
:  ? d_splice_alias+0x13a/0x3c0
:  path_openat+0xe3f/0x1080
:  do_filp_open+0x93/0x100
:  ? handle_mm_fault+0x148e/0x1690
:  ? __check_object_size+0x162/0x180
:  do_sys_openat2+0x228/0x2d0
:  do_sys_open+0x4b/0x80
:  do_syscall_64+0x33/0x80
:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
: RIP: 0033:0x7f36b02eff1e
: Code: 25 00 00 41 00 3d 00 00 41 00 74 48 48 8d 05 e9 57 0d 00 8b 00
85 c0 75 69 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d
00 f0 ff ff 0
: RSP: 002b:00007ffe7ef6ca10 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
: RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f36b02eff1e
: RDX: 0000000000000941 RSI: 00007ffe7ef6ebfa RDI: 00000000ffffff9c
: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
: R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
: R13: 00007ffe7ef6ebfa R14: 0000000000000001 R15: 0000000000000001
: XFS (loop5): xfs_do_force_shutdown(0x8) called from line 955 of file
fs/xfs/xfs_trans.c. Return address = ffffffffc08f5764
: XFS (loop5): Corruption of in-memory data detected.  Shutting down filesystem
: XFS (loop5): Please unmount the filesystem and rectify the problem(s)
