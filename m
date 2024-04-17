Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15047F7C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389658; cv=none; b=DUeX4viuUZqviwGYpkugZ3zjV4GzGqWeaAngdO3UBEnJUQxrAruyZq6IsZ6o9enO/E+cN7TONZSTLkMw0qDkEWHrqN+Rhtcmh8aI2CChhQk+g8KWC8aiDx+GXJwEOKhdn3LAGar/oxx7wift9Mhs6AfQQJTlBCYV76/V/VM7Ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389658; c=relaxed/simple;
	bh=wQTHdocU6X9aSTlwLTzFjmtr5sqq5UImbv8/THKwpJ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m5QGrDwCvYKjasoeLOx392rQ/OQSzJ01ARsyk7u8y892cWf5GYY78mLASgsAnh3Dc8Vv11S1GovRlbsWgVTk4c49zjSPsifJ5rcG4gNVzK52Echr8ZcRBbLTl6OUJcgRryG73uFPnAdbjouKG6pqGFHq5wS9CQN/5L2d21lsNSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5ti/HC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5ti/HC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A0CC072AA;
	Wed, 17 Apr 2024 21:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389658;
	bh=wQTHdocU6X9aSTlwLTzFjmtr5sqq5UImbv8/THKwpJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M5ti/HC6ckssqobQqnHOG1uUbwjcUbGBEdsax5xo469J7WhN3I8Sa0rlGy2HPjXJk
	 yLWsErEIuX5hrZgY4O9P4XtoOJFpBF8Yu1QTNDzFmnaB5LvMAbxAL8AWXWce/1uaeb
	 NBkgW/UbHvBjjiUfWCXy+ZpZI9ik4fb6loCl6WMrTdbxpnHElkl04XPtHDhjjjvRJo
	 B5tNDonqxz7MFvlfy2sKQ7ZnDv/S5TZUyFkUp/BA5h8LrkueNa5DSouVmIhS5HcIzJ
	 1YLnV0/cs1Xi+YgQ8Ld41+3G4Sx0baYZVdkPRfIQu2uKotDaM5F0PWfxtco+0ICul0
	 ZEiaoAylPCTdw==
Date: Wed, 17 Apr 2024 14:34:18 -0700
Subject: [PATCH 48/67] xfs: return -ENOSPC from xfs_rtallocate_*
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843060.1853449.13120421664271913452.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ce42b5d37527b282d38413c1b5f7283253f6562d

Just return -ENOSPC instead of returning 0 and setting the return rt
extent number to NULLRTEXTNO.  This is turn removes all users of
NULLRTEXTNO, so remove that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_types.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 035bf703d..20b5375f2 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -51,7 +51,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
-#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)

