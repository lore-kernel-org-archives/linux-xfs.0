Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33452 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:07:42 -0400
Subject: [PATCH v9 00/22] xfsprogs: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:07:37 -0700
Message-ID: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the ninth revision of a patchset that adds to XFS userland tools
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes, and the main overview is in the cover letter for
the kernel patches.  Since v8, I have split up the userland scrub
patches so that we lead off with a bunch of documentation for the future
program and then start building the tool one piece at a time.  Most of the
scrub activity simply calls into the kernel, but other parts (data block
verification, name collision checking) are mostly userspace code.

Per my new policy of reducing mailing list bombardment, I am not posting
any of the libxfs patches, only patches for actual userspace programs.

If you're going to start using this mess, you probably ought to just
pull from my git trees for kernel[1], xfsprogs[2], and xfstests[3].
The xfsprogs patches should apply against for-next.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
