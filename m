Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FC8C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 21:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355188AbiCXVk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354221AbiCXVk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 17:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789983F336;
        Thu, 24 Mar 2022 14:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146E061359;
        Thu, 24 Mar 2022 21:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69088C340EC;
        Thu, 24 Mar 2022 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648157935;
        bh=hhZo3GBcB74rH01qnpUvnw8P4Cw1qTVWAZJxRx0FaJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QimPqtIAlf2ZRLLVVbgMci528d5A5qRtyHKSfdhjOSey9Cn8m9oukBqwXdSjGVBzs
         c1rR1dKHA7+0KFYCYDtLBwp8uOU9zrjibcR+yJOAVbyoiVdhUvJ5GT7tx5e+OLPwCt
         PvsN78nv4263oACADUYWhTis7oniV45ASnUrMn24Xq4bm5cxUqjqqlCDHvMWZthKv+
         f5ubfpm1LRYBMECbwh0YIu9k6TANnZ7t0aQT4q1C5ONSzFcGxidyMnvf9pIQw5T0Vn
         duiJPJtnQLcNfZOKzSmtfHxFVuoUiC6ruiCRO6LHCB91wxetUjr6Vhmq1z0GOe7ahS
         I/qARFyY/Q4Ug==
Date:   Thu, 24 Mar 2022 14:38:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220324213854.GS8200@magnolia>
References: <164740142940.3371809.12686819717405148022.stgit@magnolia>
 <164740143497.3371809.2959237196772812909.stgit@magnolia>
 <20220323024432.44wf2xhpv3z55txp@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323024432.44wf2xhpv3z55txp@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[adding tytso for the ext4 question]

On Wed, Mar 23, 2022 at 10:44:32AM +0800, Zorro Lang wrote:
> On Tue, Mar 15, 2022 at 08:30:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test to make sure that nonzero error returns from
> > a filesystem's ->sync_fs implementation are actually passed back to
> > userspace when the call stack involves syncfs(2).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/839.out |    2 ++
> >  2 files changed, 44 insertions(+)
> >  create mode 100755 tests/xfs/839
> >  create mode 100644 tests/xfs/839.out
> > 
> > 
> > diff --git a/tests/xfs/839 b/tests/xfs/839
> > new file mode 100755
> > index 00000000..9bfe93ef
> > --- /dev/null
> > +++ b/tests/xfs/839
> > @@ -0,0 +1,42 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 839
> > +#
> > +# Regression test for kernel commits:
> > +#
> > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > +#
> > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > +# so that had to be corrected as well.
> > +#
> > +# The kernel commits above fix this problem, so this test tries to trigger the
> > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > +# hope that the EIO generated as a result of the filesystem being shut down is
> > +# only visible via ->sync_fs.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick shutdown
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_require_xfs_io_command syncfs
> > +_require_scratch_nocheck
> > +_require_scratch_shutdown
> 
> Can this case be a generic case, with the help of _require_scratch_shutdown
> and _require_xfs_io_command?

I'm not sure.  Of the three filesystems that both have a ->sync_fs
function and implement FS_IOC_SHUTDOWN, xfs and f2fs look like they
passes errors like they should.

ext4 is another story -- curiously, if the fs is shut down, it'll return
0 and it doesn't check the return value of dquot_writeback_dquots.  I
don't remember enough of ext to know if that's deliberate or merely an
age-old artifact of the Bad Old Days when that whole code path didn't
care about errors.

--D

> Thanks,
> Zorro
> 
> > +
> > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > +# bother checking the filesystem afterwards since we never wrote anything.
> > +_scratch_mount
> > +$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/839.out b/tests/xfs/839.out
> > new file mode 100644
> > index 00000000..f275cdcc
> > --- /dev/null
> > +++ b/tests/xfs/839.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 839
> > +syncfs: Input/output error
> > 
> 
