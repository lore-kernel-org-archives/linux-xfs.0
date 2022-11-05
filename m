Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41B5C433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Nov 2022 12:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKEMaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Nov 2022 08:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKEMaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Nov 2022 08:30:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0211F11178
        for <linux-xfs@vger.kernel.org>; Sat,  5 Nov 2022 05:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667651348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UG+68vg0J0evlCJILqP0y3ejKojyB7tn0LpFwXjR5yI=;
        b=MmUi9qtnZs0W9EnxhI9QxP5bTqit1DU6cFREbqWHfnIeliTTygZbMI3qoddJtrjJqtKrx9
        I3cSmG+DLiuB+/kF9dk+iXg4zK4amp+DFpA/sdXWp51aHTh9cJKcvtKDJ8N1Gf6E0LyYSS
        9hPq0Zvk9gDC7ZMRm9Wyjs4fcYqe1RQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-133-Dmp9j9etMMut-UCvz2wM3g-1; Sat, 05 Nov 2022 08:29:07 -0400
X-MC-Unique: Dmp9j9etMMut-UCvz2wM3g-1
Received: by mail-pl1-f198.google.com with SMTP id c7-20020a170903234700b0018729febd96so5466040plh.19
        for <linux-xfs@vger.kernel.org>; Sat, 05 Nov 2022 05:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UG+68vg0J0evlCJILqP0y3ejKojyB7tn0LpFwXjR5yI=;
        b=rL80YlleZKvBkrUmzi6sGj9tpkGUPW0RMRb5ilB3HLJ9WjpzG98J+KLaoEIdJloEtt
         NX4vJQI5jEIFbscY1SRJctN6uhD641tprdOxL7uGxB73kXVUAs1YHw4WqxOYQoZLbVQX
         qGoxnJDIRighehvJ8ww6zLiMpuWu3g2ddgalVuRaOKItTVTIMTT5lu4S93HGJvGaavkg
         +OKN5x5/D5uPkrnjAbPI6N24aE3eTtIDENiUsx/vQnz0vOn1wKNqpYo5VyTAQumbEZWk
         A8++t4+qmY54B5wpppdcG/YQp44EJO5i63nvVFILJwaqzJ4y3LrM/JHf7bbrby0OEIk0
         FTSA==
X-Gm-Message-State: ACrzQf1MRagq90pVK0eMUDxSQm1giZ/EbRvFBCLScf/NAXF99L84RuF5
        ggF3k8CIH8wQl8oypQws3YfSVx+aEpjfkwcS9ypePmj5tlAAnGZ7vi2vyU0lI/g4a9IxueG7IpI
        HNY5tS0+38HiW2vlYU9C2
X-Received: by 2002:a63:1a60:0:b0:43c:9bcd:6c37 with SMTP id a32-20020a631a60000000b0043c9bcd6c37mr33956162pgm.125.1667651344925;
        Sat, 05 Nov 2022 05:29:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7lYwZE/liac5nSCZsTaj1eIZx+3xoAiUKLeZJxqsGPjLPD3C3JEiybV/sOmnIbKt6f47k7/Q==
X-Received: by 2002:a63:1a60:0:b0:43c:9bcd:6c37 with SMTP id a32-20020a631a60000000b0043c9bcd6c37mr33956145pgm.125.1667651344587;
        Sat, 05 Nov 2022 05:29:04 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ce8700b0018691ce1696sm1579656plg.131.2022.11.05.05.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 05:29:03 -0700 (PDT)
Date:   Sat, 5 Nov 2022 20:28:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <20221105122859.d6lymkxcnsddzb3f@zlang-mailbox>
References: <20221104162002.1912751-1-zlang@kernel.org>
 <Y2U96BrOS2ixJAGh@magnolia>
 <20221105121611.gsq2d4cmp5pasfqo@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105121611.gsq2d4cmp5pasfqo@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 05, 2022 at 08:16:11PM +0800, Zorro Lang wrote:
