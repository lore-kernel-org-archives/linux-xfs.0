Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C71234D3BC
	for <linux-xfs@vger.kernel.org>; Sat,  8 Nov 2025 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762612828; cv=none; b=nXlDeAjVfs06EqgnjiQRBhzB1uObi46mx6PnXUe3PVEhGd1Wfo24vmOht9r/BSCNmLOooD0LyVVrwv6oc2X27QUYWd7jNIgJgl8TWC2hoItnoDxCXOwoSizrTHnJqc5ue6SAfTIkf3WYI7so6+cExz56MnjUy9YLLwa7x4sXeGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762612828; c=relaxed/simple;
	bh=t1MtSLoKbhqAWfG9HyHPJzNMxdt4VSllDHbkfCjgpHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bFH7wJcN1vo8IF36r4NRamXUpRZ+7s+ZwrE//D5QLcewlgFU1u6Pgbwobk7I1lhNbTmF8tMG87vqUY0KQzrDM2xOl6hdbzuQV571fUkPjIvOwogudu8QswXYoLnXay63P3SL4IjuUYhrpije2wNuRK1Ik7h7hIgjebBgF9ESuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKH5u/sG; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKH5u/sG"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c7869704so1247013f8f.2
        for <linux-xfs@vger.kernel.org>; Sat, 08 Nov 2025 06:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762612825; x=1763217625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YacYRNt0Vw+1kuJhnLB3kyf/ZF3GJhXXYii+RSXfdcw=;
        b=lKH5u/sG5xNse6OzwSl1e9dx5ykkFuxu69kJrNHuiA5WLwfo6h+q5V9DRHXDdUtccl
         BXzolACj4fy3egX8IMC+sPZC1pCQ2SQ/Ja9dlUkNEWiNpxhsceUd77bD+UwY/S9rlDLo
         khG8YBf/Ge2/77oYFCRgHjSnkZ0k8ZFvbV9BAvv0mswnwuJG6KO9O/najTTtj4ivLp+J
         vp9qGFHfvpQaao6meVqiI10ZqXmfL/kE3wEvO03MANSFi4zQgzSkTZsjVe3UHOnKD/BQ
         NMWpxLOx2osYNBhOndBVqWnQ1P8lU9tZadX8YyUuccs1yCIXCXwtDrKJo2eszX9IkvvO
         kwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762612825; x=1763217625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YacYRNt0Vw+1kuJhnLB3kyf/ZF3GJhXXYii+RSXfdcw=;
        b=NrvUrj4McR7krSybH7NKUzhL6qfivdjAk3iwcLb4lJu5pPy99U9J9M5WRtFQHd7q92
         AF3A4T0ZuOvcgLhhFt2ZjO0tmj/KcL7Vu1zRbCIdin2vrbd3F1lPYGoNcZl0gQ+2gf1P
         K3wRQReDgoWs+BqmYsBZD/UsRk05BU1sKnn0pTscF9TF9E+yQ4dBkcjxatfWBuqrOZZK
         t1lTFku1WaOBFQfU2MIDirJ5OedVJ87idnWhHLUUs0ZwwsQP1rPNn1DeUWqG0mrv66AW
         /EMni7Ywsp6Ter4HKvAWqC3bRexrIv1C0o8o9TCvZTIBWXYzHSBkopt2XMNVpys358B6
         n+ZA==
X-Gm-Message-State: AOJu0YwCgKP71Pjb5VFm9q2qIO6Z1VALbmGjMDlE09TSr2f2WliSCNa8
	UUDw/iM6gUn/dksrKBzLaWzOZloi/ReXA4OF4oU6Q4+Ky4PPWAZboO5c7My5vg==
