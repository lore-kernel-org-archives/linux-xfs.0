Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D6D339390
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 04:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788323255; cv=none; b=AaYT0ELyzVr4JUZwVT/Aaigj7LXX8ft619YUsXa3UsKw07VW8nY9IHbJF4tLqE+VUqx7W+je9T8Rb3F0A59K9UZgONgT7x1Yre2SpPrpFkXQ56LOe869MsBMhKfZp8CftGuqSPtnTSiDzA60X0mHDFZG288ZQINDILoM9QgcMvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788323255; c=relaxed/simple;
	bh=+0aKnwE0cYb8LEDeXlWtDjpQ2NsO17mZ5j+Abdva+cQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UHB5knHo94Buv4Yy+6PaM4eiZQKV5cdRk5ogNL3D5UcMepyqdaFTsFmSnDPjcjTreo3KcN1CTYXo6ZACuP041zvpuvA4om2Hz0sTr7JcdpHoxCRBYfF2gzm7IBaQ7lDDINqDfmRzVAA9f6mWA877bs4R+z7Dqz+kqe0ZrVJtON8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQh4M3e1; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQh4M3e1"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-85c9a79590aso736009b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2026 21:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788323253; x=1788928053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pDFz9QgN63ldT/xXJR2rd56NWcctZLpsj24mvleysac=;
        b=nQh4M3e19+3NaVZsOBkkL1Le2QukzP4NS2vz/ODzuSsDOQYedlC4/envKns4SbLr9t
         wL9KdXpdOaxSVdt8Bshu4e41Eb/H/yznSSFle5Gtogs8o5g5wucAYToUGCxD6p9lFQJF
         wU5otZE6DPGRZRY2tiOzfeJwUNIKfFN8wXHQ51nf4tnRGncrMXx8lejLCvwSQJg3njsI
         csWvymsz3c38jJafSoFgKVK7oB2dV2asmo3RuNJoP+ULusZCTCGo+uPNu9t2n2MQTlFa
         utdPc/9h9Q5Mp2La11YVKj907Z1pXBxwC4wKWapNIqGnO35bT1cD5cd01Pg5Z4bCd0PY
         laSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788323253; x=1788928053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pDFz9QgN63ldT/xXJR2rd56NWcctZLpsj24mvleysac=;
        b=lT6lL0QRE7M8HXaDMPM54w8iQkI7FqmGveAqwBcjLF84qiospQqFNYGHDX+t9Aizyy
         dSdKOcHChvhE4NsgXU0r10DtftWCtrYGC97z0qafq7qGyOBvsv69CDO3tJoXR5dw89ZK
         e3AXAlHUxXa5d3wegA/ZHc7TqckCRmTX/r0dojbCzlYdleTYmmT28ZVkvrAUvTiPKvxQ
         bww4RgSMGK004gRkGLzYUX41i0uBQVT/1qdoptdNKwlcCf0x8ZOd1QUDH9idTW6QSDwp
         cq12Tyzrf8j1XeQKpcgxHHtnvxrGep1uKEBu94Z+9Ncc83eoUT4AvU/feD5mEsnmVVNL
         GQ+w==
X-Forwarded-Encrypted: i=1; AKwUvBzltvmRu4bwupRipTiC+B+vn6nK7Oj0R2zbTZxtoMlv1I/raO8CJ0fYvfbgM3DKEso/Qd/dKrBY6dI=@vger.kernel.org
X-Gm-Message-State: AFuF++lmXhJ4JxtVA63HA9pq2s/VI1nrtXMo5AFnUHXkqNXerd49OFK2
	0xjbX2BksiSPMkvhJn4rYmvJOqVeyqkf2m7RiIcZbxLSy7hGXSyui2Fj