> On Fri, Nov 04, 2022 at 09:29:28AM -0700, Darrick J. Wong wrote:
> > On Sat, Nov 05, 2022 at 12:20:02AM +0800, Zorro Lang wrote:
> > > An old issue might cause on-disk inode sizes are logged prematurely
> > > via the free eofblocks path on file close. Then fs shutdown might
> > > leave NULL files but their di_size > 0.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > > 
> > > Hi,
> > > 
> > > There was an very old xfs bug on rhel-6.5, I'd like to share its reproducer to
> > > fstests. I've tried generic/044~049, no one can reproduce this bug, so I
> > > have to write this new one. It fails on rhel-6.5 [1], and test passed on
> > > later kernel.
> > > 
> > > I hard to say which patch fix this issue exactly, it's fixed by a patchset
> > > which does code improvement/cleanup.
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > [1]
> > > # ./check generic/999
> > > FSTYP         -- xfs (non-debug)
> > > PLATFORM      -- Linux/x86_64
> > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > > 
> > > generic/999 2s ... - output mismatch (see /root/xfstests-dev/results//generic/999.out.bad)
> > >     --- tests/generic/999.out   2022-11-04 00:54:11.123353054 -0400
> > >     +++ /root/xfstests-dev/results//generic/999.out.bad 2022-11-04 04:24:57.861673433 -0400
> > >     @@ -1 +1,3 @@
> > >      QA output created by 999
> > >     + - /mnt/scratch/1 get no extents, but its di_size > 0
> > >     +/mnt/scratch/1:
> > >     ...
> > >     (Run 'diff -u tests/generic/045.out /root/xfstests-dev/results//generic/999.out.bad'  to see the entire diff)
> > > Ran: generic/999
> > > Failures: generic/999
> > > Failed 1 of 1 tests
> > > 
> > >  tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/999.out |  5 +++++
> > >  2 files changed, 51 insertions(+)
> > >  create mode 100755 tests/generic/999
> > >  create mode 100644 tests/generic/999.out
> > > 
> > > diff --git a/tests/generic/999 b/tests/generic/999
> > > new file mode 100755
> > > index 00000000..a2e662fc
> > > --- /dev/null
> > > +++ b/tests/generic/999
> > > @@ -0,0 +1,46 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 999
> > > +#
> > > +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> > > +# prematurely via the free eofblocks path on file close.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick shutdown
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_io_command fiemap
> > 
> > /me would've thought you'd use the xfs_io stat/bmap commands to detect
> > either nextents > 0 (stat) or actual mappings returned (bmap), but I

Wait a minute... the "stat" command can help this case too?

I didn't use bmap command due to it only for xfs, but stat is a common command,
if it helps, that's better than fiemap (due to it supports old system). I'll
give it a test, and will resend the patch if it works. Thanks your suggestion!

> > guess if RHEL 6.5 xfsprogs has a fiemap command then this is fine with
> > me.
> 
> Ah, you're right, rhel-6 xfs_io doesn't support fiemap :)
> 
> And yes, I wrote this case as a xfs specific case at first, by using xfs_bmap.
> The original case (of us) uses xfs_bmap too. But I thought fiemap can help it
> to be a generic case to cover more fs, so I turn to use fiemap.
> 
> > 
> > If the answer to the above is "um, RHEL 6.5 xfsprogs *does* have FIEMAP",
> > then there's little point in rewriting a stable regression test, so:
> 
> I don't worry about rhel6 testing, due to I keep our internal case (for rhel6
> only). I'd like to see more generic cases, except fiemap can't help this test :)
> 
> Thanks,
> Zorro
> 
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> > > +_require_scratch_shutdown
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +echo "Create many small files with one extent at least"
> > > +for ((i=0; i<10000; i++));do
> > > +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> > > +done
> > > +
> > > +echo "Shutdown the fs suddently"
> > > +_scratch_shutdown
> > > +
> > > +echo "Cycle mount"
> > > +_scratch_cycle_mount
> > > +
> > > +echo "Check file's (di_size > 0) extents"
> > > +for f in $(find $SCRATCH_MNT -type f -size +0);do
> > > +	$XFS_IO_PROG -c "fiemap" $f > $tmp.fiemap
> > > +	# Check if the file has any extent
> > > +	grep -Eq '^[[:space:]]+[0-9]+:' $tmp.fiemap
> > > +	if [ $? -ne 0 ];then
> > > +		echo " - $f get no extents, but its di_size > 0"
> > > +		cat $tmp.fiemap
> > > +		break
> > > +	fi
> > > +done
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > > new file mode 100644
> > > index 00000000..50008783
> > > --- /dev/null
> > > +++ b/tests/generic/999.out
> > > @@ -0,0 +1,5 @@
> > > +QA output created by 999
> > > +Create many small files with one extent at least
> > > +Shutdown the fs suddently
> > > +Cycle mount
> > > +Check file's (di_size > 0) extents
> > > -- 
> > > 2.31.1
> > > 
> > 

