Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISA2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 20:28:50 -0400
Subject: [PATCH 0/4] xfsprogs-4.19: transaction cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Sep 2018 11:54:50 -0700
Message-ID: <153729689066.13178.8524619838625486047.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

<urk>

Here are four cleanups to the userspace transaction code that make the
commit and roll code more closely resemble their kernel counterparts.
This was supposed to go ahead of the libxfs sync so that it might be
easier to port the changes made by Brian's defer ops rework to
userspace.

Regrettably I wasn't able to push these out before Eric posted his own
libxfs sync branch... so, uh, yeah.  I guess I'll post them so we can
figure out whether we should rebase the branch or the series or
something.

--D
