Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753315AbcIXPTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 11:19:24 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: only do a single COW fork lookup in writeback
Date: Sat, 24 Sep 2016 08:19:19 -0700
Message-Id: <1474730361-5234-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

I've got a bug report with a slightly older version of the reflink
code, in which I get a bogus NULL xfs_bmbt_rec_host pointer back from
xfs_iext_bno_to_ext in xfs_reflink_find_cow_mapping.  I've not
reproduced that bug myself yet, but what's clear from the report is
that it's not just inefficient but also potentially dangerous to
do the blind dereference in xfs_reflink_find_cow_mapping after
we dropped the ilock from the previous xfs_reflink_find_cow_mapping
call.

So just combine that two into one function, and then rewrite the
COW writeback code to only do a single call in the second step.
I think that also cleans up the writeback code quite a bit and
makes it much easier to follow as well.

