Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC9E30F7EA;
	Mon,  5 Oct 2026 05:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179734; cv=none; b=HFNG+GMOJbYn8a479Si0hHBihgtBRETVG22bGK+caq7eLFdMYMHIZYxQ9xDB5DMhBOyZX9mT/pYiw9F3sZcDKtxakDkfNI/XAQbDp1K448ElvbfC7jLhxcNN2NRqR7TRyweOthZITO0jSc0gp1whgyj1oNlCODtmzUrYWfoLphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179734; c=relaxed/simple;
	bh=My+SZZrKRIJIDZX7RrAs3Nf09F83WIjNdiTBl23CrUA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8Eqg7SCxaP1RBamolrHhbYZ78YPuug3px2A03ZK2jBe+nFIEpg1PehEA4ZO+uEb3Om4Ozp7QmNE1e4by1V7oHfB1bX42U/Xc0GHSztM/hLowEapzz9gsD4CR6roruF+lQ6gJ3T/NVTAjoczQMIVzJ5a1aVubxZ0tGNh33lUCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkcjEOtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkcjEOtJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8EC2F1F000FF;
	Mon,  5 Oct 2026 05:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179733;
	bh=zG4enRpM84K6HFCqqM33X5vU8ExYI+Ioj0GTbqvo57k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WkcjEOtJRRsB1v5puh0X+zjhMjqrlESM94e7d0kfm4vkyrKCon4oTiAT1w1HQ99cO
	 PBKL7PTzAJnzrmp6kzp80NU2Z5mPXSiAS49Ftahb95Aze/YuL+hDyqWXinwxm0R8z4
	 tVrz0CUtU+PBMQQRSyf7OpmIMs0+FTmZ0dKlfFCWGsEIhRvze/PDvnHbDHVjE7ADf+
	 r46TO0gqHFWvSbuTWVC8Tauuv4ZtALkfjyIbvyUrVEm46mbvl/kB59dn/g/T/BVG63
	 hIoS665nTvmzNIe+kH5XXpnPEyW0dyeIJ7loDQOEY90+YuaC9sgw0CG+3Td/aMH755
	 OrELwoDgDOA4w==
Date: Sun, 04 Oct 2026 22:55:33 -0700
Subject: [PATCH 01/12] xfs: flag excessive delalloc rt extents as corruption
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965030.614350.6588199428729564800.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that we should not allow repairs to proceed if the count
of delayed-allocation realtime extents exceeds the number of free rt
extents because we can't install negative numbers into the superblock.
It's unclear how we could end up in that state in real life, but let's
at least complain loudly about it if we ever encounter it.

Cc: <stable@vger.kernel.org> # v6.2
Fixes: e74331d6fa2c21 ("xfs: online checking of the free rt extent count")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index b3fb1b4227659d..eb1a095a0fa9b9 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -609,6 +609,13 @@ xchk_fscounters(
 			try_again = true;
 	}
 
+	if (!xfs_has_zoned(mp) && fsc->frextents < fsc->frextents_delayed) {
+		if (fsc->frozen)
+			xchk_set_incomplete(sc);
+		else
+			try_again = true;
+	}
+
 	if (!xfs_has_zoned(mp) &&
 	    !xchk_fscount_within_range(sc, frextents,
 			&mp->m_free[XC_FREE_RTEXTENTS].count,

