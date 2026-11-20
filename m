Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190340;
	b=LIrB+SM35G9H3R1voKYJjJIHL1hnZNg0laY+VpQJ4vRGCsfbEz+QSX51wABjBIYOuebW
	 OBt3c2BI0W1L5qL1Mq4KIO2plPtEEgr+W5dy5X9KSuxoswUDrfH/DjnrGDsH2FW20LaGs
	 NiQzJjEGX1p/ovu60sXVrkiWCA05bDvMowo7DwhWQCCyh1sB4te9LlsTJDu0SPqUG50i4
	 u6Y+biftjyB/RdJUSWRhYwTqrlbUsZNNHp04gx5+wiDogdFQiEGdJl5QNgW760Jqu0anS
	 sfAoYp3Hax9l7QQO7+3GJKE4pc75FeAOGXbc6Hp4r0Qki6D7KTqSdSOOF/LvUJjvTyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HWvx8N4WhHxV9SNACTiKXoUrK6GfLUS7x77BYlIs/1o=;
	b=bns3012mmFFmGQEsBb04uY4IzQv9d8CvnCcX504BvX+z5NxXqQffVKZu3WfBXkutuPnF
	 Gu6M6lN4U/mLzQyQa8AXOCOP2MqeDPrsVpr8SB86RyP3NTIKOUzh1ElaQ03VS4Qxq57ud
	 mU9BFehkEJDqTSBg/4UYcoQ6OIzvAOowpY5zjLing/nypY91mWQHY35Alv5Uy7MHgph0x
	 OsmYLYbSQRkRqj27shitCXzdh/EyRUVbyOvfxbKIJWTRpMZxVC3zFvfC0A4LNZ8DQJd08
	 K+Zl51i84d/7tQwiMHD7Kjq9I5y0TMLnTagi+7FYJahnup8yqRj3/P2xg85Oxox0Xrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPqtNUyv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE24A60A2605;
	Fri, 20 Nov 2026 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPqtNUyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CA51F00AD3;
	Fri, 20 Nov 2026 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190340;
	bh=HWvx8N4WhHxV9SNACTiKXoUrK6GfLUS7x77BYlIs/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPqtNUyvvikrfudBMNWrMk65twBI3rSsLx8gA2FAIH9SxYTXF08TT3kNtOQFYftef
	 zJPXcJoX9sVQT8ot+bBM7rJ1/lIWZW6ISqeYhdNoNnkoTSPbycBHz/eba4yt6iQAog
	 biAvBEXXSl2TAi6CbwwOBdfSdJs/VF+ViEoP0w8p3Z4pus9g5fXS1o4q1JlghYMDpM
	 rVP1/2F9AxoYB18x+bwqaF1Tvv2yOXXC1BnUkvaPLCt+4hwiXL+KaVUSU784W5fVC7
	 IEJ7tsOhJzlAulvIlWgIUWTRINz08Iq787iopzdY0l4Wj9zXLbqAhAyzvySoKSYO/S
	 TT8/BykRTfdxQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 15/15] xfs: enable ro-compat fs-verity flag
Date: Fri, 20 Nov 2026 16:57:49 +0100
Message-ID: <20261120155752.192025-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
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
index 2cb375bdbd76..16d6e8931df0 100644
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

