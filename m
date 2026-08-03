Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F453AD503;
	Mon,  3 Aug 2026 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787813; cv=none; b=Z/oCXPBvjm+CM5fdNqXXi/EKusK8RTdQMcGV12zIF4zjRBztL5DR6vzhDWhu4SmuSH2Iih0/uTTwOSBnvRLfnN/ZbvwTf94n8Za1uo7miVCP2Tszk1ulkc8NyYQ5Aq2jJHXUtg2ixhkDTcmhcwasRwY9JNW8diY2gYNfWA2lLGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787813; c=relaxed/simple;
	bh=zD3fqdriNeyS4psrX9dNSbGJrsTYYoWrAlK7wvQAbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwM3aFlklljwtEvbkCUWXufD6Fio8VqtB6jQlcOIK46k40G0VUB/2S46wZvQOMRfNcySblVo13cJU52c12pbOcku+RIwFPSnKlvGJTqt+yzR3Q3KSwuunT/ILQzL/ISbFnZD/4my+H0Nhbn0uTrL6HMcf9k3SI9NpeENbXZdOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G022tgnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G022tgnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103231F00A3A;
	Mon,  3 Aug 2026 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787811;
	bh=9UsWTPXNPtGAnC/NXDW+DJPQrI7L9qVnDZTXWpl6xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G022tgnCKzcm9H3JLeiqixeL5CzvCMQio8NtQirf+5YHa6q4K/upWaSaTAZtSEYUA
	 d4oj/gdNzLYtzEzqZFBVG3MQ1HClLkJ4A+cM9V90igHp5dxjCmu/M07GpnsFkXNRE9
	 Klx1M2/cxcgchKb94lSQs1RUOUKGTnkAqcp1oxZRWc+1edgXX0WN4OVbFJsMOch8la
	 zqu6Bh/j9EwioaJuC1JosCw1v5XsCT0rzMly+v7KJ90kxIBE0xaD4OjiSG/3u+/YER
	 bldBOq6F3NtCi1O1xTu2ko3TIir3CsXOMIqLiocjVe/xu7PkxHuhveP78oIubns5pH
	 TfUXHaYng4kSQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v14 21/21] xfs: enable ro-compat fs-verity flag
Date: Mon,  3 Aug 2026 22:08:11 +0200
Message-ID: <20260803200820.393203-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fc196d9e12dd..8be1b101b196 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,8 +378,9 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.54.0

