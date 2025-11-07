Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E1832E698
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531992; cv=none; b=mdPIPtf0hzMBjs2r9T2UB/kouvpL/5O/4mWo9jd7VtcaNYIn8xtl3Z9Hk/BcCj4HJQp6dtGLxFfUS1WTy9TI9IfvwS08X78SL+pbFZI52OO4jtAdydzEvnBWN1weyBjAJx+KChC631CRjVSumvBO3Xdj7ZBN7kj1G4zrx6wwO7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531992; c=relaxed/simple;
	bh=RbD5AOknNCy6fsTHYYGpQONhpu6qZwT/M3DPbARm4Do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xz7quQ06FXdLoMrPRDA7kziB226HlmPsqlSy31/5s4v7GulFJtK5GRLSwE/+GG6uFuDI1cw8PAde4eTpU3+84GfsG3tzdmcWRWoXUwN7CSmKt6+dvqvPC+UHtr0xSeLkl2Nm+9C7O1OMpnLdSPr2r9TL3PnbSFe/g4yRI1G2Ev4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHFTPSz5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHFTPSz5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477549b3082so8547745e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 07 Nov 2025 08:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762531989; x=1763136789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RHBsu69REYgsl1PTXN6kWmotjqmFqCf8rgDGkUecODw=;
        b=VHFTPSz5JpnNUkYIp+b//mUxaS2hrzKlpLLrKN4b8mHVF0LRXEidQFwVRJLwUX89j5
         tKqUNMjjWl5lsmiQACSxDtBqW8HmjVCutist7cYI0s2KBPtq75uK47VuB6vwDzKgTb4q
         sNyhiqi+yfwZ5IZ87ry9U1X1dyAjsbucyvJ2IZKHYbwihkp+gIeax8S1EQOMBdmrKpu+
         y5QWGehxnTgsf0B2zRwfesXMLLcbue52Vkd6vnVEbuA8G4wfsgNFSO7JZjKhYHejYCBy
         hUZsJTXflbEkojdXpA+uAYXYh9GN+Z08kdIjxvwvFwg/Hqp0T66avpWmOVutw7rJxBPZ
         yEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762531989; x=1763136789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHBsu69REYgsl1PTXN6kWmotjqmFqCf8rgDGkUecODw=;
        b=wpI4BTci6YFe9KjAGH1EYkAe0/tUfhO46P0Czg7Bz/xkUj/IcnkD8Ux8I1WAxz0OhN
         l0qY5rZpiOLBdnpZwqmzDpDyHKLZFb9kggDxuiRAdZSsg224YSqDpHjwIIqmSJBpHzKh
         /6wQ1lmP2AS6zviV4fj15Or1ICAyP8hB4Hs4V6aRzMz4OdgRKgc5JxG0wqyeuIP0Ri0B
         LZs+JFLknBDp4pcEvjAc8ad/ArbxCyidAiS/pnfQTBDjr8/SoWElNJz28ZLzpONiN7ca
         44+fo4YqMOQGo64CA7He7C6D3LzCQ2DuPNS843JNe6EO5WPxMc8Jr/dYOSK+zE2UMR3w
         w0hA==
X-Gm-Message-State: AOJu0YyRb54TBZ1oL/2+gl3ZvfC/1l6YhyqGss7W9/2Fu0iOOSDTIF0h
	aSUaSdLlnGn0eIUZBy5D7M4zUL6zASwqz3re7v3MBI4gfo4YCStm76I3JwgqxQ==
X-Gm-Gg: ASbGncvw60WznbKRQOWIS/FFI1iNGzkrdyldi+1avqKbsT6qiAXVodEuabw8KTPMeqw
	zOJ4uKW37fgigw3JPP/FIwdhwAjPJvL6XPGPynKWA/V4fLon6OFWCE3wTXIHb1HK/EPD5+eSuZV
	WDFzTr0NiIZNIhqSFFB7aUXdaHeSF0zLURyGJBnBXeivWENvFtaYfz+6+c42TVH8XoGY/hCEjWK
	PFNmVOybf0bVr/Fv+kgIeMQnZxP+YExWBXHzVQML5rpOBQ1+W+AJnjONyrsnlQx9H+oeKw8tg02
	9o7bqPfgFm/IBIoJuiCzf7Ub+tASaPY9Gvc74U1tQELYyrCy93iLgUBpA8PQZeqJnZxI3k/WR2/
	wX6CD3s4twJiSLZLdh5dKg56p6unqvjmhwrcZaWp2uMF3t1gmcQJQPa1pQ5+cmEWLWXERI2RuUE
	uKYbiu8jwyqsLdqe8oSc8q/xUEPX5wY5d30Pv5KhhHKmrAcmvsC5Ar7RCCbL7KrB1h/fB6tLg=
X-Google-Smtp-Source: AGHT+IHiT9XObCZKc93JNVeyXw5KYCk63lfs7dxPqCYb+gM4YTxH4Ad76iMrvRPzJ5ZzeCE6vyDtaA==
X-Received: by 2002:a05:600c:3b1a:b0:46e:5b74:4858 with SMTP id 5b1f17b1804b1-4776bc90879mr28710205e9.13.1762531988753;
        Fri, 07 Nov 2025 08:13:08 -0800 (PST)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763dc2b8asm50092145e9.2.2025.11.07.08.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 08:13:08 -0800 (PST)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v1] libxfs: support reproducible filesystems using deterministic time/seed
