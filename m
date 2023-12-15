Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2810F3
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>
Subject: [PATCH v2 4/4] io: Adapt to >= 64-bit time_t
Date: Fri, 15 Dec 2023 00:42:13 +0000
Message-ID: <20231215004333.860034-5-sam@gentoo.org>
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

We now require (at least) 64-bit time_t, so we need to adjust some printf
specifiers accordingly.

Unfortunately, we've stumbled upon a ridiculous C mmoment whereby there's
no neat format specifier (not even one of the inttypes ones) for time_t, so
we cast to uintmax_t and use %ju.

Signed-off-by: Sam James <sam@gentoo.org>
---
 io/stat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index e8f68dc3..11533c48 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -66,11 +66,11 @@ dump_raw_stat(struct stat *st)
 	printf("stat.ino = %llu\n", (unsigned long long)st->st_ino);
 	printf("stat.size = %lld\n", (long long)st->st_size);
 	printf("stat.blocks = %lld\n", (long long)st->st_blocks);
-	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
+	printf("stat.atime.tv_sec = %ju\n", (uintmax_t)st->st_atim.tv_sec);
 	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
-	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
+	printf("stat.ctime.tv_sec = %ju\n", (uintmax_t)st->st_ctim.tv_sec);
 	printf("stat.ctime.tv_nsec = %ld\n", st->st_ctim.tv_nsec);
-	printf("stat.mtime.tv_sec = %ld\n", st->st_mtim.tv_sec);
+	printf("stat.mtime.tv_sec = %ju\n", (uintmax_t)st->st_mtim.tv_sec);
 	printf("stat.mtime.tv_nsec = %ld\n", st->st_mtim.tv_nsec);
 	printf("stat.rdev_major = %u\n", major(st->st_rdev));
 	printf("stat.rdev_minor = %u\n", minor(st->st_rdev));
-- 
2.43.0

