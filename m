Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0290C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 00:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A07F1207FB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 00:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597881885;
	bh=Eg9nDMoUgxhBqbsefQgTOQ4752a8CjLlzYcD2awEVxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iW0O8/2e59hz/SzKNQye898BeMfgN1FjxzfFAx+rY7j7xoAQfHTvAYHNE9SHl63Tv
	 1DYff1ZQVoULQ08z3Ehio4Pj28iteFtdIuuU5Vf/GATIpNuReAI2U9Er8wjE7EftsU
	 h/CkBgcJHP97nZg5cCfgjE3qeVk6Y++QrgDLEkU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgHTAEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 20:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgHTAEO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Aug 2020 20:04:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E7521744;
        Thu, 20 Aug 2020 00:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881853;
        bh=Eg9nDMoUgxhBqbsefQgTOQ4752a8CjLlzYcD2awEVxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zekS23QTYLxHz/Yegzan6U6KspMWZqjvzul7MTZE7PXhVP/FGEuETkHf2ogvWURGv
         lZWJD1hk9bVCzh4/BV8bC/K3MGTRwr6NgHSRe0p9KP+cy6mqp2GmHY4zzDLE5Ghy0m
         JWTPu1oRXJJrO4kNldu0mToB2itF8U0YbSc3qXec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/10] xfs: fix inode quota reservation checks
Date:   Wed, 19 Aug 2020 20:04:01 -0400
Message-Id: <20200820000406.216050-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000406.216050-1-sashal@kernel.org>
References: <20200820000406.216050-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit f959b5d037e71a4d69b5bf71faffa065d9269b4a ]

xfs_trans_dqresv is the function that we use to make reservations
against resource quotas.  Each resource contains two counters: the
q_core counter, which tracks resources allocated on disk; and the dquot
reservation counter, which tracks how much of that resource has either
been allocated or reserved by threads that are working on metadata
updates.

For disk blocks, we compare the proposed reservation counter against the
hard and soft limits to decide if we're going to fail the operation.
However, for inodes we inexplicably compare against the q_core counter,
not the incore reservation count.

Since the q_core counter is always lower than the reservation count and
we unlock the dquot between reservation and transaction commit, this
means that multiple threads can reserve the last inode count before we
hit the hard limit, and when they commit, we'll be well over the hard
limit.

Fix this by checking against the incore inode reservation counter, since
we would appear to maintain that correctly (and that's what we report in
GETQUOTA).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ce78534a047ee..bb8de2dddabe2 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -662,7 +662,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
+			total_count = dqp->q_res_icount + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
-- 
2.25.1

