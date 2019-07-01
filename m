Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729374AbfGARCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:02:11 -0400
Subject: [PATCH RFC 00/11] iomap: regroup code by functional area
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Jul 2019 10:01:59 -0700
Message-ID: <156200051933.1790352.5147420943973755350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi all,

This series breaks up fs/iomap.c by grouping the functions by major
functional area (swapfiles, fiemap, seek hole/data, directio, buffered
writes, buffered reads, page management, and page migration) in separate
source code files under fs/iomap/.  No functional changes have been
made.

Note that this is not the final format of the patches, because I intend
to pick a point towards the end of the merge window (after everyone
else's merges have landed), rebase this series atop that, and push it
back to Linus.  The RFC is posted so that everyone can provide feedback
on the grouping strategy, not line-specific code movements.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
