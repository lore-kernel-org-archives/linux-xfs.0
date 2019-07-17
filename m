Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57096 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfGQF7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 01:59:18 -0400
Subject: [PATCH v3 0/8] iomap: regroup code by functional area
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Jul 2019 22:58:55 -0700
Message-ID: <156334313527.360395.511547592522547578.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

Hi all,

This series breaks up fs/iomap.c by grouping the functions by major
functional area (swapfiles, fiemap, seek hole/data, directio, buffered
io, and page migration) in separate source code files under fs/iomap/.
No functional changes have been made.  Please check the copyrights to
make sure the attribution is correct.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=iomap-split
