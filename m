Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D471FC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F80720747
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603759393;
	bh=+NwHXhlGzd5i8K77Rhgue2pCfD0yCHRoE8gcXo1uYcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vWf0jT27KwOhwJOGH5xDDgaE8TkiO5Tq4cRJnas7uBzmSLgQHgexUYk1IRaJeismY
	 vh19szlDYk/Z4J3LUxm3OcuRYcONptotTpZP2bIVeE85VX5qDEydZzpjljVBlQViEf
	 QYAzbyxDeuHB45PxCwuF7AhB+nk4zxpSTOZV4pT0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408790AbgJ0Amv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408755AbgJZXth (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE342075B;
        Mon, 26 Oct 2020 23:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756176;
        bh=+NwHXhlGzd5i8K77Rhgue2pCfD0yCHRoE8gcXo1uYcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Peywlc+2e68GtRpo/rtWAmoiVecxCRFx8qlINqa7MQAkrRtkk5iVPkkUT7AbMZxwJ
         1oPkvbDUHRN8SpWTq57G5ICgdOkRPCW3z3iAVwA6n2jd2lzKjHo9smBmV6SQiVCvCJ
         pWNww3zSYt/mssk4craqs+Es+E8YcUuoFRa5RcvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 024/147] xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files
Date:   Mon, 26 Oct 2020 19:47:02 -0400
Message-Id: <20201026234905.1022767-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

[ Upstream commit c54e14d155f5fdbac73a8cd4bd2678cb252149dc ]

In xfs_growfs_rt(), we enlarge bitmap and summary files by allocating
new blocks for both files. For each of the new blocks allocated, we
allocate an xfs_buf, zero the payload, log the contents and commit the
transaction. Hence these buffers will eventually find themselves
appended to list at xfs_ail->ail_buf_list.

Later, xfs_growfs_rt() loops across all of the new blocks belonging to
the bitmap inode to set the bitmap values to 1. In doing so, it
allocates a new transaction and invokes the following sequence of
functions,
  - xfs_rtfree_range()
    - xfs_rtmodify_range()
      - xfs_rtbuf_get()
        We pass '&xfs_rtbuf_ops' as the ops pointer to xfs_trans_read_buf().
        - xfs_trans_read_buf()
	  We find the xfs_buf of interest in per-ag hash table, invoke
	  xfs_buf_reverify() which ends up assigning '&xfs_rtbuf_ops' to
	  xfs_buf->b_ops.

On the other hand, if xfs_growfs_rt_alloc() had allocated a few blocks
for the bitmap inode and returned with an error, all the xfs_bufs
corresponding to the new bitmap blocks that have been allocated would
continue to be on xfs_ail->ail_buf_list list without ever having a
non-NULL value assigned to their b_ops members. An AIL flush operation
would then trigger the following warning message to be printed on the
console,

  XFS (loop0): _xfs_buf_ioapply: no buf ops on daddr 0x58 len 8
  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  CPU: 3 PID: 449 Comm: xfsaild/loop0 Not tainted 5.8.0-rc4-chandan-00038-g4d8c2b9de9ab-dirty #37
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   dump_stack+0x57/0x70
   _xfs_buf_ioapply+0x37c/0x3b0
   ? xfs_rw_bdev+0x1e0/0x1e0
   ? xfs_buf_delwri_submit_buffers+0xd4/0x210
   __xfs_buf_submit+0x6d/0x1f0
   xfs_buf_delwri_submit_buffers+0xd4/0x210
   xfsaild+0x2c8/0x9e0
   ? __switch_to_asm+0x42/0x70
   ? xfs_trans_ail_cursor_first+0x80/0x80
   kthread+0xfe/0x140
   ? kthread_park+0x90/0x90
   ret_from_fork+0x22/0x30

This message indicates that the xfs_buf had its b_ops member set to
NULL.

This commit fixes the issue by assigning "&xfs_rtbuf_ops" to b_ops
member of each of the xfs_bufs logged by xfs_growfs_rt_alloc().

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 04b953c3ffa75..48be55b18c494 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -838,6 +838,7 @@ xfs_growfs_rt_alloc(
 				goto out_trans_cancel;
 
 			xfs_trans_buf_set_type(tp, bp, buf_type);
+			bp->b_ops = &xfs_rtbuf_ops;
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.25.1

