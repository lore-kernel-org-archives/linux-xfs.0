Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3E1E51E0;
	Wed,  8 Jul 2026 05:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487068; cv=none; b=MRB9GAk9MFGVq/0MBmYXUeiQ9tXdC9WelXO+hz0046q6pB3o4HcZPBUhfIkcEgGbDvMfRX4xJ/zuIQjaEJ/yZ2dpP7E6qrRxQtVarPUmJ9qsxAPSDiDVYVFSsKc51C7xZFUCu19ItYH1MuKXXOXeqNKbY7+rPmTuC0cp7OwLQYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487068; c=relaxed/simple;
	bh=OoDeBw1d3MtqV8UiZirvMaP4yCQa+/SgK1mAqDvxKLA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KOz9v1VO8hAAvYMWbz+IhvCJ6upzVUQVKO36nad9QTmLurRaNP91Ti+Z2wbxiqL+653eSRsG2S5z+LqnLkM3XZ8zvhgXazXqW8yXk0Z88gTJU1xATkNuqzvCgEzCEPqMwY0vAKUDhTJooeqCizZMyfRP4HEWDgjlG+vpQV2NDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKCg9/KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKCg9/KM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E31E11F000E9;
	Wed,  8 Jul 2026 05:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487067;
	bh=z0eP1PC+9/ib/5UkCbwQ8BdVWAE/6FSGiiBAAI3MK1s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nKCg9/KM6APsBdXr7vZ4ODSM8u8z/NRhQR1oeRcXneazA5ak+FIYdGfvBqYTlT29s
	 4au4+Vxfc5iLuhLdCO2vYgM3pvw6P3Y6goc5faP/CkEl5zwg3uuvKytm160vj2sn1k
	 uaABLzpJf48k5W4fB/t/tBEx2XZ6/sRQEf4xNVDb4qyRcFtqUBIA926n/Gm3ImoDRi
	 nOkgDsctdQ8MJhxP+u8fFIMQ7QQS9QOgDpmfeIU1x4z682u5by04cwQ1k4wsqfkkD6
	 lkw0TlMKSEoQD7BoYSeeL7HNyie56ShIoPpsSeXZFihA97VV+yyZJBdPL3b5oUqS8c
	 ENUUEU3NYZFGg==
Date: Tue, 07 Jul 2026 22:04:26 -0700
Subject: [PATCH 5/6] xfs: write the rg superblock when fixing it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs>
In-Reply-To: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The rtgroup superblock fixer should write the rtgroup superblock.
LOLLM noticed this, oops. :/

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 1433f8f9cead37 ("xfs: repair realtime group superblock")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rgsuper.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 482f899a518a85..a52d37c33ca15a 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -80,9 +80,13 @@ int
 xrep_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_buf		*sb_bp;
+
 	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
 
 	xfs_log_sb(sc->tp);
+	sb_bp = xfs_trans_getsb(sc->tp);
+	xfs_log_rtsb(sc->tp, sb_bp);
 	return 0;
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

