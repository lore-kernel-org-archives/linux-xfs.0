Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4426AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 07:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2221861078
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 07:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhKAHDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 03:03:11 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:46396 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhKAHDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 03:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1635750037; i=@fujitsu.com;
        bh=bEB63BkLGE0Y4igwnZ97G3Tg5AVNSAby7hXzcRSvhzM=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=EjJh8RhGIQWVzhrl++k5EQjEhh2WCdbT1lA/EzrjmptlqAGJbhBukgXgbrJhC64Sv
         GWdQ1O793GjqJ2J0WD1US8dOY0FcIU5KkvfFQvxcQHE0APd9tucG05nMYF1boiR93+
         7I6BaEeIt9IwcijFDs6RJApUmH48NHhLetCpdZFyg4aTzGEJTnex0hI1getv4SBcrL
         8U50UwpsAzAcoXtfQlXblvKdsQ32bgQsugvF2QoQvj3TrBNFYE/QjoIaNPT7l+J7vL
         cVdnmXz40ii19MRdwsGLmwQxzYbLVGVeMViiui3k09JLtffSPPkID878bgp1woRZ4p
         5LjaZpmuqDutg==
Received: from [100.112.192.69] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 72/02-05531-5909F716; Mon, 01 Nov 2021 07:00:37 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRWlGSWpSXmKPExsViZ8MxSXfKhPp
  Egx+3DC0aWtqYLC4/4bM43bKX3WLXnx3sDiwem1Z1snl8fHqLxePzJrkA5ijWzLyk/IoE1owv
  +26yFSxQrDjc3MLUwLhOpouRi0NIYAujROP5hywQzgImiUN3j7BCOLsZJX78/8/YxcjJwSagK
  fGscwFzFyMHh4iAucT1j0wgYWaBBIkJW5ezg9jCAr4Sr15PZgcpYRFQkWj8oAsS5hXwkJizvY
  kFxJYQUJCY8vA9M4jNKaAn8f7ZZ7AxQgK6EtPuHmKDqBeUODnzCQvEeAmJgy9eMEP0Kkpc6vj
  GCGFXSMya1cYEYatJXD23iXkCo+AsJO2zkLQvYGRaxWiRVJSZnlGSm5iZo2toYKBraGika2hp
  pGtkYKKXWKWbqJdaqlueWlyia6iXWF6sV1yZm5yTopeXWrKJERjsKQUHzuxgPPX6g94hRkkOJ
  iVR3sKe+kQhvqT8lMqMxOKM+KLSnNTiQ4wyHBxKErzZjUA5waLU9NSKtMwcYOTBpCU4eJREeP
  f3AqV5iwsSc4sz0yFSpxh1OS5fn7eIWYglLz8vVUqcV7wfqEgApCijNA9uBCwJXGKUlRLmZWR
  gYBDiKUgtys0sQZV/xSjOwagkzLsaZApPZl4J3KZXQEcwAR2xT6wG5IiSRISUVAPTpvSOnl9W
  j6pzTu3Y+Si24+lE7o0H123/2cB4+L5CQa7j5WuzPh6a77e79KVg+iIt786s353n661DJc+Ix
  RisORkd7RNwRyvQ+OblZ3nvA5JmH/rv/sp1i//tE1qJb+J75v9hXMjdz7dQLkjQ4c9Othxh9f
  fSKoZ3Yhx1f0/xDm7Wdo3NesZYfePutU1vAg/nJpjnsXh2McmLzjr2aPcP9rvblqmUvX+/18v
  DmsV9l+Idd+GMwzNS5Q3O6nd/8GA8OkEwj5PDuHzKRs2l5yNNji7aW/RubpKdwcPfqzVeWqfF
  7ZJ+cu6nQd7uzpq0uNwkBu/5t/KfaqU+vLk9KD/q05kP7sdCCvmMldfdi5ylxFKckWioxVxUn
  AgAkiVdkX0DAAA=
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-15.tower-267.messagelabs.com!1635750036!218015!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10701 invoked from network); 1 Nov 2021 07:00:36 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-15.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Nov 2021 07:00:36 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 34F7B100470;
        Mon,  1 Nov 2021 07:00:36 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (unknown [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 23FA4100466;
        Mon,  1 Nov 2021 07:00:36 +0000 (GMT)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.24; Mon, 1 Nov 2021 07:00:25 +0000
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <djwong@kernel.org>, <allison.henderson@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH v2] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Mon, 1 Nov 2021 15:00:20 +0800
Message-ID: <1635750020-2275-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20211029185024.GF24307@magnolia>
References: <20211029185024.GF24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.

The deadlock as below:
[983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
[  983.923405] Call Trace:
[  983.923410]  __schedule+0x2c4/0x700
[  983.923412]  schedule+0x37/0xa0
[  983.923414]  schedule_timeout+0x274/0x300
[  983.923416]  __down+0x9b/0xf0
[  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923453]  down+0x3b/0x50
[  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
[  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
[  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
[  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
[  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
[  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
[  983.923624]  ? kmem_cache_alloc+0x12e/0x270
[  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
[  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
[  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
[  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
[  983.923686]  __vfs_removexattr+0x4d/0x60
[  983.923688]  __vfs_removexattr_locked+0xac/0x130
[  983.923689]  vfs_removexattr+0x4e/0xf0
[  983.923690]  removexattr+0x4d/0x80
[  983.923693]  ? __check_object_size+0xa8/0x16b
[  983.923695]  ? strncpy_from_user+0x47/0x1a0
[  983.923696]  ? getname_flags+0x6a/0x1e0
[  983.923697]  ? _cond_resched+0x15/0x30
[  983.923699]  ? __sb_start_write+0x1e/0x70
[  983.923700]  ? mnt_want_write+0x28/0x50
[  983.923701]  path_removexattr+0x9b/0xb0
[  983.923702]  __x64_sys_removexattr+0x17/0x20
[  983.923704]  do_syscall_64+0x5b/0x1a0
[  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[  983.923707] RIP: 0033:0x7f080f10ee1b

When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.

Then subsequent removexattr will hang because of it.

This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
in this case. But xfs_attr_node_hasname will free state itself instead of caller if
xfs_da3_node_lookup_int fails.

Fix this bug by moving the step of free state into caller.

Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
xfs_attr_node_removename_setup function because we should free state ourselves.

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/libxfs/xfs_attr.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fbc9d816882c..23523b802539 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
 
 	state = xfs_da_state_alloc(args);
 	if (statep != NULL)
-		*statep = NULL;
+		*statep = state;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		xfs_da_state_free(state);
-		return error;
-	}
+	if (error)
+		retval = error;
 
-	if (statep != NULL)
-		*statep = state;
-	else
+	if (!statep)
 		xfs_da_state_free(state);
+
 	return retval;
 }
 
@@ -1112,7 +1109,7 @@ xfs_attr_node_addname_find_attr(
 	 */
 	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
+		goto error;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1337,7 +1334,7 @@ int xfs_attr_node_removename_setup(
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-		return error;
+		goto out;
 	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
-- 
2.23.0

