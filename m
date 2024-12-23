Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F281C3BF0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991265; cv=none; b=vFtWL3RARaua/QtpWjWMcfixA6EFL6XKsF+NUQmgfsbRFpn3NZmmEcyAVFybrOymMg5YxoPBdC/V668cXmw/G9s6Cgwzo5sP7bRC+O9Z6WdLec+e2xcop3ne/7MHNmdDzYPV988EoihZLw0VIGZ/ovCegO6xmi0Mwo79+QX+ZTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991265; c=relaxed/simple;
	bh=8yTtbzLtjnqqwP3HJvjNqwIz3bVaodJL55guKclnzRk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMnZsd6m191rB0hjY/m5FX+CUWWQMX5DGgleNrOLh/VTICspubC9CdHetUx9fjFM/b4vnooF+dd9xzSJgNi0J/G4F8VPRPgLnHnDVh95fFWEOAAWMvogMZ/nSSXTF2SD0HRATj+wNZvxy4ANfSwYrj42Z7TfdAjJxoFM6i4Ueug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GprfpdgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GprfpdgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9036C4CED3;
	Mon, 23 Dec 2024 22:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991265;
	bh=8yTtbzLtjnqqwP3HJvjNqwIz3bVaodJL55guKclnzRk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GprfpdgPu0f3gaASAfuc5TbzsnuONa8MIWFs1Q8KzKW0+z5ObG70SlHmBUDNWjkCT
	 Ff1+4DJgN+IkgyacpKiJfbXkht/RGBH9ZFWtA0N0B7y6jVgpkvCDxwx/RT9/eKo4yt
	 bovZ0stFrc8UxkElUsSWTbxHsbSiTBKQZMWEMl5xlPFareCt9fk76JaOM9GkUnDP92
	 JBZnFe9yZrGQ8bhpg96gXyf/PBMtUuFLDACBenN6Z68v3ZQkVGadR0dlcO3/Ha9mJE
	 4pe3dBOn7/uE3+NMw44O2aBqWmWsgLH/QG50+Q2LG4CNjIVIysfseaIyENGMxlj/dE
	 Gawwssh9RNylA==
Date: Mon, 23 Dec 2024 14:01:05 -0800
Subject: [PATCH 11/52] libfrog: add memchr_inv
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942662.2295836.2984603077407926581.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add this kernel function so we can use it in userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/util.c |   14 ++++++++++++++
 libfrog/util.h |    4 ++++
 2 files changed, 18 insertions(+)


diff --git a/libfrog/util.c b/libfrog/util.c
index 8fb10cf82f5ca4..46047571a5531f 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -22,3 +22,17 @@ log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+void *
+memchr_inv(const void *start, int c, size_t bytes)
+{
+	const unsigned char	*p = start;
+
+	while (bytes > 0) {
+		if (*p != (unsigned char)c)
+			return (void *)p;
+		bytes--;
+	}
+
+	return NULL;
+}
diff --git a/libfrog/util.h b/libfrog/util.h
index 5df95e69cd11da..8b4ee7c1333b6b 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_UTIL_H__
 #define __LIBFROG_UTIL_H__
 
+#include <sys/types.h>
+
 unsigned int	log2_roundup(unsigned int i);
 
 #define min_t(type,x,y) \
@@ -13,4 +15,6 @@ unsigned int	log2_roundup(unsigned int i);
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
 
+void *memchr_inv(const void *start, int c, size_t bytes);
+
 #endif /* __LIBFROG_UTIL_H__ */

