Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74E3158D9C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724759439; cv=none; b=lYre/RdROuxoBazoF0nAeOyhnkJLC3ukodL2IhZNNevZ1RwDB34Do6h5P3hzz/kcElAoZd9LK4PBKn/v0j1ZbLVrvjKnTNt/kUtcyy36/SDMjQnsv/U4b55Px6v5lCUNH4WH7RpIIZp0r0x7An4Co8gOfwFHBD4LjhIwrXk7yZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724759439; c=relaxed/simple;
	bh=I8csq+FuXaa4cujk6EKMJ9Cmsw5gK8qeV5DxAp1l1OI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nfRrIJeoLicbvOUJbkDWY/c93CA5N1EeOxnw3iBbEhWVzp7HHQ5HUfJPHOb+llVYXW3y6cPU508JACFO19sC1wwst7u29I1T7CVtkl6PPnycjyPdvzvpUleGgKgm2VCKeGvn4peXY3DTjvL9fbbVvZHPUQGSP2ceqSf22JnOQxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjLOv6KH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjLOv6KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D383C515F9;
	Tue, 27 Aug 2024 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724759438;
	bh=I8csq+FuXaa4cujk6EKMJ9Cmsw5gK8qeV5DxAp1l1OI=;
	h=From:To:Cc:Subject:Date:From;
	b=jjLOv6KHNrMaMGkUlEgSfJs+oV4l4vAMkaPeP3pKsLHS7wudcq4VkQkrEMr5bCzAN
	 gwKoZCpARtNKId69ZUTgpDwI4QapJbe0vopsYsFhRxj65hUeOEktNlz94YRgftXViT
	 w96vaq+nMx/iq89wXq38hHgJLL9tYGG0boFe8XQZeclCD92XTlVxQMk71/bWVllAw2
	 cuzjoWnLalhaYkJWtC891ihLTeBZQ4SQEbp68UH5AdzGdphknr8oXLVG06YYDdON6i
	 4QwB++AMSTbaJn/ACWN19p7cwsXIMzQOvHHAq/tq0RllP/4Laq/mOtwc59gwkRH/Ej
	 K5PQyWKJWNLkA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	hch@infradead.org
Subject: [PATCH 0/3] Get rid of libattr dependency
Date: Tue, 27 Aug 2024 13:50:21 +0200
Message-ID: <20240827115032.406321-1-cem@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

libxfs already defines most of the structs used by xfsprogs, so we don't
really need to link against libattr.

To make things more organized, and smaller easy to review patches, remove it in steps,


This is only compile-tested so far. I just sent the patches for testing,
but giving it might take a while, I'm sending it to the list for review.

Carlos Maiolino (3):
  libhandle: Remove libattr dependency
  libfrog: remove libattr dependency
  scrub: Remove libattr dependency

 include/handle.h   |  3 +--
 include/jdm.h      |  5 ++---
 libfrog/Makefile   |  7 ++-----
 libfrog/attr.h     | 23 +++++++++++++++++++++++
 libfrog/fsprops.c  | 13 ++++++-------
 libhandle/handle.c |  2 +-
 libhandle/jdm.c    | 14 +++++++-------
 scrub/Makefile     |  4 ----
 scrub/phase5.c     | 11 ++++-------
 9 files changed, 46 insertions(+), 36 deletions(-)
 create mode 100644 libfrog/attr.h

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
2.46.0

