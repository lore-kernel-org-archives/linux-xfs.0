Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD57B3264DA
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 03:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802158; cv=none; b=TqVPiHayAT6HSRANFBTeBRwceoszd3r1B1WBM1VwXRSodmnSgRX69xFGdgOv4tz66sc0XsCf+qP1nsy27nyxOK5dmN01EPUb1jtDMdLODQsUy/SLuQ0h+zXNl+Z1YUuuXKn0SpcqaOBmK+LKvNtdpWZrpWTS08HAalXrcHApJY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802158; c=relaxed/simple;
	bh=JGueF19DVKzmmwNZeLV81gI+8Zi1lm+VPm00pJ6kDZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TnoGFx2x7AYNhyPCyxfb9t8jiSCxZ4EloyW+Tysakw2LHA9OxqUNQ00En3cXV2V4hPf9LxoOBVlYk3S91acPiFyz9ScoMZIh6jlADtpozHe4I30/uJXI9fiXOoeGZxnmrpHeSDN6My74thIalpchWOgzi0Qpd/m2DylA9j0EbJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbW2gK+v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cXyMBd65; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbW2gK+v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cXyMBd65"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787802155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0vsox870M8LvdEPMy8zs8xmkRCgX6z9C4ItjKlbyY08=;
	b=gbW2gK+vBOxdQp4y/sE5k1CXMiJl9mPGduyh6gjo52mXs6w16yVkNt4BlS6gPRs7oTxQGm
	KQY9EHnzmc2zvfQQIDTqB0W2oRdb+wGSGnaqECNYsYGVIH4FW4gvi399C4KqUh/9Qyinn5
	apTDIcrB8bP70H+e5HDjUgzkBwoV9W0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-loMCsyvBPnasTqNl0roFGA-1; Wed, 26 Aug 2026 23:42:33 -0400
X-MC-Unique: loMCsyvBPnasTqNl0roFGA-1
X-Mimecast-MFC-AGG-ID: loMCsyvBPnasTqNl0roFGA_1787802153
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f73d0f89so24410035ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 20:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787802153; x=1788406953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0vsox870M8LvdEPMy8zs8xmkRCgX6z9C4ItjKlbyY08=;
        b=cXyMBd65uEGQvNcjpIAzi7mbSL6/YhK39QjkaqRm8959GODxVhMtNNC37d1k6GczQ+
         iIiZX+7P98flpiH4U3AycwYwcm+pr43i2OB0Kk8XRuOR856CCLgQf33bqsyf1VdKMVgU
         RxKt6jCgttrLW3Sfnexb2ys7ETyrK9FCFSZi8RcXcRf2HwxAjQn8bdtsbadO59y8SlBM
         rnQHPPLPBp3GfIQ3Jd0/qAH123RGkvT5bu/bNpecwNq5Yodr9tjdxYQc+F4ghYL4iK6D
         +nArtPJftqzc6Mwqb1gmNGrvulujL0tu0iyl33GVwCs+p2LdWSo4GWocEcKGm7smkimh
         UoyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802153; x=1788406953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0vsox870M8LvdEPMy8zs8xmkRCgX6z9C4ItjKlbyY08=;
        b=RPY//dO0AWqHmkuboDWkLumnB4U7z2Kiui2LcbmDwnooiX9i3M77go4J8wtMXII4v3
         NV5S9guvpeHbH+OnUzSDW+ovJB/A/MZ06LEyhq353Dg+r0Prz2rqLimE5FrQdfe4hSRO
         jpw5oVUaJ2lsnYSlY3hmtKQ/XM1ONYQ1iPtg5GNPJZjCSglW4hAuSev81s7UaJdo8Oki
         uPuKzENup7uTvlLP21L0W+hwMNpGWvSgu3u8W8qTw/zHppnYf/fNZiZSnALDR+aoqyWE
         PE48v7TLZJ7sH6uK/Iv6KWyqsVajMXrCK0yJ4J0r6pLcCafzMztKQlYqceU4re4OOvBq
         qvkA==
