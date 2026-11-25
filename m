Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627476;
	b=u7y/1dfGz8mfA6HrauGSva3DNYahM88HkE6qFlGHTcVMuE24vMtSc+D6hRr+jn0mBHVp
	 NoYI7sDiHclw90ikzynXjPAntbQ3PbTihI9ZODgQvR08kBwgSxUI07+MCfH6ddOWBVcpj
	 jKDZ2UNCkDvunUq4xNC5g9bOyILwYpIKKVAF1UUUCmzZC/XNqI9WGP0aUXEC3l45fAk6n
	 7i+/xLe7kKM3cQdguDYpGuxCLO47LrSXhAW8k57O0glHMYRCj+E246cgkEENez8YdtCrz
	 Uv3amUjSGkObHArNc/srdaNGsM7fwfzDacUlWHtuR0B4JtvblVZbsvT7hVC+qkN3dVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jjBjp8QhZDBYKq2DhjPeCjvD+cAHo8ewQ1sy8HytbHA=;
	b=DF9NcR9UclYAh6kmdAxkqbuHqNOUh520EBTI5d5G+zlAwRcTsbxgqNzPtOjHcVTcj2h1
	 /wIuXXZZrKwp2qfhqbi7i4LhZ+/n8UB44qOv2DXj5sfUKX43KJcGnaNJWwpY8NhoMPHtN
	 LQCx0w8rWq+00O/hQzqNoz0591RxEDKYWedbS2TawKxOEisS6JliuwS+Mk1gxEZYnd5hd
	 EhDtuFOxDzZLrxihVm5SVTNlo/AgySBMstp3QmWb8HRko2/C3lZRRo4tLboIeKas+7Zoa
	 AfeUHIvbBPQN4Lnp4WPf8QT2cb8XkUiZA4rlubqEpPomvfM1UCf3D2IVfEf8E2kCy0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZ0KZTjy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1483606A31E;
	Wed, 25 Nov 2026 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZ0KZTjy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D611F000C6;
	Wed, 25 Nov 2026 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795627476;
	bh=jjBjp8QhZDBYKq2DhjPeCjvD+cAHo8ewQ1sy8HytbHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZ0KZTjyugD+bmU/LFujB/xAxyPPPEGfLYfQXZuIsDEREbFH/IqefB4PLVK6PnTud
	 rzgu11dtFZPjhwy1OXmc1sIDzpX2K43mXosit5LuP/PsmKUgw7ecDVjh44PA1wQxq9
	 g+a+DlqWL4DfJt57xbremY7MXU8kffdmSW3O79ODSqzcQQoxcUKgnGBRpl1vTQ05BI
	 A33ejjrPki4+C+NjR+TJuygV0vCFvJjcxX1ekqHr8P7D5xSEIyLnAaU6pS9IsyP1gb
	 jhFXFMV82YkbDd7q6u3ft2CaiyBQ9gXueb+1jrEIo5kxodN7NGuG47ECPb8Hr86/po
	 zD2IdnpmCDqkg==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: move _right_neighbor_result trace before erroring out
Date: Wed, 25 Nov 2026 18:24:20 +0100
Message-ID: <20261125172426.132084-2-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125172426.132084-1-cem@kernel.org>
References: <20261125172426.132084-1-cem@kernel.org>
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

From: Carlos Maiolino <cem@kernel.org>

The tracepoint doesn't help much if we find an invalid right record.
Move it before we check the record so it can still be printed even if we
end up jumping to the error label.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
V2: Initialize rmap records during definition so we can safely use them
    in the tracepoints

Christoph, I left your RwB because I think the change is small enough to
keep the RwB, please let me know if you're not ok with it and I'll avoid
that in the future.

 fs/xfs/libxfs/xfs_rmap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 14aef87837a9..aad6e7c0e1c9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1024,8 +1024,8 @@ xfs_rmap_map(
 	const struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_rmap_irec		ltrec;
-	struct xfs_rmap_irec		gtrec;
+	struct xfs_rmap_irec		ltrec = {0};
+	struct xfs_rmap_irec		gtrec = {0};
 	int				have_gt;
 	int				have_lt;
 	int				error = 0;
@@ -1082,6 +1082,12 @@ xfs_rmap_map(
 		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
 		if (error)
 			goto out_error;
+
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				gtrec.rm_startblock, gtrec.rm_blockcount,
+				gtrec.rm_owner, gtrec.rm_offset,
+				gtrec.rm_flags);
+
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
@@ -1092,10 +1098,6 @@ xfs_rmap_map(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur,
-				gtrec.rm_startblock, gtrec.rm_blockcount,
-				gtrec.rm_owner, gtrec.rm_offset,
-				gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
 			have_gt = 0;
 	}
-- 
2.56.1

