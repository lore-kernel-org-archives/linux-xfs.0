Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9649048CC5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 23:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175443; cv=none; b=IQg35/Laob6z+AFg+08H126tIyNklO60KKcpvFiYmCrZ9CJ9tDWqZZJm0py2/RRS4TSVfr0vcdCy/zOk3LYnCE4tGMqPuCv4Cs5dVqNfm9ov1kpY52BEoT6lnwcmSV5foVXH9S81nUwexoTPS7MLjhtsgAGrGVXQ4zuEIemkvfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175443; c=relaxed/simple;
	bh=SZ7j0xTZEONqE8OFHu8qDCVGiQ7P9+vZ/IuLZczSzLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf3AE5N8gmmhriOqea0eb9UfgnozrUERDic03Eouz0dxPUAkjhGljc7ULlxbfTOFI1Sd/4/EE9X9596mZUnlPI/IN0XgmR+nJ/DGcAaeOov6ovOddw1EtB+L8JFtXftDG51RUe18IKkmXX36KLfjtEGG3V2dv0L5aVXhXgpTpek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <carlos@maiolino.me>,
	Sam James <sam@gentoo.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 3/3] build: Request 64-bit time_t where possible
Date: Mon,  5 Feb 2024 23:23:21 +0000
Message-ID: <20240205232343.2162947-3-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240205232343.2162947-1-sam@gentoo.org>
References: <20240205232343.2162947-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested by Darrick during LFS review. We take the same approach as in
5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
to avoid autoconf hell - just take the tried & tested approach which is working
fine for us with LFS already.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sam James <sam@gentoo.org>
---
 include/builddefs.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index a3745efb..abb141d4 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -13,8 +13,8 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
-CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
-BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
+CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
+BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 
 # make sure we don't pick up whacky LDFLAGS from the make environment and
 # only use what we calculate from the configured options above.
-- 
2.43.0

