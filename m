Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9FD1F3B89
	for <linux-xfs@vger.kernel.org>; Thu,  7 Aug 2025 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754546344; cv=none; b=sED6hnnDx7eYM2IsLeRfKcpiI60J2ZE0HmTTw3qbtECWI/nZ395cF88N0bH4NB50GNENZ9bvwkEvIFrAB1XGb3Eu2h5dLSzIBqO0e2ABJqV3Fedp53/A/sKJ+H/WJBvPMTX9y5XEJiEt2Oh4Kydj4lpSwAyUVPlYGG/aJvp7Srs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754546344; c=relaxed/simple;
	bh=/WxfQG5NXWdjSiVyOzGU2IrbZI7H8lx6vh0Mys9VRBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P8NdSeVB2tMEjnzSwnIdvoCrj4OwJSr2F0lGqHQV6qBsrMUkolPR3pkH2Msk0nqbEjg1og6KpbHvJmW9HWkIwvfG8Sb2lnHfkUvSXDsy2/GmK7F5Pa1nAUuUhcAwr7B0/gGAsnSkVg5rKrRkkExiJ3AtfpWOHuULZshsRQ/bslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PK5mb4RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PK5mb4RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492F3C4CEEB;
	Thu,  7 Aug 2025 05:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754546343;
	bh=/WxfQG5NXWdjSiVyOzGU2IrbZI7H8lx6vh0Mys9VRBQ=;
	h=From:To:Cc:Subject:Date:From;
	b=PK5mb4RVxQKXfYo7OPEQVlbBxFIkXDJvrAGuVmP3CPJz40N10oWf5TiZXv4sLO9Yi
	 vFhcNarNQ1/l174tSmchWmHBa4McdQXkJVBqi6TcEUiAEA8t7yuGFpqA8uh3MIU+QL
	 iASvt9J4eBBhBVb1myrrNeE+xPXsJFMp/rIbuoXCAe7+Gau/0vqzJKBBh7743e2/E+
	 AHavcQuIW/3jyAAevKo74FGfxHNo651TeApVawHvUrNc4q6WQyDWbuZI8s/iysJcfT
	 N26V1E19qRhUUzE149hWwfkGNjI1BOyt4/xcWaGyZN1cw2a0IbllAPstx+TiO0woHc
	 8S/cEgzC0iGnw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: Improve CONFIG_XFS_RT Kconfig help
Date: Thu,  7 Aug 2025 14:56:30 +0900
Message-ID: <20250807055630.841381-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve the description of the XFS_RT configuration option to document
that this option is required for zoned block devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ae0ca6858496..68724dec3d19 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -118,6 +118,15 @@ config XFS_RT
 
 	  See the xfs man page in section 5 for additional information.
 
+	  This option is mandatory to support zoned block devices. For these
+	  devices, the realtime subvolume must be backed by a zoned block
+	  device and a regular block device used as the main device (for
+	  metadata). If the zoned block device is a host-managed SMR hard-disk
+	  containing conventional zones at the beginning of its address space,
+	  XFS will use the disk conventional zones as the main device and the
+	  remaining sequential write required zones as the backing storage for
+	  the realtime subvolume.
+
 	  If unsure, say N.
 
 config XFS_DRAIN_INTENTS
-- 
2.50.1