X-Gm-Gg: ASbGncsYGPbRZuAPaZVnZhueBnqKx9hBqhpp4ofChU6d90nEe/dt0wrsxWNA80IS+Og
	AukabF/XnvKXSctgOEq5h1UYLuZvOvU8PC8WyvWOWaa8Z3hXiyh7qyjpYdNxr+vm/oZqb1QIHJC
	yeXkbinY9h6d8x2CRbN+q3EBLR9XvBNUmioMRLRpLjH72ki+uhfWeFO2O6AOdmMlWvWqaUXsHGI
	VIdZ4VEjMgTaFAhpeNJEY33kS601u6oWQx13EDvQ8c4QgPqM2QAi602Va7bmatLc6vThR0k1oG/
	dwMysWBnT/FEVOVwiot06oP85P/A8nSkkYvWU2goFBdT4g5Gxy0L7+8qQ/Fy3PCtJ9x/7f6drei
	mJlsN4otQnvgROIIIAiHpJheQt0mW4b8It6MT7CRTannJ6C1seE21Mb5tLNd9hSCzgSu8VRTCW6
	Bsd91e6zxbpQna4msmRdFZWDOfrJaOk+nV14Lf84ZYGqHWkF46GpBymcu5vfJDspf+2FtTq8LCs
	lgIleZqHQ==
X-Google-Smtp-Source: AGHT+IG6nls9QccD6bAmbqklsBRdouq0ImfZIn+6dHKpphsmKiNvcinpWPYDeQl1LKA+ZGowG8zULA==
X-Received: by 2002:a05:6000:2211:b0:429:d66b:50a1 with SMTP id ffacd0b85a97d-42b2dc2fe1bmr2034173f8f.22.1762612824359;
        Sat, 08 Nov 2025 06:40:24 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe63b7d7sm12158508f8f.11.2025.11.08.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 06:40:24 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v2] libxfs: support reproducible filesystems using deterministic time/seed
Date: Sat,  8 Nov 2025 15:39:53 +0100
Message-ID: <20251108143953.4189618-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for reproducible filesystem creation through two environment
variables that enable deterministic behavior when building XFS filesystems.

