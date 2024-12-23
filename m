Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDCB1AB53A;
	Mon, 23 Dec 2024 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991907; cv=none; b=cgJaaBQ2FY8w93KbS2ZExZ4nm3woxtnSjDF2ZZxk/jgtAnTHdvTQ6BQFwLdWuwpbkfABPQCBD2cS4ocDpQ/ocgbWejqWWOOZx/WSveaI/ZmevVPyrsRgN9ZMInxi6QsQntN+01MTVuwSN0l740YN8q/ImfdFiTct1Q/pd88zynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991907; c=relaxed/simple;
	bh=Vvo9Ir0yzFj9zvfdE4S0wAgGLjCesn1ecoP0L5XeXWw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSlZsQqBy//dUDWbjqXRZ4jKvmYuGon7uUaV/pvSbgNw1wf/3HaH269qFyfYnA7asw/C3xvjHeZqBhn20gqPvB/oANJsa+/5NJwXLiRYnMkxCQkVI3IIvYeZIKCiV4nZ3KlS8WlwjyoMZr/w1l25vC5SJh7FSKb3QvVuMjyK1Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhh4E7iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhh4E7iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F5EC4CED3;
	Mon, 23 Dec 2024 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991906;
	bh=Vvo9Ir0yzFj9zvfdE4S0wAgGLjCesn1ecoP0L5XeXWw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nhh4E7iKbztxeDDIzx2M//yRR7yevtLS2Cza8hG19mfgQFDZ4f5wNqW2xhm+QPkhf
	 gJyBhUakC/RDxRVT8qE2RTq5h8wl1BkQa+gYkbkQTeZ7zCiW92CswwQnYSe3e/ej2o
	 C/1mfbP/z69r2f01Rc5dEwqSYAIbhrt+P5AGgV4AyL4+XeoopE3aI3GXUBzvYnV7p0
	 s83dAbCYzViaOlsWJMYt6+a4sw/4kG1xHnAH+l3jNBZ6N34je3mbKbupHmkQGTBo9H
	 YlYWSHu2nNxg8uauCjzZiT7JrcKpiF5iwva25PCa/uJv5w8uD1353cRMeNbSNdRTSW
	 kHGUFgtXojQag==
Date: Mon, 23 Dec 2024 14:11:46 -0800
Subject: [PATCH 52/52] xfs: return from xfs_symlink_verify early on V4
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943287.2295836.1533846350392682600.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7f8b718c58783f3ff0810b39e2f62f50ba2549f6

V4 symlink blocks didn't have headers, so return early if this is a V4
filesystem.

Cc: <stable@vger.kernel.org> # v5.1
Fixes: 39708c20ab5133 ("xfs: miscellaneous verifier magic value fixups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

