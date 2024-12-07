Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290D817E0;
	Sat,  7 Dec 2024 00:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529896; cv=none; b=fE/dM1qo981Mnw9WmfETaEwNLWMSjxMtRaqcGYDCM9aWRp9Myx/cFZC/MTvL0IhBD4Xje5vkNsefB5Y9f6qzkorl57TnCIgc+OBw6Gev93A56aunNEXIJp5pmz1kZb2sFqF/QRwezmCffxxlTQtyjrOIJPLOfhmMSsusZ+t2/KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529896; c=relaxed/simple;
	bh=DpqGG4bMlII5yzVkc5pwB4B4TGfNhDaJexByzDs6FrQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L++tC4s94c1s7PwuC3pim7aqaVzBXex8oE4FIOfs+5s+h7CCI6903NWGkvzKBgHxzA6czajRhIFLQy9KWkCtyw7zSt6JypU2mK6xAbNn2vKVJMHnoCnuG0Cme5t1kw0TMdvwleq3jjoXNU5eU2jL0UsOfzVbVvH7zve1ylcM5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyQ+T171; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyQ+T171"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A926CC4CED1;
	Sat,  7 Dec 2024 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529895;
	bh=DpqGG4bMlII5yzVkc5pwB4B4TGfNhDaJexByzDs6FrQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NyQ+T1717nVzcT+LxnanA6RRWYpAjI/C1bSzkSBnSjUzgJi3XpPxDDeR1i9QRAyZT
	 y2O1t1Zpsx8tNMa27OSDQuxn8M5wz1NrYRPwen1kogGQtyv9dl8yRD2UeZN9o1hjMj
	 Fz5qpIFOCpz2RW4r4OLGHYNBuIgCAw7QTDpx5dep3+mnwoAMZ8ov9UcAWRHCaDO0Tl
	 bYELBYbEHwi4O2WN5R3tlqTP9AK9QtZlTLM7k+jl6Jizjf1iMjeeS8FoZ8uC8LsUD+
	 uy9252r4Z7FvqXtDOFQbg+vw20So5cdKRQQGPJMeUvZ6pfb7TPVuUInuuuwNbeIfeE
	 YyWlvdciSU7JA==
Date: Fri, 06 Dec 2024 16:04:55 -0800
Subject: [PATCH 6/6] xfs: return from xfs_symlink_verify early on V4
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751290.126106.1391306417071639286.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
References: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

V4 symlink blocks didn't have headers, so return early if this is a V4
filesystem.

Cc: <stable@vger.kernel.org> # v5.1
Fixes: 39708c20ab5133 ("xfs: miscellaneous verifier magic value fixups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_symlink_remote.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 2ad586f3926ad2..1c355f751e1cc7 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -89,8 +89,10 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
+	/* no verification of non-crc buffers */
 	if (!xfs_has_crc(mp))
-		return __this_address;
+		return NULL;
+
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))

