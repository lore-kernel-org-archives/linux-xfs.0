Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5C46AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231248; cv=none; b=oHmJO9Zcg5HY1AAHEyL83/SbqgbxxKftQuncKasYzt9TwrpbufzKKtpuuepZzUJgTDvwCmlaornnDHOTXiHVS0uhSOHj+KBmBWJX9/liX1YTnI8nLDYVLLf9/R4ERRzYB0PW0+Ju0dDv0hjBgwq/44p3Mt+1M6/o+P59MxHYdyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231248; c=relaxed/simple;
	bh=knQOaNIG5Qox40brsuxoJHxp2ttNWejroiCpoJ/MfS0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SAmRbHgefrugvEsdP5IH9llNbNRlUtxs4ZqkdS27PQ9Sy5GfCAD2fv2/r3hIsWbx/MeK8TEw5ySb8iUP5Bk+HCN6oInVnGaZ+lrLrsMZ69kBoHkSm3A4H6CthMMHS5nWLRAcpqEZnfpIDuUKZ5BCymxxh3UH4BRJnk7fRkb2n+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sbfyxe8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sbfyxe8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDF4C113CC;
	Tue, 16 Apr 2024 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231247;
	bh=knQOaNIG5Qox40brsuxoJHxp2ttNWejroiCpoJ/MfS0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sbfyxe8sV11Zg9J29BRn6VHeJYRaymXSw9321cloTF1tAYM84p16XzBk8m5hz4umX
	 r6XcDlW1rfPJj0+P5FxMKCEl6tF7CZIPq3EvV9nHZD9F2f6uLsBw7VdENm0ktMRvwD
	 xE3laB4923I9loyVfJvnsBln9+t+0z+F/jcJ5X/VER9ndFKb2aLEhKeVMRGRLySGPR
	 8S0L4lrNxRhGdAtIkIscZeEmHKqd+UN+VPhseYn6VNt3cpphgno9kG/+zkyTVMBfCn
	 VDpZsHFQTjWGy61iud00rEl6qa/1lQMRCdPsrkeH6ULiWYYehoB1eco9LaJiam0AVI
	 vKQ31GhFlm3qA==
Date: Mon, 15 Apr 2024 18:34:07 -0700
Subject: [PATCH 31/31] xfs: enable parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028294.251715.12707860436017798341.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Add parent pointers to the list of supported features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b457e457e1f71..61f51becff4f7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -382,7 +382,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
-		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
+		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

