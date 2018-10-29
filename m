Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40152 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbeJ3DQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:16:15 -0400
Subject: [PATCH 0/2] libxfs: defer ops idiotproofing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Oct 2018 11:26:21 -0700
Message-ID: <154083758133.17015.16047588822481256587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a couple of idiotproofing fixes for xfsprogs.  We forgot to
port the defered AGFL free stuff to xfsprogs, which lead to sporadic
crashes in xfs_repair... way back in 4.18. :(

To prevent a recurrence, we now require the libxfs client to export the
(currently five) defer_ops type structures so that we can link the whole
mess together at build time instead of dynamically assembling the types
at run time.

The second patch removes now-unnecessary fields from the defer ops type
structure and streamlines some of the xfs_defer.c code.

Comments and questions are, as always, welcome.

--D
