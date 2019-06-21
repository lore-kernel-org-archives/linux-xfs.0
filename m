Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUT47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:56:59 -0400
Subject: [PATCH RFC 0/6] xfs: help mkfs shed its AG initialization code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:56:53 -0700
Message-ID: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

In this series, we start by adapting the libxfs AG construction code to
be aware that an internal log can be placed with an AG that is being
initialized.  This is necessary to refactor mkfs to use the AG
construction set instead of its own open-coded initialization work.

In userspace, the next thing we have to do is to fix the uncached buffer
code so that libxfs_putbuf won't try to suck them into the buffer cache;
and then fix delwri_{queue,submit} so that IO errors are returned by the
submit function.

The final patch in the xfsprogs series replaces all of mkfs' AG
initialization functions with a single call to the functions in libxfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=mkfs-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-refactor
