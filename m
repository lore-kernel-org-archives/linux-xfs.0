Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575E03DC87B;
	Thu, 21 May 2026 13:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368440; cv=none; b=kSrHVetM1j1A3vXOeKdHTD+ZyMHJRv9OHHagnSZXuPBywM0bi8Z/+mjwU5/B3y8t5afq4m9+l0At3z4Fi081k4BNT1hVIKoxh65DeQ069sItCZvlllIlzIrStPgM3lqq5sAmWuBJYQKXXdejVWPPzRgsTK7fai1Pn4fK+cZ5jbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368440; c=relaxed/simple;
	bh=bMou4sNd4pPEwJx0wQjz38Y3NO11u7ZCanvKgOk7/DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlIUk+yQyGmTAV1XBI1GXtQQrJ2GbcfbskF7DkpjnegcjuD+adDVXrH4sLmVLmmhwwvLlggGDfHg8IOqA2W8qWPB8icoOQWJBCGr1eWPP/Hi8fw3X3HF2XCYhXOjhh0np+1t/6bsi6PkEOz4/7QefZcWspfC1mb5TCSshxNkA6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCgEd0u2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCgEd0u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C051F00A3B;
	Thu, 21 May 2026 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368439;
	bh=AlGNFvBNSZmFvJVxWwR9twiVjMmPjS17WXUmno5UJ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCgEd0u2yEowe3QXR/ofjZInvBpuM43JyKLug2DtEcdk+mMwbXrvIkoxUIXfJOdBd
	 MdEToJx7cO7BEmGoZOzTBfIZTR+UywNg3Nl0u/+YA7FC5tnPRGyGdgKtvZhfdkxYTn
	 6optQxDSc8fuZgAib1tduXrBNcxs+BSojalHdcGL9ubOSWKnj8QSY3TkrEyO42qVAN
	 Ym3WVG1+jKjsmpdxkwiw6s9zPS8GBwJC9AoHgvHfGb6Cj4Ao3e/bfHlodcps10h41N
	 rT2QtnKfbiH+ApQOQ/C9S7rd56pg3zoos7F9QetG+1zHeCMt/RRciNl7W8+1xQvLuL
	 3xNf3pwFLrYrw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 09/10] fstests: add pre_clone_tune_uuid() healper
Date: Thu, 21 May 2026 20:54:59 +0800
Message-ID: <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779367627.git.asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pre_clone_tune_uuid() changes the UUID of the golden filesystem before it
is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/common/rc b/common/rc
index 7ae9877918c8..1b3a32d9ea9b 100644
--- a/common/rc
+++ b/common/rc
@@ -1517,6 +1517,26 @@ _scratch_resvblks()
 	esac
 }
 
+pre_clone_tune_uuid()
+{
+	local temp_mnt=$TEST_DIR/${seq}_mnt
+	local dev=$1
+
+	case $FSTYP in
+	xfs)
+		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
+		;;
+	btrfs)
+		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
+		$BTRFS_TUNE_PROG -m $dev
+		;;
+	*)
+		_notrun "Require filesystem with metadata_uuid feature"
+		;;
+	esac
+}
+
 _loop_image_create_clone()
 {
 	local -n _ret=$1
-- 
2.43.0

