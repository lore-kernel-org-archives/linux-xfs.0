Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2BAC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B79460D43
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhJ2Iyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 04:54:33 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.115]:50712 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231489AbhJ2Iyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Oct 2021 04:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1635497524; i=@fujitsu.com;
        bh=zaky3TEYcshvFmINx+tvDjpL2jIYaTV7Jdyb3KtQgcE=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=g3kzbR9CJNIJMbuM/O4MJa7v/j+vKeocpcnVLdtrvwW0NViwObtfssFxvWLuZtY8N
         8bteJIUsG4J/lhAfzlskhnIiMqvnkF5jzyfVbEVo4T0knEuiuGDtFKpY3u+RgUEJdk
         MOOrJxFrrblfkoagw009wBeXeXaBcZTWUsMObs7Qbpwo4gQXePSVlIyWnAQ6XDr2JR
         FyWZo7QiMF69VtUKj7od0ZpQ6h2JGptbZoAmGOHXN+Q71vDEogOg+HpbpzUK8QTl/b
         5zPtNdDKGQD8OJmsKWE8ryCHH3IZBN8K5wNJuNUDMU0xRU1Ek4Fbor7wk0uhn39NqH
         QB/gdUVK/LKeg==
Received: from [100.113.4.229] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-central-1.aws.symcld.net id 3A/1B-09058-436BB716; Fri, 29 Oct 2021 08:52:04 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRWlGSWpSXmKPExsViZ8MRomu8rTr
  R4Oh+DYvLT/gsTrfsZbfY9WcHuwOzx6ZVnWwenzfJBTBFsWbmJeVXJLBmfH12gK1gk3TF6fU/
  mBsYt4l3MXJxCAm8ZpSYfuIUO4Szh1Hi+q7jrF2MnBxsApoSzzoXMIPYIgLiEo8X3WICsZkFM
  iQ2dF0CqxEW8JJYuOQGC4jNIqAqsX3KQnYQm1fAQ6L7/wawegkBBYkpD98zQ8QFJU7OfMICMU
  dC4uCLF8wQNYoSlzq+MULYFRKzZrUxTWDknYWkZRaSlgWMTKsYLZOKMtMzSnITM3N0DQ0MdA0
  NjXVNdA2NDfQSq3ST9FJLdZNT80qKEoGyeonlxXrFlbnJOSl6eaklmxiBwZdSyNK0g/H3qw96
  hxglOZiURHl/rq1OFOJLyk+pzEgszogvKs1JLT7EKMPBoSTBu3gLUE6wKDU9tSItMwcYCTBpC
  Q4eJRHenA1Aad7igsTc4sx0iNQpRl2Oy9fnLWIWYsnLz0uVEue9DjJDAKQoozQPbgQsKi8xyk
  oJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEubl3Qw0hSczrwRu0yugI5iAjmBWqgA5oiQRISXVwDS
  XQ256bsXtx2rK/ivYY/Xkqp+YtZXquvxe83t/50MtlhKB4KtWLYuDvr9llGOYMkvR5cf3kIbt
  778mfQqokcibV9NwrEbzwctoUd/nx/JkWp2+WAWl8IQ1dIo09bcZnKmMXHg1u63O81Uow/p3V
  fsEF4hxbkt+G3L8tONk3YKyWsZJ4hw5i5j3WJ3cyhc3NTnqGCuzSf/GGRa3rywI2qQ6NX+2zy
  MZ/Z7vdjffKfjmx67mP/L5pIipvasnp+Rb3yrGDy2ehziNM/01Ba7dzuJI2jtVeVNDfNFSdon
  SIoYb+jaf+vutrnounHVLzuDtC+YMZV7uLFV+4f+/y2bsexaacvL+Ss9CO8OXwcVKLMUZiYZa
  zEXFiQBF3X/dRQMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-8.tower-238.messagelabs.com!1635497523!193463!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 20951 invoked from network); 29 Oct 2021 08:52:03 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-8.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 Oct 2021 08:52:03 -0000
Received: from R01UKEXCASM126.r01.fujitsu.local ([10.183.43.178])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 19T8q3dd020426
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 29 Oct 2021 09:52:03 +0100
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.24; Fri, 29 Oct 2021 09:52:01 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <djwong@kernel.org>
CC:     <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Fri, 29 Oct 2021 16:52:00 +0800
Message-ID: <1635497520-8168-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
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

When getxattr calls xfs_attr_node_get, xfs_da3_node_lookup_int fails in
xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
free stat and xfs_attr_node_get doesn't do xfs_buf_trans release job.

Then subsequent removexattr will hang because of it.

This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
in this case. But xfs_attr_node_hasname will free stat itself instead of caller if
xfs_da3_node_lookup_int fails.

Fix this bug by moving the step of free state into caller.

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fbc9d816882c..6ad50a76fd8d 100644
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
 
-- 
2.23.0