Date: Fri,  7 Nov 2025 17:12:41 +0100
Message-ID: <20251107161242.3659615-1-luca.dimaio1@gmail.com>
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
When DETERMINISTIC_SEED is set, use it to generate deterministic values
from get_random_u32() instead of reading from /dev/urandom. This ensures
that UUIDs, and other randomly-selected values are consistent across builds.

The implementation introduces two helper functions to minimize changes
to existing code:

- current_fixed_time(): Helper that parses and caches SOURCE_DATE_EPOCH.
  Returns fixed timestamp when set, with fallback on parse errors.
- get_msws_prng_32(): Helper implementing Middle Square Weyl Sequence PRNG.
  Uses DETERMINISTIC_SEED to generate deterministic pseudo-random sequence.
  Accepts decimal/hex/octal values via base-0 parsing.
- Both helpers use one-time initialization to avoid repeated getenv() calls.
- Both quickly exit and noop if environment is not set or has invalid
  variables, falling back to original behaviour.

Example usage:
  SOURCE_DATE_EPOCH=1234567890 \
  DETERMINISTIC_SEED=0xDEADBEEF \
  mkfs.xfs \
	-m uuid=$EXAMPLE_UUID \
	-p file=./rootfs \
	disk1.img

This enables distributions and build systems to create bit-for-bit
identical XFS filesystems when needed for verification and debugging.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 libxfs/util.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/libxfs/util.c b/libxfs/util.c
index 3597850d..676da81b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -137,12 +137,69 @@ xfs_log_calc_unit_res(
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
+	static bool		read_env = false;
+	static time64_t		epoch = -1;
+	char			*source_date_epoch;
+
+	if (!read_env) {
+		read_env = true;
+		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
+		if (source_date_epoch && source_date_epoch[0] != '\0') {
+			errno = 0;
+			epoch = strtoul(source_date_epoch, NULL, 10);
+			if (errno != 0) {
+				epoch = -1;
+				return false;
+			}
+		}
+	}
+
+	/*
+	 * This will happen only if we successfully read a valid
+	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
+	 */
+	if (read_env && epoch >= 0) {
+		tv->tv_sec = (time_t)epoch;
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
@@ -515,6 +572,72 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
 
+/*
+ * get_msws_prng_32() tries to detect if DETERMINISTIC_SEED is in our
+ * environment, and set our result to a pseudo-random number instead of
+ * extracting from getrandom().
+ *
+ * Returns true on success, fail otherwise.
+ *
+ * This function uses Middle Square Weyl Sequence to create pseudo-random
+ * numbers based on our DETERMINISTIC_SEED.
+ *    Ref: https://arxiv.org/pdf/1704.00358
+ */
+bool
+get_msws_prng_32(
+	uint32_t	*result)
+{
+	/*
+	 * To avoid many getenv() we'll use an initialization static flag, so
+	 * we only read once.
+	 */
+	static bool	read_env = false;
+	/* MSWS state variables */
+	static uint64_t msws_c = 0;  /* increment (user seed) */
+	static uint64_t msws_n = 0;  /* current value */
+	static uint64_t msws_s = 0;  /* accumulator */
+	char		*seed;
+	unsigned long	deterministic_seed;
+
+	if (!read_env) {
+		read_env = true;
+		seed = getenv("DETERMINISTIC_SEED");
+		if (seed && seed[0] != '\0') {
+			errno = 0;
+			deterministic_seed = strtoul(seed, NULL, 0);
+			if (errno != 0)
+				return false;
+
+			/*
+			 * In this variation or MSWS we will use
+			 * DETERMINISTIC_SEED as our odd number in the formula,
+			 * so we will need to ensure it is odd.
+			 */
+			msws_c = deterministic_seed | 1;
+		}
+	}
+
+	/*
+	 * This will happen only if we successfully read a valid
+	 * DETERMINISTIC_SEED and properly initiated the sequence.
+	 */
+	if (read_env && msws_c != 0) {
+		msws_n *= msws_n;
+		msws_s += msws_c;
+		msws_n += msws_s;
+		msws_n = (msws_n >> 32) | (msws_n << 32);
+		*result = (uint32_t)msws_n;
+
+		return true;
+	}
+
+	/*
+	 * We initialized but had no valid DETERMINISTIC_SEED so we fall back
+	 * to regular behaviour.
+	 */
+	return false;
+}
+
 #ifdef HAVE_GETRANDOM_NONBLOCK
 uint32_t
 get_random_u32(void)
@@ -522,6 +645,15 @@ get_random_u32(void)
 	uint32_t	ret;
 	ssize_t		sz;
 
+	/*
+	* Check if we're creating a reproducible filesystem.
+	* In this case we try to parse our DETERMINISTIC_SEED from environment
+	* and use a pseudorandom number generator.
+	* If it fails, fall back to returning getrandom()
+	* like we used to do.
+	*/
+	if (get_msws_prng_32(&ret))
+		return ret;
 	/*
 	 * Try to extract a u32 of randomness from /dev/urandom.  If that
 	 * fails, fall back to returning zero like we used to do.
-- 
2.51.2

