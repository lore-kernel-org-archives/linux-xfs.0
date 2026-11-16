Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871042;
	b=XXYMVNl2RjMCR/OMhvFP5CK+M84hnPPS4SvhZelotl/inpj1S4p85qTGYGdniU5lSSBV
	 6w/YvVXGx5g+xZ5NXD5Jbf2UDkaPSEpMePc/gui8OmtzoYKtnE8AA4o6+yi15mu4a2Fcg
	 971X4/crfEZDw7duGvUVwb8JO3zkmphO0/gYCg0vBvqP9iQqC7H2N2SWliseWCwgReaVf
	 Ckfw8tb8uzBsq6svx7+AwQVXoME0IzYkHN6RCZKM3+HUUys0yDiHMDmz5HwgP7QstOKze
	 2h9VgdH+afAuhpLLf66iddDcSndvY+GoYTPRl3rQE0KN0jvVYV9Jl6TFenqgubazVoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=00EtnDMyWugLXTOO/h/ThBlurZ7pzY9wmnA0vtUMhoY=;
	b=s2TYGye8dyEYymsuWRKuXP3dBgRcs9u1dPoZ2SS0+UDzoKjlZg2bqEJLoZawmykYpUdA
	 blsJSz3Bpf2Z4MjRYuFzzfV/RxJcAy0v/nL5zUoZUexV/RyBbqK7Ivnlh28orGqNFlBMf
	 23MpQShxkq8TSRYPcHLEocpUpcxKoMRsh4eDCAKqgr/zoe9hi2OhwGEhWV8D/ftiDwOE/
	 croGWM+cBI/OiNaMYdbrdrKAp0u5mPwVv20mNPEaSYm9OE9h69Vu/AdLdaHyyuAHmdupI
	 dOLjBuu44lIrLF+DHYWuJmNSKUG7v14xvKb7Vmnrf6k8m5KEV/cZs0Qa0U6J3dXmWpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFM1s93v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0B3606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFM1s93v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E81F000C4;
	Mon, 16 Nov 2026 23:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871042;
	bh=00EtnDMyWugLXTOO/h/ThBlurZ7pzY9wmnA0vtUMhoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFM1s93vntijGgerKGYGEVswBr8z2HrW6LDjXEeyu8+fZzk+TXaT+Ct2ykNDvSvr5
	 /DNdVKxfGpJGtxbVp5LGetl6LQlh9Zu9G4yztVuPH7dgp/wJ8rUky52vejW0lZ1rZn
	 jvKm6RWARebaax2hXF8oOGxZTz1iYp3hE8vBEsLqIMzo3hbpz+aG27lEWw+ni8EB/D
	 2JSOVXKzZnaRk2/7DkYBHWGQ7tIXT9U2BbNmiK8r0k4tRuPnZk+bDbSOOesNNWx0J0
	 0B/lN4nkKvuCCU9hB4A/EQE6r8HVgpMyDtsPeClRzOg4jNroI6WEwluiyMzkSjFArF
	 ZqjV/Tem9+T9g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 06/59] xfs: skip missing groups when freeing them
Date: Tue, 17 Nov 2026 10:14:23 +1100
Message-ID: <20261116231707.3625263-7-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Runtime growfs and recovery of growfs operations have specific ordering
constraints for group instantiation that can be difficult to maintain when
failures occur. There are corruption/shutdown situations where the in-memory
superblock can indicate more groups exist than we have instantiated, and we
trip over this in teardown trying to free groups that don't exist.

Skip group indexes that have no instantiated group when freeing them.

Fixes: e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 2ff9d1e56b47..8b60e2ea3b4f 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -159,6 +159,15 @@ xfs_group_free(
 {
 	struct xfs_group	*xg = xa_erase(&mp->m_groups[type].xa, index);
 
+	/*
+	 * When shutdown failures occur concurrently with runtime geometry
+	 * changes, the instantiated groups might be out of sync with the
+	 * superblock group count. This can result in mount teardown iterating
+	 * group indexes that have not yet been instantiated.
+	 */
+	if (!xg)
+		return;
+
 	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
-- 
2.55.0

