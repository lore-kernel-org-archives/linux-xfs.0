Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f178.google.com ([209.85.219.178]:38221 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeKHFmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 00:42:55 -0500
Received: by mail-yb1-f178.google.com with SMTP id u103-v6so5822774ybi.5
        for <linux-xfs@vger.kernel.org>; Wed, 07 Nov 2018 12:11:00 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 0/2] xfs: fix panics seen with error injection
Date: Wed,  7 Nov 2018 15:10:53 -0500
Message-Id: <20181107201055.25883-1-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kernel-team@fb.com, linux-xfs@vger.kernel.org

I have been trying to debug a xfs hang that happens sometimes when NBD
disconnects, but when trying to do error injection the box just falls over right
away with a panic trying to access an xfs_buf that has been freed.  I hit this
consistently with the reproducer you can find here

https://github.com/josefbacik/debug-scripts/tree/master/xfs-hang

You need to have bcc installed, have the error injection stuff turned on, and
just run

./reproducer.sh

You'll want to modify test.sh to point at wherever your fsstress is, and
whatever device you want it to use.  It'll walk through functions injecting
errors and usually craps out when it hits xfs_btree_log_recs.

What the script does is triggers on whatever function you are looking at
(xfs_btree_log_recs for example) and then anything that dirties a xfs_buf in
that path will save that xfs_buf for later.  Then when we go to do
xfs_buf_ioapply_map on that buf (which eventually calls submit_bio) we'll fail
that bio.  Xfs errors out and things carry on.

In my testing however it seems like we're dropping the ref on failed xfs_buf's
prematurely, so they get freed before we're able to add them to the delwri list
to be retried.  The 2/2 patch fixes this problem.  The 1/2 patch makes it
possible for the reproducer to work, as it relies on being able to attach a
kprobe/kretprobe at xfs_buf_ioapply_map.

With this patch xfs doesn't fall over as soon as I start trying to reproduce the
hang I'm actually trying to find.  Thanks,

Josef
