Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbeARHmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jan 2018 02:42:36 -0500
Subject: [PATCH 0/2] xfs: pnfs/reflink fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 23:42:26 -0800
Message-ID: <151626134674.25794.7913544634631149739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@lst.de, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

I was chasing a quota accounting bug in the reflink code and wondered
if we're supposed to call xfs_break_layouts before we start reflinking.
We do it for fallocate, and since the point of pnfs appears to be clients
(leased) unmediated access to the storage media, I would surmise that we
ought to be doing it.  So the first patch (tested only on xfstests and
not at all with pnfs) does that.

The second patch fixes the pnfs exporter to find and unshare blocks if
the client wants write access instead of just refusing.  I do not have
pnfs set up and and Know Nothing(tm) about pnfs, so I have no idea if
it behaves correctly. :P

--D
