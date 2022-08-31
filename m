Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFA5ECAAA1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 00:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiHaAKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiHaAKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 20:10:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761D649B58;
        Tue, 30 Aug 2022 17:10:34 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q15so7528261pfn.11;
        Tue, 30 Aug 2022 17:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QLiKYqdI1KiuJx5ULNik5L1yb8NhaJKxbFBCsKQAtBw=;
        b=JDY1+qdiL0JRXboT215qoRyPDRoQIMzSGvN6+Pv+r1ytU3mcF9CSOzfeocPmLqhDwB
         UMvPESXyaSEJGj01kQeOaoc38ZndtIs7q9p0F+5CSi3HuxKpCTwKOy5HxJZdxlk9cxWv
         OgeXfLb60SPnPQdBkjpQelZvyGaCz/4OJi+UA5H3GTf5nHCHY6k+vSRKNqbhQs6XpomS
         GbuZzmGcgLHDZwWw7ZpcNsFWqVl1eU3hLae1dgGbuvEYxtTIkp38P0F66lqyzXpjhH0l
         5m2TMkkLR1WjwbB5ZcBElJZxmK1HVhVlytjoK84YeDSheWYWL8PusIwR0GFxDYYG3ICq
         N7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QLiKYqdI1KiuJx5ULNik5L1yb8NhaJKxbFBCsKQAtBw=;
        b=Rjz7r9diXcw8f7ldk3XCLoqjqGyaevmVYITJtuxawrOs8H8jqGDr6QTX4hA+ZBYiMs
         VXjTFDguFC2SD6mU/CjFI44T8GbXtj4ZZBMzq44bJjWYO0XDqHtnMJoD4O98AkwPovU4
         gL1E52gWiDg7JqOr0earYuyeX31b+G+AQsKRNitWAa5KscZcVSm6Es7lMfTBETAnSF9D
         /6Q9j0OGIk8NgbU1U47sWXby/jQvRcjbHRPrhMT/Cn4JFbQ7AP36yJqbZGAdE55n7uTF
         NaXXoXKlBtSTysuzGO76RIEpIaUQt2NmPrmcxnxZi1WizgnWCcSVSqX/W5fsBW4KzLJH
         KDWA==
X-Gm-Message-State: ACgBeo2p/EeJCrwU27z94C0Cg0Rd3wygwHnZtEU4ajL85TGtnoQ/0Ue2
        ikFuvnA9mPC85ByO4e78cWMMNHaSX9dztCkfE9NE9wW7dqA=
X-Google-Smtp-Source: AA6agR4R2zwM5m1tdy+zEJChk+4o+Qe//ICLJUGoIw0AL8xGcj0y+QXQdofmm/zOrXCjnz+e91vfZfYWW3U6nEipYPc=
X-Received: by 2002:aa7:8055:0:b0:536:df46:c567 with SMTP id
 y21-20020aa78055000000b00536df46c567mr23975113pfm.1.1661904633901; Tue, 30
 Aug 2022 17:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-4-jencce.kernel@gmail.com> <Yw4nSjAsFbCYveP+@magnolia>
In-Reply-To: <Yw4nSjAsFbCYveP+@magnolia>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 08:10:21 +0800
Message-ID: <CADJHv_tWzv6L-s63VjR0_TGZgapH5UR-S+bK41msrQJsO_o8bg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] tests/xfs: remove single-AG options
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 11:05 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Aug 30, 2022 at 12:44:32PM +0800, Murphy Zhou wrote:
> > Since this xfsprogs commit:
> >       6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > Single-AG xfs is not allowed.
> >
> > Remove agcount=1 from mkfs options and xfs/202 entirely.
>
> It's not supported for /new/ filesystems, but the rest of the tools must
> continue the same levels of support for existing filesystems, even if
> they cannot be created today.

All these changes, all of them, only fix mkfs complaints, not others.

So it is ONLY about creating new filesystems, not the existing ones.

>
> Second, there exist fstests that need to create a specific layout to
> test some part of the code.  Single-AG filesystems sometimes make this
> much easier.

But it's not allowed to be made by mkfs.xfs. Most of fstests create fs
from scratch, it's hard to cover in this situation.

Thanks,
Murphy

