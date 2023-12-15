Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD5110F8
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>
Subject: [PATCH v2 3/4] build: Request 64-bit time_t where possible
Date: Fri, 15 Dec 2023 00:42:12 +0000
Message-ID: <20231215004333.860034-4-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215004333.860034-1-sam@gentoo.org>
References: <20231215004333.860034-1-sam@gentoo.org>
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

Signed-off-by: Sam James <sam@gentoo.org>
---
 include/builddefs.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 147c9b98..969254f3 100644
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