SOURCE_DATE_EPOCH support:
When SOURCE_DATE_EPOCH is set, use its value for all filesystem timestamps
instead of the current time. This follows the reproducible builds
specification (https://reproducible-builds.org/specs/source-date-epoch/)
and ensures consistent inode timestamps across builds.

DETERMINISTIC_SEED support:
When DETERMINISTIC_SEED=1 is set, return a fixed seed value (0x53454544 =
"SEED") from get_random_u32() instead of reading from /dev/urandom.

get_random_u32() seems to be used mostly to set inode generation number, being
fixed should not be create collision issues at mkfs time.

The implementation introduces two helper functions to minimize changes
to existing code:

- current_fixed_time(): Parses and caches SOURCE_DATE_EPOCH on first
  call. Returns fixed timestamp when set, falls back to gettimeofday() on
  parse errors or when unset.
- get_deterministic_seed(): Checks for DETERMINISTIC_SEED=1 environment
  variable on first call, and returns a fixed seed value (0x53454544).
  Falls back to getrandom() when unset.
- Both helpers use one-time initialization to avoid repeated getenv() calls.
- Both quickly exit and noop if environment is not set or has invalid
  variables, falling back to original behaviour.

Example usage:
  SOURCE_DATE_EPOCH=1234567890 \
  DETERMINISTIC_SEED=1 \
  mkfs.xfs \
	-m uuid=$EXAMPLE_UUID \
	-p file=./rootfs \
	disk1.img

This enables distributions and build systems to create bit-for-bit
identical XFS filesystems when needed for verification and debugging.

v1 -> v2:
- simplify deterministic seed by returning a fixed value instead
  of using Middle Square Weyl Sequence PRNG
- fix timestamp type time_t -> time64_t
- fix timestamp initialization flag to allow negative epochs
- fix timestamp conversion type using strtoll
- fix timestamp conversion check to be sure the whole string was parsed
- print warning message when SOURCE_DATE_EPOCH is invalid

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 libxfs/util.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/libxfs/util.c b/libxfs/util.c
index 3597850d..f6af4531 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -137,12 +137,76 @@ xfs_log_calc_unit_res(
 	return unit_bytes;
 }
 
+/*
+ * current_fixed_time() tries to detect if SOURCE_DATE_EPOCH is in our
+ * environment, and set input timespec's timestamp to that value.
+ *
+ * Returns true on success, fail otherwise.
+ */
+bool
+current_fixed_time(
+	struct			timespec64 *tv)
+{
+	/*
+	 * To avoid many getenv() we'll use an initialization static flag, so
+	 * we only read once.
+	 */
+	static bool		enabled = false;
+	static bool		read_env = false;
+	static time64_t		epoch;
+	char			*endp;
+	char			*source_date_epoch;
+
+	if (!read_env) {
+		read_env = true;
+		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
+		if (source_date_epoch && source_date_epoch[0] != '\0') {
+			errno = 0;
+			epoch = strtoll(source_date_epoch, &endp, 10);
+			if (errno != 0 || *endp != '\0') {
+				fprintf(stderr,
+			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
+				progname, source_date_epoch);
+
+				return false;
+			}
+
+			enabled = true;
+		}
+	}
+
+	/*
+	 * This will happen only if we successfully read a valid
+	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
+	 */
+	if (read_env && enabled) {
+		tv->tv_sec = epoch;
+		tv->tv_nsec = 0;
+		return true;
+	}
+
+	/*
+	 * We initialized but had no valid SOURCE_DATE_EPOCH so we fall back
+	 * to regular behaviour.
+	 */
+	return false;
+}
+
 struct timespec64
 current_time(struct inode *inode)
 {
 	struct timespec64	tv;
 	struct timeval		stv;
 
+	/*
+	 * Check if we're creating a reproducible filesystem.
+	 * In this case we try to parse our SOURCE_DATE_EPOCH from environment.
+	 * If it fails, fall back to returning gettimeofday()
+	 * like we used to do.
+	 */
+	if (current_fixed_time(&tv))
+		return tv;
+
 	gettimeofday(&stv, (struct timezone *)0);
 	tv.tv_sec = stv.tv_sec;
 	tv.tv_nsec = stv.tv_usec * 1000;
@@ -515,6 +579,49 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
 
+/*
+ * get_deterministic_seed() tries to detect if DETERMINISTIC_SEED=1 is in our
+ * environment, and set our result to 0x53454544 (SEED) instead of
+ * extracting from getrandom().
+ *
+ * Returns true on success, fail otherwise.
+ */
+bool
+get_deterministic_seed(
+	uint32_t	*result)
+{
+	/*
+	 * To avoid many getenv() we'll use an initialization static flag, so
+	 * we only read once.
+	 */
+	static bool	enabled = false;
+	static bool	read_env = false;
+	static uint32_t	deterministic_seed = 0x53454544; /* SEED */
+	char		*seed_env;
+
+	if (!read_env) {
+		read_env = true;
+		seed_env = getenv("DETERMINISTIC_SEED");
+		if (seed_env && strcmp(seed_env, "1") == 0)
+			enabled = true;
+	}
+
+	/*
+	 * This will happen only if we successfully read DETERMINISTIC_SEED=1.
+	 */
+	if (read_env && enabled) {
+		*result = deterministic_seed;
+
+		return true;
+	}
+
+	/*
+	 * We initialized but had no DETERMINISTIC_SEED=1 in env so we fall
+	 * back to regular behaviour.
+	 */
+	return false;
+}
+
 #ifdef HAVE_GETRANDOM_NONBLOCK
 uint32_t
 get_random_u32(void)
@@ -522,6 +629,13 @@ get_random_u32(void)
 	uint32_t	ret;
 	ssize_t		sz;
 
+	/*
+	 * Check for DETERMINISTIC_SEED in environment, it means we're
+	 * creating a reproducible filesystem.
+	 * If it fails, fall back to returning getrandom() like we used to do.
+	 */
+	if (get_deterministic_seed(&ret))
+		return ret;
 	/*
 	 * Try to extract a u32 of randomness from /dev/urandom.  If that
 	 * fails, fall back to returning zero like we used to do.
-- 
2.51.2

