Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1348BC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Nov 2021 07:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353121AbhKYHPE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Nov 2021 02:15:04 -0500
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:30899 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352620AbhKYHNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Nov 2021 02:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1637824190; i=@fujitsu.com;
        bh=GRzTxN7g5pM4/AwLk2sb3BO2qjs1CKv54DEb7MDV8mY=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=sjSi1JbcB33f6y/YB2vf6sQhBcM5qTpi/wgx5ljFOnMllYnr70Xf7w7gRAMAIoD87
         jvaLi2T+MOLH/LwdbT2My/4N8JfTRAR/zzyXHVlPnPTAQG3cjdqvrUt+oejVeTen1i
         FtQ728cdfhrUjqIg+kBt4EsHRa8JD+asjoAEEkw6c0UN0sp2rxSpYd/vq8Zt7rKyx2
         Y0if84guVy3NlyEbIHwePylgNDfqk/KwlHY7iX30FcR/GoEKlVazF3TTajBePem7f+
         jIoYQ7W+owFKQjR/1UCEV/JuzWRfOgEB3w1n+A8jg00sOYZAK3ZwP3E8OCRrncn/lC
         kn/DN7y8LZRCQ==
Received: from [100.113.2.178] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id 82/01-32197-EB63F916; Thu, 25 Nov 2021 07:09:50 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRWlGSWpSXmKPExsViZ8MxVXef2fx
  Eg56HAhaXn/BZ7Pqzg92ByWPTqk42j8+b5AKYolgz85LyKxJYMx7evsZSMFOp4vrbB6wNjDNk
  uxi5OIQEXjJKTDi6nwnC2cMocfT5F+YuRk4ONgFNiWedC8BsEQF5if7Gb4wgNrOAn8Tui39ZQ
  WxhAV+J2Td62EFsFgFViX9rFoDV8Ap4SNxe9hmsV0JAQWLKw/fMEHFBiZMzn7BAzJGQOPjiBV
  SNosSlDoj5EgIVErNmtTFNYOSdhaRlFpKWBYxMqxgtk4oy0zNKchMzc3QNDQx0DQ2NdQ2BpLl
  eYpVuol5qqW5yal5JUSJQVi+xvFivuDI3OSdFLy+1ZBMjMORSChlLdzBOe/NB7xCjJAeTkihv
  8J95iUJ8SfkplRmJxRnxRaU5qcWHGGU4OJQkeDlU5icKCRalpqdWpGXmAMMfJi3BwaMkwnvJG
  CjNW1yQmFucmQ6ROsWoy3H5+rxFzEIsefl5qVLivDGmQEUCIEUZpXlwI2CxeIlRVkqYl5GBgU
  GIpyC1KDezBFX+FaM4B6OSMG+YHtAUnsy8ErhNr4COYAI6onfPbJAjShIRUlINTMFt+WqRM5O
  cq9W2lmxirv6vwHlMhftJw0rWdU6Fq2ax8/3ce7s9eXntX9XYiRfmun+LFONanZu2sXzDzLlr
  y3rvlP4yXC1nd7X/E/eWLarHbjx5w/T5PPMlxil9t3z0/wuKPOW+8bThfcr6naeONWhyWE4sm
  dbHtjmgoO/DpwC+I78Tyw/fbe4/2DLBMfzt7Kc35OaYX999cW9N4oKSDeVhEqJBZgvOOTjmP/
  rdqF5y6MiyyzmvFS3Sna+s3iby88CBFbOSJNw/3jusw/vixst3+79qnpkrI8i6Me2C/i1F/w8
  Z/t5Kydc6DPyrF8RvTNJaLlDKb1FrJnX5sMgtMfknIt5X8rS1dasiirL0A5RYijMSDbWYi4oT
  AQUIDoRAAwAA
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-13.tower-226.messagelabs.com!1637824189!47973!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.5; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8023 invoked from network); 25 Nov 2021 07:09:50 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-13.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 25 Nov 2021 07:09:50 -0000
Received: from R01UKEXCASM126.r01.fujitsu.local ([10.183.43.178])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 1AP79cPV014221
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 25 Nov 2021 07:09:42 GMT
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.26; Thu, 25 Nov 2021 07:09:37 +0000
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [xfsprogs] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Thu, 25 Nov 2021 15:09:33 +0800
Message-ID: <1637824173-2797-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: a1de97fe296c52eafc6590a3506f4bbd44ecb19a

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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 80a6a96f..45dd9bfc 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1059,21 +1059,18 @@ xfs_attr_node_hasname(
 
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
 
@@ -1094,7 +1091,7 @@ xfs_attr_node_addname_find_attr(
 	 */
 	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
+		goto error;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1317,7 +1314,7 @@ int xfs_attr_node_removename_setup(
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-		return error;
+		goto out;
 	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
-- 
2.23.0