X-Gm-Gg: AYBFou0op00Ii/l0ySX7wU9VAHuWYYqMytC0T8Rtdq4Fnaa+oMOdUOwh37nkUW1UuRy
	MDS5UQBDwnon8QUH+5od9T2RJf/JZjRgFy1ck9mM5o7koxvNgcoY4K/q46oDgjCzU19RKovr5QS
	v/y2/JwHD6O7kdWCstEmji+L+fI9D3gPk+wJsbHrd8KRXGegp822rq7P30nzfMKloAQ4iSQIYYk
	dZrxZPsP1qnU+of9FkuJpxInF6gbkJSKwBqaQDCpnhauqv9MWxga1ZE32b+y5vsiz5/1B5HB8CW
	CXjRnnkYucm9TPA+5LMccn0IGe3eFm9Yf+v8qH75OrNnwrGYIv2rsAYfC2nMjYjnwLUAF+0Y34Z
	y6n15i+5NSlKkrCZmqyeKdugGS4UbTX7wGnxB+Je3PwOjTol5MVCQ4b8KdcNTkq9EE/e+aQtSdd
	Qbxh0jwIzADkvD9HzXUbTYBEdDGBsArJgnQu1tHApzMU46qqxUYTw9izZR7jVG8WYRgS+67bbew
	YG3iYA5xHw9XPLE8bvtl9BFYS+WmzAeU2Fsa2mCc5S39Q==
X-Received: by 2002:a05:6a00:4287:b0:857:7337:5db5 with SMTP id d2e1a72fcca58-85ed98b4d7amr4377515b3a.19.1788323253266;
        Tue, 01 Sep 2026 21:27:33 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85dc071665dsm699841b3a.40.2026.09.01.21.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 21:27:32 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Dave Chinner <dgc@kernel.org>,
	linux-kernel@vger.kernel.org,
	eric.peterson@hpe.com
Subject: [PATCH v2] xfs: add per-mount read/write I/O completion counters
Date: Tue,  1 Sep 2026 22:25:39 -0600
Message-Id: <20260902042539.4073566-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <apUh22V-i99HtgGN@andromeda.toxiclabs.cc>
References: <apUh22V-i99HtgGN@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Peterson <eric.peterson@hpe.com>

Add two per-mount statistics counters, xs_read_completions and
xs_write_completions, to complement the existing xs_read_calls and
xs_write_calls counters. The existing counters count I/O submissions
(entries); the new counters count I/O completions. The pair (calls,
completions) lets a consumer compute outstanding I/O as a queue depth
(calls - completions) and, via Little's law, derive an approximate
response time in userspace without any hot-path timestamping.

Block device stats expose device queue depth, but that is a different
quantity from filesystem outstanding I/O. There are cases where the
filesystem queue depth is not what the block layer sees:

1. Cache hits never reach the block layer. Under a heavy read workload
   with a warm cache, a large share of ops are serviced from the page
   cache and are never seen at the block level. Device queue depth can
   sit near zero while the filesystem is servicing a very high op rate.

2. Filesystem ops don't map 1:1 to block I/O. A single read or write can
   produce one block I/O, several (metadata, readahead, writeback
   coalescing), or none at all. So device queue depth isn't the
   filesystem's outstanding-operation count.

3. Work can be outstanding inside the filesystem before any block I/O is
   issued - waiting on locks, log space/reservation, delalloc, etc.
   Such I/O has entered the filesystem but is invisible at the bdev.

The counters are plain monotonic increments (no clock reads), so they
add negligible cost to the read/write path. Per-op timestamping was
deliberately not used: a clock read on the hot path costs ~20-30 ns on
TSC but hundreds of ns to ~1 us on HPET, which would be a regression for
general users. Queue depth from completion counters is an approximation
(instantaneous depth, not time-weighted); this is a deliberate design
choice, not a placeholder.

Completions are accounted at exactly the same sites where XFS already
accounts the xs_*_bytes counters, so their semantics match the existing
byte counters per path:

  - Reads are counted at the frame in xfs_file_read_iter and
    xfs_file_splice_read.
  - Buffered writes are counted at the frame, i.e. when data reaches
    the page cache, mirroring how xs_write_bytes is accounted for
    buffered writes -- not at physical writeback.
  - DAX writes are counted at the frame after the synchronous
    dax_iomap_rw copy returns, mirroring xs_write_bytes for DAX.
  - Direct I/O writes are counted at true completion in
    xfs_dio_write_end_io, which is async-safe and fires for both sync
    and async DIO, mirroring xs_write_bytes for DIO.

Caveat: async O_DIRECT reads are counted at submission, not completion,
because XFS has no read end_io today (iomap_dio_rw is called with NULL
ops for reads). This matches the existing read-byte semantics. Adding a
read end_io for async-DIO-read precision is a larger change, deliberately
deferred.

