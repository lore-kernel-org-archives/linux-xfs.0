Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE30FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 16:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiDNQPe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 12:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351781AbiDNP5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 11:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C086848338;
        Thu, 14 Apr 2022 08:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C85761CB7;
        Thu, 14 Apr 2022 15:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A99C385A5;
        Thu, 14 Apr 2022 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649950954;
        bh=7ppyfeLEsFnzX/2nuOttB7gRp7Xfq8FfiaugowFFH/8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=YfJg7fy2nQeJi4Qp29ivAAcmlY45sWueBN1Hmh5tyxblIt5yJ8/NoT8YORjgrmsym
         6Z8/rGTF7Mqf+CigyASE9o3GERJx4WJth4/QMoL3NgSNzA6Ki6Qh5sujqLXkW8TrY3
         Q28m0/uf3VFWfvlXOIGHEpuEWnTBa7hLmTEOaDgMURqlMvnx35zhicl95aaSZhciES
         i5G54bkT45+9ZhgRxQhxjOFEfhw0DXHk3EMAFSjxG7t9fJeS3+W5BFeaX2aG8wlwUd
         +6t5XyeUyKweEQYGgWZzyUwbOs4Flp5IGdN4tf7AHjgiNclaxU9xId9pkoQpFBIe6E
         03R0uxtyowMfg==
Date:   Thu, 14 Apr 2022 08:42:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220414154234.GB17014@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971767699.169983.772317637668809854.stgit@magnolia>
 <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
 <20220412172853.GG16799@magnolia>
 <20220414144330.yby7dsxzqeawekmc@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414144330.yby7dsxzqeawekmc@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 10:43:30PM +0800, Zorro Lang wrote:
> On Tue, Apr 12, 2022 at 10:28:53AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 12, 2022 at 05:37:27PM +0800, Zorro Lang wrote:
> > > On Mon, Apr 11, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This is a regression test to make sure that nonzero error returns from
> > > > a filesystem's ->sync_fs implementation are actually passed back to
> > > > userspace when the call stack involves syncfs(2).
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/839.out |    2 ++
> > > >  2 files changed, 44 insertions(+)
> > > >  create mode 100755 tests/xfs/839
> > > >  create mode 100644 tests/xfs/839.out
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/839 b/tests/xfs/839
> > > 
> > > This case looks good to me. Just one question, is it possible to be a generic
> > > case? From the code logic, it doesn't use xfs specified operations, but I'm
> > > not sure if other filesystems would like to treat sync_fs return value as XFS.
> > 
> > Other filesystems (ext4 in particular) haven't been fixed to make
> > ->sync_fs return error codes when the fs has been shut down via
> > FS_IOC_SHUTDOWN.  We'll get there eventually, but for now I'd like to
> > get this under test for XFS since we've applied those fixes.
> 
> If other filesystems intend to do that, how about using a generic case failure to
> remind them they haven't done that :) If they don't intend that, keep this case
> under xfs is good to me.

<shrug> I don't know if they do or not; I've been so strapped for time
trying to get all these fixes out that I haven't had time to ask the
ext4 or btrfs communities, let alone propose patches.

At the moment I'd really like to get as many patches out of djwong-dev
as I can without people asking for more side projects.  As it stands
today, landing the online fsck patchset is going to involve getting 185
kernel patches, 95 xfsprogs patches, and 87 fstests patches all through
review.

--D

> > 
> > > > new file mode 100755
> > > > index 00000000..9bfe93ef
> > > > --- /dev/null
> > > > +++ b/tests/xfs/839
> > > > @@ -0,0 +1,42 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 839
> > > > +#
> > > > +# Regression test for kernel commits:
> > > > +#
> > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > 
> > > BTW, after this change, now can I assume that sync(2) flushes all data and metadata
> > > to underlying disk, if it returns 0.
> > 
> > Yes.
> > 
> > > Sorry, really confused on what these sync things
> > > really guarantee :)
> > 
> > No worries -- the history of the sync variants has been very messy and
> > confusing even to people on fsdevel.
> > 
> > --D
> > 
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +#
> > > > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > > > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > > > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > > > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > > > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > > > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > > > +# so that had to be corrected as well.
> > > > +#
> > > > +# The kernel commits above fix this problem, so this test tries to trigger the
> > > > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > > > +# hope that the EIO generated as a result of the filesystem being shut down is
> > > > +# only visible via ->sync_fs.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick shutdown
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_require_xfs_io_command syncfs
> > > > +_require_scratch_nocheck
> > > > +_require_scratch_shutdown
> > > > +
> > > > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > > > +# bother checking the filesystem afterwards since we never wrote anything.
> > > > +_scratch_mount
> > > > +$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/839.out b/tests/xfs/839.out
> > > > new file mode 100644
> > > > index 00000000..f275cdcc
> > > > --- /dev/null
> > > > +++ b/tests/xfs/839.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 839
> > > > +syncfs: Input/output error
> > > > 
> > > 
> > 
> 
