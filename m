Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77835E953
	for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2026 03:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787888234; cv=none; b=bCDc6CgBAvZDmbl3WCQXJYY4UTAI2evoujn0WMuzXQMamZGKoKcrrfyo3H+rGrWB6hgPzZtLqEGnjfI6HQ8/ALZSSJmZr12jaRjjRgXDGZb7wiPbKxRFFCUz0o5lIhF1frjZS837/5aVAO9PtEMFSOqW10csU4wv70RSSTD6h/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787888234; c=relaxed/simple;
	bh=f7WV+5JRBH7+b0h8Wle29pWQgflTwoQSptZTR/oRVxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qdt4lQqoSeehUmVtjz0SblRkgBmrcDhakAXGopbDORTAjlgIVGGIcJtRhg8sNf+/NHwGZeJa2Ojcrnl8vEcWyw/XZ0HvuQ0A/fJzNu+tlFnXStPV0CGAUaQAzpGddKh/ZSdvADrsh3NSb0pchGFr2xt3/JaQBwLqBEaJq+aBc5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuP09Cxz; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuP09Cxz"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38759bcd877so504791a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 20:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787888231; x=1788493031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kClGC4Q1h2cpbmXDDO/Cni49gBRV6utUcLJ4NZAQIpg=;
        b=LuP09CxzqBR29isgye+UoveYCFTy74KRZ1sqIa/08LoLaEZuPjWySDU3+kCgabR6rs
         IZkppA+P7n04T0+ZyWFnyV7dGuqqxFnOU4/SDS63IZdkGWZ9vqFffDi7STtBciD4lpVe
         gt/CHzNZxC8d3ErFZDFt0BQBebjRzW+NJycPAX//FYAfC7dRABmP+4gLMAqGE9BYM48v
         dmJLl96jyqF5TJVCAL/6XlmHECChzxkN7mN1hNSqzWndZmlzGBHdQo2Lj/gzsb8a+zxN
         lrEoPoDhc0pOncRC0GGH8Z22Y6SJangjt5yN8fccVqhK4SfXYwYsbfQ1TPnsjX5a6z44
         mU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888231; x=1788493031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kClGC4Q1h2cpbmXDDO/Cni49gBRV6utUcLJ4NZAQIpg=;
        b=dtw1S0/TSUt+BMVFCm22kWiVnibDwO/Uty76lq2ydUUw8UGUQe8icXaFxQUkBGP3+X
         12uXPviCyQb3Hg/8CRrTGF5FSGwvsqtUavn63/YPEZwOhufNlOEM5b/xB/j41ur1qiAx
         +RDDz4Vou6FCSjIJ9BZDhKQGgoLT3eobadIexnZlTPP2JnaQmFBOEfAvIokFiVWjfh9H
         sBWQXAt3BC2K4oKT/l6DaRizHattjp/39tIWsr25IQ31nMKq8dZQxIzLvb92NKrsU+c8
         4t2eAm3P4ROeoLzc1a1lcrVHHB7axE7sP63WRaTIIvGxzWAbK14Bh8gyhMnk/Vg/RBA8
         2yfQ==
X-Forwarded-Encrypted: i=1; AHgh+RpV6QrSc2TX1JGb/XutArPbrSByAFQZqywhWKlGxUTYTeTRcWOPnNhqPH7wpWj9Ji4GZX6mHqBSLvQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lZB2FTC4t376NX2PIivj2yBtOFC03GWIn5PGTj0eSkDtN9Z4ja
	Q1rgTqEGHxNYyb+u3BwQmjyjfwJ0iuCJRv7btMYFHK83sw0f3XRTafLDapmWMQ==
X-Gm-Gg: AR+sD117LpB43sCCgq9kMNd6gMpkkETU/TXy1yxvzhoU1dZZvvGQwlropOn1ufb00SP
	HROxa7Au88QP50e5PjsO32pMKvYbola1eIZRoKZmPsqKN1E4BsOdZpRqaExyzLkR9YtvI6AuEHh
	kGJ6NXwmWFE3ikcA95Dfsj7kF7KlGk3+R8qV1vSk5t2D9ft3JLG26U1w/FH9JdkP2il2CXXW/2h
	zEpRyC8RIjzwnAUM7961Gy+X1fciCbwpzzgZZwE+1Ikvoqef5FEZFVMj46cJJAGdhYgClAKTTh8
	y3HTXGhFjVMO5XhCbiS0Y+4dVgPBm9Y4uZrWHqYElzLbQvAo2np8cR2YWqM27/mREM4oC5TgUu9
	fdvYtyvfHimGHvIiMVPYZfHKX2HaPQHPsxAix1pJFHOc6bhvqHP3TjKTm/h9tYCmeRXeoYQlsOx
	jBwFx9k9Albyz68Goy7zgIp3V1ahSV5hpAYZDJp1v7F2vSyVIYgLegg52Qv16wkbER/eB45rT+n
	qdSIT6dog0hZRrvTagt5JiH4iVthyaHp7M/A+zz3swz1A==
X-Received: by 2002:a17:90b:2886:b0:396:4729:43fa with SMTP id 98e67ed59e1d1-396d0bfc429mr9095264a91.0.1787888231214;
        Thu, 27 Aug 2026 20:37:11 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992435sm5589943a91.13.2026.08.27.20.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 20:37:10 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Peterson <eric.peterson@hpe.com>
Subject: [PATCH] xfs: add per-mount read/write I/O completion counters
Date: Thu, 27 Aug 2026 21:34:29 -0600
Message-Id: <20260828033429.4070267-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
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

The counters are plain monotonic increments (no clock reads), so they
add negligible cost to the read/write path. Per-op timestamping was
deliberately not used: a clock read on the hot path costs ~20-30 ns on
TSC but hundreds of ns to ~1 us on HPET, which would be a regression for
general users. Queue depth from completion counters is an approximation
(instantaneous depth); this is a deliberate design choice, not
a placeholder.

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
ops for reads). This matches the existing read-byte semantics.

The counters are uint32_t and wrap like the existing xs_*_calls
counters; userspace diffs handle wrap.

The per-mount stats file gains a new appended "rwcmpl" line printing
write and read completions. The existing "rw" line is unchanged, so
positional parsers of "rw" are unaffected:

  rw     <write_calls>       <read_calls>
  rwcmpl <write_completions> <read_completions>

Signed-off-by: Eric Peterson <eric.peterson@hpe.com>
---

Notes for reviewers (not part of the commit log):

* Placement: the new "rwcmpl" group is inserted between "rw" and
  "attr" in the xstats[] table. The "rw" line itself is unchanged,
  and "rwcmpl" is appended after it, but lines below "rw" in
  /proc/fs/xfs/stat shift by one for strictly positional parsers. I
  can instead append the group at the END of the table if preferred.

* checkpatch --strict reports two CHECKs preferring u32 over uint32_t
  for the new fields. They are kept as uint32_t to match struct
  __xfsstats, whose every field is uint32_t; changing only these two
  would break local consistency.

* Testing: fstests -g auto on v6.12.74 shows baseline and patched
  fail the identical 6/1277 tests -- zero regressions. The rwcmpl
  interface was verified on hardware (rw >= rwcmpl, counters
  advance under load). This for-next port applies cleanly with no
  drift and compiles clean; a runtime -g quick smoke on for-next was
  omitted as the logic is identical to the tested v6.12.74 patch.
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

