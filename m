Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1310361668;
	Tue, 25 Aug 2026 05:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636158; cv=none; b=GRNzpBao4soHAA1hqNQi4zEW9OSq5wPl3gBGjfu2n015z/rfGtHwssCoDov1sZhI3dxMG7HHBCej1oYc45Hk/O1fnckOOMbLIJzkCfkGll0SsHqnNx+Prhjn7NgzN3EslWIcbRYOgHGNRDGJhuvR49GSKfqCkTVZ2whufoF/LhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636158; c=relaxed/simple;
	bh=JtDV2aEd30r58tEWrGKtNRwveKk++ECL6otBDlhnr0U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIzAMclInbIsOCHceAn+mOselDdJVS+/CA4CYwj14QypGUNP/zMr0gq7bmsCKwbm3Y5MsqHrDVFAr/GcW+FIh1WqEtQBvl9ARXk5wrGOVOWdyfNGLTlrOQOltVIlvKi0PSOcTgB4xELfjoX5+tKH4CFUVLfjiE/vPHcTs8dBiZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGl/Sky9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGl/Sky9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 892DC1F000E9;
	Tue, 25 Aug 2026 05:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636157;
	bh=X+aaNfcvdPTYb0VmxD/l7DonAIjppMX8gtJHjC77TqM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TGl/Sky9CQWPy1i6qeWvmbjl7SSvL0y53HQhQjQ3NEa8NiEo/1rLOT3iXILKX0V0P
	 wXIO6Z+eLjiZ7fY7mfq1HBZqrDhZJiB+8U2rk1nmxLT0YCl4ra1VXL33p5GpgmZsM4
	 uKD26hEbtKRgjvR506DbmzjKH8D2tbARcnPCJCrj6SDJCwJjXdEYuCOl0Yc2lmPL7n
	 eT9GoYpo1Igr4gNmLqYpLf/1wvuOaFVlcm1/uGEhQbgkMo+460tOrhR2uJtf0Armwp
	 AGph/ntqwTaX1w6QGDhpqingHNRX2L5LhOjhCqDdkDDZ6YDjdmcCBhBeOmLMdgv/hd
	 lpZ1T5zSIT9iA==
Date: Mon, 24 Aug 2026 22:35:57 -0700
Subject: [PATCH 6/6] xfs: lock the healthmon when inserting unmount event
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940804.944084.12785441907263638942.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that xfs_healthmon_unmount does an unlocked insert of
the unmount event into the health monitor's event list.  Fix that.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: 25ca57fa3624ca ("xfs: convey filesystem unmount events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_healthmon.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 4521ffdab9f1ae..d8b95af33a3e9f 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -415,8 +415,10 @@ xfs_healthmon_unmount(
 	 * There's nothing actionable for userspace after an unmount.  Once
 	 * we've inserted the unmount event, hm no longer owns that event.
 	 */
+	mutex_lock(&hm->lock);
 	__xfs_healthmon_insert(hm, hm->unmount_event);
 	hm->unmount_event = NULL;
+	mutex_unlock(&hm->lock);
 
 	xfs_healthmon_detach(hm);
 	xfs_healthmon_put(hm);

