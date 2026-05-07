Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF611607A4
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191935; cv=none; b=E9n3/w3jIme02uhuaHwPusOX7wkPEtJjIdYtfURaB7H1aiGt1RA2pmlDnST19Um4yFLmoeTBnv5Z41iY1C3eyRyh7Vb1qFnTqBmH3hb5d8vuKFITxDRLXwChPVqlSnuBLPH70P0ycEqbrMc9hprST/9NDD22IXusSlbfd0CZsxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191935; c=relaxed/simple;
	bh=ZPptHlGHwa3ki7MEMa/el5qrOeQkdwSQhrDfcYV0/Cs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODAdRVmfi+k1UBjT+iF2POVaKOc0RJUzkKX6XAXYkYRLWv5FoG1ACvcGNt2TkjwwgvpIS6BtmrgB7WW//QijHf8vUyWBvtTTJOy77y6c+CkFoAHnPHYDqjYJ/Y95X9dVwo0WsahUIYH3Uczwkpbs2qjjX52iWRG7Dtj4GYLuQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7WnJwYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7WnJwYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11310C2BCB2;
	Thu,  7 May 2026 22:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191935;
	bh=ZPptHlGHwa3ki7MEMa/el5qrOeQkdwSQhrDfcYV0/Cs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r7WnJwYKryDs+6hrQw3CEup5upssQKMMB9lsKT2qQ6i6eeP68MhOc4tJg3YVLn4ib
	 wP4o2rHNFFFh0TXt9ISI0UhA733+H2l7HZ+bT+H29MYjHw03fCZ/FHpo51bx0YDSSw
	 C4TAz+QkWUVSHU0RX5wi4c2a9VXK3K+cxi/+yfdqwyDoTSHk9zEj0lFgLpUT5BmDco
	 23y1ZsDxEsPZijky7GH6RZ1GcfnSLMwvRjRrtbUSa81ZMYGcaIzP+0XJEPb1Z/uafr
	 ybKOuQdmU4oG21lPavc5LYwKDe0+spxKsiFQDS8glnKZIOt5tSx+vm7enRdHNyYySD
	 Bb4auUxyrnFIQ==
Date: Thu, 07 May 2026 15:12:14 -0700
Subject: [PATCH 1/2] xfs: add write pointer to xfs_rtgroup_geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177819182911.3486206.5193162010557711631.stgit@frogsfrogsfrogs>
In-Reply-To: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
References: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: c6ce65cb17aa9321687d1b8a842487f839e1a548

There is currently no XFS ioctl that allows userspace to retrieve the
write pointer for a specific realtime group block for zoned XFS. On zoned
block devices, userspace can obtain this information via zone reports from
the underlying device. However, for zoned XFS operating on regular block
devices, no equivalent mechanism exists.

Access to the realtime group write pointer is useful to userspace
development and analysis tools such as Zonar [1]. So extend the existing
struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
field specifies the location of the current writepointer as a block offset
into the respective rtgroup.

[1] https://lwn.net/Articles/1059364/

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_fs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d165de607d179e..185f09f327c00c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
 	__u32 rg_sick;		/* o: sick things in ag */
 	__u32 rg_checked;	/* o: checked metadata in ag */
 	__u32 rg_flags;		/* i/o: flags for this ag */
-	__u32 rg_reserved[27];	/* o: zero */
+	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
+	__u32 rg_reserved[26];	/* o: zero */
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
@@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
+
 /* Health monitor event domains */
 
 /* affects the whole fs */

