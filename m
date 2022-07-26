Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A44CCA48E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiGZJVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiGZJVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A9F313A1;
        Tue, 26 Jul 2022 02:21:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l23so25077096ejr.5;
        Tue, 26 Jul 2022 02:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VH4E2xWf2GMBb40Hbv+ADlezT14bYPB4k7B1UzgSDjc=;
        b=I3iJyiGhOGUtYzieSYSL3YEnxaTiHg5pp73Dj0Tp0u7d84QdMy1/FPE8XooYfeLLRg
         pPdWTihasVMMJ6PPn7gqlvHFLcienTeklLv1r45Zw/WSNLCZqbJKqfVwCM14d2NLBGt6
         1bnzz5Qd6C4GzktzsYe2ToBDAltD3GW/Qel9Sj4jzCj85jKsebmuXwL3oPQqM9E6a/RU
         qeOlGjqX5RKRXM8RbSVOpF/TiGkjmsqczuNYM1+fIhT+icXlOCa0up7a6z74aIMYTWZu
         3wRnfwh6xLtCXjKujeSbuWXaoEnbBUsyfkdw770xgqzIC665JLObFeJIEYieY7UD8riq
         K71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VH4E2xWf2GMBb40Hbv+ADlezT14bYPB4k7B1UzgSDjc=;
        b=Sz4ZoTD5GN4BXl9rrJpmFu4T59pujH05BifOL/Z6I95qbMYD3gtfCjUlQAbtnx60Bo
         x1/l3mFUjawT3zQJwKtGQlPrFrt9Zq84DWrUCfw3JLRdrIA6Xo9fBeQ5VB4zqga3depK
         PZsWIkSAwAhZFLCTB/LXLYqNaao87wY6FX47v8aDzKOP+4+/pe18YkgQtDfj3uFFFg0/
         YxzjHjeJGV7lGiAqv8xzHfiqUy8Rbm/mTJTlRFmeo/cjIJGfOGlS49OMXuVP4P9p9yCs
         2ryNB0rm11CHiUC2jXlX+aWHmAM4FmruAAzBI2apiLO/C1tceWfyQgyQfacDZIQle6Q3
         4Eug==
X-Gm-Message-State: AJIora+MyEWbVR5nQorqlJLOAuN6p5S/SIXeefpP7kq1swEHsOoYeSq7
        HrmJOJ2TZV4PhobZIlvkW5gMKTx/3GPWDQ==
X-Google-Smtp-Source: AGRyM1t7YRZGk7YHBtiKa/Vy4VmzGjSIzkjfqw/6fXeriZjIsJuhaEsYwrKntsqQmrlDb/9x+egLqQ==
X-Received: by 2002:a17:906:844d:b0:72b:307d:fb52 with SMTP id e13-20020a170906844d00b0072b307dfb52mr13842983ejy.182.1658827299941;
        Tue, 26 Jul 2022 02:21:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE 9/9] xfs: Enforce attr3 buffer recovery order
Date:   Tue, 26 Jul 2022 11:21:25 +0200
Message-Id: <20220726092125.3899077-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit d8f4c2d0398fa1d92cacf854daf80d21a46bfefc upstream.

From the department of "WTAF? How did we miss that!?"...

When we are recovering a buffer, the first thing we do is check the
buffer magic number and extract the LSN from the buffer. If the LSN
is older than the current LSN, we replay the modification to it. If
the metadata on disk is newer than the transaction in the log, we
skip it. This is a fundamental v5 filesystem metadata recovery
behaviour.

generic/482 failed with an attribute writeback failure during log
recovery. The write verifier caught the corruption before it got
written to disk, and the attr buffer dump looked like:

XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_verify+0x275/0x2e0, xfs_attr3_leaf block 0x19be8
XFS (dm-3): Unmount and run xfs_repair
XFS (dm-3): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 4d 2a 01 e1  ........;...M*..
00000010: 00 00 00 00 00 01 9b e8 00 00 00 01 00 00 05 38  ...............8
                                  ^^^^^^^^^^^^^^^^^^^^^^^
00000020: df 39 5e 51 58 ac 44 b6 8d c5 e7 10 44 09 bc 17  .9^QX.D.....D...
00000030: 00 00 00 00 00 02 00 83 00 03 00 cc 0f 24 01 00  .............$..
00000040: 00 68 0e bc 0f c8 00 10 00 00 00 00 00 00 00 00  .h..............
00000050: 00 00 3c 31 0f 24 01 00 00 00 3c 32 0f 88 01 00  ..<1.$....<2....
00000060: 00 00 3c 33 0f d8 01 00 00 00 00 00 00 00 00 00  ..<3............
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.....

The highlighted bytes are the LSN that was replayed into the
buffer: 0x100000538. This is cycle 1, block 0x538. Prior to replay,
that block on disk looks like this:

$ sudo xfs_db -c "fsb 0x417d" -c "type attr3" -c p /dev/mapper/thin-vol
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3bee
hdr.info.crc = 0xb5af0bc6 (correct)
hdr.info.bno = 105448
hdr.info.lsn = 0x100000900
               ^^^^^^^^^^^
hdr.info.uuid = df395e51-58ac-44b6-8dc5-e7104409bc17
hdr.info.owner = 131203
hdr.count = 2
hdr.usedbytes = 120
hdr.firstused = 3796
hdr.holes = 1
hdr.freemap[0-2] = [base,size]

Note the LSN stamped into the buffer on disk: 1/0x900. The version
on disk is much newer than the log transaction that was being
replayed. That's a bug, and should -never- happen.

So I immediately went to look at xlog_recover_get_buf_lsn() to check
that we handled the LSN correctly. I was wondering if there was a
similar "two commits with the same start LSN skips the second
replay" problem with buffers. I didn't get that far, because I found
a much more basic, rudimentary bug: xlog_recover_get_buf_lsn()
doesn't recognise buffers with XFS_ATTR3_LEAF_MAGIC set in them!!!

IOWs, attr3 leaf buffers fall through the magic number checks
unrecognised, so trigger the "recover immediately" behaviour instead
of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
buffers and that causes silent on disk corruption of inode attribute
forks and potentially other things....

Git history shows this is *another* zero day bug, this time
introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
superblocks during recovery") which failed to handle the attr3 leaf
buffers in recovery. And we've failed to handle them ever since...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 1d649462d731..b374c9cee117 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -796,6 +796,7 @@ xlog_recover_get_buf_lsn(
 	switch (magicda) {
 	case XFS_DIR3_LEAF1_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
 		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
 		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
-- 
2.25.1

