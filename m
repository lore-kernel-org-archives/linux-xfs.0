Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932656AbcJURWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 13:22:15 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3401DAA0BB
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 17:22:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9LHMEBu026154
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 13:22:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] xfs: a few reflink cowblocks fixes
Date: Fri, 21 Oct 2016 13:22:10 -0400
Message-Id: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is just a few reflink fixes associated with cowblocks tagging that
I came across when playing around with and/or reviewing some code. The
issue associated with patch 3 is easily reproducible with something like
the following:

	echo 30 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime

	xfs_io -fc "cowextsize 64k" $src
	xfs_io -c "pwrite 0 128k" $src
	cp --reflink $src $tgt

	xfs_io -c "pwrite 64k 32k" $tgt
	xfs_io -c "pwrite 96k 32k" $tgt
	echo sleep
	sleep 25
	echo delalloc
	xfs_io -c "pwrite 0 4k" $tgt

... which basically just sets the cowblocks tag, uses up all of the
resulting cow blocks, waits until just before the cowblocks scanner is
going to run and creates a delalloc reservation in the cow fork. The cow
fork fiemap thingy I sent the other day shows that the resulting cow
fork blocks remain indefinitely.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (3):
  xfs: fix up inode cowblocks tracking tracepoints
  xfs: clear cowblocks tag when cow fork is emptied
  xfs: don't skip cow forks w/ delalloc blocks in cowblocks scan

 fs/xfs/xfs_icache.c  | 10 +++++-----
 fs/xfs/xfs_reflink.c | 29 +++++++++--------------------
 fs/xfs/xfs_reflink.h |  2 +-
 3 files changed, 15 insertions(+), 26 deletions(-)

-- 
2.7.4

