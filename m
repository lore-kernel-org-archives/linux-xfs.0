Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169F4C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358173AbiDLRcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358132AbiDLRbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EF15C863;
        Tue, 12 Apr 2022 10:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8DB7619D9;
        Tue, 12 Apr 2022 17:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6BEC385A1;
        Tue, 12 Apr 2022 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649784534;
        bh=892eiTQnFOscJejq2H7a/GrwClHcPXnANs6NWcesbUg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=gL/73OGlnqtnxVdHpBsBHXg9TnZ6v8QeBtUT/tG5d865unM/pS9XG0lVGKKtvuIDQ
         ZtYv8niD6t5z9MeYr8CmOCAesGOMMXBMqG+eIipN2aCbMZTyO3lb3PwxHJCo58ekRM
         1P2b/nIK9rww84UjgxTyy7GWID+7lApjvzmTFaC4rJfmf6M/fooQrRccGXYjnTeHLa
         IgLkx3FqVaMh70vdOOGcRjQylT+PKrS26KH7Sij7ODACzwKKY4EXtBsrQvGAJlJurc
         EIuq1XkNlFcIA+NQeMVAFOtV9JOkqpYEh2Kn6+FA8pPlW/8OAxCSVfZNXNFtJQ0t+V
         Z2Z3gUe/DjrOQ==
Date:   Tue, 12 Apr 2022 10:28:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220412172853.GG16799@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971767699.169983.772317637668809854.stgit@magnolia>
 <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 05:37:27PM +0800, Zorro Lang wrote:
> On Mon, Apr 11, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
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
> 
> This case looks good to me. Just one question, is it possible to be a generic
> case? From the code logic, it doesn't use xfs specified operations, but I'm
> not sure if other filesystems would like to treat sync_fs return value as XFS.

Other filesystems (ext4 in particular) haven't been fixed to make
->sync_fs return error codes when the fs has been shut down via
FS_IOC_SHUTDOWN.  We'll get there eventually, but for now I'd like to
get this under test for XFS since we've applied those fixes.

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
> 
> BTW, after this change, now can I assume that sync(2) flushes all data and metadata
> to underlying disk, if it returns 0.

Yes.

> Sorry, really confused on what these sync things
> really guarantee :)

No worries -- the history of the sync variants has been very messy and
confusing even to people on fsdevel.

--D

> 
> Thanks,
> Zorro
> 
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
