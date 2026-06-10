Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B443624B7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781067446; cv=none; b=TNdYDFTxIC2fzlijzhL0uGPHQF6lQuo0F8T9CCUY7Z48gyPnWttVH34ea2dyBQvx38ozUxJJHbKEksECEfmjFk6H6yWwGXBLLKstjDlwLqFqqSUTFCJiv/gOLptvwVIX/OaCmTnHyRFy5qVPOd2kdUPi1dkff2elzhO1LJ/sf5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781067446; c=relaxed/simple;
	bh=pgOUCov/ZuZ47+GiIIQEKvGMhjjahimnS18K0TIkBtg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eFgVNDquxOXe+VdWAOYgbTgsHJS1VUOHy/WtCKXPIKf/z8lyUKy0mjMVvE1v/MGQiCdyshXsZolHxPrAyYjGcGLk1FlYM1b3ve7m4fTCN6BHHBoeTFPBaOqnUctEmmAT3VWOsKuYHpq/vUNCqmen3yJur7YtjmBq/9GzFjzhG98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tt/yOP6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tt/yOP6+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6B0141F00893;
	Wed, 10 Jun 2026 04:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781067445;
	bh=GyDFRca3Ju/8sZLiEpMk6AUhKWP8XbnHBFcbuepfEZI=;
	h=Date:From:To:Cc:Subject;
	b=Tt/yOP6+kQ1TENz4vCKAjzhArII9GDRDyzN22eGZr51ZPerdeJa/Y9XNqKHSBeuLa
	 VFweFqaPWK9v/ZSH23ECOrw1OGWKYhMle7R4PTsyBYlQYCjoq9oOqsGFa5YgklXxT9
	 hehuZ+rbDVGSRamKSdQmi/0ka8SQBOXNbjzCYEpvqDqQCn0C6CE0IaQU8QKUocZqGH
	 SqMTUn5n0B/lOlryE4CYKvA21wO+mALR/dbcqj1x7AhNgNgtxTUud5I9dAPcUgW9gA
	 L6nQ6ZMO9g0CLm1RW2ZRV/9VwupG6PKYmKnsKACFgyDYjrLjUTfMw1S37uaZtQ5hV+
	 WXrqBLnyOj5iA==
Date: Tue, 9 Jun 2026 21:57:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix pointer arithmetic error on 32-bit systems
Message-ID: <20260610045724.GS6095@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The translation of the old XFS_BMBT_KEY_ADDR macro into a static
function is not correct on 32-bit systems because the sizeof() argument
went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
this turns out ok because they are the same size, but on 32-bit systems
this is catastrophic because they are not the same size.  So far there
have been no complaints, most likely because the xfs developers urge
against running it on 32-bit systems.  But this needs fixing asap.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: 79124b37400635 ("xfs: replace shouty XFS_BM{BT,DR} macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index b238d559ab0369..e0c870beaf670c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -89,7 +89,7 @@ xfs_bmbt_key_addr(
 {
 	return (struct xfs_bmbt_key *)
 		((char *)block + xfs_bmbt_block_len(mp) +
-		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
 }
 
 static inline xfs_bmbt_ptr_t *