X-Gm-Message-State: AFuF++khIHGIDeQ/TGnpvuFlCgZEdOstlWhOmTG+mnvBWqMHFfRR4IP7
	JXIRXkDcq235nEzi98iUZ9J3+p05w5Irr5gG89N/j4bWVYJeV8oAuDV/5rA7QMYH8zgZy1hJVey
	9TKNSNDpk07LenImV8jyfTplB2/SB5eSuJJht+yQLjacLP6mzNuMxuWEqwPkM7FcmOsFI5Fjc5k
	J1ostIgdHvBltW9HJpCnt9aFl6zHNT/ihnfOjmlzFMmiOFVnk=
X-Gm-Gg: AR+sD11adFKooX73DWNFOIMqsqPB7NAnRiUWacoz6QcugCLAe6vc+gs14OHYV5yHIyf
	l8PBkFYAWwvnWmjFBrTJb3bE/bFmuUzyASilH8keK5Ko/IV+Ux6/jAW+kcNRIAtzrWhWfaJNT2W
	0AnAFVamWRQmjjb7haiRouLV4IMDLPWTEZ6PUiLnS5SG1Vf6pew5uzHveO68KjW0pASlqzFsJGt
	SdV5q3u++4W1GO1wIxGQ+8uD39LzltO0yBCOZ/1sO8HAjyCVuL3F8cfDxOyuKz/JkOJJ/6i8EVP
	0o3TF8t+nOJfc+SEOsysF6SCEWQwZk7U5BbrKiP2BvJVEJCSs2zW0zVddBl4QRoNEbf6TBuFnKO
	uJzT6L+yBETwC8kUVoTYEL/N8zOsI6LJVBwJYt1locxA=
X-Received: by 2002:a17:903:1a0d:b0:2d0:8b28:51ab with SMTP id d9443c01a7336-2d707ad0d63mr225953275ad.7.1787802152614;
        Wed, 26 Aug 2026 20:42:32 -0700 (PDT)
X-Received: by 2002:a17:903:1a0d:b0:2d0:8b28:51ab with SMTP id d9443c01a7336-2d707ad0d63mr225952505ad.7.1787802152010;
        Wed, 26 Aug 2026 20:42:32 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d70493fc43sm13223725ad.10.2026.08.26.20.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 20:42:31 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs: Emit a clearer message if too-small log is due to AG geometry
Date: Wed, 26 Aug 2026 22:42:28 -0500
Message-ID: <20260827034228.938740-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a constraint in mkfs.xfs that logs must not be smaller than
64MiB. We can arrive at a too-small log without specifying its size,
though, if we specify so many AGs (or such small AGs) that a single
AG cannot hold the minimum-sized log. This leads to confusing output:

$ truncate --size=500m testfile
$ mkfs.xfs -dagcount=10 testfile
Log size must be at least 64MiB.
Usage: mkfs.xfs
...

because the user did not specify the log size at all! If this error
occurs due to the AG geometry specification, make that clear with a
better error message.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/xfs_mkfs.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a4864c37..0c72422c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3456,8 +3456,25 @@ validate_supported(
 	 */
 	if (mp->m_sb.sb_logblocks <
 			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
-		fprintf(stderr,
+		/*
+		 * An internal log must fit within a single allocation group.
+		 * If the user constrained the AG geometry but didn't ask for a
+		 * specific log size, the undersized log is a consequence of
+		 * allocation groups that are too small, not a log size the user
+		 * chose.  Point them at the real cause.
+		 */
+		if (!cli_opt_set(&lopts, L_SIZE) &&
+		    (cli_opt_set(&dopts, D_AGCOUNT) ||
+		     cli_opt_set(&dopts, D_AGSIZE))) {
+			fprintf(stderr,
+ _("Allocation group size (%lld MiB) is too small to hold the minimum 64MiB log.\n"
+   "Specify fewer or larger allocation groups, or use a larger data device.\n"),
+				((long long)mp->m_sb.sb_agblocks <<
+					mp->m_sb.sb_blocklog) >> 20);
+		} else {
+			fprintf(stderr,
  _("Log size must be at least 64MiB.\n"));
+		}
 		usage();
 	}
 
-- 
2.55.0

