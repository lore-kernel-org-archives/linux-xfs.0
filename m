Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D97C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 11:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF1B214D8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586950964;
	bh=uM8RYOThTOAePXpnhO/MjXiLuve+HcAfoAQLYud7kjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pomZYqMjTuPBe9BHiN0FvsZov/2VB23uGBeF+Stj0mIhRdW62zD3XQsFg23vPXNp8
	 HEH7qFftmvBHyhYlICboP6JBBzwkRG1KiDkpNf/9ZNDeBpHIufeCE/mnp5u9M0fVO0
	 pjShWTSN6KpsCozbHOR2BAdYFpm2Cdr0aJREI33Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897498AbgDOLmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897485AbgDOLmj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E93E20768;
        Wed, 15 Apr 2020 11:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950959;
        bh=uM8RYOThTOAePXpnhO/MjXiLuve+HcAfoAQLYud7kjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+DknSAtTaAAk5fNVPJxEDXVniR6vZMDMgHGU+wj/Y7IOtbB9YHdPhO0RIbFSd5pp
         vBCYZFGcBtcpOsmtmdwL9sBebzAb4cOv8LdoBp0bJsbq1ih9cuzj2iaaEulG9ao6IJ
         fZS4GP1Q22pA26JGv6PyiHgyTjgTZrHnb7R4JTU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Zorro Lang <zlang@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 010/106] xfs: fix iclog release error check race with shutdown
Date:   Wed, 15 Apr 2020 07:40:50 -0400
Message-Id: <20200415114226.13103-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6b789c337a5963ae57cbc7fe9e41488c40a9b014 ]

Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
l_icloglock held"), xlog_state_release_iclog() always performed a
locked check of the iclog error state before proceeding into the
sync state processing code. As of this commit, part of
xlog_state_release_iclog() was open-coded into
xfs_log_release_iclog() and as a result the locked error state check
was lost.

The lockless check still exists, but this doesn't account for the
possibility of a race with a shutdown being performed by another
task causing the iclog state to change while the original task waits
on ->l_icloglock. This has reproduced very rarely via generic/475
and manifests as an assert failure in __xlog_state_release_iclog()
due to an unexpected iclog state.

Restore the locked error state check in xlog_state_release_iclog()
to ensure that an iclog state update via shutdown doesn't race with
the iclog release state processing code.

Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581e..796ff37d5bb5b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -605,18 +605,23 @@ xfs_log_release_iclog(
 	struct xlog		*log = mp->m_log;
 	bool			sync;
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR) {
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		return -EIO;
-	}
+	if (iclog->ic_state == XLOG_STATE_IOERROR)
+		goto error;
 
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
+		if (iclog->ic_state == XLOG_STATE_IOERROR) {
+			spin_unlock(&log->l_icloglock);
+			goto error;
+		}
 		sync = __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		if (sync)
 			xlog_sync(log, iclog);
 	}
 	return 0;
+error:
+	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+	return -EIO;
 }
 
 /*
-- 
2.20.1

