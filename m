Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbeJ3DPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:15:44 -0400
Subject: [PATCH 0/2] xfs: defer ops idiotproofing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Oct 2018 11:25:46 -0700
Message-ID: <154083754598.16857.4909403030667946114.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a couple of idiotproofing fixes for the kernel.  We forgot to
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
