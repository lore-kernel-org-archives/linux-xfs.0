Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3147A41
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H79RxZpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318AC433C7;
	Wed, 20 Dec 2023 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092427;
	bh=bbfmD4lsEuWttsrc8ia9A7yE9qsLV1ihrny98hEu2fk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H79RxZpkvzpmOaWak0DzRWWz5dZvebKHhBhOC3Ci22CFRVhRkbXV8rN3sNuqVkMO/
	 GVjELIJuwl0DbcVLQiZyV+ZIkVlSv6Jm9UhqtcF6Xxuo+P9TVwb7Z66LgP81IWOXFd
	 f6dYCitu8a7/KFLfRsNOVcglz1dvIIz40g0Tqifx1t4xu06KmUfF6Uu6L7dGElNNDL
	 fJFYtZIXrEAokbputZ5c8E6uwsxeSzhAECt1zgOdHTrgeG6ijuAl2VbwOMHDauV6si
	 gGFALXAAxErMGP7HXZ6WoAlgvcik/8FeRr9NyX+ZaARYtWz0+nGm0m9HhCsl65qWmX
	 Q/YFCBjsgY5Tg==
Date: Wed, 20 Dec 2023 09:13:46 -0800
Subject: [PATCH 4/6] xfs_mdrestore: EXTERNALLOG is a compat value,
 not incompat
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218769.1607943.10932241213672207915.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this check to look at the correct header field.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 3190e07e..1d65765d 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -268,7 +268,7 @@ read_header_v2(
 	union mdrestore_headers		*h,
 	FILE				*md_fp)
 {
-	bool				want_external_log;
+	unsigned int			compat;
 
 	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
 			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
@@ -280,10 +280,9 @@ read_header_v2(
 	if (h->v2.xmh_reserved != 0)
 		fatal("Metadump header's reserved field has a non-zero value\n");
 
-	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
-			XFS_MD2_COMPAT_EXTERNALLOG);
+	compat = be32_to_cpu(h->v2.xmh_compat_flags);
 
-	if (want_external_log && !mdrestore.external_log)
+	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
 }
 

