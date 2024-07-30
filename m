Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D90C8C1F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299481; cv=none; b=KMv/888kgVQYeNjqMXqdzEnJJJpU6DllczXN9knHzbicUiAXBve7O0qCiu8B4A23da7bAAkjlq5VTV30WMZuYVIJoKPgvPxx0pbMdoKyiP+hq5lzXT6f6o0Wrc1BPvv5csCm92I9mQQFqqJ/OckinkUjrQY0mCsX2ksf+Bl348A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299481; c=relaxed/simple;
	bh=39IakTWi3zCEICDb52Uoee0r66UA2LI5mhjfhQ8T9RY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+Imue81GNf64FIhiEpLzMAgfNiRr4ScOwaqZOrDKCe83iGa6Zlp6XRIkIe7Mrtttybxac5YtXOLiz1kSK4ogKscyBQSKskLHIf3FLJZU7wxLnc48+v9SxU1fTzlqS16gh1KNgsRR+1Syv3yPUrAL/QNpd3wEc+8cqnHvILKrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksoBP7mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksoBP7mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9329C4AF07;
	Tue, 30 Jul 2024 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299480;
	bh=39IakTWi3zCEICDb52Uoee0r66UA2LI5mhjfhQ8T9RY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ksoBP7mKcI1ghOxk7hXOUt1//OKpxk6V/ap/CS84CQW/9vtj+7485nfbB+HY/V8Vc
	 WdF0vGSl/hsrzFfSqA0lKK+lrEd19PTiV4fmK9bLncNy2rhUKyLeZrXnkZPd0aKvfb
	 CagXRwXPn8lJ+0a+DjvAHgbx78676zmIE2uSmjIz4Iz9GLxk2+tuxl38vdyiIcANci
	 5xk+dUkHQraEVw0wtcmwCJgnxnEC80+0/TOZkLKn8sHtjyNxU7lSpwCTWqbI54qkHO
	 g6eGTUXIflR0lOJHzg4gqFHlNK0w9J0/wmNOC+/Cs/I9ekqI3QRPmDrHRmDoM1nPc+
	 u0rKja3d2T4uA==
Date: Mon, 29 Jul 2024 17:31:20 -0700
Subject: [PATCH 029/115] xfs: pin inodes that would otherwise overflow link
 count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842852.1338752.10880318687395849229.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5f204051d998ec3d7306db0d749bddcbf4c97693

The VFS inc_nlink function does not explicitly check for integer
overflows in the i_nlink field.  Instead, it checks the link count
against s_max_links in the vfs_{link,create,rename} functions.  XFS
sets the maximum link count to 2.1 billion, so integer overflows should
not be a problem.

However.  It's possible that online repair could find that a file has
more than four billion links, particularly if the link count got
corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
not large enough to store a value larger than 2^32, so we ought to
define a magic pin value of ~0U which means that the inode never gets
deleted.  This will prevent a UAF error if the repair finds this
situation and users begin deleting links to the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 10153ce11..f1818c54a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -899,6 +899,12 @@ static inline uint xfs_dinode_size(int version)
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
 
+/*
+ * Any file that hits the maximum ondisk link count should be pinned to avoid
+ * a use-after-free situation.
+ */
+#define	XFS_NLINK_PINNED	(~0U)
+
 /*
  * Values for di_format
  *

