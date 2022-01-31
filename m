Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02821C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiAaXj3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:39:29 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35092 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229642AbiAaXj1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:39:27 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7AACA62C4B6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 10:39:24 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-006aS0-Qi
        for linux-xfs@vger.kernel.org; Tue, 01 Feb 2022 10:39:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-003I1t-Nu
        for linux-xfs@vger.kernel.org;
        Tue, 01 Feb 2022 10:39:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5 v2] xfs: fallocate() vs xfs_update_prealloc_flags()
Date:   Tue,  1 Feb 2022 10:39:15 +1100
Message-Id: <20220131233920.784181-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f8732c
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=p2abxV9NUEgnOpzo1_kA:9
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

From Darrick's original patch set:

https://lore.kernel.org/linux-xfs/164351876356.4177728.10148216594418485828.stgit@magnolia/T/#m8785dae565ff0f68ade64ca720debd483f566d6c

While auditing the file permission dropping for fallocate, I reached the
conclusion that fallocate can modify file contents, and therefore should
be treated as a file write.  As such, it needs to update the file
modification and file (metadata) change timestamps, and it needs to drop
file privileges such as setuid and capabilities, just like a regular
write.  Moreover, if the inode is configured for synchronous writes,
then all the fallocate changes really ought to be persisted to disk
before fallocate returns to userspace.

Unfortunately, the XFS fallocate implementation doesn't do this
correctly.  setgid without group-exec is a mandatory locking mark and is
left alone by write(), which means that we shouldn't drop it
unconditionally.  Furthermore, file capabilities are another vector for
setuid to be set on a program file, and XFS ignores these.

I also noticed that fallocate doesn't flush the log to disk after
fallocate when the fs is mounted with -o sync or if the DIFLAG_SYNC flag
is set on the inode.

Therefore, refactor the XFS fallocate implementation to use the VFS
helper file_modified to update file metadata instead of open-coding it
incorrectly.  Refactor it further to use xfs_file_sync_writes to decide
if we need to flush the log; and then fix the log flushing so that it
flushes after we've made /all/ the changes.

--

And from my reply:

https://lore.kernel.org/linux-xfs/164351876356.4177728.10148216594418485828.stgit@magnolia/T/#m58cedaa33368c619fcdfb53639fce881bacfa9d3

This is more along the lines of what I was thinking. Unfortunately,
xfs_fs_map_blocks() can't be made to use file based VFS helpers, so
the whole "open code the permissions stripping on data extent
allocation" thing needs to remain in that code. Otherwise, we can
significantly clean up xfs_file_fallocate() and completely remove
the entire transaction that sets the prealloc flag. And given that
xfs_ioc_space() no longer exists, most of the option functionality
that xfs_update_prealloc_flags() provides is no longer necessary...

--

This is an updated version based on 5.17-rc2 that has been run
through fstests now and there are no apparent regressions from these
changes. 

Version 2:
- add missing error handling (patch 1)
- fix whitespace damage (patch 3)
- remove redundant comments in xfs_alloc_file_space (patch 3)
- rework comments to provide context to security issues around
  PNFS operations (patch 4)


