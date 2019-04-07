Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52010 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfDGU1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Apr 2019 16:27:15 -0400
Subject: [PATCH v2 0/4] vfs: make immutable files actually immutable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 Apr 2019 13:27:01 -0700
Message-ID: <155466882175.633834.15261194784129614735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi all,

The chattr(1) manpage has this to say about the immutable bit that
system administrators can set on files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

Given the clause about how the file 'cannot be modified', it is
surprising that programs holding writable file descriptors can continue
to write to and truncate files after the immutable flag has been set,
but they cannot call other things such as utimes, fallocate, unlink,
link, setxattr, or reflink.

Since the immutable flag is only settable by administrators, resolve
this inconsistent behavior in favor of the documented behavior -- once
the flag is set, the file cannot be modified, period.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=immutable-files
