Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B213CB2DB
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022362; cv=none; b=sNU254BTTTs8K+TFUitO9Rx5lh05gk5A5l96OOJKbCQrXycsNG+cnQamUyX6U1cfCBpzBTh3VgoP1XfJmpG7m9KUS5s5CeiD+Zg2UqxcPLPtuS9inQ3qOfEmcFYJFPhgoeus4815WY+V+7lnQLJdiaGwauFkEdx4bhRPYVj4+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022362; c=relaxed/simple;
	bh=ZPptHlGHwa3ki7MEMa/el5qrOeQkdwSQhrDfcYV0/Cs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKbMHfCaEL/vEFcNYxSfafFwxZPvDXG3CvRV1aggt7mmV1Zc3WfLsAUIx/ZbT0d6orH9WIoWsEHpzrj5T1/vT03kuUtzgWmjjP9izpMmDWxPdH6OTU6cNYJHQ1U6tKhyT3g9culp8bI2Ns+4TTdxV5mIdTqHSUKJ/hXv0EFCEAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vdv0qJkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vdv0qJkq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 95C041F000E9;
	Thu,  2 Jul 2026 19:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022359;
	bh=s+11tesRZw5cReY76YeCHGn2fDW/F9GLOjnW1zrBuJ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Vdv0qJkq17Zwbd7MCdt5wacthvY7nqDdxuQTy7+51t9rDsTDicls11S3bWOCaGWyb
	 aCfkpqQBc7wODfZbTUusKuXDWlwIbmCYKNzEfZ5cvV9DQuY0CtOXmbHYfxmzdbXLKv
	 lP80RiC7oEZHZjGLrOTxv11uY/HwZ04wmH332WHPiCJ6hGUOpjkJyk37z9RrjWyinK
	 xnW/ZTqVs0RNu9Zb7ttCZMgwLtzBMbVBrAD92uf3hRUjkmz8VrbxF/tnTzqd2glQC0
	 11N4iJS/H+msO3YHpysRT5QDGxIKT0NwERqzdN3Qv5Wj53zmfQ9EDUPnXP0l1650XN
	 EjaeP/id5Z9XQ==
Date: Thu, 02 Jul 2026 12:59:19 -0700
Subject: [PATCH 1/5] xfs: add write pointer to xfs_rtgroup_geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <178302225924.845293.4268373698753480705.stgit@frogsfrogsfrogs>
In-Reply-To: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
References: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
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