>
> Both of these reasons are why fstests (and LTP) get a special pass on
> all the new checks in mkfs 5.19.
>
> IOWs, we still need to check that xfs_repair works ok for existing
> single AG filesystems.  We can perhaps drop these tests in a decade or
> so, but now is premature.
>
> --D
>
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  tests/xfs/179     |  2 +-
> >  tests/xfs/202     | 40 ----------------------------------------
> >  tests/xfs/202.out | 29 -----------------------------
> >  tests/xfs/520     |  2 +-
> >  4 files changed, 2 insertions(+), 71 deletions(-)
> >  delete mode 100755 tests/xfs/202
> >  delete mode 100644 tests/xfs/202.out
> >
> > diff --git a/tests/xfs/179 b/tests/xfs/179
> > index ec0cb7e5..f0169717 100755
> > --- a/tests/xfs/179
> > +++ b/tests/xfs/179
> > @@ -22,7 +22,7 @@ _require_cp_reflink
> >  _require_test_program "punch-alternating"
> >
> >  echo "Format and mount"
> > -_scratch_mkfs -d agcount=1 > $seqres.full 2>&1
> > +_scratch_mkfs > $seqres.full 2>&1
> >  _scratch_mount >> $seqres.full 2>&1
> >
> >  testdir=$SCRATCH_MNT/test-$seq
> > diff --git a/tests/xfs/202 b/tests/xfs/202
> > deleted file mode 100755
> > index 5075d3a1..00000000
> > --- a/tests/xfs/202
> > +++ /dev/null
> > @@ -1,40 +0,0 @@
> > -#! /bin/bash
> > -# SPDX-License-Identifier: GPL-2.0
> > -# Copyright (c) 2009 Christoph Hellwig.
> > -#
> > -# FS QA Test No. 202
> > -#
> > -# Test out the xfs_repair -o force_geometry option on single-AG filesystems.
> > -#
> > -. ./common/preamble
> > -_begin_fstest repair auto quick
> > -
> > -# Import common functions.
> > -. ./common/filter
> > -. ./common/repair
> > -
> > -# real QA test starts here
> > -_supported_fs xfs
> > -
> > -# single AG will cause default xfs_repair to fail. This test is actually
> > -# testing the special corner case option needed to repair a single AG fs.
> > -_require_scratch_nocheck
> > -
> > -#
> > -# The AG size is limited to 1TB (or even less with historic xfsprogs),
> > -# so chose a small enough filesystem to make sure we can actually create
> > -# a single AG filesystem.
> > -#
> > -echo "== Creating single-AG filesystem =="
> > -_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
> > - || _fail "!!! failed to make filesystem with single AG"
> > -
> > -echo "== Trying to repair it (should fail) =="
> > -_scratch_xfs_repair
> > -
> > -echo "== Trying to repair it with -o force_geometry =="
> > -_scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
> > -
> > -# success, all done
> > -echo "*** done"
> > -status=0
> > diff --git a/tests/xfs/202.out b/tests/xfs/202.out
> > deleted file mode 100644
> > index c2c5c881..00000000
> > --- a/tests/xfs/202.out
> > +++ /dev/null
> > @@ -1,29 +0,0 @@
> > -QA output created by 202
> > -== Creating single-AG filesystem ==
> > -== Trying to repair it (should fail) ==
> > -Phase 1 - find and verify superblock...
> > -Only one AG detected - cannot validate filesystem geometry.
> > -Use the -o force_geometry option to proceed.
> > -== Trying to repair it with -o force_geometry ==
> > -Phase 1 - find and verify superblock...
> > -Phase 2 - using <TYPEOF> log
> > -        - zero log...
> > -        - scan filesystem freespace and inode maps...
> > -        - found root inode chunk
> > -Phase 3 - for each AG...
> > -        - scan and clear agi unlinked lists...
> > -        - process known inodes and perform inode discovery...
> > -        - process newly discovered inodes...
> > -Phase 4 - check for duplicate blocks...
> > -        - setting up duplicate extent list...
> > -        - check for inodes claiming duplicate blocks...
> > -Phase 5 - rebuild AG headers and trees...
> > -        - reset superblock...
> > -Phase 6 - check inode connectivity...
> > -        - resetting contents of realtime bitmap and summary inodes
> > -        - traversing filesystem ...
> > -        - traversal finished ...
> > -        - moving disconnected inodes to lost+found ...
> > -Phase 7 - verify and correct link counts...
> > -done
> > -*** done
> > diff --git a/tests/xfs/520 b/tests/xfs/520
> > index d9e252bd..de70db60 100755
> > --- a/tests/xfs/520
> > +++ b/tests/xfs/520
> > @@ -60,7 +60,7 @@ force_crafted_metadata() {
> >  }
> >
> >  bigval=100000000
> > -fsdsopt="-d agcount=1,size=512m"
> > +fsdsopt="-d size=512m"
> >
> >  force_crafted_metadata freeblks 0 "agf 0"
> >  force_crafted_metadata longest $bigval "agf 0"
> > --
> > 2.31.1
> >
