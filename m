Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF6E4501E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100614; cv=none; b=TEltkzZWQjfgOvvlLwbvUyvxeA+XgtAiMLnzMqt/iOMVVt0p/XiFj8yt/lZPn+p7wcovwnrY40n5SlZgLZYp7g/X1DOJ+2DBZDTVWytO54xRm0HxOHIy/nzCTu/bbNAH+qdm9LoNm52Uw2OIK4JnpKcsdbK0aB9mfLaGhQOj8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100614; c=relaxed/simple;
	bh=E/bt0dYN2lL6WZn+qlaB9pYAPVKC4Kaf1XvTNzArXbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm4xYUmsp1EDsLiazgQaEnJQtkn3FMc7nABx112c1otBiK7wk3PJDCziZ4qzi6RN7HFH6qxnyLreuxLiT93wDY4Fs4X2Ed3NfqBYQk4E76eVlksLz03m2D+9Ahy6sGqdfLbiWUSiFWAdrGJ9EforN27hPyoVDI9OUXR5npoT1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dnZNPhbz; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dnZNPhbz"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6b6f86975so3853750b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100612; x=1712705412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/OfCM3oMmWggl87qX9Ta7RIE7Sy0f8S+C87ULKf1Ey0=;
        b=dnZNPhbzXj/8vwcGirRMaWGbbRR0rMwoLTPsmdMJYLJkR4cdQaf0qCA3j/27awmYBO
         XH/sjKQyqNhzno1wUU0//xGW3GgAvxYNPEiJTXkACM6qZoG41iDV5vpoQcKaEQLdHbLD
         6VLXed9Y1+ch5Nc9z+/Gw3TSeo3dqdOxJO7leDDCm+ZeBsgQtKb290+ZCKpRe8upHgPf
         kPKqmu4CNdyL2aJ626K31eEOHrOQMiMshWA0+QDNx73CmYeed0xbqUUfj7g2hgYbrSqm
         y7yErZXwr95gXGiekEKnkAeUI0x0KtT2tPkF5sUY5pzzbjLa/48phOSyaQzl3UjFJn33
         wlEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100612; x=1712705412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OfCM3oMmWggl87qX9Ta7RIE7Sy0f8S+C87ULKf1Ey0=;
        b=NH1Mt8U7AXGMeif9vn2jJv+RDQmClUB4LFRr8LY3hXPWMnCdwcPFV4GKIlEPc54QsI
         w59wFHr9pWoo6KVAKhHzNYUSz45C/lBvseUv6iXx6kR7pbBTcAMEBs6A+LR8gOjuo+i8
         tBlbWm8sdnwaGj5NJ3CiT/jCN4uGtCxN1yugMdUPp1n7GsbtpyLdzK+y0gzeeJZqLLsx
         JbmasLOvSrBWSRqVe5vIgXYy3NuC51f/7qgcfSOOu3wKmhV1n3/FZH1qTQYpUcxdIFod
         5kdKKDSr7zkFdv1qBHtRk/OiaZe5pY/k1Kp35fRIyS7z6nUC1ELEiJAC+ePqGeG2Xd4c
         olMA==
X-Gm-Message-State: AOJu0YyU/39xvPc6WLRQvhPlC9eLGCcew4V38lLoO6fXof1oRmSgnG6r
	IsBJkH6MAz8Ymj72M53uKNR2/h6g+IpyWPsvgngTbWj69TT/u4QLhDqQxyE3eLiB+7fUYgbHrc4
	k
X-Google-Smtp-Source: AGHT+IGSEJIjRZnXmCTUNtbdAilFdpBYVQSuJk60/QEhO+m+cJ39z3cVGq7x9XgrHkd3vg89HaSbWA==
X-Received: by 2002:a05:6a00:3d0f:b0:6e7:6b57:d92e with SMTP id lo15-20020a056a003d0f00b006e76b57d92emr1283422pfb.28.1712100611606;
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id k14-20020aa790ce000000b006e319d8c752sm10451745pfk.150.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001sy6-1l;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZx-000000054rB-0EdZ;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 1/5] xfs: only allow minlen allocations when near ENOSPC
Date: Wed,  3 Apr 2024 10:28:40 +1100
Message-ID: <20240402233006.1210262-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
References: <20240402233006.1210262-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When we are near ENOSPC and don't have enough free
space for an args->maxlen allocation, xfs_alloc_space_available()
will trim args->maxlen to equal the available space. However, this
function has only checked that there is enough contiguous free space
for an aligned args->minlen allocation to succeed. Hence there is no
guarantee that an args->maxlen allocation will succeed, nor that the
available space will allow for correct alignment of an args->maxlen
allocation.

Further, by trimming args->maxlen arbitrarily, it breaks an
assumption made in xfs_alloc_fix_len() that if the caller wants
aligned allocation, then args->maxlen will be set to an aligned
value. It then skips the tail alignment and so we end up with
extents that aren't aligned to extent size hint boundaries as we
approach ENOSPC.

To avoid this problem, don't reduce args->maxlen by some random,
arbitrary amount. If args->maxlen is too large for the available
space, reduce the allocation to a minlen allocation as we know we
have contiguous free space available for this to succeed and always
be correctly aligned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9da52e92172a..215265e0f68f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2411,14 +2411,23 @@ xfs_alloc_space_available(
 	if (available < (int)max(args->total, alloc_len))
 		return false;
 
+	if (flags & XFS_ALLOC_FLAG_CHECK)
+		return true;
+
 	/*
-	 * Clamp maxlen to the amount of free space available for the actual
-	 * extent allocation.
+	 * If we can't do a maxlen allocation, then we must reduce the size of
+	 * the allocation to match the available free space. We know how big
+	 * the largest contiguous free space we can allocate is, so that's our
+	 * upper bound. However, we don't exaclty know what alignment/size
+	 * constraints have been placed on the allocation, so we can't
+	 * arbitrarily select some new max size. Hence make this a minlen
+	 * allocation as we know that will definitely succeed and match the
+	 * callers alignment constraints.
 	 */
-	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
-		args->maxlen = available;
+	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;
+	if (longest < alloc_len) {
+		args->maxlen = args->minlen;
 		ASSERT(args->maxlen > 0);
-		ASSERT(args->maxlen >= args->minlen);
 	}
 
 	return true;
-- 
2.43.0

