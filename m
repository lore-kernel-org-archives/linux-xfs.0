Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506131FBE80
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527848; cv=none; b=V8wrBUQJHsOs+mmAKRlLMugjyu20nPn9WZ+9lRqnei/JeNMlV1wVNrpZVrV8K/p5y9XyQraJMcWFyqqCon5yyyxmeYi0TtyyxsBISVTm2dAWD6QvZ6xjU4s5fGAEcwijeE7Oetqf9mAqnVUolWAfANDBggjaCa7G90fCpMpGBMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527848; c=relaxed/simple;
	bh=CtffnXfGf6THJ0fayY3LRBO/9ddE9d7SukxYgoSwDHg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKDHLTy6x2gmtHQew0uk/ouIg2QOfHl9UdJ85gx3SV7dcsWt+1s5eJBmBOevr6cWBRAZVIwAkXNVkhXhWVPnLMGAefoiRWi9KTUEHsqFH11YDWiopsqyW5vRoOkGfDlfzwCdPx5kLxKSSXORGJVoGyCDseSLovJiK8qCiWGDQqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucWqP0gS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucWqP0gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFEC4CED1;
	Fri,  6 Dec 2024 23:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527847;
	bh=CtffnXfGf6THJ0fayY3LRBO/9ddE9d7SukxYgoSwDHg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ucWqP0gSqyum1JpLDb8QtBpn8wB7zgeCAI7lFikdLaQGk6fdfWghsV2YfVXdi2O2q
	 OOfdZN8ryVVCd681lKO5nk9Vu2GyIDmQaeK9TN6yNKO8Z+2f7M+APOaKdt9GELiT8p
	 Mf2vdy42TTAVxFfWbRDrlKExy77IJTc2VpctdC7vRLvpUccRdgxHlXCUWdo9LZwK5w
	 s6+WIJgKy8DtzXGrpWbaQLhZwNSVUNmZc2FlnOcedA1Aoyb/Sk9lKaLhPFXew5N0PH
	 o8GT+rg9pwtLjGEiapD2UjFvKx9wcC3dr1bd2FHxgnUAmZW9acp0SKm0TU5xdnmoK6
	 LdVaMeicWgdQQ==
Date: Fri, 06 Dec 2024 15:30:47 -0800
Subject: [PATCH 02/36] xfs: sb_spino_align is not verified
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746912.121772.17815430564700417233.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 59e43f5479cce106d71c0b91a297c7ad1913176c

It's just read in from the superblock and used without doing any
validity checks at all on the value.

Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0603e5087f2e46..0d98b8a344209e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -395,6 +395,20 @@ xfs_validate_sb_common(
 					 sbp->sb_inoalignmt, align);
 				return -EINVAL;
 			}
+
+			if (!sbp->sb_spino_align ||
+			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+				xfs_warn(mp,
+				"Sparse inode alignment (%u) is invalid.",
+					sbp->sb_spino_align);
+				return -EINVAL;
+			}
+		} else if (sbp->sb_spino_align) {
+			xfs_warn(mp,
+				"Sparse inode alignment (%u) should be zero.",
+				sbp->sb_spino_align);
+			return -EINVAL;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {

