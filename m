Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbeJEHnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:43:51 -0400
Subject: [PATCH v3 0/3] xfs-4.20: scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:47:38 -0700
Message-ID: <153870045847.29695.10286947858219936840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a few online fsck fixes for 4.20.

The first patch fixes the online repair "find AG btree root" function to
ignore btree blocks that have siblings and to ignore a btree level if
multiple sibling-less blocks are found.

The second patch strengthens the buffer read functions to apply buffer
ops (and verify the buffer contents) any time a caller tries to read a
buffer with a given set of ops and the buffer doesn't have ops yet.

The third patch fixes some buffer state management bugs so that we
don't accidentally clobber b_ops on buffers that were already in-core
when we try to find an AG header's btree root blocks.

Comments and questions are, as always, welcome.

--D
