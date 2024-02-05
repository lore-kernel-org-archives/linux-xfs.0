Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291B0482FC
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 23:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175441; cv=none; b=XT4zMltW6GEgeCCl6AEFYBjVjpr2fPLEB0/MbhvGSmavCABLBuDSjEk2DSTZgUzwgvQORgrnWD/Pxemtqet70MIEKVzgWotR70ofUWgmWv0HpvgMCuvNASM0TNFXmr8CjuASxSSnHV9AHu0Q3vi1xk3HGJ3w2EWuEn8RbFArg7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175441; c=relaxed/simple;
	bh=129qQNB2iTza9/Bz6cOPy4Iw1KiRJDPgYjMg0NMcZtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKf240thuqzuPId5ZL7eeiVaW7Jn0zCG0TzEW7tl4f7LKI68COyv9lBxYvUqBv2UhUIpQi28jz8cBvdNa2uyC8PYV4JjW4hkw9pHxfjx4TY5IZmzgNaTVcbh7dAih7Ewh/atOSw5011/PlUuxmiQDNJsFhqcloZBqeUtylu/9Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <carlos@maiolino.me>,
	Sam James <sam@gentoo.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 2/3] io: Adapt to >= 64-bit time_t
Date: Mon,  5 Feb 2024 23:23:20 +0000
Message-ID: <20240205232343.2162947-2-sam@gentoo.org>
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

We now require (at least) 64-bit time_t, so we need to adjust some printf
specifiers accordingly.

Unfortunately, we've stumbled upon a ridiculous C mmoment whereby there's
no neat format specifier (not even one of the inttypes ones) for time_t, so
we cast to intmax_t and use %jd.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sam James <sam@gentoo.org>
---
 io/stat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index e8f68dc3..743a7586 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -66,11 +66,11 @@ dump_raw_stat(struct stat *st)
 	printf("stat.ino = %llu\n", (unsigned long long)st->st_ino);
 	printf("stat.size = %lld\n", (long long)st->st_size);
 	printf("stat.blocks = %lld\n", (long long)st->st_blocks);
-	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
+	printf("stat.atime.tv_sec = %jd\n", (intmax_t)st->st_atim.tv_sec);
 	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
-	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
+	printf("stat.ctime.tv_sec = %jd\n", (intmax_t)st->st_ctim.tv_sec);
 	printf("stat.ctime.tv_nsec = %ld\n", st->st_ctim.tv_nsec);
-	printf("stat.mtime.tv_sec = %ld\n", st->st_mtim.tv_sec);
+	printf("stat.mtime.tv_sec = %jd\n", (intmax_t)st->st_mtim.tv_sec);
 	printf("stat.mtime.tv_nsec = %ld\n", st->st_mtim.tv_nsec);
 	printf("stat.rdev_major = %u\n", major(st->st_rdev));
 	printf("stat.rdev_minor = %u\n", minor(st->st_rdev));
-- 
2.43.0

