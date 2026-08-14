Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C22645C710;
	Fri, 14 Aug 2026 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699647; cv=none; b=jOmwtQbytUK4fTAIYsUQ32H3WdW0BC/uU7JfisHcZ3yaUZv2Eve8KPBomsfE07nAKs0I/6DbYl0ZglCEDQRIzLSdtaycOjYva6og7m5KqzWKqdQV7RRgXqxKsituizpFwKhPx3sZcMv7nuBTkSR2nZW8UNDJMqbMI59TIjl/m88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699647; c=relaxed/simple;
	bh=vYsEWnsQN2VdBwS+DlxR7OlUTvk+2EnYiyPdL2P/C+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKrHbvzpdIgntSUY5ATS7lX7NxUFoVReUbgtW7jmV0d75kJum0AkyGt5HeAoR1BRT/BSKg+s8WMPG4qoYZfB1bhq06LWRIOObycFlO2qvxLZL2J4QzZc7Ufu2ncs0r7SQZv6VKjba2gkQ4FPm38qXdFWas7wC2p9iWrUH9JR9Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P80IHQvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P80IHQvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC9A1F00A3A;
	Fri, 14 Aug 2026 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699646;
	bh=d+gCw8DY5xRJnv9bLvU/3aejVrqjwUJS770c7agRs00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P80IHQvDwjhD7oBFPrnAacVTRuUgQ+ducv49FMhfl4AygPacOl3IGnpw1RG4pjO0g
	 4HVbIVid+GHfrfLN+7sJgOxifxhSwAl4u9zLpuIbGRLjqdon2NW+3wHvntxo2JyS9D
	 2w2sgxhleKedJ5zy6s+kxWLsWkDPh0mTo0oHeUDwfWEkPebjuo3U1JVQq6YtR8lhcR
	 Eb+IEWJkHgZgrygiFYEyCnPn1+uiSjOtkW/EmPiGf8RaaJvPjcB1hKJnRutxbdas6i
	 z9TsQmQAHo0LnaZGNd0pveKVI969RfdKi5FQ7AYfFZDv1yNIa9VAhNB+phz1xZJXYW
	 Sf0fFISR08fgg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v15 22/25] xfs: advertise fs-verity being available on filesystem
Date: Fri, 14 Aug 2026 11:24:39 +0200
Message-ID: <20260814092448.1818082-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..c80133784419 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5ac467f387c2..4f9657c8dd95 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1590,6 +1590,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.54.0

