Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75455172798
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 11:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265328; cv=none; b=K4OLjvdsCseXkXGuVUE0UerkEufkRM9eLtwulsVOI0D0jjbuzV1HsnG/3zdfSVVrFGHYQ8jqWGUz9TiJ4V5ym+mE46FPVQlYjhgeNHlLQB4VahNAVJaxBpHajOJNsYJyqhBuYG4vOeufy8OL/6lqvKj70wGTJYwOcEa05Ji7pE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265328; c=relaxed/simple;
	bh=Tu9XdvQAW/Nk4f+7tkfYPFqjRqc1nNK0PjUBCPmkuTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lgp1dwLNgqBL8OX0ifXYNfczSf/QwUTZpJKhs/AHIsnn/sY74pPKMqGdYGgy1zJHAQXtXAVHeljiO3W86JXFhlkoJuCzr28HCStys0UmUk2rWr147/6D0L7Ppv8opQ42oX6LfiNUKNrDAkwWColU7dA5OD96lsz6IXPVnV7f0Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHv0A/ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHv0A/ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7FBC4CEC3;
	Wed, 25 Sep 2024 11:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265328;
	bh=Tu9XdvQAW/Nk4f+7tkfYPFqjRqc1nNK0PjUBCPmkuTU=;
	h=From:To:Cc:Subject:Date:From;
	b=VHv0A/edzLSPzlkXQ/VvjCJKuHJKSzns8QdroyrM+qM8cw22ahpChCFgWJBKlEwKM
	 MHReA7R5vT4hJIO/hN6JNpKttQP0A4YjxdODu3w5cRxoph9nJdYDkuXtnPxE78ykQL
	 KbQkeu53v9HFsKw5WtYVX3Q5f9Mc0UxvCWpDG7geSVmUW/jHNzpWV/r0nCyYu+swxg
	 NvRrGNEnAyAmIH2jMa67LZEwAh5alfQc6Ls4C63tJWW0lLWcig4s6ur921eHP/wui9
	 TQs5NeB9oUhdBJ+F1C1Umi4ufu1oXWHlwHJz5daKYJ8JsN47SO3N527nE8RePSBGKW
	 iMMDp8bMqDa1Q==
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	cem@kernel.org
Subject: [PATCH] MAINTAINERS: add Carlos Maiolino as XFS release manager
Date: Wed, 25 Sep 2024 17:25:09 +0530
Message-ID: <20240925115512.2313780-1-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I nominate Carlos Maiolino to take over linux-xfs tree maintainer role for
upstream kernel's XFS code. He has enough experience in Linux kernel and he's
been maintaining xfsprogs and xfsdump trees for a few years now, so he has
sufficient experience with xfs workflow to take over this role.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7387afe8f7ea..9d6ae8df2dc3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25297,7 +25297,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
-M:	Chandan Babu R <chandan.babu@oracle.com>
+M:	Carlos Maiolino <cem@kernel.org>
 R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.43.0

