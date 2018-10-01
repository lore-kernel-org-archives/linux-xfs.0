Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbeJBF2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 01:28:25 -0400
Subject: [PATCH v2 0/2] xfs-4.20: scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 15:48:15 -0700
Message-ID: <153843409576.24414.14199833763423874927.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

Here are a couple of online fsck fixes for 4.20.

The first patch fixes the online repair "find AG btree root" function to
ignore btree blocks that have siblings and to ignore a btree level if
multiple sibling-less blocks are found.

The second patch fixes some buffer state management bugs so that we
don't accidentally clobber b_ops on buffers that were already in-core
when we try to find an AG header's btree root blocks.

Comments and questions are, as always, welcome.

--D
