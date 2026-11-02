Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630568;
	b=feczZvSP4vp7f02o0tb/5gbnuCsWiz9wtb+3TUu7vWYVxzhRL2m0I3OcCdRjIfpwZrEm
	 xGVbqkFVRH/qeMPq0ZXZaCvyfHoTBym9JtYIm1JdTCbs/0mzAFQIR3wOyPCNKEAp3xVNl
	 JfmHF/dpXm+DTvjR5tqKrNbF6Avj3b9PgOCL4x+7dME0qhbRZZMX9CzienPct0ke6hMhD
	 AFjHrimqHpNYP6eIxHWcyrroD+8jtd3noOduSIvr/E5TtWeJUcFLZTK9PFZVkM4xfV02Y
	 NJppZIzAt6bqD5mWGjByKKtoT/29thFXxX7pk8+wCyR9zbsQriai/slLEQbK3j5XvsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZDF3hFd0AqvSSItMBqnpXxJJycke+FURr780crstz+c=;
	b=IePM9fcA9ymh9UMBh5dyQSKgS511yWcyvEYNtUxJ/GUEeBcavRNY4X8Vp6uTG6+AsBwF
	 g+wNefjKQauGsOoWYczyQSTdjbwrNXaju1B0UIRq6UTYfKxZUiqI5I0/zRsryGPtCPb7G
	 KcrASTx3+sZIVS62uB1Amz0tQWidIcWT0hr/6MslIbDyxIj/mJcLJ9amyknEIanxRXUnH
	 TGxFpnzpSBS5+7FJHA5Tpj9a7csfilXOy0HOjEg0zhg6wdIuo+zzBfvBnzGQsHfVhisln
	 6WRTTvhhtvLxxvS0BqGcL5IOoLXhIw0o2QLzqAUMKXewr1r+o5X7aCl/XyuthFU1gbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qy6Ftoyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1FF606FB5A;
	Mon,  2 Nov 2026 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qy6Ftoyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2411F00A16;
	Mon,  2 Nov 2026 14:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630567;
	bh=ZDF3hFd0AqvSSItMBqnpXxJJycke+FURr780crstz+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qy6Ftoyu8yc+meLQrnrdryZl9ErdV0jwOAYRuF3ZJoT+aofXGVah2gg5m+GlE+7dd
	 DRiE4GkRmNnNTIy5w1Zxp8u86KXIVcV1adHFYgg6V3WfgpPHzvR+PDHSvObtqsvxN2
	 l0LGiLb7QGwQEBNRTmuye2E4WjAR95qIYq355m8vyxwQ9nHXM7wj40oVssQEwPHmP0
	 GguowVFJ3kzfoBoLWMbSvH8tG+PhuNYeUGJv28M1aAG0bUGTngXtpJ8Kl/x1v62UoK
	 UQguF43KKeWoYHIQJUzovHtipbh2g361rraHPi9a8nnS/ZZesjfKTUIIudbPab9Nww
	 67Mr/FhewVNOA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 15/15] xfs: enable ro-compat fs-verity flag
Date: Mon,  2 Nov 2026 15:41:45 +0100
Message-ID: <20261102144147.2393369-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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
index e1f50ad18f0b..6594fbe4f7f6 100644
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

