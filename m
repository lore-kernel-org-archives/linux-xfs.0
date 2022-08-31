Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABF2ECAAD5
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 00:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiHaACl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiHaACk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 20:02:40 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF8267450;
        Tue, 30 Aug 2022 17:02:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mj6so7571430pjb.1;
        Tue, 30 Aug 2022 17:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zztb5SPCCCHz/KqN3OXQAj9QVlbXU1r8bk9c+Pzi20Y=;
        b=OfDOgzt7naP5KY6vEuPSR90qIuvAFuWCLoATNNQfFRvqTNUUGIfGTRub1FqKLn+Y9P
         +ByOpknRqkTyrmipGhxUL0J3BjnAHxFJDlz3d1/pzTMVZ/xYYL/T2HQ8bvG6w2/BOz/6
         3esewHJupEYfjVH3Eh/MeH7pxRJ5DAdJv2x28vIh+wY4qkeL8Ot9KGfJd67hXr2XtYvH
         Sx2cJz25z0mmql96w357E4tPhPTlgiSqWabY1Jz9HlyE3wLF7F2ugVFJ8Js8rddH+6LL
         Of6Kj7dJbolQFhpEj3EH7Hwy0nAIcIqoxWB+cCDznkB0E8WqDiApbW0BOToqpzhRFH9a
         drpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zztb5SPCCCHz/KqN3OXQAj9QVlbXU1r8bk9c+Pzi20Y=;
        b=bnkF/+aRNiZ7Vqx1F1wtBg3Iu4TdJiuuHpED+aIsp4nQbp3F1siNXpM75lGjlsPAAy
         6RRJc5z7tXJ6zqI17KAHQyO9bGtmRuUEv+PazP7SEFJfw9SbWuFRl5yVhFziSnE84cXo
         TbSTXwm+jOsMPqnhJkl08BPketxPvsB9SaD9i5/Ws8gqaiD6ziOpfJ7ieopORGW+trcp
         vQO3YS6cXRygptPZT/RtqjMf9lWdtb4fLpJnepjq4OmEBkq6cT+DqVq30W4qqfqJfmqT
         e1vbkogWTG4lSPUKBYpPELjC5dc2evXPnRtbZPvvNwIPfUTogtx5QyMYBRddAzXMc3Cu
         qc+Q==
X-Gm-Message-State: ACgBeo1Lt+zqbGSjqe6C1adU5IEN/HKWQ1RVCpaj8YAqKkSR5RzyprnY
        wlGBJO4wr6Z3YYz/lQ7a4tCvD9zA+3PxRPIzYqA=
X-Google-Smtp-Source: AA6agR5sET670AKG+jVD9+Y66Dgq2KS75Zb/lauMKmOgUw/h/9xZk4MQJQy4i1s1tQoSjn7ZZC1V6WayRq7SS8BHmh8=
X-Received: by 2002:a17:90a:cb14:b0:1fd:c964:f708 with SMTP id
 z20-20020a17090acb1400b001fdc964f708mr523142pjt.62.1661904159351; Tue, 30 Aug
 2022 17:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-4-jencce.kernel@gmail.com> <20220830134257.2sve6rwvyvz66lsg@zlang-mailbox>
In-Reply-To: <20220830134257.2sve6rwvyvz66lsg@zlang-mailbox>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 08:02:27 +0800
Message-ID: <CADJHv_uSATsSnpnxaxvYf0N8wDQVU6qDeGuLW-UYmE1_A+NpyA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] tests/xfs: remove single-AG options
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 9:43 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Aug 30, 2022 at 12:44:32PM +0800, Murphy Zhou wrote:
> > Since this xfsprogs commit:
> >       6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > Single-AG xfs is not allowed.
> >
> > Remove agcount=1 from mkfs options and xfs/202 entirely.
> >
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
>
> Looks like all single AG xfs tests are invalid now. As this patch would like to
> remove xfs specific cases or change its original format, better to let xfs list
> review, to make sure they are informed at least.
>
> BTW I remember xfs/041 uses "agcount=1" too, don't we need to change it with
> this patch together?

I changed to agcount=2 with the fs size change patch.

>
> Thanks,
> Zorro
>
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
>