The counters are uint32_t and wrap like the existing xs_*_calls
counters; userspace diffs handle wrap.

The per-mount stats file gains a new appended "rwcmpl" line printing
write and read completions. The existing "rw" line is unchanged, so
positional parsers of "rw" are unaffected:

  rw     <write_calls>       <read_calls>
  rwcmpl <write_completions> <read_completions>

Signed-off-by: Eric Peterson <eric.peterson@hpe.com>
---

v2:
- Expand the commit message with the rationale for why filesystem
  outstanding I/O differs from block-device queue depth (cache
  hits, no 1:1 op-to-block mapping, and work outstanding inside the
  filesystem before any block I/O). No code change from v1.
  (Carlos Maiolino)

Notes for reviewers (not part of the commit log):

* Placement: the new "rwcmpl" group is inserted between "rw" and
  "attr" in the xstats[] table. The "rw" line itself is unchanged,
  and "rwcmpl" is appended after it, but lines below "rw" in
  /proc/fs/xfs/stat shift by one for strictly positional parsers. I
  can instead append the group at the END of the table if preferred.

* checkpatch --strict reports two CHECKs preferring u32 over
  uint32_t for the new fields. They are kept as uint32_t to match
  struct __xfsstats, whose every field is uint32_t; changing only
  these two would break local consistency.

* Testing: fstests -g auto shows baseline and patched fail the
  identical tests -- zero regressions. The rwcmpl interface was
  verified on hardware (rw >= rwcmpl, counters advance under load).
 fs/xfs/xfs_file.c  | 11 +++++++++--
 fs/xfs/xfs_stats.c |  3 ++-
 fs/xfs/xfs_stats.h |  2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 426a67b813..3ecd4ed534 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -347,8 +347,10 @@ xfs_file_read_iter(
 	else
 		ret = xfs_file_buffered_read(iocb, to);

-	if (ret > 0)
+	if (ret > 0) {
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
+		XFS_STATS_INC(mp, xs_read_completions);
+	}
 	return ret;
 }

@@ -375,8 +377,10 @@ xfs_file_splice_read(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = filemap_splice_read(in, ppos, pipe, len, flags);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-	if (ret > 0)
+	if (ret > 0) {
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
+		XFS_STATS_INC(mp, xs_read_completions);
+	}
 	return ret;
 }

@@ -663,6 +667,7 @@ xfs_dio_write_end_io(
 	 * for it on submission.
 	 */
 	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
+	XFS_STATS_INC(ip->i_mount, xs_write_completions);

 	/*
 	 * We can allocate memory here while doing writeback on behalf of
@@ -1032,6 +1037,7 @@ xfs_file_dax_write(

 	if (ret > 0) {
 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
+		XFS_STATS_INC(ip->i_mount, xs_write_completions);

 		/* Handle various SYNC-type writes */
 		ret = generic_write_sync(iocb, ret);
@@ -1098,6 +1104,7 @@ xfs_file_buffered_write(

 	if (ret > 0) {
 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
+		XFS_STATS_INC(ip->i_mount, xs_write_completions);
 		/* Handle various SYNC-type writes */
 		ret = generic_write_sync(iocb, ret);
 	}
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index c13d600732..5b276666b6 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -40,7 +40,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "log",		xfsstats_offset(xs_try_logspace)},
 		{ "push_ail",		xfsstats_offset(xs_xstrat_quick)},
 		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
-		{ "rw",			xfsstats_offset(xs_attr_get)	},
+		{ "rw",			xfsstats_offset(xs_write_completions)	},
+		{ "rwcmpl",		xfsstats_offset(xs_attr_get)	},
 		{ "attr",		xfsstats_offset(xs_iflush_count)},
 		{ "icluster",		xfsstats_offset(xs_inodes_active) },
 		{ "vnodes",		xfsstats_offset(xb_get)		},
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 57c32b86c3..608d12d0c6 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -93,6 +93,8 @@ struct __xfsstats {
 	uint32_t		xs_xstrat_split;
 	uint32_t		xs_write_calls;
 	uint32_t		xs_read_calls;
+	uint32_t		xs_write_completions;
+	uint32_t		xs_read_completions;
 	uint32_t		xs_attr_get;
 	uint32_t		xs_attr_set;
 	uint32_t		xs_attr_remove;
-- 
2.39.5

