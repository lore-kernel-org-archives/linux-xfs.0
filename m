Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD4331EC5;
	Mon, 21 Sep 2026 06:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971425; cv=none; b=b4wGmXf2U8rJOSJuQvHvhHlvd+lZ27M2Dtf0VTtYPEehquSrwzcouPKtuKxtbQTwJuaFLH3HDK3vHtQC+7r9g323g8lHgyI68R4hQ4JDo+sEqtJVQsCXmHgClzpqPqi+zG53CjPpNWNxIVto4Gr4Ve1keqkL5GF9RqYQwt+hGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971425; c=relaxed/simple;
	bh=o3UPXYDcI2WPN/NfnzdS+NDYYIT29aAs981IDpGPEUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TnodltOn54srD6ZLDHV424hqUDnpypKKUFx5RwMajngATwgKN/04M+LHqw8C96h6ByC46IygoqvFyT7cUSNDV2nPbzRZOrqs9L9+DXro+a1mXtapnTiHlgqe+rBy2kjxCWNhkz7jjjHcsm6cUgBo0Vv0j1Vb/e1fvc/ETcCITiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1VkiO6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1VkiO6w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 70B911F000FF;
	Mon, 21 Sep 2026 06:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971424;
	bh=UYld1hkh0DqpTQ4psBoVk1UTLEmADI2rw9kZTO3YcTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=C1VkiO6wjI2mLHDg1ifKxx+C4P15SkfcAZIfn5gxCdtTegSVROHQiTfekTUcPCHU/
	 inmjv1hSi7oGpWUj21nvEX0AmYqxvS68S+MSbKSM3qp0QT7+zfuY7ctZwVKxXI+8MQ
	 88qWFC3QlsyAonNroIJw3t3XWwQHAjUJ5BWe+PP7k1TfoXxBKG2ul8SSnAS4WsdH9R
	 fkHLTu7E7bNLLyfby57boRi/KhaISnmKvtsvfmpqii4OgNR+5OZyiMMLYx+29roc2J
	 P28ZjYexA+2iVkCOeG1iiD3EgLQvcrjp/9BzViTisnQ0V5tFV/RO1535c0w6aEMXLL
	 EJQpt2JJO1D8g==
Date: Sun, 20 Sep 2026 23:17:04 -0700
Subject: [PATCH 08/14] xfs: fix maximum atomic cow length computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120721.181988.7950955477687457877.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM says rounddown_pow_of_two acts funny if you pass it 0, so we need
to catch this possibility because maybe the filesystem doesn't support
software atomic writes at all.

Cc: <stable@vger.kernel.org> # v6.16
Fixes: 0c438dcc31504b ("xfs: add xfs_calc_atomic_write_unit_max()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_reflink.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4801361366359b..489ecd4cf10aff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1081,6 +1081,8 @@ xfs_extlen_t
 xfs_reflink_max_atomic_cow(
 	struct xfs_mount	*mp)
 {
+	xfs_extlen_t		fsb;
+
 	/* We cannot do any atomic writes without out of place writes. */
 	if (!xfs_can_sw_atomic_write(mp))
 		return 0;
@@ -1089,7 +1091,10 @@ xfs_reflink_max_atomic_cow(
 	 * Atomic write limits must always be a power-of-2, according to
 	 * generic_atomic_write_valid.
 	 */
-	return rounddown_pow_of_two(xfs_calc_max_atomic_write_fsblocks(mp));
+	fsb = xfs_calc_max_atomic_write_fsblocks(mp);
+	if (!fsb)
+		return 0;
+	return rounddown_pow_of_two(fsb);
 }
 
 /*

