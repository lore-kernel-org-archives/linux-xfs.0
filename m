Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61FE1DED56;
	Wed, 12 Feb 2025 03:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331166; cv=none; b=aMmvwU/MQ/hSRfhXAUQzgnyhncyimwzw9U5cGSj752o69DrM69TjbkxeVklHfEUorNrDV6Pqd+NSUwkKlhmV0115FABaSsV4w8lmB+FbhBaA8CexV+Rz6YWCYakQ2WTqrubADHwroexk0L4F8/uuEyj0qyzmlAFwT5j2/5TV8Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331166; c=relaxed/simple;
	bh=TU+b8xnNHHQDCl8mXZVwDmk7NrFQje3B92kBrjzEyBA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmnCCc3p+cYLK5IPFAA4DIqInv79zbA36MzSLzy8TWgodBXWfuiMLjy9Pl2uMqjGfTn0bI6mw/5Z6GakFCJfsz6eXdKCgQiKr38cAnQrU59MptyuO8lBZGnxGeJGsP/Vu/Z0tXP+Oyz7zxaO1ZV4O9nS0DZ6DYS0c2ODVDg5Bds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AG6GIrns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AG6GIrns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4C9C4CEDF;
	Wed, 12 Feb 2025 03:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331166;
	bh=TU+b8xnNHHQDCl8mXZVwDmk7NrFQje3B92kBrjzEyBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AG6GIrnsfLiyVtah1J8fJ7ZVCzzLyQdjMcltzstt/e56pd19qR7AjgaNODTzTGMcJ
	 4wWW8GmtsLu4LekF8O1A6js4ly9navLBPbx6+I8JWWUQ8QXNu77l+H/2+4TrUC6ZE/
	 D2SbO3jIJsu6QRa/4aCZrSSR+2TR75d8rNm4Q3UTWnetJnaAW2XYTSZzL/nvCqIZe/
	 jt44rduSPpsB1nSG7RwD20/4trJ4YSMCXKzLOTGNgx9CuMXYPVKBxUVwZkegIcF94e
	 NBEImQh+PooO21r0R5G4kp+rQ43J0rHFZH7G/Al+5mBAqtH8mIGSZVxnWv3UbRUBC9
	 PPWo5OItb/uYQ==
Date: Tue, 11 Feb 2025 19:32:46 -0800
Subject: [PATCH 08/34] common/populate: correct the parent pointer name
 creation formulae
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094477.1758477.4821811234018602995.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The formulae used to compute the number of parent pointers that we have
to create in a child file in order to generate a particular xattr
structure are not even close to correct -- the first one needs a bit of
adjustment, but the second one is way off and creates far too many
files.

Fix the computation, and document where the magic numbers come from.

Cc: <fstests@vger.kernel.org> # v2024.06.27
Fixes: 0c02207d61af9a ("populate: create hardlinks for parent pointers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/common/populate b/common/populate
index 4cf9c0691956a3..c907e04efd0ea9 100644
--- a/common/populate
+++ b/common/populate
@@ -473,13 +473,18 @@ _scratch_xfs_populate() {
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' \
 			--hardlink --format "two_%d"
 
-		# Create one xattr leaf block of parent pointers
-		nr="$((blksz * 2 / 16))"
+		# Create one xattr leaf block of parent pointers.  The name is
+		# 8 bytes and, the handle is 12 bytes, which rounds up to 24
+		# bytes per record, plus xattr structure overhead.
+		nr="$((blksz / 24))"
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
 			--hardlink --format "many%04d"
 
-		# Create multiple xattr leaf blocks of large parent pointers
-		nr="$((blksz * 16 / 16))"
+		# Create multiple xattr leaf blocks of large parent pointers.
+		# The name is 256 bytes and the handle is 12 bytes, which
+		# rounds up to 272 bytes per record, plus xattr structure
+		# overhead.
+		nr="$((blksz * 2 / 272))"
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
 			--hardlink --format "y%0254d"
 

